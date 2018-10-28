const std = @import("std");
const builtin = @import("builtin");
const Builder = std.build.Builder;

pub const Executable = struct.{
    output: []const u8,
    input: []const u8,
};

const examples = []Executable.{
    Executable.{ .output = "../bin/basic", .input = "examples/basic.zig"},
};

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    try b.makePath("bin");

    for (examples) |example| {
        const exe = b.addExecutable(example.output, example.input);
        exe.addPackagePath("ziglet", "src/index.zig");
        exe.setBuildMode(mode);
        exe.setTarget(builtin.arch, builtin.os, builtin.environ);
        b.default_step.dependOn(&exe.step);
        b.installArtifact(exe);
    }
}
