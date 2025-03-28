const std = @import("std");
const utils = @import("utils.zig");

pub const Tree = struct {
    init_dir: []const u8,
    with_color: bool,
    with_hidden_dirs: bool,
    save_file: ?[]const u8,

    var num_dirs: i32 = 0;
    var num_files: i32 = 0;

    pub fn walkDirs(t: Tree) !void {
        const cwd = std.fs.cwd();
        const dir = try cwd.openDir(t.init_dir, .{ .iterate = true });

        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const alloc = arena.allocator();
        var treeBuffer = try std.ArrayList(u8).initCapacity(alloc, 1024);
        defer treeBuffer.deinit();

        const bufWriter = treeBuffer.writer();
        try bufWriter.print("·\n", .{});
        try t.walkDirsAux(dir, "", alloc, bufWriter);

        const stdout = std.io.getStdOut().writer();
        try stdout.print("{s}\n{} {s}, {} {s}\n", .{
            treeBuffer.items,
            num_dirs,
            if (num_dirs == 1) "directory" else "directories",
            num_files,
            if (num_files == 1) "file" else "files",
        });

        if (t.save_file) |file_name| {
            const file = try cwd.createFile(file_name, .{});
            defer file.close();
            _ = try file.write(treeBuffer.items);
        }
    }

    fn walkDirsAux(t: Tree, dir: std.fs.Dir, prefix: []const u8, alloc: std.mem.Allocator, writer: anytype) !void {
        var it = dir.iterate();
        var curr_entry = try it.next();
        var next_entry = try it.next();

        var prefix_buffer = std.ArrayList(u8).init(alloc);
        defer prefix_buffer.deinit();

        while (curr_entry) |entry| {
            // Saveguard to avoid conflicting entry names
            if (std.mem.indexOfScalar(u8, entry.name, 0) != null) {
                curr_entry = next_entry;
                next_entry = try it.next();
                continue;
            }

            const is_last_entry = next_entry == null;

            try writer.print("{s}{s}── \x1b[{s}m{s}\x1b[0m\n", .{
                prefix,
                if (is_last_entry) "└" else "├",
                utils.getTextColor(entry, t.with_color),
                entry.name,
            });

            if (entry.kind == .directory) {
                num_dirs += 1;

                if (t.with_hidden_dirs or (entry.name.len > 0 and entry.name[0] != '.')) {
                    prefix_buffer.clearRetainingCapacity();
                    try prefix_buffer.appendSlice(prefix);
                    try prefix_buffer.appendSlice(if (is_last_entry) "    " else "│   ");

                    const sub_dir = dir.openDir(entry.name, .{ .iterate = true }) catch return;
                    try t.walkDirsAux(sub_dir, prefix_buffer.items, alloc, writer);
                }
            } else num_files += 1;

            curr_entry = next_entry;
            next_entry = try it.next();
        }
    }
};
