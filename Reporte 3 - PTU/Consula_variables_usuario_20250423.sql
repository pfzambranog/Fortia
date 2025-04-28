/**********************************************************
 *                LISTA DE VARIABLES DE USUARIO           *
 **********************************************************/

/************** SUELDO PROMEDIO **************/

/*
   Conceptos que se consideran para la suma o resta 
   en el c�lculo del salario promedio. 
   Estos se almacenan en la siguiente variable:
*/

SELECT * FROM RH_VAR_USUARIO   WHERE CLA_VAR = '$prdGSPTU'
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$prdGSPTU'


/*
   Rango de fechas considerado para el c�lculo del sueldo promedio

   - A�o/mes de inicio (formato aaaamm)
*/

SELECT * FROM RH_VAR_USUARIO WHERE CLA_VAR = '$in_GS_PTU'  
/*
   - A�o/mes de fin (formato aaaamm)
*/
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$fi_GS_PTU'


/************** D�AS CONSIDERADOS PARA GRATIFICACI�N PTU **************/

/*
   Se considerar� una variable de usuario para determinar el n�mero de d�as
   - Actualmente se consideran 153 d�as
*/

SELECT * FROM RH_VAR_USUARIO WHERE CLA_VAR = '$diasG_PTU'
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$diasG_PTU'


/************** GRATIFICACI�N **************/

/*
   Se considerar� una variable de usuario para determinar el n�mero de d�as
   - Actualmente se consideran 130 d�as
   - No se descuenta ning�n tipo de ausentismo
   - No se considera la fecha de ingreso
*/

SELECT * FROM RH_VAR_USUARIO WHERE CLA_VAR = '$diaGraesp'
SELECT * FROM [RHCFG_VARIABLE] WHERE CLA_VAR = '$diaGraesp'

/*NUEVO TIPO DE N�MINA PARA GRATIFICACI�N DE PTU*/

SELECT * FROM RH_TIPO_NOMINA
WHERE NOM_TIPO_NOMINA ='GRATIFICACION ESPECIAL'
