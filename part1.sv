`timescale 1ns / 1ps
module part1(input clk, input reset, input logic[1:0] sw, input check, 
    input[15:0] in, input logic[3:0] switches,
    output logic[15:0] x_out);
    // 101000000111100
    always@(posedge clk, posedge reset)
    begin
        if(reset == 1)
        begin
            x_out <= 0;
            
        end
        else
        begin
            if(check == 0)
            begin
                x_out <= in;
            end
            else
            begin
                case(sw)
                    2'b00:
                    begin
                        x_out[3:0] <= switches; 
                    end
                    2'b01:
                    begin
                        x_out[7:4] <= switches;
                    end
                    2'b10:
                    begin
                        x_out[11:8] <= switches;
                    end
                    2'b11:
                    begin
                        x_out[15:12] <= switches;
                    end
                endcase

            end
        end
    end
endmodule