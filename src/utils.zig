const std = @import("std");
const bzz = @import("../build.zig.zon");

pub fn printHelp() !void {
    const message =
        \\Usage ftree [options]
        \\
        \\Options:
        \\
        \\  -h, --help       Show the help message information
        \\  -v, --version    Show the version of the application
        \\  -a, -A           Include the content of directories that start with "."
        \\  -c, -C           Include color coding in the tree for the different elements
        \\
        \\
    ;

    try std.io.getStdOut().writer().print("{s}", .{message});
}

pub fn printVersion() !void {
    const version = "0.0.1";
    try std.io.getStdOut().writer().print("v{s}\n", .{version});
}
