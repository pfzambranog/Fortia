-- Declare
   -- @PsRazon_Social            Varchar(Max)   = '1',
   -- @PsCla_Empresa             Varchar(Max)   = '',
   -- @PnAnio                    Integer        = 2025,
   -- @PnMesIni                  Integer        = 0,
   -- @PnMesFin                  Integer        = 0,
   -- @PsCla_Ubicacion           Varchar(Max)   = '',
   -- @PsCla_CentroCosto         Varchar(Max)   = '',
   -- @PsCla_Area                Varchar(Max)   = '',
   -- @PsCla_Depto               Varchar(Max)   = '',
   -- @PsCla_RegImss             Varchar(Max)   = '',
   -- @PsCla_PerDed              Varchar(Max)   = '',
   -- @PsCla_Periodo             Varchar(Max)   = '',
   -- @PsNominas                 Varchar(Max)   = '',
   -- @PsCla_Trab                Varchar(Max)   = '',
   -- @PsCLa_Puesto              Varchar(Max)   = '',
   -- @PbImprimeProv             Bit            = 1,
   -- @PbIncluyeNominaAbierta    Bit            = 1,
   -- @PsStatusNom               Varchar(Max)   = Null,
   -- @PnError                   Integer        = 0,
   -- @PsMensaje                 Varchar( 250)  = ' ';
-- Begin
   -- Execute dbo.SP_NOMINA_TABULAR_XLS_V3 @PsRazon_Social          = @PsRazon_Social,
                                       -- @PsCla_Empresa            = @PsCla_Empresa,
                                       -- @PnAnio                   = @PnAnio,
                                       -- @PnMesIni                 = @PnMesIni,
                                       -- @PnMesFin                 = @PnMesFin,
                                       -- @PsCla_Ubicacion          = @PsCla_Ubicacion,
                                       -- @PsCla_CentroCosto        = @PsCla_CentroCosto,
                                       -- @PsCla_Area               = @PsCla_Area,
                                       -- @PsCla_Depto              = @PsCla_Depto,
                                       -- @PsCla_RegImss            = @PsCla_RegImss,
                                       -- @PsCla_PerDed             = @PsCla_PerDed,
                                       -- @PsCla_Periodo            = @PsCla_Periodo,
                                       -- @PsNominas                = @PsNominas,
                                       -- @PsCla_Trab               = @PsCla_Trab,
                                       -- @PsCLa_Puesto             = @PsCLa_Puesto,
                                       -- @PbImprimeProv            = @PbImprimeProv,
                                       -- @PsStatusNom              = @PsStatusNom,
                                       -- @PbIncluyeNominaAbierta   = @PbIncluyeNominaAbierta,
                                       -- @PnError                  = @PnError   Output,
                                       -- @PsMensaje                = @PsMensaje Output;
   -- If @PnError != 0
      -- Begin
         -- Select @PnError, @PsMensaje;
      -- End

   -- Return

-- End
-- Go

Create Or Alter Procedure SP_NOMINA_TABULAR_XLS_V3
  (@PsRazon_Social            Varchar(Max)   = '',
   @PsCla_Empresa             Varchar(Max)   = '',
   @PnAnio                    Integer,
   @PsCla_Ubicacion           Varchar(Max)   = '',
   @PsCla_CentroCosto         Varchar(Max)   = '',
   @PsCla_Area                Varchar(Max)   = '',
   @PsCla_Depto               Varchar(Max)   = '',
   @PsCla_RegImss             Varchar(Max)   = '',
   @PnMesIni                  Integer        = 0,
   @PnMesFin                  Integer        = 0,
   @PsCla_TipoNom             Varchar(Max)   = '',
   @PsCla_PerDed              Varchar(Max)   = '',
   @PsCla_Periodo             Varchar(Max)   = '',
   @PsNominas                 Varchar(Max)   = '',
   @PsCla_Trab                Varchar(Max)   = '',
   @PsCla_Puesto              Varchar(Max)   = '',
   @PsStatusNom               Varchar(Max)   = '',
   @PbImprimeProv             Bit            = 1,
   @PbIncluyeNominaAbierta    Bit            = 1,
   @PnError                   Integer        = 0    Output,
   @PsMensaje                 Varchar( 250)  = Null Output)
As

Declare
   @w_desc_error              Varchar(250),
   @w_tituloRep               Varchar(350),
   @w_fechaProc               Varchar( 10),
   @w_fechaProcIni            Varchar( 10),
   @w_fechaProcFin            Varchar( 10),
   @w_nomina                  Varchar( 10),
   @w_nom_trab                Varchar(300),
   @w_nom_trab_ante           Varchar(300),
   @w_nom_razon_social        Varchar(350),
   @w_nom_razon_social_ante   Varchar(350),
   @w_nom_empresa             Varchar(350),
   @w_nom_empresa_ante        Varchar(350),
   @w_nom_ubicacion           Varchar( 80),
   @w_nom_ubicacion_ante      Varchar( 80),
   @w_nom_centro_costo        Varchar( 80),
   @w_nom_centro_costo_ante   Varchar( 80),
   @w_nom_depto               Varchar( 80),
   @w_nom_depto_ante          Varchar( 80),
   @w_nom_perded              Varchar( 80),
   @w_cla_perded              Varchar( 20),
   @w_nominas                 Varchar(Max),
   @w_sql                     Varchar(Max),
   @w_cla_razon_social        Integer,
   @w_cla_razon_social_ante   Integer,
   @w_cla_empresa             Integer,
   @w_cla_empresa_ante        Integer,
   @w_cla_trab                Integer,
   @w_cla_trab_ante           Integer,
   @w_cla_ubicacion           Integer,
   @w_cla_ubicacion_ante      Integer,
   @w_cla_centro_costo        Integer,
   @w_cla_centro_costo_ante   Integer,
   @w_cla_depto               Integer,
   @w_cla_depto_ante          Integer,
   @w_cla_puesto              Varchar( 10),
   @w_NOM_PUESTO              Varchar( 80),
   @w_Error                   Integer,
   @w_secuencia               Integer,
   @w_registros               Integer,
   @w_MesIni                  Integer,
   @w_MesFin                  Integer,
   @w_AnioMesIni              Integer,
   @w_AnioMesFin              Integer,
   @w_reg                     Integer,
   @w_secFin                  Integer,
   @w_horaProceso             Char(20),
   @w_comilla                 Char( 1),
   @w_inicio                  Bit,
   @w_importe                 Decimal(18, 2),
   @w_FECHA_ING               Date,
   @w_fecha_ing_ante          Date,
   @w_FECHA_ING_GRUPO         Date,
   @w_fecha_ing_grupo_ante    Date,
   @w_NSS                     Varchar(20),
   @w_nss_ante                Varchar(20),
   @w_RFC                     Varchar(20),
   @w_rfc_ante                Varchar(20),
   @w_CLA_PERIODO             Integer,
   @w_NUM_NOMINA              Integer,
   @w_NOM_PERIODO             Varchar(150),
   @w_tipo_companiero         Varchar( 50),
   @w_tipo_companiero_ante    Varchar( 50),
   @w_anio_mes                Integer,
   @w_inicio_per              Varchar( 10),
   @w_fin_per                 Varchar( 10),
   @w_sue_dia                 Decimal(18, 2),
   @w_sue_dia_ante            Decimal(18, 2),
   @w_sue_int                 Decimal(18, 2),
   @w_sue_int_ante            Decimal(18, 2),
   @w_tot_per                 Decimal(18, 2),
   @w_tot_per_ante            Decimal(18, 2),
   @w_tot_ded                 Decimal(18, 2),
   @w_tot_ded_ante            Decimal(18, 2),
   @w_tot_neto                Decimal(18, 2),
   @w_tot_neto_ante           Decimal(18, 2),
   @w_dias_por_pagar          Decimal(18, 2),
   @w_dias_por_pagar_ante     Decimal(18, 2),
   @w_nom_tipo_nomina         Varchar(Max);

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off
   Set Ansi_Warnings On

   Select @PnError       = 0,
          @w_registros   = 0,
          @w_secuencia   = 0,
          @w_inicio      = 1,
          @w_nominas     = '',
          @w_comilla     = Char(39),
          @PsMensaje     = 'Proceso Terminado Ok',
          @w_tituloRep   = 'NOMINA POR UBICACION, C.COSTO Y DEPARTAMENTO',
          @w_fechaProc   = Convert(Char(10), Getdate(), 103),
          @w_horaProceso = Format(Getdate(), 'hh:mm:ss tt'),
          @w_MesIni      = Case When Isnull(@PnMesIni, 0) = 0
                               Then 1
                               Else @PnMesIni
                          End,
          @w_mesFin     = Case When Isnull(@PnMesFin, 0) = 0
                               Then 12
                               Else @PnMesFin
                          End,
          @w_AnioMesIni = Case When Isnull(@PnMesIni, 0) = 0
                               Then (@PnAnio * 100) + @w_MesIni
                               Else (@PnAnio * 100) + @PnMesIni
                          End,
         @w_AnioMesFin  = Case When Isnull(@PnMesFin, 0) = 0
                               Then (@PnAnio * 100) + @w_MesFin
                               Else (@PnAnio * 100) + @PnMesFin
                          End;

--
-- Creación de Tablas Temporales.
--

--
-- Tabla Temporal Razón Social.
--

   Create Table #TmpRazon_Social
  (CLA_RAZON_SOCIAL  Integer      Not Null,
   NOM_RAZON_SOCIAL  Varchar(300) Not Null,
   CLA_EMPRESA       Integer      Not Null,
   Constraint TempRazon_SocialPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA));

--
-- Tabla Temporal Empresa.
--

   Create Table #TmpEmpresa
  (CLA_RAZON_SOCIAL  Integer      Not Null,
   CLA_EMPRESA       Integer      Not Null,
   NOM_EMPRESA       Varchar(300) Not Null,
   Constraint TempEmpresaPk
   Primary Key (CLA_EMPRESA, CLA_RAZON_SOCIAL));

-- Tabla Temporal de Ubicación.

   Create Table #tmpUbicacion
  (CLA_EMPRESA         Integer      Not Null,
   CLA_UBICACION       Integer      Not Null,
   NOM_UBICACION       Varchar(100) Not Null,
   Constraint tmpUbicacionPk
   Primary Key (CLA_EMPRESA, CLA_UBICACION));

-- Tabla Temporal de Centro de Costo.

   Create Table #tmpCentroCosto
  (CLA_EMPRESA         Integer      Not Null,
   CLA_CENTRO_COSTO    Integer      Not Null,
   NOM_CENTRO_COSTO    Varchar(100) Not Null,
   Constraint tmpCCPk
   Primary Key (CLA_EMPRESA, CLA_CENTRO_COSTO));

--
-- Tabla Temporal de Areas.
--

   Create Table #tmpArea
  (CLA_EMPRESA      Integer      Not Null,
   CLA_AREA         Integer      Not Null,
   NOM_AREA         Varchar(150) Not Null,
   Constraint tmpAreaPk
   Primary Key (CLA_EMPRESA, CLA_AREA));

-- Tabla Temporal de Departamento.

   Create Table #TmpDepto
  (CLA_EMPRESA         Integer       Not Null,
   CLA_DEPTO           Integer       Not Null,
   NOM_DEPTO           Varchar(100)  Not Null,
   CLA_AREA            Integer       Not Null,
   Constraint tmpDeptoPk
   Primary Key (CLA_EMPRESA, CLA_DEPTO));

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
-- Tabla Temporal de Puestos.
--

   Create Table #tmpPuesto
  (CLA_EMPRESA Integer       Not Null,
   CLA_PUESTO  Integer       Not Null,
   NOM_PUESTO  Varchar(250)  Not Null,
   Constraint tmpPuestoPk
   Primary Key (CLA_EMPRESA, CLA_PUESTO));

--
-- Tabla Temporal de Tipos de Nómina.
--

   Create Table #TmpTipoNom
  (TIPO_NOMINA            Integer       Not Null,
   NOM_TIPO_NOMINA        Varchar(100)  Not Null,
   Constraint tempTipoNomPk
   Primary Key (TIPO_NOMINA));

--
-- Tabla Temporal de Periodos de Nómina.
--

   Create Table #TmpPeriodo
  (CLA_EMPRESA  Integer       Not Null,
   CLA_PERIODO  Integer       Not Null,
   NOM_PERIODO  Varchar(100)  Not Null,
   Constraint tempPeriodoPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO));

--
-- Tabla Temporal de Conceptos de Nómina.
--

   Create  Table #tmpPerded
  (CLA_EMPRESA       Integer      Not Null,
   CLA_PERDED        Integer      Not Null,
   NOM_PERDED        Varchar( 80) Not Null,
   TIPO_PERDED       Integer      Not Null,
   MOSTRAR_SALDO     Integer      Not Null Default 0,
   GRUPO_CAL1        Integer      Not Null Default 1,
   NO_AFECTAR_NETO   Integer      Not Null Default 0,
   Constraint tmpPerdedPk
   Primary Key (CLA_EMPRESA, CLA_PERDED));

--
-- Tabla Temporal de Calendatrio de Nómina.
--

   Create Table #tmpNominas
  (CLA_EMPRESA      Integer      Not Null,
   CLA_PERIODO      Integer      Not Null,
   NUM_NOMINA       Integer      Not Null,
   ANIO_MES         Integer      Not Null,
   INICIO_PER       Date         Not Null,
   FIN_PER          Date         Not Null,
   ANIO             Integer          Null,
   NOM_PERIODO      Varchar( 20)     Null,
   TIPO_NOMINA      INTEGER          Null,
   NOM_TIPO_NOMINA  Varchar( 80) Not Null,
   STRING           Varchar(Max) Not Null,
   Constraint tmpNominasPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO, NUM_NOMINA));

--
-- Tabla Temporal de Estatus de Nómina.
--

   Create Table #TmpEstatusNomina
  (idEstatus    Integer Not Null Primary Key);

--
-- Tabla Temporal de Trabajadores.
--
   Create Table #TmpTrabajador
  (CLA_RAZON_SOCIAL   Integer       Not Null,
   CLA_EMPRESA        Integer       Not Null,
   CLA_TRAB           Integer       Not Null,
   NOM_TRAB           Varchar(400)      Null,
   CLA_UBICACION      Integer           Null,
   CLA_CENTRO_COSTO   Integer           Null,
   CLA_DEPTO          Integer           Null,
   CLA_PUESTO         Integer           Null,
   FECHA_ING          Date              Null,
   FECHA_ING_GRUPO    Date              Null,
   NSS                Varchar( 20)      Null,
   RFC                Varchar( 20)      Null,
   SINDICALIZADO      Varchar( 30)      Null,
   Constraint TmpTrabajadorPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB));

--
--
--

   Create Table  #TmpDIAS_POR_PAGAR
  (CLA_EMPRESA       Integer        Not Null,
   CLA_TRAB          Integer        Not Null,
   CLA_PERIODO       Integer        Not Null,
   NUM_NOMINA        Integer        Not Null,
   ANIO_MES          Integer        Not Null,
   DIAS_POR_PAGAR    Decimal(18, 2) Not Null,
   Index DIAS_POR_PAGARIDX01 (cla_empresa, CLA_TRAB, CLA_PERIODO, NUM_NOMINA, ANIO_MES));

--
-- Tabla de Relación Trabajadores Nómina.
--

   Create Table #tmpNominasTrab
  (CLA_RAZON_SOCIAL  Integer         Not Null,
   NOM_RAZON_SOCIAL  Varchar(300)    Not Null,
   CLA_EMPRESA       Integer         Not Null,
   NOM_EMPRESA       Varchar(100)    Not Null,
   CLA_TRAB          Integer             Null,
   NOM_TRAB          Varchar(150)        Null,
   FECHA_ING         VarchaR( 10)        Null,
   FECHA_ING_GRUPO   Varchar( 10)        Null,
   NSS               Varchar( 20)        Null,
   RFC               Varchar( 20)        Null,
   CLA_PERIODO       Integer         Not Null,
   NUM_NOMINA        Integer         Not Null,
   CLA_UBICACION     Integer         Not Null,
   NOM_UBICACION     Varchar(150)        Null,
   CLA_CENTRO_COSTO  Integer             Null,
   NOM_CENTRO_COSTO  Varchar(150)        Null,
   CLA_DEPTO         Integer             Null,
   NOM_DEPTO         Varchar(150)        Null,
   CLA_PUESTO        Integer             Null,
   NOM_PUESTO        Varchar(150)        Null,
   NOM_PERIODO       Varchar(150)        Null,
   TIPO_COMPANIERO   Varchar( 50)        Null,
   ANIO_MES          Integer             Null,
   INICIO_PER        Varchar( 10)        Null,
   FIN_PER           Varchar( 10)        Null,
   SUE_DIA           Decimal(18, 2)   Not Null Default 0,
   SUE_INT           Decimal(18, 2)   Not Null Default 0,
   TOT_PER           Decimal(18, 2)   Not Null Default 0,
   TOT_DED           Decimal(18, 2)   Not Null Default 0,
   TOT_NETO          Decimal(18, 2)   Not Null Default 0,
   DIAS_POR_PAGAR    Decimal(18, 2)       Null Default 0,
   CLA_PERDED        Integer          Not Null Default 0,
   NOM_PERDED        Varchar(100)     Not Null Default Char(32),
   NOM_TIPO_NOMINA   Varchar(100)     Not Null Default Char(32),
   IMPORTE           Decimal(18, 2)   Not Null Default 0,
   Index tmpNominasTrabIdx01 (CLA_EMPRESA, CLA_PERIODO, CLA_TRAB, ANIO_MES,
                              NUM_NOMINA,  CLA_PERDED));

--
-- Tabla de Salida.
--

   Create Table #tmpResultado
  (secuencia         Integer         Not Null Identity (1, 1) Primary Key,
   tipo              Char(2)         Not Null Default 'L0',
   CLA_RAZON_SOCIAL  Integer         Not Null,
   NOM_RAZON_SOCIAL  Varchar(300)    Not Null,
   CLA_EMPRESA       Integer         Not Null,
   NOM_EMPRESA       Varchar(100)    Not Null,
   CLA_TRAB          Integer             Null,
   NOM_TRAB          Varchar(150)        Null,
   FECHA_ING         VarchaR( 10)        Null,
   FECHA_ING_GRUPO   Varchar( 10)        Null,
   NSS               Varchar( 20)        Null,
   RFC               Varchar( 20)        Null,
   CLA_UBICACION     Integer         Not Null,
   NOM_UBICACION     Varchar(150)        Null,
   CLA_CENTRO_COSTO  Integer             Null,
   NOM_CENTRO_COSTO  Varchar(150)        Null,
   CLA_DEPTO         Integer             Null,
   NOM_DEPTO         Varchar(150)        Null,
   CLA_PUESTO        Varchar( 10)        Null Default Char(32),
   NOM_PUESTO        Varchar(150)        Null Default Char(32),
   TIPO_COMPANIERO   Varchar(150)        Null Default Char(32),
   SUE_DIA           Varchar( 30)        Null Default Char(32),
   SUE_INT           Varchar( 30)        Null Default Char(32),
   TOT_PER           Varchar( 30)        Null Default Char(32),
   TOT_DED           Varchar( 30)        Null Default Char(32),
   TOT_NETO          Varchar( 30)        Null Default Char(32),
   DIAS_POR_PAGAR    Varchar( 30)        Null Default Char(32),
   Index tmpResultadoIdx01 (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO,
                            CLA_DEPTO,        CLA_TRAB,    Tipo));

--
-- Inicio de Proceso.
--

--
-- Filtro de Consulta de Razon Social.
--

   If Isnull(@PsRazon_Social, '') = ''
      Begin
         Insert Into #TmpRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select CLA_RAZON_SOCIAL, Concat(nom_razon_social, ' - ', rfc_emp), CLA_EMPRESA
         From   dbo.rh_razon_social;
      End
   Else
      Begin
         Insert Into #TmpRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select Distinct b.CLA_RAZON_SOCIAL, Concat(b.nom_razon_social, ' - ', rfc_emp), b.CLA_EMPRESA
         From   String_split(@PsRazon_Social, ',') a
         Join   dbo.rh_razon_social                b
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
-- Filtro de Consulta de Empresas
--

   If Isnull(@PsCla_Empresa, '') = ''
      Begin
         Insert Into #TmpEmpresa
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, NOM_EMPRESA)
         Select Distinct a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.NOM_EMPRESA
         From   dbo.rh_razon_social a
         Join   #TmpRazon_Social   b
         On     b.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
         And    b.CLA_EMPRESA      = a.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #TmpEmpresa
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, NOM_EMPRESA)
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA, b.NOM_EMPRESA
         From   String_split(@PsCla_Empresa, ',') a
         Join   dbo.rh_razon_social               b
         On     b.CLA_EMPRESA = a.value
         Join   #TmpRazon_Social   c
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
-- Filtro de Consulta de Ubicación.
--

   If Isnull(@PsCla_Ubicacion, '') = ''
      Begin
         Insert Into #tmpUbicacion
        (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
         Select Distinct a.CLA_EMPRESA, a.CLA_UBICACION, a.NOM_UBICACION
         From   dbo.RH_UBICACION a
         Join   #TmpEmpresa      b
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
         Join   #TmpEmpresa                         c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 3,
                      @PsMensaje = 'La Lista de Ubicaciones Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro de Consulta de centros de Costo.
--

   If Isnull(@PsCla_CentroCosto, '') = ''
      Begin
         Insert Into #tmpCentroCosto
        (CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO)
         Select Distinct a.CLA_EMPRESA, a.CLA_CENTRO_COSTO, a.NOM_CENTRO_COSTO
         From   dbo.RH_CENTRO_COSTO a
         Join   #TmpEmpresa         b
         On     b.CLA_EMPRESA = a.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #tmpCentroCosto
        (CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_CENTRO_COSTO, b.NOM_CENTRO_COSTO
         From   String_split(@PsCla_CentroCosto, ',') a
         Join   dbo.RH_CENTRO_COSTO                   b
         On     b.CLA_CENTRO_COSTO = a.value
         Join   #TmpEmpresa                           c
         On     c.CLA_EMPRESA = b.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 4,
                      @PsMensaje = 'La Lista de Centros de Costos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro de Consulta de Areas
--

   If Isnull(@PsCla_Area, '') = ''
      Begin
         Insert Into #tmpArea
        (CLA_EMPRESA, CLA_AREA, NOM_AREA)
         Select Distinct a.CLA_EMPRESA, a.CLA_AREA, a.NOM_AREA
         From   dbo.RH_AREA a
         Join   #TmpEmpresa b
         On     b.CLA_EMPRESA = a.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #tmpArea
        (CLA_EMPRESA, CLA_AREA, NOM_AREA)
         Select Distinct b.CLA_EMPRESA, b.CLA_AREA, b.NOM_AREA
         From   String_split(@PsCla_Area, ',') a
         Join   dbo.RH_AREA                    b
         On     b.CLA_AREA         = a.value
         Join   #TmpEmpresa                    c
         On     C.CLA_EMPRESA      = b.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 4,
                      @PsMensaje = 'La Lista de Areas Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro de Consulta de Departamentos
--

   If Isnull(@PsCla_Depto, '') = ''
      Begin
         Insert Into #TmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA)
         Select DIstinct a.CLA_EMPRESA, a.CLA_DEPTO, a.NOM_DEPTO, a.CLA_AREA
         From   dbo.RH_DEPTO  a
         Join   #TmpEmpresa   b
         On     b.CLA_EMPRESA = a.CLA_EMPRESA
         Join   #tmpArea      c
         On     c.CLA_EMPRESA = a.CLA_EMPRESA
         And    c.CLA_AREA    = a.CLA_AREA;
      End
   Else
      Begin
         Insert Into #TmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA)
         Select Distinct b.CLA_EMPRESA, b.CLA_DEPTO, b.NOM_DEPTO, b.CLA_AREA
         From   String_split(@PsCla_Depto, ',') a
         Join   dbo.RH_DEPTO                    b
         On     b.CLA_DEPTO   = a.value
         Join   #TmpEmpresa                     c
         On     c.CLA_EMPRESA = b.CLA_EMPRESA
         Join   #tmpArea                        d
         On     d.CLA_EMPRESA = b.CLA_EMPRESA
         And    d.CLA_AREA    = b.CLA_AREA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 5,
                      @PsMensaje = 'La Lista de Departamentos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta de los Puestos.
--

   If Isnull(@PsCla_Puesto, '') = ''
      Begin
         Insert Into #tmpPuesto
        (CLA_EMPRESA, CLA_PUESTO, NOM_PUESTO)
         Select Distinct t1.CLA_EMPRESA, t1.CLA_PUESTO,  t1.NOM_PUESTO
         From   dbo.RH_PUESTO t1
         Join   #TmpEmpresa  t2
         On     t2.CLA_EMPRESA = t1.Cla_Empresa
         Order  By 1, 2;
      End
   Else
      Begin
         Insert Into #tmpPuesto
        (CLA_EMPRESA, CLA_PUESTO, NOM_PUESTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PUESTO,  b.NOM_PUESTO
         From   String_split(@PsCla_Puesto, ',') a
         Join   dbo.RH_PUESTO                     b
         On     b.CLA_PUESTO  = a.value
         Join   #TmpEmpresa                      c
         On     c.CLA_EMPRESA = b.Cla_Empresa
         Order  by 1, 2;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 7,
                      @PsMensaje = 'La Lista de los Puestos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro de Consulta de Regimenes IMSS
--

   If Isnull(@PsCla_RegImss, '') = ''
      Begin
         Insert Into #tmpRegImss
        (CLA_REG_IMSS, CLA_EMPRESA, NOM_REG_IMSS, NUM_REG_IMSS)
         Select Distinct a.CLA_REG_IMSS, a.CLA_EMPRESA, a.NOM_REG_IMSS, a.NUM_REG_IMSS
         From   dbo.RH_REG_IMSS  a
         Join   #TmpEmpresa     c
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
         Join   #TmpEmpresa     c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA
         Order  By 1;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 6,
                      @PsMensaje = 'La Lista de los Regimen del IMSS Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro de Consulta de Tipos de Nomina
--

   If Isnull(@PsCla_TipoNom, '') = ''
      Begin
         Insert Into #TmpTipoNom
        (TIPO_NOMINA, NOM_TIPO_NOMINA)
         Select Distinct TIPO_NOMINA, NOM_TIPO_NOMINA
         From   dbo.RH_TIPO_NOMINA
      End
   Else
      Begin
         Insert Into #TmpTipoNom
        (TIPO_NOMINA, NOM_TIPO_NOMINA)
         Select Distinct b.TIPO_NOMINA, b.NOM_TIPO_NOMINA
         From   String_split(@PsCla_TipoNom, ',') a
         Join   dbo.RH_TIPO_NOMINA               b
         On     b.TIPO_NOMINA      = a.value;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 7,
                      @PsMensaje = 'La Lista de los tipos de nómina Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro de Consulta de Períodos de Nomina
--

   If Isnull(@PsCla_Periodo, '') = ''
      Begin
         Insert Into #TmpPeriodo
       (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct a.CLA_EMPRESA, a.CLA_PERIODO, a.NOM_PERIODO
         From   dbo.RH_PERIODO a
         Join   #TmpEmpresa    b
         On     b.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
         And    b.CLA_EMPRESA      = a.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #TmpPeriodo
        (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERIODO, b.NOM_PERIODO
         From   String_split(@PsCla_Periodo, ',') a
         Join   dbo.RH_PERIODO                    b
         On     b.CLA_PERIODO      = a.value
         Join   #TmpEmpresa                        c
         On     c.CLA_RAZON_SOCIAL = b.CLA_RAZON_SOCIAL
         And    c.CLA_EMPRESA      = b.CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 8,
                      @PsMensaje = 'La Lista de los períodos de nómina Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Filtro para Consulta de Empresas
--

   If Isnull(@PsStatusNom, '') = ''
      Begin
         Insert Into #TmpEstatusNomina
         (idEstatus)
         Select distinct a.STATUS_NOMINA
         From   dbo.RH_FECHA_PER a
         Join   #TmpEmpresa     b
         On     b.CLA_EMPRESA = a.CLA_EMPRESA
         Order  By 1;
      End
   Else
      Begin
         Insert Into #TmpEstatusNomina
        (idEstatus)
         Select Distinct b.STATUS_NOMINA
         From   String_split(@PsStatusNom, ',') a
         Join   dbo.RH_FECHA_PER                b
         On     b.STATUS_NOMINA = a.value
         Join   #TmpEmpresa     c
         On     c.CLA_EMPRESA = b.CLA_EMPRESA
         Order  By 1;

        If @@Rowcount = 0
           Begin
              Select @PnError   = 3,
                     @PsMensaje = 'La Lista de Estatus de Nómina Esta Vacía.'

              Select @PnError IdError, @PsMensaje Error
              Set Xact_Abort Off
              Return

           End

     End

--
-- Filtro de Consulta de Conceptos de nómina.
--

   If Isnull(@PsCla_PerDed, '') = ''
      Begin
         Insert Into #tmpPerded
        (CLA_EMPRESA, CLA_PERDED, NOM_PERDED, TIPO_PERDED, MOSTRAR_SALDO,
          GRUPO_CAL1, NO_AFECTAR_NETO)
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                Case When TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(a.MOSTRAR_SALDO, 0),
                Isnull(a.GRUPO_CAL1, 0), Isnull(a.NO_AFECTAR_NETO, 0)
         From   dbo.RH_PERDED  a
         Join   #TmpEmpresa    b
         On     b.CLA_EMPRESA     = a.CLA_EMPRESA
         Where  a.NO_AFECTAR_NETO = 0
         And    a.NO_IMPRIMIR     = 0
         And    a.ES_PROVISION    = 0
         Union
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                3, Isnull(a.MOSTRAR_SALDO, 0), Isnull(a.GRUPO_CAL1, 0),
                Isnull(NO_AFECTAR_NETO, 0)
         From   dbo.RH_PERDED  a
         Join   #TmpEmpresa    b
         On     b.CLA_EMPRESA     = a.CLA_EMPRESA
         Where  a.NO_AFECTAR_NETO = 1
         And    a.NO_IMPRIMIR     = 1
         And    a.ES_PROVISION    = 1
         And    @PbImprimeProv    = 1
      End
   Else
      Begin
         Insert Into #tmpPerded
        (CLA_EMPRESA,   CLA_PERDED, NOM_PERDED, TIPO_PERDED,
         MOSTRAR_SALDO, GRUPO_CAL1, NO_AFECTAR_NETO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                Case When b.TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(b.MOSTRAR_SALDO, 0),
                Isnull(b.GRUPO_CAL1, 0), Isnull(b.NO_AFECTAR_NETO, 0)
         From   String_split(@PsCla_PerDed, ',') a
         Join   dbo.RH_PERDED                    b
         On     b.cla_perded      = a.value
         Join   #TmpEmpresa                      c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA
         Where  b.NO_AFECTAR_NETO = 0
         And    b.NO_IMPRIMIR     = 0
         And    b.ES_PROVISION    = 0
         Union
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                3, Isnull(b.MOSTRAR_SALDO, 0),
                Isnull(b.GRUPO_CAL1, 0), Isnull(b.NO_AFECTAR_NETO, 0)
         From   String_split(@PsCla_PerDed, ',') a
         Join   dbo.RH_PERDED                    b
         On     b.cla_perded      = a.value
         Join   #TmpEmpresa                      c
         On     b.CLA_EMPRESA     = c.CLA_EMPRESA
         Where  b.NO_AFECTAR_NETO = 1
         And    b.NO_IMPRIMIR     = 1
         And    b.ES_PROVISION    = 1
         And    @PbImprimeProv    = 1;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 9,
                      @PsMensaje = 'La Lista de Conceptos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

   Update #tmpPerded
   Set    NOM_PERDED = 'C' + Convert(Varchar,t1.CLA_PERDED) + '_' +  UPPER(Replace(
                      Replace(Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(Replace(Replace(
                      Replace(RTRIM(LTRIM(T1.NOM_PERDED)),')','_')
                                  ,'(','_'),'%',''),'.',''),'-',''),'/',''),'$',''),'.',''),' ','_'),char(13),''),char(10),''),char(9),''))
   From   #tmpPerded t1

--
-- Filtro de Consulta de nóminas.
--

   If Isnull(@PsNominas, '') = ''
      Begin
         Insert Into #tmpNominas
         (CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
          INICIO_PER,       FIN_PER,          ANIO,             NOM_PERIODO,
          TIPO_NOMINA,      NOM_TIPO_NOMINA,  STRING)
         Select Distinct t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,          t1.ANIO_MES,
                t1.INICIO_PER,  t1.FIN_PER,          t1.ANIO_MES / 100 ANIO, t2.NOM_PERIODO,
                t4.TIPO_NOMINA,
                t4.NOM_TIPO_NOMINA, Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
         From   dbo.RH_FECHA_PER t1
         Join   #TmpPeriodo      t2
         On     t2.CLA_EMPRESA      = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO      = t1.CLA_PERIODO
         Join   #TmpEmpresa      t3
         On     t3.CLA_EMPRESA      = t1.CLA_EMPRESA
         Join   #TmpTipoNom      t4
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA;
      End
   Else
      Begin
         Insert Into #tmpNominas
         (CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
          INICIO_PER,       FIN_PER,          ANIO,             NOM_PERIODO,
          TIPO_NOMINA,      NOM_TIPO_NOMINA,  STRING)
         Select Distinct t1.CLA_EMPRESA,     t1.CLA_PERIODO,      t1.NUM_NOMINA,          t1.ANIO_MES,
                t1.INICIO_PER,      t1.FIN_PER,          t1.ANIO_MES / 100 ANIO, t2.NOM_PERIODO,
                t4.tipo_nomina,     t4.NOM_TIPO_NOMINA,
                Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
         From   String_split(@PsNominas, ',') t0
         Join   dbo.RH_FECHA_PER              t1
         On     t1.NUM_NOMINA  = t0.value
         Join   #TmpPeriodo                   t2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO = t1.CLA_PERIODO
         Join   #TmpEmpresa                   t3
         On     t3.CLA_EMPRESA = t1.CLA_EMPRESA
         Join   #TmpTipoNom        t4
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 10,
                      @PsMensaje = 'La Lista de Nóminas Seleccionada no es es Válida'

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
         Insert Into #TmpTrabajador
        (CLA_RAZON_SOCIAL, CLA_EMPRESA,      CLA_TRAB, NOM_TRAB,
         FECHA_ING,        FECHA_ING_GRUPO,  NSS,      RFC,
         SINDICALIZADO,    CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO,
         CLA_PUESTO)
         Select Distinct a.CLA_RAZON_SOCIAL,  a.CLA_EMPRESA, a.CLA_TRAB,
                Concat(Trim(a.NOM_TRAB), ' ', Trim(a.AP_PATERNO), ' ', Trim(a.AP_MATERNO)),
                a.FECHA_ING,                  a.FECHA_ING_GRUPO, Trim(a.NUM_IMSS), Trim(a.RFC),
                          Case When Isnull(SIND, 0) = 0
               Then 'NO SINDICALIZADO'
               Else 'SINDICALIZADO'
			   End, a.CLA_UBICACION_BASE,    a.CLA_CENTRO_COSTO, a.CLA_DEPTO,
               a.CLA_PUESTO
         From   dbo.RH_TRAB        a
         Join   #TmpEmpresa        b
         On     b.CLA_EMPRESA      = a.CLA_EMPRESA
         And    b.cla_razon_social = a.CLA_RAZON_SOCIAL
         Join   #tmpUbicacion      c
         On     c.CLA_EMPRESA      = a.CLA_EMPRESA
         And    c.CLA_UBICACION    = a.CLA_UBICACION_BASE
         Join   #tmpCentroCosto    d
         On     d.CLA_EMPRESA      = a.CLA_EMPRESA
         And    d.CLA_CENTRO_COSTO = a.CLA_CENTRO_COSTO
         Join   #TmpDepto          e
         On     e.CLA_EMPRESA      = a.CLA_EMPRESA
         And    a.CLA_DEPTO        = a.CLA_DEPTO
         Join   #tmpArea           f
         On     f.Cla_Empresa      = e.Cla_Empresa
         And    f.CLA_AREA         = e.CLA_AREA
         Order  By 1, 2, 3;
      End
   Else
      Begin
         Insert Into #TmpTrabajador
        (CLA_RAZON_SOCIAL, CLA_EMPRESA,      CLA_TRAB, NOM_TRAB,
         FECHA_ING,        FECHA_ING_GRUPO,  NSS,      RFC,
         SINDICALIZADO,    CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO,
         CLA_PUESTO)
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA, b.CLA_TRAB,
                Concat(Trim(b.NOM_TRAB), ' ', Trim(b.AP_PATERNO), ' ', Trim(b.AP_MATERNO)),
                a.FECHA_ING,                 a.FECHA_ING_GRUPO, Trim(a.NUM_IMSS), Trim(a.RFC),
                          Case When Isnull(SIND, 0) = 0
               Then 'NO SINDICALIZADO'
               Else 'SINDICALIZADO'
         End SINDICALIZADO, b.CLA_UBICACION_BASE,    b.CLA_CENTRO_COSTO, b.CLA_DEPTO,
         b.CLA_PUESTO
         From   String_split(@PsCla_Trab, ',') a
         Join   dbo.RH_Trab                    b
         On     b.CLA_TRAB         = a.value
         Join   #TmpEmpresa        c
         On     c.CLA_EMPRESA      = b.CLA_EMPRESA
         And    c.cla_razon_social = b.CLA_RAZON_SOCIAL
         Join   #tmpUbicacion      d
         On     d.CLA_EMPRESA      = b.CLA_EMPRESA
         And    d.CLA_UBICACION    = b.CLA_UBICACION_BASE
         Join   #tmpCentroCosto    e
         On     e.CLA_EMPRESA      = b.CLA_EMPRESA
         And    e.CLA_CENTRO_COSTO = b.CLA_CENTRO_COSTO
         Join   #TmpDepto          f
         On     f.CLA_EMPRESA      = b.CLA_EMPRESA
         And    f.CLA_DEPTO        = b.CLA_DEPTO
         Join   #tmpArea           f
         On     f.Cla_Empresa      = e.Cla_Empresa
         And    f.CLA_AREA         = e.CLA_AREA
         Order  By 1, 2, 3;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 11,
                      @PsMensaje = 'La Lista de los Trabajadores Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta a los días por pagar.
--

   Insert Into #TmpDIAS_POR_PAGAR
  (CLA_EMPRESA, CLA_TRAB, CLA_PERIODO, NUM_NOMINA,
   ANIO_MES,    DIAS_POR_PAGAR)
   Select a.cla_empresa, a.CLA_TRAB, a.CLA_PERIODO, a.NUM_NOMINA, a.ANIO_MES,
          Sum(Case When b.tipo_perded = 1
                   Then importe
                   When b.tipo_perded = 2
                   Then -importe
                   Else 0
              End) DIAS_POR_PAGAR
   From   dbo.RH_det_REC_HISTO a
   Join   #TmpEmpresa          E
   On     E.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    E.CLA_EMPRESA      = a.CLA_EMPRESA
   Join   #TmpTrabajador       T
   On     T.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    T.CLA_EMPRESA      = a.CLA_EMPRESA
   And    T.CLA_TRAB         = a.CLA_TRAB
   Join   #tmpPerded        b
   On     b.CLA_PERDED       = a.CLA_PERDED
   And    b.CLA_EMPRESA      = a.CLA_EMPRESA
   And    b.GRUPO_CAL1       = 1
   And    b.NO_AFECTAR_NETO  = 0
   Join   #tmpNominas          c
   On     c.ANIO_MES         = a.ANIO_MES
   And    c.CLA_EMPRESA      = a.CLA_EMPRESA
   And    c.CLA_PERIODO      = a.CLA_PERIODO
   And    c.NUM_NOMINA       = a.NUM_NOMINA
   Group  By a.cla_empresa, a.CLA_TRAB, a.CLA_PERIODO, a.ANIO_MES, a.NUM_NOMINA;

--
-- Inicio de Consulta para el reporte.
--

   Insert Into #tmpNominasTrab
  (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,      NOM_EMPRESA,
   CLA_TRAB,         NOM_TRAB,         FECHA_ING,        FECHA_ING_GRUPO,
   NSS,              RFC,              CLA_PERIODO,      NUM_NOMINA,
   CLA_UBICACION,    NOM_UBICACION,    CLA_CENTRO_COSTO, NOM_CENTRO_COSTO,
   CLA_DEPTO,        NOM_DEPTO,        CLA_PUESTO,       NOM_PUESTO,
   NOM_PERIODO,      TIPO_COMPANIERO,  ANIO_MES,         INICIO_PER,
   FIN_PER,          SUE_DIA,          SUE_INT,          TOT_PER,
   TOT_DED,          TOT_NETO,         DIAS_POR_PAGAR,   NOM_TIPO_NOMINA,
   CLA_PERDED,       NOM_PERDED,       Importe)
   Select t2.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
          t2.cla_trab,         t3.NOM_TRAB,          t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
          t3.nss,              t3.RFC,               T1.CLA_PERIODO,      t1.NUM_NOMINA,
          t3.CLA_UBICACION,    t5.NOM_UBICACION,     t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
          t3.CLA_DEPTO,        t7.NOM_DEPTO,         t3.CLA_PUESTO,       t13.NOM_PUESTO,
          t1.NOM_PERIODO,      t3.SINDICALIZADO,     T2.ANIO_MES,         Convert(Varchar(10), T1.INICIO_PER,103),
          Convert(Varchar(10), T1.FIN_PER,103),      t2.SUE_DIA,          t2.SUE_INT,
          t2.TOT_PER,          t2.TOT_DED,           t2.TOT_NETO,         Isnull(t99.DIAS_POR_PAGAR, 0),
          t1.NOM_TIPO_NOMINA,  tr.CLA_PERDED,        tp.NOM_PERDED,       Sum(tr.importe)
   From   #tmpNominas          t1
   Join   dbo.RH_ENC_REC_HISTO t2
   On     t2.ANIO_MES          = t1.ANIO_MES
   And    t2.CLA_EMPRESA       = t1.CLA_EMPRESA
   And    t2.CLA_PERIODO       = t1.CLA_PERIODO
   And    t2.NUM_NOMINA        = t1.NUM_NOMINA
   Join   dbo.RH_DET_REC_HISTO TR
   On     tr.CLA_TRAB          = t2.CLA_TRAB
   And    Tr.CLA_EMPRESA       = t2.CLA_EMPRESA
   And    tr.ANIO_MES          = t2.ANIO_MES
   And    Tr.NUM_NOMINA        = t2.NUM_NOMINA
   And    Tr.CLA_PERIODO       = t2.CLA_PERIODO
   Join   #TmpRazon_Social     Trz
   On     trz.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
   And    trz.CLA_EMPRESA      = t2.CLA_RAZON_SOCIAL
   Join   #TmpEmpresa          te
   On     te.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
   And    te.CLA_EMPRESA      = t2.CLA_EMPRESA
   Join   #TmpTrabajador       t3
   On     t3.CLA_EMPRESA = t2.CLA_EMPRESA
   And    t3.CLA_TRAB    = t2.CLA_TRAB
   Join   #tmpRegImss          t4
   On     t4.CLA_EMPRESA  = t2.CLA_EMPRESA
   And    t4.CLA_REG_IMSS = t2.CLA_REG_IMSS
   Join   #tmpUbicacion        t5
   On     t5.CLA_EMPRESA   = t2.CLA_EMPRESA
   And    t5.CLA_UBICACION = t2.CLA_UBICACION_BASE
   Join   #tmpCentroCosto       t6
   On     t6.CLA_EMPRESA      = t2.CLA_EMPRESA
   And    t6.CLA_CENTRO_COSTO = t2.CLA_CENTRO_COSTO
   Join   #tmpDepto            t7
   On     t7.CLA_EMPRESA      = t2.CLA_EMPRESA
   And    t7.CLA_DEPTO        = t2.CLA_DEPTO
   Join   #tmpPerded           tp
   On     tp.Cla_Empresa      = tr.CLA_EMPRESA
   And    tp.CLA_PERDED       = tr.CLA_PERDED
   Left   Join  #tmpPuesto     t13
   On     t13.CLA_EMPRESA     = t2.CLA_EMPRESA
   And    t13.CLA_PUESTO      = t2.CLA_PUESTO
   Left   Join  #TmpDIAS_POR_PAGAR T99
   On     t99.CLA_EMPRESA     = t2.CLA_EMPRESA
   And    t99.CLA_TRAB        = t2.CLA_TRAB
   And    t99.ANIO_MES        = t2.ANIO_MES
   And    t99.CLA_PERIODO     = t2.CLA_PERIODO
   And    t99.NUM_NOMINA      = t2.NUM_NOMINA
   Group  By t2.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
             t2.cla_trab,         t3.NOM_TRAB,          t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
             t3.nss,              t3.RFC,               T1.CLA_PERIODO,      t1.NUM_NOMINA,
             t3.CLA_UBICACION,    t5.NOM_UBICACION,     t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
             t3.CLA_DEPTO,        t7.NOM_DEPTO,         t3.CLA_PUESTO,       t13.NOM_PUESTO,
             t1.NOM_PERIODO,      t3.SINDICALIZADO,     T2.ANIO_MES,         Convert(Varchar(10), T1.INICIO_PER,103),
             Convert(Varchar(10), T1.FIN_PER,103),
             t2.SUE_DIA,          t2.SUE_INT,           t2.TOT_PER,          t2.TOT_DED,
             t2.TOT_NETO,         Isnull(t99.DIAS_POR_PAGAR, 0),            t1.NOM_TIPO_NOMINA,
             tr.CLA_PERDED,       tp.NOM_PERDED;

   If @PbIncluyeNominaAbierta = 1 And
      Exists              ( Select top 1 1
                            From   #TmpEstatusNomina
                            Where  idEstatus = 1)
      Begin
         Insert Into #tmpNominasTrab
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,      NOM_EMPRESA,
         CLA_TRAB,         NOM_TRAB,         FECHA_ING,        FECHA_ING_GRUPO,
         NSS,              RFC,              CLA_PERIODO,      NUM_NOMINA,
         CLA_UBICACION,    NOM_UBICACION,    CLA_CENTRO_COSTO, NOM_CENTRO_COSTO,
         CLA_DEPTO,        NOM_DEPTO,        CLA_PUESTO,       NOM_PUESTO,
         NOM_PERIODO,      TIPO_COMPANIERO,  ANIO_MES,         INICIO_PER,
         FIN_PER,          SUE_DIA,          SUE_INT,          TOT_PER,
         TOT_DED,          TOT_NETO,         DIAS_POR_PAGAR,   NOM_TIPO_NOMINA,
         CLA_PERDED,       NOM_PERDED,       Importe)
         Select trz.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
                t2.cla_trab,         t3.NOM_TRAB,         t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
                t3.nss,              t3.RFC,              T1.CLA_PERIODO,      t1.NUM_NOMINA,
                t3.CLA_UBICACION,    t5.NOM_UBICACION,    t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
                t3.CLA_DEPTO,        t7.NOM_DEPTO,        t3.CLA_PUESTO,       t13.NOM_PUESTO,
                t1.NOM_PERIODO,      t3.SINDICALIZADO,    T2.ANIO_MES_ISPT,    Convert(Varchar(10), T1.INICIO_PER,103),
                Convert(Varchar(10), T1.FIN_PER,103),
                t2.SUE_DIA,          t2.SUE_INT,          t2.TOT_PER,          t2.TOT_DED,
                t2.TOT_NETO,         Isnull(t99.DIAS_POR_PAGAR, 0),
                t1.NOM_TIPO_NOMINA,  tr.CLA_PERDED,       tp.NOM_PERDED,       Sum(tr.importe)
         From   #tmpNominas          t1
         Join   dbo.RH_ENC_REC_ACTUAL t2
         On     t2.ANIO_MES_ISPT    = t1.ANIO_MES
         And    t2.CLA_EMPRESA      = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO      = t1.CLA_PERIODO
         And    t2.NUM_NOMINA       = t1.NUM_NOMINA
         Join   dbo.RH_DET_REC_ACTUAL Tr
         On     tr.CLA_TRAB          = t2.CLA_TRAB
         And    Tr.CLA_EMPRESA       = t2.CLA_EMPRESA
         And    Tr.NUM_NOMINA        = t2.NUM_NOMINA
         And    Tr.CLA_PERIODO       = t2.CLA_PERIODO
		 And    Tr.FOLIO_NOM         = t2.FOLIO_NOM
         Join   #TmpEmpresa          te
         On     te.CLA_EMPRESA       = t2.CLA_EMPRESA
         Join   #TmpRazon_Social     Trz
         On     trz.CLA_RAZON_SOCIAL = te.CLA_RAZON_SOCIAL
         And    trz.CLA_EMPRESA      = te.CLA_RAZON_SOCIAL
         Join   #TmpTrabajador       t3
         On     t3.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t3.CLA_TRAB         = t2.CLA_TRAB
         Join   #tmpRegImss          t4
         On     t4.CLA_EMPRESA  = t2.CLA_EMPRESA
         And    t4.CLA_REG_IMSS = t2.CLA_REG_IMSS
         Join   #tmpUbicacion        t5
         On     t5.CLA_EMPRESA   = t2.CLA_EMPRESA
         And    t5.CLA_UBICACION = t2.CLA_UBICACION_BASE
         Join   #tmpCentroCosto               t6
         On     t6.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t6.CLA_CENTRO_COSTO = t2.CLA_CENTRO_COSTO
         Join   #tmpDepto            t7
         On     t7.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t7.CLA_DEPTO        = t2.CLA_DEPTO
         Join   #tmpPerded           tp
         On     tp.Cla_Empresa      = tr.CLA_EMPRESA
         And    tp.CLA_PERDED       = tr.CLA_PERDED
         Left   Join  #tmpPuesto     t13
         On     t13.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t13.CLA_PUESTO  = t2.CLA_PUESTO
         Left   Join  #TmpDIAS_POR_PAGAR T99
         On     t99.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t99.CLA_TRAB    = t2.CLA_TRAB
         And    t99.ANIO_MES    = t2.ANIO_MES_ISPT
         And    t99.CLA_PERIODO = t2.CLA_PERIODO
         And    t99.NUM_NOMINA  = t2.NUM_NOMINA
         Group  By trz.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
                t2.cla_trab,         t3.NOM_TRAB,         t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
                t3.nss,              t3.RFC,              T1.CLA_PERIODO,      t1.NUM_NOMINA,
                t3.CLA_UBICACION,    t5.NOM_UBICACION,    t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
                t3.CLA_DEPTO,        t7.NOM_DEPTO,        t3.CLA_PUESTO,       t13.NOM_PUESTO,
                t1.NOM_PERIODO,      t3.SINDICALIZADO,    T2.ANIO_MES_ISPT,    Convert(Varchar(10), T1.INICIO_PER,103),
                Convert(Varchar(10), T1.FIN_PER,103),
                t2.SUE_DIA,          t2.SUE_INT,          t2.TOT_PER,          t2.TOT_DED,
                t2.TOT_NETO,         Isnull(t99.DIAS_POR_PAGAR, 0),
                t1.NOM_TIPO_NOMINA,  tr.CLA_PERDED,       tp.NOM_PERDED;


      End;

   Declare
      C_tipoNom  Cursor For
      Select  Distinct NOM_TIPO_NOMINA
      From    #tmpNominasTrab;
   Begin
      Open  C_tipoNom
      While @@Fetch_status < 1
      Begin
         Fetch C_tipoNom Into @w_nom_tipo_nomina
         If @@Fetch_status != 0
            Begin
               Break
            End

        If @w_secuencia = 0
           Begin
              Select @w_nominas   = Concat('NOMINAS: ', @w_nomina),
                     @w_secuencia = 1;
           End
        Else
           Begin
              Set @w_nominas = @w_nominas + ', ' + @w_nomina
           End

     End
     Close      C_tipoNom
     Deallocate C_tipoNom
   End

--
-- Adición de Columnas de Conceptos de nómina a la tabla de Salida.
--

   Declare
      C_Conceptos Cursor For
      Select a.NOM_PERDED
      From   #tmpNominasTrab a
      Join   #tmpPerded      b
      On     b.Cla_Empresa  = a.Cla_Empresa
      And    b.CLA_PERDED   = a.CLA_PERDED
      Where  a.IMPORTE     != 0
      Group  By a.NOM_PERDED, b.TIPO_PERDED, a.CLA_PERDED
      Order  By b.TIPO_PERDED, a.CLA_PERDED;

   Begin
      Open  C_Conceptos
      While @@Fetch_status < 1
      Begin
         Fetch C_Conceptos Into @w_nom_perded;
         If @@Fetch_status != 0
            Begin
               Break
            End

         Set @w_sql = Concat('Alter Table #tmpResultado Add ', Substring(@w_nom_perded, 1, 30),
                                  ' Decimal (18, 2) Null Default 0')
         Execute(@w_sql)

      End
      Close      C_Conceptos
      Deallocate C_Conceptos
   End

   Declare
      C_Importes Cursor For
      Select CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,      NOM_EMPRESA,
             CLA_TRAB,         NOM_TRAB,         FECHA_ING,        FECHA_ING_GRUPO,
             NSS,              RFC,              CLA_UBICACION,    NOM_UBICACION,
             CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,        NOM_DEPTO,
             CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,  Max(SUE_DIA),
             Max(SUE_INT),     Max(TOT_PER),     Max(TOT_DED),     Max(TOT_NETO),
             Max(DIAS_POR_PAGAR)
      From  #tmpNominasTrab
      Group By CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,      NOM_EMPRESA,
               CLA_TRAB,         NOM_TRAB,         FECHA_ING,        FECHA_ING_GRUPO,
               NSS,              RFC,              CLA_UBICACION,    NOM_UBICACION,
               CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,        NOM_DEPTO,
               CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO
      Order By CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO,
               CLA_DEPTO,        CLA_TRAB;
   Begin
      Open  C_Importes
      While @@Fetch_status < 1
      Begin
         Fetch C_Importes  Into @w_CLA_RAZON_SOCIAL, @w_NOM_RAZON_SOCIAL, @w_CLA_EMPRESA,      @w_NOM_EMPRESA,
                                @w_CLA_TRAB,         @w_NOM_TRAB,         @w_FECHA_ING,        @w_FECHA_ING_GRUPO,
                                @w_NSS,              @w_RFC,              @w_CLA_UBICACION,    @w_NOM_UBICACION,
                                @w_CLA_CENTRO_COSTO, @w_NOM_CENTRO_COSTO, @w_CLA_DEPTO,        @w_NOM_DEPTO,
                                @w_CLA_PUESTO,       @w_NOM_PUESTO,       @w_TIPO_COMPANIERO,  @w_SUE_DIA,
                                @w_SUE_INT,          @w_TOT_PER,          @w_TOT_DED,          @w_TOT_NETO,
                                @w_DIAS_POR_PAGAR;
         If @@Fetch_status != 0
            Begin
               Break
            End

         If @w_inicio = 1
            Begin
               Set @w_inicio = 0

               Select @w_cla_razon_social_ante   = @w_cla_razon_social,
                      @w_nom_razon_social_ante   = @w_nom_razon_social,
                      @w_cla_empresa_ante        = @w_cla_empresa,
                      @w_nom_empresa_ante        = @w_nom_empresa,
                      @w_cla_ubicacion_ante      = @w_cla_ubicacion,
                      @w_nom_ubicacion_ante      = @w_nom_ubicacion,
                      @w_cla_centro_costo_ante   = @w_cla_centro_costo,
                      @w_nom_centro_costo_ante   = @w_nom_centro_costo,
                      @w_cla_depto_ante          = @w_cla_depto,
                      @w_nom_depto_ante          = @w_nom_depto,
                      @w_cla_trab_ante           = @w_cla_trab,
                      @w_nom_trab_ante           = @w_nom_trab,
                      @w_fecha_ing_ante          = @w_fecha_ing,
                      @w_fecha_ing_grupo_ante    = @w_fecha_ing_grupo,
                      @w_nss_ante                = @w_nss,
                      @w_rfc_ante                = @w_rfc,
                      @w_tipo_companiero_ante    = @w_tipo_companiero,
                      @w_sue_dia_ante            = @w_sue_dia,
                      @w_sue_int_ante            = @w_sue_int,
                      @w_tot_per_ante            = @w_tot_per,
                      @w_tot_ded_ante            = @w_tot_ded,
                      @w_tot_neto_ante           = @w_tot_neto,
                      @w_dias_por_pagar_ante     = @w_dias_por_pagar;
             End;

--
-- Total Departamento.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_depto_ante          != @w_cla_depto
            Begin
               Insert Into  #tmpResultado
              (tipo,            CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,
               NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_ING,
               FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,
               NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
               NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,
               SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED,
               TOT_NETO,        DIAS_POR_PAGAR)
               Select  'L1',           @w_cla_razon_social_ante,     Char(32),  @w_cla_empresa_ante,
                       Char(32),       @w_cla_trab_ante,             Char(32),  Char(32),
                       Char(32),       Char(32),                     Char(32),  @w_cla_ubicacion_ante,
                       Char(32),       Char(32),                     Char(32),  @w_cla_depto_ante,
                       'Total Departamento.: ' + @w_nom_depto_ante,  Char(32),  Char(32),  Char(32),
                       Char(32),                                     Char(32),  Char(32),  Char(32),
                       Char(32),                                     Char(32);
            End;

--
-- Total Centro de Costo.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo
            Begin
               Insert Into  #tmpResultado
              (tipo,            CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,
               NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_ING,
               FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,
               NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
               NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,
               SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED,
               TOT_NETO,        DIAS_POR_PAGAR)
               Select  'L2',           @w_cla_razon_social_ante, Char(32),  @w_cla_empresa_ante,
                       Char(32),       @w_cla_trab_ante,         Char(32),  Char(32),
                       Char(32),       Char(32),                 Char(32),  @w_cla_ubicacion_ante,
                       Char(32),       Char(32),                 'Total Centro de Costo.: ' + @w_nom_centro_costo_ante,  @w_cla_depto_ante,
                       Char(32),       Char(32),                 Char(32),  Char(32),
                       Char(32),       Char(32),                 Char(32),  Char(32),
                       Char(32),       Char(32);

            End;

--
-- Total Ubicacion.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante   != @w_cla_ubicacion
            Begin
               Insert Into  #tmpResultado
              (tipo,            CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,
               NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_ING,
               FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,
               NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
               NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,
               SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED,
               TOT_NETO,        DIAS_POR_PAGAR)
               Select  'L3',           @w_cla_razon_social_ante, Char(32),  @w_cla_empresa_ante,
                       Char(32),       @w_cla_trab_ante,         Char(32),  Char(32),
                       Char(32),       Char(32),                 Char(32),  @w_cla_ubicacion_ante,
                       'Total Ubicacion..: ' + @w_nom_ubicacion, Char(32),  Char(32),                 @w_cla_depto_ante,
                       Char(32),       CHAR(32),       Char(32),  Char(32),
                       Char(32),       Char(32),                 Char(32),  Char(32),
                       Char(32),       Char(32);

            End;

--
-- Total por Trabajador.
--

         Insert Into  #tmpResultado
        (tipo,            CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,
         NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_ING,
         FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,
         NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
         NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,
         SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED,
         TOT_NETO,        DIAS_POR_PAGAR)
         Select  'L0',               @w_cla_razon_social, @w_nom_razon_social, @w_cla_empresa,
                 @w_nom_empresa,     @w_cla_trab,         @w_nom_trab,         @w_fecha_ing,
                 @w_fecha_ing_grupo, @w_nss,              @w_rfc,              @w_cla_ubicacion,
                 @w_nom_ubicacion,   @w_cla_centro_costo, @w_nom_centro_costo, @w_cla_depto,
                 @w_nom_depto,       @w_cla_puesto,       @w_nom_puesto,       @w_tipo_companiero,
                 Format(@w_sue_dia,  '##,###,###,##0.00'), Format(@w_sue_int,        '##,###,###,##0.00'),
                 Format(@w_tot_per,  '##,###,###,##0.00'), Format(@w_tot_ded,        '##,###,###,##0.00'),
                 Format(@w_tot_neto, '##,###,###,##0.00'), Format(@w_dias_por_pagar, '##,###,###,##0.00');

         Select @w_cla_razon_social_ante   = @w_cla_razon_social,
                @w_nom_razon_social_ante   = @w_nom_razon_social,
                @w_cla_empresa_ante        = @w_cla_empresa,
                @w_nom_empresa_ante        = @w_nom_empresa,
                @w_cla_ubicacion_ante      = @w_cla_ubicacion,
                @w_nom_ubicacion_ante      = @w_nom_ubicacion,
                @w_cla_centro_costo_ante   = @w_cla_centro_costo,
                @w_nom_centro_costo_ante   = @w_nom_centro_costo,
                @w_cla_depto_ante          = @w_cla_depto,
                @w_nom_depto_ante          = @w_nom_depto,
                @w_cla_trab_ante           = @w_cla_trab,
                @w_nom_trab_ante           = @w_nom_trab,
                @w_fecha_ing_ante          = @w_fecha_ing,
                @w_fecha_ing_grupo_ante    = @w_fecha_ing_grupo,
                @w_nss_ante                = @w_nss,
                @w_rfc_ante                = @w_rfc,
                @w_tipo_companiero_ante    = @w_tipo_companiero,
                @w_sue_dia_ante            = @w_sue_dia,
                @w_sue_int_ante            = @w_sue_int,
                @w_tot_per_ante            = @w_tot_per,
                @w_tot_ded_ante            = @w_tot_ded,
                @w_tot_neto_ante           = @w_tot_neto,
                @w_dias_por_pagar_ante     = @w_dias_por_pagar;

      End
      Close       C_Importes
      Deallocate  C_Importes
   End

--
-- Total Departamento.
--

   Insert Into  #tmpResultado
  (tipo,            CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,
   NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_ING,
   FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,
   NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
   NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,
   SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED,
   TOT_NETO,        DIAS_POR_PAGAR)
   Select  'L1',           @w_cla_razon_social,  Char(32),  @w_cla_empresa,
           Char(32),       @w_cla_trab,          Char(32),  Char(32),
           Char(32),       Char(32),             Char(32),  @w_cla_ubicacion,
           Char(32),       Char(32),             Char(32),  @w_cla_depto,
           'Total Departamento ' + @w_nom_depto, Char(32),  Char(32), Char(32),
           Char(32),       Char(32),             Char(32),  Char(32),
           Char(32),       Char(32);


--
-- Total Centro de Costo.
--

   Insert Into  #tmpResultado
  (tipo,            CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,
   NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_ING,
   FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,
   NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
   NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,
   SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED,
   TOT_NETO,        DIAS_POR_PAGAR)
   Select  'L2',           @w_cla_razon_social_ante, Char(32),  @w_cla_empresa_ante,
           Char(32),       @w_cla_trab_ante,         Char(32),  Char(32),
           Char(32),       Char(32),                 Char(32),  @w_cla_ubicacion_ante,
           Char(32),       Char(32),                 'Total Centro de Costo.: ' + @w_nom_centro_costo_ante,  @w_cla_depto_ante,
           Char(32),       Char(32),                 Char(32),  Char(32),
           Char(32),       Char(32),                 Char(32),  Char(32),
           Char(32),       Char(32);

--
-- Total Ubicacion.
--

   Insert Into  #tmpResultado
  (tipo,            CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,
   NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_ING,
   FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,
   NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
   NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO,
   SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED,
   TOT_NETO,        DIAS_POR_PAGAR)
   Select  'L3',           @w_cla_razon_social_ante, Char(32),  @w_cla_empresa_ante,
           Char(32),       @w_cla_trab_ante,         Char(32),  Char(32),
           Char(32),       Char(32),                 Char(32),  @w_cla_ubicacion_ante,
           'Total Ubicacion..: ' + @w_nom_ubicacion, Char(32),  Char(32),                 @w_cla_depto_ante,
           Char(32),       CHAR(32),       Char(32),  Char(32),
           Char(32),       Char(32),                 Char(32),  Char(32),
           Char(32),       Char(32);

   Declare
      C_ImporteTrab Cursor For
      Select CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO,
             CLA_DEPTO,        CLA_TRAB,    CLA_PERDED,    Substring(NOM_PERDED, 1, 30),
             Sum(Importe)
      From   #tmpNominasTrab
      Where  importe != 0
      Group  By CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO,
                CLA_DEPTO,        CLA_TRAB,    CLA_PERDED,    Substring(NOM_PERDED, 1, 30)
      Order  By CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO,
                CLA_DEPTO,        CLA_TRAB,    CLA_PERDED;
   Begin
      Open  C_ImporteTrab
      While @@Fetch_status < 1
      Begin
         Fetch C_ImporteTrab Into @w_CLA_RAZON_SOCIAL, @w_CLA_EMPRESA, @w_CLA_UBICACION, @w_CLA_CENTRO_COSTO,
                                  @w_CLA_DEPTO,        @w_CLA_TRAB,    @w_CLA_PERDED,    @w_NOM_PERDED,
                                  @w_Importe;
         If @@Fetch_status != 0
            Begin
               Break
            End

         If Isnull(@w_importe, 0) = 0
            Begin
               Goto Siguiente
            End

         Set @w_sql = Concat('Update #tmpResultado ',
                             'Set   ', @w_NOM_PERDED, ' = ', @w_Importe,       ' ',
                             'From   #tmpResultado With(Index (tmpResultadoIdx01)) ', 
                             'Where CLA_RAZON_SOCIAL = ', @w_CLA_RAZON_SOCIAL, ' ',
                             'And   CLA_EMPRESA      = ', @w_cla_empresa,      ' ',
                             'And   CLA_UBICACION    = ', @w_cla_ubicacion,    ' ',
                             'And   CLA_CENTRO_COSTO = ', @w_cla_centro_costo, ' ',
                             'And   CLA_DEPTO        = ', @w_cla_depto,        ' ',
                             'And   CLA_TRAB         = ', @w_cla_trab,         ' ',
                             'And   tipo             = ', @w_comilla, 'L0', @w_comilla);
         Execute(@w_sql);

Siguiente:

      End
      Close      C_ImporteTrab
      Deallocate C_ImporteTrab
   End

   Select *
   from  #tmpResultado
   Order By Secuencia;

   Set Xact_Abort Off
   Return

End
Go
