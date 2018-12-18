//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const debug = std.debug;
const mem = std.mem;
const Allocator = mem.Allocator;
const assert = debug.assert;
const ArrayList = std.ArrayList;

/// A buffer that allocates memory and maintains a null byte at the end.

pub fn Buffer(comptime T: type) type {
    return struct {
        const Self = @This();

        list: ArrayList(T),

        /// Must deinitialize with deinit.
        pub fn init(allocator: *Allocator, m: []const T) !Self {
            var self = try initSize(allocator, m.len);
            mem.copy(T, self.list.items, m);
            return self;
        }

        /// Must deinitialize with deinit.
        pub fn initSize(allocator: *Allocator, size: usize) !Self {
            var self = initNull(allocator);
            try self.resize(size);
            return self;
        }

        /// Must deinitialize with deinit.
        /// None of the other operations are valid until you do one of these:
        /// * ::replaceContents
        /// * ::resize
        pub fn initNull(allocator: *Allocator) Self {
            return Self{ .list = ArrayList(T).init(allocator) };
        }

        /// Must deinitialize with deinit.
        pub fn initFromSelf(buffer: *const Self) !Self {
            return Self.init(buffer.list.allocator, buffer.toSliceConst());
        }

        /// Self takes ownership of the passed in slice. The slice must have been
        /// allocated with `allocator`.
        /// Must deinitialize with deinit.
        pub fn fromOwnedSlice(allocator: *Allocator, slice: []T) !Self {
            var self = Self{ .list = ArrayList(T).fromOwnedSlice(allocator, slice) };
            try self.list.append(0);
            return self;
        }

        /// The caller owns the returned memory. The Self becomes null and
        /// is safe to `deinit`.
        pub fn toOwnedSlice(self: *Self) []T {
            const allocator = self.list.allocator;
            const result = allocator.shrink(T, self.list.items, self.len());
            self.* = initNull(allocator);
            return result;
        }

        pub fn allocPrint(allocator: *Allocator, comptime format: []const T, args: ...) !Self {
            const countSize = struct {
                fn countSize(size: *usize, bytes: []const T) (error{}!void) {
                    size.* += bytes.len;
                }
            }.countSize;
            var size: usize = 0;
            std.fmt.format(&size, error{}, countSize, format, args) catch |err| switch (err) {};
            var self = try Self.initSize(allocator, size);
            assert((std.fmt.bufPrint(self.list.items, format, args) catch unreachable).len == size);
            return self;
        }

        pub fn deinit(self: *Self) void {
            self.list.deinit();
        }

        pub fn toSlice(self: *const Self) []T {
            return self.list.toSlice()[0..self.len()];
        }

        pub fn toSliceConst(self: *const Self) []const T {
            return self.list.toSliceConst()[0..self.len()];
        }

        pub fn shrink(self: *Self, new_len: usize) void {
            assert(new_len <= self.len());
            self.list.shrink(new_len + 1);
            self.list.items[self.len()] = 0;
        }

        pub fn resize(self: *Self, new_len: usize) !void {
            try self.list.resize(new_len + 1);
            self.list.items[self.len()] = 0;
        }

        pub fn isNull(self: *const Self) bool {
            return self.list.len == 0;
        }

        pub fn len(self: *const Self) usize {
            return self.list.len - 1;
        }

        pub fn append(self: *Self, m: []const T) !void {
            const old_len = self.len();
            try self.resize(old_len + m.len);
            mem.copy(T, self.list.toSlice()[old_len..], m);
        }

        pub fn appendByte(self: *Self, byte: T) !void {
            const old_len = self.len();
            try self.resize(old_len + 1);
            self.list.toSlice()[old_len] = byte;
        }

        pub fn eql(self: *const Self, m: []const T) bool {
            return mem.eql(T, self.toSliceConst(), m);
        }

        pub fn startsWith(self: *const Self, m: []const T) bool {
            if (self.len() < m.len) return false;
            return mem.eql(T, self.list.items[0..m.len], m);
        }

        pub fn endsWith(self: *const Self, m: []const T) bool {
            const l = self.len();
            if (l < m.len) return false;
            const start = l - m.len;
            return mem.eql(T, self.list.items[start..l], m);
        }

        pub fn replaceContents(self: *Self, m: []const T) !void {
            try self.resize(m.len);
            mem.copy(T, self.list.toSlice(), m);
        }

        /// For passing to C functions.
        pub fn ptr(self: *const Self) [*]T {
            return self.list.items.ptr;
        }
    };
}
