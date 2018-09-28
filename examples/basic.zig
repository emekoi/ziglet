//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// zig build-exe examples/basic.zig --pkg-begin ziglet src/index.zig --pkg-end

const std = @import("std");
const heap = std.heap;
const mem = std.mem;
use @import("ziglet");

pub var global: *mem.Allocator = undefined;
var alloc_impl: heap.DirectAllocator = undefined;

pub fn main() !void {
    alloc_impl = heap.DirectAllocator.init();
    global = &alloc_impl.allocator;
    defer alloc_impl.deinit();

    const opts = WindowOptions {
        .borderless = false,
        .title = true,
        .resize = false,
    };

    var w = try Window.new(global, "foo", 512, 512, opts);
    defer w.close();

    while (!w.should_close) {
        w.update();

        if (w.is_key_pressed(Key.Space, false)) {
            std.debug.warn("space is down\n");
        }
    }
}
