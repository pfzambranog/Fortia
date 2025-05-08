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
   @w_nom_perded              Varchar( 40),
   @w_cla_perded              Varchar( 20),
   @w_cla_puesto              Varchar( 10),
   @w_NOM_PUESTO              Varchar( 80),
   @w_NSS                     Varchar( 20),
   @w_nss_ante                Varchar( 20),
   @w_RFC                     Varchar( 20),
   @w_rfc_ante                Varchar( 20),
   @w_NOM_PERIODO             Varchar(150),
   @w_tipo_companiero         Varchar( 50),
   @w_tipo_companiero_ante    Varchar( 50),
   @w_inicio_per              Varchar( 10),
   @w_fin_per                 Varchar( 10),
   @w_nominas                 Varchar(Max),
   @w_sql                     Varchar(Max),
   @w_columnas                Varchar(Max),
   @w_colsuma                 Varchar(Max),
   @w_executeInsert           Varchar(Max),
   @w_insert                  Varchar(Max),
   @w_inicial                 Varchar(Max),
   @w_select                  Varchar(Max),
   @w_suma_Percepciones       Varchar(Max),
   @w_suma_Deducciones        Varchar(Max),
   @w_suma_Provisiones        Varchar(Max),
   @w_nom_tipo_nomina         Varchar(Max),
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
   @w_Error                   Integer,
   @w_secuencia               Integer,
   @w_registros               Integer,
   @w_MesIni                  Integer,
   @w_MesFin                  Integer,
   @w_AnioMesIni              Integer,
   @w_AnioMesFin              Integer,
   @w_reg                     Integer,
   @w_secFin                  Integer,
   @w_anio_mes                Integer,
   @w_regRZ                   Integer,
   @w_regEmpr                 Integer,
   @w_regUbic                 Integer,
   @w_regCCO                  Integer,
   @w_regDpto                 Integer,
   @w_CLA_PERIODO             Integer,
   @w_NUM_NOMINA              Integer,
   @w_idTabla                 Integer,
   @w_tipo_perded             Integer,
   @w_tipo_perdedAnte         Integer,
   @w_horaProceso             Char(20),
   @w_comilla                 Char( 1),
   @w_inicio                  Bit,
   @w_FECHA_ING               Date,
   @w_fecha_ing_ante          Date,
   @w_FECHA_ING_GRUPO         Date,
   @w_fecha_ing_grupo_ante    Date,
   @w_fechaHoy                Date,
   @w_importe                 Decimal(18, 2),
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
   @w_columna                 Sysname,
   @w_idSession               Nvarchar(Max);

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off
   Set Ansi_Warnings On

   Select @PnError           = 0,
          @w_registros       = 0,
          @w_secuencia       = 0,
          @w_inicio          = 1,
          @w_tipo_perdedAnte = 0,
          @w_nominas         = '',
          @w_columnas        = '',
          @w_colsuma         = '',
          @w_executeInsert   = '',
          @w_idSession       = Cast(Newid() As nvarchar(Max)),
          @w_comilla         = Char(39),
          @w_fechaHoy        = Getdate(),
          @PsMensaje         = 'Proceso Terminado Ok',
          @w_tituloRep       = 'NOMINA POR UBICACION, C.COSTO Y DEPARTAMENTO',
          @w_fechaProc       = Convert(Char(10), Getdate(), 103),
          @w_horaProceso     = Format(Getdate(), 'hh:mm:ss tt'),
          @w_MesIni          = Case When Isnull(@PnMesIni, 0) = 0
                                   Then 1
                                   Else @PnMesIni
                               End,
          @w_mesFin          = Case When Isnull(@PnMesFin, 0) = 0
                                    Then 12
                                    Else @PnMesFin
                               End,
          @w_AnioMesIni      = Case When Isnull(@PnMesIni, 0) = 0
                                    Then (@PnAnio * 100) + @w_MesIni
                                    Else (@PnAnio * 100) + @PnMesIni
                               End,
         @w_AnioMesFin       = Case When Isnull(@PnMesFin, 0) = 0
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
   NOM_PERDED        Varchar( 40) Not Null,
   TIPO_PERDED       Integer      Not Null,
   MOSTRAR_SALDO     Integer      Not Null Default 0,
   GRUPO_CAL1        Integer      Not Null Default 1,
   NO_AFECTAR_NETO   Integer      Not Null Default 0,
   ESBASE_ISPT       Integer      Not Null Default 0,
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
   CLA_PERIODO        Integer           Null,
   FECHA_ING          Date              Null,
   FECHA_ING_GRUPO    Date              Null,
   FECHA_NACIMIENTO   Date              Null,
   EDAD               Integer           Null Default 0,
   NSS                Varchar( 20)      Null,
   RFC                Varchar( 20)      Null,
   SINDICALIZADO      Varchar( 30)      Null,
   Constraint TmpTrabajadorPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB));

--
-- Tabla temporal de concepto de nómina de días a pagar.
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
  (Secuencia         Integer         Not Null Identity(1, 1) Primary Key,
   CLA_RAZON_SOCIAL  Integer         Not Null,
   NOM_RAZON_SOCIAL  Varchar(300)    Not Null,
   CLA_EMPRESA       Integer         Not Null,
   NOM_EMPRESA       Varchar(100)    Not Null,
   CLA_TRAB          Integer             Null,
   NOM_TRAB          Varchar(150)        Null,
   FECHA_NACIMIENTO  Date                Null,
   EDAD              Integer             Null Default 0,
   FECHA_ING         Varchar( 10)        Null,
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
   NOM_PERDED        Varchar( 40)     Not Null Default Char(32),
   NOM_TIPO_NOMINA   Varchar(100)     Not Null Default Char(32),
   IMPORTE           Decimal(18, 2)   Not Null Default 0,
   Index tmpNominasTrabIdx01 (CLA_EMPRESA, CLA_PERIODO, CLA_TRAB, ANIO_MES,
                              NUM_NOMINA,  CLA_PERDED));

--
-- Tabla de Resultado.
--

   Create Table #tmpResultado
  (secuencia         Integer         Not Null Identity (1, 1) Primary Key,
   tipo              Char(2)         Not Null Default 'L0',
   CLA_RAZON_SOCIAL  Integer         Not Null,
   NOM_RAZON_SOCIAL  Varchar(300)    Not Null Default Char(32),
   CLA_EMPRESA       Integer         Not Null,
   NOM_EMPRESA       Varchar(100)    Not Null Default Char(32),
   CLA_TRAB          Integer             Null,
   NOM_TRAB          Varchar(150)        Null Default Char(32),
   FECHA_ING         Varchar( 10)        Null Default Char(32),
   FECHA_ING_GRUPO   Varchar( 10)        Null Default Char(32),
   NSS               Varchar( 20)        Null Default Char(32),
   RFC               Varchar( 20)        Null Default Char(32),
   FECHA_NACIMIENTO  Varchar( 10)        Null Default Char(32),
   EDAD              Varchar( 10)        Null Default Char(32),
   CLA_UBICACION     Integer             Null,
   NOM_UBICACION     Varchar(150)        Null Default Char(32),
   CLA_DEPTO         Varchar(150)        Null,
   NOM_DEPTO         Varchar(150)        Null Default Char(32),
   CLA_PUESTO        Varchar( 10)        Null Default Char(32),
   NOM_PUESTO        Varchar(150)        Null Default Char(32),
   CLA_CENTRO_COSTO  Integer             Null,
   NOM_CENTRO_COSTO  Varchar(150)        Null Default Char(32),
   CLA_PERIODO       Integer             Null,
   NOM_PERIODO       Varchar(150)        Null Default char(32),
   TIPO_COMPANIERO   Varchar(150)        Null Default Char(32),
   SUE_DIA           Varchar( 30)        Null Default Char(32),
   SUE_INT           Varchar( 30)        Null Default Char(32),
   TOT_PER           Varchar( 30)        Null Default Char(32),
   TOT_DED           Varchar( 30)        Null Default Char(32),
   TOT_NETO          Varchar( 30)        Null Default Char(32),
   DIAS_POR_PAGAR    Varchar( 30)        Null Default Char(32),
   Index tmpResultadoIdx01 (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO,
                            CLA_DEPTO,        CLA_TRAB,    Tipo));

   Set @w_idTabla = OBJECT_ID('tempdb.dbo.#tmpResultado')

--
-- Tabla de Excepciones de columnas en la presentación de la columna.
--

   Create Table #TempCamposExcepcion
  (Columna    Sysname Not Null Primary Key);

--
-- Tabla de Presentación del Reporte.
--

   Create Table #tmpReporte
  (secuencia         Integer          Not Null Identity (1, 1) Primary Key,
   idSession         NVarchar(Max)    Not Null,
   Columna001        Varchar(500)         Null Default Char(32),
   Columna002        Varchar(500)         Null Default Char(32),
   Columna003        Varchar(500)         Null Default Char(32),
   Columna004        Varchar(500)         Null Default Char(32),
   Columna005        Varchar(500)         Null Default Char(32),
   Columna006        Varchar(500)         Null Default Char(32),
   Columna007        Varchar(500)         Null Default Char(32),
   Columna008        Varchar(500)         Null Default Char(32),
   Columna009        Varchar(500)         Null Default Char(32),
   Columna010        Varchar(500)         Null Default Char(32),
   Columna011        Varchar(500)         Null Default Char(32),
   Columna012        Varchar(500)         Null Default Char(32),
   Columna013        Varchar(500)         Null Default Char(32),
   Columna014        Varchar(500)         Null Default Char(32),
   Columna015        Varchar(500)         Null Default Char(32),
   Columna016        Varchar(500)         Null Default Char(32),
   Columna017        Varchar(500)         Null Default Char(32),
   Columna018        Varchar(500)         Null Default Char(32),
   Columna019        Varchar(500)         Null Default Char(32),
   Columna020        Varchar(500)         Null Default Char(32),
   Columna021        Varchar(500)         Null Default Char(32),
   Columna022        Varchar(500)         Null Default Char(32),
   Columna023        Varchar(500)         Null Default Char(32),
   Columna024        Varchar(500)         Null Default Char(32),
   Columna025        Varchar(500)         Null Default Char(32),
   Columna026        Varchar(500)         Null Default Char(32),
   Columna027        Varchar(500)         Null Default Char(32),
   Columna028        Varchar(500)         Null Default Char(32),
   Columna029        Varchar(500)         Null Default Char(32),
   Columna030        Varchar(500)         Null Default Char(32),
   Columna031        Varchar(500)         Null Default Char(32),
   Columna032        Varchar(500)         Null Default Char(32),
   Columna033        Varchar(500)         Null Default Char(32),
   Columna034        Varchar(500)         Null Default Char(32),
   Columna035        Varchar(500)         Null Default Char(32),
   Columna036        Varchar(500)         Null Default Char(32),
   Columna037        Varchar(500)         Null Default Char(32),
   Columna038        Varchar(500)         Null Default Char(32),
   Columna039        Varchar(500)         Null Default Char(32),
   Columna040        Varchar(500)         Null Default Char(32),
   Columna041        Varchar(500)         Null Default Char(32),
   Columna042        Varchar(500)         Null Default Char(32),
   Columna043        Varchar(500)         Null Default Char(32),
   Columna044        Varchar(500)         Null Default Char(32),
   Columna045        Varchar(500)         Null Default Char(32),
   Columna046        Varchar(500)         Null Default Char(32),
   Columna047        Varchar(500)         Null Default Char(32),
   Columna048        Varchar(500)         Null Default Char(32),
   Columna049        Varchar(500)         Null Default Char(32),
   Columna050        Varchar(500)         Null Default Char(32),
   Columna051        Varchar(500)         Null Default Char(32),
   Columna052        Varchar(500)         Null Default Char(32),
   Columna053        Varchar(500)         Null Default Char(32),
   Columna054        Varchar(500)         Null Default Char(32),
   Columna055        Varchar(500)         Null Default Char(32),
   Columna056        Varchar(500)         Null Default Char(32),
   Columna057        Varchar(500)         Null Default Char(32),
   Columna058        Varchar(500)         Null Default Char(32),
   Columna059        Varchar(500)         Null Default Char(32),
   Columna060        Varchar(500)         Null Default Char(32),
   Columna061        Varchar(500)         Null Default Char(32),
   Columna062        Varchar(500)         Null Default Char(32),
   Columna063        Varchar(500)         Null Default Char(32),
   Columna064        Varchar(500)         Null Default Char(32),
   Columna065        Varchar(500)         Null Default Char(32),
   Columna066        Varchar(500)         Null Default Char(32),
   Columna067        Varchar(500)         Null Default Char(32),
   Columna068        Varchar(500)         Null Default Char(32),
   Columna069        Varchar(500)         Null Default Char(32),
   Columna070        Varchar(500)         Null Default Char(32),
   Columna071        Varchar(500)         Null Default Char(32),
   Columna072        Varchar(500)         Null Default Char(32),
   Columna073        Varchar(500)         Null Default Char(32),
   Columna074        Varchar(500)         Null Default Char(32),
   Columna075        Varchar(500)         Null Default Char(32),
   Columna076        Varchar(500)         Null Default Char(32),
   Columna077        Varchar(500)         Null Default Char(32),
   Columna078        Varchar(500)         Null Default Char(32),
   Columna079        Varchar(500)         Null Default Char(32),
   Columna080        Varchar(500)         Null Default Char(32),
   Columna081        Varchar(500)         Null Default Char(32),
   Columna082        Varchar(500)         Null Default Char(32),
   Columna083        Varchar(500)         Null Default Char(32),
   Columna084        Varchar(500)         Null Default Char(32),
   Columna085        Varchar(500)         Null Default Char(32),
   Columna086        Varchar(500)         Null Default Char(32),
   Columna087        Varchar(500)         Null Default Char(32),
   Columna088        Varchar(500)         Null Default Char(32),
   Columna089        Varchar(500)         Null Default Char(32),
   Columna090        Varchar(500)         Null Default Char(32),
   Columna091        Varchar(500)         Null Default Char(32),
   Columna092        Varchar(500)         Null Default Char(32),
   Columna093        Varchar(500)         Null Default Char(32),
   Columna094        Varchar(500)         Null Default Char(32),
   Columna095        Varchar(500)         Null Default Char(32),
   Columna096        Varchar(500)         Null Default Char(32),
   Columna097        Varchar(500)         Null Default Char(32),
   Columna098        Varchar(500)         Null Default Char(32),
   Columna099        Varchar(500)         Null Default Char(32),
   Columna100        Varchar(500)         Null Default Char(32),
   Columna101        Varchar(500)         Null Default Char(32),
   Columna102        Varchar(500)         Null Default Char(32),
   Columna103        Varchar(500)         Null Default Char(32),
   Columna104        Varchar(500)         Null Default Char(32),
   Columna105        Varchar(500)         Null Default Char(32),
   Columna106        Varchar(500)         Null Default Char(32),
   Columna107        Varchar(500)         Null Default Char(32),
   Columna108        Varchar(500)         Null Default Char(32),
   Columna109        Varchar(500)         Null Default Char(32),
   Columna110        Varchar(500)         Null Default Char(32),
   Columna111        Varchar(500)         Null Default Char(32),
   Columna112        Varchar(500)         Null Default Char(32),
   Columna113        Varchar(500)         Null Default Char(32),
   Columna114        Varchar(500)         Null Default Char(32),
   Columna115        Varchar(500)         Null Default Char(32),
   Columna116        Varchar(500)         Null Default Char(32),
   Columna117        Varchar(500)         Null Default Char(32),
   Columna118        Varchar(500)         Null Default Char(32),
   Columna119        Varchar(500)         Null Default Char(32),
   Columna120        Varchar(500)         Null Default Char(32),
   Columna121        Varchar(500)         Null Default Char(32),
   Columna122        Varchar(500)         Null Default Char(32),
   Columna123        Varchar(500)         Null Default Char(32),
   Columna124        Varchar(500)         Null Default Char(32),
   Columna125        Varchar(500)         Null Default Char(32),
   Columna126        Varchar(500)         Null Default Char(32),
   Columna127        Varchar(500)         Null Default Char(32),
   Columna128        Varchar(500)         Null Default Char(32),
   Columna129        Varchar(500)         Null Default Char(32),
   Columna130        Varchar(500)         Null Default Char(32),
   Columna131        Varchar(500)         Null Default Char(32),
   Columna132        Varchar(500)         Null Default Char(32),
   Columna133        Varchar(500)         Null Default Char(32),
   Columna134        Varchar(500)         Null Default Char(32),
   Columna135        Varchar(500)         Null Default Char(32),
   Columna136        Varchar(500)         Null Default Char(32),
   Columna137        Varchar(500)         Null Default Char(32),
   Columna138        Varchar(500)         Null Default Char(32),
   Columna139        Varchar(500)         Null Default Char(32),
   Columna140        Varchar(500)         Null Default Char(32),
   Columna141        Varchar(500)         Null Default Char(32),
   Columna142        Varchar(500)         Null Default Char(32),
   Columna143        Varchar(500)         Null Default Char(32),
   Columna144        Varchar(500)         Null Default Char(32),
   Columna145        Varchar(500)         Null Default Char(32),
   Columna146        Varchar(500)         Null Default Char(32),
   Columna147        Varchar(500)         Null Default Char(32),
   Columna148        Varchar(500)         Null Default Char(32),
   Columna149        Varchar(500)         Null Default Char(32),
   Columna150        Varchar(500)         Null Default Char(32));

--
-- Inicio de Proceso.
--

   Insert Into #TempCamposExcepcion
  (Columna)
   Select 'cla_razon_social'
   Union
   Select 'nom_razon_social'
   Union
   Select 'CLA_EMPRESA'
   Union
   Select 'NOM_EMPRESA'
   Union
   Select 'CLA_DEPTO'
   Union
   Select 'CLA_CENTRO_COSTO'
   Union
   Select 'CLA_UBICACION'
   Union
   Select 'secuencia'
   Union
   Select 'tipo'
   Union
   Select 'CLA_PUESTO'
   Union
   Select 'CLA_PERIODO'
   Union
   Select 'totalPercepciones'
   Union
   Select 'totalDeducciones'
   Union
   Select 'TOTALPROVISIONES';

--
-- Filtro de Consulta de Razon Social.
--

   If Isnull(@PsRazon_Social, '') = ''
      Begin
         Insert Into #TmpRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select CLA_RAZON_SOCIAL, Concat(nom_razon_social, ' - ', rfc_emp), CLA_EMPRESA
         From   dbo.rh_razon_social;
         Set    @w_regRZ = @@Rowcount
      End
   Else
      Begin
         Insert Into #TmpRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select Distinct b.CLA_RAZON_SOCIAL, Concat(b.nom_razon_social, ' - ', rfc_emp), b.CLA_EMPRESA
         From   String_split(@PsRazon_Social, ',') a
         Join   dbo.rh_razon_social                b
         On     b.CLA_RAZON_SOCIAL= a.value;
         Set    @w_regRZ = @@Rowcount
         If @w_regRZ = 0
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
         Set @w_regEmpr = @@Rowcount
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
         Set @w_regEmpr = @@Rowcount
         If @w_regEmpr = 0
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
         Set @w_regUbic = @@Rowcount
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
         Set @w_regUbic = @@Rowcount
         If @w_regUbic = 0
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
         Set @w_regCCO = @@Rowcount
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
         Set @w_regEmpr = @@Rowcount
         If @w_regEmpr = 0
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
         Set @w_regDpto = @@Rowcount
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
         Set @w_regDpto = @@Rowcount
         If @w_regDpto = 0
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
         Join   #TmpEmpresa                       c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA
         Order  By 1;
         Set @w_reg = @@Rowcount
         If  @w_reg = 0
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
         Join   dbo.RH_TIPO_NOMINA                b
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
         Join   #TmpEmpresa                       c
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
         On     b.CLA_EMPRESA     = a.CLA_EMPRESA
         Where  a.anio_mes  Between @w_AnioMesIni And @w_AnioMesFin
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
         Where  b.anio_mes  Between @w_AnioMesIni And @w_AnioMesFin
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
        (CLA_EMPRESA,   CLA_PERDED, NOM_PERDED,      TIPO_PERDED,
         MOSTRAR_SALDO, GRUPO_CAL1, NO_AFECTAR_NETO, ESBASE_ISPT)
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, Substring(a.NOM_PERDED, 1, 40),
                Case When TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(a.MOSTRAR_SALDO, 0),
                Isnull(a.GRUPO_CAL1, 0), Isnull(a.NO_AFECTAR_NETO, 0),
                Isnull(a.ESBASE_ISPT, 0)
         From   dbo.RH_PERDED  a
         Join   #TmpEmpresa    b
         On     b.CLA_EMPRESA     = a.CLA_EMPRESA
         Where  a.NO_AFECTAR_NETO = 0
         And    a.NO_IMPRIMIR     = 0
         And    a.ES_PROVISION    = 0
         Union
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, Substring(a.NOM_PERDED, 1, 40),
                3, Isnull(a.MOSTRAR_SALDO, 0), Isnull(a.GRUPO_CAL1, 0),
                Isnull(NO_AFECTAR_NETO, 0),    Isnull(a.ESBASE_ISPT, 0)
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
         MOSTRAR_SALDO, GRUPO_CAL1, NO_AFECTAR_NETO, ESBASE_ISPT)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, Substring(b.NOM_PERDED, 1, 40),
                Case When b.TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(b.MOSTRAR_SALDO, 0),
                Isnull(b.GRUPO_CAL1, 0), Isnull(b.NO_AFECTAR_NETO, 0),
                Isnull(b.ESBASE_ISPT, 0)
         From   String_split(@PsCla_PerDed, ',') a
         Join   dbo.RH_PERDED                    b
         On     b.cla_perded      = a.value
         Join   #TmpEmpresa                      c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA
         Where  b.NO_AFECTAR_NETO = 0
         And    b.NO_IMPRIMIR     = 0
         And    b.ES_PROVISION    = 0
         Union
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, Substring(b.NOM_PERDED, 1, 40),
                3, Isnull(b.MOSTRAR_SALDO, 0),
                Isnull(b.GRUPO_CAL1, 0), Isnull(b.NO_AFECTAR_NETO, 0),
                Isnull(b.ESBASE_ISPT, 0)
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
   Set    NOM_PERDED = Substring('C' + Convert(Varchar,t1.CLA_PERDED) + '_' +  UPPER(Replace(
                      Replace(Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(Replace(Replace(
                      Replace(Trim(T1.NOM_PERDED),')','_')
                              ,'(','_'),'%',''),'.',''),'-',''),'/',''),'$',''),'.',''),' ','_'),char(13),''),char(10),''),char(9),'')),
                              1, 40)
   From   #tmpPerded t1;

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
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
         Where  t1.Anio_Mes    Between @w_AnioMesIni And @w_AnioMesFin;;
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
         On     t4.TIPO_NOMINA       = t1.TIPO_NOMINA
         Where  t1.Anio_Mes    Between @w_AnioMesIni And @w_AnioMesFin;
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
         CLA_PUESTO,       FECHA_NACIMIENTO, EDAD,             CLA_PERIODO)
         Select Distinct a.CLA_RAZON_SOCIAL,  a.CLA_EMPRESA, a.CLA_TRAB,
                Concat(Trim(a.NOM_TRAB), ' ', Trim(a.AP_PATERNO), ' ', Trim(a.AP_MATERNO)),
                a.FECHA_ING,                  a.FECHA_ING_GRUPO, Trim(a.NUM_IMSS), Trim(a.RFC),
                Case When Isnull(SIND, 0) = 0
                     Then 'NO SINDICALIZADO'
                     Else 'SINDICALIZADO'
                End, a.CLA_UBICACION_BASE,    a.CLA_CENTRO_COSTO, a.CLA_DEPTO,
                a.CLA_PUESTO,  a.FECHA_NAC, dbo.fnCalcEdad(a.FECHA_NAC, @w_fechaHoy),
                a.CLA_PERIODO
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
         CLA_PUESTO,       FECHA_NACIMIENTO, EDAD,             CLA_PERIODO)
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA, b.CLA_TRAB,
                Concat(Trim(b.NOM_TRAB), ' ', Trim(b.AP_PATERNO), ' ', Trim(b.AP_MATERNO)),
                a.FECHA_ING,                 a.FECHA_ING_GRUPO, Trim(a.NUM_IMSS), Trim(a.RFC),
                Case When Isnull(SIND, 0) = 0
                     Then 'NO SINDICALIZADO'
                     Else 'SINDICALIZADO'
                End SINDICALIZADO, b.CLA_UBICACION_BASE,    b.CLA_CENTRO_COSTO, b.CLA_DEPTO,
                b.CLA_PUESTO, b.FECHA_NAC, dbo.fnCalcEdad(b.FECHA_NAC, @w_fechaHoy),
                a.CLA_PERIODO
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
          Sum((a.dias_per - (a.F_JUST_SUE + a.F_INJUST  + a.F_JUST_NSUE + 
                             a.INCAP_ENF  + a.INCAP_MAT + a.INCAP_RIES))) DIAS_POR_PAGAR
   From   dbo.RH_ENC_REC_HISTO a
   Join   #TmpEmpresa          E
   On     E.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    E.CLA_EMPRESA      = a.CLA_EMPRESA
   Join   #TmpTrabajador       T
   On     T.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    T.CLA_EMPRESA      = a.CLA_EMPRESA
   And    T.CLA_TRAB         = a.CLA_TRAB
   Join   #tmpNominas          c
   On     c.ANIO_MES         = a.ANIO_MES
   And    c.CLA_EMPRESA      = a.CLA_EMPRESA
   And    c.CLA_PERIODO      = a.CLA_PERIODO
   And    c.NUM_NOMINA       = a.NUM_NOMINA
   Group  By a.CLA_EMPRESA, a.CLA_TRAB, a.CLA_PERIODO, a.NUM_NOMINA,
             a.ANIO_MES;

--
-- Inicio de Consulta para el reporte.
--

   If Exists ( Select top 1 1
               From   #TmpEstatusNomina
               Where  idEstatus = 9)
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
         CLA_PERDED,       NOM_PERDED,       Importe,          FECHA_NACIMIENTO,
         EDAD)
         Select t2.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
                t2.cla_trab,         t3.NOM_TRAB,          t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
                t3.nss,              t3.RFC,               T1.CLA_PERIODO,      t1.NUM_NOMINA,
                t3.CLA_UBICACION,    t5.NOM_UBICACION,     t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
                t3.CLA_DEPTO,        t7.NOM_DEPTO,         t3.CLA_PUESTO,       t13.NOM_PUESTO,
                t1.NOM_PERIODO,      t3.SINDICALIZADO,     T2.ANIO_MES,         Convert(Varchar(10), T1.INICIO_PER,103),
                Convert(Varchar(10), T1.FIN_PER,103),      t2.SUE_DIA,          t2.SUE_INT,
                t2.TOT_PER,          t2.TOT_DED,           t2.TOT_NETO,         
                0,
                t1.NOM_TIPO_NOMINA,  tr.CLA_PERDED,        tp.NOM_PERDED,       Sum(tr.importe),
                t3.FECHA_NACIMIENTO, t3.EDAD
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
         And    trz.CLA_EMPRESA      = t2.CLA_EMPRESA
         Join   #TmpEmpresa          te
         On     te.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
         And    te.CLA_EMPRESA      = t2.CLA_EMPRESA
         Join   #TmpTrabajador       t3
         On     t3.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t3.CLA_RAZON_SOCIAL = t2.cla_razon_social
         And    t3.CLA_TRAB         = t2.CLA_TRAB
         Join   #tmpRegImss           t4
         On     t4.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t4.CLA_REG_IMSS     = t2.CLA_REG_IMSS
         Join   #tmpUbicacion        t5
         On     t5.CLA_EMPRESA      = t3.CLA_EMPRESA
         And    t5.CLA_UBICACION    = t3.CLA_UBICACION
         Join   #tmpCentroCosto       t6
         On     t6.CLA_EMPRESA      = t3.CLA_EMPRESA
         And    t6.CLA_CENTRO_COSTO = t3.CLA_CENTRO_COSTO
         Join   #tmpDepto            t7
         On     t7.CLA_EMPRESA      = t3.CLA_EMPRESA
         And    t7.CLA_DEPTO        = t3.CLA_DEPTO
         Join   #tmpPerded           tp
         On     tp.Cla_Empresa      = tr.CLA_EMPRESA
         And    tp.CLA_PERDED       = tr.CLA_PERDED
         Left   Join  #tmpPuesto     t13
         On     t13.CLA_EMPRESA     = t3.CLA_EMPRESA
         And    t13.CLA_PUESTO      = t3.CLA_PUESTO
         Group  By t2.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
                   t2.cla_trab,         t3.NOM_TRAB,          t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
                   t3.nss,              t3.RFC,               T1.CLA_PERIODO,      t1.NUM_NOMINA,
                   t3.CLA_UBICACION,    t5.NOM_UBICACION,     t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
                   t3.CLA_DEPTO,        t7.NOM_DEPTO,         t3.CLA_PUESTO,       t13.NOM_PUESTO,
                   t1.NOM_PERIODO,      t3.SINDICALIZADO,     T2.ANIO_MES,         Convert(Varchar(10), T1.INICIO_PER,103),
                   Convert(Varchar(10), T1.FIN_PER,103),
                   t2.SUE_DIA,          t2.SUE_INT,           t2.TOT_PER,          t2.TOT_DED,
                   t2.TOT_NETO,         t1.NOM_TIPO_NOMINA,
                   tr.CLA_PERDED,       tp.NOM_PERDED,        t3.FECHA_NACIMIENTO, t3.EDAD;
      End

   If @PbIncluyeNominaAbierta = 1 Or
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
         CLA_PERDED,       NOM_PERDED,       Importe,          FECHA_NACIMIENTO,
         EDAD)
         Select trz.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
                t2.cla_trab,          t3.NOM_TRAB,          t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
                t3.nss,               t3.RFC,               T1.CLA_PERIODO,      t1.NUM_NOMINA,
                t3.CLA_UBICACION,     t5.NOM_UBICACION,     t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
                t3.CLA_DEPTO,         t7.NOM_DEPTO,         t3.CLA_PUESTO,       t13.NOM_PUESTO,
                t1.NOM_PERIODO,       t3.SINDICALIZADO,     T2.ANIO_MES_ISPT,    Convert(Varchar(10), T1.INICIO_PER,103),
                Convert(Varchar(10),  T1.FIN_PER,103),
                t2.SUE_DIA,           t2.SUE_INT,           t2.TOT_PER,          t2.TOT_DED,
                t2.TOT_NETO,          0,
                t1.NOM_TIPO_NOMINA,   tr.CLA_PERDED,        tp.NOM_PERDED,       Sum(tr.importe),
                t3.FECHA_NACIMIENTO,  t3.EDAD
         From   #tmpNominas           t1
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
         On     te.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
         And    te.CLA_EMPRESA      = t2.CLA_EMPRESA
         Join   #TmpRazon_Social     Trz
         On     trz.CLA_RAZON_SOCIAL = te.CLA_RAZON_SOCIAL
         And    trz.CLA_EMPRESA      = te.CLA_EMPRESA
         Join   #TmpTrabajador       t3
         On     t3.CLA_EMPRESA       = t2.CLA_EMPRESA
         And    t3.CLA_TRAB          = t2.CLA_TRAB
         Join   #tmpRegImss          t4
         On     t4.CLA_EMPRESA       = t2.CLA_EMPRESA
         And    t4.CLA_REG_IMSS      = t2.CLA_REG_IMSS
         Join   #tmpUbicacion        t5
         On     t5.CLA_EMPRESA       = t3.CLA_EMPRESA
         And    t5.CLA_UBICACION     = t3.CLA_UBICACION
         Join   #tmpCentroCosto               t6
         On     t6.CLA_EMPRESA       = t3.CLA_EMPRESA
         And    t6.CLA_CENTRO_COSTO  = t3.CLA_CENTRO_COSTO
         Join   #tmpDepto            t7
         On     t7.CLA_EMPRESA       = t3.CLA_EMPRESA
         And    t7.CLA_DEPTO         = t3.CLA_DEPTO
         Join   #tmpPerded           tp
         On     tp.Cla_Empresa       = tr.CLA_EMPRESA
         And    tp.CLA_PERDED        = tr.CLA_PERDED
         Left   Join  #tmpPuesto     t13
         On     t13.CLA_EMPRESA      = t3.CLA_EMPRESA
         And    t13.CLA_PUESTO       = t3.CLA_PUESTO
         Group  By trz.CLA_RAZON_SOCIAL, trz.NOM_RAZON_SOCIAL, t2.CLA_EMPRESA,      te.NOM_EMPRESA,
                t2.cla_trab,         t3.NOM_TRAB,         t3.FECHA_ING,        t3.FECHA_ING_GRUPO,
                t3.nss,              t3.RFC,              T1.CLA_PERIODO,      t1.NUM_NOMINA,
                t3.CLA_UBICACION,    t5.NOM_UBICACION,    t3.CLA_CENTRO_COSTO, t6.NOM_CENTRO_COSTO,
                t3.CLA_DEPTO,        t7.NOM_DEPTO,        t3.CLA_PUESTO,       t13.NOM_PUESTO,
                t1.NOM_PERIODO,      t3.SINDICALIZADO,    T2.ANIO_MES_ISPT,    Convert(Varchar(10), T1.INICIO_PER,103),
                Convert(Varchar(10), T1.FIN_PER,103),
                t2.SUE_DIA,          t2.SUE_INT,          t2.TOT_PER,          t2.TOT_DED,
                t2.TOT_NETO,
                t1.NOM_TIPO_NOMINA,  tr.CLA_PERDED,       tp.NOM_PERDED,       t3.FECHA_NACIMIENTO,
                t3.EDAD;


      End;

   Update #tmpNominasTrab
   Set    DIAS_POR_PAGAR = (Select Sum(DIAS_POR_PAGAR)
                            From   #TmpDIAS_POR_PAGAR T99
                            Where  t99.CLA_EMPRESA      = t2.CLA_EMPRESA
                            And    t99.CLA_TRAB         = t2.CLA_TRAB
                            And    t99.ANIO_MES         = t2.ANIO_MES
                            And    t99.CLA_PERIODO      = t2.CLA_PERIODO
                            And    t99.NUM_NOMINA       = t2.NUM_NOMINA)
   From   #tmpNominasTrab t2
   Where  Secuencia       = (Select Min (secuencia)
                            From   #tmpNominasTrab
                            Where  CLA_EMPRESA      = t2.CLA_EMPRESA
                            And    CLA_TRAB         = t2.CLA_TRAB
                            And    ANIO_MES         = t2.ANIO_MES
                            And    CLA_PERIODO      = t2.CLA_PERIODO
                            And    NUM_NOMINA       = t2.NUM_NOMINA)         

   If Not Exists ( Select Top 1 1
                   From   #tmpNominasTrab)
      Begin
           Begin
              Select @PnError   = 13,
                     @PsMensaje = 'No Existen Coincidencias para los Parámetros Seleccionados.'

              Select @PnError IdError, @PsMensaje Error
              Set Xact_Abort Off
              Return

           End
      End

   Select @w_fechaProcIni = Min(INICIO_PER),
          @w_fechaProcFin = Max(FIN_PER)
   From   #tmpNominasTrab;

   Set @w_secuencia = 0;

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
              Select @w_nominas   = Concat('NOMINAS: ', @w_nom_tipo_nomina),
                     @w_secuencia = 1;
           End
        Else
           Begin
              Set @w_nominas = @w_nominas + ', ' + @w_nom_tipo_nomina
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
      Select a.NOM_PERDED, b.TIPO_PERDED
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
         Fetch C_Conceptos Into @w_nom_perded, @w_tipo_perded;
         If @@Fetch_status != 0
            Begin
               Break
            End

         If @w_tipo_perdedAnte = 0
            Begin
               Select @w_tipo_perdedAnte = @w_tipo_perded,
                      @w_suma_Percepciones = 'Update #tmpResultado Set totalPercepciones = 0 ',
                      @w_suma_Deducciones  = 'Update #tmpResultado Set totalDeducciones  = 0 ',
                      @w_suma_Provisiones  = 'Update #tmpResultado Set totalProvisiones  = 0 ';
            End

         If @w_tipo_perded = 1
            Begin
               Set  @w_suma_Percepciones =  @w_suma_Percepciones + ' + ' + @w_nom_perded
            End

         If @w_tipo_perded = 2
            Begin
               Set  @w_suma_Deducciones =  @w_suma_Deducciones + ' + ' + @w_nom_perded
            End

         If @w_tipo_perded = 3
            Begin
               Set  @w_suma_Provisiones =  @w_suma_Provisiones + ' + ' + @w_nom_perded
            End

         If @w_tipo_perded != @w_tipo_perdedAnte
            Begin
               If @w_tipo_perdedAnte = 1
                  Begin
                     Set @w_sql = Concat('Alter Table #tmpResultado Add TOTALPERCEPCIONES ',
                                         ' Decimal (18, 2) Null Default 0')
                     Execute(@w_sql)

                     Set @w_columnas = Concat(@w_columnas, ', TOTALPERCEPCIONES ');
                     Set @w_colsuma  = Concat(@w_colsuma, ', 0')
                  End

               If @w_tipo_perdedAnte = 2
                  Begin
                     Set @w_sql = Concat('Alter Table #tmpResultado Add TOTALDEDUCCIONES ',
                                         ' Decimal (18, 2) Null Default 0')
                     Execute(@w_sql)

                     Set @w_columnas = Concat(@w_columnas, ', totalDeducciones ');
                     Set @w_colsuma  = Concat(@w_colsuma, ', 0')
                  End

               Set @w_tipo_perdedAnte = @w_tipo_perded

            End

         Set @w_sql = Concat('Alter Table #tmpResultado Add ', @w_nom_perded,
                                  ' Decimal (18, 2) Null Default 0')
         Execute(@w_sql)

         Set @w_columnas = Concat(@w_columnas, ', ', @w_nom_perded);

         Set @w_colsuma  = Concat(@w_colsuma, ', Sum(',
                                       'Iif(NOM_PERDED = ', @w_comilla, trim(@w_nom_perded), @w_comilla,
                                                           ',importe, 0))');
      End
      Close      C_Conceptos
      Deallocate C_Conceptos
   End

   Set @w_sql = Concat('Alter Table #tmpResultado Add TOTALPROVISIONES ',
                                    ' Decimal (18, 2) Null Default 0')
   Execute(@w_sql)

   Set @w_columnas = Concat(@w_columnas, ', totalProvisiones ');

   Set @w_colsuma  = Concat(@w_colsuma, ', 0')

   Alter Table #tmpResultado Add  NOMINAS       Varchar(2000) Null Default Char(32);
   Alter Table #tmpResultado Add  FECHA_INICIO  Varchar(  10) Null Default Char(32);
   Alter Table #tmpResultado Add  FECHA_TERMINO Varchar(  10) Null Default Char(32);

   Select @w_columnas = Concat(@w_columnas, ', ', 'NOMINAS, FECHA_INICIO, FECHA_TERMINO '),
          @w_colsuma  = Concat(@w_colsuma,  ', ', @w_comilla, @w_nominas, @w_comilla, ', ',
                               @w_comilla, Convert(Char(10), @w_fechaProcIni, 103), @w_comilla, ', ',
                               @w_comilla, Convert(Char(10), @w_fechaProcFin, 103), @w_comilla)

--
-- Detalle por Trabajador
--


   Set @w_executeInsert = Concat('Insert Into #tmpResultado ',
                                 '(tipo,           CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,',
                                 'NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB, ',
                                 'FECHA_ING,',
                                 'FECHA_ING_GRUPO, NSS,              RFC,              CLA_UBICACION,',
                                 'NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,',
                                 'NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO, ',
                                 'SUE_DIA,         SUE_INT,          TOT_PER,          TOT_DED, ',
                                 'TOT_NETO,        DIAS_POR_PAGAR,   FECHA_NACIMIENTO, EDAD, ',
                                 'CLA_PERIODO, NOM_PERIODO ', @w_columnas, ') ',
                                 'Select ', @w_comilla, 'L0', @w_comilla, ', ',
                                         'CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,',
                                         'NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         Convert(Char(10), FECHA_ING, 103), ',
                                         'Convert(Char(10), FECHA_ING_GRUPO, 103), NSS,              RFC,              CLA_UBICACION,',
                                         'NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,',
                                         'NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO, ',
                                         'Max(SUE_DIA),    Max(SUE_INT),     Sum(TOT_PER),     Sum(TOT_DED), ',
                                         'Sum(TOT_NETO),   Sum(DIAS_POR_PAGAR),   Convert(Char(10), FECHA_NACIMIENTO, 103), ',
                                         'Cast(EDAD As Varchar), CLA_PERIODO, NOM_PERIODO ',  @w_colsuma, ' ',
                                 'From  #tmpNominasTrab ',
                                 'Group By CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,',
                                         'NOM_EMPRESA,     CLA_TRAB,         NOM_TRAB,         FECHA_NACIMIENTO, ',
                                         'EDAD,            Convert(Char(10), FECHA_ING, 103),',
                                         'Convert(Char(10), FECHA_ING_GRUPO, 103), NSS,        RFC,  CLA_UBICACION,',
                                         'NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,',
                                         'NOM_DEPTO,       CLA_PUESTO,       NOM_PUESTO,       TIPO_COMPANIERO, ',
                                         'Convert(Char(10), FECHA_NACIMIENTO, 103), EDAD,      CLA_PERIODO, ',
                                         'NOM_PERIODO ',
                                  'Order By CLA_RAZON_SOCIAL, CLA_EMPRESA,  CLA_UBICACION, CLA_CENTRO_COSTO, CLA_DEPTO, ',
                                  'CLA_TRAB' );

   Execute (@w_executeInsert);

--
-- Total por Departamento
--

   Set @w_executeInsert = Concat('Insert Into #tmpResultado ',
                                 '(tipo,  CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB,  CLA_UBICACION, ',
                                 'CLA_CENTRO_COSTO, CLA_DEPTO, NOM_TRAB ',
                                  @w_columnas, ') ',
                                 'Select ', @w_comilla, 'L1', @w_comilla, ', ',
                                         'CLA_RAZON_SOCIAL, CLA_EMPRESA, Max(CLA_TRAB), ',
                                         'CLA_UBICACION,    CLA_CENTRO_COSTO, ',
                                         'CLA_DEPTO, ',
                                         'Concat(', @w_comilla, 'Total Departamento.: ', @w_comilla, ', CLA_DEPTO) ',
                                         ' ',  @w_colsuma, ' ',
                                 'From  #tmpNominasTrab ',
                                 'Group By CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION,',
                                         ' CLA_DEPTO, CLA_CENTRO_COSTO ',
                                 'Order By CLA_RAZON_SOCIAL, CLA_EMPRESA,  CLA_UBICACION, CLA_CENTRO_COSTO, 7, 4' );

   Execute (@w_executeInsert);

--
-- Total por Centro de Costo.
--

   Set @w_executeInsert = Concat('Insert Into #tmpResultado ',
                                 '(tipo,  CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB,  CLA_UBICACION, ',
                                 'CLA_CENTRO_COSTO, NOM_TRAB, CLA_DEPTO ',
                                  @w_columnas, ') ',
                                 'Select ', @w_comilla, 'L2', @w_comilla, ', ',
                                         'CLA_RAZON_SOCIAL, CLA_EMPRESA, Max(CLA_TRAB), ',
                                         'CLA_UBICACION, CLA_CENTRO_COSTO, ',
                                         'Concat(', @w_comilla, 'Total Centro de Costo.: ', @w_comilla, ', CLA_CENTRO_COSTO), ',
                                         'Max(CLA_DEPTO) ',
                                          @w_colsuma, ' ',
                                 'From  #tmpNominasTrab ',
                                 'Group By CLA_RAZON_SOCIAL,  CLA_EMPRESA,  CLA_UBICACION, CLA_CENTRO_COSTO ',
                                 'Order By CLA_RAZON_SOCIAL, CLA_EMPRESA,  CLA_UBICACION, 6, 8, 4' );

   Execute (@w_executeInsert);

--
-- Total por Ubicación.
--

   If @w_regUbic > 1
      Begin
         Set @w_executeInsert = Concat('Insert Into #tmpResultado ',
                                       '(tipo,  CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB,  CLA_UBICACION, NOM_TRAB, ',
                                       'CLA_CENTRO_COSTO, CLA_DEPTO ',
                                        @w_columnas, ') ',
                                       'Select ', @w_comilla, 'L3', @w_comilla, ', ',
                                               'CLA_RAZON_SOCIAL, CLA_EMPRESA, Max(CLA_TRAB), ',
                                               'CLA_UBICACION, ',
                                               'Concat(', @w_comilla, 'Total UBICACION.: ', @w_comilla, ', CLA_UBICACION), ',
                                               'Max(CLA_CENTRO_COSTO), ', 'Max(CLA_DEPTO) ',
                                                @w_colsuma, ' ',
                                       'From  #tmpNominasTrab ',
                                       'Group By CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION ',
                                       'Order By CLA_RAZON_SOCIAL, CLA_EMPRESA,  5, 6, 8, 4' );

         Execute (@w_executeInsert);
      End

--
-- Total por Empresa.
--

   If @w_regEmpr > 1
      Begin
         Set @w_executeInsert = Concat('Insert Into #tmpResultado ',
                                       '(tipo,  CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB,  CLA_UBICACION, NOM_TRAB, ',
                                       'CLA_CENTRO_COSTO, CLA_DEPTO ',
                                        @w_columnas, ') ',
                                       'Select ', @w_comilla, 'L4', @w_comilla, ', ',
                                               'CLA_RAZON_SOCIAL, CLA_EMPRESA, Max(CLA_TRAB), ',
                                               'Max(CLA_UBICACION), ',
                                               'Concat(', @w_comilla, 'Total Empresa.: ', @w_comilla, ', CLA_EMPRESA), ',
                                               'Max(CLA_CENTRO_COSTO), ', 'Max(CLA_DEPTO) ',
                                                @w_colsuma, ' ',
                                       'From  #tmpNominasTrab ',
                                       'Group By CLA_RAZON_SOCIAL, CLA_EMPRESA ',
                                       'Order By CLA_RAZON_SOCIAL, 3,  5, 6, 8, 4' );

         Execute (@w_executeInsert);
      End

--
-- Total por Razón Social.
--

   If @w_regRZ > 1
      Begin
         Set @w_executeInsert = Concat('Insert Into #tmpResultado ',
                                       '(tipo,  CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB,  CLA_UBICACION, NOM_TRAB, ',
                                       'CLA_CENTRO_COSTO, CLA_DEPTO ',
                                        @w_columnas, ') ',
                                       'Select ', @w_comilla, 'L5', @w_comilla, ', ',
                                               'Max(CLA_RAZON_SOCIAL), Max(CLA_EMPRESA), Max(CLA_TRAB), ',
                                               'Max(CLA_UBICACION), ',
                                               'Concat(', @w_comilla, 'Total Razon Social.: ', @w_comilla, ', Max(CLA_RAZON_SOCIAL)), ',
                                               'Max(CLA_CENTRO_COSTO), ', 'Max(CLA_DEPTO) ',
                                                @w_colsuma, ' ',
                                       'From  #tmpNominasTrab ',
                                       'Group By CLA_RAZON_SOCIAL ',
                                       'Order By CLA_RAZON_SOCIAL, 3,  5, 6, 8, 4' );

         Execute (@w_executeInsert);
      End

--
-- Total Reporte.
--


   Set @w_executeInsert = Concat('Insert Into #tmpResultado ',
                                 '(tipo,  CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB,  CLA_UBICACION, NOM_TRAB, ',
                                 'CLA_CENTRO_COSTO, CLA_DEPTO ',
                                  @w_columnas, ') ',
                                 'Select ', @w_comilla, 'L6', @w_comilla, ', ',
                                         'Max(CLA_RAZON_SOCIAL), Max(CLA_EMPRESA), Max(CLA_TRAB), ',
                                         'Max(CLA_UBICACION), ',
                                         @w_comilla, 'Total Reporte.: ', @w_comilla,', ',
                                         'Max(CLA_CENTRO_COSTO), ', 'Max(CLA_DEPTO) ',
                                          @w_colsuma, ' ',
                                 'From  #tmpNominasTrab ',
                                 'Order By 2, 3, 5, 6, 8, 4' );

   Execute (@w_executeInsert);

   Execute (@w_suma_Percepciones)
   Execute (@w_suma_Deducciones)
   Execute (@w_suma_provisiones)

   Update #tmpResultado
   Set       TOT_PER  = totalPercepciones,
             TOT_DED  = totalDeducciones,
             TOT_NETO = totalPercepciones - totalDeducciones;

   Set @w_secuencia = 0

   Declare
      C_ColumnasRep    Cursor For
      Select name
      From   tempdb.sys.all_columns
      Where  object_id = @w_idTabla
      Order  by column_id
   Begin
      Select @w_insert    = 'Insert Into #tmpReporte (idSession ',
             @w_inicial   = Concat('Select ', @w_comilla, 'idSession',  @w_comilla, ' '),
             @w_columnas  = Concat('Select ', @w_comilla, @w_idSession, @w_comilla, ' '),
             @w_select    = 'Select ';

      Open  C_ColumnasRep
      While @@Fetch_status < 1
      Begin
         Fetch C_ColumnasRep Into @w_columna
         If @@Fetch_status != 0
            Begin
               Break
            End

         If Exists ( Select top 1 1
                     From   #TempCamposExcepcion
                     Where  columna = @w_columna)
            Begin
               Goto Siguiente
            End

         Set @w_secuencia = @w_secuencia + 1;

         Select @w_insert   = Concat(@w_insert, ', Columna', Format(@w_secuencia,'000')),
                @w_inicial  = Concat(@w_inicial,  ', ', @w_comilla, @w_columna, @w_comilla),
                @w_select   = Concat(@w_select, iif(@w_secuencia = 1, Char(32), ', '),
                                        'Columna', Format(@w_secuencia,'000'));
         If @w_columna = 'CLA_TRAB'
            Begin
               Set @w_columna = Concat('iif(tipo = ', @w_comilla, 'L0', @w_comilla, ', Cast(cla_trab As Varchar), Char(32))');
            End

         Set @w_columnas = Concat(@w_columnas, ', ', @w_columna);

Siguiente:

      End
      Close      C_ColumnasRep
      Deallocate C_ColumnasRep

   End

   Select @w_insert   = @w_insert + ')',
          @w_columnas = Concat(@w_columnas, ' ',
                       'From  #tmpResultado ',
                       'Order By CLA_UBICACION, ',
                              'CLA_CENTRO_COSTO, CLA_DEPTO, CLA_TRAB, Secuencia')

   Set @w_executeInsert = Concat(@w_insert, ' ', @w_inicial)
   Execute (@w_executeInsert)

   Set @w_executeInsert = Concat(@w_insert, ' ', @w_columnas)
   Execute (@w_executeInsert)

   Set @w_executeInsert = CONCAT(@w_select, ' ',
                                'From   #tmpReporte ',
                                'Order  BY secuencia')

   Execute (@w_executeInsert)

   Set Xact_Abort Off
   Return

End
Go
