//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn toWide(out: [:0  ]u16, str: []const u8) [:0]const u16 {
    const last = std.unicode.utf8ToUtf16Le(out, str) catch unreachable;
    out[last] = 0;
    return out[0..(last + 1):0];
}

pub fn clamp(comptime T: type, x: T, a: T, b: T) T {
    return std.math.max(std.math.min(a, b), std.math.min(x, std.math.max(a, b)));
}

pub inline fn forceErr() !void {
    var _i: i32 = 0;
    if (_i > 1) return error.FakeError;
}

pub fn RingBuffer(comptime T: type, comptime S: usize) type {
    return struct {
        const Self = @This();

        items: [S]T,
        write: usize,
        read: usize,

        pub fn new() Self {
            return .{
                .items = [_]T{undefined} ** S,
                .write = 0,
                .read = 0,
            };
        }

        fn mask(self: Self, idx: usize) usize {
            return idx & (self.capacity() - 1);
        }

        pub fn empty(self: Self) bool {
            return self.write == self.read;
        }

        pub fn full(self: Self) bool {
            return self.count() == self.capacity();
        }

        pub fn count(self: Self) usize {
            return self.write - self.read;
        }

        pub fn capacity(self: Self) usize {
            return self.items.len;
        }

        pub fn push(self: *Self, data: T) void {
            self.items[self.mask(self.write)] = data;
            self.write += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (!self.empty()) {
                self.read += 1;
                return self.items[self.mask(self.read - 1)];
            }
            return null;
        }

        pub fn peek(self: *const Self) ?T {
            if (!self.empty()) {
                return self.items[self.mask(self.read)];
            }
            return null;
        }
    };
}
