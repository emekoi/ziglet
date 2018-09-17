//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const builtin = @import("builtin");
const Os = builtin.Os;

const windows = @import("windows/index.zig");

pub use switch(builtin.os) {
    Os.windows => windows,
    else => void,
};
