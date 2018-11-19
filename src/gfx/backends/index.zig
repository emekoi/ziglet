//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");
const Os = builtin.Os;

pub const dx11 = switch (builtin.os) {
    Os.windows => @import("dx11/index.zig"),
    else => void,
};

pub const opengl = switch (builtin.os) {
    Os.windows, Os.linux, Os.macosx => @import("opengl/index.zig"),
    else => void,
};

pub const metal = switch (builtin.os) {
    Os.macosx => @import("metal/index.zig"),
    else => void,
};
