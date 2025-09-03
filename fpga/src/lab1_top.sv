// James Kaden Cassidy kacassidy@hmc.edu 8/31/2025

// top module housing an oscillator, divider and seven segment display. Inputs of reset is used for simulation and input s controlls the value to be displayed
// on the seven segment display as well as the opperation of two onboard leds

module lab1_top (
    input   logic       reset,
    input   logic[3:0]  s,
    output  logic[2:0]  led,
    output  logic[6:0]  seg
 );

 logic          int_osc;
 logic          blink_led_on;

 //// --------- segment display --------- ////

 seven_segment_display display(.value(s), .segments(seg));

 // leg 0 controlls
 assign led[1] = s[2] ^ s[3];

 // led 1 controlls
 assign led[0] = s[1] & s[0];

 //// --------- blinking led --------- ////

 // Internal high-speed oscillator
 HSOSC #(.CLKHF_DIV(2'b00)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

 // Divider to reduce oscillator from 48Mhz to 2.4Hz
 divider Divider(.osc(int_osc), .reset, .osc_divided(blink_led_on));

 assign led[2] = blink_led_on;
	
endmodule