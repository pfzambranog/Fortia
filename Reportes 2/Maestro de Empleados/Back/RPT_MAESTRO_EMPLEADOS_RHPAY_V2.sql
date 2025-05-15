 --Declare
 --  @PsRazon_Social           Varchar(Max) = '',
 --  @PsCla_Empresa            Varchar(Max) = '1',
 --  @PsCla_Ubicacion          Varchar(Max) = '3,1,21',
 --  @PsCla_CentroCosto        Varchar(Max) = '',
 --  @PsCla_Periodo            Varchar(Max) = '',
 --  @PsEstatus_Trab           Varchar(Max) = 'A',
 --  @PsCla_Depto              Varchar(Max) = '',
 --  @PsCla_RegImss            Varchar(Max) = '',
 --  @PsCla_Trab               Varchar(Max) = '',
 --  @PsCla_Puestos            Varchar(MAx) = '15, 1, 13',
 --  @nUsuario                 Integer      = 1;

 -- Execute dbo.RPT_MAESTRO_EMPLEADOS_RHPAY_V2 @PsRazon_Social    = @PsRazon_Social,
 --                                            @PsCla_Ubicacion   = @PsCla_Ubicacion,
 --                                            @PsCla_CentroCosto = @PsCla_CentroCosto,
 --                                            @PsCla_Periodo     = @PsCla_Periodo,
 --                                            @PsCla_RegImss     = @PsCla_RegImss,
 --                                            @PsEstatus_Trab    = @PsEstatus_Trab,
 --                                            @PsCla_Depto       = @PsCla_Depto,
 --                                            @PsCla_Trab        = @PsCla_Trab,
 --                                            @PsCla_Puestos     = @PsCla_Puestos,
 --                                            @nUsuario          = @nUsuario;

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
  (@PsRazon_Social           Varchar(Max)   = '',
   @PsCla_Empresa            Varchar(Max)   = '',
   @PsCla_Ubicacion          Varchar(Max)   = '',
   @PsCla_CentroCosto        Varchar(Max)   = '',
   @PsCla_Periodo            Varchar(Max)   = '',
   @PsCla_Depto              Varchar(Max)   = '',
   @PsEstatus_Trab           Varchar(Max)   = '',
   @PsCla_RegImss            Varchar(Max)   = '',
   @PsCla_Trab               Varchar(Max)   = '',
   @PsCla_Puestos            Varchar(Max)   = '',
   @nUsuario                 Integer,
   @PnError                  Integer        = 0    Output,
   @PsMensaje                Varchar(250)   = Null Output)
As

Declare
  @FIN_ANIO_ANTERIOR         Date,
  @FIN_ANIO_ACTUAL           Date,
  @INI_ANIO_ACTUAL           Date,
  @INI_ANIO_ANTERIOR         Date,
--
  @w_anioMesIni              Char(4),
  @w_anioMesFin              Char(4),
  @w_fecha                   Date,
  @w_fechaProc               Datetime,
  @w_anio                    Integer;

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off

   Select @PnError           = 0,
          @PsMensaje         = '',
          @w_fechaProc       = Getdate(),
          @w_fecha           = @w_fechaProc,
          @w_anioMesIni      = '0101',
          @w_anioMesFin      = '1231',
          @w_anio            = Year(@w_fechaProc),
          @INI_ANIO_ANTERIOR = Convert(Date, Str(Year(DATEADD(YY, -1, @w_fecha ))) + @w_anioMesIni),
          @FIN_ANIO_ANTERIOR = Convert(DATE, Str(Year(DATEADD(YY, -1, @w_fecha)))  + @w_anioMesFin),
          @INI_ANIO_ACTUAL   = Convert(Date, Str(Year(@w_fecha)) + @w_anioMesIni),
          @FIN_ANIO_ACTUAL   = Convert(Date, Str(Year(@w_fecha)) + @w_anioMesFin);

--
-- Generación de Tablas Temporales.
--

-- Razón Social.

   Create Table #TempRazon_Social
  (CLA_RAZON_SOCIAL  Integer      Not Null,
   NOM_RAZON_SOCIAL  Varchar(300) Not Null,
   CLA_EMPRESA       Integer      Not Null,
   Constraint TempRazon_SocialPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA));

-- Razón Empresa.

   Create Table #TempEmpresa
  (CLA_RAZON_SOCIAL  Integer      Not Null,
   CLA_EMPRESA       Integer Not Null,
   Constraint TempEmpresaPk
   Primary Key (CLA_EMPRESA, CLA_RAZON_SOCIAL));

-- Tabla Temporal de Ubicación.

   Create Table #tmpUbicacion
  (CLA_EMPRESA         Integer      Not Null,
   CLA_UBICACION       Integer      Not Null,
   NOM_UBICACION       Varchar(100) Not Null,
   Constraint tmpUbicacionPk
   Primary Key (CLA_EMPRESA, CLA_UBICACION));

--
-- Tabla Temporal de Centro de Costo.
--

   Create Table #tmpCentroCosto
  (CLA_EMPRESA         Integer      Not Null,
   CLA_CENTRO_COSTO    Integer      Not Null,
   NOM_CENTRO_COSTO    Varchar(100) Not Null,
   Constraint tmpCCPk
   Primary Key (CLA_EMPRESA, CLA_CENTRO_COSTO));

--
-- Tabla Temporal de Departamento.
--

   Create Table #tmpDepto
  (CLA_EMPRESA Integer       Not Null,
   CLA_DEPTO   Integer       Not Null,
   NOM_DEPTO   Varchar(100)  Not Null,
   CLA_AREA    Integer           Null,
   NOM_AREA    Varchar(100)      Null,
   Index tmpDeptoidx(CLA_EMPRESA, CLA_DEPTO));

--
-- Tabla Temporal de Períodos.
--

   Create Table #tempPeriodo
  (CLA_EMPRESA  Integer       Not Null,
   CLA_PERIODO  Integer       Not Null,
   NOM_PERIODO  Varchar(100)  Not Null,
   Constraint tempPeriodoPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO));

--
-- Tabla Temporal de Regimen IMSS.
--

   Create Table #tmpRegImss
  (CLA_EMPRESA      Integer      Not Null,
   CLA_REG_IMSS     Integer      Not Null,
   NUM_REG_IMSS     Varchar( 20) Not Null,
   NOM_REG_IMSS     Varchar(100) Not Null,
   Constraint tmpRegImssPk
   Primary Key (CLA_EMPRESA, NUM_REG_IMSS));

--
-- Tabla Temporal de Trabajadores.
--

   Create Table #TempTrabajador
  (CLA_EMPRESA      Integer      Not Null,
   CLA_TRAB         Integer      Not Null,
   Constraint TempTrabajadorPk
   Primary Key (CLA_EMPRESA, CLA_TRAB));

--
-- Tabla Temporal de Puestos.
--

   Create Table #tmpPuesto
  (CLA_EMPRESA     Integer       Not Null,
   CLA_PUESTO      Integer       Not Null,
   NOM_PUESTO      Varchar(250)  Not Null,
   Constraint tmpPuestoPk
   Primary Key (CLA_EMPRESA, CLA_PUESTO));

--
-- Tabla Temporal de Estatus Trabajador.
--

   Create Table #TmpEstatusTrab
  (idEstatus    Varchar(2) Not Null Primary Key);

--
-- Inicio de Proceso.
--

--
-- Filtro para Consulta de Razon Social.
--

   If Isnull(@PsRazon_Social, '') = ''
      Begin
         Insert Into #TempRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA
         From   dbo.rh_razon_social;
      End
   Else
      Begin
         Insert Into #TempRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select Distinct b.CLA_RAZON_SOCIAL, b.NOM_RAZON_SOCIAL, b.CLA_EMPRESA
         From   String_split(@PsRazon_Social, ',') a
         Join   dbo.rh_razon_social                  b
         On     b.CLA_RAZON_SOCIAL= a.value;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 1,
                      @PsMensaje = 'La Lista de Razon social Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro para Consulta de Empresas
--

   If Isnull(@PsCla_Empresa, '') = ''
      Begin
         Insert Into #TempEmpresa
        (CLA_RAZON_SOCIAL, CLA_EMPRESA)
         Select Distinct a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA
         From   dbo.rh_razon_social a
         Join   #TempRazon_Social   b
         On     b.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
         And    b.CLA_EMPRESA      = a.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #TempEmpresa
        (CLA_RAZON_SOCIAL, CLA_EMPRESA)
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA
         From   String_split(@PsCla_Empresa, ',') a
         Join   dbo.rh_razon_social               b
         On     b.CLA_EMPRESA = a.value
         Join   #TempRazon_Social   c
         On     c.CLA_RAZON_SOCIAL = b.CLA_RAZON_SOCIAL
         And    c.CLA_EMPRESA      = b.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 2,
                      @PsMensaje = 'La Lista de Empresas Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro para Consulta de Estatus de Trabajador
--

   If Isnull(@PsEstatus_Trab, '') = ''
      Begin
         Insert Into #TmpEstatusTrab
        (idEstatus)
        Select Distinct STATUS_TRAB
        From   dbo.RH_TRAB;
     End
  Else
     Begin
         Insert Into #TmpEstatusTrab
        (idEstatus)
        Select Distinct STATUS_TRAB
        From   String_split(@PsEstatus_Trab, ',') a
        Join   dbo.RH_TRAB b
        On     b.STATUS_TRAB = a.value;
        If @@Rowcount = 0
           Begin
              Select @PnError   = 3,
                     @PsMensaje = 'La Lista de Estatus del Trabajador Esta Vacía.'

              Select @PnError IdError, @PsMensaje Error
              Set Xact_Abort Off
              Return

           End
     End

--
-- Filtro para Consulta de Ubicación.
--

   If Isnull(@PsCla_Ubicacion, '') = ''
      Begin
         Insert Into #tmpUbicacion
        (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
         Select Distinct a.CLA_EMPRESA, a.CLA_UBICACION, a.NOM_UBICACION
         From   dbo.RH_UBICACION a
         Join   #TempEmpresa     b
         On     b.CLA_EMPRESA = a.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #tmpUbicacion
        (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
         Select Distinct b.CLA_EMPRESA, b.CLA_UBICACION, b.NOM_UBICACION
         From   String_split(@PsCla_Ubicacion, ',') a
         Join   dbo.RH_UBICACION                    b
         On     b.CLA_UBICACION   = a.value
         Join   #TempEmpresa     c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 4,
                      @PsMensaje = 'La Lista de Ubicaciones Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro para Consulta de los centros de Costo.
--

   If Isnull(@PsCla_CentroCosto, '') = ''
      Begin
         Insert Into #tmpCentroCosto
        (CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO)
         Select Distinct a.CLA_EMPRESA, a.CLA_CENTRO_COSTO, a.NOM_CENTRO_COSTO
         From   dbo.RH_CENTRO_COSTO a
         Join   #TempEmpresa     c
         On     c.CLA_EMPRESA     = a.CLA_EMPRESA;
      End
   Else
      Begin

         Insert Into #tmpCentroCosto
        (CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_CENTRO_COSTO, b.NOM_CENTRO_COSTO
         From   String_split(@PsCla_CentroCosto, ',') a
         Join   dbo.RH_CENTRO_COSTO                   b
         On     b.CLA_CENTRO_COSTO = a.value
         Join   #TempEmpresa     c
         On     c.CLA_EMPRESA      = b.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 5,
                      @PsMensaje = 'La Lista de Centros de Costos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro para Consulta de los Departamentos
--

   If Isnull(@PsCla_Depto, '') = ''
      Begin
         Insert Into #tmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA, NOM_AREA)
         Select Distinct t1.CLA_EMPRESA, t1.CLA_DEPTO, t1.NOM_DEPTO,
                t1.CLA_AREA,    t2.NOM_AREA
         From   dbo.RH_DEPTO    t1
         LEFT   Join dbo.RH_AREA t2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t2.CLA_AREA    = t1.CLA_AREA
         Join   #TempEmpresa     c
         On     c.CLA_EMPRESA     = t1.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #tmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA, NOM_AREA)
         Select Distinct t2.CLA_EMPRESA, t2.CLA_DEPTO, t2.NOM_DEPTO,
                t2.CLA_AREA,    t3.NOM_AREA
         From   String_split(@PsCla_Depto, ',') t1
         Join   dbo.RH_DEPTO                    t2
         On     t2.CLA_DEPTO   = t1.value
         LEFT   Join dbo.RH_AREA                t3
         On     t3.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t3.CLA_AREA    = t2.CLA_AREA
         Join   #TempEmpresa     c
         On     c.CLA_EMPRESA  = T2.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 6,
                      @PsMensaje = 'La Lista de Departamentos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro para Consulta de los Regimenes IMSS
--

   If Isnull(@PsCla_RegImss, '') = ''
      Begin
         Insert Into #tmpRegImss
        (CLA_REG_IMSS, CLA_EMPRESA, NOM_REG_IMSS, NUM_REG_IMSS)
         Select Distinct a.CLA_REG_IMSS, a.CLA_EMPRESA, a.NOM_REG_IMSS, a.NUM_REG_IMSS
         From   dbo.RH_REG_IMSS  a
         Join   #TempEmpresa     c
         On     c.CLA_EMPRESA     = a.CLA_EMPRESA
         Order  By 1;
      End
   Else
       Begin
         Insert Into #tmpRegImss
        (CLA_REG_IMSS, CLA_EMPRESA, NOM_REG_IMSS, NUM_REG_IMSS)
         Select Distinct b.CLA_REG_IMSS, b.CLA_EMPRESA, b.NOM_REG_IMSS, b.NUM_REG_IMSS
         From   String_split(@PsCla_RegImss, ',') a
         Join   dbo.RH_REG_IMSS                   b
         On     b.CLA_REG_IMSS = @PsCla_RegImss
         Join   #TempEmpresa     c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA
         Order  By 1;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 7,
                      @PsMensaje = 'La Lista de los Regimen del IMSS Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro para Consulta de los Trabajadores
--
   If Isnull(@PsCla_Trab, '') = ''
      Begin
         Insert Into #TempTrabajador
        (CLA_EMPRESA, CLA_TRAB)
         Select Distinct a.CLA_EMPRESA, a.CLA_TRAB
         From   dbo.RH_TRAB       a
         Join   #TempEmpresa b
         On     b.CLA_EMPRESA      = a.CLA_EMPRESA
         And    b.cla_razon_social = a.CLA_RAZON_SOCIAL
         Order  By 2;
      End
   Else
      Begin
         Insert Into #TempTrabajador
        (CLA_EMPRESA, CLA_TRAB)
         Select Distinct b.CLA_EMPRESA, b.CLA_TRAB
         From   String_split(@PsCla_Trab, ',') a
         Join   dbo.RH_Trab                    b
         On     b.CLA_TRAB      = a.value
         Join   #TempEmpresa                   c
         On     c.CLA_EMPRESA      = b.CLA_EMPRESA
         And    c.cla_razon_social = b.CLA_RAZON_SOCIAL
         Order  By 2;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 8,
                      @PsMensaje = 'La Lista de los Trabajadores Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta de los Períodos de Nomina
--

   If Isnull(@PsCla_Periodo, '') = ''
      Begin
         Insert Into #tempPeriodo
       (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct a.CLA_EMPRESA, a.CLA_PERIODO, a.NOM_PERIODO
         From   dbo.RH_PERIODO    a
         Join   #TempEmpresa      b
         On     b.CLA_EMPRESA      = a.CLA_EMPRESA
         And    b.cla_razon_social = a.CLA_RAZON_SOCIAL
         Order  By 2;
      End
   Else
      Begin
         Insert Into #tempPeriodo
        (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERIODO, b.NOM_PERIODO
         From   String_split(@PsCla_Periodo, ',') a
         Join   dbo.RH_PERIODO              b
         On     b.CLA_PERIODO      = a.value
         Join   #TempEmpresa c
         On     c.CLA_EMPRESA      = b.CLA_EMPRESA
         And    c.cla_razon_social = b.CLA_RAZON_SOCIAL
         Order  By 2;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 10,
                      @PsMensaje = 'La Lista de los períodos de nómina Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta de los Puestos.
--


   If Isnull(@PsCla_Puestos, '') = ''
      Begin
         Insert Into #tmpPuesto
        (CLA_EMPRESA, CLA_PUESTO, NOM_PUESTO)
         Select Distinct t1.CLA_EMPRESA, t1.CLA_PUESTO,  t1.NOM_PUESTO
         From   dbo.RH_PUESTO t1
         Join   #TempEmpresa  t2
         On     t2.CLA_EMPRESA     = T1.CLA_EMPRESA
         Order  By 2;
      End
   Else
      Begin
         Insert Into #tmpPuesto
        (CLA_EMPRESA, CLA_PUESTO, NOM_PUESTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PUESTO,  b.NOM_PUESTO
         From   String_split(@PsCla_Puestos, ',') a
         Join   dbo.RH_PUESTO                     b
         On     b.CLA_PUESTO      = a.value
         Join   #TempEmpresa      c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA
         Order  by 2;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 11,
                      @PsMensaje = 'La Lista de los Puestos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta Principal del Reporte.
--

   Select T1.CLA_TRAB, dbo.fnNombreCompletoTrab(T1.CLA_EMPRESA, T1.CLA_TRAB) NOMBRE,
          T1.CURP, T1.RFC, T1.NUM_IMSS,
          Trim(T2.NOM_PUESTO)            NOM_PUESTO,
          T4.CLA_CENTRO_COSTO            CLA_CENTRO_COSTO,
          Trim(T4.NOM_CENTRO_COSTO)      NOM_CENTRO_COSTO,
          T13.CLA_UBICACION              CLA_UBICACION,
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
          Isnull(Trim(T6.NOM_BANCO), '') NOM_BANCO,
          t1.CTA_BANCO                   CUENTA,
          Trim(T3.NOM_FORMA_PAGO)        NOM_FORMA_PAGO,
          t1.CLABE_INTERBANCARIA,        Convert(Char(10), T1.FECHA_ING, 103) FECHA_ING,
          Convert(Char(10), T1.fecha_ing_grupo, 103) FECHA_ING_GRUPO,
          Isnull(T1.CTA_CORREO, '')  CTA_CORREO, T1.NUM_CTA_DESPENSA,
          dbo.fnCalcAntig(T1.ANTIG_BASE,
               Isnull(T1.FECHA_ING_GRUPO, t1.FECHA_ING), @w_fechaProc) ANTIG,
          Case t1.sind When 1
                       Then 'SINDICALIZADO'
                       Else 'NO SINDICALIZADO'
          End SIND,
          Isnull(T1.CRED_INF, '') CRED_INF,
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
          T1.VALOR_TASA_INFO   TASAINFO,
          Convert(Char(10), T1.FECHA_INI_DESCINF, 103)   FECHA_INICIAL_INFO,
          Convert(Char(10), T1.FECHA_SUSP_DESC_INF, 103) FECHA_SUPENSION_INFO,
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
          Convert(Char(10), T1.FECHA_NAC, 103) FECHA_NACIMIENTO,
          T1.SEXO                       GENERO,
          dbo.fnNumLetra(T1.SUELDO_MENSUAL,1) SUELDO_LETRA,
          x.CLA_TAB_PRE,
          x.NOM_TAB_PRE,
          x.DIAS_VAC VACACIONES, x.PRIMA_VAC PRIMA_VAC, x.DIAS_AGUI AGUINALDO,
          dbo.Fn_FDOCJA_AHORRO(T1.CLA_EMPRESA, T1.CLA_TRAB, 2)   FDO_AHORRO,
          dbo.Fn_FDOCJA_AHORRO(T1.CLA_EMPRESA, T1.CLA_TRAB, 3)   CAJA_AHORRO,
          Isnull(Convert(Varchar,T1.FECHA_BAJA, 103), '')   FECHA_BAJA,
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
          Isnull((Select Sum(GRAV_IMSS)
                  From   dbo.RH_DET_REC_HISTO a
                  Join   dbo.Rh_perded        b
                  On     b.CLA_EMPRESA     = a.CLA_EMPRESA
                  And    b.CLA_PERDED      = a.CLA_PERDED
                  And    b.NO_IMPRIMIR     = 0
                  And    b.NO_AFECTAR_NETO = 0
                  And    b.ES_PROVISION    = 0
                  Where  a.CLA_EMPRESA     = t1.CLA_EMPRESA
                  And    a.CLA_TRAB        = T1.CLA_TRAB
                  And    a.NUM_NOMINA      = ( Select MAX(num_nomina)
                                               From   dbo.RH_DET_REC_HISTO
                                               Where  CLA_TRAB    = a.CLA_TRAB
                                               And    CLA_EMPRESA = a.CLA_EMPRESA)), 0.00) VARIABLE_IMSS,
          Case When T1.APLICA_DEC = 1
               Then 'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_DECARACION,
          Case When T1.APLICA_DEC_SUELDOS = 1
               Then 'SI APLICA'
               Else 'NO APLICA'
          End  APLICA_DECARACION_SUE,
--
          Iif(CAST(T1.fotografia as Varbinary(Max)) Is null, 'NO', 'SI') "FOTOGRAFIA",
--
          t1.FACTOR_INT FACTOR_INTEGRACION,
          dbo.Fn_buscaDatoComplementario(t1.CLA_EMPRESA, t1.CLA_TRAB, 'Vales de despensa') VALESDESPENSA,
          dbo.Fn_buscaDatoComplementario(t1.CLA_EMPRESA, t1.CLA_TRAB, 'ESCOLARIDAD')       ESCOLARIDAD,
          dbo.fnObtenerNombreJefe (t1.CLA_TRAB, t1.CLA_EMPRESA, 1) JEFE_INMEDIATO
   From  dbo.RH_TRAB       T1
   Join  #TempRazon_Social T14
   On    T14.CLA_RAZON_SOCIAL = T1.CLA_RAZON_SOCIAL
   And   T14.CLA_EMPRESA      = T1.CLA_EMPRESA
   Join  #tmpPuesto    T2
   On    T1.CLA_EMPRESA        = T2.CLA_EMPRESA
   And   T1.CLA_PUESTO         = T2.CLA_PUESTO
   Join  dbo.RH_FORMA_PAGO T3
   On    T1.CLA_EMPRESA        = T3.CLA_EMPRESA
   And   T1.CLA_FORMA_PAGO     = T3.CLA_FORMA_PAGO
   Join  #tmpCentroCosto   T4
   On    T1.CLA_EMPRESA        = T4.CLA_EMPRESA
   And   T1.CLA_CENTRO_COSTO   = T4.CLA_CENTRO_COSTO
   Join  dbo.RH_CLASIFICACION T5
   On    T1.CLA_EMPRESA        = T5.CLA_EMPRESA
   And   T1.CLA_CLASIFICACION  = T5.CLA_CLASIFICACION
   LEFT  Join dbo.RH_BANCO T6
   On    T1.CLA_BANCO          = T6.CLA_BANCO
   Join  #tmpDepto            T11
   On    T1.CLA_EMPRESA        = T11.CLA_EMPRESA
   And   T1.CLA_DEPTO          = T11.CLA_DEPTO
   Join  #tempPeriodo         T12
   On    T1.CLA_PERIODO        = T12.CLA_PERIODO
   And   T1.CLA_EMPRESA        = T12.CLA_EMPRESA
   Join  #tmpUbicacion T13
   On    T1.CLA_EMPRESA        = T13.CLA_EMPRESA
   And   T1.CLA_UBICACION_BASE = T13.CLA_UBICACION
   Join  #tmpRegImss          T15
   On    t1.CLA_REG_IMSS       = T15.CLA_REG_IMSS
   And   T1.CLA_EMPRESA        = T15.CLA_EMPRESA
   Join  #TempEmpresa         T16
   On    T1.CLA_EMPRESA        = T16.CLA_EMPRESA
   And   T1.CLA_RAZON_SOCIAL   = T16.CLA_RAZON_SOCIAL
   Join  dbo.RH_ENC_TAB_PRESTAC T7
   On    T1.CLA_TAB_PRE        = T7.CLA_TAB_PRE
   And   T1.CLA_EMPRESA        = T7.CLA_EMPRESA
   Join  #TmpEstatusTrab   T18
   On    T1.STATUS_TRAB  = t18.idEstatus      Collate database_default
   Join  #TempTrabajador   t19
   On    T1.CLA_TRAB     = T19.CLA_TRAB
   And   T1.CLA_EMPRESA  = T7.CLA_EMPRESA
   Left  Join  (Select a.CLA_EMPRESA, a.CLA_TRAB, a.CLA_TAB_PRE, b.NOM_TAB_PRE,
                       c.DIAS_VAC, c.PRIMA_VAC, c.DIAS_AGUI
                From   RH_TRAB a
                Join   RH_ENC_TAB_PRESTAC b
                On     b.CLA_TAB_PRE = a.CLA_TAB_PRE
                And    b.CLA_EMPRESA = a.CLA_EMPRESA
                Join   RH_DET_TAB_PRESTAC c
                On     c.CLA_TAB_PRE = b.CLA_TAB_PRE
                And    c.CLA_EMPRESA = b.CLA_EMPRESA
				Join   RH_DET_VACACION  d
                On    d.CLA_EMPRESA = a.CLA_EMPRESA
				And   d.CLA_TRAB    = a.cla_trab
				And   d.ANIO        = @w_anio
                And   d.ANTIG       = c.antig) x
   On    x.CLA_EMPRESA         = T1.CLA_EMPRESA
   And   x.CLA_TRAB            = T1.CLA_TRAB
   Where DBO.fnc_ValidaSeguridadStd(T1.CLA_EMPRESA, @nUsuario,T1.CLA_UBICACION_BASE,T1.CLA_dEPTO,T1.CLA_PERIODO) > 0
   Order By T1.CLA_TRAB

   Set Xact_Abort Off
   Return
    
End
Go
