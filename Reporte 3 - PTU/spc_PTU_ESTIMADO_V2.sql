-- Declare
   -- @PsRazon_Social            Varchar(Max)   = '',
   -- @PsCla_Empresa             Varchar(Max)   = '1',
   -- @PsCla_Ubicacion           Varchar(Max)   = '',
   -- @PsCla_CentroCosto         Varchar(Max)   = '',
   -- @PsCla_Area                Varchar(Max)   = '',
   -- @PsCla_Depto               Varchar(Max)   = '',
   -- @PsCla_RegImss             Varchar(Max)   = '',
   -- @PnAnioPTU                 Integer        = 2024,
   -- @PnError                   Integer        = 0,
   -- @PsMensaje                 Varchar( 250)  = ' ';
-- Begin
   -- Execute dbo.spc_PTU_Estimado        @PsRazon_Social    = @PsRazon_Social,
                                       -- @PsCla_Empresa     = @PsCla_Empresa,
                                       -- @PsCla_Ubicacion   = @PsCla_Ubicacion,
                                       -- @PsCla_CentroCosto = @PsCla_CentroCosto,
                                       -- @PsCla_Area        = @PsCla_Area,
                                       -- @PsCla_Depto       = @PsCla_Depto,
                                       -- @PsCla_RegImss     = @PsCla_RegImss,
                                       -- @PnAnioPTU         = @PnAnioPTU,
                                       -- @PnError           = @PnError   Output,
                                       -- @PsMensaje         = @PsMensaje Output;
   -- If @PnError != 0
      -- Begin
         -- Select @PnError, @PsMensaje;
      -- End

   -- Return

-- End
-- Go

Create Or Alter Procedure dbo.spc_PTU_Estimado
  (@PsRazon_Social            Varchar(Max)   = '',
   @PsCla_Empresa             Varchar(Max)   = '',
   @PsCla_Ubicacion           Varchar(Max)   = '',
   @PsCla_CentroCosto         Varchar(Max)   = '',
   @PsCla_Area                Varchar(Max)   = '',
   @PsCla_Depto               Varchar(Max)   = '',
   @PsCla_RegImss             Varchar(Max)   = '',
   @PnAnioPTU                 Integer        = 0,
   @PnError                   Integer        = 0    Output,
   @PsMensaje                 Varchar( 250)  = Null Output)
As

Declare
   @w_desc_error              Varchar(250),
   @w_tituloRep               Varchar(350),
   @w_fechaProc               Varchar( 10),
   @w_colPerded               Varchar( 60),
   @w_sql                     Varchar(Max),
   @w_columnas                Varchar(Max),
   @w_columnas2               Varchar(Max),
   @w_insert                  Varchar(Max),
   @w_inicial                 Varchar(Max),
   @w_select                  Varchar(Max),
   @w_executeInsert           Varchar(Max),
   @w_fechaProcIni            Date,
   @w_fechaProcFin            Date,
   @w_fechaInicioPTU          Date,
   @w_fechaTerminoPTU         Date,
   @w_Error                   Integer,
   @w_secuencia               Integer,
   @w_registros               Integer,
   @w_MesIni                  Integer,
   @w_MesFin                  Integer,
   @w_AnioMesIni              Integer,
   @w_AnioMesFin              Integer,
   @w_anioPagoPTU             Integer,
   @w_diasEjercicio           Integer,
   @w_diasGratificacion       Integer,
   @w_reg                     Integer,
   @w_secFin                  Integer,
   @w_dias_prom               Integer,
   @w_status_nomina           Integer,
   @w_total_dias              Integer,
   @w_sec_min                 Integer,
   @w_sec_max                 Integer,
   @w_mesIniPtu               Integer,
   @w_mesFinPtu               Integer,
   @w_cla_perded              Integer,
   @w_num_nomina              Integer,
   @w_idTabla                 Integer,
   @w_inicio                  Bit,
   @w_importe                 Decimal(18, 2),
   @w_imp                     Decimal(18, 2),
   @w_salBasePtu              Decimal(18, 2),
   @w_PorcBasePtu             Decimal(18, 2),
   @w_topePtu                 Decimal(18, 2),
   @w_imp_PTU_A_REPARTIR      Decimal(18, 2),
   @w_total_salarios          Decimal(18, 2),
   @w_fechaHoy                Date,
   @w_Factor_Salarios         Float,
   @w_factor_dias             Float,
--
   @w_horaProceso             Char(20),
   @w_comilla                 Char(1),
   @w_char47                  Char(1),
   @w_columna                 Sysname,
   @w_idSession               Nvarchar(Max);;

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off
   Set Ansi_Warnings On

   Select @PnError              = 0,
          @w_reg                = 0,
          @w_registros          = 0,
          @w_secuencia          = 0,
          @w_inicio             = 1,
          @w_comilla            = Char(39),
          @w_char47             = Char(47),
          @w_idSession          = Cast(Newid() As nvarchar(Max)),
          @w_anioPagoPTU        = @PnAnioPTU + 1,
          @w_fechaHoy           = Getdate(),
          @PsMensaje            = 'Proceso Terminado Ok',
          @w_tituloRep          = Concat('NOMINA PTU AÑO.: ', @PnAnioPTU),
          @w_fechaProc          = Convert(Char(10), Getdate(), 103),
          @w_horaProceso        = Format(Getdate(), 'hh:mm:ss tt'),
          @w_fechaInicioPTU     = Convert(Date, Concat('01/01/',  @PnAnioPTU), 103),
          @w_fechaTerminoPTU    = Convert(Date, Concat('31/12/',  @PnAnioPTU), 103),
          @w_diasEjercicio      = Datediff(DD, @w_fechaInicioPTU, @w_fechaTerminoPTU) + 1;

--
-- Consulta al Rango de fechas para el cálculo del sueldo promedio.
--

   Select  Top 1 @w_AnioMesIni = VALOR_VAR_USUARIO
   From    dbo.RH_VAR_USUARIO
   Where   CLA_VAR = '$in_GS_PTU'

   Select  Top 1 @w_AnioMesFin = VALOR_VAR_USUARIO
   From    dbo.RH_VAR_USUARIO
   Where   CLA_VAR = '$fi_GS_PTU'

--
-- Consulta del número de días para el Cálculo del Sueldo Promedio.

   Select top 1 @w_dias_prom = VALOR_VAR_USUARIO
   From   dbo.RH_VAR_USUARIO
   Where  CLA_VAR = '$diasG_PTU';

--
-- Consulta del número de días para la Gratificación.
--

   Select Top 1 @w_diasGratificacion = VALOR_VAR_USUARIO
   From   dbo.RH_VAR_USUARIO
   Where  CLA_VAR = '$diaGraesp';

--
-- Consulta Datos del PTU.
--

   Select TOP 1 @w_imp_PTU_A_REPARTIR = utilidad,
                @w_topePtu            = TOPE_DE_INGRESOS
   from   dbo.rh_ptu
   Where  anio = @PnAnioPTU;

--
-- Creación de Tablas Temporales.
--

-- Razón Social.

   Create Table #TempRazon_Social
  (CLA_RAZON_SOCIAL  Integer      Not Null,
   NOM_RAZON_SOCIAL  Varchar(300) Not Null,
   CLA_EMPRESA       Integer      Not Null,
   Constraint TempRazon_SocialPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA));

-- Razón Empresa.

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
-- Tabla Temporal de Periodos de Nómina.
--

   Create Table #TmpPeriodo
  (CLA_EMPRESA  Integer       Not Null,
   CLA_PERIODO  Integer       Not Null,
   Constraint tempPeriodoPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO));

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
   TIPO_NOMINA      Integer          Null,
   NOM_TIPO_NOMINA  Varchar( 80) Not Null,
   STATUS_NOMINA    Integer      Not Null,
   STRING           Varchar(Max) Not Null,
   Constraint tmpNominasPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO, NUM_NOMINA));

--
-- Tabla Temporal de Conceptos de Nómina.
--

   Create  Table #tmpPerded
  (CLA_EMPRESA       Integer      Not Null,
   CLA_PERDED        Integer      Not Null,
   NOM_PERDED        Varchar( 80) Not  Null,
   TIPO_PERDED       Integer      Not Null,
   Constraint tmpPerdedPk
   Primary Key (CLA_EMPRESA, CLA_PERDED));

--
-- Tabla Temporal de Trabajadores.
--

   Create Table #TmpTrabajador
  (CLA_RAZON_SOCIAL    Integer         Not Null,
   NOM_RAZON_SOCIAL    Varchar(300)    Not Null,
   CLA_EMPRESA         Integer         Not Null,
   NOM_EMPRESA         Varchar(120)    Not Null,
   CLA_TRAB            Integer         Not Null,
   NOM_TRAB            Varchar(400)        Null,
   FECHA_ING_GRUPO     Date                Null,
   FECHA_BAJA          Date                Null,
   STATUS_TRAB         Char(1)         Not Null,
   CLA_PUESTO          Integer         Not Null Default 0,
   CLA_CLASIFICACION   Integer         Not Null Default 0,
   CLA_UBICACION       Integer         Not Null Default 0,
   NOM_UBICACION       Varchar(150)        Null,
   SUELDO_DIA          Decimal(18, 2)  Not Null Default 0,
   Constraint TmpTrabajadorPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB));

--
-- Tabla Temporal de Salarios Promedios de Trabajadores.
--

   Create Table #TmpSalarioProm
  (CLA_RAZON_SOCIAL    Integer          Not Null,
   CLA_EMPRESA         Integer          Not Null,
   CLA_TRAB            Integer          Not Null,
   CLA_PERDED          Integer          Not Null,
   IMPORTE             Decimal(18, 2)   Not Null,
   Constraint TmpSalarioPromPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED));

--
-- Tabla Temporal de Cifras de PTU.
--

   Create Table #TmpCifrasPTU
  (CLA_RAZON_SOCIAL    Integer          Not Null,
   CLA_EMPRESA         Integer          Not Null,
   CLA_TRAB            Integer          Not Null,
   CLA_PERDED          Integer          Not Null,
   IMPORTE             Decimal(18, 2)   Not Null,
   Constraint TmpCifrasPTUPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED));

--
-- Tabla Temporal de Cifras Nómina Especial.
--


   Create Table #TmpCifrasNomEsp
  (CLA_RAZON_SOCIAL    Integer          Not Null,
   CLA_EMPRESA         Integer          Not Null,
   CLA_TRAB            Integer          Not Null,
   CLA_PERDED          Integer          Not Null,
   IMPORTE             Decimal(18, 2)   Not Null,
   Constraint TmpCifrasNomEspPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED));

--
-- Tabla Temporal de Tipos de Nómina.
--

   Create Table #TmpTipoNom
  (TIPO_NOMINA            Integer       Not Null,
   NOM_TIPO_NOMINA        Varchar(100)  Not Null,
   Constraint tempTipoNomPk
   Primary Key (TIPO_NOMINA));

--
-- Tabla de Relación Trabajadores Nómina.
--

   Create Table #tmpAcumTrab
  (CLA_RAZON_SOCIAL  Integer         Not Null,
   NOM_RAZON_SOCIAL  Varchar(300)    Not Null,
   CLA_EMPRESA       Integer         Not Null,
   NOM_EMPRESA       Varchar(100)    Not Null,
--
   CLA_TRAB          Integer             Null,
   NOM_TRAB          Varchar(150)        Null,
   STATUS_TRAB       Char(1)         Not Null,
   CLA_PUESTO        Integer             Null,
   NOM_PUESTO        Varchar(150)        Null,
   NOM_CATEGORIA     Varchar(150)        Null,
   FECHA_ING_GRUPO   Date                Null,
   FECHA_BAJA        Date                Null,
   CLA_UBICACION     Integer         Not Null,
   NOM_UBICACION     Varchar(150)        Null,
   CLA_PERDED        Integer         Not Null,
   NOM_PERDED        Varchar(150)    Not Null,
   IMPORTE           Decimal(18, 2)  Not Null Default 0,
   Index tmpAcumTrabIdx01 (CLA_EMPRESA, CLA_TRAB, CLA_PERDED));

--
-- Tabla de presentación inicial de la Salida.
--

   Create Table #tmpResultado
  (secuencia                 Integer        Not Null Identity (1, 1) Primary Key,
   CLA_TRAB                  Integer        Not Null,
   NOM_TRAB                  Varchar(200)   Not Null,
   ESTATUS                   Varchar( 10)   Not Null,
   PUESTO                    Varchar(100)   Not Null,
   CATEGORIA                 Varchar(100)   Not Null,
   INGRESO                   Varchar( 10)   Not Null,
   UBICACION                 Varchar(100)   Not Null,
   Index tmpResultado Unique (cla_trab));

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
   Select 'CLA_CLASIFICACION'
   Union
   Select 'CLA_PUESTO'
   Union
   Select 'CLA_PERIODO'
   Union
   Select 'FECHA_BAJA';

--
-- Filtro para Consulta de Razon Social.
--

   If Isnull(@PsRazon_Social, '') = ''
      Begin
         Insert Into #TempRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select Distinct CLA_RAZON_SOCIAL, Concat(nom_razon_social, ' - ', rfc_emp), CLA_EMPRESA
         From   dbo.rh_razon_social;
      End
   Else
      Begin
         Insert Into #TempRazon_Social
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
-- Filtro para Consulta de Empresas
--

   If Isnull(@PsCla_Empresa, '') = ''
      Begin
         Insert Into #TmpEmpresa
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, NOM_EMPRESA)
         Select Distinct a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.NOM_EMPRESA
         From   dbo.rh_razon_social a
         Join   #TempRazon_Social   b
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
         Join   #TempRazon_Social                 c
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
-- Filtro Consulta de Ubicación.
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
-- Filtro Consulta de los Centros de Costo.
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
-- Consulta de los Departamentos
--

   If Isnull(@PsCla_Depto, '') = ''
      Begin
         Insert Into #TmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA)
         Select DIstinct a.CLA_EMPRESA, a.CLA_DEPTO, a.NOM_DEPTO, Isnull(a.CLA_AREA, 0)
         From   dbo.RH_DEPTO  a
         Join   #TmpEmpresa   b
         On     b.CLA_EMPRESA = a.CLA_EMPRESA
         Left   Join   #tmpArea      c
         On     c.CLA_EMPRESA = a.CLA_EMPRESA
         And    c.CLA_AREA    = a.CLA_AREA;
      End
   Else
      Begin
        Insert Into #TmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA)
         Select Distinct b.CLA_EMPRESA, b.CLA_DEPTO, b.NOM_DEPTO, Isnull(b.CLA_AREA, 0)
         From   String_split(@PsCla_Depto, ',') a
         Join   dbo.RH_DEPTO                    b
         On     b.CLA_DEPTO   = a.value
         Join   #TmpEmpresa                     c
         On     c.CLA_EMPRESA = b.CLA_EMPRESA
         Left   Join   #tmpArea                        d
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
-- Filtro para Consulta de los Regimenes IMSS
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
         On     b.CLA_REG_IMSS = a.value
         Join   #TmpEmpresa                       c
         On     c.CLA_EMPRESA  = b.CLA_EMPRESA
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

   Insert Into #TmpTipoNom
  (TIPO_NOMINA, NOM_TIPO_NOMINA)
   Select Distinct TIPO_NOMINA, NOM_TIPO_NOMINA
   From   dbo.RH_TIPO_NOMINA
   Where  NOM_TIPO_NOMINA = 'GRATIFICACION ESPECIAL'
   Union
   Select Distinct TIPO_NOMINA, NOM_TIPO_NOMINA
   From   dbo.RH_TIPO_NOMINA
   Where  NOM_TIPO_NOMINA = 'PTU';

--
-- Filtro de Consulta de Períodos de Nomina
--

   Insert Into #TmpPeriodo
  (CLA_EMPRESA, CLA_PERIODO)
   Select Distinct a.CLA_EMPRESA, a.CLA_PERIODO
   From   dbo.RH_PERIODO a
   Join   #TmpEmpresa    b
   On     b.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    b.CLA_EMPRESA      = a.CLA_EMPRESA;

   Insert Into #tmpNominas
  (CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
   INICIO_PER,       FIN_PER,          ANIO,             NOM_PERIODO,
   TIPO_NOMINA,      NOM_TIPO_NOMINA,  STATUS_NOMINA,    STRING)
   Select Distinct t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,          t1.ANIO_MES,
          t1.INICIO_PER,  t1.FIN_PER,          t1.ANIO_MES / 100 ANIO,
          'PTU',
          t4.TIPO_NOMINA, t4.NOM_TIPO_NOMINA,  t1.STATUS_NOMINA,
          Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
   From   dbo.RH_FECHA_PER t1
   Join   #TmpPeriodo      t2
   On     t2.CLA_EMPRESA      = t1.CLA_EMPRESA
   And    t2.CLA_PERIODO      = t1.CLA_PERIODO
   Join   #TmpEmpresa      t3
   On     t3.CLA_EMPRESA      = t1.CLA_EMPRESA
   Join   #TmpTipoNom      t4
   On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
   Where  t1.ANIO_MES / 100   = @w_anioPagoPTU;

   Insert Into #tmpNominas
  (CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
   INICIO_PER,       FIN_PER,          ANIO,             NOM_PERIODO,
   TIPO_NOMINA,      NOM_TIPO_NOMINA,  STATUS_NOMINA,    STRING)
   Select Distinct t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,          t1.ANIO_MES,
          t1.INICIO_PER,  t1.FIN_PER,          t1.ANIO_MES / 100 ANIO,
          'ACUM',
          t4.TIPO_NOMINA, t4.NOM_TIPO_NOMINA,  t1.STATUS_NOMINA,
          Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
   From   dbo.RH_FECHA_PER t1
   Join   #TmpPeriodo      t2
   On     t2.CLA_EMPRESA      = t1.CLA_EMPRESA
   And    t2.CLA_PERIODO      = t1.CLA_PERIODO
   Join   #TmpEmpresa      t3
   On     t3.CLA_EMPRESA      = t1.CLA_EMPRESA
   Join   dbo.RH_TIPO_NOMINA     t4
   On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
   Where  t1.ANIO_MES   Between @w_AnioMesIni And  @w_AnioMesFin
   And    Not Exists          ( Select Top 1 1
                                From   #TmpTipoNom
                                Where  TIPO_NOMINA =  t4.TIPO_NOMINA);

--
-- Filtro para Consulta de conceptos de nómina.
--

   Insert Into #tmpPerded
  (CLA_EMPRESA,    CLA_PERDED,      NOM_PERDED, TIPO_PERDED)
   Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED, a.TIPO_PERDED
   From   dbo.RH_PERDED      a
   Join   #TmpEmpresa        b
   On     b.CLA_EMPRESA       = a.CLA_EMPRESA
   Join   dbo.RH_VAR_USUARIO c
   On     c.VALOR_VAR_USUARIO = a.CLA_PERDED
   Where  C.CLA_VAR           = '$prdGSPTU'
   Order  By a.TIPO_PERDED, a.CLA_PERDED;

--
-- Filtro para Consulta de los Trabajadores
--

   Insert Into #TmpTrabajador
  (CLA_RAZON_SOCIAL,  NOM_RAZON_SOCIAL,  CLA_EMPRESA,       NOM_EMPRESA,
   CLA_TRAB,          NOM_TRAB,          FECHA_ING_GRUPO,   FECHA_BAJA,
   STATUS_TRAB,       CLA_PUESTO,        CLA_CLASIFICACION, CLA_UBICACION,
   NOM_UBICACION,     SUELDO_DIA)
   Select b.CLA_RAZON_SOCIAL, a.NOM_RAZON_SOCIAL, b.CLA_EMPRESA, c.NOM_EMPRESA,
          b.CLA_TRAB,
          Concat(Trim(b.NOM_TRAB), ' ', Trim(b.AP_PATERNO), ' ', Trim(b.AP_MATERNO)),
          FECHA_ING_GRUPO,  Isnull(b.FECHA_BAJA, @w_fechaTerminoPTU),  b.STATUS_TRAB,
          b.CLA_PUESTO,
          b.CLA_CLASIFICACION, d.CLA_UBICACION, d.NOM_UBICACION, Max(b.SUELDO_DIA)
   From   dbo.RH_Trab        b
   Join   #TempRazon_Social  a
   On     a.CLA_RAZON_SOCIAL = b.CLA_RAZON_SOCIAL
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
   Join   dbo.RH_ENC_REC_HISTO  h
   On     h.CLA_RAZON_SOCIAL = b.CLA_RAZON_SOCIAL
   And    h.CLA_EMPRESA      = b.CLA_EMPRESA
   And    h.CLA_TRAB         = b.CLA_TRAB
   Join   #tmpNominas           i
   On     i.CLA_EMPRESA      = h.CLA_EMPRESA
   And    i.CLA_PERIODO      = h.CLA_PERIODO
   And    i.NUM_NOMINA       = h.NUM_NOMINA
   And    i.ANIO_MES         = h.ANIO_MES
   And    i.NOM_PERIODO      = 'PTU'
   Join   #tmpRegImss           j
   On     j.CLA_REG_IMSS     = b.CLA_REG_IMSS
   And    j.CLA_EMPRESA      = b.CLA_EMPRESA
   Group  By b.CLA_RAZON_SOCIAL, a.NOM_RAZON_SOCIAL, b.CLA_EMPRESA, c.NOM_EMPRESA,
          b.CLA_TRAB,
          Concat(Trim(b.NOM_TRAB), ' ', Trim(b.AP_PATERNO), ' ', Trim(b.AP_MATERNO)),
          FECHA_ING_GRUPO,  Isnull(b.FECHA_BAJA, @w_fechaTerminoPTU),  b.STATUS_TRAB,
          b.CLA_PUESTO,     b.CLA_CLASIFICACION, d.CLA_UBICACION, d.NOM_UBICACION
   Order  By 1, 2, 3;

--
-- Inicio de Consulta para el reporte.
--

--
-- Acumulados
--

   Insert Into #tmpAcumTrab
  (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA,     NOM_EMPRESA,
   CLA_TRAB,         NOM_TRAB,         STATUS_TRAB,     CLA_PUESTO,
   NOM_PUESTO,       NOM_CATEGORIA,    FECHA_ING_GRUPO, FECHA_BAJA,
   CLA_UBICACION,    NOM_UBICACION,    CLA_PERDED,      NOM_PERDED,
   IMPORTE)
   Select a.CLA_RAZON_SOCIAL, a.NOM_RAZON_SOCIAL,  a.CLA_EMPRESA,     a.NOM_EMPRESA,
          a.CLA_TRAB,         a.NOM_TRAB,          a.STATUS_TRAB,     a.cla_puesto,
          c.NOM_PUESTO,       b.NOM_CLASIFICACION, a.FECHA_ING_GRUPO, a.FECHA_BAJA,
          a.CLA_UBICACION,    a.NOM_UBICACION,     e.CLA_PERDED,      g.NOM_PERDED,
          Sum(e.importe)
   From   #TmpTrabajador       a
   Join   dbo.RH_CLASIFICACION b
   On     b.CLA_EMPRESA       = a.CLA_EMPRESA
   And    b.CLA_CLASIFICACION = a.CLA_CLASIFICACION
   Join   dbo.rh_Puesto        c
   On     c.CLA_EMPRESA       = a.CLA_EMPRESA
   And    c.CLA_PUESTO        = a.CLA_PUESTO
   Join   dbo.RH_ENC_REC_HISTO  d
   On     d.CLA_RAZON_SOCIAL  = a.CLA_RAZON_SOCIAL
   And    d.CLA_EMPRESA       = a.CLA_EMPRESA
   And    d.CLA_TRAB          = a.CLA_TRAB
   Join   dbo.RH_DET_REC_HISTO e
   On     e.CLA_TRAB          = d.CLA_TRAB
   And    e.CLA_EMPRESA       = d.CLA_EMPRESA
   And    e.ANIO_MES          = d.ANIO_MES
   And    e.NUM_NOMINA        = d.NUM_NOMINA
   And    e.CLA_PERIODO       = d.CLA_PERIODO
   And    e.importe           != 0
   Join   #tmpNominas           f
   On     f.CLA_EMPRESA       = d.CLA_EMPRESA
   And    f.CLA_PERIODO       = d.CLA_PERIODO
   And    f.NUM_NOMINA        = d.NUM_NOMINA
   And    f.ANIO_MES          = d.ANIO_MES
   And    f.NOM_PERIODO       = 'ACUM'
   Join   #tmpPerded            g
   On     g.CLA_EMPRESA       = e.CLA_EMPRESA
   And    g.CLA_PERDED        = e.CLA_PERDED
   Group  By a.CLA_RAZON_SOCIAL, a.NOM_RAZON_SOCIAL,  a.CLA_EMPRESA,     a.NOM_EMPRESA,
             a.CLA_TRAB,         a.NOM_TRAB,          a.STATUS_TRAB,     a.cla_puesto,
             c.NOM_PUESTO,       b.NOM_CLASIFICACION, a.FECHA_ING_GRUPO, a.FECHA_BAJA,
             a.CLA_UBICACION,    a.NOM_UBICACION,     e.CLA_PERDED,      g.NOM_PERDED;

--
-- Inicio de Presentación de Reporte.
--

   Insert Into #tmpResultado
  (CLA_TRAB,   NOM_TRAB, ESTATUS, PUESTO,
   CATEGORIA,  INGRESO,  UBICACION)
   Select Distinct CLA_TRAB, NOM_TRAB,        STATUS_TRAB,   NOM_PUESTO,
          NOM_CATEGORIA,     FECHA_ING_GRUPO, NOM_UBICACION
   From   #tmpAcumTrab
   Order  by CLA_TRAB;

--
-- Consulta a las columnas.
--

   Set @w_columnas  = 'Update #tmpResultado Set TOTAL_GRAL = 0 ';

   Set @w_columnas2 = 'Update #tmpResultado Set ';
 
   Declare
      C_Conceptos Cursor For
      Select Distinct CLA_PERDED, Concat(Format (CLA_PERDED, '###00'),'-', Substring(NOM_PERDED, 1, 25))
      From   #tmpAcumTrab a
      Order  By CLA_PERDED;

   Begin
      Open C_Conceptos
      While @@Fetch_Status < 1
      Begin
         Fetch C_Conceptos Into @w_cla_perded, @w_colPerded
         If  @@Fetch_Status != 0
             Begin
                Break
             End

          Set @w_sql = Concat('Alter Table #tmpResultado Add "', trim(@w_colPerded),
                                   '" Decimal (18, 2) Not Null Default 0')
          Execute(@w_sql)
          If @@Error != 0
             Begin
                Select @w_sql
                Break
             End

          Set @w_sql = Concat('Update #tmpResultado Set "', trim(@w_colPerded),
                                   '" = Isnull((Select Sum(Importe) ',
                                        'From   #tmpAcumTrab ',
                                        'Where  CLA_TRAB   = a.CLA_TRAB ',
                                        'And    CLA_PERDED = ', @w_cla_perded, '), 0)',
                              'From  #tmpResultado a ')

          Execute(@w_sql)

          Set @w_columnas  = Concat(@w_columnas, ' + "', trim(@w_colPerded), '"');

          Set @w_columnas2 = Concat(@w_columnas2, '  "', trim(@w_colPerded), '" = Abs("',
                                    trim(@w_colPerded), '"), ');
     End
     Close      C_Conceptos
     Deallocate C_Conceptos

   End


   Set @w_sql = 'Alter Table #tmpResultado Add TOTAL_GRAL Decimal (18, 2) Not Null Default 0';
   Execute (@w_sql);

   Set @w_sql = Concat('Alter Table #tmpResultado Add DIAS INTEGER Not Null Default ', @w_dias_prom)
   Execute (@w_sql);

   Set @w_sql = 'Alter Table #tmpResultado Add SALARIO_PROMEDIO Decimal (18, 2) Not Null Default 0';
   Execute (@w_sql);

   Execute (@w_columnas);

   Set @w_columnas2 = Substring(trim(@w_columnas2), 1, Len(@w_columnas2) -1);

   Execute (@w_columnas2);

   Select Top 1 @w_status_nomina = STATUS_NOMINA,
                @w_num_nomina    = NUM_NOMINA
   From   #tmpNominas
   Where  NOM_TIPO_NOMINA ='GRATIFICACION ESPECIAL';

   If @w_status_nomina = 9
      Begin
         Insert Into #TmpSalarioProm
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED,
         IMPORTE)
         Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED,
                Sum(e.importe)
         From   #TmpTrabajador       a
         Join   dbo.RH_ENC_REC_HISTO  d
         On     d.CLA_RAZON_SOCIAL  = a.CLA_RAZON_SOCIAL
         And    d.CLA_EMPRESA       = a.CLA_EMPRESA
         And    d.CLA_TRAB          = a.CLA_TRAB
         Join   dbo.RH_DET_REC_HISTO e
         On     e.CLA_TRAB          = d.CLA_TRAB
         And    e.CLA_EMPRESA       = d.CLA_EMPRESA
         And    e.ANIO_MES          = d.ANIO_MES
         And    e.NUM_NOMINA        = d.NUM_NOMINA
         And    e.CLA_PERIODO       = d.CLA_PERIODO
         And    e.cla_perded        = 10213
         Join   #tmpNominas           f
         On     f.CLA_EMPRESA       = d.CLA_EMPRESA
         And    f.CLA_PERIODO       = d.CLA_PERIODO
         And    f.NUM_NOMINA        = d.NUM_NOMINA
         And    f.ANIO_MES          = d.ANIO_MES
         And    f.NOM_PERIODO       = 'PTU'
         And    f.NUM_NOMINA        = @w_num_nomina
         Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED;

         Insert Into #TmpCifrasNomEsp
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED,
         IMPORTE)
         Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED,
                Sum(e.importe)
         From   #TmpTrabajador       a
         Join   dbo.RH_ENC_REC_HISTO  d
         On     d.CLA_RAZON_SOCIAL  = a.CLA_RAZON_SOCIAL
         And    d.CLA_EMPRESA       = a.CLA_EMPRESA
         And    d.CLA_TRAB          = a.CLA_TRAB
         Join   dbo.RH_DET_REC_HISTO e
         On     e.CLA_TRAB          = d.CLA_TRAB
         And    e.CLA_EMPRESA       = d.CLA_EMPRESA
         And    e.ANIO_MES          = d.ANIO_MES
         And    e.NUM_NOMINA        = d.NUM_NOMINA
         And    e.CLA_PERIODO       = d.CLA_PERIODO
         And    e.cla_perded       In (10215, 10216, 1021)
         Join   #tmpNominas           f
         On     f.CLA_EMPRESA       = d.CLA_EMPRESA
         And    f.CLA_PERIODO       = d.CLA_PERIODO
         And    f.NUM_NOMINA        = d.NUM_NOMINA
         And    f.ANIO_MES          = d.ANIO_MES
         And    f.NOM_PERIODO       = 'PTU'
         And    f.NUM_NOMINA        = @w_num_nomina
         Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED;

      End

   If @w_status_nomina = 1
      Begin
         Insert Into #TmpSalarioProm
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED,
         IMPORTE)
         Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED,
                Sum(e.Importe)
         From   #TmpTrabajador       a
         Join   dbo.RH_ENC_REC_ACTUAL  d
         On     d.CLA_RAZON_SOCIAL  = a.CLA_RAZON_SOCIAL
         And    d.CLA_EMPRESA       = a.CLA_EMPRESA
         And    d.CLA_TRAB          = a.CLA_TRAB
         Join   dbo.RH_DET_REC_ACTUAL e
         On     e.CLA_TRAB          = d.CLA_TRAB
         And    e.CLA_EMPRESA       = d.CLA_EMPRESA
         And    e.NUM_NOMINA        = d.NUM_NOMINA
         And    e.CLA_PERIODO       = d.CLA_PERIODO
         And    e.FOLIO_NOM         = d.FOLIO_NOM
         And    e.cla_perded        = 10213
         Join   #tmpNominas           f
         On     f.CLA_EMPRESA       = d.CLA_EMPRESA
         And    f.CLA_PERIODO       = d.CLA_PERIODO
         And    f.NUM_NOMINA        = d.NUM_NOMINA
         And    f.ANIO_MES          = d.ANIO_MES_ISPT
         And    f.NOM_PERIODO       = 'PTU'
         And    f.NUM_NOMINA        = @w_num_nomina
         Group  BY a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED;

         Insert Into #TmpCifrasNomEsp
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED,
         IMPORTE)
         Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED,
                Sum(e.Importe)
         From   #TmpTrabajador       a
         Join   dbo.RH_ENC_REC_ACTUAL  d
         On     d.CLA_RAZON_SOCIAL  = a.CLA_RAZON_SOCIAL
         And    d.CLA_EMPRESA       = a.CLA_EMPRESA
         And    d.CLA_TRAB          = a.CLA_TRAB
         Join   dbo.RH_DET_REC_ACTUAL e
         On     e.CLA_TRAB          = d.CLA_TRAB
         And    e.CLA_EMPRESA       = d.CLA_EMPRESA
         And    e.NUM_NOMINA        = d.NUM_NOMINA
         And    e.CLA_PERIODO       = d.CLA_PERIODO
         And    e.FOLIO_NOM         = d.FOLIO_NOM
         And    e.cla_perded       In (10215, 10216, 1021)
         Join   #tmpNominas           f
         On     f.CLA_EMPRESA       = d.CLA_EMPRESA
         And    f.CLA_PERIODO       = d.CLA_PERIODO
         And    f.NUM_NOMINA        = d.NUM_NOMINA
         And    f.ANIO_MES          = d.ANIO_MES_ISPT
         And    f.NOM_PERIODO       = 'PTU'
         And    f.NUM_NOMINA        = @w_num_nomina
         Group  BY a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED;

      End

   Update #tmpResultado
   Set    SALARIO_PROMEDIO = (Select Importe
                              From   #TmpSalarioProm
                              Where  cla_trab = a.cla_trab)
   From   #tmpResultado a
   Where  Exists             (Select Top 1 1
                              From   #TmpSalarioProm
                              Where  cla_trab = a.cla_trab)

--
-- Datos de la Nómina PTU.
--

   Select Top 1 @w_status_nomina = STATUS_NOMINA,
                @w_num_nomina    = num_nomina
   From   #tmpNominas
   Where  NOM_TIPO_NOMINA = 'PTU';

--
-- Datos de la Nómina PTU.
--

   Insert Into #TmpCifrasPTU
  (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED,
   IMPORTE)
   Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED,
          Sum(e.importe)
   From   #TmpTrabajador       a
   Join   dbo.RH_ENC_REC_HISTO  d
   On     d.CLA_RAZON_SOCIAL  = a.CLA_RAZON_SOCIAL
   And    d.CLA_EMPRESA       = a.CLA_EMPRESA
   And    d.CLA_TRAB          = a.CLA_TRAB
   Join   dbo.RH_DET_REC_HISTO e
   On     e.CLA_TRAB          = d.CLA_TRAB
   And    e.CLA_EMPRESA       = d.CLA_EMPRESA
   And    e.ANIO_MES          = d.ANIO_MES
   And    e.NUM_NOMINA        = d.NUM_NOMINA
   And    e.CLA_PERIODO       = d.CLA_PERIODO
   And    e.cla_perded       In (10601, 10602, 1060)
   Join   #tmpNominas           f
   On     f.CLA_EMPRESA       = d.CLA_EMPRESA
   And    f.CLA_PERIODO       = d.CLA_PERIODO
   And    f.NUM_NOMINA        = d.NUM_NOMINA
   And    f.ANIO_MES          = d.ANIO_MES
   And    f.NOM_PERIODO       = 'PTU'
   And    f.NUM_NOMINA        = @w_num_nomina
   Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB, e.CLA_PERDED;

   Declare
      C_Conceptos Cursor For
      Select Distinct 1, a.CLA_PERDED, Concat(Format (a.CLA_PERDED, '###00'),'-', Substring(b.NOM_PERDED, 1, 25))
      From   #TmpCifrasPTU a
      Join   dbo.RH_PERDED b
      On     b.CLA_EMPRESA  = a.CLA_EMPRESA
      And    b.CLA_PERDED   = a.CLA_PERDED
      Where  a.IMPORTE     != 0
      And    a.cla_perded  != 1060
      Union
      Select Distinct 2, a.CLA_PERDED, Concat(Format (a.CLA_PERDED, '###00'),'-', Substring(b.NOM_PERDED, 1, 25))
      From   #TmpCifrasPTU a
      Join   dbo.RH_PERDED b
      On     b.CLA_EMPRESA  = a.CLA_EMPRESA
      And    b.CLA_PERDED   = a.CLA_PERDED
      Where  a.IMPORTE     != 0
      And    a.cla_perded   = 1060
      Order  By 1, 2;

   Begin
      Open C_Conceptos
      While @@Fetch_Status < 1
      Begin
         Fetch C_Conceptos Into @w_secuencia, @w_cla_perded, @w_colPerded
         If  @@Fetch_Status != 0
             Begin
                Break
             End

          Set @w_sql = Concat('Alter Table #tmpResultado Add "', trim(@w_colPerded),
                                   '" Decimal (18, 2) Not Null Default 0')
          Execute(@w_sql)
          If @@Error != 0
             Begin
                Select @w_sql
                Break
             End

          Set @w_sql = Concat('Update #tmpResultado Set "', trim(@w_colPerded),
                                   '" = Isnull((Select Sum(Importe) ',
                                        'From   #TmpCifrasPTU ',
                                        'Where  CLA_TRAB   = a.CLA_TRAB ',
                                        'And    CLA_PERDED = ', @w_cla_perded, '), 0)',
                              'From  #tmpResultado a ')

          Execute(@w_sql)


     End
     Close      C_Conceptos
     Deallocate C_Conceptos

   End

   Delete  #tmpResultado
   Where  "10601-PTU DIAS" = 0

   Declare
      C_Conceptos Cursor For
      Select   Distinct a.CLA_PERDED, Concat(Format(a.CLA_PERDED, '###00'), '-', Substring(b.NOM_PERDED, 1, 25))
      From     #TmpCifrasNomEsp a
      Join     dbo.RH_PERDED b
      On       b.CLA_EMPRESA  = a.CLA_EMPRESA
      And      b.CLA_PERDED   = a.CLA_PERDED
      Where    a.IMPORTE     != 0
	  Order    By 2

   Begin
      Open C_Conceptos
      While @@Fetch_Status < 1
      Begin
         Fetch C_Conceptos Into @w_cla_perded, @w_colPerded
         If  @@Fetch_Status != 0
             Begin
                Break
             End

          Set @w_sql = Concat('Alter Table #tmpResultado Add "', trim(@w_colPerded),
                                   '" Decimal (18, 2) Not Null Default 0')
          Execute(@w_sql)
          If @@Error != 0
             Begin
                Select @w_sql
                Break
             End

          Set @w_sql = Concat('Update #tmpResultado Set "', trim(@w_colPerded),
                                   '" = Isnull((Select Sum(Importe) ',
                                        'From   #TmpCifrasNomEsp ',
                                        'Where  CLA_TRAB   = a.CLA_TRAB ',
                                        'And    CLA_PERDED = ', @w_cla_perded, '), 0)',
                              'From  #tmpResultado a ')

          Execute(@w_sql)

     End
     Close      C_Conceptos
     Deallocate C_Conceptos

   End

   Select @w_idTabla   = OBJECT_ID('tempdb.dbo.#tmpResultado'),
          @w_secuencia = 0;

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
         Set @w_columnas = Concat(@w_columnas, ', "', @w_columna,'"');

Siguiente:

      End
      Close      C_ColumnasRep
      Deallocate C_ColumnasRep

   End

   Select @w_insert   = @w_insert + ')',
          @w_columnas = Concat(@w_columnas, ' ',
                       'From  #tmpResultado ',
                       'Order By CLA_TRAB')

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
