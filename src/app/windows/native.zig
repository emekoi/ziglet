//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

pub use std.os.windows;

pub const ATOM = u16;

pub const LONG_PTR = usize;

pub const HWND = HANDLE;

pub const HICON = HANDLE;

pub const HCURSOR = HANDLE;

pub const HBRUSH = HANDLE;

pub const HMENU = HANDLE;

pub const HDC = HANDLE;

pub const HDROP = HANDLE;

pub const LPARAM = LONG_PTR;

pub const WPARAM = LONG_PTR;

pub const LRESULT = LONG_PTR;

pub const MAKEINTRESOURCE = [*]WCHAR;

pub const CS_VREDRAW = 1;

pub const CS_HREDRAW = 2;

pub const CS_OWNDC = 32;

pub const WM_DESTROY = 2;

pub const WM_SIZE = 5;

pub const WM_CLOSE = 16;

pub const WM_QUIT = 18;

pub const WM_KEYDOWN = 256;

pub const WM_KEYUP = 257;

pub const WM_CHAR = 258;

pub const WM_SYSCHAR = 262;

pub const WM_SYSKEYDOWN = 260;

pub const WM_SYSKEYUP = 261;

pub const WM_MOUSEMOVE = 512;

pub const WM_LBUTTONDOWN = 513;

pub const WM_LBUTTONUP = 514;

pub const WM_RBUTTONDOWN = 516;

pub const WM_RBUTTONUP = 517;

pub const WM_MBUTTONDOWN = 519;

pub const WM_MBUTTONUP = 520;

pub const WM_MOUSEWHEEL = 522;

pub const WM_MOUSEHWHEEL = 526;

pub const WM_DROPFILES = 563;

pub const WM_MOUSELEAVE = 675;

pub const IDC_ARROW = @intToPtr(MAKEINTRESOURCE, 32512);

pub const IDI_WINLOGO = @intToPtr(MAKEINTRESOURCE, 32517);

pub const CW_USEDEFAULT = -1;

pub const WS_CAPTION = 0x00C00000;

pub const WS_OVERLAPPEDWINDOW = 0x00CF0000;

pub const WS_MAXIMIZEBOX = 0x00010000;

pub const WS_POPUP = 0x80000000;

pub const WS_SYSMENU = 0x00080000;

pub const WS_THICKFRAME = 0x00040000;

pub const WS_CLIPCHILDREN = 0x02000000;

pub const WS_CLIPSIBLINGS = 0x04000000;

pub const WS_EX_ACCEPTFILES = 0x00000010;

pub const WS_EX_APPWINDOW = 0x00040000;

pub const WS_EX_WINDOWEDGE = 0x00000100;

pub const SW_NORMAL = 1;

pub const SWP_NOSIZE = 0x0001;

pub const SWP_SHOWWINDOW = 0x0040;

pub const PM_REMOVE = 1;

pub const VK_ESCAPE = 27;

pub const GWLP_USERDATA = -21;

pub const BI_BITFIELDS = 3;

pub const DIB_RGB_COLORS = 0;

pub const SRCCOPY = 0x00CC0020;

pub const PFD_DOUBLEBUFFER = 0x00000001;

pub const PFD_DRAW_TO_WINDOW = 0x00000004;

pub const PFD_SUPPORT_OPENGL = 0x00000020;

pub const PFD_TYPE_RGBA = 0;

pub const PFD_MAIN_PLANE = 0;

pub const DM_PELSWIDTH = 0x00080000;

pub const DM_PELSHEIGHT = 0x00100000;

pub const DM_BITSPERPEL = 0x00040000;

pub const CDS_FULLSCREEN = 4;

pub const SIZE_MINIMIZED = 1;

pub const SIZE_MAXIMIZED = 2;

pub const TME_LEAVE = 2;

pub const WNDPROC = stdcallcc fn (HWND, UINT, WPARAM, LPARAM) LRESULT;

pub const WNDCLASSEX = extern struct {
    cbSize: UINT,
    style: UINT,
    lpfnWndProc: ?WNDPROC,
    cbClsExtra: c_int,
    cbWndExtra: c_int,
    hInstance: HMODULE,
    hIcon: ?HICON,
    hCursor: ?HCURSOR,
    hbrBackground: ?HBRUSH,
    lpszMenuName: ?[*]const WCHAR,
    lpszClassName: [*]const WCHAR,
    hIconSm: ?HICON,
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
    hWnd: HWND,
    message: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
    time: DWORD,
    pt: POINT,
};

// pub const BITMAPINFOHEADER = extern struct {
//     biSize: DWORD,
//     biWidth: LONG,
//     biHeight: LONG,
//     biPlanes: WORD,
//     biBitCount: WORD,
//     biCompression: DWORD,
//     biSizeImage: DWORD,
//     biXPelsPerMeter: LONG,
//     biYPelsPerMeter: LONG,
//     biClrUsed: DWORD,
//     biClrImportant: DWORD,
// };

// pub const RGBQUAD = extern struct {
//     rgbBlue: BYTE,
//     rgbGreen: BYTE,
//     rgbRed: BYTE,
//     rgbReserved: BYTE,
// };

// pub const BITMAPINFO = extern struct {
//     bmiHeader: BITMAPINFOHEADER,
//     bmiColors: [3]RGBQUAD,
// };

pub const DEVMODEW = extern struct {
    dmDeviceName: [32]WCHAR,
    dmSpecVersion: WORD,
    dmDriverVersion: WORD,
    dmSize: WORD,
    dmDriverExtra: WORD,
    dmFields: DWORD,
    dmOrientation: c_short,
    dmPaperSize: c_short,
    dmPaperLength: c_short,
    dmPaperWidth: c_short,
    dmScale: c_short,
    dmCopies: c_short,
    dmDefaultSource: c_short,
    dmPrintQuality: c_short,
    dmColor: c_short,
    dmDuplex: c_short,
    dmYResolution: c_short,
    dmTTOption: c_short,
    dmCollate: c_short,
    dmFormName: [32]WCHAR,
    dmLogPixels: WORD,
    dmBitsPerPel: DWORD,
    dmPelsWidth: DWORD,
    dmPelsHeight: DWORD,
    dmDisplayFlags: DWORD,
    dmDisplayFrequency: DWORD,
    dmICMMethod: DWORD,
    dmICMIntent: DWORD,
    dmMediaType: DWORD,
    dmDitherType: DWORD,
    dmReserved1: DWORD,
    dmReserved2: DWORD,
    dmPanningWidth: DWORD,
    dmPanningHeight: DWORD,
};

pub const TRACKMOUSEEVENT = extern struct {
    cbSize: DWORD,
    dwFlags: DWORD,
    hwndTrack: HWND,
    dwHoverTime: DWORD,
};

pub extern "user32" stdcallcc fn LoadCursorW(hInstance: ?HINSTANCE, lpCursorName: LPCWSTR) ?HCURSOR;

pub extern "user32" stdcallcc fn LoadIconW(hInstance: ?HINSTANCE, lpIconName: LPCWSTR) ?HICON;

pub extern "user32" stdcallcc fn RegisterClassExW(lpWndClassEx: *const WNDCLASSEX) ATOM;

pub extern "user32" stdcallcc fn UnregisterClassW(lpClassName: LPCWSTR, hInstance: HMODULE) BOOL;

pub extern "user32" stdcallcc fn AdjustWindowRect(lpRect: *RECT, dwStyle: DWORD, bMenu: BOOL) BOOL;

pub extern "user32" stdcallcc fn GetClientRect(wnd: HWND, lpRect: *RECT) BOOL;

pub extern "user32" stdcallcc fn CreateWindowExW(dwExStyle: DWORD, lpClassName: LPCWSTR, lpWindowName: LPCWSTR, dwStyle: DWORD, X: c_int, Y: c_int, nWidth: c_int, nHeight: c_int, hWndParent: ?HWND, menu: ?HMENU, hInstance: ?HMODULE, lpParam: ?LPVOID) ?HWND;

pub extern "user32" stdcallcc fn DestroyWindow(wnd: HWND) BOOL;

pub extern "user32" stdcallcc fn ShowWindow(wnd: HWND, nCmdShow: c_int) BOOL;

pub extern "user32" stdcallcc fn GetDC(wnd: HWND) ?HDC;

pub extern "user32" stdcallcc fn ReleaseDC(wnd: HWND, hDC: HDC) c_int;

pub extern "user32" stdcallcc fn PeekMessageW(lpMsg: *MSG, wnd: HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT, wRemoveMsg: UINT) BOOL;

pub extern "user32" stdcallcc fn SendMessageW(hWnd: HWND, Msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT;

pub extern "user32" stdcallcc fn TranslateMessage(lpMsg: *MSG) BOOL;

pub extern "user32" stdcallcc fn DispatchMessageW(lpMsg: *MSG) LONG;

pub extern "user32" stdcallcc fn DefWindowProcW(wnd: HWND, msg: UINT, wp: WPARAM, lp: LPARAM) LRESULT;

pub extern "user32" stdcallcc fn GetWindowLongPtrW(hWnd: HWND, nIndex: c_int) LONG_PTR;

pub extern "user32" stdcallcc fn SetWindowLongPtrW(hWnd: HWND, nIndex: c_int, dwNewLong: LONG_PTR) LONG_PTR;

pub extern "user32" stdcallcc fn SetWindowTextW(hWnd: HWND, lpString: LPCWSTR) BOOL;

// pub extern "user32" stdcallcc fn SetWindowPos(hWnd: HWND, hWndInsertAfter: ?HWND,
//                     X: c_int, Y: c_int, cx: c_int, cy: c_int, uFlags: UINT) BOOL;

// pub extern "user32" stdcallcc fn GetForegroundWindow() ?HWND;

// pub extern "user32" stdcallcc fn ValidateRect(hWnd: HWND, lpRect: ?*const RECT) BOOL;

// pub extern "user32" stdcallcc fn InvalidateRect(hWnd: HWND, lpRect: ?*const RECT, bErase: BOOL) BOOL;

pub extern "user32" stdcallcc fn ChangeDisplaySettingsW(lpDevMode: ?*DEVMODEW, dwFlags: DWORD) LONG;

pub extern "user32" stdcallcc fn ShowCursor(bShow: BOOL) c_int;

pub extern "user32" stdcallcc fn AdjustWindowRectEx(lpRect: *RECT, dwStyle: DWORD, bMenu: BOOL, dwExStyle: DWORD) BOOL;

pub extern "user32" stdcallcc fn TrackMouseEvent(lpEventTrack: *TRACKMOUSEEVENT) BOOL;

pub extern "shell32" stdcallcc fn DragQueryFileW(hDrop: HDROP, iFile: UINT, lpszFile: ?LPCWSTR, cch: UINT) UINT;

pub extern "shell32" stdcallcc fn DragFinish(hDrop: HDROP) void;

pub extern "user32" stdcallcc fn GetCursorPos(lpPoint: *POINT) BOOL;

pub extern "user32" stdcallcc fn ScreenToClient(hWndl: HWND, lpPoint: *POINT) BOOL;

pub inline fn LOWORD(l: DWORD) WORD {
    return @intCast(WORD, (l & 0xffff));
}

pub inline fn HIWORD(l: DWORD) WORD {
    return @intCast(WORD, ((l >> 16) & 0xffff));
}

pub inline fn LOBYTE(l: WORD) BYTE {
    return @intCast(BYTE, (l & 0xff));
}

pub inline fn HIBYTE(l: WORD) BYTE {
    return @intCast(BYTE, ((l >> 8) & 0xff));
}

pub inline fn GET_X_LPARAM(lp: LPARAM) c_int {
    return @intCast(c_int, @truncate(c_ushort, LOWORD(@intCast(DWORD, lp))));
}

pub inline fn GET_Y_LPARAM(lp: LPARAM) c_int {
    return @intCast(c_int, @truncate(c_ushort, HIWORD(@intCast(DWORD, lp))));
}
