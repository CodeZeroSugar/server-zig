const std = @import("std");
const Stream = std.Io.net.Stream;
const Map = std.static_string_map;

pub const Method = enum {
    GET,
    pub fn init(text: []const u8) !Method {
        return try MethodMap.get(text).?;
    }
    pub fn is_supported(m: []const u8) bool {
        const method = MethodMap.get(m);
        if (method) |_| {
            return true;
        }
        return false;
    }
};

const MethodMap = Map(Method).initComptime(.{
    .{ "GET", Method.GET },
});

pub const Request = struct {
    method: Method,
    uri: []const u8,
    version: []const u8,

    pub fn init(method: Method, uri: []const u8, version: []const u8) Request {
        return Request{
            .method = method,
            .uri = uri,
            .version = version,
        };
    }
};

pub fn read_request(io: std.Io, conn: Stream, buffer: []u8) !void {
    var recv_buffer: [1024]u8 = undefined;
    var reader = conn.reader(io, &recv_buffer);
    const reader_interface = &reader.interface;
    var start_index: usize = 0;
    for (0..5) |_| {
        const len = try read_next_line(reader_interface, buffer, start_index);
        start_index += len;
    }
}

fn read_next_line(reader: *std.Io.Reader, buffer: []u8, start_index: usize) !usize {
    const next_line = try reader.takeDelimiterInclusive('\n');
    @memcpy(
        buffer[start_index..(start_index + next_line.len)],
        next_line[0..],
    );

    return next_line.len;
}
