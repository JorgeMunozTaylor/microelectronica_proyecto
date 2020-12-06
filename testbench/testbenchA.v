/*
    Tarea 2
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`timescale 1ns/1ps

`ifndef DEFINES_V
`include "./src/defines.v"
`endif

`define CONT_CICLO_MEDIO_4b 

/*
    Testbench que se usará para el contador, simplemente conecta los
    módulos, indica cuando acaba la simulación y genera el archivo VCD.
*/
module testbench;

    wire       enable; 
    wire       clk; 
    wire       reset; 
    wire [1:0] mode; 
    wire [3:0] D;
    wire       load; 
    wire       rco; 
    wire [3:0] Q;


    /* Instancia el módulo que genera las señales */
    test_1 #( 
        .FILE  ("./logs/log_parteA.txt"),
        .WIDTH ( 4 ) 
    ) TEST_1
    (
        .enable (enable), 
        .clk    (clk), 
        .reset  (reset), 
        .mode   (mode), 
        .D      (D)
    );


    /* Instancia el contador */
    counter DUV 
    (
        .CLK    (clk),
        .ENABLE (enable), 
        .RESET  (reset),
        .D      (D),  
        .MODO   (mode), 
        .Q      (Q),
        .RCO    (rco),
        .LOAD   (load)         
    );


    /* Instancia el módulo CHECK que se usará para verificar las salidas 
       del DUV */
    checker #(
        .FILE  ("./logs/log_parteA.txt"),
        .WIDTH ( 4 )
    ) CHECK
    (
        .enable (enable), 
        .clk    (clk), 
        .reset  (reset), 
        .mode   (mode), 
        .D      (D),
        .load   (load), 
        .rco    (rco), 
        .Q      (Q)
    );

    /* Acaba la simulación y genera el archivo VCD */
    initial
    begin
        $dumpfile("./bin/prueba.vcd");
        $dumpvars;
        #`TIEMPO $finish;
    end

endmodule
