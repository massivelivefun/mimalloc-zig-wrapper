const std = @import("std");
const testing = std.testing;
const mimalloc_allocator = @import("main.zig").mimalloc_allocator;

test "allocate memory and free" {
    conswidth: i32,
        height: i32,
        title: []const u8,
        index: usize,t TestStruct = struct {
        
    };

    const memory: []TestStruct = mimalloc_allocator.alloc(TestStruct, 1) catch @panic("test failure");
    mimalloc_allocator.free(memory);
}

test "allocate memory, use it and free" {
    const TestStruct = struct {
        width: i32,
        height: i32,
        title: []const u8,
        index: usize,
    };

    const memory: []TestStruct = mimalloc_allocator.alloc(TestStruct, 1) catch @panic("test failure");

    memory[0] = TestStruct {
        .width = 1280,
        .height = 720,
        .title = "Should work fine!",
        .index = 12,
    };

    try testing.expect(memory[0].width == 1280);
    try testing.expect(memory[0].height == 720);
    try testing.expect(memory[0].index == 12);

    mimalloc_allocator.free(memory);
}

test "allocate memory, use it, reallocate memory, use it and free" {
    const TestStruct = struct {
        width: i32,
        height: i32,
        title: []const u8,
        index: usize,
    };

    var memory: []TestStruct = mimalloc_allocator.alloc(TestStruct, 2) catch @panic("test failure");

    memory[0] = TestStruct{
        .width = 1280,
        .height = 720,
        .title = "Should work fine!",
        .index = 12,
    };

    memory[1] = TestStruct{
        .width = 1230,
        .height = 820,
        .title = "Cool game",
        .index = 120,
    };

    try testing.expect(memory[0].width == 1280);
    try testing.expect(memory[0].height == 720);
    try testing.expect(memory[0].index == 12);

    try testing.expect(memory[1].width == 1230);
    try testing.expect(memory[1].height == 820);
    try testing.expect(memory[1].index == 120);

    memory = mimalloc_allocator.realloc(memory, 4) catch @panic("test failure");

    memory[0] = TestStruct{
        .width = 6122,
        .height = 810,
        .title = "Game",
        .index = 99,
    };

    memory[1] = TestStruct{
        .width = 728,
        .height = 187,
        .title = "Race game",
        .index = 7,
    };

    memory[2] = TestStruct{
        .width = 12612,
        .height = 45,
        .title = "Window title",
        .index = 31,
    };

    memory[3] = TestStruct{
        .width = 125,
        .height = 1,
        .title = "Game title",
        .index = 21,
    };

    try testing.expect(memory[0].width == 6122);
    try testing.expect(memory[0].height == 810);
    try testing.expect(memory[0].index == 99);

    try testing.expect(memory[1].width == 728);
    try testing.expect(memory[1].height == 187);
    try testing.expect(memory[1].index == 7);

    try testing.expect(memory[2].width == 12612);
    try testing.expect(memory[2].height == 45);
    try testing.expect(memory[2].index == 31);

    try testing.expect(memory[3].width == 125);
    try testing.expect(memory[3].height == 1);
    try testing.expect(memory[3].index == 21);

    mimalloc_allocator.free(memory);
}
