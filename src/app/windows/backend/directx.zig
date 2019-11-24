//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const windows = @import("../../windows.zig");
const ziglet = @import("../../../ziglet.zig");

const app = ziglet.app;

pub const Context = struct {
    pub fn init(window: *const windows.WindowImpl, options: app.WindowOptions) Context {
        return .{};
    }
};
