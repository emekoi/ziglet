const std = @import("std");
const Builder = std.build.Builder;

pub const Executable = struct {
    output: []const u8,
    input: []const u8,
};

const executables = []Executable {
    Executable { .output = "../bin/basic", .input = "examples/basic.zig"},
};

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    try b.makePath("bin");

    for (executables) |file| {
        const exe = b.addExecutable(file.output, file.input);
        exe.addPackagePath("ziglet", "src/index.zig");
        exe.setBuildMode(mode);
        b.default_step.dependOn(&exe.step);
        b.installArtifact(exe);
    }
}
