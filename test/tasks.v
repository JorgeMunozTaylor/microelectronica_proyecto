/*
    Proyecto final
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`ifndef DEFINES_V
`include "./src/defines.v"
`endif

/*
    Recibe la salida Q del contador de 4 bits y su valor anterior para determinar si
    el valor es el correcto.
*/
task verificar_Q_4b 
(
    input [3:0] Qi,
    input [3:0] Q_ant,

    output reg Q_fallo
); 
    begin
        Q_fallo = ( Qi === Q_ant )? `BAJO:`ALTO;
    end	

endtask

/*
    Recibe la salida Q del contador de 32 bits y su valor anterior para determinar si
    el valor es el correcto.
*/
task verificar_Q_32b
(
    input [31:0] Qi,
    input [31:0] Q_ant,

    output reg Q_fallo
); 

    begin   
        Q_fallo = ( Qi === Q_ant )? `BAJO:`ALTO;    
    end 

endtask


/*
    Recibe la salida load del contador para determinar si
    el valor es el correcto.
*/
task verificar_LOAD
(
    input LOAD,
    input LOAD_CHECK,

    output reg LOAD_fallo
 ); 
    
    begin
        LOAD_fallo = ( LOAD === LOAD_CHECK )? `BAJO:`ALTO;
    end

endtask


/*
    Recibe la salida rco del contador para determinar si
    el valor es el correcto.
*/
task verificar_rco
(
    input RCO,
    input RCO_check,

    output reg RCO_fallo
);

    begin
        RCO_fallo = ( RCO === RCO_check )? `BAJO:`ALTO;
    end

endtask
