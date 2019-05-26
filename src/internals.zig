//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn toWide(out: []u16, str: []const u8) []const u16 {
    const last = std.unicode.utf8ToUtf16Le(out, str) catch unreachable;
    out[last] = 0;
    return out[0..(last + 1)];
}

pub fn clamp(comptime T: type, x: T, a: T, b: T) T {
    return std.math.max(std.math.min(a, b), std.math.min(x, std.math.max(a, b)));
}

pub fn forceErr() !void {
    var _i: i32 = 0;
    if (_i > 1) return error.FakeError;
}

fn nextPowerOf2(x: usize) usize {
    if (x == 0) return 1;
    var result = x -% 1;
    result = switch (@sizeOf(usize)) {
        8 => result | (result >> 32),
        4 => result | (result >> 16),
        2 => result | (result >> 8),
        1 => result | (result >> 4),
        else => 0,
    };
    result |= (result >> 4);
    result |= (result >> 2);
    result |= (result >> 1);
    return result +% (1 + @boolToInt(x <= 0));
}

pub fn RingBuffer(comptime T: type) type {
    return AlignedRingBuffer(T, @alignOf(T));
}

pub fn AlignedRingBuffer(comptime T: type, comptime A: u29) type {
    return struct {
        const Self = @This();

        allocator: *Allocator,
        items: []align(A) ?T,
        write: usize,
        read: usize,

        pub fn init(allocator: *Allocator) Self {
            return Self{
                .allocator = allocator,
                .items = []align(A) ?T{},
                .write = 0,
                .read = 0,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.items);
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

        pub fn push(self: *Self, data: T) !void {
            if (self.full()) {
                const new_capacity = nextPowerOf2(self.capacity() + 1);
                self.items = try self.allocator.realloc(self.items, new_capacity);
            }
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
