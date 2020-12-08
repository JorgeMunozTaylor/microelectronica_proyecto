#    Proyecto
#    Microelectrónica
#    Creado por Jorge Muñoz Taylor
#    Carné A53863
#    II-2020

ALL: probarA probarB probarC

probarA:
	@mkdir -p ./bin
	@mkdir -p ./logs
	@iverilog -o ./bin/PRUEBA_A ./test/test.v ./test/checker.v ./src/parteA/counter4b.v ./testbench/testbenchA.v 
	@vvp ./bin/PRUEBA_A
	@gtkwave ./bin/prueba.vcd

probarB:
	@mkdir -p ./bin
	@mkdir -p ./logs
	@iverilog -o ./bin/PRUEBA_B ./test/test.v ./test/checker.v ./src/parteA/counter4b.v ./src/parteB/counter32b.v ./testbench/testbenchB.v
	@vvp ./bin/PRUEBA_B
	@gtkwave ./bin/prueba.vcd

probarC:
	@mkdir -p ./bin
	@mkdir -p ./logs
	@iverilog -o ./bin/PRUEBA_C ./test/test.v ./test/checker.v ./src/parteC/counter4b.v ./testbench/testbenchC.v
	@vvp ./bin/PRUEBA_C
	@gtkwave ./bin/prueba.vcd

	@iverilog -o ./bin/PRUEBA_C ./test/test.v ./test/checker.v ./src/parteC/counter4b.v ./src/parteB/counter32b.v ./testbench/testbenchB.v
	@vvp ./bin/PRUEBA_C
	@gtkwave ./bin/prueba.vcd

clean:
	rm -rf ./bin ./logs
