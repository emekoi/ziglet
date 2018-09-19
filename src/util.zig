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


// pub fn clamp(v: f32, lb: f32, ub: f32) f32 {
//     f32::min(f32::max(v, lb), ub)
// }
// 
// pub fn get_pos(mode: MouseMode, mx: f32, my: f32, scale: f32, width: f32, height: f32) -> void {
//     let s = 1.0 / scale as f32;
//     let x = mx * s;
//     let y = my * s;
//     let window_width = width * s;
//     let window_height = height * s;
// 
//     match mode {
//         MouseMode::Pass => Some((x, y)),
//         MouseMode::Clamp => {
//             Some((clamp(x, 0.0, window_width - 1.0),
//                   clamp(y, 0.0, window_height - 1.0)))
//         },
//         MouseMode::Discard => {
//             if x < 0.0 || y < 0.0 || x >= window_width || y >= window_height {
//                 None
//             } else {
//                 Some((x, y))
//             }
//         },
//     }
// }

