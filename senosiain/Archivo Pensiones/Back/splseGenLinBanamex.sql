Alter Procedure splseGenLinBanamexPensiones2024
 ( @chCompania       Char  (4), --LS
  @chClaNomina       Char  (2),  --M2
  @chTipNomina       Char  (2),  --02
  @iAnio             Integer,  --2006
  @iPeriodo          Integer,  --05
  @dFechaDeposito    Char  (11),
  @chDescripcion     Char  (30),
  @iOrdenamiento     Tinyint, -- 1 Alfabético, 2 Numérico
  @iSitTrabajador    Tinyint)
As

---------------------------------------------------------------------------------------------
---- Modificado por: Francisco Rodríguez
---- Última Modificación: 2012-08-13
---- Motivo: Genera la información incorrecta cuando un empleado cuenta con más de un
---- Beneficiario de pensión alimenticia

---- Modificado por: Pedro Zambrano
---- Última Modificación: 2025-08-06
---- Motivo: Ajuste al layout de Banamex.

---- Modificado por: Pedro Zambrano
---- Última Modificación: 2025-08-07
---- Motivo: Se convierte el Script la codificación de Utf-8 a Ascii.

---- Modificado por: Pedro Zambrano
---- Última Modificación: 2025-08-14
---- Motivo: Se Actualiza la clave del banco cuando es interbancario.

---------------------------------------------------------------------------------------------

Declare
   @iSitPeriodo         Tinyint,
   @iSitActivos         Tinyint,
   @iSitBajas           Tinyint,
   @iSitTodos           Tinyint,
   @iSitTraActivo       Tinyint,
   @iSitTraBaja         Tinyint,
   @iSitPerCerrado      Tinyint,
   @iOrdAlfabetico      Tinyint,
--
   @iIdCalendario       Integer,
   @iNumCliente         Integer,
   @iNatArchivo         Integer,
   @iParTipCuenta       Integer,
   @iDeVolumen          Integer,
   @iCarArchivo         Integer,
   @iNumEntero          Integer,
   @iCuentaTrab         Integer,
--
   @chVarLayout         Varchar (250),
   @chAlfanumerico      Varchar (250),
   @chTrabSuc           Varchar ( 40),
   @chBenSucursal       Varchar ( 40),
   @chBenCta            Varchar ( 40),
   @chPenTipo           Varchar ( 40),
   @chBenDep            Varchar ( 40),
   @chAgrDepto          Varchar ( 40),
   @chConsecutivo       Varchar (  4),
   @chParSucFondeo      Varchar ( 30),
   @chParCtaFondeo      Varchar ( 30),
   @chParNomEmpresa     Varchar ( 30),
   @chNomEmpresa        Varchar (100),
   @chCueDeposito       Varchar ( 20),
   @chOrdenamiento      Varchar ( 40),
   @chImporte18         Varchar ( 18),
   @chSucursal          Varchar ( 40),
   @chCuentaDeposito    Varchar ( 40),
   @chCuentaTrab        Varchar (  6),
   @chCuenta20          Varchar ( 20),
   @chCadena            Varchar (500),
   @chNumCliente        Varchar ( 12),
   @chNombre            Varchar (120),
   @chApePaterno        Varchar (120),
   @chApeMaterno        Varchar (120),
   @chNombres           Varchar (120),
   @chNumeroAbonos6     Varchar (  6),
   @chSucFondeo         Varchar ( 10),
   @chCtaFondeo         Varchar ( 10),
   @chMesDeposito       Varchar ( 20),
--
   @sQuery              Varchar (2000),
   @chSelect            Varchar (5000),
   @chFroWhePrincipal   Varchar (5000),
   @chInsert            Varchar (5000),
--
   @chCveAgrDepto       Char ( 30),
   @chParNumCliente     Char ( 30),
   @chParNatArchivo     Char ( 30),
   @chParVarLayout      Char ( 30),
   @chParDeVolumen      Char ( 30),
   @chParCarArchivo     Char ( 30),
   @chParTipcuenta      Char ( 30),
   @chParTipOperaciones Char ( 30),
   @chParTipClaveMoneda Char ( 30),
   @chParCueDeposito    Char ( 30),
   @chFechaDeposito     Char (  6),
   @iParTipOperaciones  Char ( 30),
   @iParClaveMoneda     Char ( 30),
   @chParTrabSuc        Char ( 30),
   @chParBenSucursal    Char ( 30),
   @chParBenCta         Char ( 30),
   @chParPenTipo        Char ( 30),
   @chParBenDep         Char ( 30),
   @chFinCursor         Char (  2),
   @w_referencia        Char ( 16),
--
   @cNumDecimal         Decimal(19, 6),
   @cImporte            Decimal(12, 2),
   @dImporte            Decimal(12, 2),
   @iConsecutivo        Numeric(5,  0),
   @iPosInicial         Numeric (3, 0),
   @iPosDiagonal        Numeric (3, 0),
   @iLonNombre          Numeric (3, 0),
--
   @dFecHora            Datetime,
   @chNomTabla          Sysname;

Begin

 --  Declaración de contantes
 --

 Set @iSitActivos = 1
 Set @iSitBajas = 2
 Set @iSitTodos = 0
 Set @iSitTraActivo = 1
 Set @iSitTraBaja = 2

 Set @iSitPerCerrado = 2
 Set @iOrdAlfabetico = 1

 Set @chParNumCliente =  'PAR_NUM_CLIENTE'
 Set @chParNatArchivo =  'PAR_NAT_ARCHIVO'
 Set @chParVarLayout =  'PAR_VER_LAYOUT'
 Set @chParDeVolumen =  'PAR_DE_VOLUMEN'
 Set @chParCarArchivo =  'PAR_CAR_ARCHIVO'
 Set @chParTipcuenta =  'PAR_TIP_CUENTA'
 Set @chParTipOperaciones =  'PAR_TIP_OPERACION'
 Set @chParTipClaveMoneda =  'PAR_CLAVE_MONEDA'

Set @chParSucFondeo = 'SUC_CITI_CLASE_'
Set @chParCtaFondeo = 'CTA_CITI_CLASE_'

 Set @chCveAgrDepto =  'PAR_AGR_DEPARTAMENTO'

 Set  @chParTrabSuc =  'PAR_TRABAJADOR_SUCURSAL'
 Set  @chParBenSucursal = 'PAR_BENEFICIARIO_SUCURSAL'

 Set  @chParBenCta =   'PAR_BENEFICIARIO_CUENTA'
 Set  @chParPenTipo =   'PAR_PENSION_TIPO'
 Set  @chParBenDep =   'PAR_PAGO_BENEF_DEPOSITO'

 Set @chParNomEmpresa = 'NOMBRE_EMPRESA_SPOOL'

 Set     @chParCueDeposito = 'PAR_CUE_' + @chClaNomina


 -- Obtiene los valores de los parámetros
 --
 --  Número de Cliente Banamex

 Execute  splseLeeParametro @chCompania,
                            @chParNumCliente,
                            @iNumCliente    out,
                            @cNumDecimal    out,
                            @chAlfanumerico out,
                            @dFecHora       out;

Set @iNumCliente = Isnull (@iNumCliente, 0)

 --  Número de Nat Archivo
 Execute  splseLeeParametro @chCompania, @chParNatArchivo,
     @iNatArchivo out,
     @cNumDecimal out,
     @chAlfanumerico out,
     @dFecHora out
Set @iNatArchivo = Isnull (@iNatArchivo, 0)

 --  Número de Var Laoyout
 Execute  splseLeeParametro @chCompania, @chParVarLayout,
     @iNumEntero out,
     @cNumDecimal out,
     @chVarLayout out,
     @dFecHora out
Set @chVarLayout = Isnull (@chVarLayout, '')

 --  Número de De Volumen
 Execute  splseLeeParametro @chCompania, @chParDeVolumen,
     @iDeVolumen out,
     @cNumDecimal out,
     @chAlfanumerico out,
     @dFecHora out
Set @iDeVolumen = Isnull (@iDeVolumen, 0)

 --  Número de Car Archivo
 Execute  splseLeeParametro @chCompania, @chParCarArchivo,
     @iCarArchivo out,
     @cNumDecimal out,
     @chAlfanumerico out,
     @dFecHora out
Set @iCarArchivo = Isnull (@iCarArchivo, 0)

 --  Cuenta Senosiain
 Execute  splseLeeParametro @chCompania, @chParCueDeposito,
     @iNumEntero     out,
     @cNumDecimal out,
     @chCueDeposito out,
     @dFecHora out


 Execute  splseLeeParametro @chCompania, @chParTipcuenta,
     @iParTipCuenta out,
     @cNumDecimal out,
     @chAlfanumerico out,
     @dFecHora out
Set @iParTipCuenta = Isnull (@iParTipCuenta, 0)


 Execute  splseLeeParametro @chCompania, @chParTipOperaciones,
     @iParTipOperaciones out,
     @cNumDecimal out,
     @chAlfanumerico out,
     @dFecHora out
Set @iParTipOperaciones = Isnull (@iParTipOperaciones, 0)

 Execute  splseLeeParametro @chCompania, @chParTipClaveMoneda,
     @iParClaveMoneda out,
     @cNumDecimal out,
     @chAlfanumerico out,
     @dFecHora out
Set @iParClaveMoneda = Isnull (@iParClaveMoneda, 0)

 Execute  splseLeeParametro @chCompania, @chParTrabSuc,
     @iNumEntero  out,
     @cNumDecimal out,
     @chTrabSuc out,
     @dFecHora out

 Execute  splseLeeParametro @chCompania, @chParBenSucursal,
     @iNumEntero  out,
     @cNumDecimal out,
     @chBenSucursal out,
     @dFecHora out

 Execute  splseLeeParametro @chCompania, @chParBenCta,
     @iNumEntero  out,
     @cNumDecimal out,
     @chBenCta out,
     @dFecHora out

 Execute  splseLeeParametro @chCompania, @chParPenTipo,
     @iNumEntero  out,
     @cNumDecimal out,
     @chPenTipo out,
     @dFecHora out

 Execute  splseLeeParametro @chCompania, @chParBenDep,
     @iNumEntero  out,
     @cNumDecimal out,
     @chBenDep out,
     @dFecHora out

 -- Obtiene la clave de la agrupación de "departamento"
 --
 Execute  splseLeeParametro @chCompania, @chCveAgrDepto,
     @iNumEntero out,
     @cNumDecimal out,
     @chAgrDepto out,
     @dFecHora out

--
--  Nombre de la empresa
--
 Execute  splseLeeParametro @chCompania, @chParNomEmpresa,
     @iNumEntero out,
     @cNumDecimal out,
     @chNomEmpresa out,
     @dFecHora out

--
--  Sucursal de fondeo
--
    Set @chParSucFondeo = @chParSucFondeo + @chClaNomina
 Execute  splseLeeParametro @chCompania, @chParSucFondeo,
     @iNumEntero out,
     @cNumDecimal out,
     @chSucFondeo out,
     @dFecHora out

--
--  Cuenta de fondeo
--
    Set @chParCtaFondeo = @chParCtaFondeo + @chClaNomina
 Execute  splseLeeParametro @chCompania, @chParCtaFondeo,
     @iNumEntero out,
     @cNumDecimal out,
     @chCtaFondeo out,
     @dFecHora out


 -- Verifica la situación del período solicitado
 --
 Set @iSitPeriodo = NULL
 Set @iIdCalendario = NULL

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
 Set @chNomTabla = 'transacciones_ns'
 IF @iSitPeriodo = @iSitPerCerrado
  Set @chNomTabla = 'trans_' + RTRIM (LTRIM (@chCompania)) + '_' +
                    RTRIM (LTRIM (Convert (Varchar (15), @iIdCalendario)))


 -- Arma el from y where principal
 --

 Set @chFroWhePrincipal =
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

 Set @chFroWhePrincipal = @chFroWhePrincipal +
    ' WHERE ' +
     ' TRN.COMPANIA = ''' + @chCompania + '''   AND' +
     ' TRN.CLASE_NOMINA = ''' + @chClaNomina + '''  AND' +
     ' TRN.ID_CALENDARIO = ' +
       Convert (Char (15), @iIdCalendario) + '  AND' +
     ' TRN.SIT_TRANSACCION = 2      AND' +
--
     ' INF.TRABAJADOR = TRN.TRABAJADOR     AND' +
     ' INF.INDICE_INF_SOC = ''' + @chBenSucursal + '''  AND' +
     ' INF.DATO_11 = TRN.CONCEPTO      AND' +
--
     ' T.TRABAJADOR = TRN.TRABAJADOR     AND'
--
 Set @chFroWhePrincipal = @chFroWhePrincipal +
     ' TG.COMPANIA = TRN.COMPANIA      AND' +
     ' TG.TRABAJADOR = TRN.TRABAJADOR     AND' +
     ' ( ( TG.SIT_TRABAJADOR = ' +
        Convert (Char (1), @iSitTraActivo) + ' AND ' +
        Convert (Char (1), @iSitTrabajador) + ' = ' +
        Convert (Char (1), @iSitActivos) +
      ' ) OR' +
      ' ( TG.SIT_TRABAJADOR = ' +
        Convert (Char (1), @iSitTraBaja) + ' AND ' +
        Convert (Char (1), @iSitTrabajador) + ' = ' +
        Convert (Char (1), @iSitBajas) +
      ' ) OR ' +
       Convert (Char (1), @iSitTrabajador) + ' = ' +
       Convert (Char (1), @iSitTodos) +
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

--
--  Creando la tabla temporal que contiene la información de los recibos a generar
--

    CREATE TABLE #TablaDepositos
    (   NumCliente              Varchar     (5),
        variable_per_09         Decimal     (15, 6),
        nombre_cia              Varchar     (100),
        NatArchivo              Varchar     (10),
        VarLayout               Varchar     (10),
        DeVolumen               Varchar     (10),
        CarArchivo              Varchar     (10),
        ParTipCuenta            Varchar     (10),
        variable_per_08         Decimal     (15, 6),
        variable_per_07         Decimal     (15, 6),
        ParTipOperaciones       Varchar     (10),
        ParClaveMoneda          Varchar     (10),
        importe                 Decimal     (13, 2),
        TipoCta                 Varchar     (10),
        trabajadores            Varchar     (20),
        nombre                  Varchar     (120),
        cuenta_deposito         Varchar     (40),
        sucursal                Varchar     (20),
        FechaDeposito           Varchar     (20),
        Descripcion             Varchar     (100),
        Concepto                Varchar     (40),
        FechaInicio             Varchar     (20),
        FechaTermino            Varchar     (20),
        ClaveNomina             Varchar     (20),
        Periodo                 Varchar     ( 2))
 --  Arma el query principal
 --
 Set @chSelect =
 ' Insert into #TablaDepositos Select ' +
  '''' + Convert (Varchar (15), @iNumCliente) + ''' NumCliente, ' +
  'Isnull (CAL.VARIABLE_PER_08, 0) variable_per_09, ' +
  'RTRIM (CIA.NOMBRE_CIA) nombre_cia, ' +
  '''' + Convert (Varchar (15), @iNatArchivo) + ''' NatArchivo, ' +
  '''' + Convert (Varchar (15), @chVarLayout) + ''' VarLayout, ' +
  '''' + Convert (Varchar (15), @iDeVolumen) + ''' DeVolumen, ' +
  '''' + Convert (Varchar (15), @iCarArchivo) + ''' CarArchivo, ' +
  '''' + Convert (Varchar (15), @iParTipCuenta) + ''' ParTipCuenta, ' +
  'Isnull (CAL.VARIABLE_PER_07, 0) VARIABLE_PER_08, ' +
  'Isnull (CAL.VARIABLE_PER_06, 0) VARIABLE_PER_07, ' +
  '''' + RTRIM (Convert (Varchar (3), @iParTipOperaciones)) + ''' ParTipOperaciones, ' +
  '''' + RTRIM (Convert (Varchar (3), @iParClaveMoneda)) + ''' ParClaveMoneda, ' +
  'TRN.IMPORTE, ' +
       '''' + 'TipoCta' + ''' ' + ' = CASE ' +
        ' WHEN Len (RTRIM (LTRIM (INF.DATO_04))) > 0 ' +
           ' THEN ''01''  ' +
           ' ELSE ''03''  ' +
       ' END, ' +
  'T.TRABAJADOR, ' +
  'Isnull (INF.DATO_09, '''') Beneficiario, '  +
  'Isnull (INF.DATO_05, '''') NoCuenta, ' +
  'Isnull (INF.DATO_04,''0000'') Sucursal, '

 --  Ponemos las columnas fijas de parámetro
--
 Set @chSelect = @chSelect +
  '''' + Convert (Varchar (15), Isnull (@dFechaDeposito,'')) + ''' FechaDeposito, ' +
  '''' + Convert (Varchar (15), Isnull (@chDescripcion,'')) + ''' Descripcion, ' +
  'C.DESCRIPCION Concepto, ' +
  '''' + Convert (Varchar (15), Isnull (@dFInicio,''), 103) + ''' FechaInicio, ' +
  '''' + Convert (Varchar (15), Isnull (@dFFin, ''), 103) + ''' FechaTermino, ' +
  '''' + Convert (Varchar (15), @chTipNomina) + '-' + Convert (Varchar (15), @iAnio) +
   '-' + Convert (Varchar (15), @iPeriodo) + ''' ClaveNomina, '  +
  '''' + Convert (Varchar (15), Isnull (@iPeriodo, '')) + ''' Periodo '

 -- Armamos el Join
 --
 Set @chSelect = @chSelect +
    @chFroWhePrincipal +
    ' AND INF.' + @chPenTipo + ' = ''' + @chBenDep + '''' +
    ' ORDER BY '

 --
 -- Asignamos el orden correcto a los resultados
 --
 
 if @iOrdenamiento = 1
 begin
  Set @chSelect = @chSelect + ' TRN.TRABAJADOR'
 end
 else
 begin
  Set @chSelect = @chSelect + ' T.NOMBRE'
 end

 Execute  (@chSelect)

--
--  Contando el número de movimientos
--
    Set @iCuentaTrab = 0

    SELECT  @iCuentaTrab = COUNT (1)
    from    #TablaDepositos

    Set @iCuentaTrab = Isnull (@iCuentaTrab, 0)

--
--  Contabilizando el total de Importes
--
    Set @dImporte = 0
    SELECT  @dImporte = Sum(Isnull (importe, 0))
    from    #TablaDepositos;
    
    Set @dImporte = Isnull (@dImporte, 0)

--
--  TABLA QUE CONTIENE LA INTERFAZ DE DEPÓSITOS CITI
--

    CREATE TABLE #INTERFACE_CITI
        (   secuencia_registro              Numeric (10)    NOT NULL Identity,
            cadena_interface                Varchar (500)
        )
--
--  CURSOR DE BENEFICIARIOS
--

DECLARE
    CR_CUR_BENEFICIARIOS CURSOR FOR
    SELECT      nombre,
                importe,
                sucursal,
                cuenta_deposito

        FROM    #TablaDepositos
--
--  CREANDO LAS SECCIONES DE LA INTERFACE
--

--
--  01 Registro de Control - Importación
--
    Set @chCadena = ''

    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '1', 1)                     -- Registro de Control

    Set @chNumCliente = Convert (Varchar (12), @iNumCliente)                    -- Número de cliente
    Set @chNumCliente = Replicate ('0', 12 - Len (@chNumCliente)) + @chNumCliente
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chNumCliente, 2)

    Set @chMesDeposito = Substring (@dFechaDeposito, 1, 3)                      -- Fecha de pago

    IF  @chMesDeposito In ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
    BEGIN
        Set @chMesDeposito = Case WHEN    @chMesDeposito = 'Jan' THEN '01'
                                  WHEN    @chMesDeposito = 'Feb' THEN '02'
                                  WHEN    @chMesDeposito = 'Mar' THEN '03'
                                  WHEN    @chMesDeposito = 'Apr' THEN '04'
                                  WHEN    @chMesDeposito = 'May' THEN '05'
                                  WHEN    @chMesDeposito = 'Jun' THEN '06'
                                  WHEN    @chMesDeposito = 'Jul' THEN '07'
                                  WHEN    @chMesDeposito = 'Aug' THEN '08'
                                  WHEN    @chMesDeposito = 'Sep' THEN '09'
                                  WHEN    @chMesDeposito = 'Oct' THEN '10'
                                  WHEN    @chMesDeposito = 'Nov' THEN '11'
                                  WHEN    @chMesDeposito = 'Dec' THEN '12'
                             End

        Set @chFechaDeposito = Substring (@dFechaDeposito, 10, 2) +
            Substring (@chMesDeposito, 1, 2) +
            Substring (@dFechaDeposito, 5, 2)
    END
    ELSE
       Begin
          Set @chFechaDeposito =  Substring (@dFechaDeposito, 3, 2) +
                                  Substring (@dFechaDeposito, 6, 2) +
                                  Substring (@dFechaDeposito, 9, 2)
       End
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chFechaDeposito, 14)

    IF EXISTS           -- Consecutivo del archivo
    (   SELECT  1
            FROM    lseNumArchivoCiti
            WHERE   fecha_generacion = @chFechaDeposito
    )
    BEGIN
        SELECT  @iConsecutivo = consecutivo
            FROM    lseNumArchivoCiti
            WHERE   fecha_generacion = @chFechaDeposito

        Set @iConsecutivo = @iConsecutivo + 1

        UPDATE  lseNumArchivoCiti
            Set consecutivo = @iConsecutivo
            WHERE   fecha_generacion = @chFechaDeposito
    END

    ELSE
    BEGIN
        INSERT INTO lseNumArchivoCiti
            VALUES (@chFechaDeposito, 1)

        Set @iConsecutivo = 1
    END

    Set @chConsecutivo = Convert (Varchar (4), @iConsecutivo)
    Set @chConsecutivo = replicate ('0', 4 - Len (@chConsecutivo)) + RTRIM (LTRIM (@chConsecutivo))
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chConsecutivo, 20)

    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chNomEmpresa, 24)                          -- Nombre de la empresa
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chDescripcion, 60)                         -- Descripción
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '15', 80)                  -- Naturaleza del archivo
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, 'D', 82)                                    -- Versión del layout
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '01', 83)                                   -- Cargo Global

    INSERT INTO #INTERFACE_CITI
        (cadena_interface)
        values
        (@chCadena)

--
--  02 Registro Global de Importación
--
    Set @chCadena = ''

    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '2', 1)                                     -- Tipo de Registro 'Global'
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '1', 2)                                     -- Tipo de Operación 'Abono'
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '001', 3)                                   -- Clave de la Moneda

    Set @chImporte18 = Convert (Varchar (18), @dImporte)                                         -- Importe a cargar
    Set @chImporte18 = Replace (@chImporte18, '.', '')
    Set @chImporte18 = RTRIM (LTRIM(@chImporte18))
    Set @chImporte18 = REPLICATE ('0', 18 - Len (@chImporte18)) + @chImporte18
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chImporte18, 6)

    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '01', 24)                                   -- Tipo de cuenta

    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '000000000', 26)                            -- Número de Cuenta - Ceros a la izquierda
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chSucFondeo, 35)                           -- Número de Cuenta - Número de Sucursal
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chCtaFondeo, 39)                           -- Número de Cuenta - Número de Cuenta

    Set @chCuentaTrab = Convert (Varchar (6), @iCuentaTrab)                                     -- Número de Abonos
    Set @chCuentaTrab = replicate ('0', 6 -Len (@chCuentaTrab)) + @chCuentaTrab
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chCuentaTrab, 46)

    INSERT INTO #INTERFACE_CITI
        (cadena_interface)
        values
        (@chCadena)

--
--  03 Registros de Detalle
--
    Set @chFinCursor = 'NO'

    OPEN   CR_CUR_BENEFICIARIOS
    FETCH  CR_CUR_BENEFICIARIOS
    INTO   @chNombre,
           @cImporte,
           @chSucursal,
           @chCuentaDeposito

    IF  @@FETCH_STATUS <> 0

        Set @chFinCursor = 'SI'

    WHILE   @chFinCursor = 'NO'
    BEGIN
        Set @chCadena = ''

        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '3', 1)                                     -- Tipo de Registro
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '0', 2)  -- Tipo de Operación

--
-- Actualización del 06/08/2025
--

--
-- Metodo de Pago.
--

        If Len (@chCuentaDeposito) = 18
           Begin
              Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '002', 3)
           End
        Else
           Begin
              Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '001', 3)                               -- Clave de la Moneda
           End


--
-- Tipo de Pago
--

    IF @chTipNomina in ('AQ', 'AS', 'A1', 'A2')
        Begin
           Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '51', 6)
        End
    Else
       Begin
          IF @chTipNomina = 'M2'         -- Pago Nómina General
             Begin
                Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '01', 6)
             End
          Else
             Begin
                -- Pago Pensiones.
                Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '54', 6)
             End
       End


--
-- tipo de Moneda
--

   Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '001', 8)

        Set @chImporte18 = RTRIM (LTRIM (Convert (Varchar (18), @cImporte)))                        -- Importe
        Set @chImporte18 = REPLACE (@chImporte18, '.', '')
        Set @chImporte18 = REPLICATE ('0', 18 - Len (@chImporte18)) + RTRIM (LTRIM (@chImporte18))
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chImporte18, 11)                           -- Importe

--
-- Tipo de cuenta de abono
--

        Set @chCuentaDeposito = RTRIM (LTRIM (@chCuentaDeposito))
        IF  Len (@chCuentaDeposito) = 16
            Begin
               Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '03', 29)
            End
        else
            Begin
               If Len (@chCuentaDeposito) = 18
                  Begin
                     Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '40', 29)
                  End
               ELSE
                  Begin
                     Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '01', 29)
                  End
            End

        -- Número de cuenta de abono
        
        Set @chSucursal       = RTRIM (LTRIM (@chSucursal)) 
        Set @chCuentaDeposito = RTRIM (LTRIM (@chCuentaDeposito))


        IF  Len (@chCuentaDeposito) < 16
            BEGIN
               Set @chCuenta20 = REPLICATE ('0', 9)
               Set @chCuenta20 = @chCuenta20 + REPLICATE ('0', 4 - Len (@chSucursal)) + @chSucursal        --      Sucursal
               Set @chCuenta20 = @chCuenta20 + REPLICATE ('0', 7 - Len (@chCuentaDeposito)) + @chCuentaDeposito    --  Cuenta
            END
        ELSE
           Begin
               If Len (@chCuentaDeposito) = 18
                  Begin
                     Set @chCuenta20 = '00' + @chCuentaDeposito
                  End
               Else
                  BEGIN
                      Set @chCuenta20 = '0000' + @chCuentaDeposito
                  END
          End

        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chCuenta20, 31)

--
-- Referencia del pago
--

        If Len (@chCuentaDeposito) = 18
           Begin
              Set @w_referencia = Cast(@iAnio As Char(4)) + '0' +
                                  Case When Len(@iPeriodo) < 2
                                       Then '0' + Cast(@iPeriodo As Char(1))
                                       Else Cast(@iPeriodo As Char(2))
                                  End;
           End

       Else
          Begin
             Set @w_referencia =  Substring (@chDescripcion, 1, 16);
          End

       Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @w_referencia, 51)

--
-- Fin Actualización del 06/08/2025
--

--
-- Beneficiario
--
        Set @chNombre = Upper(@chNombre);

        Set @chNombre = Ltrim(Rtrim(Replace(Replace (@chNombre, Char(241), 'N'),'Ñ', 'N')));

        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, Substring(@chNombre, 1, 55), 67)

--
-- Fin actualización Nombre
--

        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 122)                                   -- Referencia 1
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 157)                                   -- Referencia 2
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 192)                                   -- Referencia 3
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 227)                                  -- Referencia 4

--
-- Clave de banco
-- Ajuste del 14/08/2025
--
        If Len (@chCuentaDeposito) != 18
           Begin
              Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '0000', 262) 
           End
        Else
           Begin
              Set @chCadena = dbo.fnlseArmaCadena (@chCadena, 
                              '0' + Substring(@chCuentaDeposito, 1, 3), 262) 
           End
--
-- Fin de Ajuste del 14/08/2025
--

        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '00', 266)                                  -- Plazo
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 268)                                   -- RFC
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 282)                                   -- IVA
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 290)                                   -- Uso futuro 1
        Set @chCadena = dbo.fnlseArmaCadena (@chCadena, ' ', 420)                                   -- Uso futuro 2

        INSERT INTO #INTERFACE_CITI
            (cadena_interface)
         values
            (@chCadena)

        FETCH   CR_CUR_BENEFICIARIOS
        INTO    @chNombre,
                @cImporte,
                @chSucursal,
                @chCuentaDeposito

        IF  @@FETCH_STATUS <> 0

            Set @chFinCursor = 'SI'
    END

    CLOSE CR_CUR_BENEFICIARIOS
    DEALLOCATE CR_CUR_BENEFICIARIOS
--
--  04 Registro de Control.
--
    Set @chCadena = ''

    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '4', 1)                                         -- Tipo de registro
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '001', 2)                                       -- Clave de la moneda

    Set @chNumeroAbonos6 = Convert (Varchar (6), @iCuentaTrab)                                      -- Número de abonos
    Set @chNumeroAbonos6 = REPLICATE ('0', 6 - Len (@chNumeroAbonos6)) + @chNumeroAbonos6
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chNumeroAbonos6, 5)

    Set @chImporte18 = Convert (Varchar (18), @dImporte)                                            -- Importe total de abonos
    Set @chImporte18 = REPLACE (@chImporte18, '.', '')
    Set @chImporte18 = RTRIM (LTRIM(@chImporte18))
    Set @chImporte18 = REPLICATE ('0', 18 - Len (@chImporte18)) + @chImporte18

    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chImporte18, 11)                               -- Importe total de abonos
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, '000001', 29)                                   -- Número de abonos
    Set @chCadena = dbo.fnlseArmaCadena (@chCadena, @chImporte18, 35)                               -- Importe total de cargos

    Insert INTO #INTERFACE_CITI
    (cadena_interface)
    values (@chCadena)

    SELECT  cadena_interface
    FROM    #INTERFACE_CITI
    ORDER   BY secuencia_registro

    Return

End
Go
