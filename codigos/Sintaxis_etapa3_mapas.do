*****************************
*MAPAS
*****************************
*Elaborado por: Javier Vargas
*****************************
*Definicion de ubigeo
*********************
clear all
global ruta "F:\Propuesta\variables"
global input "$ruta/input"
global temp  "$ruta/temp"
global output "$ruta/output"

clear all
use "$input/Padron_web2904"
br
rename *, low

keep if (niv_mod=="A1" | niv_mod=="A2" | niv_mod=="A3" | niv_mod=="B0" | niv_mod=="D1" | niv_mod=="D2" | niv_mod=="E0" | niv_mod=="E1" | niv_mod=="E2"  | niv_mod=="F0") & gestion=="1" &  estado=="1"
gen iiee=1

collapse (sum) talumno iiee, by(codgeo codooii d_dreugel d_prov d_dist) 
gen IDPROV=substr(codgeo,1,4)
destring codooii, replace
merge m:1 codooii using "$input/padron_ugel", gen(ma)
sort Región
drop if ma==2
drop ma

merge m:1 UnidadEjecutoradeEducación using "$output/COB_DEA_INP_m", keepusing(conglome VRS_TE_INP) gen(md)
drop if md!=3
drop md
sort Región

gen UBIGEO=codgeo

merge m:m UBIGEO using "$input/dbasedist.dta"
keep if _merge==3
merge m:m UBIGEO using "$input/atributo-distritos.dta", gen(m1)
sort m1
drop if m1!=3
sort _ID
br

gen conglome1=round(conglome)
duplicates drop _ID, force
sort Región

grmap conglome using "$input/coordist.dta", id(_ID) ocolor(none ..) mosize(0.001) line(data("$input\coordep.dta") size(0.2) color(black)) clnumber(70) fcolor(YlGnBu) legend(label(2 "Cluster 1") label(3 "Cluster 2") label(4 "Cluster 3") label(5 "Cluster 4") label(6 "Cluster 5") size(vsmall)) legend(title("Cluster de IGED", size(*0.5) bexpand justification(left)))

graph save "$output\cluster.gph", replace

grmap VRS_TE_INP using "$input/coordist.dta", id(_ID) ocolor(none ..) mosize(0.001) line(data("$input\coordep.dta") size(0.2) color(black)) clnumber(8) fcolor(Greens) legend(title("Niveles de eficiencia", size(*0.5) bexpand justification(left))) legend(label(2 "De 23.7% hasta 45.3%") label(3 "Más de 45.3% hasta 62.0%") label(4 "Más de 62.0% hasta 70.0%") label(5 "Más de 70.0% hasta 81.7%") label(6 "Más de 81.7% hasta 91.6%") label(7 "Más de 91.6% hasta 97.9%") label(8 "Más de 97.9% hasta 100.0%") margin(1 1 1 1)) 

graph save "$output\eficiencia.gph", replace

rename UnidadEjecutoradeEducación ue
replace ue="304-1725: REGION PASCO - EDUCACION PUERTO BERMUDEZ" if ue=="304-1725: GOB. REG. DE PASCO - EDUCACION PUERTO BERMUDEZ"
merge m:m ue using "$input\resultadomaterial2022.dta", gen(ma)
drop if ma!=3

grmap valor_logrado_ufd using "$input/coordist.dta", id(_ID) ocolor(none ..) mosize(0.001) line(data("$input\coordep.dta") size(0.2) color(black)) clnumber(9) fcolor(Reds) legend(title("Niveles de cumplimiento", size(*0.5) bexpand justification(left))) legend(label(2 "De 0% hasta 89.3%") label(3 "Más de 89.3% hasta 98.2%") label(4 "Más de 98.2% hasta 99.3%") label(5 "Más de 99.3% hasta 100%") margin(1 1 1 1)) 

graph save "$output\cumplimiento.gph", replace

graph combine "$output\cluster.gph" "$output\eficiencia.gph"

grmap valor_logrado_ufd using "$input/coordist.dta", id(_ID) ocolor(none ..) mosize(0.001) line(data("$input\coordep.dta") size(0.2) color(black)) clnumber(9) fcolor(Reds) legend(title("Niveles de cobertura", size(*0.5) bexpand justification(left))) legend(label(2 "De 0% hasta 89.3%") label(3 "Más de 89.3% hasta 98.2%") label(4 "Más de 98.2% hasta 99.3%") label(5 "Más de 99.3% hasta 100%") margin(1 1 1 1)) 


