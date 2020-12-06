/*
    Proyecto final
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`timescale 1ns/1ps

`ifndef DEFINES_V
`include "./src/defines.v"
`endif

/*
    Módulo que genera las señales de prueba que se inyectarán en el contador.
*/
module test_1 #( 
    parameter FILE  = "./logs/log.txt", 
    parameter WIDTH = 4
)
(
    output reg  enable, 
    output reg  clk, 
    output reg  reset, 
    output reg  [1:0] mode, 
    output reg  [WIDTH-1:0] D
);

    integer log;

    // Inicia el reloj en 0.
    initial clk = `BAJO;
    always #`CLK clk = !clk;
        
    // Al iniciar el test resetea el circuito.
    initial enable           = `BAJO;
    initial #(`CLK*2) enable = `ALTO; 
    initial reset            = `ALTO;
    initial #(`CLK*2) reset  = `BAJO;
        
    initial #(`CLK*282) enable = `DESACTIVADO;
    initial #(`CLK*282) reset  = `DESACTIVADO;

    initial #(`CLK*352) enable = `ACTIVO;
    initial #(`CLK*352) reset  = `DESACTIVADO;


    // Se coloca el protocolo de verificación.
    initial
    begin
        mode = `CARGA_D;
        D = `BAJO;

        // Prueba el modo 00.
        #(`CLK*2) mode = `CUENTA_TRES_TRES;
                    
        // Prueba el modo 01.
        #(`CLK*70) mode = `CUENTA_MENOS_UNO;
            
        // Prueba el modo 10.
        #(`CLK*70) mode = `CUENTA_MAS_UNO;
            
        // Prueba el modo 11.
        #(`CLK*70) mode = `CARGA_D;
                    
        // Se probarán los modos de forma aleatoria hasta el final de la simulación.
        // También las entradas enable-reset cambiarán aleatoriamente.
        forever
        begin
            #(`CLK*70) mode <= $random;
            #($urandom_range( `CLK*10, `CLK*20) ) enable <= $random;
            #($urandom_range( `CLK*10, `CLK*20) ) reset  <= $random; 
        end

    end

    // D es aleatorio durante toda la simulación.
    always
    begin
        #(`CLK*20) D <= $random; 
    end

    // Crea el archivo de logs.
    initial 
    begin
        log = $fopen (FILE); 
        $display ("\n\n********** Start simulation **********\n");
        $fdisplay(log, "********** Start simulation **********\n");
    end


//    /**/
//    `ifdef CONT_CICLO_MEDIO_4b
//
//        // Crea el archivo de logs.
//        initial 
//        begin
//            log = $fopen (FILE); 
//            $display ("\n\n********** Start simulation **********\n");
//            $fdisplay(log, "********** Start simulation **********\n");
//        end
//
//    /**/
//    `else
//        
//        // Crea el archivo de logs.
//        initial 
//        begin
//            log = $fopen (FILE); 
//            $display ("\n\n********** Start simulation **********\n");
//            $fdisplay(log, "********** Start simulation **********\n");
//        end
//
//    `endif

endmodule