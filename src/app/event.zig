//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

const super = @import("index.zig");

const MouseButton = super.KeyMouseButton;
const Key = super.Key;

pub const Event = union {
    KeyDown: Key,
    KeyUp: Key,
    Char: u8,
    MouseDown: MouseButton,
    MouseUp: MouseButton,
    MouseScroll: [2]const i32,
    MouseMove: [2]const i32,
    MouseEnter,
    MouseLeave,
    Resized: [2]const i32,
    Iconified,
    Restored,
};
