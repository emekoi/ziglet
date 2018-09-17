//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
pub use @import("winapi.zig");

pub fn to_wstring(str: []const u8) ![512]u16 {
    var result: [512]u16 = undefined;

    const end_index = try std.unicode.utf8ToUtf16Le(result[0..], str);
    std.debug.assert(end_index < result.len);
    result[end_index] = 0;
    
    return result;
}


pub const Window = struct {
    const Self = this;
    
    window_class: WNDCLASS,
    window_handle: HWND,
    device_context: HDC,
    should_close: bool,
    width: i32,
    height: i32,

    pub const WindowError = error {
        CreateError,
        CloseError,
    };

    export stdcallcc fn wnd_proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
        var result: LRESULT = 0;

        var window = @intToPtr(?*Self, GetWindowLongPtrW(hWnd, GWLP_USERDATA)) orelse return DefWindowProcW(hWnd, msg, wParam, lParam);

        switch (msg) {
            WM_CLOSE => window.should_close = true,
            WM_KEYDOWN => {},
            WM_KEYUP => {},
            else => return DefWindowProcW(hWnd, msg, wParam, lParam),
        }

        return result;
    }

    pub fn new(title: []const u8, width: i32, height: i32) !Self {
        var result: Self = undefined;

        const wtitle = try to_wstring(title);

        // result.window_class = WNDCLASS {
        //     .style = CS_OWNDC | CS_VREDRAW | CS_HREDRAW,
        //     .lpfnWndProc = &Self.wnd_proc,
        //     .cbClsExtra = 0,
        //     .cbWndExtra = 0,
        //     .hInstance = undefined,
        //     .hIcon = undefined,
        //     .hCursor = undefined, // LoadCursorW(null, IDC_ARROW) orelse return error.CreateError;
        //     .hbrBackground = undefined,
        //     .lpszMenuName = undefined,
        //     .lpszClassName = wtitle[0..].ptr,
        // };


        result.window_class.style = CS_OWNDC | CS_VREDRAW | CS_HREDRAW;
        result.window_class.lpfnWndProc = &Self.wnd_proc;
        result.window_class.hCursor = LoadCursorW(null, IDC_ARROW) orelse return error.CreateError;
        result.window_class.lpszClassName = wtitle[0..].ptr;

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

        std.debug.warn("GAT\n");

        rect.right -= rect.left;
        rect.bottom -= rect.top;

        result.width = width;
        result.height = height;
        
        std.debug.warn("BAR\n");

        result.window_handle = CreateWindowExW(0, 
            wtitle[0..].ptr, wtitle[0..].ptr,
            WS_OVERLAPPEDWINDOW & ~WS_MAXIMIZEBOX & ~WS_THICKFRAME,
            CW_USEDEFAULT, CW_USEDEFAULT,
            rect.right, rect.bottom,
            null, null, null, null
        ) orelse return error.CreateError;

        std.debug.warn("FOO\n");


        _ = ShowWindow(result.window_handle, SW_NORMAL);

        result.device_context = GetDC(result.window_handle) orelse return error.CreateError;

        return result;
    }

    pub fn generic_update(self: *Self) void {
        _ = SetWindowLongPtrW(self.window_handle, GWLP_USERDATA, @ptrToInt(self));
    }

    pub fn message_loop(self: *Self) void {
        var msg: MSG = undefined;

        while (PeekMessageW(&msg, self.window_handle, 0, 0, PM_REMOVE) == TRUE) {
            if (msg.message == WM_QUIT) break;
            _ = TranslateMessage(&msg);
            _ = DispatchMessageW(&msg);
        }
    }

    pub fn update(self: *Self) void {
        self.generic_update();
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
};
