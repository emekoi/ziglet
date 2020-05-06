//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");

pub usingnamespace switch (builtin.os.tag) {
    .windows => @import("native/windows.zig"),
    else => @compileError("unsupported OS"),
};
