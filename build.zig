const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Fetch the mimalloc dependency defined in build.zig.zon
    const mimalloc_dep = b.dependency("mimalloc", .{});

    const lib = b.addLibrary(.{
        .name = "mimalloc-zig-wrapper",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
        .linkage = .static,
    });
    
    // Add mimalloc include path
    lib.addIncludePath(mimalloc_dep.path("include"));

    // Compile mimalloc C source
    // src/static.c includes the necessary parts of mimalloc for a static build
    lib.addCSourceFile(.{
        .file = mimalloc_dep.path("src/static.c"),
        .flags = &.{
            "-DMI_STATIC_LIB",
            // Add any other necessary flags, mostly standard
        },
    });

    // Link standard C library
    lib.linkLibC();

    // Windows specific system libraries often needed by mimalloc
    if (target.result.os.tag == .windows) {
        lib.linkSystemLibrary("advapi32");
        lib.linkSystemLibrary("bcrypt");
    }

    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tests.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Test compilation also needs mimalloc sources and includes
    main_tests.addIncludePath(mimalloc_dep.path("include"));
    main_tests.addCSourceFile(.{
        .file = mimalloc_dep.path("src/static.c"),
        .flags = &.{
            "-DMI_STATIC_LIB",
        },
    });
    main_tests.linkLibC();

    if (target.result.os.tag == .windows) {
        main_tests.linkSystemLibrary("advapi32");
        main_tests.linkSystemLibrary("bcrypt");
    }

    const run_main_tests = b.addRunArtifact(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}
