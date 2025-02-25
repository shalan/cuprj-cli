// Generated Wishbone Bus Verilog Code with Bus Splitter, External Interface Mapping, IRQ Checkers, and Total WB Cell Count

module wb_bus(
    input         wb_clk,
    input         wb_rst,
    input  [31:0] wb_adr,
    inout  [31:0] wb_dat_i,
    input         wb_we,
    input         wb_stb,
    input         wb_cyc,
    input  [31:0] wb_dat_o,
    output        wb_ack,
    input  [37:0] io_in,
    output [37:0] io_out,
    output [37:0] io_oen,
    output [2:0]  user_irq
);

    localparam SLAVE_ADDR_SIZE = 32'h0001_0000;
    localparam TOTAL_WB_CELL_COUNT = 13092;

    // Wires for slave 0: PIC
    wire [31:0] slave0_dat;
    wire        slave0_ack;
    wire        cs0;

    // Wires for slave 1: UART0
    wire [31:0] slave1_dat;
    wire        slave1_ack;
    wire        cs1;

    // Wires for slave 2: UART1
    wire [31:0] slave2_dat;
    wire        slave2_ack;
    wire        cs2;

    // Wires for slave 3: UART2
    wire [31:0] slave3_dat;
    wire        slave3_ack;
    wire        cs3;

    // Wires for slave 4: UART3
    wire [31:0] slave4_dat;
    wire        slave4_ack;
    wire        cs4;

    // Wires for slave 5: TMR0
    wire [31:0] slave5_dat;
    wire        slave5_ack;
    wire        cs5;

    // Wires for slave 6: TMR1
    wire [31:0] slave6_dat;
    wire        slave6_ack;
    wire        cs6;

    // Wires for slave 7: PORTA
    wire [31:0] slave7_dat;
    wire        slave7_ack;
    wire        cs7;

    assign cs0 = ((wb_adr >= 32'h300F0000) && (wb_adr < (32'h300F0000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;
    assign cs1 = ((wb_adr >= 32'h30000000) && (wb_adr < (32'h30000000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;
    assign cs2 = ((wb_adr >= 32'h30010000) && (wb_adr < (32'h30010000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;
    assign cs3 = ((wb_adr >= 32'h30020000) && (wb_adr < (32'h30020000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;
    assign cs4 = ((wb_adr >= 32'h30030000) && (wb_adr < (32'h30030000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;
    assign cs5 = ((wb_adr >= 32'h30040000) && (wb_adr < (32'h30040000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;
    assign cs6 = ((wb_adr >= 32'h30050000) && (wb_adr < (32'h30050000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;
    assign cs7 = ((wb_adr >= 32'h30060000) && (wb_adr < (32'h30060000 + SLAVE_ADDR_SIZE))) ? 1'b1 : 1'b0;

    wire [9:0] pic_irq;
    assign pic_irq[1:0] = user_irq[1:0];

    // Instantiate the PIC
    wb_pic_8 PIC (
          .clk(wb_clk),
          .rst(wb_rst),
          .wb_addr(wb_adr),
          .wb_wdata(wb_dat_i),
          .wb_we(wb_we),
          .wb_stb(wb_stb),
          .wb_rdata(slave0_dat),
          .wb_ack(slave0_ack),
          .int_in(pic_irq[9:2]),
          .irq(user_irq[2])
    );
    // Instantiate slave UART0 of type EF_UART_WB
    EF_UART_WB UART0 (
        .clk_i(wb_clk),
        .rst_i(wb_rst),
        .adr_i(wb_adr),
        .dat_o(slave1_dat),
        .dat_i(wb_dat_i),
        .we_i(wb_we),
        .stb_i(wb_stb & cs1),
        .cyc_i(wb_cyc & cs1),
        .ack_o(slave1_ack),
        .rx(io_in[12:12]),
        .tx(io_out[13:13]),
        .IRQ(pic_irq[0])
    );

    // Instantiate slave UART1 of type EF_UART_WB
    EF_UART_WB UART1 (
        .clk_i(wb_clk),
        .rst_i(wb_rst),
        .adr_i(wb_adr),
        .dat_o(slave2_dat),
        .dat_i(wb_dat_i),
        .we_i(wb_we),
        .stb_i(wb_stb & cs2),
        .cyc_i(wb_cyc & cs2),
        .ack_o(slave2_ack),
        .rx(io_in[14:14]),
        .tx(io_out[15:15]),
        .IRQ(pic_irq[1])
    );

    // Instantiate slave UART2 of type EF_UART_WB
    EF_UART_WB UART2 (
        .clk_i(wb_clk),
        .rst_i(wb_rst),
        .adr_i(wb_adr),
        .dat_o(slave3_dat),
        .dat_i(wb_dat_i),
        .we_i(wb_we),
        .stb_i(wb_stb & cs3),
        .cyc_i(wb_cyc & cs3),
        .ack_o(slave3_ack),
        .rx(io_in[16:16]),
        .tx(io_out[17:17]),
        .IRQ(pic_irq[2])
    );

    // Instantiate slave UART3 of type EF_UART_WB
    EF_UART_WB UART3 (
        .clk_i(wb_clk),
        .rst_i(wb_rst),
        .adr_i(wb_adr),
        .dat_o(slave4_dat),
        .dat_i(wb_dat_i),
        .we_i(wb_we),
        .stb_i(wb_stb & cs4),
        .cyc_i(wb_cyc & cs4),
        .ack_o(slave4_ack),
        .rx(io_in[18:18]),
        .tx(io_out[19:19]),
        .IRQ(pic_irq[3])
    );

    // Instantiate slave TMR0 of type EF_TMR32_WB
    EF_TMR32_WB TMR0 (
        .clk_i(wb_clk),
        .rst_i(wb_rst),
        .adr_i(wb_adr),
        .dat_o(slave5_dat),
        .dat_i(wb_dat_i),
        .we_i(wb_we),
        .stb_i(wb_stb & cs5),
        .cyc_i(wb_cyc & cs5),
        .ack_o(slave5_ack),
        .pwm0(io_out[20:20]),
        .pwm1(io_out[21:21]),
        .pwm_fault(1'b0)
    );

    // Instantiate slave TMR1 of type EF_TMR32_WB
    EF_TMR32_WB TMR1 (
        .clk_i(wb_clk),
        .rst_i(wb_rst),
        .adr_i(wb_adr),
        .dat_o(slave6_dat),
        .dat_i(wb_dat_i),
        .we_i(wb_we),
        .stb_i(wb_stb & cs6),
        .cyc_i(wb_cyc & cs6),
        .ack_o(slave6_ack),
        .pwm0(io_out[22:22]),
        .pwm1(io_out[23:23]),
        .pwm_fault(1'b0)
    );

    // Instantiate slave PORTA of type EF_GPIO8_WB
    EF_GPIO8_WB PORTA (
        .clk_i(wb_clk),
        .rst_i(wb_rst),
        .adr_i(wb_adr),
        .dat_o(slave7_dat),
        .dat_i(wb_dat_i),
        .we_i(wb_we),
        .stb_i(wb_stb & cs7),
        .cyc_i(wb_cyc & cs7),
        .ack_o(slave7_ack),
        .io_in(io_in[37:30]),
        .io_out(io_out[37:30]),
        .io_oe(io_oen[37:30]),
        .IRQ(pic_irq[4])
    );

    // Bus splitter: Multiplexer for slave outputs
    reg [31:0] selected_dat;
    reg        selected_ack;
    always @(*) begin
        if (cs0) begin
            selected_dat = slave0_dat;
            selected_ack = slave0_ack;
        end
        else if (cs1) begin
            selected_dat = slave1_dat;
            selected_ack = slave1_ack;
        end
        else if (cs2) begin
            selected_dat = slave2_dat;
            selected_ack = slave2_ack;
        end
        else if (cs3) begin
            selected_dat = slave3_dat;
            selected_ack = slave3_ack;
        end
        else if (cs4) begin
            selected_dat = slave4_dat;
            selected_ack = slave4_ack;
        end
        else if (cs5) begin
            selected_dat = slave5_dat;
            selected_ack = slave5_ack;
        end
        else if (cs6) begin
            selected_dat = slave6_dat;
            selected_ack = slave6_ack;
        end
        else if (cs7) begin
            selected_dat = slave7_dat;
            selected_ack = slave7_ack;
        end
        else begin
            selected_dat = 32'h0;
            selected_ack = 1'b0;
        end
    end

    assign wb_dat_o = selected_dat;
    assign wb_ack = selected_ack;

    assign io_oen[0] = 1'b1;
    assign io_out[0] = 1'b0;
    assign io_oen[1] = 1'b1;
    assign io_out[1] = 1'b0;
    assign io_oen[2] = 1'b1;
    assign io_out[2] = 1'b0;
    assign io_oen[3] = 1'b1;
    assign io_out[3] = 1'b0;
    assign io_oen[4] = 1'b1;
    assign io_out[4] = 1'b0;
    assign io_oen[5] = 1'b1;
    assign io_out[5] = 1'b0;
    assign io_oen[6] = 1'b1;
    assign io_out[6] = 1'b0;
    assign io_oen[7] = 1'b1;
    assign io_out[7] = 1'b0;
    assign io_oen[8] = 1'b1;
    assign io_out[8] = 1'b0;
    assign io_oen[9] = 1'b1;
    assign io_out[9] = 1'b0;
    assign io_oen[10] = 1'b1;
    assign io_out[10] = 1'b0;
    assign io_oen[11] = 1'b1;
    assign io_out[11] = 1'b0;
    assign io_oen[12] = 1'b0;
    assign io_oen[13] = 1'b1;
    assign io_oen[14] = 1'b0;
    assign io_oen[15] = 1'b1;
    assign io_oen[16] = 1'b0;
    assign io_oen[17] = 1'b1;
    assign io_oen[18] = 1'b0;
    assign io_oen[19] = 1'b1;
    assign io_oen[20] = 1'b1;
    assign io_oen[21] = 1'b1;
    assign io_oen[22] = 1'b1;
    assign io_oen[23] = 1'b1;
    assign io_oen[24] = 1'b1;
    assign io_out[24] = 1'b0;
    assign io_oen[25] = 1'b1;
    assign io_out[25] = 1'b0;
    assign io_oen[26] = 1'b1;
    assign io_out[26] = 1'b0;
    assign io_oen[27] = 1'b1;
    assign io_out[27] = 1'b0;
    assign io_oen[28] = 1'b1;
    assign io_out[28] = 1'b0;
    assign io_oen[29] = 1'b1;
    assign io_out[29] = 1'b0;

endmodule

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,
    inout vdda2,
    inout vssa1,
    inout vssa2,
    inout vccd1,
    inout vccd2,
    inout vssd1,
    inout vssd2,
`endif
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,
    inout [`MPRJ_IO_PADS-10:0] analog_io,
    input   user_clock2,
    output [2:0] user_irq
);
    wire [31:0] wb_dat_bus;
    wire [`MPRJ_IO_PADS-1:0] internal_io_oen;
    wb_bus u_wb_bus (
        .wb_clk(wb_clk_i),
        .wb_rst(wb_rst_i),
        .wb_adr(wbs_adr_i),
        .wb_dat_o(wbs_dat_o),
        .wb_dat_i(wbs_dat_i),
        .wb_we(wbs_we_i),
        .wb_stb(wbs_stb_i),
        .wb_cyc(wbs_cyc_i),
        .wb_ack(wbs_ack_o),
        .io_in(io_in),
        .io_out(io_out),
        .io_oen(internal_io_oen),
        .user_irq(user_irq)
    );
    assign io_oeb = ~internal_io_oen;
endmodule