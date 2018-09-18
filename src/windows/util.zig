//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

pub fn to_wstring(str: []const u8) ![512]u16 {
    var result: [512]u16 = undefined;

    const end_index = try std.unicode.utf8ToUtf16Le(result[0..], str);
    std.debug.assert(end_index < result.len);
    result[end_index] = 0;
    
    return result;
}
