`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2019 08:58:24 PM
// Design Name: 
// Module Name: part2

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
// 
//////////////////////////////////////////////////////////////////////////////////


module part2(input logic game, input logic s, input[15:0] count, input clk, input reset, 
    input[1:0] display, input logic[1:0] sw, 
    input check, 
    input w_en,
    input logic[3:0] switches,
    output logic[15:0] leds, output dp, output logic[6:0] seg, output[3:0] an, 
    output logic[63:0] dataString);
    
    logic[15:0] reg1, reg2, reg3, reg4;
//    logic[15:0] led1, led2, led3, led4;
    logic[15:0] xin, xout1, xout2, xout3, xout4;
    logic check1, check2, check3, check4;
    initial begin
        xin <= 16'b0;
    end
    logic clk1;
    clockConverter clc(clk, reset, clk1);

    part1 par1(clk, reset, sw, check1, reg1, switches, xout1);//, led1);
    part1 par2(clk, reset, sw, check2, reg2, switches, xout2);//, led2);
    part1 par3(clk, reset, sw, check3, reg3, switches, xout3);//, led3);
    part1 par4(clk, reset, sw, check4, reg4, switches, xout4);//, led4);
    always_ff@(posedge clk, posedge reset)
    begin
        if(reset == 1)
        begin
            reg1 <= 0;  reg2 <= 0;
            reg3 <= 0;  reg4 <= 0;
            dataString <= 0;
            
        end
        else
        begin
           if( s == 0) begin
                    case(display)
                        2'b00:
                        begin
                            check1 <= check;
                            check2 <= 0;
                            check3 <= 0;
                            check4 <= 0;
                            xin <= xout1;
                            if(w_en == 1)
                                reg1 <= xout1;
                            
                            leds <= xout1;
                        end
                        2'b01:
                        begin
                            check2 <= check;
                            check1 <= 0;
                            check3 <= 0;
                            check4 <= 0;
                            xin <= xout2;
                            if(w_en == 1)
                                reg2 <= xout2;
                            
                            leds <= xout2;
                        end
                        2'b10:
                        begin
                            check3 <= check;
                            check2 <= 0;
                            check1 <= 0;
                            check4 <= 0;
                            xin <= xout3;
                            if(w_en == 1)
                            reg3 <= xout3;
                            
                            leds <= xout3;
                        end
                        2'b11:
                        begin
                            check4 <= check;
                            check2 <= 0;
                            check3 <= 0;
                            check1 <= 0;
                            xin <= xout4;
                            if(w_en == 1)
                                reg4 <= xout4;
                            
                            leds <= xout4;
                        end
                    endcase
                end
                else begin
                    xin <= count;
                    leds <= 16'b0;
                end
          end
        
        dataString[15:0] <= reg1;
        dataString[31:16] <= reg2;
        dataString[47:32] <= reg3;
        dataString[63:48] <= reg4;
    end
    SevSeg_4digit sevenseg(clk, game, clk1, xin[3:0], xin[7:4], xin[11:8], xin[15:12], 
                    seg[0], seg[1], seg[2], seg[3],
                    seg[4], seg[5], seg[6], dp, an);
   
endmodule
