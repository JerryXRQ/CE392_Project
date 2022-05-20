module tracking #(
    parameter WIDTH = 640,
    parameter HEIGHT = 480
) (
    input  logic        clock_25,
    input  logic        clock_50,
    input  logic        reset,

    // // fifo_gs2sob_empty
    // input  logic        ready,

    input  logic        in_wr_en,

    input logic [23:0] in_din,


    output logic        in_full,

    output logic         valid,
    output logic [11:0]  center_x,
    output logic [11:0]  center_y,

    output logic [11:0]  width,
    output logic [11:0]  height
);

typedef enum logic [2:0] {s0, s1, s2, s3} state_types;
state_types state, state_c;

logic valid_c;
logic [11:0] center_x_c, center_y_c;
logic [11:0] coord_x, coord_x_c, coord_y, coord_y_c;
logic [11:0] width_c, height_c;

logic [11:0] a_x, a_y, b_x, b_y;
logic [11:0] a_x_c, a_y_c, b_x_c, b_y_c;

logic start_c, start;

logic in_rd_en, in_empty;
logic [23:0] in_dout, out, out_c;
logic fifo_reset;

assign fifo_reset = ~reset;

fifo #(
    .FIFO_BUFFER_SIZE(1024),
    .FIFO_DATA_WIDTH(24)
) fifo_in_inst (
    .reset(fifo_reset),
    .wr_clk(clock_25),
    .wr_en(in_wr_en),
    .din(in_din),
    .full(in_full),
    .rd_clk(clock_50),
    .rd_en(in_rd_en),
    .dout(in_dout),
    .empty(in_empty)
);

always_ff @(posedge clock_50 or negedge reset) begin
    if (reset == 1'b0)
    begin
        center_x <= 'b0;
        center_y <= 'b0;
        coord_x  <= 'b0;
        coord_y  <= 'b0;
        width    <= 'b0;
        height   <= 'b0;
        valid    <= 'b0;
        a_x      <= 'd999;
        a_y      <= 'd999;
        b_x      <= 'b0;
        b_y      <= 'b0;
        start    <= 'b0;
        state    <= s0;
        out      <= 'b0;
    end else
    begin
        center_x <= center_x_c;
        center_y <= center_y_c;
        coord_x  <= coord_x_c;
        coord_y  <= coord_y_c;
        width    <= width_c;
        height   <= height_c;
        valid    <= valid_c;
        a_x      <= a_x_c;
        a_y      <= a_y_c;
        b_x      <= b_x_c;
        b_y      <= b_y_c;
        start    <= start_c;
        state    <= state_c;
        out      <= out_c;
    end
end

always_comb begin
    center_x_c = center_x;
    center_y_c = center_y;
    coord_x_c  = coord_x;
    coord_y_c  = coord_y;
    width_c    = width;
    height_c   = height;
    valid_c    = 'b0;
    a_x_c      = a_x;
    a_y_c      = a_y;
    b_x_c      = b_x;
    b_y_c      = b_y;
    start_c    = start;
    state_c    = state;
    out_c      = out;

    in_rd_en   = 1'b0;

    case (state)
        s0: begin
            if ( in_empty == 1'b0 ) begin
                in_rd_en = 1'b1;
                out_c = in_dout;
                coord_x_c = coord_x + 12'b1;
                if ( coord_x == WIDTH-1 ) begin
                    coord_x_c = 12'b0;
                    coord_y_c = coord_y + 12'b1;
                    if (coord_y == HEIGHT-1) begin
                        coord_y_c = 12'b0;
                    end
                end
                state_c = s2;

            end
			/*
			else begin
				center_y_c = counter;
				height_c = in_dout;
			end
			*/

            if (coord_x==WIDTH-1 && coord_y==HEIGHT-1) begin
                start_c = 1'b0;
                if (start==1'b1) begin
                    valid_c = 1'b1;
                    center_x_c = (b_x + a_x)>>1;
                    center_y_c = (b_y + a_y)>>1;
                    width_c = (b_x - a_x)+1;
                    height_c = (b_y - a_y)+1;
                end
                else begin
                    center_x_c = 0;
                    center_y_c = 0;
                    width_c = 0;
                    height_c = 0;
                end
                a_x_c = 999;
                a_y_c = 999;
                b_x_c = 0;
                b_y_c = 0;
            end
        end
        /*
        s2: begin
            state_c = s0;
            if (($unsigned(out[23:16])<=8'd50) &&
                ($unsigned(out[15:8])>=8'd100) &&
                ($unsigned(out[7:0])<=8'd50)
            ) begin
                if (start==1'b0) begin
                    start_c = 1'b1;
                    a_x_c = coord_x;
                    a_y_c = coord_y;
                end else begin
                    b_x_c = coord_x;
                    b_y_c = coord_y;
                end
            end
				*/
        s2: begin
            state_c = s0;
            if (($unsigned(out[23:16])<=$unsigned(out[15:8]>>1)) &&
                ($unsigned(out[15:8])>=8'd100) &&
                ($unsigned(out[7:0])<=$unsigned(out[15:8]>>1))
            ) begin
                if (start==1'b0) begin
                    start_c = 1'b1;
                end
                if($unsigned(coord_x)<$unsigned(a_x)) begin
                    a_x_c = coord_x;
                end
                if($unsigned(coord_x)>$unsigned(b_x)) begin
                    b_x_c = coord_x;
                end

                if($unsigned(coord_y)<$unsigned(a_y)) begin
                    a_y_c = coord_y;
                end
                if($unsigned(coord_y)>$unsigned(b_y)) begin
                    b_y_c = coord_y;
                end
            end
        end

        default: begin
            center_x_c = 'b0;
            center_y_c = 'b0;
            coord_x_c  = 'hX;
            coord_y_c  = 'hX;
            width_c    = 'hX;
            height_c   = 'hX;
            valid_c    = 'b0;
            a_x_c      = 'b0;
            a_y_c      = 'b0;
            b_x_c      = 'b0;
            b_y_c      = 'b0;
            state_c    = s0;
        end

    endcase

end

endmodule
