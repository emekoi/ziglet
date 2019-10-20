const Builder = @import("std").build.Builder;

pub const Example = struct {
    description: ?[]const u8,
    output: []const u8,
    input: []const u8,

    pub fn new(output: []const u8, input: []const u8, desc: ?[]const u8) Example {
        return Example{
            .description = desc,
            .output = output,
            .input = input,
        };
    }
};

const examples = [_]Example{Example.new("events", "examples/events.zig", null)};

pub fn build(builder: *Builder) void {
    const mode = builder.standardReleaseOptions();
    builder.setInstallPrefix(".");

    // building and running examples
    const examples_step = builder.step("examples", "build the examples");
    builder.default_step.dependOn(examples_step);

    for (examples) |example| {
        const exe = builder.addExecutable(example.output, example.input);
        exe.addPackagePath("ziglet", "src/ziglet.zig");
        examples_step.dependOn(&exe.step);
        builder.installArtifact(exe);
        exe.setBuildMode(mode);

        const run_cmd = exe.run();
        const run_step = builder.step(builder.fmt("run-{}", example.output), example.description orelse builder.fmt("run \"{}\" example", example.output));
        run_step.dependOn(&run_cmd.step);
    }

    // formatting source files
    const fmt_step = builder.step("fmt", "format source files");
    const fmt_run = builder.addSystemCommand([_][]const u8{
        builder.zig_exe, "fmt", "examples", "src", "build.zig",
    });
    fmt_step.dependOn(&fmt_run.step);
}
