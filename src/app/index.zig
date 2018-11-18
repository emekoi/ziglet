//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");
const Os = builtin.Os;

const keyboard = @import("keyboard.zig");
const mouse = @import("mouse.zig");
const event = @import("event.zig");

pub const RenderBackend = enum.{
    DirectX11,
    OpenGL,
};

pub use switch (builtin.os) {
    Os.windows => @import("windows/index.zig"),
    else => @compileError("unsupported os"),
};

pub const Key = keyboard.Key;
pub const Keyboard = keyboard.Keyboard;

pub const MouseButton = mouse.MouseButton;
