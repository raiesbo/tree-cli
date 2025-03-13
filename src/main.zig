const std = @import("std");
const utils = @import("utils.zig");
const Tree = @import("tree.zig").Tree;

pub fn main() !void {
    var args = std.process.args();

    var with_hidden_directories_flag = false;
    var with_color_flag = false;
    const selected_directory: []const u8 = ".";

    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            return utils.printHelp();
        } else if (std.mem.eql(u8, arg, "-v") or std.mem.eql(u8, arg, "--version")) {
            return utils.printVersion();
        } else if (std.mem.eql(u8, arg, "-a") or std.mem.eql(u8, arg, "-A")) {
            with_hidden_directories_flag = true;
        } else if (std.mem.eql(u8, arg, "-c") or std.mem.eql(u8, arg, "-C")) {
            with_color_flag = true;
        }
    }

    const t = Tree{
        .init_dir = selected_directory,
        .with_color = with_color_flag,
        .with_hidden_dirs = with_hidden_directories_flag,
    };

    try t.walkDirs();
}
