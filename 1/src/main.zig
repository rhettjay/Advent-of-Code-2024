const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    //var file_reader = file.reader();
    //const file_info = try file.stat();
    //const file_size = file_info.size;
    //const lines = try file_reader.readAllAlloc(allocator, file_size);

    // Parse the lines into two columns
    var column1 = std.ArrayList(usize).init(allocator);
    var column2 = std.ArrayList(usize).init(allocator);
    defer column1.deinit();
    defer column2.deinit();

    // var tokenizer = std.mem.tokenize(u8, lines, "\n");
    // while (tokenizer.next()) |line| {
    //     var parts = std.mem.split(u8, line, "  ");
    //     const col1 = try std.fmt.parseInt(i32, parts.next() orelse return, 10);
    //     const col2 = try std.fmt.parseInt(i32, parts.next() orelse return, 10);
    //     try column1.append(col1);
    //     try column2.append(col2);
    // }
    //
    const stat = try file.stat();
    const data = try file.readToEndAlloc(allocator, stat.size);
    defer allocator.free(data);

    var lines = std.mem.tokenize(u8, data, "\n");
    while (lines.next()) |line| {
        var columns = std.mem.tokenize(u8, line, " ");
        const number1 = try std.fmt.parseInt(usize, columns.next() orelse return, 10);
        const number2 = try std.fmt.parseInt(usize, columns.next() orelse return, 10);
        try column1.append(number1);
        try column2.append(number2);
    }

    // Sort each column
    std.mem.sort(usize, column1.items, {}, std.sort.asc(usize));
    std.mem.sort(usize, column2.items, {}, std.sort.asc(usize));

    // Print sorted columns
    std.log.info("Column 1: {any}", .{column1.items});
    std.log.info("Column 2: {any}", .{column2.items});

    var difference : usize = 0;
    var similarity : usize = 0;

    for (column1.items, column2.items) |col1, col2| {
        if (col1 > col2) {
            var counter : usize = 0;
            for (column2.items) |item| {
                if (col1 == item) {
                    counter += 1;
                } else {
                    continue;
                }
            }
            similarity += col1 * counter;
            difference += col1 - col2;
        } else {
            var counter : usize = 0;
            for (column2.items) |item| {
                if (col1 == item) {
                    counter += 1;
                } else {
                    continue;
                }
            }
            similarity += col1 * counter;
            difference += col2 - col1;
        }
    }

    std.debug.print("Difference: {d}\n", .{difference});
    std.debug.print("Similarity: {d}\n", .{similarity});

}

