//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const ziglet = @import("../ziglet.zig");
const internals = @import("../internals.zig");
const native = @import("windows/native.zig");

const mem = std.mem;
const app = ziglet.app;
const assert = std.debug.assert;

pub const Event = app.event.Event;
pub const Key = app.event.Key;
pub const MouseButton = app.event.MouseButton;

const Backend = union(ziglet.gfx.RenderBackend) {
    OpenGL: @import("backend/opengl.zig").Context,
    DirectX11: @import("backend/directx.zig").Context,
};

fn intToKey(lParam: native.LPARAM) Key {
    return switch (lParam & 0x1ff) {
        0x00B => Key.Key0,
        0x002 => Key.Key1,
        0x003 => Key.Key2,
        0x004 => Key.Key3,
        0x005 => Key.Key4,
        0x006 => Key.Key5,
        0x007 => Key.Key6,
        0x008 => Key.Key7,
        0x009 => Key.Key8,
        0x00A => Key.Key9,
        0x01E => Key.A,
        0x030 => Key.B,
        0x02E => Key.C,
        0x020 => Key.D,
        0x012 => Key.E,
        0x021 => Key.F,
        0x022 => Key.G,
        0x023 => Key.H,
        0x017 => Key.I,
        0x024 => Key.J,
        0x025 => Key.K,
        0x026 => Key.L,
        0x032 => Key.M,
        0x031 => Key.N,
        0x018 => Key.O,
        0x019 => Key.P,
        0x010 => Key.Q,
        0x013 => Key.R,
        0x01F => Key.S,
        0x014 => Key.T,
        0x016 => Key.U,
        0x02F => Key.V,
        0x011 => Key.W,
        0x02D => Key.X,
        0x015 => Key.Y,
        0x02C => Key.Z,
        0x03B => Key.F1,
        0x03C => Key.F2,
        0x03D => Key.F3,
        0x03E => Key.F4,
        0x03F => Key.F5,
        0x040 => Key.F6,
        0x041 => Key.F7,
        0x042 => Key.F8,
        0x043 => Key.F9,
        0x044 => Key.F10,
        0x057 => Key.F11,
        0x058 => Key.F12,
        0x150 => Key.Down,
        0x14B => Key.Left,
        0x14D => Key.Right,
        0x148 => Key.Up,
        0x028 => Key.Apostrophe,
        0x029 => Key.Backquote,
        0x02B => Key.Backslash,
        0x033 => Key.Comma,
        0x00D => Key.Equal,
        0x01A => Key.LeftBracket,
        0x00C => Key.Minus,
        0x034 => Key.Period,
        0x01B => Key.RightBracket,
        0x027 => Key.Semicolon,
        0x035 => Key.Slash,
        0x00E => Key.Backspace,
        0x153 => Key.Delete,
        0x14F => Key.End,
        0x01C => Key.Enter,
        0x001 => Key.Escape,
        0x147 => Key.Home,
        0x152 => Key.Insert,
        0x15D => Key.Menu,
        0x151 => Key.PageDown,
        0x149 => Key.PageUp,
        0x045 => Key.Pause,
        0x039 => Key.Space,
        0x00F => Key.Tab,
        0x145 => Key.NumLock,
        0x03A => Key.CapsLock,
        0x046 => Key.ScrollLock,
        0x02A => Key.LeftShift,
        0x036 => Key.RightShift,
        0x01D => Key.LeftControl,
        0x11D => Key.RightControl,
        0x052 => Key.Kp0,
        0x04F => Key.Kp1,
        0x050 => Key.Kp2,
        0x051 => Key.Kp3,
        0x04B => Key.Kp4,
        0x04C => Key.Kp5,
        0x04D => Key.Kp6,
        0x047 => Key.Kp7,
        0x048 => Key.Kp8,
        0x049 => Key.Kp9,
        0x053 => Key.KpDecimal,
        0x135 => Key.KpDivide,
        0x037 => Key.KpMultiply,
        0x04A => Key.KpSubtract,
        0x04E => Key.KpMultiply,
        0x11C => Key.KpEnter,
        0x038 => Key.LeftAlt,
        0x138 => Key.RightAlt,
        else => Key.Unknown,
    };
}

pub const WindowImpl = struct {
    handle: native.HWND,

    fn window_resized(self: *WindowImpl) ?[2]i32 {
        var w = @fieldParentPtr(app.Window, "impl", self);
        var rect: native.RECT = undefined;
        if (native.GetClientRect(self.handle, &rect) == native.TRUE) {
            const new_width = @intCast(usize, rect.right - rect.left);
            const new_height = @intCast(usize, rect.bottom - rect.top);
            if ((new_width != w.options.width) or (new_height != w.options.height)) {
                w.options.width = new_width;
                w.options.height = new_height;
                return []i32{
                    @intCast(i32, new_width),
                    @intCast(i32, new_height),
                };
            }
        } else {
            w.options.width = 1;
            w.options.height = 1;
        }
        return null;
    }

    stdcallcc fn wnd_proc(hWnd: native.HWND, msg: native.UINT, wParam: native.WPARAM, lParam: native.LPARAM) native.LRESULT {
        var result: native.LRESULT = 0;

        var self = @intToPtr(?*WindowImpl, native.GetWindowLongPtrW(hWnd, native.GWLP_USERDATA)) orelse {
            return native.DefWindowProcW(hWnd, msg, wParam, lParam);
        };

        var window = @fieldParentPtr(app.Window, "impl", self);

        switch (msg) {
            native.WM_CLOSE => {
                window.should_close = true;
            },
            native.WM_SYSKEYDOWN, native.WM_KEYDOWN => {
                window.event_pump.push(Event{ .KeyDown = intToKey(lParam >> 16) }) catch unreachable;
            },
            native.WM_SYSKEYUP, native.WM_KEYUP => {
                window.event_pump.push(Event{ .KeyUp = intToKey(lParam >> 16) }) catch unreachable;
            },
            native.WM_SYSCHAR, native.WM_CHAR => {
                window.event_pump.push(Event{ .Char = @intCast(u8, wParam) }) catch unreachable;
            },
            native.WM_LBUTTONDOWN => {
                window.event_pump.push(Event{ .MouseDown = MouseButton.Left }) catch unreachable;
            },
            native.WM_RBUTTONDOWN => {
                window.event_pump.push(Event{ .MouseDown = MouseButton.Right }) catch unreachable;
            },
            native.WM_MBUTTONDOWN => {
                window.event_pump.push(Event{
                    .MouseDown = MouseButton.Middle,
                }) catch unreachable;
            },
            native.WM_LBUTTONUP => {
                window.event_pump.push(Event{ .MouseUp = MouseButton.Left }) catch unreachable;
            },
            native.WM_RBUTTONUP => {
                window.event_pump.push(Event{ .MouseUp = MouseButton.Right }) catch unreachable;
            },
            native.WM_MBUTTONUP => {
                window.event_pump.push(Event{
                    .MouseUp = MouseButton.Middle,
                }) catch unreachable;
            },
            native.WM_MOUSEWHEEL => {
                if (window.mouse_tracked) {
                    const scroll = @intToFloat(f32, @intCast(i16, @truncate(u16, (@truncate(u32, wParam) >> 16) & 0xffff))) * 0.1;
                    window.event_pump.push(Event{
                        .MouseScroll = []f32{ 0.0, scroll },
                    }) catch unreachable;
                }
            },
            native.WM_MOUSEHWHEEL => {
                if (window.mouse_tracked) {
                    const scroll = @intToFloat(f32, @intCast(i16, @truncate(u16, (@truncate(u32, wParam) >> 16) & 0xffff))) * 0.1;
                    window.event_pump.push(Event{
                        .MouseScroll = []f32{ scroll, 0.0 },
                    }) catch unreachable;
                }
            },
            native.WM_MOUSEMOVE => {
                if (!window.mouse_tracked) {
                    window.mouse_tracked = true;
                    var tme: native.TRACKMOUSEEVENT = undefined;
                    tme.cbSize = @sizeOf(native.TRACKMOUSEEVENT);
                    tme.dwFlags = native.TME_LEAVE;
                    tme.hwndTrack = self.handle;
                    assert(native.TrackMouseEvent(&tme) != 0);
                    window.event_pump.push(Event.MouseEnter) catch unreachable;
                }
                window.event_pump.push(Event{
                    .MouseMove = []f32{
                        @bitCast(f32, native.GET_X_LPARAM(lParam)),
                        @bitCast(f32, native.GET_Y_LPARAM(lParam)),
                    },
                }) catch unreachable;
            },
            native.WM_MOUSELEAVE => {
                window.mouse_tracked = false;
                window.event_pump.push(Event.MouseLeave) catch unreachable;
            },
            native.WM_SIZE => {
                const iconified = wParam == native.SIZE_MINIMIZED;
                if (iconified != window.iconified) {
                    window.iconified = iconified;
                    if (iconified) {
                        window.event_pump.push(Event.Iconified) catch unreachable;
                    } else {
                        window.event_pump.push(Event.Restored) catch unreachable;
                    }
                }
                if (self.window_resized()) |new_size| {
                    window.event_pump.push(Event{
                        .Resized = new_size,
                    }) catch unreachable;
                }
            },
            native.WM_DROPFILES => {
                const hDrop = @intToPtr(native.HDROP, wParam);
                const count = native.DragQueryFileW(hDrop, 0xFFFFFFFF, null, 0);

                var index: c_uint = 0;
                while (index < count) : (index += 1) {
                    var in_buffer: [native.PATH_MAX_WIDE]u16 = undefined;
                    var len = native.DragQueryFileW(hDrop, index, in_buffer[0..].ptr, in_buffer.len);
                    var res = std.unicode.utf16leToUtf8Alloc(window.allocator, in_buffer[0..len]) catch unreachable;
                    window.event_pump.push(Event{
                        .FileDroppped = res,
                    }) catch unreachable;
                }

                native.DragFinish(hDrop);
            },
            else => {
                return native.DefWindowProcW(hWnd, msg, wParam, lParam);
            },
        }

        return result;
    }

    fn open_window(options: ziglet.app.WindowOptions) !native.HWND {
        var wide_title = []u16{0} ** 512;
        const wtitle = internals.toWide(&wide_title, options.title);

        const wcex = native.WNDCLASSEX{
            .style = native.CS_HREDRAW | native.CS_VREDRAW | native.CS_OWNDC,
            .lpfnWndProc = wnd_proc,
            .hInstance = native.kernel32.GetModuleHandleW(null),
            .hIcon = native.LoadIconW(null, native.IDI_WINLOGO).?,
            .hCursor = native.LoadCursorW(null, native.IDC_ARROW).?,
            .hbrBackground = native.HBRUSH(native.GetStockObject(native.NULL_BRUSH)),
            .lpszClassName = wtitle.ptr,
        };

        if (native.RegisterClassExW(&wcex) == 0) {
            return error.InitError;
        }

        var rect = native.RECT{
            .left = 0,
            .right = @truncate(c_int, @intCast(isize, options.width)),
            .top = 0,
            .bottom = @truncate(c_int, @intCast(isize, options.height)),
        };

        var dwExStyle: u32 = 0;
        var dwStyle: u32 = native.WS_CLIPSIBLINGS | native.WS_CLIPCHILDREN;

        if (options.fullscreen) {
            var dmScreenSettings: native.DEVMODEW = undefined;
            dmScreenSettings.dmSize = @sizeOf(native.DEVMODEW);
            dmScreenSettings.dmPelsWidth = @intCast(u32, options.width);
            dmScreenSettings.dmPelsHeight = @intCast(u32, options.height);
            dmScreenSettings.dmBitsPerPel = 32;
            dmScreenSettings.dmFields = native.DM_BITSPERPEL | native.DM_PELSWIDTH | native.DM_PELSHEIGHT;
            if (native.ChangeDisplaySettingsW(&dmScreenSettings, native.CDS_FULLSCREEN) != 0) {
                return error.InitError;
            } else {
                dwExStyle = native.WS_EX_APPWINDOW;
                dwStyle |= native.WS_POPUP;
                _ = native.ShowCursor(native.FALSE);
            }
        } else {
            dwExStyle = native.WS_EX_APPWINDOW | native.WS_EX_WINDOWEDGE | native.WS_EX_ACCEPTFILES;
            dwStyle |= native.DWORD(native.WS_OVERLAPPEDWINDOW);

            if (options.resizeable) {
                dwStyle |= native.DWORD(native.WS_THICKFRAME) | native.DWORD(native.WS_MAXIMIZEBOX);
            } else {
                dwStyle &= ~native.DWORD(native.WS_MAXIMIZEBOX);
                dwStyle &= ~native.DWORD(native.WS_THICKFRAME);
            }

            if (options.borderless) {
                dwStyle &= ~native.DWORD(native.WS_THICKFRAME);
            }
        }

        if (native.AdjustWindowRectEx(&rect, dwStyle, native.FALSE, dwExStyle) == 0) {
            return error.InitError;
        }

        rect.right -= rect.left;
        rect.bottom -= rect.top;

        const result = native.CreateWindowExW(dwExStyle, wtitle.ptr, wtitle.ptr, dwStyle, native.CW_USEDEFAULT, native.CW_USEDEFAULT, rect.right, rect.bottom, null, null, wcex.hInstance, null) orelse return error.InitError;
        _ = native.ShowWindow(result, native.SW_NORMAL);

        return result;
    }

    fn message_loop(self: *const WindowImpl) void {
        var msg: native.MSG = undefined;

        while (native.PeekMessageW(&msg, self.handle, 0, 0, native.PM_REMOVE) == native.TRUE) {
            if (msg.message == native.WM_QUIT) break;
            _ = native.TranslateMessage(&msg);
            _ = native.DispatchMessageW(&msg);
        }
    }

    pub fn init(self: *WindowImpl, options: ziglet.app.WindowOptions) !void {
        self.* = WindowImpl{
            .handle = undefined,
        };

        errdefer self.deinit();

        self.handle = try open_window(options);
        _ = native.SetWindowLongPtrW(self.handle, native.GWLP_USERDATA, @ptrToInt(self));
    }

    pub fn deinit(self: *WindowImpl) void {
        var window = @fieldParentPtr(app.Window, "impl", self);
        if (window.options.fullscreen) {
            _ = native.ChangeDisplaySettingsW(null, 0);
            _ = native.ShowCursor(native.TRUE);
        }
        var wide_title = []u16{0} ** 512;
        _ = native.UnregisterClassW(internals.toWide(&wide_title, window.options.title).ptr, native.kernel32.GetModuleHandleW(null));
    }

    pub fn update(self: *WindowImpl) !void {
        try internals.forceErr();
        self.message_loop();
    }
};
