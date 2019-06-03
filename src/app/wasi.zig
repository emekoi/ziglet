//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const ziglet = @import("../ziglet.zig");
const internals = @import("../internals.zig");
const native = @import("windows/native.zig");

pub const WindowImpl = struct {
    export fn ziglet_event_handler() void {}

    pub fn init(self: *WindowImpl, options: ziglet.app.WindowOptions) !void {
        self.* = WindowImpl{};
        errdefer self.deinit();
    }

    pub fn deinit(self: *WindowImpl) void {
        var window = @fieldParentPtr(app.Window, "impl", self);
    }

    pub fn update(self: *WindowImpl) !void {
        try internals.forceErr();
    }
};
