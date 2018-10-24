//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

/// max str len of 512
pub fn L(str: []const u8) []u16 {
    if (str.len == 0) return []u16.{};
    var result = []u16.{0} ** 512;
    const last = std.unicode.utf8ToUtf16Le(result[0..], str) catch unreachable;
    result[last] = 0;
    return result[0..];
}
