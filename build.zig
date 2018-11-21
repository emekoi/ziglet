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

fn winRes(self: *Builder, path: []const u8) !void {
    var args = ArrayList([]const u8).init(self.allocator);
    const cache = builder.pathFromRoot(builder.cache_root);
    // const args = []const u8 { "windres", "-O", "coff", "-o", path, path };
    defer args.deinit();
    try args.appendSlice([]const u8 { "windres", "-O", "coff", "-o" });

    // const output = "zig-cache"path

    // try builder.spawnChild(path);
    // builder.addObjectFile()
}

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
