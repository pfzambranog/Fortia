 CREATE PROCEDURE splseGenLinBanamexPensiones    
 ( @chCompania  char  (4), --LS    
  @chClaNomina  char  (2),  --M2    
  @chTipNomina  char  (2),  --02    
  @iAnio   integer,  --2006    
  @iPeriodo  integer,  --05    
  @dFechaDeposito char  (10),    
  @chDescripcion char  (30),    
  @iOrdenamiento tinyint, -- 1 Alfabético, 2 Numérico    
  @iSitTrabajador TINYINT    
 )    
  
---------------------------------------------------------------------------------------------  
---- Modificado por: Francisco Rodríguez  
---- Última Modificación: 2012-08-13  
---- Motivo: Genera la información incorrecta cuando un empleado cuenta con más de un  
----   beneficiario de pensión alimenticia  
---------------------------------------------------------------------------------------------    
as    
    
DECLARE @iSitPeriodo   TINYINT    
DECLARE @iIdCalendario  INTEGER    
DECLARE @iSitPerCerrado  TINYINT    
DECLARE @iOrdAlfabetico  TINYINT    
DECLARE @iNumCliente   INTEGER    
DECLARE @iNatArchivo   INTEGER    
DECLARE @iParTipCuenta  INTEGER    
DECLARE @chVarLayout   VARCHAR (250)    
DECLARE @iDeVolumen   INTEGER    
DECLARE @iCarArchivo   INTEGER    
    
DECLARE @iNumEntero   INTEGER    
DECLARE @cNumDecimal   DECIMAL (19, 6)    
DECLARE @chAlfanumerico  VARCHAR (250)    
DECLARE @dFecHora   DATETIME    
declare @chTrabSuc   VARCHAR (40)    
declare @chBenSucursal  VARCHAR (40)    
  
DECLARE @chAgrDepto   VARCHAR (40)  
DECLARE @chCveAgrDepto  CHAR (30)  
    
DECLARE @chBenCta   VARCHAR (40)    
DECLARE @chPenTipo   VARCHAR (40)    
DECLARE @chBenDep   VARCHAR (40)    
    
DECLARE @chParNumCliente  CHAR (30)    
DECLARE @chParNatArchivo  CHAR (30)    
DECLARE @chParVarLayout  CHAR (30)    
Declare @chParDeVolumen  CHAR (30)    
DECLARE @chParCarArchivo  CHAR (30)    
DECLARE @chParTipcuenta  CHAR (30)    
DECLARE @chParTipOperaciones CHAR (30)    
DECLARE @chParTipClaveMoneda CHAR (30)    
    
DECLARE @iParTipOperaciones CHAR (30)    
DECLARE @iParClaveMoneda  CHAR (30)    
declare @chParTrabSuc   CHAR (30)    
declare @chParBenSucursal  CHAR (30)    
    
DECLARE @chParBenCta   CHAR (30)    
DECLARE @chParPenTipo   CHAR (30)    
DECLARE @chParBenDep   CHAR (30)    
    
      
DECLARE @chNomTabla   VARCHAR (40)    
DECLARE @chSelect   VARCHAR (5000)  
DECLARE @chFroWhePrincipal  VARCHAR (5000)  
DECLARE @chInsert   VARCHAR (5000)    
DECLARE @chOrdenamiento  VARCHAR (40)    
    
declare @dImporte   decimal(12,2)    
declare @sQuery    varchar(2000)    
declare @iCuentaTrab   integer    
    
DECLARE @iSitActivos   TINYINT    
DECLARE @iSitBajas   TINYINT    
DECLARE @iSitTodos   TINYINT    
    
DECLARE @iSitTraActivo  TINYINT  
DECLARE @iSitTraBaja   TINYINT    
    
Begin    
    
 --  Declaración de contantes    
 --    
    
 SET @iSitActivos = 1    
 SET @iSitBajas = 2    
 SET @iSitTodos = 0    
    
 SET @iSitTraActivo = 1    
 SET @iSitTraBaja = 2    
    
 SET @iSitPerCerrado = 2    
 SET @iOrdAlfabetico = 1    
    
 SET @chParNumCliente =  'PAR_NUM_CLIENTE'    
 SET @chParNatArchivo =  'PAR_NAT_ARCHIVO'    
 SET @chParVarLayout =  'PAR_VER_LAYOUT'    
 SET @chParDeVolumen =  'PAR_DE_VOLUMEN'    
 SET @chParCarArchivo =  'PAR_CAR_ARCHIVO'    
 SET @chParTipcuenta =  'PAR_TIP_CUENTA'    
 SET @chParTipOperaciones =  'PAR_TIP_OPERACION'    
 SET @chParTipClaveMoneda =  'PAR_CLAVE_MONEDA'    
  
 SET @chCveAgrDepto =  'PAR_AGR_DEPARTAMENTO'  
  
 SET  @chParTrabSuc =  'PAR_TRABAJADOR_SUCURSAL'    
 SET  @chParBenSucursal = 'PAR_BENEFICIARIO_SUCURSAL'    
    
 SET  @chParBenCta =   'PAR_BENEFICIARIO_CUENTA'     
 SET  @chParPenTipo =   'PAR_PENSION_TIPO'    
 SET  @chParBenDep =   'PAR_PAGO_BENEF_DEPOSITO'    
    
  
 -- Obtiene los valores de los parámetros    
 --    
 --  Número de Cliente Banamex    
     
 EXEC splseLeeParametro @chCompania, @chParNumCliente,    
     @iNumCliente out,    
     @cNumDecimal out,    
     @chAlfanumerico out,    
     @dFecHora out    
SET @iNumCliente = ISNULL (@iNumCliente, 0)  
    
 --  Número de Nat Archivo    
 EXEC splseLeeParametro @chCompania, @chParNatArchivo,    
     @iNatArchivo out,   
     @cNumDecimal out,    
     @chAlfanumerico out,    
     @dFecHora out  
SET @iNatArchivo = ISNULL (@iNatArchivo, 0)  
    
 --  Número de Var Laoyout    
 EXEC splseLeeParametro @chCompania, @chParVarLayout,    
     @iNumEntero out,    
     @cNumDecimal out,    
     @chVarLayout out,    
     @dFecHora out  
SET @chVarLayout = ISNULL (@chVarLayout, '')  
    
 --  Número de De Volumen    
 EXEC splseLeeParametro @chCompania, @chParDeVolumen,    
     @iDeVolumen out,    
     @cNumDecimal out,    
     @chAlfanumerico out,    
     @dFecHora out  
SET @iDeVolumen = ISNULL (@iDeVolumen, 0)  
     
 --  Número de Car Archivo    
 EXEC splseLeeParametro @chCompania, @chParCarArchivo,    
     @iCarArchivo out,    
     @cNumDecimal out,    
     @chAlfanumerico out,    
     @dFecHora out  
SET @iCarArchivo = ISNULL (@iCarArchivo, 0)  
    
 EXEC splseLeeParametro @chCompania, @chParTipcuenta,    
     @iParTipCuenta out,    
     @cNumDecimal out,    
     @chAlfanumerico out,    
     @dFecHora out  
SET @iParTipCuenta = ISNULL (@iParTipCuenta, 0)  
    
 EXEC splseLeeParametro @chCompania, @chParTipOperaciones,    
     @iParTipOperaciones out,    
     @cNumDecimal out,    
     @chAlfanumerico out,    
     @dFecHora out  
SET @iParTipOperaciones = ISNULL (@iParTipOperaciones, 0)  
    
 EXEC splseLeeParametro @chCompania, @chParTipClaveMoneda,    
     @iParClaveMoneda out,    
     @cNumDecimal out,    
     @chAlfanumerico out,    
     @dFecHora out  
SET @iParClaveMoneda = ISNULL (@iParClaveMoneda, 0)  
    
 EXEC splseLeeParametro @chCompania, @chParTrabSuc,    
     @iNumEntero  out,    
     @cNumDecimal out,    
     @chTrabSuc out,    
     @dFecHora out    
    
    
 EXEC splseLeeParametro @chCompania, @chParBenSucursal,    
     @iNumEntero  out,    
     @cNumDecimal out,    
     @chBenSucursal out,    
     @dFecHora out    
    
 EXEC splseLeeParametro @chCompania, @chParBenCta,    
     @iNumEntero  out,    
     @cNumDecimal out,    
     @chBenCta out,    
     @dFecHora out    
    
    
 EXEC splseLeeParametro @chCompania, @chParPenTipo,    
     @iNumEntero  out,    
     @cNumDecimal out,    
     @chPenTipo out,    
     @dFecHora out    
    
    
 EXEC splseLeeParametro @chCompania, @chParBenDep,    
     @iNumEntero  out,    
     @cNumDecimal out,    
     @chBenDep out,    
     @dFecHora out    
    
 -- Obtiene la clave de la agrupación de "departamento"  
 --  
 EXEC splseLeeParametro @chCompania, @chCveAgrDepto,  
     @iNumEntero out,  
     @cNumDecimal out,  
     @chAgrDepto out,  
     @dFecHora out    
    
 -- Verifica la situación del período solicitado    
 --    
 SET @iSitPeriodo = NULL    
 SET @iIdCalendario = NULL    
 SELECT @iSitPeriodo = cpc.sit_periodo, @iIdCalendario = cpc.id_calendario    
  FROM cal_proc_cias cpc, calendario_procesos cp    
  WHERE cp.tipo_nomina = @chTipNomina  AND    
   cp.anio = @iAnio   AND    
   cp.periodo = @iPeriodo   AND    
   cpc.compania = @chCompania  AND    
   cpc.id_calendario = cp.id_calendario    
 declare @dFInicio datetime    
 declare @dFFin datetime    
 select @dFInicio = fecha_inicio, @dFFin = fecha_termino     
  from calendario_procesos     
  where id_calendario = @iIdCalendario    
  
  
 -- Arma el nombre de la tabla de donde se obtiene la información    
 --    
 SET @chNomTabla = 'transacciones_ns'    
 IF @iSitPeriodo = @iSitPerCerrado    
  SET @chNomTabla = 'trans_' + RTRIM (LTRIM (@chCompania)) + '_' + RTRIM (LTRIM (CONVERT (varCHAR (15), @iIdCalendario)))    
    
 -- Creamos unas tablas de paso para poner los valores globales    
 --    
    
 create table #trPaso1(dImporte decimal(12,2))    
 insert into #trPaso1 values(0)    
     
 create table #trPaso2(iCuentaTrab decimal(12,2))    
 insert into #trPaso2 values(0)    
  
  
 -- Arma el from y where principal  
 --  
 set @chFroWhePrincipal =  
    ' FROM ' +  
      @chNomTabla + '  TRN,' +  
     ' INF_SOC_TRABAJADOR INF,' +  
     ' TRABAJADORES  T,' +  
     ' TRABAJADORES_GRALES TG,' +  
     ' REL_TRAB_INS_DEP RELD,' +  
     ' CONCEPTOS   C,' +  
     ' REL_TRAB_AGR  RTA,' +  
     ' DATOS_AGR_TRAB  DAT,' +  
     ' CLASES_NOMINA  CN,' +  
     ' COMPANIAS   CIA,' +  
     ' CAL_PROC_CIAS  CAL'  
  
 set @chFroWhePrincipal = @chFroWhePrincipal +  
    ' WHERE ' +  
     ' TRN.COMPANIA = ''' + @chCompania + '''   AND' +  
     ' TRN.CLASE_NOMINA = ''' + @chClaNomina + '''  AND' +  
     ' TRN.ID_CALENDARIO = ' +  
       CONVERT (CHAR (15), @iIdCalendario) + '  AND' +  
     ' TRN.SIT_TRANSACCION = 2      AND' +  
--  
     ' INF.TRABAJADOR = TRN.TRABAJADOR     AND' +  
     ' INF.INDICE_INF_SOC = ''' + @chBenSucursal + '''  AND' +  
     ' INF.DATO_11 = TRN.CONCEPTO      AND' +  
--  
     ' T.TRABAJADOR = TRN.TRABAJADOR     AND'  
--  
 set @chFroWhePrincipal = @chFroWhePrincipal +  
     ' TG.COMPANIA = TRN.COMPANIA      AND' +  
     ' TG.TRABAJADOR = TRN.TRABAJADOR     AND' +  
     ' ( ( TG.SIT_TRABAJADOR = ' +  
        CONVERT (CHAR (1), @iSitTraActivo) + ' AND ' +  
        CONVERT (CHAR (1), @iSitTrabajador) + ' = ' +  
        CONVERT (CHAR (1), @iSitActivos) +  
      ' ) OR' +  
      ' ( TG.SIT_TRABAJADOR = ' +  
        CONVERT (CHAR (1), @iSitTraBaja) + ' AND ' +  
        CONVERT (CHAR (1), @iSitTrabajador) + ' = ' +  
        CONVERT (CHAR (1), @iSitBajas) +  
      ' ) OR ' +  
       CONVERT (CHAR (1), @iSitTrabajador) + ' = ' +  
       CONVERT (CHAR (1), @iSitTodos) +  
     ' ) AND' +  
--  
     ' RELD.COMPANIA = TRN.COMPANIA   AND' +  
     ' RELD.TRABAJADOR = TRN.TRABAJADOR  AND' +  
     ' RELD.INS_DEP_PRINCIPAL = 1    AND' +  
--  
     ' C.CONCEPTO = TRN.CONCEPTO    AND' +  
--  
     ' RTA.COMPANIA = TRN.COMPANIA   AND' +  
     ' RTA.AGRUPACION = ''' + @chAgrDepto + ''' AND' +  
     ' RTA.TRABAJADOR = TRN.TRABAJADOR   AND' +  
--  
     ' DAT.AGRUPACION = RTA.AGRUPACION   AND' +  
     ' DAT.DATO = RTA.DATO     AND' +  
--  
     ' CN.CLASE_NOMINA = TRN.CLASE_NOMINA  AND' +  
--  
     ' CIA.COMPANIA = TRN.COMPANIA   AND' +  
--  
     ' CAL.COMPANIA = TRN.COMPANIA   AND' +  
     ' CAL.ID_CALENDARIO = TRN.ID_CALENDARIO'  
  
  
 -- Calculamos la suma en importes de depósitos  
 --  
 set @sQuery =  
  'UPDATE #trPaso1' +  
  ' SET dImporte = ' +  
   ' ISNULL ( ( SELECT SUM (TRN.IMPORTE) ' +  
          @chFroWhePrincipal + '  AND' +  
         ' INF.' + @chPenTipo + ' = ' +  
          '''' + @chBenDep + '''' +  
      ' ), 0' +  
     ' )'  
  
 exec (@sQuery)  
 select @dImporte = max(dImporte) from #trPaso1  
 SET @dImporte = ISNULL (@dImporte, 0)  
  
 -- Se calcula el número de movimientos de depósitos  
 --  
 set  @sQuery =  +  
  'UPDATE #trPaso2' +  
  ' SET iCuentaTrab = ' +  
   ' ISNULL ( ( SELECT COUNT (TRN.IMPORTE) ' +  
          @chFroWhePrincipal + '  AND' +  
         ' INF.' + @chPenTipo + ' = ' +  
          '''' + @chBenDep + '''' +  
      ' ), 0' +  
     ' )'  
  
 exec(@sQuery)  
 select @iCuentaTrab = max(iCuentaTrab) from #trPaso2  
 SET @iCuentaTrab = ISNULL (@iCuentaTrab, 0)  
     
 --  Arma el query principal    
 --    
 SET @chSelect =  
 'SELECT ' +  
  '''' + CONVERT (VARCHAR (15), @iNumCliente) + ''' NumCliente, ' +  
  'ISNULL (CAL.VARIABLE_PER_08, 0) variable_per_09, ' +  
  'RTRIM (CIA.NOMBRE_CIA) nombre_cia, ' +  
  '''' + CONVERT (VARCHAR (15), @iNatArchivo) + ''' NatArchivo, ' +  
  '''' + CONVERT (VARCHAR (15), @chVarLayout) + ''' VarLayout, ' +  
  '''' + CONVERT (VARCHAR (15), @iDeVolumen) + ''' DeVolumen, ' +  
  '''' + CONVERT (VARCHAR (15), @iCarArchivo) + ''' CarArchivo, ' +  
  CONVERT (VARCHAR (15), @dImporte) + ' ImporteTot, ' +  
  '''' + CONVERT (VARCHAR (15), @iParTipCuenta) + ''' ParTipCuenta, ' +  
  'ISNULL (CAL.VARIABLE_PER_07, 0) VARIABLE_PER_08, ' +  
  'ISNULL (CAL.VARIABLE_PER_06, 0) VARIABLE_PER_07, ' +  
  '''' + RTRIM (CONVERT (VARCHAR (3), @iParTipOperaciones)) + ''' ParTipOperaciones, ' +  
  '''' + RTRIM (CONVERT (VARCHAR (3), @iParClaveMoneda)) + ''' ParClaveMoneda, ' +  
  'TRN.IMPORTE, ' +    
       '''' + 'TipoCta' + ''' ' + ' = CASE ' +  
        ' WHEN LEN (RTRIM (LTRIM (INF.DATO_04))) > 0 ' +  
           ' THEN ''01''  ' +  
           ' ELSE ''03''  ' +  
       ' END, ' +    
  'T.TRABAJADOR, ' +  
  'ISNULL (INF.DATO_09, '''') Beneficiario, '  +  
  '''' + CONVERT (VARCHAR (15), ISNULL (@iCuentaTrab, 0)) + ''' ' + ' CountTrab, ' +  
  'ISNULL (INF.DATO_05, '''') NoCuenta, ' +  
  'ISNULL (INF.DATO_04,'''') Sucursal, '    
      
 --  Ponemos las columnas fijas de parámetro   
--  
 SET @chSelect = @chSelect +  
  '''' + CONVERT (VARCHAR (15), ISNULL (@dFechaDeposito,'')) + ''' FechaDeposito, ' +  
  '''' + CONVERT (VARCHAR (15), ISNULL (@chDescripcion,'')) + ''' Descripcion, ' +  
  'C.DESCRIPCION Concepto, ' +  
  '''' + CONVERT (VARCHAR (15), ISNULL (@dFInicio,''), 103) + ''' FechaInicio, ' +  
  '''' + CONVERT (VARCHAR (15), ISNULL (@dFFin, ''), 103) + ''' FechaTermino, ' +  
  '''' + CONVERT (VARCHAR (15), @chTipNomina) + '-' + CONVERT (VARCHAR (15), @iAnio) +  
   '-' + CONVERT (VARCHAR (15), @iPeriodo) + ''' ClaveNomina, '  +  
  '''' + CONVERT (VARCHAR (15), ISNULL (@iPeriodo, '')) + ''' Periodo '    
    
 -- Armamos el Join    
 --       
 SET @chSelect = @chSelect +  
    @chFroWhePrincipal +  
    ' AND INF.' + @chPenTipo + ' = ''' + @chBenDep + '''' +  
    ' ORDER BY '  
  
 -- Asignamos el orden correcto a los resultados    
 --    
 if @iOrdenamiento = 1     
 begin    
  SET @chSelect = @chSelect + ' TRN.TRABAJADOR'    
 end       
 else    
 begin    
  SET @chSelect = @chSelect + ' T.NOMBRE'  
 end  
  
  
 EXEC (@chSelect)    
  
END  