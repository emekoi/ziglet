//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

use @import("native.zig");

const std = @import("std");
const util = @import("util.zig");
const super = @import("../index.zig");

pub const Window = struct.{
    const Self = @This();

    pub const Error = error.{
        InitError,
        ShutdownError,
        SetError,
    };

    pub const Options = struct.{
        backend: super.RenderBackend,
        fullscreen: bool,
        borderless: bool,
        resizeable: bool,
        width: isize,
        height: isize,
        title: []const u8,
    };

    handle: HWND,

    fullscreen: bool,
    borderless: bool,
    resizeable: bool,
    width: isize,
    height: isize,
    title: []const u8,
    pub should_close: bool,

    pub keyboard: super.Keyboard,

    stdcallcc fn wnd_proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
        var result: LRESULT = 0;

        var self = @intToPtr(?*Self, GetWindowLongPtrW(hWnd, GWLP_USERDATA)) orelse {
            return DefWindowProcW(hWnd, msg, wParam, lParam);
        };

        switch (msg) {
            WM_CLOSE, WM_DESTROY, WM_QUIT => {
                std.debug.warn("cisab: {}\n", @ptrToInt(self));
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

    fn open_window(options: Options) Error!HWND {
        const wtitle = util.L(options.title)[0..];

        const wcex = WNDCLASSEX.{
            .cbSize = @sizeOf(WNDCLASSEX),
            .style = CS_HREDRAW | CS_VREDRAW | CS_OWNDC,
            .lpfnWndProc = wnd_proc,
            .cbClsExtra = 0,
            .cbWndExtra = 0,
            .hInstance = GetModuleHandleW(null),
            .hIcon = LoadIconW(null, IDI_WINLOGO).?,
            .hCursor = LoadCursorW(null, IDC_ARROW).?,
            .hbrBackground = null,
            .lpszMenuName = null,
            .lpszClassName = wtitle.ptr,
            .hIconSm = null,
        };

        if (RegisterClassExW(&wcex) == 0) {
            return error.InitError;
        }

        var rect = RECT.{
            .left = 0,
            .right = @truncate(c_int, options.width),
            .top = 0,
            .bottom = @truncate(c_int, options.height),
        };

        var dwExStyle: u32 = 0;
        var dwStyle: u32 = WS_CLIPSIBLINGS | WS_CLIPCHILDREN;

        if (options.fullscreen) {
            var dmScreenSettings: DEVMODEW = undefined;
            dmScreenSettings.dmSize = @sizeOf(DEVMODEW);
            dmScreenSettings.dmPelsWidth = @intCast(u32, options.width);
            dmScreenSettings.dmPelsHeight = @intCast(u32, options.height);
            dmScreenSettings.dmBitsPerPel = 32;
            dmScreenSettings.dmFields = DM_BITSPERPEL | DM_PELSWIDTH | DM_PELSHEIGHT;
            if (ChangeDisplaySettingsW(&dmScreenSettings, CDS_FULLSCREEN) != 0) {
                return error.InitError;
            } else {
                dwExStyle = WS_EX_APPWINDOW;
                dwStyle |= WS_POPUP;
                _ = ShowCursor(FALSE);
            }
        } else {
            dwExStyle = WS_EX_APPWINDOW | WS_EX_WINDOWEDGE | WS_EX_ACCEPTFILES;
            dwStyle |= DWORD(WS_OVERLAPPEDWINDOW);

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

        rect.right -= rect.left;
        rect.bottom -= rect.top;

        return CreateWindowExW(dwExStyle,
            wtitle.ptr, wtitle.ptr, dwStyle,
            CW_USEDEFAULT, CW_USEDEFAULT, rect.right, rect.bottom,
            null, null, wcex.hInstance, null
        ) orelse return error.InitError;
    }

    pub fn init(options: Options) !Self {
        var result = Self.{
            .handle = undefined,
            .fullscreen = options.fullscreen,
            .borderless = options.borderless,
            .resizeable = options.resizeable,
            .width = options.width,
            .height = options.height,
            .title = options.title,
            .should_close = false,
            .keyboard = super.Keyboard.new(),
        };

        errdefer result.deinit();

        result.handle = try open_window(options);
        _ = ShowWindow(result.handle, SW_NORMAL);
        _ = SetWindowLongPtrW(result.handle, GWLP_USERDATA, @ptrToInt(&result));

        result.fullscreen = true;
        std.debug.warn("creat: {}\n", @ptrToInt(&result));
        return result;
    }

    pub fn deinit(self: Self) void {
        if (self.fullscreen) {
            _ = ChangeDisplaySettingsW(null, 0);
            _ = ShowCursor(TRUE);
        }
        _ = UnregisterClassW(util.L(self.title)[0..].ptr, GetModuleHandleW(null));
    }

    fn update_keyboard(self: *Self, wparam: usize, state: bool) void {
        switch (wparam & 0x1ff) {
            0x00B => self.keyboard.set_key(super.Key.Key0, state),
            0x002 => self.keyboard.set_key(super.Key.Key1, state),
            0x003 => self.keyboard.set_key(super.Key.Key2, state),
            0x004 => self.keyboard.set_key(super.Key.Key3, state),
            0x005 => self.keyboard.set_key(super.Key.Key4, state),
            0x006 => self.keyboard.set_key(super.Key.Key5, state),
            0x007 => self.keyboard.set_key(super.Key.Key6, state),
            0x008 => self.keyboard.set_key(super.Key.Key7, state),
            0x009 => self.keyboard.set_key(super.Key.Key8, state),
            0x00A => self.keyboard.set_key(super.Key.Key9, state),
            0x01E => self.keyboard.set_key(super.Key.A, state),
            0x030 => self.keyboard.set_key(super.Key.B, state),
            0x02E => self.keyboard.set_key(super.Key.C, state),
            0x020 => self.keyboard.set_key(super.Key.D, state),
            0x012 => self.keyboard.set_key(super.Key.E, state),
            0x021 => self.keyboard.set_key(super.Key.F, state),
            0x022 => self.keyboard.set_key(super.Key.G, state),
            0x023 => self.keyboard.set_key(super.Key.H, state),
            0x017 => self.keyboard.set_key(super.Key.I, state),
            0x024 => self.keyboard.set_key(super.Key.J, state),
            0x025 => self.keyboard.set_key(super.Key.K, state),
            0x026 => self.keyboard.set_key(super.Key.L, state),
            0x032 => self.keyboard.set_key(super.Key.M, state),
            0x031 => self.keyboard.set_key(super.Key.N, state),
            0x018 => self.keyboard.set_key(super.Key.O, state),
            0x019 => self.keyboard.set_key(super.Key.P, state),
            0x010 => self.keyboard.set_key(super.Key.Q, state),
            0x013 => self.keyboard.set_key(super.Key.R, state),
            0x01F => self.keyboard.set_key(super.Key.S, state),
            0x014 => self.keyboard.set_key(super.Key.T, state),
            0x016 => self.keyboard.set_key(super.Key.U, state),
            0x02F => self.keyboard.set_key(super.Key.V, state),
            0x011 => self.keyboard.set_key(super.Key.W, state),
            0x02D => self.keyboard.set_key(super.Key.X, state),
            0x015 => self.keyboard.set_key(super.Key.Y, state),
            0x02C => self.keyboard.set_key(super.Key.Z, state),
            0x03B => self.keyboard.set_key(super.Key.F1, state),
            0x03C => self.keyboard.set_key(super.Key.F2, state),
            0x03D => self.keyboard.set_key(super.Key.F3, state),
            0x03E => self.keyboard.set_key(super.Key.F4, state),
            0x03F => self.keyboard.set_key(super.Key.F5, state),
            0x040 => self.keyboard.set_key(super.Key.F6, state),
            0x041 => self.keyboard.set_key(super.Key.F7, state),
            0x042 => self.keyboard.set_key(super.Key.F8, state),
            0x043 => self.keyboard.set_key(super.Key.F9, state),
            0x044 => self.keyboard.set_key(super.Key.F10, state),
            0x057 => self.keyboard.set_key(super.Key.F11, state),
            0x058 => self.keyboard.set_key(super.Key.F12, state),
            0x150 => self.keyboard.set_key(super.Key.Down, state),
            0x14B => self.keyboard.set_key(super.Key.Left, state),
            0x14D => self.keyboard.set_key(super.Key.Right, state),
            0x148 => self.keyboard.set_key(super.Key.Up, state),
            0x028 => self.keyboard.set_key(super.Key.Apostrophe, state),
            0x029 => self.keyboard.set_key(super.Key.Backquote, state),
            0x02B => self.keyboard.set_key(super.Key.Backslash, state),
            0x033 => self.keyboard.set_key(super.Key.Comma, state),
            0x00D => self.keyboard.set_key(super.Key.Equal, state),
            0x01A => self.keyboard.set_key(super.Key.LeftBracket, state),
            0x00C => self.keyboard.set_key(super.Key.Minus, state),
            0x034 => self.keyboard.set_key(super.Key.Period, state),
            0x01B => self.keyboard.set_key(super.Key.RightBracket, state),
            0x027 => self.keyboard.set_key(super.Key.Semicolon, state),
            0x035 => self.keyboard.set_key(super.Key.Slash, state),
            0x00E => self.keyboard.set_key(super.Key.Backspace, state),
            0x153 => self.keyboard.set_key(super.Key.Delete, state),
            0x14F => self.keyboard.set_key(super.Key.End, state),
            0x01C => self.keyboard.set_key(super.Key.Enter, state),
            0x001 => self.keyboard.set_key(super.Key.Escape, state),
            0x147 => self.keyboard.set_key(super.Key.Home, state),
            0x152 => self.keyboard.set_key(super.Key.Insert, state),
            0x15D => self.keyboard.set_key(super.Key.Menu, state),
            0x151 => self.keyboard.set_key(super.Key.PageDown, state),
            0x149 => self.keyboard.set_key(super.Key.PageUp, state),
            0x045 => self.keyboard.set_key(super.Key.Pause, state),
            0x039 => self.keyboard.set_key(super.Key.Space, state),
            0x00F => self.keyboard.set_key(super.Key.Tab, state),
            0x145 => self.keyboard.set_key(super.Key.NumLock, state),
            0x03A => self.keyboard.set_key(super.Key.CapsLock, state),
            0x046 => self.keyboard.set_key(super.Key.ScrollLock, state),
            0x02A => self.keyboard.set_key(super.Key.LeftShift, state),
            0x036 => self.keyboard.set_key(super.Key.RightShift, state),
            0x01D => self.keyboard.set_key(super.Key.LeftCtrl, state),
            0x11D => self.keyboard.set_key(super.Key.RightCtrl, state),
            0x052 => self.keyboard.set_key(super.Key.NumPad0, state),
            0x04F => self.keyboard.set_key(super.Key.NumPad1, state),
            0x050 => self.keyboard.set_key(super.Key.NumPad2, state),
            0x051 => self.keyboard.set_key(super.Key.NumPad3, state),
            0x04B => self.keyboard.set_key(super.Key.NumPad4, state),
            0x04C => self.keyboard.set_key(super.Key.NumPad5, state),
            0x04D => self.keyboard.set_key(super.Key.NumPad6, state),
            0x047 => self.keyboard.set_key(super.Key.NumPad7, state),
            0x048 => self.keyboard.set_key(super.Key.NumPad8, state),
            0x049 => self.keyboard.set_key(super.Key.NumPad9, state),
            0x053 => self.keyboard.set_key(super.Key.NumPadDot, state),
            0x135 => self.keyboard.set_key(super.Key.NumPadSlash, state),
            0x037 => self.keyboard.set_key(super.Key.NumPadAsterisk, state),
            0x04A => self.keyboard.set_key(super.Key.NumPadMinus, state),
            0x04E => self.keyboard.set_key(super.Key.NumPadPlus, state),
            0x11C => self.keyboard.set_key(super.Key.NumPadEnter, state),
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
        if (self.fullscreen) {
            std.debug.warn("debug: {}\n", @ptrToInt(&self));
            self.fullscreen = false;
        }

        self.keyboard.update();
        self.message_loop();
        // std.debug.warn("kill who?");
    }

    pub fn get_fullscreen(self: *const Self) bool {
        return self.fullscreen;
    }

    pub fn get_borderless(self: *const Self) bool {
        return self.borderless;
    }

    pub fn get_resizeable(self: *const Self) bool {
        return self.resizeable;
    }

    pub fn get_width(self: *const Self) isize {
        return self.width;
    }

    pub fn get_height(self: *const Self) isize {
        return self.height;
    }

    pub fn get_title(self: *const Self) []const u8 {
        return self.title;
    }

    pub fn set_title(self: *Self, title: []const u8) !void {
        self.title = title;
        const wtitle = util.L(self.title)[0..];
        if (SetWindowTextW(self.handle, wtitle.ptr) == FALSE) {
            return error.SetError;
        }
    }
};
