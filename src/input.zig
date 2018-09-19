//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");

const mem = std.mem;

pub const Key = enum {
    Key0 = 0,
    Key1 = 1,
    Key2 = 2,
    Key3 = 3,
    Key4 = 4,
    Key5 = 5,
    Key6 = 6,
    Key7 = 7,
    Key8 = 8,
    Key9 = 9,

    A = 10,
    B = 11,
    C = 12,
    D = 13,
    E = 14,
    F = 15,
    G = 16,
    H = 17,
    I = 18,
    J = 19,
    K = 20,
    L = 21,
    M = 22,
    N = 23,
    O = 24,
    P = 25,
    Q = 26,
    R = 27,
    S = 28,
    T = 29,
    U = 30,
    V = 31,
    W = 32,
    X = 33,
    Y = 34,
    Z = 35,

    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,
    F13,
    F14,
    F15,

    Down,
    Left,
    Right,
    Up,
    Apostrophe,
    Backquote,

    Backslash,
    Comma,
    Equal,
    LeftBracket,
    Minus,
    Period,
    RightBracket,
    Semicolon,

    Slash,
    Backspace,
    Delete,
    End,
    Enter,

    Escape,

    Home,
    Insert,
    Menu,

    PageDown,
    PageUp,

    Pause,
    Space,
    Tab,
    NumLock,
    CapsLock,
    ScrollLock,
    LeftShift,
    RightShift,
    LeftCtrl,
    RightCtrl,

    NumPad0,
    NumPad1,
    NumPad2,
    NumPad3,
    NumPad4,
    NumPad5,
    NumPad6,
    NumPad7,
    NumPad8,
    NumPad9,
    NumPadDot,
    NumPadSlash,
    NumPadAsterisk,
    NumPadMinus,
    NumPadPlus,
    NumPadEnter,

    LeftAlt,
    RightAlt,

    LeftSuper,
    RightSuper,

    Unknown,

    Count = 107,
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
            .keys = []bool{false} ** 512,
            .keys_down_duration = []f32{-1.0} ** 512,
            .key_repeat_delay = 0.0,
            .key_repeat_rate = 0.0,
        };
    }

    pub inline fn set_key_state(self: *Self, key: Key, state: bool) void {
        self.keys[@enumToInt(key)] = state;
    }
    
    pub fn get_keys(self: *Self, alloc: *std.mem.Allocator) !std.ArrayList(Key) {
        var result = std.ArrayList(Key).init(alloc);
        
        for (self.keys) |down, idx| {
            if (down) try result.append(@intToEnum(idx));
        }
        
        return result;
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
    
    pub fn get_keys_pressed(self: *Self, repeat: bool) !std.ArrayList(Key) {
        var result = std.ArrayList(Key).init(alloc);
        
        for (self.keys) |down, idx| {
            if (self.key_pressed(idx, repeat)) try result.append(@intToEnum(idx));
        }
        
        return result;
    }

    pub inline fn is_key_down(self: *Self, key: Key) bool {
        return self.keys[@enumToInt(key)];
    }

    pub inline fn set_key_repeat_delay(self: *Self, delay: f32) void {
        self.key_repeat_delay = delay;
    }

    pub inline fn set_key_repeat_rate(self: *Self, rate: f32) void {
        self.key_repeat_rate = rate;
    }

    pub fn key_pressed(self: *Self, index: usize, repeat: bool) bool {
        const t = self.keys_down_duration[index];

        if (t == 0.0) return true;
        const comp = (t > self.key_repeat_delay);
        if (repeat && comp.*) {
            const delay = self.key_repeat_delay;
            const rate = self.key_repeat_rate;
            if ((@rem(t - delay, rate) > rate * 0.5) != (@rem(t - delay - self.delta_time, rate) > rate * 0.5)) {
                return true;
            }
        }

        return false;
    }

    pub fn is_key_pressed(self: *Self, key: Key, repeat: bool) bool {
        return self.key_pressed(@enumToInt(key), repeat);
    }
};

pub const MouseButton = enum {
    Left,
    Middle,
    Right,
};

pub const MouseMode = enum {
    Pass,
    Clamp,
    Discard
};
