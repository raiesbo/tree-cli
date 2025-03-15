const std = @import("std");
const utils = @import("utils.zig");

pub const Tree = struct {
    init_dir: []const u8,
    with_color: bool,
    with_hidden_dirs: bool,

    var num_dirs: i32 = 0;
    var num_files: i32 = 0;

    pub fn walkDirs(t: Tree) !void {
        const cwd = std.fs.cwd();
        const dir = try cwd.openDir(t.init_dir, .{ .iterate = true });

        const stdout = std.io.getStdOut().writer();
        try stdout.print("·\n", .{});
        try t.walkDirsAux(dir, t.init_dir, "");
        try stdout.print("\n{} {s}, {} {s}\n", .{
            num_dirs,
            if (num_dirs == 1) "directory" else "directories",
            num_files,
            if (num_files == 1) "file" else "files",
        });
    }

    fn walkDirsAux(t: Tree, dir: std.fs.Dir, path: []const u8, prefix: []const u8) !void {
        const stdout = std.io.getStdOut().writer();

        var it = dir.iterate();
        var curr_entry = try it.next();
        var next_entry = try it.next();

        while (curr_entry) |entry| {
            const is_last_entry = next_entry == null;

            try stdout.print("{s}{s}── \x1b[{s}m{s}\x1b[0m\n", .{
                prefix,
                if (is_last_entry) "└" else "├",
                utils.getTextColor(entry, t.with_color),
                entry.name,
            });

            if (entry.kind == .directory) {
                num_dirs += 1;

                if (t.with_hidden_dirs or entry.name[0] != '.') {
                    var prefix_buffer: [256]u8 = undefined;
                    const new_prefix: []u8 = try std.fmt.bufPrint(&prefix_buffer, "{s}{s}   ", .{ prefix, if (is_last_entry) " " else "│" });

                    const alloc = std.heap.page_allocator;
                    const dir_path = try std.fs.path.join(alloc, &[_][]const u8{ path, entry.name });
                    defer alloc.free(dir_path);

                    // TODO: Validate path to see if the directory still exists before attempting to open it.
                    const sub_dir = try std.fs.cwd().openDir(dir_path, .{ .iterate = true });
                    try t.walkDirsAux(sub_dir, dir_path, new_prefix);
                }
            } else num_files += 1;

            curr_entry = next_entry;
            next_entry = try it.next();
        }
    }
};
