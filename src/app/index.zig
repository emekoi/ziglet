//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");
const Os = builtin.Os;

pub const keyboard = @import("keyboard.zig");
pub const mouse = @import("mouse.zig");
pub const event = @import("event.zig");

pub const RenderBackend = enum {
    OpenGL,
    DirectX11,
    Metal,
};

pub const WindowOptions = struct {
    backend: RenderBackend,
    fullscreen: bool,
    borderless: bool,
    resizeable: bool,
    width: i32,
    height: i32,
    title: []const u8,
};

pub const WindowError = error {
    InitError,
    ShutdownError,
};

pub use switch (builtin.os) {
    Os.windows => @import("windows/index.zig"),
    else => @compileError("unsupported os"),
};

