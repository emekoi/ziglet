const builtin = @import("builtin");

pub const RenderBackend = enum.{
    DirectX11,
    OpenGL,
};

pub use switch (builtin.os) {
    builtin.Os.windows => @import("windows/index.zig"),
    else => @compileError("unsupported os"),
};
