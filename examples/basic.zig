//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// zig build-exe examples/basic.zig --pkg-begin ziglet src/index.zig --pkg-end

const std = @import("std");
const ziglet = @import("ziglet");

const Window = ziglet.app.Window;
const RenderBackend = ziglet.app.RenderBackend;

pub fn main() !void {
    const opts = Window.Options.{
        .backend = RenderBackend.OpenGL,
        .fullscreen = false,
        .borderless = false,
        .resizeable = false,
        .width = 512,
        .height = 512,
        .title = "hello_world",
    };

    var w = try Window.init(opts);
    defer w.deinit();

    std.debug.warn("basic: {}\n", @ptrToInt(&w));

    while (!w.should_close) {
        w.update();
        if (w.should_close) {
            std.debug.warn("shutdown!\n");
        }
    }
}
