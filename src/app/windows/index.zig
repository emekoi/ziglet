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

    // private implementation stuff
    handle: HWND,

    pub fullscreen: bool,
    pub borderless: bool,
    pub resizeable: bool,
    pub width: isize,
    pub height: isize,
    pub title: []const u8,
    pub should_close: bool,

    stdcallcc fn wnd_proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
        var result: LRESULT = 0;

        var self = @intToPtr(?*Self, GetWindowLongPtrW(hWnd, GWLP_USERDATA)) orelse {
            return DefWindowProcW(hWnd, msg, wParam, lParam);
        };

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

    fn open_window(options: Options) Error!HWND {
        const wtitle = util.L(options.title)[0..(options.title.len + 1)];

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
        ) orelse {
            std.debug.warn("CreateWindowExW {}\n", GetLastError());
            return error.InitError;
        };
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
        };

        errdefer result.deinit();

        result.handle = try open_window(options);
        _ = ShowWindow(result.handle, SW_NORMAL);
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
        _ = SetWindowLongPtrW(self.handle, GWLP_USERDATA, @ptrToInt(self));

        self.message_loop();
    }

};






