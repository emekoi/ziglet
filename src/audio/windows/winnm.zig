//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const windows = @import("std").os.windows;

pub const WAVE_FORMAT_PCM = 0x01;
pub const WHDR_INQUEUE = 0x10;
pub const WAVE_MAPPER = 0xffffffff;
pub const CALLBACK_NULL = 0x0;

pub const UINT_PTR = usize;

pub const MMError = error {
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

pub const MMRESULT = extern enum(u32) {
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
            MMRESULT.WAVERR_BADFORMAT =>  MMError.BadFormat,
            MMRESULT.WAVERR_STILLPLAYING =>  MMError.StillPlaying,
            MMRESULT.WAVERR_UNPREPARED =>  MMError.Unprepared,
            MMRESULT.WAVERR_SYNC =>  MMError.Sync,
        };
    }
};

pub const WaveHdr = extern struct {
    lpData: windows.LPSTR,
    dwBufferLength: windows.DWORD,
    dwBytesRecorded: windows.DWORD,
    dwUser: windows.DWORD_PTR,
    dwFlags: windows.DWORD,
    dwLoops: windows.DWORD,
    lpNext: ?*WaveHdr,
    reserved: windows.DWORD_PTR,
};

pub const WaveFormatEx = extern struct {
    wFormatTag: windows.WORD,
    nChannels: windows.WORD,
    nSamplesPerSec: windows.DWORD,
    nAvgBytesPerSec: windows.DWORD,
    nBlockAlign: windows.WORD,
    wBitsPerSample: windows.WORD,
    cbSize: windows.WORD,
};


pub extern "winmm" stdcallcc fn waveOutOpen(phwo: *windows.HANDLE, uDeviceID: UINT_PTR,
    pwfx: *const WaveFormatEx, dwCallback: windows.DWORD_PTR,
    dwCallbackInstance: windows.DWORD_PTR, fdwOpen: windows.DWORD) MMRESULT;

pub extern "winmm" stdcallcc fn waveOutClose(hwo: windows.HANDLE) MMRESULT;

pub extern "winmm" stdcallcc fn waveOutPrepareHeader(hwo: windows.HANDLE, pwh: *WaveHdr, cbwh: windows.UINT) MMRESULT;

pub extern "winmm" stdcallcc fn waveOutUnprepareHeader(hwo: windows.HANDLE, pwh: *WaveHdr, cbwh: windows.UINT) MMRESULT;

pub extern "winmm" stdcallcc fn waveOutWrite(hwo: windows.HANDLE, pwh: *WaveHdr, cbwh: windows.UINT) MMRESULT;
