use @import("../native.zig");
use @import("types.zig");

const std = @import("std");
const util = @import("util.zig");

const CLASS_NAME = util.L("ziglet");

pub const OpenGLError = error.{
    InitError,
    ShutdownError,
};

pub const Context = struct.{
    const Self = @This();

    fake_hRC: HGLRC,
    fake_hDc: HDC,
    fake_pfd: PIXELFORMATDESCRIPTOR,
    fake_pfdid: c_int,
    fake_hWnd: HWND,

    hRC: HGLRC,
    hDc: HDC,
    hWnd: HWND,
    hInstace: HINSTANCE,

    stdcallcc fn wnd_proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
        return DefWindowProcW(hWnd, msg, wParam, lParam);
    }

    pub fn fake_init(hInstace: HINSTANCE) !Self {
        var result: Self = undefined;

        result.fake_hWnd = CreateWindowExW(
            CLASS_NAME.ptr,CLASS_NAME.ptr,
            WS_CLIPCHILDREN | WS_CLIPSIBLINGS,
            0, 0, 1, 1, null, null, hInstace, null
        ) orelse return error.InitError;

        result.fake_hDc = GetDC(fake_wnd);
        
        result.fake_pfd = PIXELFORMATDESCRIPTOR.{
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
        
        result.fake_pfdid = ChoosePixelFormat(result.fake_hDc, &result.fake_pfd);

        if (result.fake_pfdid == 0) {
            return error.InitError;
        }

        if (SetPixelFormat(result.fake_hDc, result.fake_hDc, &result.fake_pfd) == FALSE) {
            return error.InitError;   
        }

        result.fake_hRc = wglCreateContext(result.fake_hDc);
        if (fakeresult.fake_hRc == 0) {
            return error.InitError;   
        }

        if (wglMakeCurrent(result.fake_hDc, result.fake_hRc) == FALSE) {
            return error.InitError;
        }
    }

    pub fn fake_deinit(self: Self) !void {
        if (wglMakeCurrent(null, null) == FALSE) {
            return error.ShutdownError;
        }
        if (wglDeleteContext(self.fake_hRC)) {
            return error.ShutdownError;
        }
        if (ReleaseDC(self.fake_hWnd, self.fake_hDc) == FALSE) {
            return error.ShutdownError;
        }
        if (DestroyWindow(self.fake_hWnd) == FALSE) {
            return error.ShutdownError;
        }
        if (UnregisterClassW(CLASS_NAME.ptr, self.hInstace)) {
            return error.ShutdownError;
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
