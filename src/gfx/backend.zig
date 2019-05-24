//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");
const Os = builtin.Os;

pub const dx11 = switch (builtin.os) {
    .windows => @import("backend/dx11.zig"),
    else => void,
};

pub const opengl = switch (builtin.os) {
    .windows, .linux, .macosx => @import("backend/opengl.zig"),
    else => void,
};

pub const metal = switch (builtin.os) {
    .macosx => @import("backend/metal.zig"),
    else => void,
};
