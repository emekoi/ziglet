//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// [~] const char* cm_get_error(void);
// [x] void cm_init(int samplerate);
// [~] void cm_set_lock(cm_EventHandler lock);
// [x] void cm_set_master_gain(double gain);
// [ ] void cm_process(cm_Int16 *dst, int len);
// [ ] cm_Source* cm_new_source(const cm_SourceInfo *info);
// [ ] cm_Source* cm_new_source_from_file(const char *filename);
// [ ] cm_Source* cm_new_source_from_mem(void *data, int size);
// [x] void cm_destroy_source(cm_Source *self);
// [x] double cm_get_length(cm_Source *self);
// [x] double cm_get_position(cm_Source *self);
// [~] int cm_get_state(cm_Source *self);
// [x] void cm_set_gain(cm_Source *self, double gain);
// [x] void cm_set_pan(cm_Source *self, double pan);
// [x] void cm_set_pitch(cm_Source *self, double pitch);
// [~] void cm_set_loop(cm_Source *self, int loop);
// [x] void cm_play(cm_Source *self);
// [x] void cm_pause(cm_Source *self);
// [x] void cm_stop(cm_Source *self);

const std = @import("std");
const Mutex = std.Mutex;
const Allocator = std.mem.Allocator;

const math = std.math;
pub const Player = @import("index.zig").Player;

const BUFFER_SIZE = 512;
const BUFFER_MASK = BUFFER_SIZE - 1;

const FX_BITS = 12;
const FX_UNIT = 1 << FX_BITS;

fn fxFromFloat(f: f32) i32 {
    return f * FX_UNIT;
}

fn fxLerp(comptime T: type, a: T, b: T, p: T) T {
    return a + (((b - a) * p) >> FX_BITS);
}

fn clamp(comptime T: type, x: T, a: T, b: T) T {
    const max = math.max(T, a, b);
    const min = math.min(T, a, b);
    if (x > max) {
        return max;
    } else if (x < min) {
        return min;
    } else {
        return x;
    }
}

pub const State = enum {
    Stopped,
    Playing,
    Paused,
};

pub const EventHandler = fn(Event)void;

pub const Event = union(enum) {
    Lock: void,
    Unlock: void,
    Rewind: void,
    Destroy: void,
    Samples: []const i16,
};


pub const SourceInfo = struct {
    handler: EventHandler,
    sample_rate: usize,
    length: usize,
};

pub const Source = struct {
    const Self = @This();

    mixer: *Mixer,
    next: ?*const Source,       // next source in list
    buffer: [BUFFER_SIZE]i16,   // internal buffer with raw stereo pcm
    handler: EventHandler,      // event handler
    sample_rate: usize,         // stream's native samplerate
    length: usize,              // stream's length in frames
    end: usize,                 // end index for the current play-through
    pub state: State,           // current state
    position: i64,              // current playhead position (fixed point)
    lgain, rgain: i32,          // left and right gain (fixed point)
    rate: usize,                // playback rate (fixed point)
    next_fill: usize,           // next frame idx where the buffer needs to be filled
    pub loop: bool,             // whether the source will loop when `end` is reached
    rewind: bool,               // whether the source will rewind before playing
    active: bool,               // whether the source is part of `sources` list
    gain: f32,                  // gain set by `setGain()`
    pan: f32,                   // pan set by `setPan()`

    fn new(mixer: *Mixer, info: SourceInfo) !*Self {
        const result = try mixer.allocator.createOne(Self);
        result.*.handler = info.handler;
        result.*.length = info.length;
        result.*.sample_rate = info.sample_rate;
        result.setGain(1.0);
        result.setPan(0.0);
        result.setPitch(1.0);
        result.setLoop(false);
        result.stop();
        return result;
    }

    fn rewindSource(self: *Self) void {
        self.handler(Event {
            .Rewind = {},
        });
        self.position = 0;
        self.rewind = false;
        self.end = self.length;
        self.next_fill = 0;
    }

    fn fillBuffer(self: *Self, offset: usize, length: usize) void {
        const start = offset;
        const end = start + length;
        self.handler(Event {
            .Samples = self.buffer[start..end],
        });
    }

    fn process(self: *Self, length: usize) void {
        const dst = self.mixer.buffer;

        // do rewind if flag is set
        if (self.rewind) {
            self.rewindSource();
        }

        // don't process if not playing
        if (self.state == State.Paused) {
            return;
        }

        // process audio
        while (length > 0) {
            // get current position frame
            const frame = self.position >> FX_BITS;

            // fill buffer if required
            if (frame + 3 >= self.next_fill) {
                self.fillBuffer((self.next_fill * 2) & BUFFER_MASK, BUFFER_SIZE / 2);
                self.next_fill = BUFFER_SIZE / 4;
            }

            // handle reaching the end of the playthrough
            if (frame >= self.end) {
                // ss streams continiously fill the raw buffer in a loop we simply
                // increment the end idx by one length and continue reading from it for
                // another play-through
                self.end = frame + self.length;
                // set state and stop processing if we're not set to loop
                if (self.loop) {
                    self.state = State.Stopped;
                    break;
                }
            }

            // work out how many frames we should process in the loop
            var n = math.min(usize, self.next_fill - 2, self.end) - frame;
            const count = blk: {
                var c = (n << FX_BITS) / self.rate;
                c = math.max(usize, c, 1);
                c = math.min(usize, c, length / 2);
                break :blk c;
            };

            length -= count * 2;

            // add audio to master buffer
            if (self.rate == FX_UNIT) {
                // add audio to buffer -- basic
                var n = frame * 2;
                var i: usize = 0;
                while (i < count) : (i += 1) {
                    dst[(i * 2) + 0] += (self.buffer[(n    ) & BUFFER_MASK] * self.lgain) >> FX_BITS;
                    dst[(i * 2) + 1] += (self.buffer[(n + 1) & BUFFER_MASK] * self.rgain) >> FX_BITS;
                    n += 2;
                }
                self.position += count* FX_UNIT;
            } else {
                // add audio to buffer -- interpolated
                var i: usize = 0;
                while (i < count) : (i += 1) {
                    const p = self.position & FX_MASK;
                    var n = (self.position >> FX_BITS) * 2;
                    var a = self.buffer[(n    ) & BUFFER_MASK];
                    var b = self.buffer[(n + 2) & BUFFER_MASK];
                    dst[(i * 2) + 0] += (FX_LERP(a, b, p) * self.lgain) >> FX_BITS;
                    n += 1;
                    a = self.buffer[(n    ) & BUFFER_MASK];
                    b = self.buffer[(n + 2) & BUFFER_MASK];
                    dst[(i * 2) + 1] += (FX_LERP(a, b, p) * self.rgain) >> FX_BITS;
                    self.position += self.rate;
                }
            }
        }
    }

    pub fn destroy(self: *Self) void {
        const held = self.mixer.lock.acquire();
        if (self.active) {
            var source = self.mixer.sources;
            while (source) |*src| {
                if (src.* == self) {
                    src.* = self.next;
                    break;
                }
            }
        }
        held.release();
        self.handler(Event {
            .Destroy= {}
        });
        self.mixer.allocator.free(self);
        self = undefined;
    }

    pub fn getLength(self: *const Self) f32 {
        return self.length / @intToFloat(f32, self.sample_rate);
    }

    pub fn getPosition(self: *const Self) f32 {
        return ((self.position >> FX_BITS) % self.length) / @intToFloat(f32, self.sample_rate);
    }

    fn recalcGains(self: *Self) void {
        self.lgain = fxFromFloat(self.gain * (if (self.pan <= 0.0) 1.0 else 1.0 - pan));
        self.rgain = fxFromFloat(self.gain * (if (self.pan >= 0.0) 1.0 else 1.0 + pan));
    }

    pub fn setGain(self: *Self, gain: f32) void {
        self.gain = gain;
        self.recalcGains();
    }

    pub fn setPan(self: *Self, pan: f32) void {
        self.pan = clamp(f32, -1.0, 1.0);
        self.recalcGains();
    }

    pub fn setPitch(self: *Self, pitch: f32) void {
        const rate: f32 = if (pitch > 0.0) {
            self.samplerate / @intToFloat(f32, self.sample_rate) * pitch;
        } else {
            0.001;
        };
        self.rate = fxFromFloat(rate);
    }

    pub fn play(self: *Self) void {
        const held = self.mixer.lock.acquire();
        defer held.release();

        self.state = State.Playing;
        if (!self.active) {
            self.active = true;
            self.next = self.mixer.sources;
            self.mixer.sources = self;
        }
    }

    pub fn pause(self: *Self) void {
        self.state = State.Paused;
    }

    pub fn stop(self: *Self) void {
        self.state = State.Stopped;
        self.rewind = true;
    }
};


pub const Mixer = struct {
    const Self = @This();

    lock: Mutex,
    allocator: *Allocator,
    sources: ?*Source,          // linked list of active sources
    buffer: [BUFFER_SIZE]i32,   // internal master buffer
    sample_rate: i32,         // master samplerate
    gain: i32,                  // master gain (fixed point)

    pub fn init(allocator: *Allocator, sample_rate: i32) Self {
        return Self {
            .allocator = allocator,
            .sample_rate = sample_rate,
            .lock = Mutex.init(),
            .sources = null,
            .gain = FX_UNIT,
        };
    }

    pub fn setGain(self: *Self, gain: f32) void {
        self.gain = fxFromFloat(gain);
    }

    pub fn process(self: *Self, dst: []const i16) void {
        // process in chunks of BUFFER_SIZE if `dst.len` is larger than BUFFER_SIZE
        while (dst.len > BUFFER_SIZE) {
            self.process(dst[0..BUFFER_SIZE]);
            dst = dst[BUFFER_SIZE..];
        }

        // zeroset internal buffer
        std.mem.secureZero(i32, self.buffer);
        const held = self.lock.acquire();
        
        var source = self.src;
        while (source) |*src| {
            src.process(dst.len);
            // remove source from list if no longer plating
            if (src.*.state != State.Playing) {
                src.*.active = false;
                source.?.* = src.next;
            } else {
                source = src.next;
            }
        }

        held.release();

        // copy internal buffer to destination and clip
        for (dst) |*d, i| {
            const x = (self.buffer[i] * self.gain) >> FX_BITS;
            d.* = clamp(i32, -32768, 32767);
        }
    }
};
