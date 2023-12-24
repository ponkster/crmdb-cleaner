const std = @import("std");
const Connection = @import("pgz").Connection;
const quoteLiteral = @import("pgz").quoteLiteral;

pub const MyStruct = struct {
    message_trace_id: ?[]const u8,
    count: ?[]const u8,

    fn toNonOptionalMessageTraceId(self: MyStruct) []const u8 {
        return self.message_trace_id orelse "";
    }
};

pub fn main() !void {
    var dsn = try std.Uri.parse("postgres://admin:password123@localhost:5432/crm_outlookdb");
    var connection = try Connection.init(std.heap.page_allocator, dsn);
    defer connection.deinit();

    var result = try connection.query("select message_trace_id, count(*) from email_conversation group by message_trace_id having count(*) > 1;", MyStruct);
    defer result.deinit();

    var stmt = try connection.prepare("select id from email_conversation where message_trace_id = $1 limit 1;");
    var stmt2 = try connection.prepare("delete from email_conversation where message_trace_id = $1 and id <> $2;");
    defer stmt.deinit();
    defer stmt2.deinit();

    for (result.data) |value| {
        std.debug.print("[{s}] [{s}]\n", .{ value.message_trace_id.?, value.count.? });
        // retrive the email conversation ids that will not be deleted
        var res = try stmt.query(struct { ?[]const u8 }, .{value.message_trace_id.?});
        defer res.deinit();
        std.debug.print("total record = {} and value = {s}\n", .{ res.data.len, res.data[0].@"0".? });
        var id = res.data[0].@"0";

        var res2 = try stmt2.query(struct { ?[]const u8, ?[]const u8 }, .{ value.message_trace_id.?, id.? });
        defer res2.deinit();

        //delete the rest

    }
}
