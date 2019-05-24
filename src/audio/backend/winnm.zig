//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const Allocator = std.mem.Allocator;
const windows = std.os.windows;

const WAVE_FORMAT_PCM = 0x01;
const WHDR_INQUEUE = 0x10;
const WAVE_MAPPER = 0xffffffff;
const CALLBACK_NULL = 0x0;
const HWAVEOUT = windows.HANDLE;

const UINT_PTR = usize;

const MMError = error{
    Error,
    BadDeviceID,
    Allocated,
    InvalidHandle,
    NoDriver,
    NoMem,
    BadFormat,
    StillPlaying,
    Unprepared,
    Sync,
};

const MMRESULT = extern enum(u32) {
    MMSYSERR_NOERROR = 0,
    MMSYSERR_ERROR = 1,
    MMSYSERR_BADDEVICEID = 2,
    MMSYSERR_ALLOCATED = 4,
    MMSYSERR_INVALIDHANDLE = 5,
    MMSYSERR_NODRIVER = 6,
    MMSYSERR_NOMEM = 7,
    WAVERR_BADFORMAT = 32,
    WAVERR_STILLPLAYING = 33,
    WAVERR_UNPREPARED = 34,
    WAVERR_SYNC = 35,

    pub fn toError(self: MMRESULT) MMError!void {
        return switch (self) {
            MMRESULT.MMSYSERR_NOERROR => {},
            MMRESULT.MMSYSERR_ERROR => MMError.Error,
            MMRESULT.MMSYSERR_BADDEVICEID => MMError.BadDeviceID,
            MMRESULT.MMSYSERR_ALLOCATED => MMError.Allocated,
            MMRESULT.MMSYSERR_INVALIDHANDLE => MMError.InvalidHandle,
            MMRESULT.MMSYSERR_NODRIVER => MMError.NoDriver,
            MMRESULT.MMSYSERR_NOMEM => MMError.NoMem,
            MMRESULT.WAVERR_BADFORMAT => MMError.BadFormat,
            MMRESULT.WAVERR_STILLPLAYING => MMError.StillPlaying,
            MMRESULT.WAVERR_UNPREPARED => MMError.Unprepared,
            MMRESULT.WAVERR_SYNC => MMError.Sync,
        };
    }
};

const WAVEHDR = extern struct {
    lpData: windows.LPSTR,
    dwBufferLength: windows.DWORD,
    dwBytesRecorded: windows.DWORD,
    dwUser: windows.DWORD_PTR,
    dwFlags: windows.DWORD,
    dwLoops: windows.DWORD,
    lpNext: ?*WAVEHDR,
    reserved: windows.DWORD_PTR,
};

const WAVEFORMATEX = extern struct {
    wFormatTag: windows.WORD,
    nChannels: windows.WORD,
    nSamplesPerSec: windows.DWORD,
    nAvgBytesPerSec: windows.DWORD,
    nBlockAlign: windows.WORD,
    wBitsPerSample: windows.WORD,
    cbSize: windows.WORD,
};

extern "winmm" stdcallcc fn waveOutOpen(phwo: *HWAVEOUT, uDeviceID: UINT_PTR, pwfx: *const WAVEFORMATEX, dwCallback: windows.DWORD_PTR, dwCallbackInstance: windows.DWORD_PTR, fdwOpen: windows.DWORD) MMRESULT;

extern "winmm" stdcallcc fn waveOutClose(hwo: HWAVEOUT) MMRESULT;

extern "winmm" stdcallcc fn waveOutPrepareHeader(hwo: HWAVEOUT, pwh: *WAVEHDR, cbwh: windows.UINT) MMRESULT;

extern "winmm" stdcallcc fn waveOutUnprepareHeader(hwo: HWAVEOUT, pwh: *WAVEHDR, cbwh: windows.UINT) MMRESULT;

extern "winmm" stdcallcc fn waveOutWrite(hwo: HWAVEOUT, pwh: *WAVEHDR, cbwh: windows.UINT) MMRESULT;

const Buffer = @import("../buffer.zig").Buffer;
const AudioMode = @import("../../audio.zig").AudioMode;

const Header = struct {
    const Self = @This();

    pub const Error = error{InvalidLength};

    buffer: Buffer(i16),
    wave_out: HWAVEOUT,
    wave_hdr: winnm.WAVEHDR,

    pub fn new(player: *Player, buf_size: usize) !Self {
        var result: Self = undefined;

        result.buffer = try Buffer(i16).initSize(player.allocator, buf_size);
        result.wave_out = player.wave_out;

        result.wave_hdr.dwBufferLength = @intCast(windows.DWORD, buf_size);
        result.wave_hdr.lpData = result.buffer.ptr();
        result.wave_hdr.dwFlags = 0;

        try winnm.waveOutPrepareHeader(result.wave_out, &result.wave_hdr, @sizeOf(winnm.WAVEHDR)).toError();

        return result;
    }

    pub fn write(self: *Self, data: []const i16) !void {
        if (data.len != self.buffer.len()) {
            return error.InvalidLength;
        }

        try self.buffer.replaceContents(data);

        try winnm.waveOutWrite(self.wave_out, &self.wave_hdr, @intCast(windows.UINT, self.buffer.len())).toError();
    }

    pub fn destroy(self: *Self) !void {
        try winnm.waveOutUnprepareHeader(sefl.wave_out, &self.wave_hdr, @sizeOf(winnm.WAVEHDR)).toError();
        self.buffer.deinit();
    }
};

pub const Backend = struct {
    const BUF_COUNT = 2;

    allocator: *Allocator,
    wave_out: winnm.HWAVEOUT,
    headers: [BUF_COUNT]Header,
    buffer: Buffer(f32),

    pub fn init(allocator: *Allocator, sample_rate: usize, mode: AudioMode, buf_size: usize) Error!Self {
        var result: Self = undefined;
        var handle: windows.HANDLE = undefined;

        const bps = switch (mode) {
            AudioMode.Mono => |bps| bps,
            AudioMode.Stereo => |bps| bps,
        };

        const block_align = bps * mode.channelCount();

        const format = winnm.WAVEFORMATEX{
            .wFormatTag = winnm.WAVE_FORMAT_PCM,
            .nChannels = @intCast(windows.WORD, mode.channelCount()),
            .nSamplesPerSec = @intCast(windows.DWORD, sample_rate),
            .nAvgBytesPerSec = @intCast(windows.DWORD, sample_rate * block_align),
            .nBlockAlign = @intCast(windows.WORD, block_align),
            .wBitsPerSample = @intCast(windows.WORD, bps * 8),
            .cbSize = 0,
        };

        try winnm.waveOutOpen(&handle, winnm.WAVE_MAPPER, &format, 0, 0, winnm.CALLBACK_NULL).toError();

        result = Self{
            .handle = handle,
            .headers = []Header{undefined} ** BUF_COUNT,
            .buf_size = buf_size,
            .allocator = allocator,
            .tmp = try Buffer(u8).initSize(allocator, buf_size),
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
        try winmm.waveOutReset(self.wave_out).toError();

        for (self.headers) |*header| {
            try header.destroy();
        }

        try winnm.waveOutClose(self.handle).toError();
        self.buffer.deinit();
    }
};
