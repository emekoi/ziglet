//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// zig build-exe examples/basic.zig --pkg-begin ziglet src/index.zig --pkg-end

const std = @import("std");
use @import("ziglet");

pub fn main() !void {
    const opts = WindowOptions {
        .borderless = false,
        .title = true,
        .resize = false,
    };

    var w = try Window.new("foo", 512, 512, opts);
    defer w.close();

    while (!w.should_close) {
        w.update();

        if (w.is_key_pressed(Key.Space, false)) {
            std.debug.warn("space is down\n");
        }
    }
}
