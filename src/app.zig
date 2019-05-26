//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");
const std = @import("std");

pub const event = @import("app/event.zig");
const internals = @import("internals.zig");
const ziglet = @import("ziglet.zig");

const WindowImpl = switch (builtin.os) {
    .windows => @import("app/windows.zig").WindowImpl,
    else => @compileError("unsupport OS"),
};

const gfx = ziglet.gfx;
const mem = std.mem;

pub const WindowOptions = struct {
    backend: gfx.Backend,
    fullscreen: bool,
    borderless: bool,
    resizeable: bool,
    width: usize,
    height: usize,
    title: []const u8,
};

pub const Window = struct {
    allocator: *mem.Allocator,
    options: WindowOptions,
    event_pump: event.EventPump,
    should_close: bool,
    mouse_tracked: bool,
    iconified: bool,
    impl: WindowImpl,

    pub fn init(self: *Window, allocator: *mem.Allocator, options: WindowOptions) !void {
        self.* = Window{
            .allocator = allocator,
            .options = options,
            .should_close = false,
            .mouse_tracked = false,
            .iconified = false,
            .impl = undefined,
            .event_pump = event.EventPump.init(allocator),
        };
        errdefer self.deinit();
        try self.impl.init(options);
    }

    pub fn deinit(self: *Window) void {
        self.event_pump.deinit();
        self.impl.deinit();
    }

    pub fn update(self: *Window) !void {
        try internals.forceErr();
        try self.impl.update();
    }

    pub fn getEventPump(self: *Window) *event.EventPump {
        return &self.event_pump;
    }
};

pub const WindowError = error{
    InitError,
    ShutdownError,
};
