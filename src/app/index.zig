const builtin = @import("builtin");

pub use switch (builtin.os) {
    builtin.Os.windows => @import("windows/index.zig"),
    else => @compileError("unsupported os"),
};
