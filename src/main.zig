const std = @import("std");
const server = @import("server.zig");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    std.debug.print("starting server-zig\n", .{});

    const io = init.io;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    try stdout_writer.flush(); // Don't forget to flush!
}
