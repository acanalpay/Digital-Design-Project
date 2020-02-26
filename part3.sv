`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2019 11:10:19 AM
// Design Name: 
// Module Name: part3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// count, clk, reset, display, sw, check, w_en, switches, led, dp, seg, an, dataMatrix
//////////////////////////////////////////////////////////////////////////////////


module part3(input game, input s, input[15:0] count, input clk, input reset, input[1:0] display, 
    input logic[1:0] sw, 
    input check,
    input w_en, 
    input logic[3:0] switches,
    output logic[15:0] leds, output dp, output logic[6:0] seg, output[3:0] an,
    output logic[7:0][7:0] dataMatrix);
    
    logic[63:0] dataString;

    part2 par1(game, s, count, clk, reset, display, sw, check, 
    w_en, switches, leds, dp, seg, an, dataString);
    
    always_ff@(posedge clk)
    begin
        if( s == 0) begin
            for(int i = 0; i < 64; i++) begin
                dataMatrix[7 - (i % 8)][i / 8] <= dataString[i];
            end   
        end
    end    
//        SevSeg_4digit sevenseg(clk, leds[3:0], leds[7:4], leds[11:8], leds[15:12],
//                    seg[0], seg[1], seg[2], seg[3],
//                    seg[4], seg[5], seg[6], dp, an);
    
    
endmodule
