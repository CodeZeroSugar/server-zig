const std = @import("std");
const Server = @import("server.zig").Server;
const Request = @import("request.zig");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    std.debug.print("starting server-zig\n", .{});

    const io = init.io;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    try stdout_writer.flush(); // Don't forget to flush!

    const server = try Server.init(io);
    var listener = try server.listen();
    const connection = try listener.accept(io);
    defer connection.close(io);

    var request_buffer: [1000]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(io, connection, request_buffer[0..]);

    std.debug.print("{s}", .{request_buffer});
}
