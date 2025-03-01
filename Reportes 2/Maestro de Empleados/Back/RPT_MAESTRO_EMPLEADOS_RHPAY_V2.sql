 --Declare
 --  @Empresa            Integer = Null,
 --  @RAZON_SOCIAL       Integer = Null,
 --  @UBICACION          Integer = Null,
 --  @Periodo            Integer = Null,
 --  @Status             Char(1) = Null,
 --  @PnIdDepartamento   Integer = Null,
 --  @idtrabajador       Integer = Null,
 --  @nUsuario           Integer = 1;

 -- Execute dbo.RPT_MAESTRO_EMPLEADOS_RHPAY_V2 @Empresa          = @Empresa,
 --                                            @RAZON_SOCIAL     = @RAZON_SOCIAL,
    --                                         @UBICACION        = @UBicacion,
    --                                         @Periodo          = @Periodo,
    --                                         @STATUS           = @Status,
    --                                         @PnIdDepartamento = @PnIdDepartamento,
    --                                         @idtrabajador     = @idtrabajador,
    --                                         @nUsuario         = @nUsuario;

/********************************************************************************************
    JM
 SP: RPT_MAESTRO_EMPLEADOS_RHPAY
    Descripción  : Genera el reporte maestro de empleados, considerando filtros como empresa,
                      razón social, ubicación, periodo, estado, y usuario.
    Última Modificación:26/02/2025
    Version: 2
    Progrador: Pedro Zambrano.
    Motivo Act: Minuta Arriva - Minuta de cambio - Maestro Empleados

********************************************************************************************/
Create Or Alter Procedure RPT_MAESTRO_EMPLEADOS_RHPAY_V2
 (@Empresa            Integer = Null,
  @RAZON_SOCIAL       Integer = Null,
  @UBICACION          Integer = Null,
  @Periodo            Integer = Null,
  @STATUS             Char(1) = Null,
  @PnIdDepartamento   Integer = Null,
  @idtrabajador       Integer = Null,
  @nUsuario           Integer)
As

Declare
  @FIN_ANIO_ANTERIOR  Date,
  @FIN_ANIO_ACTUAL    Date,
  @INI_ANIO_ACTUAL    Date,
  @INI_ANIO_ANTERIOR  Date,
--
  @w_anioMesIni       Char(4),
  @w_anioMesFin       Char(4),
  @w_fecha            Date,
  @w_fechaProc        Datetime;

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off

   Select @w_fechaProc       = Getdate(),
          @w_fecha           = @w_fechaProc,
          @w_anioMesIni      = '0101',
          @w_anioMesFin      = '1231',
          @INI_ANIO_ANTERIOR = Convert(Date, Str(Year(DATEADD(YY, -1, @w_fecha ))) + @w_anioMesIni),
          @FIN_ANIO_ANTERIOR = Convert(DATE, Str(Year(DATEADD(YY, -1, @w_fecha)))  + @w_anioMesFin),
          @INI_ANIO_ACTUAL   = Convert(Date, Str(Year(@w_fecha)) + @w_anioMesIni),
          @FIN_ANIO_ACTUAL   = Convert(Date, Str(Year(@w_fecha)) + @w_anioMesFin);

--
-- Inicio de Consulta.
--

   Select T1.CLA_TRAB, dbo.fnNombreCompletoTrab(T1.CLA_EMPRESA, T1.CLA_TRAB) NOMBRE,
          T1.CURP, T1.RFC, T1.NUM_IMSS,
          Trim(T2.NOM_PUESTO)            NOM_PUESTO,
          T4.CLA_CENTRO_COSTO            CLA_CENTRO_COSTO,
          Trim(T4.NOM_CENTRO_COSTO)      NOM_CENTRO_COSTO,
          T1.CLA_UBICACION_BASE          CLA_UBICACION,
          Trim(T13.NOM_UBICACION)        NOM_UBICACION,
          T1.CLA_DEPTO                   CLA_DEPTO,
          Trim(T11.NOM_DEPTO)            NOM_DEPTO,
          Trim(T12.NOM_PERIODO)          NOM_PERIODO,
          T1.SUELDO_INT,                 T1.SUELDO_DIA,
          T1.SUELDO_MENSUAL,             T1.CLA_RAZON_SOCIAL,
          T14.NOM_RAZON_SOCIAL,          t1.CLA_REG_IMSS,
          t15.NOM_REG_IMSS               NOM_REG_IMSS,
          Trim(T5.NOM_CLASIFICACION)     NOM_CLASIFICACION,
          dbo.fnObtieneRoll(t1.CLA_TRAB, t1.CLA_EMPRESA, @w_fecha) ROLL,
          Trim(T6.NOM_BANCO)             NOM_BANCO,
          t1.CTA_BANCO                   CUENTA,
          Trim(T3.NOM_FORMA_PAGO)        NOM_FORMA_PAGO,
          t1.CLABE_INTERBANCARIA,        Convert(Varchar, T1.FECHA_ING, 103) FECHA_ING,
          Convert(Varchar, T1.fecha_ing_grupo,103) FECHA_ING_GRUPO,
          T1.CTA_CORREO , T1.NUM_CTA_DESPENSA,
          dbo.fnCalcAntig(T1.ANTIG_BASE,
          Isnull(T1.FECHA_ING_GRUPO, t1.FECHA_ING), @w_fechaProc) ANTIG,
          Case t1.sind When 1
                       Then 'SINDICALIZADO'
                       Else 'NO SINDICALIZADO'
          End SIND,
          T1.CRED_INF,
          Case When T1.VALOR_CREDITO_INFO IN (1, 2, 3)
               Then '%'
               When T1.VALOR_CREDITO_INFO = 4
               Then 'Cuota Monetaria'
               When t1.valor_credito_info =  5
               Then  'Factor de descuento'
               When t1.valor_credito_info =  6
               Then  'Tasa INFONAVIT'
               Else ''
          End  TIPOINFO,
          T1.VALOR_TASA_INFO  TASAINFO,
         (Select Top 1 NOM_CONTRATO
          From   dbo.RH_TIPO_CONTRATO
          Where  CLA_CONTRATO = T1.TIPO_CONTRATO ) EVENTUAL_PLANTA,
          T1.AP_PATERNO                 PATERNO,
          T1.AP_MATERNO                 MATERNO,
          T1.NOM_TRAB                   NOM_TRAB,
          t1.CALLE                      CALLE,
          t1.NUM_EXT                    NUMERO_EXTERIOR,
          t1.NUM_INT                    NUMERO_INTERIOR,
          T1.COLONIA                    COLONIA,
          T1.DOMICILIO_FISCAL_RECEPTOR  CP_FISCAL,
          T1.CP_STR                     CODIGO_POSTAL,
          T1.CIUDAD                     CIUDAD,
          T1.DELEGACION                 MUNICIPIO,
          T1.NACIONALIDAD               NACIONALIDAD,
          Case When Upper(T1.NACIONALIDAD) LIKE 'MEXICAN%'
               Then 'MEXICO'
               Else 'OTRO'
          End                           PAIS,
          T1.TELEFONO                   TELEFONO,
          T1.FECHA_NAC                  FECHA_NACIMIENTO,
          T1.SEXO                       GENERO,
          dbo.fnNumLetra(T1.SUELDO_MENSUAL,1) SUELDO_LETRA,
          T7.CLA_TAB_PRE,
          T7.NOM_TAB_PRE, x.DIAS_VAC VACACIONES, x.PRIMA_VAC PRIMA_VAC,
          x.DIAS_AGUI AGUINALDO,
          dbo.Fn_FDOCJA_AHORRO(T1.CLA_EMPRESA, T1.CLA_TRAB, 2)   FDO_AHORRO,
          dbo.Fn_FDOCJA_AHORRO(T1.CLA_EMPRESA, T1.CLA_TRAB, 3)   CAJA_AHORRO,
          Convert(Varchar,T1.FECHA_BAJA ,103)   FECHA_BAJA,
          Case T1.STATUS_TRAB  When 'A'
                               Then 'ACTIVO'
                               Else 'BAJA'
          End  ESTATUS_TRAB,
          Isnull((Select NOM_TIPO_MOV
                  From   dbo.RH_TIPO_MOV
                  Where  CLA_EMPRESA  = T1.CLA_EMPRESA
                  And    CLA_TIPO_MOV = Isnull((Select MAX(CLA_TIPO_MOV)
                                                From   dbo.RH_HIST_LABORAL
                                                Where  CLA_TRAB  = T1.CLA_TRAB
                                                And    FECHA_MOV = T1.Fecha_Baja) ,
                                               (Select MAX(CLA_TIPO_MOV)
                                                From   dbo.RH_NEGOCIA_FINIQUITO
                                                Where  CLA_TRAB   = T1.CLA_TRAB
                                                And    FECHA_BAJA = T1.Fecha_Baja))
                 ), '') CAUSA_BAJA,
          T1.CUADRO_NETO,
          Case When T1.CALC_NOMINA = 1
               Then 'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_NOMINA,
          Case When T1.APLICA_PTU = 1
               Then 'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_PTU,
          Case When T1.APLICA_FA = 1
               Then  'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_FA,
          Case When T1.APLICA_IMSS = 1
               Then  'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_IMSS,
          Case When T1.APLICA_DEC = 1
               Then 'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_DECARACION,
          Case When T1.APLICA_DEC_SUELDOS = 1
               Then 'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_DECARACION_SUE,
 --
          T1.fotografia FOTOGRAFIA, t1.FACTOR_INT FACTOR_INTEGRACION,
          dbo.Fn_buscaDatoComplementario(t1.CLA_EMPRESA, t1.CLA_TRAB, 'Vales de despensa') VALESDESPENSA,
          dbo.Fn_buscaDatoComplementario(t1.CLA_EMPRESA, t1.CLA_TRAB, 'ESCOLARIDAD')       ESCOLARIDAD
   From  dbo.RH_TRAB   T1
   Join  dbo.RH_PUESTO T2
   On    T1.CLA_EMPRESA        = T2.CLA_EMPRESA
   And   T1.CLA_PUESTO         = T2.CLA_PUESTO
   Join  dbo.RH_FORMA_PAGO T3
   On    T1.CLA_EMPRESA        = T3.CLA_EMPRESA
   And   T1.CLA_FORMA_PAGO     = T3.CLA_FORMA_PAGO
   Join  dbo.RH_CENTRO_COSTO T4
   On    T1.CLA_EMPRESA        = T4.CLA_EMPRESA
   And   T1.CLA_CENTRO_COSTO   = T4.CLA_CENTRO_COSTO
   Join  dbo.RH_CLASIFICACION T5
   On    T1.CLA_EMPRESA        = T5.CLA_EMPRESA
   And   T1.CLA_CLASIFICACION  = T5.CLA_CLASIFICACION
   LEFT  Join dbo.RH_BANCO T6
   On    T1.CLA_BANCO          = T6.CLA_BANCO
   Join  dbo.RH_UBICACION T8
   On    T1.CLA_EMPRESA        = T8.CLA_EMPRESA
   And   T1.CLA_UBICACION_BASE = T8.CLA_UBICACION
   Join  dbo.RH_DEPTO  T11
   On    T1.CLA_EMPRESA = T11.CLA_EMPRESA
   And   T1.CLA_DEPTO   = T11.CLA_DEPTO
   Join  RH_PERIODO T12
   On    T1.CLA_PERIODO = T12.CLA_PERIODO
   And   T1.CLA_EMPRESA = T12.CLA_EMPRESA
   Join  RH_UBICACION T13
   On    T1.CLA_UBICACION_BASE  = t13.CLA_UBICACION
   And   T1.CLA_EMPRESA         = T13.CLA_EMPRESA
   Join  dbo.RH_RAZON_SOCIAL T14
   On    t1.CLA_RAZON_SOCIAL = T14.CLA_RAZON_SOCIAL
   And   T1.CLA_EMPRESA      = T14.CLA_EMPRESA
   Join  dbo.RH_REG_IMSS T15
   On    t1.CLA_REG_IMSS = T15.CLA_REG_IMSS
   And   T1.CLA_EMPRESA  = T15.CLA_EMPRESA
   Join  dbo.RH_ENC_TAB_PRESTAC T7
   On    T1.CLA_TAB_PRE  = T7.CLA_TAB_PRE
   And   T1.CLA_EMPRESA  =T7.CLA_EMPRESA
   Join  (Select a.CLA_EMPRESA, a.CLA_TRAB, DIAS_VAC, PRIMA_VAC, DIAS_AGUI 
          From   RH_TRAB a
          Join   RH_ENC_TAB_PRESTAC b
          On     b.CLA_TAB_PRE = a.CLA_TAB_PRE
          And    b.CLA_EMPRESA = a.CLA_EMPRESA
          Join   RH_DET_TAB_PRESTAC c
          On     c.CLA_TAB_PRE = b.CLA_TAB_PRE
          And    c.CLA_EMPRESA = b.CLA_EMPRESA
          And    c.ANTIG       = dbo.fnStd_CalcAntig(0, FECHA_ING, @w_fecha, a.CLA_TRAB, a.CLA_EMPRESA, 3)) x
   On    x.CLA_EMPRESA         = T1.CLA_EMPRESA
   And   x.CLA_TRAB            = T1.CLA_TRAB
   Where T1.CLA_EMPRESA        = iif(@Empresa          Is Null, T1.CLA_EMPRESA,        @Empresa)
   And   T1.CLA_RAZON_SOCIAL   = iif(@RAZON_SOCIAL     Is Null, T1.CLA_RAZON_SOCIAL,   @RAZON_SOCIAL)
   And   T1.CLA_UBICACION_BASE = iif(@UBICACION        Is Null, T1.CLA_UBICACION_BASE, @UBICACION)
   And   T1.CLA_PERIODO        = iif(@Periodo          Is Null, T1.CLA_PERIODO,        @Periodo)
   And   T1.STATUS_TRAB        = iif(@STATUS           Is Null, T1.STATUS_TRAB,        @STATUS)
   And   T1.cla_trab           = iif(@idtrabajador     Is null, T1.cla_trab,           @idtrabajador)
   And   T1.cla_depto          = Iif(@PnIdDepartamento Is null, T1.cla_depto,          @PnIdDepartamento)
   And   DBO.fnc_ValidaSeguridadStd(T1.CLA_EMPRESA, @nUsuario,T1.CLA_UBICACION_BASE,T1.CLA_dEPTO,T1.CLA_PERIODO) > 0
   Order By T1.CLA_TRAB
                   
   Return
    
End
Go
