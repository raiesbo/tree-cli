const std = @import("std");

pub fn main() !void {
    const cwd = std.fs.cwd();
    const dir = try cwd.openDir(".", .{ .iterate = true });

    var numDirs: i32 = 0;
    var numFiles: i32 = 0;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("·\n", .{});

    try walkDir(dir, ".", "", &numDirs, &numFiles);
    try stdout.print("\nDirectories: {} Files: {}\n", .{ numDirs, numFiles });
}

pub fn walkDir(dir: std.fs.Dir, path: []const u8, prefix: []const u8, num_dirs: *i32, num_files: *i32) !void {
    const stdout = std.io.getStdOut().writer();

    var it = dir.iterate();

    var curr_entry = try it.next();
    var next_entry = try it.next();

    while (curr_entry) |entry| {
        const isLast = next_entry == null;

        try stdout.print("{s}{s}── {s}\n", .{ prefix, if (isLast) "└" else "├", entry.name });
        // TODO: Add -c // --color flag for coloring the different elements. Files / Directories
        // try stdout.print("{s}{s}── \x1b[36m{s}\x1b[0m\n", .{ prefix, if (isLast) "└" else "├", entry.name });

        if (entry.kind == .directory) {
            num_dirs.* += 1;

            var new_prefix_buffer: [50]u8 = undefined;
            const new_prefix: []u8 = try std.fmt.bufPrint(&new_prefix_buffer, "{s}{s}   ", .{ prefix, if (isLast) " " else "│" });

            // TODO: Add -a to display the insides of directories that start with a "."
            if (entry.name[0] != '.') {
                var path_buffer: [50]u8 = undefined;
                const full_path = try std.fmt.bufPrint(&path_buffer, "{s}{s}{s}", .{ path, "/", entry.name });
                const sub_dir = try std.fs.cwd().openDir(full_path, .{ .iterate = true });
                try walkDir(sub_dir, full_path, new_prefix, num_dirs, num_files);
            }
        } else num_files.* += 1;

        curr_entry = next_entry;
        next_entry = try it.next();
    }
}
