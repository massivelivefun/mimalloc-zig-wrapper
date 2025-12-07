const std = @import("std");
const mem = std.mem;
const math = std.math;
const debug = std.debug;

const Allocator = mem.Allocator;

const mi = @cImport(@cInclude("mimalloc.h"));

pub const mimalloc_allocator = Allocator{
    .ptr = undefined,
    .vtable = &mimalloc_vtable,
};

const mimalloc_vtable = Allocator.VTable{
    .alloc = mimallocAlloc,
    .resize = mimallocResize,
    .free = mimallocFree,
    .remap = mimallocRemap,
};

fn mimallocAlloc(ctx: *anyopaque, len: usize, ptr_align: mem.Alignment, ret_addr: usize) ?[*]u8 {
    _ = ctx;
    _ = ret_addr;
    return @as(?[*]u8, @ptrCast(mi.mi_malloc_aligned(len, ptr_align.toByteUnits())));
}

fn mimallocResize(
    ctx: *anyopaque,
    buf: []u8,
    buf_align: mem.Alignment,
    new_len: usize,
    ret_addr: usize,
) bool {
    _ = ctx;
    _ = buf_align;
    _ = ret_addr;
    
    // Check if the allocated block is already large enough
    const full_len = mi.mi_malloc_size(buf.ptr);
    if (new_len <= full_len) {
        return true;
    }
    return false;
}

fn mimallocRemap(
    ctx: *anyopaque,
    buf: []u8,
    buf_align: mem.Alignment,
    new_len: usize,
    ret_addr: usize,
) ?[*]u8 {
    _ = ctx;
    _ = ret_addr;
    return @as(?[*]u8, @ptrCast(mi.mi_realloc_aligned(buf.ptr, new_len, buf_align.toByteUnits())));
}

fn mimallocFree(
    ctx: *anyopaque,
    buf: []u8,
    buf_align: mem.Alignment,
    ret_addr: usize,
) void {
    _ = ctx;
    _ = buf_align;
    _ = ret_addr;
    mi.mi_free(buf.ptr);
}
