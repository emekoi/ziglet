//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const Allocator = std.mem.Allocator;
const windows = std.os.windows;

const Buffer = @import("../buffer.zig").Buffer;
const AudioMode = @import("../index.zig").AudioMode;
const winnm = @import("winnm.zig");

const Header = struct {
    const Self = @This();

    pub const Error = error {
        InvalidLength,
    };

    buffer: Buffer(u8),
    wavehdr: winnm.WaveHdr,

    pub fn new(player: Player, buf_size: usize) !Self {
        var result: Self = undefined;

        result.buffer = try Buffer(u8).initSize(player.allocator, buf_size);

        result.wavehdr = winnm.WaveHdr {
            .lpData = result.buffer.ptr(),
            .dwBufferLength = @intCast(windows.DWORD, buf_size),
            .dwBytesRecorded = undefined,
            .dwUser = undefined,
            .dwFlags = 0,
            .dwLoops = undefined,
            .lpNext = undefined,
            .reserved = undefined,
        };
        
        try winnm.waveOutPrepareHeader(
            player.handle, &result.wavehdr,
           @sizeOf(winnm.WaveHdr)
        ).toError();
        
        return result;
    }

    pub fn write(self: *Self, player: *const Player, data: []const u8) !void {
        if (data.len != self.buffer.len()) {
            return error.InvalidLength;
        }

        try self.buffer.replaceContents(data);

        try winnm.waveOutWrite(
            player.handle, &self.wavehdr,
            @intCast(windows.UINT, self.buffer.len())
        ).toError();
    }

    pub fn destroy(self: *Self, player: Player) !void {
        try winnm.waveOutUnprepareHeader(
            player.handle, &self.wavehdr,
            @sizeOf(winnm.WaveHdr)
        ).toError();
        self.buffer.deinit();
    }
};

pub const Player = struct {
    const Self = @This();
    const BUF_COUNT = 2;

    pub const Error = Header.Error || Allocator.Error || winnm.MMError;

    allocator: *Allocator,
    handle: windows.HANDLE,
    headers: [BUF_COUNT]Header,
    tmp: Buffer(u8),
    buf_size: usize,

    pub fn new(allocator: *Allocator, sample_rate: usize, mode: AudioMode, buf_size: usize) Error!Self {
        var result: Self = undefined;
        var handle: windows.HANDLE = undefined;

        const bps = switch (mode) {
            AudioMode.Mono => |bps| bps,
            AudioMode.Stereo => |bps| bps,
        };

        const block_align = bps * mode.channelCount();

        const format = winnm.WaveFormatEx {
            .wFormatTag = winnm.WAVE_FORMAT_PCM,
            .nChannels = @intCast(windows.WORD, mode.channelCount()),
            .nSamplesPerSec = @intCast(windows.DWORD, sample_rate),
            .nAvgBytesPerSec = @intCast(windows.DWORD, sample_rate * block_align),
            .nBlockAlign = @intCast(windows.WORD, block_align),
            .wBitsPerSample = @intCast(windows.WORD, bps * 8),
            .cbSize = 0,
        };

        try winnm.waveOutOpen(
            &handle, winnm.WAVE_MAPPER, &format,
            0, 0, winnm.CALLBACK_NULL
        ).toError();

        result = Self {
            .handle = handle,
            .headers = []Header {undefined} ** BUF_COUNT,
            .buf_size = buf_size,
            .allocator = allocator,
            .tmp = try Buffer(u8).initSize(allocator, buf_size)
        };

        for (result.headers) |*header| {
            header.* = try Header.new(result, buf_size);
        }

        return result;
    }

    pub fn write(self: *Self, data: []const u8) Error!usize {
        const n = std.math.min(data.len, std.math.max(0, self.buf_size - self.tmp.len()));
        try self.tmp.append(data[0..n]);
        if (self.tmp.len() < self.buf_size) {
            return n;
        }

        var header = for (self.headers) |header| {
            if (header.wavehdr.dwFlags & winnm.WHDR_INQUEUE == 0) {
                break header;
            }
        } else return n;

        try header.write(self, self.tmp.toSlice());
        try self.tmp.resize(0);

        return n;
    }

    pub fn close(self: *Self) Error!void {
        for (self.headers) |*header| {
            try header.destroy(self.handle);
        }
        try winnm.waveOutClose(self.handle).toError();
        self.tmp.deinit();
    }
};
