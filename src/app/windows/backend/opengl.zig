//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

const windows = @import("../../windows.zig");
const native = @import("../native.zig");
const internals = @import("../../../internals.zig");

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
const PFNGLARRAYELEMENTEXTPROC = ?stdcallcc fn (GLint) void;
const PFNGLDRAWARRAYSEXTPROC = ?stdcallcc fn (GLenum, GLint, GLsizei) void;
const PFNGLVERTEXPOINTEREXTPROC = ?stdcallcc fn (GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLNORMALPOINTEREXTPROC = ?stdcallcc fn (GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLCOLORPOINTEREXTPROC = ?stdcallcc fn (GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLINDEXPOINTEREXTPROC = ?stdcallcc fn (GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLTEXCOORDPOINTEREXTPROC = ?stdcallcc fn (GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
const PFNGLEDGEFLAGPOINTEREXTPROC = ?stdcallcc fn (GLsizei, GLsizei, ?*const GLboolean) void;
const PFNGLGETPOINTERVEXTPROC = ?stdcallcc fn (GLenum, ?*(?*GLvoid)) void;
const PFNGLARRAYELEMENTARRAYEXTPROC = ?stdcallcc fn (GLenum, GLsizei, ?*const GLvoid) void;
const PFNGLDRAWRANGEELEMENTSWINPROC = ?stdcallcc fn (GLenum, GLuint, GLuint, GLsizei, GLenum, ?*const GLvoid) void;
const PFNGLADDSWAPHINTRECTWINPROC = ?stdcallcc fn (GLint, GLint, GLsizei, GLsizei) void;
const PFNGLCOLORTABLEEXTPROC = ?stdcallcc fn (GLenum, GLenum, GLsizei, GLenum, GLenum, ?*const GLvoid) void;
const PFNGLCOLORSUBTABLEEXTPROC = ?stdcallcc fn (GLenum, GLsizei, GLsizei, GLenum, GLenum, ?*const GLvoid) void;
const PFNGLGETCOLORTABLEEXTPROC = ?stdcallcc fn (GLenum, GLenum, GLenum, ?*GLvoid) void;
const PFNGLGETCOLORTABLEPARAMETERIVEXTPROC = ?stdcallcc fn (GLenum, GLenum, ?*GLint) void;
const PFNGLGETCOLORTABLEPARAMETERFVEXTPROC = ?stdcallcc fn (GLenum, GLenum, ?*GLfloat) void;

// wgl extentions
const PFNWGLCREATECONTEXTATTRIBSARBPROC = ?stdcallcc fn (HDC, HGLRC, ?*const c_int) HGLRC;
const PFNWGLCHOOSEPIXELFORMATARBPROC = ?stdcallcc fn (HDC, ?*const c_int, ?*const FLOAT, UINT, ?*c_int, ?*UINT) BOOL;

const PIXELFORMATDESCRIPTOR = extern struct {
    nSize: WORD = @sizeOf(PIXELFORMATDESCRIPTOR),
    nVersion: WORD = 1,
    dwFlags: DWORD = 0,
    iPixelType: BYTE = PFD_TYPE_RGBA,
    cColorBits: BYTE = 32,
    cRedBits: BYTE = 0,
    cRedShift: BYTE = 0,
    cGreenBits: BYTE = 0,
    cGreenShift: BYTE = 0,
    cBlueBits: BYTE = 0,
    cBlueShift: BYTE = 0,
    cAlphaBits: BYTE = 8,
    cAlphaShift: BYTE = 0,
    cAccumBits: BYTE = 0,
    cAccumRedBits: BYTE = 0,
    cAccumGreenBits: BYTE = 0,
    cAccumBlueBits: BYTE = 0,
    cAccumAlphaBits: BYTE = 0,
    cDepthBits: BYTE = 24,
    cStencilBits: BYTE = 0,
    cAuxBuffers: BYTE = 0,
    iLayerType: BYTE = PFD_MAIN_PLANE,
    bReserved: BYTE = 0,
    dwLayerMask: DWORD = 0,
    dwVisibleMask: DWORD = 0,
    dwDamageMask: DWORD = 0,
};

extern "gdi32" stdcallcc fn StretchDIBits(hdc: HDC, xDest: c_int, yDest: c_int, DestWidth: c_int, DestHeight: c_int, xSrc: c_int, ySrc: c_int, SrcWidth: c_int, SrcHeight: c_int, lpBits: ?*const c_void, lpbmi: ?*const BITMAPINFO, iUsage: UINT, rop: DWORD) c_int;

extern "gdi32" stdcallcc fn ChoosePixelFormat(hdc: HDC, ppfd: ?*const PIXELFORMATDESCRIPTOR) c_int;

extern "gdi32" stdcallcc fn SetPixelFormat(hdc: HDC, format: c_int, ppfd: ?*const PIXELFORMATDESCRIPTOR) BOOL;

extern "opengl32" stdcallcc fn wglCreateContext(arg0: HDC) ?HGLRC;

extern "opengl32" stdcallcc fn wglMakeCurrent(arg0: ?HDC, arg1: ?HGLRC) BOOL;

extern "opengl32" stdcallcc fn wglDeleteContext(arg0: HGLRC) BOOL;

extern "opengl32" stdcallcc fn wglGetProcAddress(LPCSTR) ?PROC;

pub const OpenGLError = error{
    InitError,
    ShutdownError,
};

pub const Context = struct {
    dummy_hRC: native.HGLRC,
    dummy_hDc: native.HDC,
    dummy_pfd: PIXELFORMATDESCRIPTOR,
    dummy_pfdid: c_int,
    dummy_hWnd: native.HWND,

    hRC: HGLRC,
    hDc: native.HDC,
    hWnd: native.HWND,

    pub fn dummy_init(window: *const super.Window) !Context {
        var wcex: native.WNDCLASSEX = native.WNDCLASSEX{};
        var class_name: [18]u16 = undefined;
        wcex.style = native.OWN_DC;
        wcex.hInstace = native.kernel32.GetModuleHandleW(null);
        wcex.lpszClassName = internals.toWide(&class_name, "ziglet_wgl_loader").ptr;
        if (native.RegisterClassExW(&wcex) == 0) {
            return error.InitError;
        }

        var dummy_wnd = CreateWindowExW(0, wcex.lpszClassName, 0, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, null, null, wcex.hInstace, null) orelse return error.InitError;
        var dummy_dc = GetDC(dummy_wnd);

        var dummy_pfd = PIXELFORMATDESCRIPTOR{
            .dwFlags = PFD_DOUBLEBUFFER | PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL,
        };

        var dummy_pfdid = ChoosePixelFormat(dummy_dc, &dummy_pfd);

        if (result.dummy_pfdid == 0) {
            return error.InitError;
        }

        if (SetPixelFormat(dummy_dc, dummy_pfdid, &dummy_pfd) == FALSE) {
            return error.InitError;
        }

        var dummy_glc = wglCreateContext(dummy_dc) orelse return error.InitError;

        if (wglMakeCurrent(dummy_dc, dummy_glc) == FALSE) {
            return error.InitError;
        }

        // load opengl functions here https://github.com/ApoorvaJ/Papaya/blob/3808e39b0f45d4ca4972621c847586e4060c042a/src/libs/gl_lite.h
        // use metaprogramming to make it easier

        if (wglMakeCurrent(null, null) == FALSE) {
            return error.InitError;
        }
        if (wglDeleteContext(dummy_glc)) {
            return error.InitError;
        }
        if (ReleaseDC(dummy_wnd, dummy_dc) == FALSE) {
            return error.InitError;
        }
        if (DestroyWindow(dummy_wnd) == FALSE) {
            return error.InitError;
        }
    }

    pub fn init(self: *Context, window: *const super.Window) !void {
        self.hWnd = window.hWnd;
        self.dummy_init(window);

        self.dummy_deinit();

        if (wglMakeCurrent(self.hDc, self.hRc) == FALSE) {
            return error.InitError;
        }
    }

    pub fn deinit(self: Context) !void {
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
