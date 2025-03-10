import ss_addresses::*;

module prog_timer (
    input wire clk,
    input wire clk_en,

    input wire reset,

    input wire input_k03,

    input wire enable,
    input wire mem_reset,
    input wire [2:0] clock_selection,
    input wire [7:0] counter_reload,

    input  wire reset_factor,
    output reg  factor_flags = 0,

    output reg [7:0] downcounter = 0,

    // Savestates
    input wire [31:0] ss_bus_in,
    input wire [7:0] ss_bus_addr,
    input wire ss_bus_wren,
    input wire ss_bus_reset,
    output wire [31:0] ss_bus_out
);
  reg divider_8khz = 0;
  reg [5:0] counter_8khz = 0;

  // Comb: The input clock for the timer
  reg input_clock = 0;

  reg prev_reset = 0;

  wire [31:0] ss_current_data = {16'b0, factor_flags, downcounter, divider_8khz, counter_8khz};
  wire [31:0] ss_new_data;

  always_comb begin
    case (clock_selection)
      // K03 input
      // TODO: Unused. We don't add noise rejector
      3'b000, 3'b001: input_clock = input_k03;
      // 256Hz
      3'b010: input_clock = counter_8khz[5];
      // 512Hz
      3'b011: input_clock = counter_8khz[4];
      // 1024Hz
      3'b100: input_clock = counter_8khz[3];
      // 2048Hz
      3'b101: input_clock = counter_8khz[2];
      // 4096Hz
      3'b110: input_clock = counter_8khz[1];
      // 8192Hz
      3'b111: input_clock = counter_8khz[0];
    endcase
  end

  wire [7:0] counter_reload_value = counter_reload == 0 ? 8'd255 : counter_reload;

  always @(posedge clk) begin
    if (clk_en) begin
      prev_reset <= reset;
    end

    if (reset) begin
      {divider_8khz, counter_8khz} <= ss_new_data[6:0];
    end else if (clk_en) begin
      // Every 2 ticks, we're at 2x 8,192Hz
      divider_8khz <= ~divider_8khz;

      if (enable && divider_8khz && ~prev_reset) begin
        // Special case to prevent ticking on reset
        counter_8khz <= counter_8khz + 6'h1;
      end
    end
  end

  reg prev_input_clock = 0;

  always @(posedge clk) begin
    if (reset) begin
      {factor_flags, downcounter} <= ss_new_data[15:7];
    end else if (clk_en) begin
      prev_input_clock <= input_clock;

      if (enable) begin
        if (~input_clock && prev_input_clock) begin
          downcounter <= downcounter - 8'h1;
        end

        if (downcounter == 0) begin
          // Timer elapsed
          downcounter  <= counter_reload_value;

          factor_flags <= 1;
        end
      end

      if (mem_reset) begin
        downcounter <= counter_reload_value;
      end

      if (reset_factor) begin
        factor_flags <= 0;
      end
    end
  end

  bus_connector #(
      .ADDRESS(SS_PROG_TIMER),
      // Downcounter starts at 255
      .DEFAULT_VALUE({17'b0, 8'hFF, 7'b0})
  ) ss (
      .clk(clk),

      .bus_in(ss_bus_in),
      .bus_addr(ss_bus_addr),
      .bus_wren(ss_bus_wren),
      .bus_reset(ss_bus_reset),
      .bus_out(ss_bus_out),

      .current_data(ss_current_data),
      .new_data(ss_new_data)
  );
endmodule
