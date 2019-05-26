//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

pub const Backend = union(enum) {
    OpenGL: GLVersion,
    DirectX: DXVersion,
    WebGL: WGLVersion,
    Metal,

    pub const GLVersion = enum {
        GL3_3,
        GL4_0,
        GL4_1,
        GL4_2,
        GL4_3,
        GL4_4,
        GL4_5,
        GL4_6,
    };

    pub const DXVersion = enum {
        DX9_0,
        DX11_0,
        DX11_1,
    };

    pub const WGLVersion = enum {
        WGL1,
        WGL2,
    };
};
