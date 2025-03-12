const std = @import("std");

pub fn main() !void {
    const cwd = std.fs.cwd();
    const dir = try cwd.openDir(".", .{ .iterate = true });

    try walkDir(dir, ".", 0);
}

pub fn walkDir(dir: std.fs.Dir, path: []const u8, level: u8) !void {
    const stdout = std.io.getStdOut().writer();

    var it = dir.iterate();

    var currEntry: ?std.fs.Dir.Entry = try it.next();
    var nextEntry: ?std.fs.Dir.Entry = try it.next();

    while (currEntry) |entry| {
        var indentBuffer: [128]u8 = undefined;
        const indentLen = @min(indentBuffer.len, level * 4);
        @memset(indentBuffer[0..indentLen], ' ');
        if (nextEntry != null) {
            try stdout.print("{s}├── {s}\n", .{ indentBuffer[0..indentLen], entry.name });
        } else {
            try stdout.print("{s}└── {s}\n", .{ indentBuffer[0..indentLen], entry.name });
        }

        if (entry.kind == .directory and entry.name[0] != 46) {
            var pathBuffer: [50]u8 = undefined;
            const fullPath = try std.fmt.bufPrint(&pathBuffer, "{s}{s}{s}", .{ path, "/", entry.name });
            const subDir = try std.fs.cwd().openDir(fullPath, .{ .iterate = true });
            try walkDir(subDir, fullPath, level + 1);
        }

        currEntry = nextEntry;
        nextEntry = try it.next();
    }
}
