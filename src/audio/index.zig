//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const builtin = @import("builtin");
const time = std.os.time;

const winmm = @import("winmm/index.zig");

pub const Backend = enum {
    Wasapi,
    Winmm,
    CoreAudio,
    Alsa,
    Null,
};

pub const PlayerError = error {

};

pub const AudioMode = union(enum) {
    const Self = @This();

    Mono: usize,
    Stereo: usize,

    pub fn channelCount(self: Self) usize {
        return switch (self) {
            AudioMode.Mono => usize(1),
            AudioMode.Stereo => usize(2),
        };
    }
};

pub const Player = struct {
    const Self = @This();

    player: sys.Player,
    pub sample_rate: usize,
    mode: AudioMode,
    buf_size: usize,

    pub fn new(allocator: *std.mem.Allocator, sample_rate: usize, mode: AudioMode, buf_size: usize) !Self {
        return Self {
            .player = try sys.Player.new(allocator, sample_rate, mode, buf_size),
            .sample_rate = sample_rate,
            .buf_size = buf_size,
            .mode = mode,
        };
    }

    fn bytes_per_sec(self: Self) usize {
        return self.sample_rate * switch (self.mode) {
            AudioMode.Mono => |bps| bps * self.mode.channelCount(),
            AudioMode.Stereo => |bps| bps * self.mode.channelCount(),
        };
    }

    pub fn write(self: *Self, bytes: []const u8) Error!void {
        var written: usize = 0;
        var data = bytes;

        while (data.len > 0) {
            const n = try self.player.write(data);
            written += n;

            data = data[n..];

            if (data.len > 0) {
                time.sleep(time.ns_per_s * self.buf_size / self.bytes_per_sec() / 8);
            }
        }
    }

    pub fn close(self: *Self) !void {
        time.sleep(time.ns_per_s * self.buf_size / self.bytes_per_sec());
        try self.player.close();
    }
};

test "Player -- raw audio" {
    var direct_allocator = std.heap.DirectAllocator.init();
    const alloc = &direct_allocator.allocator;
    defer direct_allocator.deinit();
    
    const mode = AudioMode { .Stereo = 2 };
    var player = try Player.new(alloc, 44100, mode, 2048);
    var stream = player.outStream().stream;

    var timer = try time.Timer.start();
    const duration = time.ns_per_s * 5;
    const dt = 1.0 / @intToFloat(f32, player.sample_rate);

    while (timer.read() < duration) {
        try player.write([]u8{127}**2048);
        // var i: usize = 0;
        // while (i < player.buf_size) : (i += 1) {
        //     const p = @intToFloat(f32, i) / @intToFloat(f32, player.buf_size);
        //     const out = std.math.sin(p * 2.0 * std.math.pi);
        //     try stream.writeByte(@floatToInt(u8, out));
        //     try stream.writeByte(@floatToInt(u8, out));
        // }
    }
}
