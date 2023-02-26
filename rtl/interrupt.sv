module interrupt (
    input wire clk,

    input wire reset_n,

    // Clock
    input wire timer_32hz,
    input wire timer_8hz,
    input wire timer_2hz,
    input wire timer_1hz,

    // Masks
    input wire [3:0] clock_mask,
    input wire [1:0] stopwatch_mask,
    input wire prog_timer_mask,

    // Factor flags
    input wire reset_clock_factor,
    output reg [3:0] clock_factor = 0,

    input wire [1:0] stopwatch_factor,
    input wire prog_timer_factor,
    input wire [1:0] input_factor,

    output reg [14:0] interrupt_req = 0
);
  always_comb begin
    interrupt_req = 0;

    // Clock is 0x102 interrupt
    interrupt_req[1] = |(clock_mask & clock_factor);
    // Stopwatch is 0x104 interrupt
    interrupt_req[3] = |(stopwatch_mask & stopwatch_factor);
    // Input uses the mask for setting the factor, for some reason
    // Input K0 is 0x106 interrupt
    interrupt_req[5] = input_factor[0];
    // Input K1 is 0x108 interrupt
    interrupt_req[7] = input_factor[1];
    // Prog timer is 0x10C interrupt
    interrupt_req[11] = |(prog_timer_mask & prog_timer_factor);
  end

  reg prev_timer_32hz = 0;
  reg prev_timer_8hz = 0;
  reg prev_timer_2hz = 0;
  reg prev_timer_1hz = 0;

  always @(posedge clk) begin
    if (~reset_n) begin
      prev_timer_32hz <= 0;
      prev_timer_8hz <= 0;
      prev_timer_2hz <= 0;
      prev_timer_1hz <= 0;

      clock_factor <= 0;
    end else begin
      prev_timer_32hz <= timer_32hz;
      prev_timer_8hz  <= timer_8hz;
      prev_timer_2hz  <= timer_2hz;
      prev_timer_1hz  <= timer_1hz;

      if (prev_timer_32hz && ~timer_32hz) begin
        clock_factor[0] <= 1;
      end

      if (prev_timer_8hz && ~timer_8hz) begin
        clock_factor[1] <= 1;
      end

      if (prev_timer_2hz && ~timer_2hz) begin
        clock_factor[2] <= 1;
      end

      if (prev_timer_1hz && ~timer_1hz) begin
        clock_factor[3] <= 1;
      end

      if (reset_clock_factor) begin
        clock_factor <= 0;
      end
    end
  end

endmodule
