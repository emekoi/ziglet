//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

// ~~stolen from~~ based on [this](https://github.com/RandyGaul/cute_headers/blob/master/cute_spritebatch.h).

const slotmap = @import("../lib.zig").slotmap;

pub const Config = struct {};
pub const Sprite = struct {};

pub const SubmitBatch = fn (sprites: []Sprite) void;

pub const SpriteDescriptor = struct {
    width: i32,
    height: i32,
    x: f32,
    y: f32,
    sx: f32,
    sy: f32,
    c: f32,
    s: f32,
    sort_bits: i32,
};

pub const Batch = struct {
    pub fn init(config: Config) !Batch {
        return Batch{};
    }

    pub fn deinit(self: *Self) void {}

    pub fn push(self: *Batch, image_id: u64, desc: SpriteDescriptor) !void {
        return error.NotImplemented;
    }

    pub fn tick(self: *Self) void {}

    pub fn flush(self: *Batch) !void {
        return error.NotImplemented;
    }

    pub fn defrag(self: *Batch) !void {
        return error.NotImplemented;
    }
};
