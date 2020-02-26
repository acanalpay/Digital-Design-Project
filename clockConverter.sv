`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2019 11:21:10 AM
// Design Name: 
// Module Name: clockConverter
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


module clockConverter(input clk, input reset, output logic clk1);
    int count;
    always@(posedge clk, posedge reset)
    begin
        if(reset == 1)
        begin
            count = 0;
            clk1 = 0;
        end
        else
        begin
            if(count >= 25000000)
            begin
                clk1 = !clk1;
                
                count = 0;
            end
            else
            begin
                count = count + 1;
            end
        end
//        led = clk1;
    end
endmodule
