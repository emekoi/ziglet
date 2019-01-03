//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");
pub const event = @import("event.zig");
const ziglet = @import("../index.zig");

const Os = builtin.Os;
const gfx = ziglet.gfx;

pub const WindowOptions = struct {
    backend: gfx.RenderBackend,
    fullscreen: bool,
    borderless: bool,
    resizeable: bool,
    width: usize,
    height: usize,
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

