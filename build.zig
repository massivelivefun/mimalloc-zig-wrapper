const Builder = @import("std").build.Builder;

// This build file would have to be heavily edited to actually link
// appropriately on your machine, unless you somehow managed to install the
// same toolchains from Visual Studio 2019
pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-mimalloc-wrapper", "src/main.zig");
    lib.addSystemIncludeDir("../mimalloc/include");
    lib.addLibPath("../mimalloc/out/msvc-x64/Release");
    lib.addLibPath("C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30133/lib/x64");
    lib.addLibPath("C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/ucrt/x64");
    lib.linkSystemLibrary("mimalloc-static");
    lib.linkSystemLibrary("advapi32");
    lib.linkSystemLibrary("bcrypt");
    // Statically linked for now...
    lib.linkSystemLibrary("libcmt");
    lib.linkSystemLibrary("libucrt");
    lib.linkSystemLibrary("libvcruntime");
    lib.linkSystemLibrary("libcpmt");
    lib.setBuildMode(mode);
    lib.install();

    const main_tests = b.addTest("src/tests.zig");
    main_tests.addSystemIncludeDir("../mimalloc/include");
    main_tests.addLibPath("../mimalloc/out/msvc-x64/Release");
    main_tests.addLibPath("C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30133/lib/x64");
    main_tests.addLibPath("C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/ucrt/x64");
    main_tests.linkSystemLibrary("mimalloc-static");
    main_tests.linkSystemLibrary("advapi32");
    main_tests.linkSystemLibrary("bcrypt");
    // Statically linked for now...
    main_tests.linkSystemLibrary("libcmt");
    main_tests.linkSystemLibrary("libucrt");
    main_tests.linkSystemLibrary("libvcruntime");
    main_tests.linkSystemLibrary("libcpmt");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
