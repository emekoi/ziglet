//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// zig build-exe examples/basic.zig --pkg-begin ziglet src/index.zig --pkg-end

const std = @import("std");
const ziglet = @import("ziglet");

const Key = ziglet.app.Key;
const Event = ziglet.app.event.Event;
const Window = ziglet.app.Window;

pub fn main() !void {
    var direct_allocator = std.heap.DirectAllocator.init();
    var alloc = &direct_allocator.allocator;
    defer direct_allocator.deinit();
    
    const opts = ziglet.app.WindowOptions {
        .backend = ziglet.app.RenderBackend.OpenGL,
        .fullscreen = false,
        .borderless = false,
        .resizeable = true,
        .width = 512,
        .height = 512,
        .title = "hello_world",
    };

    var w = try Window.init(alloc, opts);
    defer w.deinit();

    while (!w.should_close) {
        w.update();

        // while (w.event_pump.pop()) |event| {
        //     switch (event) {
        //         Event.KeyDown => |key| {
        //             std.debug.warn("KeyDown: {}\n", key);
        //             switch (key) {
        //                 Key.Escape => {
        //                     w.should_close  = true;
        //                     break;
        //                 },
        //                 else => continue,
        //             }
        //         },
        //         Event.KeyUp => |key| std.debug.warn("KeyUp: {}\n", key),
        //         Event.Char => |char| std.debug.warn("Char: {}\n", char),
        //         Event.MouseDown => |btn| std.debug.warn("MouseDown: {}\n", btn),
        //         Event.MouseUp => |btn| std.debug.warn("MouseUp: {}\n", btn),
        //         Event.MouseScroll => |scroll| std.debug.warn("MouseScroll: {}, {}\n", scroll[0], scroll[1]),
        //         Event.MouseMove => |coord| std.debug.warn("MouseMove: {}, {}\n", coord[0], coord[1]),
        //         Event.MouseEnter => std.debug.warn("MouseEnter\n"),
        //         Event.MouseLeave => std.debug.warn("MouseLeave\n"),
        //         Event.Resized => |size| std.debug.warn("Resized: {}, {}\n", size[0], size[1]),
        //         Event.Iconified => std.debug.warn("Iconified\n"),
        //         Event.Restored => std.debug.warn("Restored\n"),
        //         Event.FileDroppped => |path| std.debug.warn("FileDroppped: {}\n", path),
        //         else => {
        //             std.debug.warn("invalid event\n");
        //         },
        //     }
        // }

        while (w.event_pump.pop()) |event| {
            switch (event) {
                Event.KeyDown => |key| {
                    switch (key) {
                        Key.Escape => {
                            w.should_close  = true;
                            break;
                        },
                        else => continue,
                    }
                },
                Event.KeyUp => {},
                Event.Char => {},
                Event.MouseDown => {},
                Event.MouseUp => {},
                Event.MouseScroll => {},
                Event.MouseMove => {},
                Event.MouseEnter => {},
                Event.MouseLeave => {},
                Event.Resized => {},
                Event.Iconified => {},
                Event.Restored => {},
                Event.FileDroppped => {},
            }
        }

        std.os.time.sleep(16666667);
    }
}
