`timescale 1ns / 1ps

module multiplier_tb();


parameter length = 100;
parameter period = 10.0; // in ns
parameter half_period = period / 2;
parameter skew = 0.490;

integer i;

reg [63:0] a;
reg [63:0] b;
wire [127:0] f;
reg clk;

multiplier multiplier(
    .a(a),
    .b(b),
    .f(f)
);


initial begin
    clk = 0;
    void'($urandom(32'hdeadbeef));// Set a fixed seed for reproducibility
    $dumpfile("simulation.vcd");
    $dumpvars();
end


always begin
    clk = ~clk;
    #half_period;
end

initial begin
    #period;#period;

    #skew;
    for (i = 0; i < length; i = i + 1) begin
        a = { $urandom(), $urandom() }; // 64-bit integer
        b = { $urandom(), $urandom() }; // 64-bit integer
        #period;
        $display(i, a, b, f);
    end
    #period;

    // finish
    $finish;
end

endmodule