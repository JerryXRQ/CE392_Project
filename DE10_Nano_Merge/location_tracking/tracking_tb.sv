
`timescale 1 ns / 1 ns

module tracking_tb;

localparam string IMG_IN_NAME_BASE  = "brooklyn_bridge_720_540.bmp";
localparam string IMG_OUT_NAME = "green_dot.bmp";
localparam CLOCK_PERIOD = 10;

logic clock = 1'b1;
logic reset = '0;
logic start = '0;
logic done  = '0;

logic        in_full;
logic        in_wr_en  = '0;
logic [23:0] in_din    = '0;
logic [23:0] out_dout  = '0;

logic        in_full_1;
logic        in_wr_en_1  = '0;
logic [23:0] in_din_1    = '0;

logic        in_full_2;
logic        in_wr_en_2  = '0;
logic [23:0] in_din_2    = '0;

logic        out_rd_en;
logic        out_empty;
logic [23:0] out_dout;

logic   hold_clock      = '0;
logic   in_write_done   = '0;
logic   in_write_done_1 = '0;
logic   in_write_done_2 = '0;
logic   out_read_done   = '0;
integer out_errors      = '0;

localparam WIDTH = 720;
localparam HEIGHT = 540;
localparam BMP_HEADER_SIZE = 54;
localparam BYTES_PER_PIXEL = 3;
localparam BMP_DATA_SIZE = WIDTH*HEIGHT*BYTES_PER_PIXEL;

logic [7:0] oR_in, oG_in, oB_in;
logic valid_out;
logic [11:0] center_x_out, center_y_out;
logic [11:0] width_out, height_out;

tracking #(
    .WIDTH(WIDTH),
    .HEIGHT(HEIGHT)
) tracking_dut (
    .clock_25(clock),
    .clock_50(clock),
    .reset(reset),
    .in_wr_en(in_wr_en),

    .in_din(in_din),
    .out_dout(out_dout),
    .in_full(in_full),
    .valid(valid_out),
    .center_x(center_x_out),
    .center_y(center_y_out),
    .width(width_out),
    .height(height_out)
);

always begin
    clock = 1'b1;
    #(CLOCK_PERIOD/2);
    clock = 1'b0;
    #(CLOCK_PERIOD/2);
end

initial begin
    @(posedge clock);
    reset = 1'b1;
    @(posedge clock);
    reset = 1'b0;
end

initial begin : tb_process
    longint unsigned start_time, end_time;

    @(negedge reset);
    @(posedge clock);
    start_time = $time;

    // start
    $display("@ %0t: Beginning simulation...", start_time);
    start = 1'b1;
    @(posedge clock);
    start = 1'b0;

    // wait(out_read_done);
    end_time = $time;

    // report metrics
    $display("@ %0t: Simulation completed.", end_time);
    $display("Total simulation cycle count: %0d", (end_time-start_time)/CLOCK_PERIOD);
    $display("Total error count: %0d", out_errors);


    wait(in_write_done);
    // $display

    // end the simulation
    $finish;
end

// initial begin : generate_image_green_process
//     int i, r;
//     int out_file;
//     int cmp_file;
//     logic [7:0] bmp_header [0:BMP_HEADER_SIZE-1];

//     @(negedge reset);
//     @(negedge clock);

//     $display("@ %0t: Generating file %s...", $time, IMG_OUT_NAME);
    
//     cmp_file = $fopen(IMG_IN_NAME_BASE, "rb");
//     out_file = $fopen(IMG_OUT_NAME, "wb");
    
//     // Copy the BMP header
//     r = $fread(bmp_header, cmp_file, 0, BMP_HEADER_SIZE);
//     for (i = 0; i < BMP_HEADER_SIZE; i++) begin
//         $fwrite(out_file, "%c", bmp_header[i]);
//     end

//     i = 0;
//     while (i < BMP_DATA_SIZE/BYTES_PER_PIXEL) begin
//         @(negedge clock);
//         // if (
//         //     i==(WIDTH*100+WIDTH/2)
//         // ) begin
//         if (
//             i==(WIDTH*100+WIDTH/2)   || 
//             i==(WIDTH*100+WIDTH/2)+1 || 
//             i==(WIDTH*100+WIDTH/2)+2 ||
//             i==(WIDTH*100+WIDTH/2)+3 ||
//             i==(WIDTH*101+WIDTH/2)   || 
//             i==(WIDTH*101+WIDTH/2)+1 || 
//             i==(WIDTH*101+WIDTH/2)+2 ||
//             i==(WIDTH*101+WIDTH/2)+3 ||
//             i==(WIDTH*102+WIDTH/2)   || 
//             i==(WIDTH*102+WIDTH/2)+1 || 
//             i==(WIDTH*102+WIDTH/2)+2 ||
//             i==(WIDTH*102+WIDTH/2)+3 ||
//             i==(WIDTH*103+WIDTH/2)   || 
//             i==(WIDTH*103+WIDTH/2)+1 || 
//             i==(WIDTH*103+WIDTH/2)+2 ||
//             i==(WIDTH*103+WIDTH/2)+3 
//         ) begin
//             $fwrite(out_file, "%c%c%c", 8'b0, 8'b11111111, 8'b0);
//         end else begin
//             $fwrite(out_file, "%c%c%c", 8'b0, 8'b0, 8'b0);
//         end
//         i += 1;
//     end

//     @(negedge clock);
//     $fclose(out_file);
//     out_read_done = 1'b1;
// end

initial begin : img_read_process
    int i, r;
    int in_file;
    logic [7:0] bmp_header [0:BMP_HEADER_SIZE-1];

    @(posedge reset);
    // wait(out_read_done);
    $display("@ %0t: Loading file %s...", $time, IMG_OUT_NAME);

    in_file = $fopen(IMG_OUT_NAME, "rb");
    in_wr_en = 1'b0;

    // Skip BMP header
    r = $fread(bmp_header, in_file, 0, BMP_HEADER_SIZE);

    // Read data from image file
    i = 0;
    while ( i < BMP_DATA_SIZE+90000 ) begin
        @(negedge clock);
        in_wr_en = 1'b0;
        if (in_full == 1'b0) begin
            r = $fread(in_din, in_file, BMP_HEADER_SIZE+i, BYTES_PER_PIXEL);

            in_wr_en = 1'b1;
            i += BYTES_PER_PIXEL;
        end
        if ( valid_out ) begin
            $display("@ %0t: center_x is %d...", $time, center_x_out);
            $display("@ %0t: center_y is %d...", $time, center_y_out);
            $display("@ %0t: width_out %d...", $time, width_out);
            $display("@ %0t: height_out %d...", $time, height_out);
        end
    end

    @(negedge clock);
    in_wr_en = 1'b0;
    $fclose(in_file);
    in_write_done = 1'b1;
end


endmodule
