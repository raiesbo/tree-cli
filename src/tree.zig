const std = @import("std");

pub const Tree = struct {
    init_dir: []const u8,
    with_color: bool,
    with_hidden_dirs: bool,

    var num_dirs: i32 = 0;
    var num_files: i32 = 0;

    pub fn walkDirs(t: Tree) !void {
        const cwd = std.fs.cwd();
        const dir = try cwd.openDir(".", .{ .iterate = true });

        const stdout = std.io.getStdOut().writer();
        try stdout.print("·\n", .{});

        try t.walkDirsAux(dir, t.init_dir, "");
        try stdout.print("\nDirectories: {} Files: {}\n", .{ num_dirs, num_files });
    }

    fn walkDirsAux(t: Tree, dir: std.fs.Dir, path: []const u8, prefix: []const u8) !void {
        const stdout = std.io.getStdOut().writer();

        var it = dir.iterate();

        var curr_entry = try it.next();
        var next_entry = try it.next();

        while (curr_entry) |entry| {
            const is_last_entry = next_entry == null;

            if (t.with_color and entry.kind == .directory) {
                try stdout.print("{s}{s}── \x1b[36m{s}\x1b[0m\n", .{ prefix, if (is_last_entry) "└" else "├", entry.name });
            } else {
                try stdout.print("{s}{s}── {s}\n", .{ prefix, if (is_last_entry) "└" else "├", entry.name });
            }

            if (entry.kind == .directory) {
                num_dirs += 1;

                var new_prefix_buffer: [50]u8 = undefined;
                const new_prefix: []u8 = try std.fmt.bufPrint(&new_prefix_buffer, "{s}{s}   ", .{ prefix, if (is_last_entry) " " else "│" });

                if (t.with_hidden_dirs or entry.name[0] != '.') {
                    var path_buffer: [50]u8 = undefined;
                    const full_path = try std.fmt.bufPrint(&path_buffer, "{s}{s}{s}", .{ path, "/", entry.name });
                    const sub_dir = try std.fs.cwd().openDir(full_path, .{ .iterate = true });
                    try t.walkDirsAux(sub_dir, full_path, new_prefix);
                }
            } else num_files += 1;

            curr_entry = next_entry;
            next_entry = try it.next();
        }
    }
};
