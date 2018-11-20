//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

const mem = std.mem;

pub const Key = enum(u9) {
    Invalid          = 0,
    Space            = 32,
    Apostrophe       = 39,
    Comma            = 44,
    Minus            = 45,
    Period           = 46,
    Slash            = 47,
    Key0             = 48,
    Key1             = 49,
    Key2             = 50,
    Key3             = 51,
    Key4             = 52,
    Key5             = 53,
    Key6             = 54,
    Key7             = 55,
    Key8             = 56,
    Key9             = 57,
    Semicolon        = 59,
    Equal            = 61,
    A                = 65,
    B                = 66,
    C                = 67,
    D                = 68,
    E                = 69,
    F                = 70,
    G                = 71,
    H                = 72,
    I                = 73,
    J                = 74,
    K                = 75,
    L                = 76,
    M                = 77,
    N                = 78,
    O                = 79,
    P                = 80,
    Q                = 81,
    R                = 82,
    S                = 83,
    T                = 84,
    U                = 85,
    V                = 86,
    W                = 87,
    X                = 88,
    Y                = 89,
    Z                = 90,
    LeftBracket      = 91,
    Backslash        = 92,
    RightBracket     = 93,
    Backquote        = 96,
    World1           = 161,
    World2           = 162,
    Escape           = 256,
    Enter            = 257,
    Tab              = 258,
    Backspace        = 259,
    Insert           = 260,
    Delete           = 261,
    Right            = 262,
    Left             = 263,
    Down             = 264,
    Up               = 265,
    PageUp           = 266,
    PageDown         = 267,
    Home             = 268,
    End              = 269,
    CapsLock         = 280,
    ScrollLock       = 281,
    NumLock          = 282,
    PrintScreen      = 283,
    Pause            = 284,
    F1               = 290,
    F2               = 291,
    F3               = 292,
    F4               = 293,
    F5               = 294,
    F6               = 295,
    F7               = 296,
    F8               = 297,
    F9               = 298,
    F10              = 299,
    F11              = 300,
    F12              = 301,
    F13              = 302,
    F14              = 303,
    F15              = 304,
    F16              = 305,
    F17              = 306,
    F18              = 307,
    F19              = 308,
    F20              = 309,
    F21              = 310,
    F22              = 311,
    F23              = 312,
    F24              = 313,
    F25              = 314,
    Kp0              = 320,
    Kp1              = 321,
    Kp2              = 322,
    Kp3              = 323,
    Kp4              = 324,
    Kp5              = 325,
    Kp6              = 326,
    Kp7              = 327,
    Kp8              = 328,
    Kp9              = 329,
    KpDecimal        = 330,
    KpDivide         = 331,
    KpMultiply       = 332,
    KpSubtract       = 333,
    KpAdd            = 334,
    KpEnter          = 335,
    KpEqual          = 336,
    LeftShift        = 340,
    LeftControl      = 341,
    LeftAlt          = 342,
    LeftSuper        = 343,
    RightShift       = 344,
    RightControl     = 345,
    RightAlt         = 346,
    RightSuper       = 347,
    Menu             = 348,
};

pub const Keyboard = struct {
    const Self = @This();

    prev_time: u64,
    delta_time: f32,
    keys: [512]bool,
    keys_down_duration: [512]f32,
    key_repeat_delay: f32,
    key_repeat_rate: f32,
    
    pub fn new() Self {
        return Self {
            .prev_time = 0,
            .delta_time = 0,
            .keys = []bool {false} ** 512,
            .keys_down_duration = []f32 {-1.0} ** 512,
            .key_repeat_delay = 0.0,
            .key_repeat_rate = 0.0,
        };
    }    
    
    pub fn update(self: *Self) void {
        const current_time = std.os.time.timestamp();
        const delta_time = @intToFloat(f32, current_time - self.prev_time);
        self.prev_time = current_time;
        self.delta_time = delta_time;

        for (self.keys_down_duration) |*key, idx| {
            if (self.keys[idx]) {
                if (key.* < 0.0) {
                    key.* = 0.0;
                } else {
                    key.* += delta_time;
                }
            } else {
                key.* = -1.0;
            }
        }
    }

    pub inline fn set_key(self: *Self, key: Key, state: bool) void {
        self.keys[@enumToInt(key)] = state;
    }

    pub fn is_down(self: *Self, key: Key) bool {
        return self.keys[@enumToInt(key)];
    }

    pub fn keys_down(self: *Self, alloc: *std.mem.Allocator) !std.ArrayList(Key) {
        var result = std.ArrayList(Key).init(alloc);
        
        for (self.keys) |down, idx| {
            if (down) {
                const e = @truncate(u7, idx);
                try result.append(@intToEnum(Key, e));
            }
        }
        
        return result;
    }

    pub fn was_pressed(self: *Self, key: Key, repeat: bool) bool {
        const t = self.keys_down_duration[@enumToInt(key)];

        if (t == 0.0) return true;

        if (repeat and (t > self.key_repeat_delay)) {
            const delay = self.key_repeat_delay;
            const rate = self.key_repeat_rate;
            if ((@rem(t - delay, rate) > rate * 0.5) != (@rem(t - delay - self.delta_time, rate) > rate * 0.5)) {
                return true;
            }
        }

        return false;
    }

    pub fn keys_pressed(self: *Self, alloc: *std.mem.Allocator, repeat: bool) !std.ArrayList(Key) {
        var result = std.ArrayList(Key).init(alloc);
        
        for (self.keys) |down, idx| {
            const e = @truncate(u7, idx);
            if (self.was_pressed(@intToEnum(Key, e), repeat)) {
                try result.append(@intToEnum(Key, e));
            }
        }
        
        return result;
    }

    pub fn set_key_repeat_delay(self: *Self, delay: f32) void {
        self.key_repeat_delay = delay;
    }

    pub fn set_key_repeat_rate(self: *Self, rate: f32) void {
        self.key_repeat_rate = rate;
    }
};
