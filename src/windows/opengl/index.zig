//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

use @import("../native.zig");
use @import("types.zig");

const std = @import("std");
const util = @import("util.zig");
const super = @import("../index.zig");

const CLASS_NAME = util.L("ziglet");

pub const OpenGLError = error.{
    InitError,
    ShutdownError,
};

pub const Context = struct.{
    const Self = @This();

    dummy_hRC: HGLRC,
    dummy_hDc: HDC,
    dummy_pfd: PIXELFORMATDESCRIPTOR,
    dummy_pfdid: c_int,
    dummy_hWnd: HWND,

    hRC: HGLRC,
    hDc: HDC,
    hWnd: HWND,
    hInstace: HINSTANCE,

    stdcallcc fn wnd_proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
        return DefWindowProcW(hWnd, msg, wParam, lParam);
    }

    pub fn dummy_init(hInstace: HINSTANCE) !Self {
        var result: Self = undefined;

        result.dummy_hWnd = CreateWindowExW(
            CLASS_NAME.ptr,CLASS_NAME.ptr,
            WS_CLIPCHILDREN | WS_CLIPSIBLINGS,
            0, 0, 1, 1, null, null, hInstace, null
        ) orelse return error.InitError;

        result.dummy_hDc = GetDC(dummy_wnd);
        
        result.dummy_pfd = PIXELFORMATDESCRIPTOR.{
            .nSize =@sizeOf(PIXELFORMATDESCRIPTOR),
            .nVersion = 1,
            .dwFlags = PFD_DOUBLEBUFFER | PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL,
            .iPixelType = PFD_TYPE_RGBA,
            .cColorBits = 32,
            .cRedBits = 0,
            .cRedShift = 0,
            .cGreenBits = 0,
            .cGreenShift = 0,
            .cBlueBits = 0,
            .cBlueShift = 0,
            .cAlphaBits = 0,
            .cAlphaShift = 0,
            .cAccumBits = 0,
            .cAccumRedBits = 0,
            .cAccumGreenBits = 0,
            .cAccumBlueBits = 0,
            .cAccumAlphaBits = 0,
            .cDepthBits = 0,
            .cStencilBits = 0,
            .cAuxBuffers = 0,
            .iLayerType = PFD_MAIN_PLANE, 
            .bReserved = 0,
            .dwLayerMask = 0,
            .dwVisibleMask = 0,
            .dwDamageMask = 0,
        };
        
        result.dummy_pfdid = ChoosePixelFormat(result.dummy_hDc, &result.dummy_pfd);

        if (result.dummy_pfdid == 0) {
            return error.InitError;
        }

        if (SetPixelFormat(result.dummy_hDc, result.dummy_hDc, &result.dummy_pfd) == FALSE) {
            return error.InitError;   
        }

        if (wglCreateContext(result.dummy_hDc)) |hRc| {
            result.dummy_hRc = hRc;
        } else return error.InitError;

        if (wglMakeCurrent(result.dummy_hDc, result.dummy_hRc) == FALSE) {
            return error.InitError;
        }

        return result;
    }

    fn dummy_deinit(self: Self) !void {
        if (wglMakeCurrent(null, null) == FALSE) {
            return error.InitError;
        }
        if (wglDeleteContext(self.dummy_hRC)) {
            return error.InitError;
        }
        if (ReleaseDC(self.dummy_hWnd, self.dummy_hDc) == FALSE) {
            return error.InitError;
        }
        if (DestroyWindow(self.dummy_hWnd) == FALSE) {
            return error.InitError;
        }
    }

    pub fn init(self: *Self, window: *super.Window) !void { 
        self.hWnd = window.handle;
        
        self.dummy_deinit();

        if (wglMakeCurrent(result.hDc, result.hRc) == FALSE) {
            return error.InitError;
        }
    }

    pub fn deinit(self: Self) !void {
        if (wglMakeCurrent(null, null) == FALSE) {
            return error.ShutdownError;
        }
        if (wglDeleteContext(self.hRC)) {
            return error.ShutdownError;
        }
        if (ReleaseDC(self.hWnd, self.hDc) == FALSE) {
            return error.ShutdownError;
        }
        if (DestroyWindow(self.hWnd) == FALSE) {
            return error.ShutdownError;
        }
        if (UnregisterClassW(CLASS_NAME.ptr, self.hInstace)) {
            return error.ShutdownError;
        }
    }
}
