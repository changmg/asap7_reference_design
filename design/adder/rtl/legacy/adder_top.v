module adder_top(clk, a, b, f, cOut);
  input clk;
  input [127:0] a;
  input [127:0] b;
  // add registers after the POs
  output reg [127:0] f; 
  output reg cOut;

  // add registers before the PIs
  reg [127:0] a_reg;
  reg [127:0] b_reg;
  wire [127:0] f_wire;
  wire cOut_wire;

  // Register the inputs and outputs
  always @(posedge clk) begin
    // synchronize the PIs with the clock (PI register -> combinational circuit PI)
    a_reg <= a;
    b_reg <= b;
    // synchronize the POs with the clock (combinational circuit PO -> PO register)
    f <= f_wire;
    cOut <= cOut_wire;
  end

  // Instantiate the combinational circuit
  adder adder_inst (
    .a(a_reg),
    .b(b_reg),
    .f(f_wire),
    .cOut(cOut_wire)
  );
endmodule
