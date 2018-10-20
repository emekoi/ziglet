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
            .gl_context = undefined,
            .handle = undefined,
            .fullscreen = options.fullscreen,
            .borderless = options.borderless,
            .resizeable = options.resizeable,
            .width = options.width,
            .height = options.height,
            .title = options.title,
        };

        result.handle = open_window(options) catch |err| {
            resul.deinit();
            return err;
        };
        // return Self.{
        //     .gl_context = try opengl.Context.init(),
        // };
    }

    pub fn deinit(self: Self) void {
        if (self.fullscreen) {
            _ = ChangeDisplaySettings(null, 0);
            _ = ShowCursor(TRUE);
        }
        self.gl_context.deinit();
    }

    pub fn resize(self: *Self) void {
        glViewPort(0, 0, self.width, self.height);
    }
};






