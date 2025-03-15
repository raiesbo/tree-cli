const std = @import("std");

pub fn printHelp() !void {
    const message =
        \\Tree CLI - Recursively lists the directory structure of a given path,
        \\including files, and displays it in a tree-like format directly in the terminal.
        \\
        \\USAGE:
        \\
        \\  tree <dir_path?> <options?>
        \\
        \\OPTIONS:
        \\
        \\  -h, --help       Show this help message
        \\  -v, --version    Show the application version
        \\  -a, -A           Include hidden files and directories (starting with ".")
        \\  -c, -C           Enable color coding for different elements
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
    if (entry.kind == .sym_link) return "32";
    if (entry.kind == .unix_domain_socket) return "31";
    if (entry.kind == .directory) {
        if (entry.name[0] == '.') return "36";
        return "34";
    }
    return "35"; // File type
}

pub fn isValidPath(path: []const u8) bool {
    var dir = std.fs.cwd();
    const result = dir.openFile(path, .{ .mode = .read_only });
    return result != error.FileNotFound and result != error.AccessDenied;
}
