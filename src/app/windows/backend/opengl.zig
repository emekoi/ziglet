//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

const super = @import("../index.zig");
const native = @import("../native.zig");

const HGLRC = HANDLE;
const PROC = *@OpaqueType();

const GLenum = u32;
const GLboolean = bool;
const GLbitfield = u32;
const GLbyte = i8;
const GLshort = i16;
const GLint = i32;
const GLsizei = i32;
const GLubyte = u8;
const GLushort = u16;
const GLuint = u32;
const GLfloat = f32;
const GLclampf = f32;
const GLdouble = f64;
const GLclampd = f64;
const GLvoid = *c_void;

// opengl function pointers
const PFNGLARRAYELEMENTEXTPROC = ?stdcallcc fn(GLint) void;
const PFNGLDRAWARRAYSEXTPROC = ?stdcallcc fn(GLenum, GLint, GLsizei) void;
const PFNGLVERTEXPOINTEREXTPROC = ?stdcallcc fn(GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLNORMALPOINTEREXTPROC = ?stdcallcc fn(GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLCOLORPOINTEREXTPROC = ?stdcallcc fn(GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLINDEXPOINTEREXTPROC = ?stdcallcc fn(GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLTEXCOORDPOINTEREXTPROC = ?stdcallcc fn(GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLEDGEFLAGPOINTEREXTPROC = ?stdcallcc fn(GLsizei, GLsizei, ?*const GLboolean) void;
const PFNGLGETPOINTERVEXTPROC = ?stdcallcc fn(GLenum, ?*(?*GLvoid)) void;
const PFNGLARRAYELEMENTARRAYEXTPROC = ?stdcallcc fn(GLenum, GLsizei, ?*const GLvoid) void;
const PFNGLDRAWRANGEELEMENTSWINPROC = ?stdcallcc fn(GLenum, GLuint, GLuint, GLsizei, GLenum, ?*const GLvoid) void;
const PFNGLADDSWAPHINTRECTWINPROC = ?stdcallcc fn(GLint, GLint, GLsizei, GLsizei) void;
const PFNGLCOLORTABLEEXTPROC = ?stdcallcc fn(GLenum, GLenum, GLsizei, GLenum, GLenum, ?*const GLvoid) void;
const PFNGLCOLORSUBTABLEEXTPROC = ?stdcallcc fn(GLenum, GLsizei, GLsizei, GLenum, GLenum, ?*const GLvoid) void;
const PFNGLGETCOLORTABLEEXTPROC = ?stdcallcc fn(GLenum, GLenum, GLenum, ?*GLvoid) void;
const PFNGLGETCOLORTABLEPARAMETERIVEXTPROC = ?stdcallcc fn(GLenum, GLenum, ?*GLint) void;
const PFNGLGETCOLORTABLEPARAMETERFVEXTPROC = ?stdcallcc fn(GLenum, GLenum, ?*GLfloat) void;

// wgl extentions
const PFNWGLCREATECONTEXTATTRIBSARBPROC = ?stdcallcc fn(HDC, HGLRC, ?*const c_int) HGLRC;
const PFNWGLCHOOSEPIXELFORMATARBPROC = ?stdcallcc fn(HDC, ?*const c_int, ?*const FLOAT, UINT, ?*c_int, ?*UINT) BOOL;

const PIXELFORMATDESCRIPTOR = extern struct {
    nSize: WORD,
    nVersion: WORD,
    dwFlags: DWORD,
    iPixelType: BYTE,
    cColorBits: BYTE,
    cRedBits: BYTE,
    cRedShift: BYTE,
    cGreenBits: BYTE,
    cGreenShift: BYTE,
    cBlueBits: BYTE,
    cBlueShift: BYTE,
    cAlphaBits: BYTE,
    cAlphaShift: BYTE,
    cAccumBits: BYTE,
    cAccumRedBits: BYTE,
    cAccumGreenBits: BYTE,
    cAccumBlueBits: BYTE,
    cAccumAlphaBits: BYTE,
    cDepthBits: BYTE,
    cStencilBits: BYTE,
    cAuxBuffers: BYTE,
    iLayerType: BYTE,
    bReserved: BYTE,
    dwLayerMask: DWORD,
    dwVisibleMask: DWORD,
    dwDamageMask: DWORD,
};

extern "gdi32" stdcallcc fn StretchDIBits(hdc: HDC, xDest: c_int, yDest: c_int, DestWidth: c_int, DestHeight: c_int,
                    xSrc: c_int, ySrc: c_int, SrcWidth: c_int, SrcHeight: c_int, lpBits: ?*const c_void,
                    lpbmi: ?*const BITMAPINFO, iUsage: UINT, rop: DWORD) c_int;

extern "gdi32" stdcallcc fn ChoosePixelFormat(hdc: HDC, ppfd: ?*const PIXELFORMATDESCRIPTOR) c_int;

extern "gdi32" stdcallcc fn SetPixelFormat(hdc: HDC, format: c_int, ppfd: ?*const PIXELFORMATDESCRIPTOR) BOOL;

extern "opengl32" stdcallcc fn wglCreateContext(arg0: HDC) ?HGLRC;

extern "opengl32" stdcallcc fn wglMakeCurrent(arg0: HDC, arg1: HGLRC) BOOL;

extern "opengl32" stdcallcc fn wglDeleteContext(arg0: HGLRC) BOOL;

extern "opengl32" stdcallcc fn wglGetProcAddress(LPCSTR) ?PROC;


pub const OpenGLError = error {
    InitError,
    ShutdownError,
};

pub const Context = struct {
    const Self = @This();

    dummy_hRC: native.HGLRC,
    dummy_hDc: native.HDC,
    dummy_pfd: PIXELFORMATDESCRIPTOR,
    dummy_pfdid: c_int,
    dummy_hWnd: native.HWND,

    hRC: HGLRC,
    hDc: native.HDC,
    hWnd: native.HWND,

    stdcallcc fn wnd_proc(hWnd: native.HWND, msg: native.UINT, wParam: native.WPARAM, lParam: native.LPARAM) native.LRESULT {
        return native.DefWindowProcW(hWnd, msg, wParam, lParam);
    }

    pub fn dummy_init(window: *const super.Window) !Self {
        var result: Self = undefined;

        result.dummy_hWnd = CreateWindowExW(
            CLASS_NAME.ptr,CLASS_NAME.ptr,
            WS_CLIPCHILDREN | WS_CLIPSIBLINGS,
            0, 0, 1, 1, null, null,
            native.GetModuleHandleW(null), null
        ) orelse return error.InitError;

        result.dummy_hDc = GetDC(dummy_wnd);
        
        result.dummy_pfd = PIXELFORMATDESCRIPTOR {
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

    pub fn init(self: *Self, window: *const super.Window) !void {
        self.hWnd = window.hWnd;
        self.dummy_init(window);

        self.dummy_deinit();

        if (wglMakeCurrent(self.hDc, self.hRc) == FALSE) {
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
};
