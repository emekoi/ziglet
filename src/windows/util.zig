const std = @import("std");

pub fn L(comptime str: []const u8) ![]u16 {
    if (str.len == 0) return []u8.{};
    var result: [str.len]u16 = undefined;
    _ = try std.unicode.utf8ToUtf16Le(result[0..], str);
    return result[0..];
}
