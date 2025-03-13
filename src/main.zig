const std = @import("std");

var with_hidden_directories = false;
var with_color = false;

pub fn main() !void {
    var args = std.process.args();
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            return printHelp();
        } else if (std.mem.eql(u8, arg, "-a") or std.mem.eql(u8, arg, "-A")) {
            with_hidden_directories = true;
        } else if (std.mem.eql(u8, arg, "-c") or std.mem.eql(u8, arg, "-C")) {
            with_color = true;
        }
    }

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
        const is_last_entry = next_entry == null;

        if (with_color and entry.kind == .directory) {
            try stdout.print("{s}{s}── \x1b[36m{s}\x1b[0m\n", .{ prefix, if (is_last_entry) "└" else "├", entry.name });
        } else {
            try stdout.print("{s}{s}── {s}\n", .{ prefix, if (is_last_entry) "└" else "├", entry.name });
        }

        if (entry.kind == .directory) {
            num_dirs.* += 1;

            var new_prefix_buffer: [50]u8 = undefined;
            const new_prefix: []u8 = try std.fmt.bufPrint(&new_prefix_buffer, "{s}{s}   ", .{ prefix, if (is_last_entry) " " else "│" });

            if (with_hidden_directories or entry.name[0] != '.') {
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

fn printHelp() !void {
    const message =
        \\Usage ftree [options]
        \\
        \\Options:
        \\  -h, --help       Show the help message information
        \\  -a, -A           Include the content of directories that start with "."
        \\  -c, -C           Include color coding in the tree for the different elements
        \\
        \\
    ;

    try std.io.getStdOut().writer().print("{s}", .{message});
}
