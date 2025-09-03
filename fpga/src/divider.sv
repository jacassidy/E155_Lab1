// James Kaden Cassidy kacassidy@hmc.edu 8/31/2025

// this module takes in an oscillating signal and decreases the frequency at which it oscillates by 20000000
// this module could be improved by parameterizing this value

module divider (
    input   logic   osc,
    input   logic   reset,
    output  logic   osc_divided
);
 logic[27:0] oscillator_count, oscillator_countp1;
 logic       clear;

 assign oscillator_countp1 = oscillator_count + 1;
 
 // add one to the oscillator count on each oscillator posedge
 always_ff @ (posedge osc) begin
    if(reset == 0 | clear)  oscillator_count <= 28'b0;
    else                    oscillator_count <= oscillator_countp1;
 end

 // When the count reaches 20000000, clear the counter and start again
 always_comb begin
    if (oscillator_count == 28'h1312D00) clear = 1'b1;
    else                                 clear = 1'b0;
 end
 
 // Each time the count is clear, toggle the led
 always_ff @ (posedge clear) begin
    osc_divided <= ~osc_divided;
 end    

  

endmodule