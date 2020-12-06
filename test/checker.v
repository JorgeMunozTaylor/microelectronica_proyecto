/*
    Tarea 1
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
    Módulo que se encarga de verificar los resultados provenientes modulo
    del contador de 4 bits.
*/
module checker #( 
    parameter FILE  = "./logs/log.txt",
    parameter WIDTH = 4
)
(
    input             enable, 
    input             clk, 
    input             reset, 
    input [1:0]       mode, 
    input [WIDTH-1:0] D,

    input             load, 
    input             rco, 
    input [WIDTH-1:0] Q
);

    `ifndef TASKS_V
    `include "./test/tasks.v" // Incluye los task que verifican cada salida.
    `endif

    /**/
    `ifdef CONT_CICLO_MEDIO_4b

        integer log;
            
        reg [3:0] Q_check; // Es la variable que se comparará con la salida Q del contador.
        wire rco_check; // Es la variable que se comparará con la salida rco del contador.
        reg load_check; // Es la variable que se comparará con la salida load del contador.  

        reg Q_FALLO; // Si la salida Q falla se ponen en alto.
        reg RCO_FALLO; // Si la salida rco falla se ponen en alto.
        reg LOAD_FALLO; // Si la salida load falla se ponen en alto.

        initial log = $fopen (FILE); // Abre el archivo log para escritura. 

        reg RCO_temp; // RCO temporal que contendra el RCO para un ciclo
        reg RCO_temp2; // RCO que se usara para restarlo al RCO de un ciclo
        
        /* Este bloque se utiliza para multiplicar la senal RCO 
        y generar el medio ciclo solicitado */
        always @( negedge clk )
        begin
            if ( RCO_temp == 1 ) RCO_temp2 <= 0;
            else                 RCO_temp2 <= 1; 
        end

        assign rco_check = (RCO_temp & RCO_temp2);


        /* Este bloque simula el comportamiento del contador */
        always @( posedge clk )
        begin

            /* Si enable es 1 el contador funciona normal */
            if ( enable == `ALTO && reset == `BAJO )
            begin
                    
                    /* Si Q no está en alta impedancia el contador funciona normal */
                    case (mode)

                        `CUENTA_TRES_TRES: {RCO_temp, Q_check} <= Q_check - 3;
                        `CUENTA_MENOS_UNO: {RCO_temp, Q_check} <= Q_check - 1;
                        `CUENTA_MAS_UNO:   {RCO_temp, Q_check} <= Q_check + 1;
                        `CARGA_D:          {RCO_temp, Q_check} <= {`BAJO, D};
                        default:           {RCO_temp, Q_check} <= `DEFAULT;

                    endcase
                        

                    /* Si se esta en mode CARGA la salida load es 1, 0 en caso contrario */
                    if ( mode === `CARGA_D ) 
                        load_check <= `ALTO;
                    else
                        load_check <= `BAJO; 

            end
                    
            /* Si reset=enable=0 Q_check se pone en alta impedancia y las salidas 
            se ponen en bajo */
            else if ( enable == `BAJO && reset == `BAJO )
            begin
                Q_check    <= `BAJO;
                RCO_temp   <= `BAJO;
                load_check <= `BAJO;
            end

            /* Como reset=1 las salidas se ponen en bajo */
            else if ( enable == `ALTO && reset == `ALTO )
            begin
                Q_check    <= `BAJO;
                RCO_temp   <= `BAJO;
                load_check <= `BAJO;           
            end

            /* Como reset=1 las salidas se ponen en bajo */ 
            else if ( enable == `BAJO && reset == `ALTO )
            begin
                Q_check    <= `BAJO;
                RCO_temp   <= `BAJO;
                load_check <= `BAJO;                
            end

            /* Indica si hubo un valor equivocado para enable o reset */
            else
                $display ("ERROR: Combinación enable-reset inexistente.");


            
            // Verifica el funcionamiento de la salida Q.
            verificar_Q_4b
            (
                Q,
                Q_check,
                Q_FALLO
            );


            // Verifica el funcionamiento de la salida rco.
            verificar_rco
            (
                rco,
                rco_check,
                RCO_FALLO
            );

            
            // verifica el funcionamiento de la salida load.
            verificar_LOAD
            (
                load, 
                load_check,
                LOAD_FALLO
            );  
        
            /* Aquí se verifican las variables Q_FALLO, RCO_FALLO y LOAD_FALLO, 
            en caso de que alguna este en alto se imprimirá en la terminal el mensaje
            de fallo y se escribirá en el archivo log. */
            if ( Q_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : Q fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : Q fail", $time, mode);
            end
            
            if ( RCO_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : RCO fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : RCO fail", $time, mode);
            end

            if ( LOAD_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : LOAD fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : LOAD fail", $time, mode);
            end

        end


    `elsif CONT_CICLO_COMPLETO_4b 

        integer log;
            
        reg [3:0] Q_check; // Es la variable que se comparará con la salida Q del contador.
        reg rco_check; // Es la variable que se comparará con la salida rco del contador.
        reg load_check; // Es la variable que se comparará con la salida load del contador.  

        reg Q_FALLO; // Si la salida Q falla se ponen en alto.
        reg RCO_FALLO; // Si la salida rco falla se ponen en alto.
        reg LOAD_FALLO; // Si la salida load falla se ponen en alto.

        initial log = $fopen (FILE); // Abre el archivo log para escritura. 

        /**/
        always @( posedge clk )
        begin

            /* Si enable es 1 el contador funciona normal */
            if ( enable == `ALTO && reset == `BAJO )
            begin
                    
                    case (mode)

                        `CUENTA_TRES_TRES: {rco_check, Q_check} <= Q_check - 3;
                        `CUENTA_MENOS_UNO: {rco_check, Q_check} <= Q_check - 1;
                        `CUENTA_MAS_UNO:   {rco_check, Q_check} <= Q_check + 1;
                        `CARGA_D:          {rco_check, Q_check} <= {`BAJO, D};
                        default:           {rco_check, Q_check} <= `DEFAULT;

                    endcase
                        

                    /* Si se esta en mode CARGA la salida load es 1, 0 en caso contrario */
                    if ( mode === `CARGA_D ) 
                        load_check <= `ALTO;
                    else
                        load_check <= `BAJO; 
            end
                    
            /* Si reset=enable=0 Q_check se pone en alta impedancia y las salidas 
            se ponen en bajo */
            else if ( enable == `BAJO && reset == `BAJO )
            begin
                Q_check    <= `BAJO;
                rco_check  <= `BAJO;
                load_check <= `BAJO;
            end

            /* Como reset=1 las salidas se ponen en bajo */
            else if ( enable == `ALTO && reset == `ALTO )
            begin
                Q_check    <= `BAJO;
                rco_check  <= `BAJO;
                load_check <= `BAJO;          
            end

            /* Como reset=1 las salidas se ponen en bajo */ 
            else if ( enable == `BAJO && reset == `ALTO )
            begin
                Q_check    <= `BAJO;
                rco_check  <= `BAJO;
                load_check <= `BAJO;                
            end

            /* Indica si hubo un valor equivocado para enable o reset */
            else
                $display ("ERROR: Combinación enable-reset inexistente.");


            
            // Verifica el funcionamiento de la salida Q.
            verificar_Q
            (
                Q,
                Q_check,
                Q_FALLO
            );


            // Verifica el funcionamiento de la salida rco.
            verificar_rco
            (
                rco,
                rco_check,
                RCO_FALLO
            );

            
            // verifica el funcionamiento de la salida load.
            verificar_LOAD
            (
                load, 
                load_check,
                LOAD_FALLO
            );  
        
            /* Aquí se verifican las variables Q_FALLO, RCO_FALLO y LOAD_FALLO, 
            en caso de que alguna este en alto se imprimirá en la terminal el mensaje
            de fallo y se escribirá en el archivo log. */
            if ( Q_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : Q fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : Q fail", $time, mode);
            end
            
            if ( RCO_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : RCO fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : RCO fail", $time, mode);
            end

            if ( LOAD_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : LOAD fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : LOAD fail", $time, mode);
            end

        end


    `elsif CONT_32b

        integer log;
            
        reg [31:0] Q_check; // Es la variable que se comparará con la salida Q del contador.
        wire       rco_check; // Es la variable que se comparará con la salida rco del contador.
        reg        load_check; // Es la variable que se comparará con la salida load del contador.  

        reg Q_FALLO; // Si la salida Q falla se ponen en alto.
        reg RCO_FALLO; // Si la salida rco falla se ponen en alto.
        reg LOAD_FALLO; // Si la salida load falla se ponen en alto.

        initial log = $fopen (FILE); // Abre el archivo log para escritura. 

        reg RCO_temp; // RCO temporal que contendra el RCO para un ciclo
        reg RCO_temp2; // RCO que se usara para restarlo al RCO de un ciclo
        /* Este bloque se utiliza para multiplicar la senal RCO 
        y generar el medio ciclo solicitado */
        always @( negedge clk )
        begin
            if ( RCO_temp == 1 ) RCO_temp2 <= 0;
            else                 RCO_temp2 <= 1; 
        end

        assign rco_check = (RCO_temp & RCO_temp2);


        /* Este bloque simula el comportamiento del contador */
        always @( posedge clk )
        begin

            /* Si enable es 1 el contador funciona normal */
            if ( enable == `ALTO && reset == `BAJO )
            begin
                    
                    case (mode)

                        `CUENTA_TRES_TRES: {RCO_temp, Q_check} <= Q_check - 3;
                        `CUENTA_MENOS_UNO: {RCO_temp, Q_check} <= Q_check - 1;
                        `CUENTA_MAS_UNO:   {RCO_temp, Q_check} <= Q_check + 1;
                        `CARGA_D:          {RCO_temp, Q_check} <= {`BAJO, D};
                        default:           {RCO_temp, Q_check} <= `DEFAULT;

                    endcase
                        
                    /* Si se esta en mode CARGA la salida load es 1, 0 en caso contrario */
                    if ( mode === `CARGA_D ) 
                        load_check <= `ALTO;
                    else
                        load_check <= `BAJO; 

            end
                    
            /* Si reset=enable=0 Q_check se pone en alta impedancia y las salidas 
            se ponen en bajo */
            else if ( enable == `BAJO && reset == `BAJO )
            begin
                Q_check    <= `BAJO;
                RCO_temp   <= `BAJO;
                load_check <= `BAJO;
            end

            /* Como reset=1 las salidas se ponen en bajo */
            else if ( enable == `ALTO && reset == `ALTO )
            begin
                Q_check    <= `BAJO;
                RCO_temp   <= `BAJO;
                load_check <= `BAJO;           
            end

            /* Como reset=1 las salidas se ponen en bajo */ 
            else if ( enable == `BAJO && reset == `ALTO )
            begin
                Q_check    <= `BAJO;
                RCO_temp   <= `BAJO;
                load_check <= `BAJO;                
            end

            /* Indica si hubo un valor equivocado para enable o reset */
            else
                $display ("ERROR: Combinación enable-reset inexistente.");


            
            // Verifica el funcionamiento de la salida Q.
            verificar_Q
            (
                Q,
                Q_check,
                Q_FALLO
            );


            // Verifica el funcionamiento de la salida rco.
            verificar_rco
            (
                rco,
                rco_check,
                RCO_FALLO
            );

            
            // verifica el funcionamiento de la salida load.
            verificar_LOAD
            (
                load, 
                load_check,
                LOAD_FALLO
            );  
        
            /* Aquí se verifican las variables Q_FALLO, RCO_FALLO y LOAD_FALLO, 
            en caso de que alguna este en alto se imprimirá en la terminal el mensaje
            de fallo y se escribirá en el archivo log. */
            if ( Q_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : Q fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : Q fail", $time, mode);
            end
            
            if ( RCO_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : RCO fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : RCO fail", $time, mode);
            end

            if ( LOAD_FALLO == `ALTO ) 
            begin
                $display ("tiempo =%2d : modo %1b : LOAD fail", $time, mode);
                $fdisplay(log, "tiempo =%2d : modo %1b : LOAD fail", $time, mode);
            end

        end


    /**/

    `endif


endmodule