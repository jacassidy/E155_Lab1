module lab1_top (
    input   logic       clk,
    input   logic       reset,
    input   logic[3:0]  s,
    output  logic[2:0]  led,
    output  logic[6:0]  seg
 );

 logic          int_osc;
 logic[27:0]    oscillator_count, oscillator_countp1;

 logic          clear;
 logic          blink_led_on;

 //// --------- segment display --------- ////

 seven_segment_display display(.value(s), .segments(seg));

 // leg 0 controlls
 assign led[0] = s[0] ^ s[1];

 // led 1 controlls
 assign led[1] = s[3] & s[2];

 //// --------- blinking led --------- ////

 // Internal high-speed oscillator
 HSOSC #(.CLKHF_DIV(2'b01)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

 // adder
 assign oscillator_countp1 = oscillator_count + 1;

 always_ff @ (posedge int_osc) begin
    if(reset == 0 | clear)  oscillator_count <= 28'b0;
    else                    oscillator_count <= oscillator_countp1;
 end

 always_comb begin
    if (oscillator_count == 28'h1312D00) clear = 1'b1;
    else                                 clear = 1'b0;
 end

 always_ff @ (posedge clear) begin
    blink_led_on <= ~blink_led_on;
 end    

 assign led[2] = blink_led_on;
	
endmodule