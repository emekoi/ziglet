const std = @import("std");
const builtin = @import("builtin");
const Builder = std.build.Builder;

pub const Executable = struct {
    output: []const u8,
    input: []const u8,
};

const examples = []const Executable {
    Executable { .output = "events", .input = "examples/events.zig" },
};

pub fn build(builder: *Builder) !void {
    const mode = builder.standardReleaseOptions();
    try builder.makePath("build/bin");
    builder.setInstallPrefix("build");

    for (examples) |example| {
        const exe = builder.addExecutable(example.output, example.input);
        exe.addPackagePath("ziglet", "src/index.zig");
        exe.setBuildMode(mode);
        exe.setTarget(builtin.arch, builtin.os, builtin.environ);
        builder.default_step.dependOn(&exe.step);
        builder.installArtifact(exe);
    }
}
