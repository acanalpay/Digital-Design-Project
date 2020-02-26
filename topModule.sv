`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2019 02:08:45 PM
// Design Name: 
// Module Name: topModule
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


module topModule(input clk, input reset, input[1:0] display, input logic[1:0] sw, 
            input check, input logic btnU, input logic btnL, input logic btnR, 
            input logic btnD,
            input w_en, input start,
            input logic[3:0] switches, output logic[15:0] led,
            output dp, output logic[6:0] seg, output[3:0] an, output logic[7:0] rowsOut,
            output logic shcp, stcp, mr, oe, ds);
    logic countState; // whether to increase count or not
    logic[7:0][7:0] dataMatrix; // original matrix
    logic[7:0][7:0] dataNew; // current matrix
    
    logic gameStart, gameOver;// gameStart 
    
    
    logic[15:0] count; // count
    logic sel, u, d, l, r; // whether already entered or not
    /*
        sel => is game started?
        u => is last pressed button up?
        d => is last pressed button down?
        l => is last pressed button left?
        r => is last pressed button right?
    */

    part3 par(gameOver, sel, count, clk, reset, display, sw, check, w_en,
                switches, led, dp, seg, an, dataMatrix);
    initial begin
        dataNew <= 64'b0;
        count <= 16'b0;
        countState <= 4'b0;
        sel = 0;
        u <= 0; d <= 0;
        r <= 0; l <= 0;
        gameStart <= 1;
        gameOver <= 0;
    end
    // locations of the buttons
    int up[15:0];
    int down[15:0];
    int right[15:0];
    int left[15:0];
    
    initial begin
        up[0] = 0;  up[1] = 2; up[2] = 4; up[3] = 6;
        up[4] = 16;  up[5] = 18; up[6] = 20; up[7] = 22;
        up[8] = 32;  up[9] = 34; up[10] = 36; up[11] = 38;
        up[12] = 48;  up[13] = 50; up[14] = 52; up[15] = 54;
        
        left[0] = 1;  left[1] = 3; left[2] = 12; left[3] = 14;
        left[4] = 17;  left[5] = 19; left[6] = 28; left[7] = 30;
        left[8] = 40;  left[9] = 42; left[10] = 44; left[11] = 46;
        left[12] = 56;  left[13] = 58; left[14] = 60; left[15] = 62;
        
        down[0] = 5;  down[1] = 7; down[2] = 8; down[3] = 10;
        down[4] = 21;  down[5] = 23; down[6] = 24; down[7] = 26;
        down[8] = 33;  down[9] = 35; down[10] = 37; down[11] = 39;
        down[12] = 49;  down[13] = 51; down[14] = 53; down[15] = 55;
        
        right[0] = 9;  right[1] = 11; right[2] = 13; right[3] = 15;
        right[4] = 25;  right[5] = 27; right[6] = 29; right[7] = 31;
        right[8] = 41;  right[9] = 43; right[10] = 45; right[11] = 47;
        right[12] = 57;  right[13] = 59; right[14] = 61; right[15] = 63;
    end

    always_ff@(posedge clk)
    begin
        if(reset == 1) begin
            dataNew = 64'b0;
            count = 16'b0;
            //dataMatrix = 64'b0;
            u = 0; d = 0;
            r = 0; l = 0;
            gameStart = 0;
            sel = 0;
            gameOver = 0;
        end
        else if(start == 1) begin
            sel = 1;
            count = 16'b0;
            u = 0; d = 0;
            r = 0; l = 0;
            gameStart = 1;
            for(int i = 0; i < 8; i++) begin
                for(int j = 0; j < 8; j++) begin
                    dataNew[i][j] = dataMatrix[i][j];
                end
            end
        end
        
        else if( sel == 1) begin
            gameStart = 0; // check whether the game is finished or not
            for(int i = 0; i < 8; i++)begin
                for(int j = 0; j < 8; j++) begin
                    if(dataNew[i][j] == 1) begin 
                        gameStart = 1;
                    end
                end
            end
            gameOver = ~gameStart; // if the game is over, go to the blink state
            if(btnU == 1 && gameStart == 1)begin 
                if(countState == 0 && u == 0)begin
                    countState = 1;
                    count = count + 1;
                    u = 1; d = 0;
                    r = 0; l = 0;
                end
                else begin
                    countState = 1;
                end
                for(int i = 0; i < 16; i++)begin
                    int x = up[i] / 8;
                    int y = up[i] % 8;
                    int n = (x - 1) % 8;
                    int s = (x + 1) % 8;
                    int e = (y + 1) % 8;
                    int w = (y - 1) % 8;
                    if(dataNew[n][y] == 1 && dataNew[x][e] == 1 && dataNew[x][w] == 1 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[n][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[s][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[n][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 1 && dataNew[x][e] == 0 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 1) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end                
                    else begin
                        dataNew[x][y] = 0;
                    end
                end
            end
            
            else if(btnD == 1 && gameStart == 1)begin
                if(countState == 0 && d == 0)begin
                    countState = 1;
                    count = count + 1;
                    u = 0; d = 1;
                    r = 0; l = 0;
                end
                else begin
                    countState = 1;
                end
                for(int i = 0; i < 16; i++)begin
                    int x = down[i] / 8;
                    int y = down[i] % 8;
                    int n = (x - 1) % 8;
                    int s = (x + 1) % 8;
                    int e = (y + 1) % 8;
                    int w = (y - 1) % 8;
                    if(dataNew[n][y] == 1 && dataNew[x][e] == 1 && dataNew[x][w] == 1 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[n][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[s][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[n][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 1 && dataNew[x][e] == 0 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 1) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end                
                    else begin
                        dataNew[x][y] = 0;
                    end
                end
            end        
            else if(btnR == 1 && gameStart == 1)begin
                if(countState == 0 && r == 0)begin
                    countState = 1;
                    count = count + 1;
                    u = 0; d = 0;
                    r = 1; l = 0;
                end
                else begin
                    countState = 1;
                end
                for(int i = 0; i < 16; i++)begin
                    int x = right[i] / 8;
                    int y = right[i] % 8;
                    int n = (x - 1) % 8;
                    int s = (x + 1) % 8;
                    int e = (y + 1) % 8;
                    int w = (y - 1) % 8;
                    if(dataNew[n][y] == 1 && dataNew[x][e] == 1 && dataNew[x][w] == 1 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[n][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[s][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[n][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 1 && dataNew[x][e] == 0 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 1) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end                
                    else begin
                        dataNew[x][y] = 0;
                    end
                end
            end
            
            else if(btnL == 1 && gameStart == 1)begin
                if(countState == 0 && l == 0)begin
                    countState = 1;
                    count = count + 1;
                    u = 0; d = 0;
                    r = 0; l = 1;
                end
                else begin
                    countState = 1;
                end
                for(int i = 0; i < 16; i++)begin
                    int x = left[i] / 8;
                    int y = left[i] % 8;
                    int n = (x - 1) % 8;
                    int s = (x + 1) % 8;
                    int e = (y + 1) % 8;
                    int w = (y - 1) % 8;
                    if(dataNew[n][y] == 1 && dataNew[x][e] == 1 && dataNew[x][w] == 1 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[n][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[s][y] == 1 && dataNew[x][w] == 1 &&
                             dataNew[x][e] == 0 && dataNew[n][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 1 && dataNew[x][e] == 0 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 1) begin
                        dataNew[x][y] = 1;
                    end
                    else if(dataNew[x][w] == 0 && dataNew[x][e] == 1 &&
                            dataNew[n][y] == 0 && dataNew[s][y] == 0) begin
                        dataNew[x][y] = 1;
                    end                
                    else begin
                        dataNew[x][y] = 0;
                    end
                end
            end
            else begin
                countState = 0;
            end
        end
    end
    
    converter con(clk, dataNew, rowsOut, shcp, stcp, mr, oe, ds);

//    SevSeg_4digit sevenseg(clk, control[3:0], control[7:4], control[11:8], control[15:12], 
//                    seg[0], seg[1], seg[2], seg[3],
//                    seg[4], seg[5], seg[6], dp, an);
endmodule
