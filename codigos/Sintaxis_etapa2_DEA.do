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

****************************************
*Etapa 2. Estimación de eficiencia (DEA)

**** CLUSTER 1
clear all
use "$output\resultados"

keep if conglome==1
gen dmu=_n

dea matri_eb_publica persona_proceso m2totalfinal pim22_transmat tpromdirectivo  = matentriiee, rts(vrs) ort(in) sav("$output\COB_DEA_INP_1_m")

*************************
**** CLUSTER 2
clear all
use "$output\resultados"

keep if conglome==2
gen dmu=_n
dea matri_eb_publica persona_proceso m2totalfinal pim22_transmat tpromdirectivo  = matentriiee , rts(vrs) ort(in) sav("$output\COB_DEA_INP_2_m")

*************************
**** CLUSTER 3
clear all
use "$output\resultados"

keep if conglome==3
gen dmu=_n
dea matri_eb_publica persona_proceso m2totalfinal pim22_transmat tpromdirectivo  = matentriiee, rts(vrs) ort(in) sav("$output\COB_DEA_INP_3_m")
*************************
**** CLUSTER 4
clear all
use "$output\resultados"

keep if conglome==4
gen dmu=_n
dea matri_eb_publica persona_proceso m2totalfinal pim22_transmat tpromdirectivo  = matentriiee, rts(vrs) ort(in) sav("$output\COB_DEA_INP_4_m")

*************************
**** CLUSTER 5
clear all
use "$output\resultados"

keep if conglome==5
gen dmu=_n
dea matri_eb_publica persona_proceso m2totalfinal pim22_transmat tpromdirectivo  = matentriiee, rts(vrs) ort(in) sav("$output\COB_DEA_INP_5_m")

/*************************
**** CLUSTER 5
clear all
use "$output\resultados"

keep if conglome==5
gen dmu=_n
dea persona_proceso m2totalfinal ejecucion tpromdirectivo  = matentriiee, rts(vrs) ort(in) sav("$output\COB_DEA_INP_5_m")

*************************
**** CLUSTER 6
clear all
use "$output\resultados"

keep if conglome==6
gen dmu=_n
dea persona_proceso m2totalfinal ejecucion tpromdirectivo  = matentriiee, rts(vrs) ort(in) sav("$output\COB_DEA_INP_6_m")

************************************/
****FUSIONAMOS LOS CUATROS CLUSTERS
clear all
use "$output/COB_DEA_INP_1_m"
append using "$output/COB_DEA_INP_2_m"
append using "$output/COB_DEA_INP_3_m"
append using "$output/COB_DEA_INP_4_m"
append using "$output/COB_DEA_INP_5_m"


rename CRS_TE CRS_TE_INP // INP DE INPUT
rename VRS_TE VRS_TE_INP
rename SCALE SCALE_INP
rename RTS RTS_INP

save "$output\COB_DEA_INP_m.dta", replace

sort VRS_TE_INP

*Graficos 
*********
twoway scatter VRS_TE_INP persona_proceso, by(conglome) 
twoway scatter VRS_TE_INP m2totalfinal, by(conglome)
twoway scatter VRS_TE_INP ejecucion, by(conglome)
twoway scatter VRS_TE_INP tpromdirectivo, by(conglome)

hist VRS_TE_INP
