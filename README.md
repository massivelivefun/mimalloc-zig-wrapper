# mimalloc-zig-wrapper
A lightweight implementation of Zig's std.mem.Allocator interface that wraps around Microsoft's mimalloc.

## Usage

Use this library as a Zig library ([instructions here](https://github.com/ziglang/zig/wiki/Zig-Build-System#use-a-zig-library)) and then add something like this to your root source file:
```zig
const mimalloc = @import("mimalloc-zig-wrapper");
const mi = mimalloc.mimalloc_allocator;

pub fn main() !void {
    const memory = try mi.alloc(i32, 1);
    memory[0] = 12;
    mi.free(memory);
}
```

## Build

You might have to go into `build.zig` and fix up the paths to point to the right libraries.

zig build

## Test

zig build test
