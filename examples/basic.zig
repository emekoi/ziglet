//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// zig build-exe examples/basic.zig --pkg-begin ziglet src/index.zig --pkg-end

const std = @import("std");
use @import("ziglet");

pub fn main() !void {
    var w = Window.new("foo", 512, 512) catch |err| {
        return err;
    };

    while (!w.should_close) {
        w.update();

        if (w.is_down(Key.Space)) {
            std.debug.warn("space is down\n");
        }
    }

    try w.close();
}
