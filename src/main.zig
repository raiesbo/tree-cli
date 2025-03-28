const std = @import("std");
const utils = @import("utils.zig");
const Tree = @import("tree.zig").Tree;

pub fn main() !void {
    var args = std.process.args();

    var with_hidden_directories_flag = false;
    var with_color_flag = false;
    var selected_directory: []const u8 = ".";
    var file_name: ?[]const u8 = null;

    while (args.next()) |arg| {
        if (std.mem.startsWith(u8, arg, ".")) {
            if (utils.isValidPath(arg)) selected_directory = arg;
        } else if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            return utils.printHelp();
        } else if (std.mem.eql(u8, arg, "-v") or std.mem.eql(u8, arg, "--version")) {
            return utils.printVersion();
        } else if (std.mem.eql(u8, arg, "-a") or std.mem.eql(u8, arg, "-A")) {
            with_hidden_directories_flag = true;
        } else if (std.mem.eql(u8, arg, "-c") or std.mem.eql(u8, arg, "-C")) {
            with_color_flag = true;
        } else if (std.mem.eql(u8, arg, "-o") or std.mem.eql(u8, arg, "-O")) {
            const selected_file = args.next();
            file_name = selected_file;
        }
    }

    const t = Tree{
        .init_dir = selected_directory,
        .with_color = with_color_flag,
        .with_hidden_dirs = with_hidden_directories_flag,
        .save_file = file_name,
    };

    try t.walkDirs();
}
