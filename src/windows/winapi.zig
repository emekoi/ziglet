//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

pub use std.os.windows;

pub const ATOM = i16;
pub const LONG = c_int;
pub const LONG_PTR = usize;
pub const HWND = HANDLE;
pub const HICON = HANDLE;
pub const HCURSOR = HANDLE;
pub const HBRUSH = HANDLE;
pub const HINST = HANDLE;
pub const HMENU = HANDLE;
pub const HDC = HANDLE;
pub const LPARAM = LONG_PTR;
pub const WPARAM = LONG_PTR;
pub const LRESULT = LONG_PTR;
pub const TMSG = MSG;
pub const LPWNDCLASS = *WNDCLASS;
pub const LPRECT = *RECT;
pub const LPMSG = *MSG;
pub const MAKEINTRESOURCE = [*]WCHAR;

pub const CS_VREDRAW = 1;
pub const CS_HREDRAW = 2;
pub const CS_OWNDC = 32;

pub const WM_DESTROY = 0x0002;
pub const WM_CLOSE = 0x0010;
pub const WM_KEYDOWN = 0x0100;
pub const WM_KEYUP = 0x0101;
pub const WM_QUIT = 0x0012;

pub const IDC_ARROW = @intToPtr(MAKEINTRESOURCE, 32512);

pub const CW_USEDEFAULT: c_int = -1;
pub const WS_CAPTION = DWORD(0x00C00000);
pub const WS_OVERLAPPEDWINDOW = DWORD(0x00CF0000);
pub const WS_MAXIMIZEBOX = DWORD(0x00010000);
pub const WS_POPUP = DWORD(0x80000000);
pub const WS_SYSMENU = DWORD(0x00080000);
pub const WS_THICKFRAME = DWORD(0x00040000);

pub const SW_NORMAL = 1;

pub const PM_REMOVE = 1;

pub const VK_ESCAPE = 27;

pub const GWLP_USERDATA = -21;

pub const WNDPROC = stdcallcc fn(HWND, UINT, WPARAM, LPARAM) LRESULT;
  
pub const WNDCLASS = extern struct {
    style: UINT,
    lpfnWndProc: ?WNDPROC,
    cbClsExtra: c_int,
    cbWndExtra: c_int,
    hInstance: HANDLE,
    hIcon: HICON,
    hCursor: HCURSOR,
    hbrBackground: HBRUSH,
    lpszMenuName: [*]const WCHAR,
    lpszClassName: [*]const WCHAR,
};

pub const RECT = extern struct {
    left: LONG,
    top: LONG,
    right: LONG,
    bottom: LONG,
};

pub const POINT = extern struct {
    x: LONG,
    y: LONG,
};

pub const MSG = extern struct {
    hwnd: HWND,
    message: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
    time: DWORD,
    pt: POINT,
};

pub extern "user32" stdcallcc fn LoadCursorW(hInstance: ?HINST, lpCursorName: LPCWSTR) ?HCURSOR;

pub extern "user32" stdcallcc fn RegisterClassW(lpWndClass: LPWNDCLASS) ATOM;

pub extern "user32" stdcallcc fn UnregisterClassW(lpClassName: LPCWSTR, hInstance: HINST) BOOL;

pub extern "user32" stdcallcc fn AdjustWindowRect(lpRect: LPRECT, dwStyle: DWORD, bMenu: BOOL) BOOL;

pub extern "user32" stdcallcc fn CreateWindowExW(dwExStyle: DWORD, lpClassName: LPCWSTR,
                    lpWindowName: LPCWSTR, dwStyle: DWORD, X: c_int,
                    Y: c_int, nWidth: c_int, nHeight: c_int,
                    hWndParent: ?HWND, menu: ?HMENU, hInstance: ?HINST,
                    lpParam: ?LPVOID) ?HWND;

pub extern "user32" stdcallcc fn DestroyWindow(wnd: HWND) BOOL;

pub extern "user32" stdcallcc fn ShowWindow(wnd: HWND, nCmdShow: c_int) BOOL;

pub extern "user32" stdcallcc fn GetDC(wnd: HWND) ?HDC;

pub extern "user32" stdcallcc fn ReleaseDC(wnd: HWND, hDC: HDC) c_int;

pub extern "user32" stdcallcc fn SetPropW(wnd: HWND, lpString: LPCWSTR, hData: HANDLE) BOOL;

pub extern "user32" stdcallcc fn GetPropW(wnd: HWND, lpString: LPCWSTR) ?HANDLE;

pub extern "user32" stdcallcc fn RemovePropW(wnd: HWND, lpString: LPCWSTR) ?HANDLE;

pub extern "user32" stdcallcc fn GetClientRect(wnd: HWND, lpRect: LPRECT) BOOL;

pub extern "user32" stdcallcc fn PeekMessageW(lpMsg: *TMSG, wnd: HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT, wRemoveMsg: UINT) BOOL;

pub extern "user32" stdcallcc fn TranslateMessage(lpMsg: LPMSG) BOOL;

pub extern "user32" stdcallcc fn DispatchMessageW(lpMsg: LPMSG) LONG;

pub extern "user32" stdcallcc fn DefWindowProcW(wnd: HWND, msg: UINT, wp: WPARAM, lp: LPARAM) LRESULT;

pub extern "user32" stdcallcc fn GetWindowLongPtrW(hwnd: HWND, nIndex: c_int) LONG_PTR;

pub extern "user32" stdcallcc fn SetWindowLongPtrW(hwnd: HWND, nIndex: c_int, dwNewLong: LONG_PTR) LONG_PTR;
