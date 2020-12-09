/*
    Proyecto final
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`ifndef DEFINES_V
`include "defines.v"
`endif

`include "counter4b.v"

/*
Descripción conductual de un contador de 32 bits que tiene 4 modos de operación: 
1. Cuenta ascendente de 1 en 1.
2. Cuenta descendente de 1 en 1.
3. Cuenta ascendente de 3 en 3.
4. Carga la entrada D en Q.

Entradas:

    [in] CLK: Reloj principal del contador.
    [in] ENABLE: Habilita el contador en ALTO.
    [in] RESET: Pone las salidas del contador en 0 cuando es BAJO.
    [in] D: Número de 32 bits que se pone en Q cuando MODO es 11.
    [in] MODO: Selecciona uno de los cuatro modos de operación posibles.

Salidas:

    [out] Q: Resultado del conteo en base al modo de operación.
    [out] RCO: Indica en ALTO cuando ocurrió rebase.
    [out] LOAD: Se pone en ALTO cuando se seleccionó el modo 11, RESET es 0 y ENABLE es 1.
*/
module counter32b
(
    input         CLK,
    input         ENABLE,
    input         RESET,
    input  [31:0] D,
    input  [1:0 ] MODO,

    output [31:0] Q,
    output        RCO,
    output        LOAD
);

    wire [7:0] rco_wire;
    wire [7:0] load_wire;
    wire       enable_wire;
    reg        rco_resta;

    /* 
    Si el RCO del último contador es 1 pone 1 en la señal
    rco_resta que se usará posteriormente para que la señal de
    RCO de contador de 32 bits sea de un ciclo
    */
    always @( posedge CLK )
    begin
        if ( rco_wire[7] == `ALTO )
            rco_resta <= `ALTO;
        else
            rco_resta <= `BAJO;
    end

    /* 
    Asigna los valores de RCO y LOAD del contador de 32 bits. 
    La salida LOAD corresponde a la salida LOAD del último contador, RCO también
    corresponde al RCO del último contador pero se le resta 1 luego de un ciclo
    para que la salida RCO esté en ALTO durante sólo un ciclo.
    */
    assign RCO  = ( rco_wire [7] == `BAJO )? `BAJO : rco_wire[7] - rco_resta;
    assign LOAD = load_wire[7]; 

    /* Se generarán los 8 contadores con sus conexiones */
    genvar i;
    generate
    
        for ( i=0; i<8; i=i+1 )
        begin

            /* 
            Cable que va conectado al ENABLE de todos los contadores menos el primero,
            si el modo es 11 todos los contadores quedan habilitados, en caso contrario
            la entrada ENABLE queda asignada a la salida RCO del contador anterior (menos
            el primero, ese siempre está habilitado)
            */
            assign enable_wire = ( MODO==`CARGA_D )? `ALTO : rco_wire[i-1];

            /**/
            if (i==0)
            begin
                counter4b count4b
                (
                    .CLK    ( CLK           ),
                    .ENABLE ( ENABLE        ),
                    .RESET  ( RESET         ),
                    .D      ( D [3:0]       ),
                    .MODO   ( MODO          ),
                    .Q      ( Q [3:0]       ),
                    .RCO    ( rco_wire  [0] ),
                    .LOAD   ( load_wire [0] )
                );
            end
            else
            begin
                counter4b count4b
                (
                    .CLK    ( ( MODO==`CARGA_D || RESET==`ALTO || (RESET==`BAJO && ENABLE==`BAJO) )? CLK: rco_wire[i-1] ),
                    .ENABLE ( ENABLE                                                                                    ),
                    .RESET  ( RESET                                                                                     ),
                    .D      ( D [ ((4*i)+3):(4*i) ]                                                                     ),
                    .MODO   ( ( MODO == `CUENTA_TRES_TRES )? `CUENTA_MENOS_UNO : MODO                                   ),
                    .Q      ( Q [ ((4*i)+3):(4*i) ]                                                                     ),
                    .RCO    ( rco_wire  [i]                                                                             ),
                    .LOAD   ( load_wire [i]                                                                             )
                ); 
            end           

        end

    endgenerate

endmodule
