const std = @import("std");

pub fn main() !void {
    const cwd = std.fs.cwd();
    const dir = try cwd.openDir(".", .{ .iterate = true });

    var numDirs: i32 = 0;
    var numFiles: i32 = 0;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("·\n", .{});

    try walkDir(dir, ".", &numDirs, &numFiles, "");
    try stdout.print("\nDirectories: {} Files: {}\n", .{ numDirs, numFiles });
}

pub fn walkDir(dir: std.fs.Dir, path: []const u8, numDirs: *i32, numFiles: *i32, prefix: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

    var it = dir.iterate();

    var currEntry = try it.next();
    var nextEntry = try it.next();

    while (currEntry) |entry| {
        if (nextEntry != null) {
            try stdout.print("{s}├── {s}\n", .{ prefix, entry.name });
        } else {
            try stdout.print("{s}└── {s}\n", .{ prefix, entry.name });
        }

        if (entry.kind == .directory) {
            numDirs.* += 1;

            var prefixBuffer: [50]u8 = undefined;
            var newPrefix: []u8 = undefined;
            if (nextEntry != null) {
                newPrefix = try std.fmt.bufPrint(&prefixBuffer, "{s}│   ", .{prefix});
            } else {
                newPrefix = try std.fmt.bufPrint(&prefixBuffer, "{s}    ", .{prefix});
            }

            if (entry.name[0] != 46) {
                var pathBuffer: [50]u8 = undefined;
                const fullPath = try std.fmt.bufPrint(&pathBuffer, "{s}{s}{s}", .{ path, "/", entry.name });
                const subDir = try std.fs.cwd().openDir(fullPath, .{ .iterate = true });
                try walkDir(subDir, fullPath, numDirs, numFiles, newPrefix);
            }
        } else numFiles.* += 1;

        currEntry = nextEntry;
        nextEntry = try it.next();
    }
}
