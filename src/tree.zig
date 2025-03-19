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

        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const stdout = std.io.getStdOut().writer();
        try stdout.print("·\n", .{});
        try t.walkDirsAux(dir, "", arena.allocator());
        try stdout.print("\n{} {s}, {} {s}\n", .{
            num_dirs,
            if (num_dirs == 1) "directory" else "directories",
            num_files,
            if (num_files == 1) "file" else "files",
        });
    }

    fn walkDirsAux(t: Tree, dir: std.fs.Dir, prefix: []const u8, alloc: std.mem.Allocator) !void {
        const stdout = std.io.getStdOut().writer();

        var it = dir.iterate();
        var curr_entry = try it.next();
        var next_entry = try it.next();

        while (curr_entry) |entry| {
            // Saveguard to avoid conflicting entry names
            if (std.mem.indexOfScalar(u8, entry.name, 0) != null) {
                curr_entry = next_entry;
                next_entry = try it.next();
                continue;
            }

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
                    const new_prefix: []u8 = try std.fmt.allocPrint(alloc, "{s}{s}   ", .{ prefix, if (is_last_entry) " " else "│" });

                    const sub_dir = dir.openDir(entry.name, .{ .iterate = true }) catch return;
                    try t.walkDirsAux(sub_dir, new_prefix, alloc);
                }
            } else num_files += 1;

            curr_entry = next_entry;
            next_entry = try it.next();
        }
    }
};
