*********************
*BENCHMARKING de IGED
*********************
*Javier Vargas

***********************
clear all
global ruta "F:\Propuesta\variables"
global input "$ruta/input"
global temp  "$ruta/temp"
global output "$ruta/output"

*************************************
*Etapa 1. Estimación de los clusteres
*************************************
use "$output/variables"

pwcorr pim_per_estudianteeb iie_menos2 horas_dist pmatri_eb_rural_pub estudiantes_ebsp_docente, sta(.10) sig

cluster wardslinkage pim_per_estudianteeb horas_dist pmatri_eb_rural_pub estudiantes_ebsp_docente, measure(Gower) name(conglome)
	format conglome_hgt %15.10fc
cluster stop, rule(calinski) groups(2/10)
cluster stop, rule(duda) groups(2/10)

cluster dendrogram conglome, cutnumber(5) 
	graph export "$output/Dendograma.png", as(png) replace
cluster generate conglome = groups(5), name(conglome) ties(error)

bysort tipodeiged: ta Región conglome, m

sort codooii Región
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged
gen count=1

label define conglome 1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3" 4 "Cluster 4" 5 "Cluster 5" 
label values conglome conglome

save "$output/resultados", replace

collapse (sum) count (mean) ejecucion serv_eb_publica matri_eb_publica pim_per_estudianteeb horas_dist poriieemenos2 pmatri_eb_rural_pub servicios_iged matentriiee m2totalfinal tpromdirectivo ratiopersona_proce persona_proceso estudiantes_ebsp_docente, by(conglome)

format count matri_eb_publica serv_eb_publica pim_per_estudianteeb horas_dist pmatri_eb_rural_pub servicios_iged matentriiee m2totalfinal tpromdirectivo ratiopersona_proce %12.2fc

save "$output\tabla_resumen", replace

*Graficos
*********
clear all
use "$output\resultados"
rename count iged
*Distribucion de Clusters
graph bar (count) iged, over(conglome) legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5")) blabel(bar)

*Servicios de EB pública vs horas de distancia a la IGED 
twoway (scatter serv_eb_publica horas_dist if conglome==1) (scatter serv_eb_publica horas_dist if conglome==2) (scatter serv_eb_publica horas_dist if conglome==3) (scatter serv_eb_publica horas_dist if conglome==4) (scatter serv_eb_publica horas_dist if conglome==5) , title("Serv. de EB publica vs horas promedio de distancia") legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5"))

graph save "$output\scatter_grafico1.gph", replace

*Servicios de EB pública vs a menos de 2hrs de la IGED 
twoway (scatter serv_eb_publica poriieemenos2 if conglome==1) (scatter serv_eb_publica poriieemenos2 if conglome==2) (scatter serv_eb_publica poriieemenos2 if conglome==3) (scatter serv_eb_publica poriieemenos2 if conglome==4) (scatter serv_eb_publica poriieemenos2 if conglome==5) , title("Serv. de EB publica vs %iiee a menos de 2hrs") legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5"))

graph save "$output\scatter_grafico2.gph", replace

*Servicios de EB pública vs %matricula de EB pública rural 
twoway (scatter serv_eb_publica pmatri_eb_rural_pub if conglome==1) (scatter serv_eb_publica pmatri_eb_rural_pub if conglome==2) (scatter serv_eb_publica pmatri_eb_rural_pub if conglome==3) (scatter serv_eb_publica pmatri_eb_rural_pub if conglome==4) (scatter serv_eb_publica pmatri_eb_rural_pub if conglome==5)  , title("Serv. de EB publica vs % estudiantes de EB publica rural") legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5"))

graph save "$output\scatter_grafico3.gph", replace

*Servicios de EB pública vs PIM por estudiante 
twoway (scatter serv_eb_publica pim_per_estudianteeb if conglome==1) (scatter serv_eb_publica pim_per_estudianteeb if conglome==2) (scatter serv_eb_publica pim_per_estudianteeb if conglome==3) (scatter serv_eb_publica pim_per_estudianteeb if conglome==4) (scatter serv_eb_publica pim_per_estudianteeb if conglome==5), title("Serv. de EB publica vs PIM por estudiante de EB")  legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5") )

graph save "$output\scatter_grafico4.gph", replace

*Cantidad de material educativo vs Servicios de EB pública
twoway (scatter  matentriiee serv_eb_publica if conglome==1) (scatter matentriiee serv_eb_publica if conglome==2) (scatter matentriiee serv_eb_publica if conglome==3) (scatter matentriiee serv_eb_publica if conglome==4) (scatter matentriiee serv_eb_publica if conglome==5), title("Serv. de EB publica vs Cantidad de material educativo")  legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5") )

graph save "$output\scatter_grafico5.gph", replace


*Servicios de EB pública vs ejecución materiales 2022 
twoway (scatter serv_eb_publica ejecucion_materiales22 if conglome==1) (scatter serv_eb_publica ejecucion_materiales22 if conglome==2) (scatter serv_eb_publica ejecucion_materiales22 if conglome==3) (scatter serv_eb_publica ejecucion_materiales22 if conglome==4) (scatter serv_eb_publica ejecucion_materiales22 if conglome==5), title("Serv. de EB publica vs PIM por estudiante de EB")  legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5") )

graph save "$output\scatter_grafico6.gph", replace


*Servicios de EB pública vs ejecución materiales 2022 
twoway (scatter serv_eb_publica estudiantes_ebsp_docente if conglome==1) (scatter serv_eb_publica estudiantes_ebsp_docente if conglome==2) (scatter serv_eb_publica estudiantes_ebsp_docente if conglome==3) (scatter serv_eb_publica estudiantes_ebsp_docente if conglome==4) (scatter serv_eb_publica estudiantes_ebsp_docente if conglome==5), title("Serv. de EB publica vs Ratio de docente por estudiante")  legend( label(1 "Grupo 1") label(2 "Grupo 2") label(3 "Grupo 3") label(4 "Grupo 4") label(5 "Grupo 5") )

graph save "$output\scatter_grafico7.gph", replace













