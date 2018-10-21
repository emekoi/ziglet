//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

use @import("native.zig");

const std = @import("std");
const super = @import("../index.zig");
const opengl = @import("opengl/index.zig");

pub const Window = struct.{
    const Self = @This();

    pub const WindowError = error.{
        InitError,
        ShutdownError,
    };

    pub const Options = struct.{
        fullscreen: bool,
        borderless: bool,
        resizeable: bool,
        width: usize,
        height: usize,
        title: []const u8,
    };

    // private implementation stuff
    gl_context: opengl.Context,
    handle: HWND,

    pub fullscreen: bool,
    pub borderless: bool,
    pub resizeable: bool,
    pub width: usize,
    pub height: usize,
    pub title: []const u8,
    pub should_close: bool,
    pub keyboard: super.keyboard.Keyboard,

    stdcallcc fn wnd_proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
        var result: LRESULT = 0;

        var self = @intToPtr(?*Self, GetWindowLongPtrW(hWnd, GWLP_USERDATA)) orelse return DefWindowProcW(hWnd, msg, wParam, lParam);

        switch (msg) {
            WM_CLOSE => {
                self.should_close = true;
            },
            WM_KEYDOWN => {
                self.update_keyboard(lParam >> 16, true);
            },
            WM_KEYUP => {
                self.update_keyboard(lParam >> 16, false);
            },
            else => {
                return DefWindowProcW(hWnd, msg, wParam, lParam);
            }
        }

        return result;
    }

    fn open_window(options: Options) !HWND {
        const wcex = WNDCLASSEX.{
            .cbSize = @sizeOf(WNDCLASSEX),
            .style = CS_HREDRAW | CS_VREDRAW | CS_OWNDC,
            .lpfnWndProc = wnd_proc,
            .cbClsExtra = 0,
            .cbWndExtra = 0,
            .hInstance = GetModuleHandleW(null),
            .hIcon = LoadIconW(null, IDI_WINLOGO).?,
            .hCursor = LoadCursorW(null, IDC_ARROW).?,
            .hbrBackground = undefined,
            .lpszMenuName = L("").ptr,
            .lpszClassName = CLASS_NAME.ptr,
            .hIconSm = undefined,
        };

        if (RegisterClassW(&wcex) == 0) {
            return return error.InitError;
        }

        var rect = RECT.{
            .left = 0,
            .right = width,
            .top = 0,
            .bottom = height,
        };

        var dwExStyle = 0;
        var dwStyle = WS_CLIPSIBLINGS | WS_CLIPCHILDREN;     

        if (options.fullscreen) {
            var dmScreeenSettings: DEVMODEW = undefined;
            dmScreeenSettings.dmSize = @sizeOf(DEVMODEW);
            dmScreenSettings.dmPelsWidth = width;
            dmScreenSettings.dmPelsHeight = height;
            dmScreenSettings.dmBitsPerPel = 32;
            dmScreenSettings.dmFields = DM_BITSPERPEL | DM_PELSWIDTH | DM_PELSHEIGHT;
            if (ChangeDisplaySettings(&dmScreeenSettings, CDS_FULLSCREEN) != 0) {
                return error.InitError;
            } else {
                dwExStyle = WS_EX_APPWINDOW;
                dwStyle |= WS_POPUP;
                ShowCursor(FALSE);
            }
        } else {
            dwExStyle = WS_EX_APPWINDOW | WS_EX_WINDOWEDGE | WS_EX_ACCEPTFILES;

            if (options.title) {
                dwStyle |= DWORD(WS_OVERLAPPEDWINDOW);
            }

            if (options.resizeable) {
                dwStyle |= DWORD(WS_THICKFRAME) | DWORD(WS_MAXIMIZEBOX);
            } else {
                dwStyle &= ~DWORD(WS_MAXIMIZEBOX);
                dwStyle &= ~DWORD(WS_THICKFRAME);
            }

            if (options.borderless) {
                dwStyle &= ~DWORD(WS_THICKFRAME);
            }
        }

        if (AdjustWindowRectEx(&rect, dwStyle, FALSE, dwExStyle) == 0) {
            return error.InitError;
        }

        const wtitle = L(options.title);

        rect.right -= rect.left;
        rect.bottom -= rect.top;

        return CreateWindowExW(dwExStyle, 
            wtitle.ptr, wtitle.ptr, dwStyle,
            CW_USEDEFAULT, CW_USEDEFAULT, rect.right, rect.bottom,
            null, null, wcex.hInstance, null
        ) orelse return error.CreateError;
    }

    pub fn init(options: Options) !Self {
        var result = Self.{
            .gl_context = try opengl.Context.dummy_init(),
            .handle = undefined,
            .fullscreen = options.fullscreen,
            .borderless = options.borderless,
            .resizeable = options.resizeable,
            .width = options.width,
            .height = options.height,
            .title = options.title,
            .should_close = false,
            .keyboard = super.keyboard.Keyboard.new(),
        };

        errdefer result.deinit();

        result.handle = try open_window(options);
        try result.gl_context.init(result);

    }

    pub fn deinit(self: Self) void {
        if (self.fullscreen) {
            _ = ChangeDisplaySettings(null, 0);
            _ = ShowCursor(TRUE);
        }
        // TODO deinit window here or with opengl context
        self.gl_context.deinit();
    }

    fn update_keyboard(self: *Self, wparam: usize, state: bool) void {
        switch (wparam & 0x1ff) {
            0x00B => self.keyboard.set_key_state(super.keyboard.Key.Key0, state),
            0x002 => self.keyboard.set_key_state(super.keyboard.Key.Key1, state),
            0x003 => self.keyboard.set_key_state(super.keyboard.Key.Key2, state),
            0x004 => self.keyboard.set_key_state(super.keyboard.Key.Key3, state),
            0x005 => self.keyboard.set_key_state(super.keyboard.Key.Key4, state),
            0x006 => self.keyboard.set_key_state(super.keyboard.Key.Key5, state),
            0x007 => self.keyboard.set_key_state(super.keyboard.Key.Key6, state),
            0x008 => self.keyboard.set_key_state(super.keyboard.Key.Key7, state),
            0x009 => self.keyboard.set_key_state(super.keyboard.Key.Key8, state),
            0x00A => self.keyboard.set_key_state(super.keyboard.Key.Key9, state),
            0x01E => self.keyboard.set_key_state(super.keyboard.Key.A, state),
            0x030 => self.keyboard.set_key_state(super.keyboard.Key.B, state),
            0x02E => self.keyboard.set_key_state(super.keyboard.Key.C, state),
            0x020 => self.keyboard.set_key_state(super.keyboard.Key.D, state),
            0x012 => self.keyboard.set_key_state(super.keyboard.Key.E, state),
            0x021 => self.keyboard.set_key_state(super.keyboard.Key.F, state),
            0x022 => self.keyboard.set_key_state(super.keyboard.Key.G, state),
            0x023 => self.keyboard.set_key_state(super.keyboard.Key.H, state),
            0x017 => self.keyboard.set_key_state(super.keyboard.Key.I, state),
            0x024 => self.keyboard.set_key_state(super.keyboard.Key.J, state),
            0x025 => self.keyboard.set_key_state(super.keyboard.Key.K, state),
            0x026 => self.keyboard.set_key_state(super.keyboard.Key.L, state),
            0x032 => self.keyboard.set_key_state(super.keyboard.Key.M, state),
            0x031 => self.keyboard.set_key_state(super.keyboard.Key.N, state),
            0x018 => self.keyboard.set_key_state(super.keyboard.Key.O, state),
            0x019 => self.keyboard.set_key_state(super.keyboard.Key.P, state),
            0x010 => self.keyboard.set_key_state(super.keyboard.Key.Q, state),
            0x013 => self.keyboard.set_key_state(super.keyboard.Key.R, state),
            0x01F => self.keyboard.set_key_state(super.keyboard.Key.S, state),
            0x014 => self.keyboard.set_key_state(super.keyboard.Key.T, state),
            0x016 => self.keyboard.set_key_state(super.keyboard.Key.U, state),
            0x02F => self.keyboard.set_key_state(super.keyboard.Key.V, state),
            0x011 => self.keyboard.set_key_state(super.keyboard.Key.W, state),
            0x02D => self.keyboard.set_key_state(super.keyboard.Key.X, state),
            0x015 => self.keyboard.set_key_state(super.keyboard.Key.Y, state),
            0x02C => self.keyboard.set_key_state(super.keyboard.Key.Z, state),
            0x03B => self.keyboard.set_key_state(super.keyboard.Key.F1, state),
            0x03C => self.keyboard.set_key_state(super.keyboard.Key.F2, state),
            0x03D => self.keyboard.set_key_state(super.keyboard.Key.F3, state),
            0x03E => self.keyboard.set_key_state(super.keyboard.Key.F4, state),
            0x03F => self.keyboard.set_key_state(super.keyboard.Key.F5, state),
            0x040 => self.keyboard.set_key_state(super.keyboard.Key.F6, state),
            0x041 => self.keyboard.set_key_state(super.keyboard.Key.F7, state),
            0x042 => self.keyboard.set_key_state(super.keyboard.Key.F8, state),
            0x043 => self.keyboard.set_key_state(super.keyboard.Key.F9, state),
            0x044 => self.keyboard.set_key_state(super.keyboard.Key.F10, state),
            0x057 => self.keyboard.set_key_state(super.keyboard.Key.F11, state),
            0x058 => self.keyboard.set_key_state(super.keyboard.Key.F12, state),
            0x150 => self.keyboard.set_key_state(super.keyboard.Key.Down, state),
            0x14B => self.keyboard.set_key_state(super.keyboard.Key.Left, state),
            0x14D => self.keyboard.set_key_state(super.keyboard.Key.Right, state),
            0x148 => self.keyboard.set_key_state(super.keyboard.Key.Up, state),
            0x028 => self.keyboard.set_key_state(super.keyboard.Key.Apostrophe, state),
            0x029 => self.keyboard.set_key_state(super.keyboard.Key.Backquote, state),
            0x02B => self.keyboard.set_key_state(super.keyboard.Key.Backslash, state),
            0x033 => self.keyboard.set_key_state(super.keyboard.Key.Comma, state),
            0x00D => self.keyboard.set_key_state(super.keyboard.Key.Equal, state),
            0x01A => self.keyboard.set_key_state(super.keyboard.Key.LeftBracket, state),
            0x00C => self.keyboard.set_key_state(super.keyboard.Key.Minus, state),
            0x034 => self.keyboard.set_key_state(super.keyboard.Key.Period, state),
            0x01B => self.keyboard.set_key_state(super.keyboard.Key.RightBracket, state),
            0x027 => self.keyboard.set_key_state(super.keyboard.Key.Semicolon, state),
            0x035 => self.keyboard.set_key_state(super.keyboard.Key.Slash, state),
            0x00E => self.keyboard.set_key_state(super.keyboard.Key.Backspace, state),
            0x153 => self.keyboard.set_key_state(super.keyboard.Key.Delete, state),
            0x14F => self.keyboard.set_key_state(super.keyboard.Key.End, state),
            0x01C => self.keyboard.set_key_state(super.keyboard.Key.Enter, state),
            0x001 => self.keyboard.set_key_state(super.keyboard.Key.Escape, state),
            0x147 => self.keyboard.set_key_state(super.keyboard.Key.Home, state),
            0x152 => self.keyboard.set_key_state(super.keyboard.Key.Insert, state),
            0x15D => self.keyboard.set_key_state(super.keyboard.Key.Menu, state),
            0x151 => self.keyboard.set_key_state(super.keyboard.Key.PageDown, state),
            0x149 => self.keyboard.set_key_state(super.keyboard.Key.PageUp, state),
            0x045 => self.keyboard.set_key_state(super.keyboard.Key.Pause, state),
            0x039 => self.keyboard.set_key_state(super.keyboard.Key.Space, state),
            0x00F => self.keyboard.set_key_state(super.keyboard.Key.Tab, state),
            0x145 => self.keyboard.set_key_state(super.keyboard.Key.NumLock, state),
            0x03A => self.keyboard.set_key_state(super.keyboard.Key.CapsLock, state),
            0x046 => self.keyboard.set_key_state(super.keyboard.Key.ScrollLock, state),
            0x02A => self.keyboard.set_key_state(super.keyboard.Key.LeftShift, state),
            0x036 => self.keyboard.set_key_state(super.keyboard.Key.RightShift, state),
            0x01D => self.keyboard.set_key_state(super.keyboard.Key.LeftCtrl, state),
            0x11D => self.keyboard.set_key_state(super.keyboard.Key.RightCtrl, state),
            0x052 => self.keyboard.set_key_state(super.keyboard.Key.NumPad0, state),
            0x04F => self.keyboard.set_key_state(super.keyboard.Key.NumPad1, state),
            0x050 => self.keyboard.set_key_state(super.keyboard.Key.NumPad2, state),
            0x051 => self.keyboard.set_key_state(super.keyboard.Key.NumPad3, state),
            0x04B => self.keyboard.set_key_state(super.keyboard.Key.NumPad4, state),
            0x04C => self.keyboard.set_key_state(super.keyboard.Key.NumPad5, state),
            0x04D => self.keyboard.set_key_state(super.keyboard.Key.NumPad6, state),
            0x047 => self.keyboard.set_key_state(super.keyboard.Key.NumPad7, state),
            0x048 => self.keyboard.set_key_state(super.keyboard.Key.NumPad8, state),
            0x049 => self.keyboard.set_key_state(super.keyboard.Key.NumPad9, state),
            0x053 => self.keyboard.set_key_state(super.keyboard.Key.NumPadDot, state),
            0x135 => self.keyboard.set_key_state(super.keyboard.Key.NumPadSlash, state),
            0x037 => self.keyboard.set_key_state(super.keyboard.Key.NumPadAsterisk, state),
            0x04A => self.keyboard.set_key_state(super.keyboard.Key.NumPadMinus, state),
            0x04E => self.keyboard.set_key_state(super.keyboard.Key.NumPadPlus, state),
            0x11C => self.keyboard.set_key_state(super.keyboard.Key.NumPadEnter, state),
            else => {},
        }
    }

    fn message_loop(self: *const Self) void {
        var msg: MSG = undefined;

        while (PeekMessageW(&msg, self.handle, 0, 0, PM_REMOVE) == TRUE) {
            if (msg.message == WM_QUIT) break;
            _ = TranslateMessage(&msg);
            _ = DispatchMessageW(&msg);
        }
    }

    pub fn update(self: *Self) void {

        /// TODO handle an error here
        _ = SetWindowLongPtrW(result.handle, GWLP_USERDATA, @ptrToInt(result));

        self.keyboard.update();
        self.message_loop();
    }

};






