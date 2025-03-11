const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const dir = try cwd.openDir(".", .{ .iterate = true });

    var it = dir.iterate();
    while (try it.next()) |entry| {
        try stdout.print("File name: {s}\n", .{entry.name});
    }
}
