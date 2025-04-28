/**********************************************************
 *                LISTA DE VARIABLES DE USUARIO           *
 **********************************************************/

/************** SUELDO PROMEDIO **************/

/*
   Conceptos que se consideran para la suma o resta 
   en el cálculo del salario promedio. 
   Estos se almacenan en la siguiente variable:
*/

SELECT * FROM RH_VAR_USUARIO   WHERE CLA_VAR = '$prdGSPTU'
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$prdGSPTU'


/*
   Rango de fechas considerado para el cálculo del sueldo promedio

   - Año/mes de inicio (formato aaaamm)
*/

SELECT * FROM RH_VAR_USUARIO WHERE CLA_VAR = '$in_GS_PTU'  
/*
   - Año/mes de fin (formato aaaamm)
*/
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$fi_GS_PTU'


/************** DÍAS CONSIDERADOS PARA GRATIFICACIÓN PTU **************/

/*
   Se considerará una variable de usuario para determinar el número de días
   - Actualmente se consideran 153 días
*/

SELECT * FROM RH_VAR_USUARIO WHERE CLA_VAR = '$diasG_PTU'
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$diasG_PTU'


/************** GRATIFICACIÓN **************/

/*
   Se considerará una variable de usuario para determinar el número de días
   - Actualmente se consideran 130 días
   - No se descuenta ningún tipo de ausentismo
   - No se considera la fecha de ingreso
*/

SELECT * FROM RH_VAR_USUARIO WHERE CLA_VAR = '$diaGraesp'
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$diaGraesp'

/*NUEVO TIPO DE NÓMINA PARA GRATIFICACIÓN DE PTU*/

SELECT * FROM RH_TIPO_NOMINA
WHERE NOM_TIPO_NOMINA ='GRATIFICACION ESPECIAL'
