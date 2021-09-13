const std = @import("std");
const mem = std.mem;
const math = std.math;
const debug = std.debug;

const Allocator = mem.Allocator;

// const c = @cImport(@cInclude("zig_mimalloc.h"));
const c = @cImport(@cInclude("mimalloc.h"));

pub export const mimalloc_allocator: *Allocator = &mimalloc_allocator_state;

var mimalloc_allocator_state = Allocator {
    .allocFn = mimallocAllocFn,
    .resizeFn = mimallocResizeFn,
};

fn mimallocAllocFn(
    self: *Allocator,
    len: usize,
    ptr_align: u29,
    len_align: u29,
    ret_addr: usize
) Allocator.Error![]u8 {
    debug.assert(len > 0);
    debug.assert(ptr_align > 0);
    debug.assert(math.isPowerOfTwo(ptr_align));

    var ptr: [*]u8 = @ptrCast([*]u8, c.mi_malloc_aligned(len, ptr_align) orelse return error.OutOfMemory);
    if (len_align == 0) {
        return ptr[0..len];
    }

    const full_len = c.mi_malloc_size(ptr);
    return ptr[0..mem.alignBackwardAnyAlign(full_len, len_align)];
}

fn mimallocResizeFn(
    self: *Allocator,
    buf: []u8,
    buf_align: u29,
    new_len: usize,
    len_align: u29,
    ret_addr: usize
) mem.Allocator.Error!usize {
    if (new_len == 0) {
        c.mi_free(buf.ptr);
        return 0;
    }

    if (new_len <= buf.len) {
        return mem.alignAllocLen(buf.len, new_len, len_align);
    }

    const full_len = c.mi_malloc_size(buf.ptr);
    if (new_len <= buf.len) {
        return mem.alignAllocLen(full_len, new_len, len_align);
    }

    return error.OutOfMemory;
}
