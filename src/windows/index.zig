//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const util = @import("util.zig");
pub use @import("input.zig");
pub use @import("winapi.zig");

pub const Window = struct {
    const Self = @This();
    
    window_class: WNDCLASS,
    window_handle: HWND,
    device_context: HDC,
    keyboard: Keyboard,
    should_close: bool,
    width: i32,
    height: i32,

    pub const WindowError = error {
        CreateError,
        CloseError,
    };

    export stdcallcc fn wnd_proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
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

    pub fn new(title: []const u8, width: i32, height: i32) !Self {
        var result: Self = undefined;

        const wtitle = try util.to_wstring(title);

        result.window_class.style = CS_OWNDC | CS_VREDRAW | CS_HREDRAW;
        result.window_class.lpfnWndProc = Self.wnd_proc;
        result.window_class.hCursor = LoadCursorW(null, IDC_ARROW) orelse return error.CreateError;
        result.window_class.lpszClassName = wtitle[0..].ptr;
        result.window_class.hInstance = GetModuleHandleW(null);

        if (RegisterClassW(&result.window_class) == 0) {
            return error.CreateError;
        }

        var rect = RECT {
            .left = 0,
            .right = width,
            .top = 0,
            .bottom = height,
        };

        if (AdjustWindowRect(&rect, WS_POPUP | WS_SYSMENU | WS_CAPTION, FALSE) == 0) {
            return error.CreateError;
        }

        rect.right -= rect.left;
        rect.bottom -= rect.top;

        result.width = width;
        result.height = height;

        result.window_handle = CreateWindowExW(0, 
            wtitle[0..].ptr, wtitle[0..].ptr,
            WS_OVERLAPPEDWINDOW & ~WS_MAXIMIZEBOX & ~WS_THICKFRAME,
            CW_USEDEFAULT, CW_USEDEFAULT, rect.right, rect.bottom,
            null, null, result.window_class.hInstance, null
        ) orelse return error.CreateError;

        _ = ShowWindow(result.window_handle, SW_NORMAL);

        result.device_context = GetDC(result.window_handle) orelse return error.CreateError;

        result.keyboard = Keyboard {
            .keys = []bool{false} ** 512
        };

        return result;
    }

    fn update_keyboard(self: *Self, wparam: usize, state: bool) void {
        switch (wparam & 0x1ff) {
            0x00B => self.keyboard.set_key_state(Key.Key0, state),
            0x002 => self.keyboard.set_key_state(Key.Key1, state),
            0x003 => self.keyboard.set_key_state(Key.Key2, state),
            0x004 => self.keyboard.set_key_state(Key.Key3, state),
            0x005 => self.keyboard.set_key_state(Key.Key4, state),
            0x006 => self.keyboard.set_key_state(Key.Key5, state),
            0x007 => self.keyboard.set_key_state(Key.Key6, state),
            0x008 => self.keyboard.set_key_state(Key.Key7, state),
            0x009 => self.keyboard.set_key_state(Key.Key8, state),
            0x00A => self.keyboard.set_key_state(Key.Key9, state),
            0x01E => self.keyboard.set_key_state(Key.A, state),
            0x030 => self.keyboard.set_key_state(Key.B, state),
            0x02E => self.keyboard.set_key_state(Key.C, state),
            0x020 => self.keyboard.set_key_state(Key.D, state),
            0x012 => self.keyboard.set_key_state(Key.E, state),
            0x021 => self.keyboard.set_key_state(Key.F, state),
            0x022 => self.keyboard.set_key_state(Key.G, state),
            0x023 => self.keyboard.set_key_state(Key.H, state),
            0x017 => self.keyboard.set_key_state(Key.I, state),
            0x024 => self.keyboard.set_key_state(Key.J, state),
            0x025 => self.keyboard.set_key_state(Key.K, state),
            0x026 => self.keyboard.set_key_state(Key.L, state),
            0x032 => self.keyboard.set_key_state(Key.M, state),
            0x031 => self.keyboard.set_key_state(Key.N, state),
            0x018 => self.keyboard.set_key_state(Key.O, state),
            0x019 => self.keyboard.set_key_state(Key.P, state),
            0x010 => self.keyboard.set_key_state(Key.Q, state),
            0x013 => self.keyboard.set_key_state(Key.R, state),
            0x01F => self.keyboard.set_key_state(Key.S, state),
            0x014 => self.keyboard.set_key_state(Key.T, state),
            0x016 => self.keyboard.set_key_state(Key.U, state),
            0x02F => self.keyboard.set_key_state(Key.V, state),
            0x011 => self.keyboard.set_key_state(Key.W, state),
            0x02D => self.keyboard.set_key_state(Key.X, state),
            0x015 => self.keyboard.set_key_state(Key.Y, state),
            0x02C => self.keyboard.set_key_state(Key.Z, state),
            0x03B => self.keyboard.set_key_state(Key.F1, state),
            0x03C => self.keyboard.set_key_state(Key.F2, state),
            0x03D => self.keyboard.set_key_state(Key.F3, state),
            0x03E => self.keyboard.set_key_state(Key.F4, state),
            0x03F => self.keyboard.set_key_state(Key.F5, state),
            0x040 => self.keyboard.set_key_state(Key.F6, state),
            0x041 => self.keyboard.set_key_state(Key.F7, state),
            0x042 => self.keyboard.set_key_state(Key.F8, state),
            0x043 => self.keyboard.set_key_state(Key.F9, state),
            0x044 => self.keyboard.set_key_state(Key.F10, state),
            0x057 => self.keyboard.set_key_state(Key.F11, state),
            0x058 => self.keyboard.set_key_state(Key.F12, state),
            0x150 => self.keyboard.set_key_state(Key.Down, state),
            0x14B => self.keyboard.set_key_state(Key.Left, state),
            0x14D => self.keyboard.set_key_state(Key.Right, state),
            0x148 => self.keyboard.set_key_state(Key.Up, state),
            0x028 => self.keyboard.set_key_state(Key.Apostrophe, state),
            0x029 => self.keyboard.set_key_state(Key.Backquote, state),
            0x02B => self.keyboard.set_key_state(Key.Backslash, state),
            0x033 => self.keyboard.set_key_state(Key.Comma, state),
            0x00D => self.keyboard.set_key_state(Key.Equal, state),
            0x01A => self.keyboard.set_key_state(Key.LeftBracket, state),
            0x00C => self.keyboard.set_key_state(Key.Minus, state),
            0x034 => self.keyboard.set_key_state(Key.Period, state),
            0x01B => self.keyboard.set_key_state(Key.RightBracket, state),
            0x027 => self.keyboard.set_key_state(Key.Semicolon, state),
            0x035 => self.keyboard.set_key_state(Key.Slash, state),
            0x00E => self.keyboard.set_key_state(Key.Backspace, state),
            0x153 => self.keyboard.set_key_state(Key.Delete, state),
            0x14F => self.keyboard.set_key_state(Key.End, state),
            0x01C => self.keyboard.set_key_state(Key.Enter, state),
            0x001 => self.keyboard.set_key_state(Key.Escape, state),
            0x147 => self.keyboard.set_key_state(Key.Home, state),
            0x152 => self.keyboard.set_key_state(Key.Insert, state),
            0x15D => self.keyboard.set_key_state(Key.Menu, state),
            0x151 => self.keyboard.set_key_state(Key.PageDown, state),
            0x149 => self.keyboard.set_key_state(Key.PageUp, state),
            0x045 => self.keyboard.set_key_state(Key.Pause, state),
            0x039 => self.keyboard.set_key_state(Key.Space, state),
            0x00F => self.keyboard.set_key_state(Key.Tab, state),
            0x145 => self.keyboard.set_key_state(Key.NumLock, state),
            0x03A => self.keyboard.set_key_state(Key.CapsLock, state),
            0x046 => self.keyboard.set_key_state(Key.ScrollLock, state),
            0x02A => self.keyboard.set_key_state(Key.LeftShift, state),
            0x036 => self.keyboard.set_key_state(Key.RightShift, state),
            0x01D => self.keyboard.set_key_state(Key.LeftCtrl, state),
            0x11D => self.keyboard.set_key_state(Key.RightCtrl, state),
            0x052 => self.keyboard.set_key_state(Key.NumPad0, state),
            0x04F => self.keyboard.set_key_state(Key.NumPad1, state),
            0x050 => self.keyboard.set_key_state(Key.NumPad2, state),
            0x051 => self.keyboard.set_key_state(Key.NumPad3, state),
            0x04B => self.keyboard.set_key_state(Key.NumPad4, state),
            0x04C => self.keyboard.set_key_state(Key.NumPad5, state),
            0x04D => self.keyboard.set_key_state(Key.NumPad6, state),
            0x047 => self.keyboard.set_key_state(Key.NumPad7, state),
            0x048 => self.keyboard.set_key_state(Key.NumPad8, state),
            0x049 => self.keyboard.set_key_state(Key.NumPad9, state),
            0x053 => self.keyboard.set_key_state(Key.NumPadDot, state),
            0x135 => self.keyboard.set_key_state(Key.NumPadSlash, state),
            0x037 => self.keyboard.set_key_state(Key.NumPadAsterisk, state),
            0x04A => self.keyboard.set_key_state(Key.NumPadMinus, state),
            0x04E => self.keyboard.set_key_state(Key.NumPadPlus, state),
            0x11C => self.keyboard.set_key_state(Key.NumPadEnter, state),
            else => {},
        }
    }

    fn update_generic(self: *Self) void {
        _ = SetWindowLongPtrW(self.window_handle, GWLP_USERDATA, @ptrToInt(self));
    }

    fn message_loop(self: *Self) void {
        var msg: MSG = undefined;

        while (PeekMessageW(&msg, self.window_handle, 0, 0, PM_REMOVE) == TRUE) {
            if (msg.message == WM_QUIT) break;
            _ = TranslateMessage(&msg);
            _ = DispatchMessageW(&msg);
        }
    }

    pub fn update(self: *Self) void {
        self.update_generic();
        self.message_loop();
    }

    pub fn close(self: *Self) !void {
        if (ReleaseDC(self.window_handle, self.device_context) != 1) {
            return error.CloseError;
        }
        if (DestroyWindow(self.window_handle) == 0) {
            return error.CloseError;
        }
    }

    pub fn is_down(self: *Self, key: Key) bool {
        return self.keyboard.is_down(key);
    }
};
