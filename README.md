# Proyecto final

## Autor
```
Jorge Muñoz Taylor 
A53863
jorge.munoztaylor@ucr.ac.cr
```

## Reporte
Se encuentra en el repositorio con nombre: 
```
proyecto_A53863.pdf
```

## Como ejecutar el código
Ubíquese en la carpeta raíz del proyecto: 
```
cd $(PATH)/microelectronica_proyecto
```

El código puede probar cada contador por separado o todos a la vez, para ello utilize el comando MAKE de Ubuntu seguido de las etiquetas probarA, probarC, probarC o clean, como se muestra a continuación:
```
1. $ make     
2. $ make probarA
3. $ make probarB
4. $ make probarC
5. $ make clean
```
El comando 1 ejecutará las tres simulaciones.\
El comando 2 ejecutará SÓLO la simulación de la parte A.\
El comando 3 ejecutará SÓLO la simulación de la parte B.\
El comando 4 ejecutará SÓLO la simulación de la parte C.\
El comando 5 eliminará los logs y los binarios creados.\
\
Cada simulación creará una archivo de LOGs en la carpeta logs, ahí podrá analizar la salida producida por verilog, los resultados también se imprimirán en la terminal. 

Los archivos de las partes D y E se encuentran en la carpeta src en la carpeta raíz.

## Bibliotecas y/o programas necesarios
```
1. Icarus verilog 
2. GTKwave
3. Ubuntu (creado en Ubuntu 18.04)
4. Qflow
5. Magic
6. LTSpice
```
