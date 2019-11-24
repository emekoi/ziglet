//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// zig build-exe examples/basic.zig --pkg-begin ziglet src/index.zig --pkg-end

const std = @import("std");
const ziglet = @import("ziglet");

const app = ziglet.app;

const Key = app.event.Key;
const Event = app.event.Event;
const Window = app.Window;

pub fn main() !void {
    var alloc = std.heap.direct_allocator;

    const opts  = ziglet.app.WindowOptions {
        .width = 512,
        .height = 512,
        .title = "hello_world",
    };

    var w: Window = undefined;
    try w.init(alloc, opts);
    defer w.deinit();
    var pump = w.getEventPump();

    while (!w.should_close) {
        try w.update();

        while (pump.pop()) |event| {
            switch (event) {
                Event.KeyDown => |key| {
                    std.debug.warn("KeyDown: {}\n", key);
                    switch (key) {
                        Key.Escape => {
                            w.should_close = true;
                            break;
                        },
                        else => continue,
                    }
                },
                Event.KeyUp => |key| std.debug.warn("KeyUp: {}\n", key),
                Event.Char => |char| std.debug.warn("Char: {}\n", char),
                Event.MouseDown => |btn| std.debug.warn("MouseDown: {}\n", btn),
                Event.MouseUp => |btn| std.debug.warn("MouseUp: {}\n", btn),
                Event.MouseScroll => |scroll| std.debug.warn("MouseScroll: {}, {}\n", scroll[0], scroll[1]),
                Event.MouseMove => |coord| std.debug.warn("MouseMove: {}, {}\n", coord[0], coord[1]),
                Event.MouseEnter => std.debug.warn("MouseEnter\n"),
                Event.MouseLeave => std.debug.warn("MouseLeave\n"),
                Event.Resized => |size| std.debug.warn("Resized: {}, {}\n", size[0], size[1]),
                Event.Iconified => std.debug.warn("Iconified\n"),
                Event.Restored => std.debug.warn("Restored\n"),
                Event.FileDroppped => |path| {
                    std.debug.warn("FileDroppped: {}\n", path);
                    w.allocator.free(path);
                },
                else => {
                    std.debug.warn("invalid event\n");
                },
            }
        }

        std.time.sleep(16666667);
    }
}
