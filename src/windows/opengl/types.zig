//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

pub const GLenum = u32;
pub const GLboolean = bool;
pub const GLbitfield = u32;
pub const GLbyte = i8;
pub const GLshort = i16;
pub const GLint = i32;
pub const GLsizei = i32;
pub const GLubyte = u8;
pub const GLushort = u16;
pub const GLuint = u32;
pub const GLfloat = f32;
pub const GLclampf = f32;
pub const GLdouble = f64;
pub const GLclampd = f64;
pub const GLvoid = *c_void;


// opengl function pointers
pub const PFNGLARRAYELEMENTEXTPROC = ?stdcallcc fn(GLint) void;
pub const PFNGLDRAWARRAYSEXTPROC = ?stdcallcc fn(GLenum, GLint, GLsizei) void;
pub const PFNGLVERTEXPOINTEREXTPROC = ?stdcallcc fn(GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
pub const PFNGLNORMALPOINTEREXTPROC = ?stdcallcc fn(GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
pub const PFNGLCOLORPOINTEREXTPROC = ?stdcallcc fn(GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
pub const PFNGLINDEXPOINTEREXTPROC = ?stdcallcc fn(GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
pub const PFNGLTEXCOORDPOINTEREXTPROC = ?stdcallcc fn(GLint, GLenum, GLsizei, GLsizei, ?*const GLvoid) void;
pub const PFNGLEDGEFLAGPOINTEREXTPROC = ?stdcallcc fn(GLsizei, GLsizei, ?*const GLboolean) void;
pub const PFNGLGETPOINTERVEXTPROC = ?stdcallcc fn(GLenum, ?*(?*GLvoid)) void;
pub const PFNGLARRAYELEMENTARRAYEXTPROC = ?stdcallcc fn(GLenum, GLsizei, ?*const GLvoid) void;
pub const PFNGLDRAWRANGEELEMENTSWINPROC = ?stdcallcc fn(GLenum, GLuint, GLuint, GLsizei, GLenum, ?*const GLvoid) void;
pub const PFNGLADDSWAPHINTRECTWINPROC = ?stdcallcc fn(GLint, GLint, GLsizei, GLsizei) void;
pub const PFNGLCOLORTABLEEXTPROC = ?stdcallcc fn(GLenum, GLenum, GLsizei, GLenum, GLenum, ?*const GLvoid) void;
pub const PFNGLCOLORSUBTABLEEXTPROC = ?stdcallcc fn(GLenum, GLsizei, GLsizei, GLenum, GLenum, ?*const GLvoid) void;
pub const PFNGLGETCOLORTABLEEXTPROC = ?stdcallcc fn(GLenum, GLenum, GLenum, ?*GLvoid) void;
pub const PFNGLGETCOLORTABLEPARAMETERIVEXTPROC = ?stdcallcc fn(GLenum, GLenum, ?*GLint) void;
pub const PFNGLGETCOLORTABLEPARAMETERFVEXTPROC = ?stdcallcc fn(GLenum, GLenum, ?*GLfloat) void;


// wgl extentions
pub const PFNWGLCREATECONTEXTATTRIBSARBPROC = ?stdcallcc fn(HDC, HGLRC, ?*const c_int) HGLRC;
pub const PFNWGLCHOOSEPIXELFORMATARBPROC = ?stdcallcc fn(HDC, ?*const c_int, ?*const FLOAT, UINT, ?*c_int, ?*UINT) BOOL;
