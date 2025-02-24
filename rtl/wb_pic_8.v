/*
  A Programmable Interrupt COntroller (PIC) for Caravel User's Project
  
  - Register Map & WB Interface: 
    0x00: 8‑bit Pending Register (read‑only)
    0x04: 8‑bit Interrupt Enable Register (read/write)
    0x08: 32‑bit Packed Priority Register (read/write, with eight 4‑bit fields)
    0x0C: Global Interrupt Control Register (read/write; bit 0 = global enable)
    0x10: Interrupt Acknowledge Register (write‑only; writing a ‘1’ clears the corresponding pending bit)
    0x14: Highest IRQ Register (read‑only; contains the computed 3‑bit highest priority interrupt ID)
  - Priority Encoder:
    For each interrupt that is both pending and enabled (and when global interrupts are active), 
    it compares the 4‑bit priority value (from the packed priority register). The interrupt with 
    the lowest numerical value is selected.
*/

module wb_pic_8 (
    input         clk,
    input         rst,
    // WB slave interface signals
    input  [7:0]  wb_addr,     // Address (offset from base)
    input  [31:0] wb_wdata,    // Write data
    input         wb_we,       // Write enable
    input         wb_stb,      // Strobe
    output reg [31:0] wb_rdata, // Read data
    output reg    wb_ack,      // Acknowledge
    // 8 Interrupt inputs
    input  [7:0]  int_in,
    // Interrupt output: aggregated IRQ signal
    output        irq
);

  //--------------------------------------------------------------------------
  // Register Declarations
  //--------------------------------------------------------------------------

  // Interrupt Pending Register: each bit is set when the corresponding
  // interrupt is detected.
  reg [7:0] pending_reg;
  
  // Interrupt Enable Register: each bit controls enabling of an interrupt.
  reg [7:0] enable_reg;
  
  // Packed Priority Register: contains eight 4-bit fields. For example,
  // bits [3:0] are the priority for interrupt 0, bits [7:4] for interrupt 1, etc.
  reg [31:0] priority_reg;
  
  // Global interrupt enable (from Global Interrupt Control Register, bit0).
  reg global_en;
  
  // Highest IRQ Register: stores the highest (i.e. most urgent) pending
  // interrupt ID, computed by the priority encoder.
  reg [2:0] highest_irq;

  //--------------------------------------------------------------------------
  // Wishbone Bus Slave Interface
  //--------------------------------------------------------------------------

  // This always block handles register updates and bus read/write transactions.
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pending_reg   <= 8'b0;
      enable_reg    <= 8'b0;
      // Default priorities: lower number = higher priority.
      priority_reg  <= {4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0};
      global_en     <= 1'b1;  // Enable interrupts by default.
      wb_ack        <= 1'b0;
    end else begin
      // Latch new interrupt events (for edge/level sensitive inputs, adjust as needed).
      pending_reg <= pending_reg | int_in;
      
      if (wb_stb) begin
        wb_ack <= 1'b1;
        case (wb_addr)
          // 0x00: Read the Pending Register.
          8'h00: begin
            wb_rdata <= {24'b0, pending_reg};
          end
          // 0x04: Read/Write Interrupt Enable Register.
          8'h04: begin
            if (wb_we)
              enable_reg <= wb_wdata[7:0];
            wb_rdata <= {24'b0, enable_reg};
          end
          // 0x08: Read/Write Packed Priority Register.
          8'h08: begin
            if (wb_we)
              priority_reg <= wb_wdata;
            wb_rdata <= priority_reg;
          end
          // 0x0C: Read/Write Global Interrupt Control Register.
          8'h0C: begin
            if (wb_we)
              global_en <= wb_wdata[0];
            wb_rdata <= {31'b0, global_en};
          end
          // 0x10: Write-only: Interrupt Acknowledge Register.
          // Writing a '1' to a bit clears the corresponding pending bit.
          8'h10: begin
            if (wb_we)
              pending_reg <= pending_reg & ~(wb_wdata[7:0]);
            wb_rdata <= 32'b0;
          end
          // 0x14: Read the Highest IRQ Register.
          8'h14: begin
            wb_rdata <= {29'b0, highest_irq};
          end
          default: wb_rdata <= 32'b0;
        endcase
      end else begin
        wb_ack <= 1'b0;
      end
    end
  end

  //--------------------------------------------------------------------------
  // Priority Encoder (Combinational Logic)
  //--------------------------------------------------------------------------

  // This block scans through the 8 interrupts (only if both pending and enabled)
  // and selects the one with the lowest 4-bit priority value.
  reg [2:0] selected_id;
  reg [3:0] min_priority;
  integer i;
  always @(*) begin
    selected_id = 3'd0;
    min_priority = 4'hF; // Initialize to the maximum value.
    for (i = 0; i < 8; i = i + 1) begin
      // Consider an interrupt only if global enable is active and the interrupt
      // is both pending and enabled.
      if (global_en && (pending_reg[i] & enable_reg[i])) begin
        // Use the slicing syntax to extract the 4-bit priority for interrupt i.
        if ( priority_reg[4*i+3 -: 4] < min_priority ) begin
          min_priority = priority_reg[4*i+3 -: 4];
          selected_id = i[2:0];
        end
      end
    end
  end

  //--------------------------------------------------------------------------
  // Register to Store Highest IRQ
  //--------------------------------------------------------------------------

  // The highest_irq register is updated synchronously with the computed value.
  always @(posedge clk or posedge rst) begin
    if (rst)
      highest_irq <= 3'd0;
    else
      highest_irq <= selected_id;
  end

  //--------------------------------------------------------------------------
  // Aggregated IRQ Output
  //--------------------------------------------------------------------------

  // The irq signal is asserted when any enabled and pending interrupt exists,
  // provided that global interrupts are enabled.
  assign irq = global_en && ((pending_reg & enable_reg) != 8'b0);

endmodule
