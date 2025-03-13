const std = @import("std");

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

pub fn getTextColor(entry: std.fs.Dir.Entry, with_colors: bool) []const u8 {
    if (!with_colors) return "37";

    if (entry.kind == .directory) {
        if (entry.name[0] == '.') {
            return "36";
        } else {
            return "34";
        }
    } else return "35";
}

pub fn isValidPath(path: []const u8) bool {
    var dir = std.fs.cwd();
    const result = dir.openFile(path, .{ .mode = .read_only });
    return result != error.FileNotFound and result != error.AccessDenied;
}
