//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const ziglet = @import("../ziglet.zig");
const internals = @import("../internals.zig");

const mem = std.mem;

pub const Event = union(enum) {
    KeyDown: Key,
    KeyUp: Key,
    Char: u8,
    MouseDown: MouseButton,
    MouseUp: MouseButton,
    MouseScroll: [2]f32,
    MouseMove: [2]f32,
    MouseEnter: void,
    MouseLeave: void,
    Resized: [2]i32,
    Iconified: void,
    Restored: void,
    // FileDroppped: []const u8,
};

pub const EventPump = internals.RingBuffer(Event);

pub const MouseButton = enum {
    Left,
    Right,
    Middle,
};

pub const Key = enum {
    Unknown,
    Space,
    Apostrophe,
    Comma,
    Minus,
    Period,
    Slash,
    Key0,
    Key1,
    Key2,
    Key3,
    Key4,
    Key5,
    Key6,
    Key7,
    Key8,
    Key9,
    Semicolon,
    Equal,
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
    X,
    Y,
    Z,
    LeftBracket,
    Backslash,
    RightBracket,
    Backquote,
    World1,
    World2,
    Escape,
    Enter,
    Tab,
    Backspace,
    Insert,
    Delete,
    Right,
    Left,
    Down,
    Up,
    PageUp,
    PageDown,
    Home,
    End,
    CapsLock,
    ScrollLock,
    NumLock,
    PrintScreen,
    Pause,
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
    F16,
    F17,
    F18,
    F19,
    F20,
    F21,
    F22,
    F23,
    F24,
    F25,
    Kp0,
    Kp1,
    Kp2,
    Kp3,
    Kp4,
    Kp5,
    Kp6,
    Kp7,
    Kp8,
    Kp9,
    KpDecimal,
    KpDivide,
    KpMultiply,
    KpSubtract,
    KpAdd,
    KpEnter,
    KpEqual,
    LeftShift,
    LeftControl,
    LeftAlt,
    LeftSuper,
    RightShift,
    RightControl,
    RightAlt,
    RightSuper,
    Menu,
};

const Keyboard = struct {
    prev_time: u64,
    delta_time: f32,
    keys: [512]bool,
    keys_down_duration: [512]f32,
    key_repeat_delay: f32,
    key_repeat_rate: f32,

    pub fn new() Keyboard {
        return Keyboard{
            .prev_time = 0,
            .delta_time = 0,
            .keys = []bool{false} ** 512,
            .keys_down_duration = []f32{-1.0} ** 512,
            .key_repeat_delay = 0.0,
            .key_repeat_rate = 0.0,
        };
    }

    pub fn update(self: *Keyboard) void {
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

    pub inline fn set_key(self: *Keyboard, key: Key, state: bool) void {
        self.keys[@enumToInt(key)] = state;
    }

    pub fn is_down(self: *Keyboard, key: Key) bool {
        return self.keys[@enumToInt(key)];
    }

    pub fn keys_down(self: *Keyboard, alloc: *std.mem.Allocator) !std.ArrayList(Key) {
        var result = std.ArrayList(Key).init(alloc);

        for (self.keys) |down, idx| {
            if (down) {
                const e = @truncate(u7, idx);
                try result.append(@intToEnum(Key, e));
            }
        }

        return result;
    }

    pub fn was_pressed(self: *Keyboard, key: Key, repeat: bool) bool {
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

    pub fn keys_pressed(self: *Keyboard, alloc: *std.mem.Allocator, repeat: bool) !std.ArrayList(Key) {
        var result = std.ArrayList(Key).init(alloc);

        for (self.keys) |down, idx| {
            const e = @truncate(u7, idx);
            if (self.was_pressed(@intToEnum(Key, e), repeat)) {
                try result.append(@intToEnum(Key, e));
            }
        }

        return result;
    }

    pub fn set_key_repeat_delay(self: *Keyboard, delay: f32) void {
        self.key_repeat_delay = delay;
    }

    pub fn set_key_repeat_rate(self: *Keyboard, rate: f32) void {
        self.key_repeat_rate = rate;
    }
};
