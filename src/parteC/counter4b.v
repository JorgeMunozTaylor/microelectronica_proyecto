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
Descripción conductual de un contador de 4 bits que tiene 4 modos de operación: 
1. Cuenta ascendente de 1 en 1.
2. Cuenta descendente de 1 en 1.
3. Cuenta ascendente de 3 en 3.
4. Carga la entrada D en Q.

Entradas:

    [in] CLK: Reloj principal del contador.
    [in] ENABLE: Habilita el contador en ALTO.
    [in] RESET: Pone las salidas del contador en 0 cuando es BAJO.
    [in] D: Número de 4 bits que se pone en Q cuando MODO es 11.
    [in] MODO: Selecciona uno de los cuatro modos de operación posibles.

Salidas:

    [out] Q: Resultado del conteo en base al modo de operación.
    [out] RCO: Indica en ALTO durante UN CICLO cuando ocurrió el rebase.
    [out] LOAD: Se pone en ALTO cuando se seleccionó el modo 11, RESET es 0 y ENABLE es 1.
*/
module counter4b 
(
    input            CLK,
    input            ENABLE,
    input            RESET,
    input      [3:0] D,
    input      [1:0] MODO,

    output reg [3:0] Q,
    output reg       RCO,
    output reg       LOAD
);      

    /* Loop principal activado por el flanco positivo de CLK */
    always @( posedge CLK )
    begin

            /* Si ENABLE es 1 el contador funciona normal */
            if ( ENABLE == `ALTO && RESET == `BAJO )
            begin
                
                /* Como Q no esta en alta impedancia el contador funciona
                normal */
                case (MODO)

                    `CUENTA_TRES_TRES: {RCO, Q} <= Q - 3;
                    `CUENTA_MENOS_UNO: {RCO, Q} <= Q - 1;
                    `CUENTA_MAS_UNO:   {RCO, Q} <= Q + 1;
                    `CARGA_D:          {RCO, Q} <= {`BAJO, D};
                    default:           {RCO, Q} <= `DEFAULT;

                endcase
                    
                /* Si se esta en modo CARGA la salida LOAD es 1, 0 en caso contrario */
                if ( MODO == `CARGA_D ) 
                    LOAD <= `ALTO;
                else
                    LOAD <= `BAJO; 
            end
                
            /* Si enable=reset=0 la salida Q = 0 y las demas salidas se
            ponen en bajo, este estado se indica con la variable temp en alto */
            else if ( ENABLE == `BAJO && RESET == `BAJO )
            begin
                Q    <= `BAJO;
                RCO  <= `BAJO;
                LOAD <= `BAJO;
            end

            /* Como el reset=1 todas las salidas se ponen en bajo */
            else if ( ENABLE == `ALTO && RESET == `ALTO )
            begin
                Q    <= `BAJO;
                RCO  <= `BAJO;
                LOAD <= `BAJO; 
            end

            /* Como el reset=1 todas las salidas se ponen en bajo */ 
            else
            begin
                Q    <= `BAJO;
                RCO  <= `BAJO;
                LOAD <= `BAJO;               
            end

    end // Always end

endmodule