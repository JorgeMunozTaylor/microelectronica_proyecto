/*
    Tarea 2
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`define CLK 200 // Tiempo del reloj

`define CUENTA_MAS_UNO   2'b00
`define CUENTA_MENOS_UNO 2'b01
`define CUENTA_TRES_TRES 2'b10 
`define CARGA_D          2'b11

`define HiZ 4'bzzzz // Alta impedancia

`define ACTIVO    1'b1 // Define el estado activo
`define DESACTIVADO 1'b0 // Define el estado desactivado

`define ALTO 1'b1 // Define el ALTO
`define BAJO 1'b0 // Define el BAJO

`define DEFAULT 'b0 // Define el estado inicial

`define TIEMPO 100000 // Tiempo de finalizacion de la simulacion