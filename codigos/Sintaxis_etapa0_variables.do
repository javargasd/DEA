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

/*
clear all
import excel using "F:\Propuesta\variables\input\20221102_GOBIERNOREGIONAL.xlsx", firstrow sheet("Hoja1")
rename *, low
save "F:\Propuesta\variables\input\20221102_GOBIERNOREGIONAL.dta", replace
clear all
import excel using "F:\Propuesta\variables\input\20221102_SECTOR10.xlsx", firstrow sheet("Hoja1")
rename *, low
save "F:\Propuesta\variables\input\20221102_SECTOR10.dta", replace
append using "F:\Propuesta\variables\input\20221102_GOBIERNOREGIONAL.dta"
save "F:\Propuesta\variables\input\20221102_PRESUPUESTO", replace
*/

***********************************
*Etapa 0. Definición de variables
***********************************

*1.1 Servicios educativos (*Ajustar la informacion)
*************************
clear all
use "$input/Padron_web2904" 
/*merge m:1 cod_mod using "$input/codigos_materiales2022.dta" se cruza contra los codigos modulares que fueron beneficiarios del material en 2022
drop if _merge!=3
drop if anexo!="0"*/

*a.Servicios de basica que recibieron material en 2022
******************************************************
gen mod_eb=1 if (niv_mod=="A1" | niv_mod=="A2" | niv_mod=="A3" | niv_mod=="A5" | niv_mod=="B0" | niv_mod=="D1" | niv_mod=="D2" | niv_mod=="E0" | niv_mod=="E1" | niv_mod=="E2"  | niv_mod=="F0") 

gen serv_eb=1 if mod_eb==1
replace serv_eb=0 if serv_eb==.

*b.Servicios de básica pública que recibieron material en 2022
**************************************************************
gen serv_eb_publica=1 if mod_eb==1 & (gestion=="1")
replace serv_eb_publica=0 if serv_eb_publica==.

	*b.1. Urbana
	gen serv_eb_urbana_publica=serv_eb if (dareacenso=="Urbana" | dareacenso=="Urbano") & mod_eb==1 & (gestion=="1")
	replace serv_eb_urbana_publica=0 if serv_eb_urbana_publica==.

	*b.2. Rural
	gen serv_eb_rural_publica=serv_eb if (dareacenso=="Rural") & mod_eb==1 & (gestion=="1")
	replace serv_eb_rural_publica=0 if serv_eb_rural_publica==.

*1.2 Estudiantes
****************
*a. Estudiantes de básica
*************************
gen matricula_total=talumno
gen matri_eb=talumno if mod_eb==1

*b. Estudiantes de básica publica
*********************************
gen matri_eb_publica=talumno if mod_eb==1 & (gestion=="1")
replace matri_eb_publica=0 if matri_eb_publica==.

	*b.1. Urbana
	gen matri_eb_urbana_publica=matri_eb if (gestion=="1") & (dareacenso=="Urbana" | dareacenso=="Urbano") & mod_eb==1
	replace matri_eb_urbana_publica=0 if matri_eb_urbana_publica==.
	
	*b.1. Rural
	gen matri_eb_rural_publica=matri_eb if (gestion=="1") & (dareacenso=="Rural") & mod_eb==1
	replace matri_eb_rural_publica=0 if matri_eb_rural_publica==.

*1.3 Docentes
*************
*a. Docentes de básica
**********************
gen docentes=tdocente
gen docentes_eb=tdocente if mod_eb==1

*b. Docentes de básica publica
*******************************
gen docentes_eb_publica=tdocente if mod_eb==1 & (gestion=="1")
replace docentes_eb_publica=0 if docentes_eb_publica==.
	
	*b.1. Urbana
	gen docentes_eb_urbana_publica=docentes_eb if (gestion=="1") & (dareacenso=="Urbana" | dareacenso=="Urbano") & docentes_eb==1
	replace docentes_eb_urbana_publica=0 if docentes_eb_urbana_publica==.

	*b.1. Rural
	gen docentes_eb_rural_publica=docentes_eb if (gestion=="1") & (dareacenso=="Rural") & mod_eb==1
	replace docentes_eb_rural_publica=0 if docentes_eb_rural_publica==.

collapse (sum) serv_eb serv_eb_publica serv_eb_urbana_publica serv_eb_rural_publica matri_eb matri_eb_publica matri_eb_urbana_publica matri_eb_rural_publica docentes_eb docentes_eb_publica docentes_eb_urbana_publica docentes_eb_rural_publica, by(codooii)

destring *, replace

merge 1:1 codooii using "$ruta/input/padron_ugel", gen(m)
drop m

replace serv_eb=0 if serv_eb==.
replace serv_eb_publica=0 if serv_eb_publica==.
replace serv_eb_urbana_publica=0 if serv_eb_urbana_publica==.
replace serv_eb_rural_publica=0 if serv_eb_rural_publica==.

replace matri_eb=0 if matri_eb==.
replace matri_eb_publica=0 if matri_eb_publica==.
replace matri_eb_urbana_publica=0 if matri_eb_urbana_publica==.  
replace matri_eb_rural_publica=0 if matri_eb_rural_publica==. 

replace docentes_eb=0 if docentes_eb==.
replace docentes_eb_publica=0 if docentes_eb_publica==.
replace docentes_eb_urbana_publica=0 if docentes_eb_urbana_publica==.
replace docentes_eb_rural_publica=0 if docentes_eb_rural_publica==.

sort serv_eb_publica
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged

collapse (sum) serv_eb serv_eb_publica serv_eb_urbana_publica serv_eb_rural_publica matri_eb matri_eb_publica matri_eb_urbana_publica matri_eb_rural_publica docentes_eb docentes_eb_publica docentes_eb_urbana_publica docentes_eb_rural_publica, by(UnidadEjecutoradeEducación)

gen pmatri_eb_rural_pub=matri_eb_rural_publica/(matri_eb_rural_publica+matri_eb_urbana_publica)
gen estudiantes_eb_servicio_publica=matri_eb_publica/serv_eb_publica

merge 1:m UnidadEjecutoradeEducación using "$ruta/input/padron_ugel", gen(m)
sort Región
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged
drop if tipodeiged=="UGEL OPERATIVA"
keep if serv_eb_publica!=0
drop m

save "$output/matricula", replace

*2. Tiempo 
**********
/*Comentario: Se consideran los siguientes niveles correspondientes a la Educación Básica pues son los que reciben materiales educativos
A1	Inicial - Cuna
A2	Inicial - Jard�n
A3	Inicial - Cuna-jard�n
B0	Primaria
D0	B�sica Alternativa
D1	B�sica Alternativa-Inicial e Intermedio
D2	B�sica Alternativa-Avanzado
E0	B�sica Especial
E1	B�sica Especial-Inicial
E2	B�sica Especial-Primaria
F0	Secundaria
*/

clear all
import excel using "$input/PADRON_20220212_Accesibilidad_Sedes_DRE_UGEL1.xlsx", sheet("PADRON_20220212_Tiempo_SedeUGEL") firstrow

rename *, low
rename codigodreugel codooii
destring codooii, replace
merge m:1 codooii using "$input/padron_ugel", gen(m1)

rename codigomodular cod_mod 

/*merge m:1 cod_mod using "$input/codigos_materiales2022.dta"

drop if _merge!=3

drop m1 _merge*/

rename tiempoalasedeugel tiempo_jurisd_ugel
sort tiempo_jurisd_ugel
drop if tiempo_jurisd_ugel==.
drop if anexo!="0"

sort tiempo_jurisd_ugel
duplicates tag codigolocal, gen(a)

sort cod_mod

gen horas_dist= tiempo_jurisd_ugel/60

gen iie_menos2=1 if horas_dist<=2
replace iie_menos=0 if iie_menos2==.
ta iie_menos2
gen iiee=1
collapse (mean) horas_dist (sum) iie_menos2 iiee, by(UnidadEjecutoradeEducación)

gen poriieemenos2=iie_menos2/iiee

merge 1:m UnidadEjecutoradeEducación using "$ruta/input/padron_ugel", gen(m1)
sort Región
drop if tipodeiged=="UGEL OPERATIVA"

destring codooii, replace
keep codooii horas_dist iie_menos2 iiee poriieemenos2

merge 1:1 codooii using "$ruta/input/padron_ugel", gen(m1)
drop if m1==2
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged
drop m1
save "$output/tiempoiged", replace


*3. Presupuesto
*********************
*a. Presupuesto total
*********************
/*clear all
import excel using "$input\20221115_GOBIERNOREGIONAL.xlsx", firstrow
rename *, low
save "$input\20221115_GOBIERNOREGIONAL.dta", replace

clear all
import excel using "$input\20221115_SECTOR10.xlsx", firstrow
rename *, low
save "$input\20221115_SECTOR10.dta", replace

append using "$input\20221115_GOBIERNOREGIONAL.dta"

save "$input\20221115_PRESUPUESTO.dta", replace*/

clear all
use "$input\20221115_PRESUPUESTO.dta"

gen basica=1 if funcion_descripcion=="EDUCACION" & division_funcional_descripcion=="EDUCACION BASICA"
keep if ano_eje=="2022" & basica==1

gen devengado=mto_devengado_01 + mto_devengado_02 + mto_devengado_03 + mto_devengado_04 + mto_devengado_05 + mto_devengado_06 + mto_devengado_07 + mto_devengado_08 + mto_devengado_09 + mto_devengado_10 + mto_devengado_11 + mto_devengado_12 

collapse (sum) mto_pia mto_pim devengado, by(sec_ejec pliego pliego_nombre ejecutora ejecutora_nombre)

format mto_pia mto_pim devengado %14.0fc

destring sec_ejec, replace
destring pliego ejecutora, replace
egen id=concat(pliego ejecutora)
destring id, replace

merge 1:m id using "$input\padron_ue_ugel_upp", gen(m1) keepusing(NombredeUnidadEjecutoradeEducaci nombrededregreougel CódigodeDREGREoUGEL Región) /*ver los que no cruzan y aproximar a las DRE*/

sort m1
sort CódigodeDREGREoUGEL
drop if nombrededregreougel==""
duplicates drop id, force

rename CódigodeDREGREoUGEL codooii

br if Región=="SAN MARTIN" /*Ajuste en San Martin*/
replace codooii=220009 if codooii==220005
replace codooii=220006 if codooii==220003

merge 1:1 codooii using "$input/padron_ugel", gen(m)

order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged

sort Región
drop if m!=3

keep codooii mto_pia mto_pim devengado
format mto_pia mto_pim devengado %14.0fc
sort codooii

merge 1:1 codooii using "$input/padron_ugel", gen(m)

drop if m!=3

table Región, c(sum mto_pia sum mto_pim sum devengado) format (%14.0fc) row
save "$output/presupuesto22ue", replace

*b. Presupuesto de materiales
*****************************
clear all
*use "$input/20221102_PRESUPUESTO.dta"
use "$input\20221115_PRESUPUESTO.dta"

gen especifica_gasto=generica+"."+subgenerica+"."+subgenerica_det+"."+especifica+"."+especifica_det

keep if ano_eje=="2022" & (programa_ppto=="0090" | programa_ppto=="0106" | programa_ppto=="9002") & funcion=="22" & (act_proy=="3000387" | act_proy=="3000789" |  act_proy=="3999999") & (generica=="3") & especifica_gasto=="3.2.7.11.2"

gen pim22_transmat=mto_pim if ano_eje=="2022"
gen dev22_transmat=mto_pagado_01 + mto_pagado_02 + mto_pagado_03 + mto_pagado_04 + mto_pagado_05 + mto_pagado_06 + mto_pagado_07 + mto_pagado_08 + mto_pagado_09 + mto_pagado_10 + mto_pagado_11 + mto_pagado_12 + mto_pagado_13 if ano_eje=="2022"

*
collapse (rawsum) pim22_transmat dev22_transmat, by(pliego pliego_nombre ejecutora sec_ejec ejecutora_nombre)
destring ejecutora, replace
destring pliego ejecutora, replace
egen id=concat(pliego ejecutora)
destring id, replace

merge m:m id using "$input\padron_ue_ugel_upp", gen(m1) keepusing(NombredeUnidadEjecutoradeEducaci nombrededregreougel CódigodeDREGREoUGEL Región) /*ver los que no cruzan y aproximar a las DRE*/

sort CódigodeDREGREoUGEL
drop if nombrededregreougel==""
duplicates drop id, force
rename CódigodeDREGREoUGEL codooii

br if Región=="SAN MARTIN" /*Ajuste en San Martin*/
replace codooii=220009 if codooii==220005
replace codooii=220006 if codooii==220003
merge 1:1 codooii using "$input/padron_ugel", gen(m)
drop if m!=3
drop if m1==2
drop m1 m

order id Región NombredeUnidadEjecutoradeEducaci codooii nombrededregreougel UnidadEjecutoradeEducación nombredeiged tipodeiged
gen ejecucion_materiales22=dev22_transmat/pim22_transmat
sort ejecucion_materiales22

format ejecucion_materiales22 dev22_transmat pim22_transmat %12.2fc
duplicates report ejecutora_nombre
keeporder codooii nombrededregreougel UnidadEjecutoradeEducación nombredeiged tipodeiged ejecucion_materiales22 pim22_transmat dev22_transmat
sort tipodeiged

sort ejecucion_materiales22
save "$output/20221115_PRESUPUESTOMATERIALES.dta", replace

*4. Servicios en la IGED //Porcentaje de sedes tienen los servicios 
************************

/*Servicios:
-M03_P340: Energia Electrica (¿El local de la sede administrativa principal de la DRE/UGEL cuenta con energía eléctrica todos los días de la semana?)
-M03_P349: Agua Potable (¿El local de la sede administrativa principal de la DRE/UGEL tieneagua potable todos los días de la semana?)
-M03_P351: Desague (El/los baño(s) que tiene este predio está(n) conectado(s) a: 1.vRed pública de desagüe dentro del predio)
-M05_P519: Internet (¿La DRE/GRE/UGEL tiene conexión al servicio de internet)
*/

clear all
import excel "$input\BD_MOD03.xlsx", sheet("BD_MOD03") firstrow
keep cod_id M03_P340 M03_P349 M03_P351
rename (cod_id M03_P340 M03_P349 M03_P351) (codooii luz agua desague)
destring codooii, replace
codebook luz agua
replace luz=0 if luz==2 | luz==.
replace agua=0 if agua==2 | agua==.

gen serv_agua_luz=luz+agua
keep codooii serv_agua_luz luz agua

merge 1:1 codooii using "$input/padron_ugel", gen(m)
sort Región UnidadEjecutoradeEducación
save "$input\luz_agua", replace

clear all
import excel "$input\BD_MOD05.xlsx", sheet("BD_MOD05") firstrow
keep cod_id M05_P519
rename cod_id codooii
codebook M05_P519
rename M05_P519 serv_internet
destring codooii serv_internet, replace
replace serv_internet=0 if serv_internet==2

merge 1:1 codooii using "$input/padron_ugel", gen(m)
save "$input\internet", replace
merge 1:1 codooii using "$input\luz_agua", gen(m1)

gen servicios_iged=serv_agua_luz+serv_internet
replace servicios_iged=0 if servicios_iged==.

ta servicios_iged, m
keep codooii serv_internet luz agua serv_agua_luz servicios_iged

replace serv_internet=0 if serv_internet==.
replace luz=0 if luz==.
replace agua=0 if agua==.
replace serv_agua_luz=0 if serv_agua_luz==.
merge 1:1 codooii using "$input/padron_ugel", gen(m)

order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged
drop m
save "$output\servicios_iged", replace

*5. Capacidad de personal 
*************************
clear all
import excel "$input\MATRIZ_P422.xlsx", sheet("MATRIZ_P422") firstrow
rename *, low
rename cod_id codooii
destring codooii, replace
merge m:m codooii using "$ruta/input/padron_ugel"
drop nombre_dre_ugel

gen persona4=m04_p424 if m04_p422==4
gen persona6=m04_p424 if m04_p422==6
gen persona8=m04_p424 if m04_p422==8
gen personat=m04_p424 if m04_p422==13

gen persona_proceso=persona4 + persona6 + persona8
destring *, replace

collapse (sum) persona*, by(codooii nombredeiged)
codebook persona_proceso
count
ge ratiopersona_proce=persona_proceso/personat
replace ratiopersona_proce=0 if ratiopersona_proce==.
kdensity ratiopersona_proce
sort ratiopersona_proce

*merge 1:m codooii using "$ruta/input/padron_ugel"

collapse (sum) persona4 persona6 persona8 personat persona_proceso, by(codooii)
merge 1:1 codooii using "$ruta/input/padron_ugel"
collapse (sum) persona4 persona6 persona8 personat persona_proceso, by(UnidadEjecutoradeEducación)

merge 1:m UnidadEjecutoradeEducación using "$ruta/input/padron_ugel"
drop if tipodeiged=="UGEL OPERATIVA"
drop _merge
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged
sort codooii Región
ge ratiopersona_proce=persona_proceso/personat

save "$output\capacidad_personal", replace

*6. Almacenes
*************
*6.1. Capacidad de almacen
**************************
/*Comentario: Se revisó la información del modulo de almacen del CENSO DRE/UGEL y existen datos faltantes en el año 2021, por lo que se revisó la información en los años 2019 y 2020 para tomar esos datos y reemplazarlos.*/

*Año 2019
*********
clear all
import spss using "$input\06_Modulo VI_2019\06_Modulo VI\BD_MÓDULO_VI.sav"
keep cod_id M06_P612 
gen codooii=cod_id
destring codooii, replace
rename M06_P612 nalmacen2019
merge m:1 codooii using "$input/padron_ugel"
collapse (sum) nalmacen2019, by(UnidadEjecutoradeEducación)
save "$output\nalmacenes2019", replace

clear all
import spss using "$input\06_Modulo VI_2019\06_Modulo VI\MATRIZ_P614.sav"
tostring M06_N_Almacén, replace
egen id=concat(cod_id M06_N_Almacén)
sort id
drop if M03_P614_2==.
drop if M03_P614_2==.
gen codooii=cod_id
destring codooii, replace
merge m:1 codooii using "$input/padron_ugel"
collapse (sum) M03_P614_2 M03_P614_3, by(UnidadEjecutoradeEducación)
rename (M03_P614_2 M03_P614_3) (m2total2019 m3total2019)
save "$output\capalmacen2019", replace

merge 1:1 UnidadEjecutoradeEducación using "$output\nalmacenes2019"
sort m2total m3total
drop _merge
save "$output\almacenes2019", replace

*Año 2020
*********
clear all
import excel "$input\06_Modulo VI_2020\06 Modulo VI\BD_MOD06.xlsx", firstrow
keep cod_id M06_P617
*drop if M06_P617==.

gen codooii=cod_id
destring codooii, replace
rename M06_P617 nalmacen2020
merge m:1 codooii using "$input/padron_ugel"
collapse (sum) nalmacen2020, by(UnidadEjecutoradeEducación)
save "$output\nalmacenes2020", replace

clear all
import excel "$input\06_Modulo VI_2020\06 Modulo VI\MATRIZ_P619.xlsx", firstrow
egen id=concat(cod_id N_ALMACÉN)
sort id
drop if M06_P6191==.
gen codooii=cod_id
destring codooii, replace
merge m:1 codooii using "$input/padron_ugel"
collapse (sum) M06_P6191 M06_P6193, by(UnidadEjecutoradeEducación)
rename (M06_P6191 M06_P6193) (m2total2020 m3total2020)
save "$output\capalmacen2020", replace
merge 1:1 UnidadEjecutoradeEducación using "$output\nalmacenes2020"

sort m2total m3total
drop _merge
save "$output\almacenes2020", replace

*Año 2021
*********
clear all
import excel "$input\06_Modulo_VI_2021\BD_MOD06.xlsx", firstrow
keep cod_id M06_P619
gen codooii=cod_id
destring codooii, replace
rename M06_P619 nalmacen2021
merge m:1 codooii using "$input/padron_ugel"
collapse (sum) nalmacen2021, by(UnidadEjecutoradeEducación)
save "$output\nalmacenes2021", replace

clear all
import excel "$input\06_Modulo_VI_2021\MATRIZ_P621.xlsx", firstrow
egen id=concat(cod_id N_ALMACÉN)
sort id
drop if M06_P6212==.
gen codooii=cod_id
destring codooii, replace
merge m:1 codooii using "$input/padron_ugel"
collapse (sum) M06_P6212 M06_P6214, by(UnidadEjecutoradeEducación)
rename (M06_P6212 M06_P6214) (m2total2021 m3total2021)
save "$output\capalmacen2021", replace

merge 1:1 UnidadEjecutoradeEducación using "$output\nalmacenes2021"
sort m2total m3total
drop _merge
save "$output\almacenes2021", replace

*Junta de bases de datos
************************
clear all
use "$output\almacenes2021"
sort m2total2021 m3total2021
merge 1:1 UnidadEjecutoradeEducación using "$output\almacenes2020", keepusing (m2total2020 m3total2020 nalmacen2020) gen(m1) 
merge 1:1 UnidadEjecutoradeEducación using "$output\almacenes2019", keepusing (m2total2019 m3total2019 nalmacen2019) gen(m2) 
drop if m1==2

*Generamos diferencias
**********************
drop m1 m2
gen m2total=m2total2021

egen m2maxtotal=rowmax(m2total2020 m2total2021 m2total2019)
egen m2mintotal=rowmin(m2total2020 m2total2021 m2total2019)

gen m2totalfinal=m2maxtotal 

sort m2totalfinal

*Tratando outliers
******************
replace m2totalfinal=m3total2021 if UnidadEjecutoradeEducación=="313-1478: GOB.REG. DE ANCASH- EDUCACION BOLOGNESI"
replace m2totalfinal=m3total2021 if UnidadEjecutoradeEducación=="301-1012: REGION ICA-EDUCACION CHINCHA"
replace m2totalfinal=100.00 if UnidadEjecutoradeEducación=="306-1248: REGION LORETO - EDUCACION DATEM DEL MARAÑON"
replace m2totalfinal=m2mintotal if UnidadEjecutoradeEducación=="308-1540: GOB. REG. HUANUCO - EDUCAC ION UGEL AMBO"

sort m2totalfinal
keep UnidadEjecutoradeEducación m2totalfinal

merge 1:m UnidadEjecutoradeEducación using "$input/padron_ugel"
drop if tipodeiged=="UGEL OPERATIVA"
order Región codooii UnidadEjecutoradeEducación nombredeiged tipodeiged m2totalfinal 
drop _merge

merge 1:1 codooii using "$output/matricula"
drop if _merge==1
drop _merge
gen matricula_eb_publica=matri_eb_urbana_publica + matri_eb_rural_publica
gen ratioalmacenestudiantesebpublica=m2totalfinal/matricula_eb_publica

hist ratioalmacenestudiantes
drop serv_eb_publica

save "$output\almacenesfinal", replace

*7.Tiempo laborando como directivo
**********************************
clear all
import excel using "$input/MATRIZ_P132.xlsx", sheet("MATRIZ_P132") firstrow
keep if M01_P132==2
destring M01_P132_AÑOS M01_P132_MESES, replace
merge m:1 codooii using "$input/padron_ugel"
gen meses=M01_P132_AÑOS*12
gen mesdi=meses+M01_P132_MESES
replace mesdi=0 if mesdi==.

collapse (mean) mesdi, by(UnidadEjecutoradeEducación)
merge 1:m UnidadEjecutoradeEducación using "$input/padron_ugel"
sort Región UnidadEjecutoradeEducación
drop if tipodeiged=="UGEL OPERATIVA"

gen tpromdirectivo=mes/12

sort tpromdirectivo
hist tpromdirectivo
drop _merge
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged
save "$output/tiempodirectivo", replace

*8. Cantidad de materiales
**************************
clear all
use "$input/materrialesentregados"
merge 1:1 codooii using "$input/padron_ugel"
format matentriiee %12.2fc
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged
drop _merge

collapse (sum) matentriiee, by(UnidadEjecutoradeEducación)
merge 1:m UnidadEjecutoradeEducación using "$input/padron_ugel"
sort Región UnidadEjecutoradeEducación

drop if tipodeiged=="UGEL OPERATIVA"

order codooii UnidadEjecutoradeEducación Región nombredeiged tipodeiged
drop _merge
replace matentriiee=0.1 if matentriiee==0.0
save "$temp/matedue", replace

*Juntando la información
clear all
use "$output/matricula"
destring codooii, replace
merge 1:1 codooii using "$input/padron_ugel", gen(mdd)
merge 1:1 codooii using "$output/tiempoiged", gen(m2)
merge 1:1 codooii using "$output/presupuesto22ue", gen(m5)
*merge 1:1 codooii using "$output/presupuestomateriales22ue", gen(m6)
merge 1:1 codooii using "$output\servicios_iged", gen(mmm2)
merge 1:1 codooii using "$output\capacidad_personal", gen(ps)
merge 1:1 codooii using "$output/almacenesfinal", gen(ds)
merge 1:1 codooii using "$temp/matedue", gen(dss)
merge 1:1 codooii using "$output/tiempodirectivo", gen(df)
merge 1:1 codooii using "$output/20221115_PRESUPUESTOMATERIALES.dta", gen(cs)

drop if df!=3
keep if serv_eb_publica!=.

ta tipodeiged, m
drop m mdd m2 m5 mmm2 ps ds dss df cs
codebook
order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged

gen pim_per_estudianteeb=mto_pim/(matri_eb_publica)
gen dev_per_estudianteeb=devengado/(matri_eb_publica)
gen ejecucion=devengado/mto_pim


gen mat_pim_per_estudianteeb=pim22_transmat/(matri_eb_publica)
gen mat_dev_per_estudianteeb=dev22_transmat/(matri_eb_publica)

gen estudiantes_ebsp_docente=matri_eb_publica/docentes_eb_publica

order codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged

keeporder codooii Región UnidadEjecutoradeEducación nombredeiged tipodeiged matri_eb_publica matri_eb_urbana_publica matri_eb_rural_publica pmatri_eb_rural_pub horas_dist iie_menos2 poriieemenos2 mto_pia mto_pim devengado ejecucion pim_per_estudianteeb dev_per_estudianteeb serv_eb_publica serv_internet serv_agua_luz servicios_iged serv_eb_publica m2totalfinal ratioalmacenestudiantes mesdi tpromdirectivo persona_proceso ratiopersona_proce matentriiee estudiantes_eb_servicio_publica pim_per_estudianteeb mat_pim_per_estudianteeb mat_dev_per_estudianteeb ejecucion_materiales22 pim22_transmat dev22_transmat estudiantes_ebsp_docente 

format mto_pia mto_pim devengado ejecucion pim_per_estudianteeb dev_per_estudianteeb mat_pim_per_estudianteeb mat_dev_per_estudianteeb ejecucion_materiales22 pim22_transmat dev22_transmat estudiantes_ebsp_docente %12.0fc

format ejecucion %15.10fc

save "$output/variables", replace