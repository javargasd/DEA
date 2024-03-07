*********************
*BENCHMARKING de IGED
*********************
*Javier Vargas
*Kevin Aley
***********************
clear all
global ruta "F:\Propuesta\variables"
global input "$ruta/input"
global temp  "$ruta/temp"
global output "$ruta/output"
global cods "$ruta/codigos"

do "$cods/Sintaxis_etapa0_variables.do"
do "$cods/Sintaxis_etapa1_cluster.do"
do "$cods/Sintaxis_etapa2_DEA.do"
do "$cods/Sintaxis_etapa3_mapas.do"