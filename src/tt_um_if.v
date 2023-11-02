`default_nettype none

module tt_um_if (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    
    wire [7:0] threshold = 8'hE6;  // Example threshold value
    
    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    assign uio_out[6:0] = 6'd0;
    


    // instantiate lif neuron 
    if_neuron if_neuron1(.current(ui_in), .clk(clk), .rst_n(rst_n), .spike(uio_out[7]), .state(uo_out), .threshold(threshold));

endmodule
