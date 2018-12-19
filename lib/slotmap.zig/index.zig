const std = @import("std");

pub const Key = struct {
    const Self = @This();

    index: u32,
    version: u32,

    pub fn equals(lhs: Self, rhs: Self) bool {
        return lhs.index == rhs.index and lhs.version == rhs.version;
    }
};

fn Slot(comptime T: type) type {
    return struct {
        const Self = @This();

        version: u32,
        next_free: u32,
        value: T,

        fn new(version: u32, next_free: u32, value: T) Self {
            return Self {
                .version = version,
                .next_free = next_free,
                .value = value
            };
        }

        fn occupied(self: Self) bool {
            return self.version % 2 > 0;
        }
    };
}

pub fn SlotMap(comptime T: type) type {
    return struct {
        const Self = @This();
        const SlotType = Slot(T);

        pub const Error = error {
            OverflowError,
            InvalidKey,
        };

        pub const Iterator = struct {
            map: *const Self,
            index: usize,
            
            pub fn next_key(self: *Iterator) ?Key {
                if (self.map.len == 0 or self.index > self.map.len) {
                    self.reset();
                    return null;
                }
                while (!self.map.slots.at(self.index).occupied()) : (self.index += 1) {}
                self.index += 1;

                return Key {
                    .index = @intCast(u32, self.index - 1),
                    .version = self.map.slots.at(self.index - 1).version,
                };
            }

            pub fn next_value(self: *Iterator) ?T {
                if (self.map.len == 0 or self.index > self.map.len) {
                    self.reset();
                    return null;
                }
                while (!self.map.slots.at(self.index).occupied()) : (self.index += 1) {}
                self.index += 1;
                return self.map.slots.at(self.index - 1).value;
            }

            fn reset(self: *Iterator) void {
                self.index = 0;
            }
        };

        slots: std.ArrayList(SlotType),
        free_head: usize,
        len: usize,

        pub fn init(allocator: *std.mem.Allocator, size: u32) !Self {
            var result = Self {
                .slots = std.ArrayList(SlotType).init(allocator),
                .free_head = 0,
                .len = 0,
            };
            
            try result.set_capacity(size);
            return result;
        }

        pub fn deinit(self: Self) void {
            self.slots.deinit();
        }

        pub fn count(self: Self) usize {
            return self.len;
        }

        pub fn capacity(self: Self) usize {
            return self.slots.capacity();
        }

        pub fn set_capacity(self: *Self, new_capacity: usize) !void {
            try self.slots.ensureCapacity(new_capacity);
        }

        pub fn has_key(self: Self, key: Key) bool {
            if (key.index < self.slots.count()) {
                const slot = self.slots.at(key.index);
                return slot.version == key.version;
            } else {
                return false;
            }
        }

        pub fn insert(self: *Self, value: T) !Key {
            const new_len = self.len + 1;

            if (new_len == std.math.maxInt(u32)) {
                return error.OverflowError;
            }
            
            const idx = self.free_head;

            if (idx < self.slots.count()) {
                const slots = self.slots.toSlice();
                const occupied_version = slots[idx].version | 1;
                const result = Key {
                    .index = @intCast(u32, idx),
                    .version = occupied_version
                };
                
                slots[idx].value = value;
                slots[idx].version = occupied_version;
                self.free_head = slots[idx].next_free;
                self.len = new_len;

                return result;
            } else {
                
                const result = Key {
                    .index = @intCast(u32, idx),
                    .version = 1
                };
                
                try self.slots.append(SlotType.new(1, 0, value));
                self.free_head = self.slots.count();
                self.len = new_len;

                return result;
            }
        }

        // TODO: find out how to do this correctly
        fn reserve(self: *Self) !Key {
            const default: T = undefined;
            return try self.insert(default);
        }

        fn remove_from_slot(self: *Self, idx: usize) T {
            const slots = self.slots.toSlice();
            slots[idx].next_free = @intCast(u32, self.free_head);
            slots[idx].version += 1;
            self.free_head = idx;
            self.len -= 1;
            return slots[idx].value;
        }

        pub fn remove(self: *Self, key: Key) !T {
            if (self.has_key(key)) {
                return self.remove_from_slot(key.index);
            } else {
                return error.InvalidKey;
            }
        }

        pub fn delete(self: *Self, key: Key) !void {
            if (self.has_key(key)) {
                _ =  self.remove_from_slot(key.index);
            } else {
                return error.InvalidKey;
            }
        }

        // TODO: zig closures
        fn retain(self: *Self, filter: fn(key: Key, value: T) bool) void {
            const len = self.slots.len;
            var idx = 0;

            while (idx < len) : (idx += 1) {
                const slot = self.slots.at(idx);
                const key = Key { .index = idx, .version = slot.version };
                if (slot.occupied and !filter(key, value)) {
                    _ = self.remove_from_slot(idx);
                }
            }
        }

        pub fn clear(self: *Self) void {
            while (self.len > 0) {
                _ = self.remove_from_slot(self.len);
            }

            self.slots.shrink(0);
            self.free_head = 0;
        }
        
        pub fn get(self: *const Self, key: Key) !T {
            if (self.has_key(key)) {
                return self.slots.at(key.index).value;
            } else {
                return error.InvalidKey;
            }
        }

        pub fn get_ptr(self: *const Self, key: Key) !*T {
            if (self.has_key(key)) {
                const slots = self.slots.toSlice();
                return &slots[key.index].value;
            } else {
                return error.InvalidKey;
            }
        }

        pub fn set(self: *Self, key: Key, value: T) !void {
            if (self.has_key(key)) {
                const slots = self.slots.toSlice();
                slots[key.index].value = value;
            } else {
                return error.InvalidKey;
            }
        }

        pub fn iterator(self: *const Self) Iterator {
            return Iterator {
                .map = self,
                .index = 0,
            };
        }

    };
}

test "slotmap" {
    const debug = std.debug;
    const mem = std.mem;
    const assert = debug.assert;
    const assertError = debug.assertError;

    const data = [][]const u8 {
        "foo",
        "bar",
        "cat",
        "zag"
    };

    var map = try SlotMap([]const u8).init(std.debug.global_allocator, 3);
    var keys = []Key { Key { .index = 0, .version = 0} } ** 3;
    var iter = map.iterator();
    var idx: usize = 0;

    defer map.deinit();

    for (data[0..3]) |word, i| {
        keys[i] = try map.insert(word);
    }
    
    assert(mem.eql(u8, try map.get(keys[0]), data[0]));
    assert(mem.eql(u8, try map.get(keys[1]), data[1]));
    assert(mem.eql(u8, try map.get(keys[2]), data[2]));

    try map.set(keys[0], data[3]);
    assert(mem.eql(u8, try map.get(keys[0]), data[3]));
    try map.delete(keys[0]);

    assertError(map.get(keys[0]), error.InvalidKey);    

    while (iter.next_value()) |value| : (idx += 1) {
        assert(mem.eql(u8, value, data[idx + 1]));
    }

    idx = 0;

    while (iter.next_key()) |key| : (idx += 1) {
        assert(mem.eql(u8, try map.get(key), data[idx + 1]));
    }

    map.clear();

    std.debug.warn("\n");
    
    for (keys) |key| {
        assertError(map.get(key), error.InvalidKey);
    }
    
    while (iter.next_value()) |value| {
        assert(iter.index == 0);
    }
}
