const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-mimalloc", "src/main.zig");
    lib.addSystemIncludeDir("./mimalloc/include");
    // lib.addSystemIncludeDir("C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30133/include");
    // lib.addSystemIncludeDir("C:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/ucrt");
    // lib.addSystemIncludeDir("C:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/um");
    lib.addLibPath("./mimalloc/out/msvc-x64/Release");
    lib.addLibPath("C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30133/lib/x64");
    lib.addLibPath("C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/ucrt/x64");
    // lib.addLibPath("C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/um/x64");
    lib.linkSystemLibrary("mimalloc-static");
    lib.linkSystemLibrary("advapi32");
    lib.linkSystemLibrary("bcrypt");
    lib.linkSystemLibrary("libcmt");
    lib.linkSystemLibrary("libucrt");
    lib.linkSystemLibrary("libvcruntime");
    lib.linkSystemLibrary("libcpmt");
    // lib.linkSystemLibrary("msvcprt");
    // lib.linkSystemLibrary("msvcrt");
    // lib.linkSystemLibrary("ucrt");
    lib.setBuildMode(mode);
    lib.install();

    const main_tests = b.addTest("src/tests.zig");
    main_tests.addSystemIncludeDir("./mimalloc/include");
    // main_tests.addSystemIncludeDir("C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30133/include");
    // main_tests.addSystemIncludeDir("C:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/ucrt");
    // main_tests.addSystemIncludeDir("C:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/um");
    main_tests.addLibPath("./mimalloc/out/msvc-x64/Release");
    main_tests.addLibPath("C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30133/lib/x64");
    main_tests.addLibPath("C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/ucrt/x64");
    // main_tests.addLibPath("C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/um/x64");
    main_tests.linkSystemLibrary("mimalloc-static");
    main_tests.linkSystemLibrary("advapi32");
    main_tests.linkSystemLibrary("bcrypt");
    // Static
    main_tests.linkSystemLibrary("libcmt");
    main_tests.linkSystemLibrary("libucrt");
    main_tests.linkSystemLibrary("libvcruntime");
    main_tests.linkSystemLibrary("libcpmt");
    // Dynamic
    // main_tests.linkSystemLibrary("msvcprt");
    // main_tests.linkSystemLibrary("msvcrt");
    // main_tests.linkSystemLibrary("msvcmrt");
    // main_tests.linkSystemLibrary("ucrt");
    // main_tests.linkSystemLibrary("vcruntime");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
