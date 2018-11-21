//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

const ziglet = @import("index.zig");
const util = @import("util.zig");

const MouseButton = ziglet.MouseButton;
const Key = ziglet.Key;

// [x] KeyDown: Key,
// [x] KeyUp: Key,
// [x] Char: u8,
// [x] MouseDown: MouseButton,
// [x] MouseUp: MouseButton,
// [ ] MouseScroll: [2]f32,
// [x] MouseMove: [2]f32,
// [x] MouseEnter: void,
// [x] MouseLeave: void,
// [x] Resized: [2]i32,
// [x] Iconified: void,
// [x] Restored: void,
// [ ] FileDroppped: []const u8,

pub const Event = union(enum) {
    KeyDown: Key,
    KeyUp: Key,
    Char: u8,
    MouseDown: MouseButton,
    MouseUp: MouseButton,
    MouseScroll: [2]f32,
    MouseMove: [2]f32,
    MouseEnter: void,
    MouseLeave: void,
    Resized: [2]i32,
    Iconified: void,
    Restored: void,
    FileDroppped: []const u8,
};

pub const EventPump = util.RingBuffer(Event);
