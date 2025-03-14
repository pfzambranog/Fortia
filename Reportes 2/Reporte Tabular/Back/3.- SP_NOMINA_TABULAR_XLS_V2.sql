--Execute dbo.SP_NOMINA_TABULAR_XLS_V2 @PnCla_RazonSocial      = 1,
--                                     @PsCla_Empresa          = Null,
--                                     @PsCla_Ubicacion        = Null,
--                                     @PsCla_CentroCosto      = Null,
--                                     @PsCla_Depto            = Null,
--                                     @PsCla_Puestos          = Null,
--                                     @PsCla_RegImss          = Null,
--                                     @PsCla_Trab             = Null,
--                                     @PsNominas              = Null,
--                                     @PsCla_TipoNom          = Null,
--                                     @PsCla_Perded           = Null,
--                                     @PsCla_Periodo          = Null,
--                                     @PsStatusNom            = '9',
--                                     @PnAnio                 = 2025,
--                                     @PnMesIni               = 1,
--                                     @PnMesFin               = 4,
--                                     @PnTipoConcepto         = 0,
--                                     @PbMostrarProv          = 1,
--                                     @MostrarMonto           = 0,
--                                     @MostrarGravExen        = 0,
--                                     @ClaUniNeg              = 0,
--                                     @PnClaUsuario           = 3,
--                                     @MostrarGravImss        = 0,
--                                     @PbMostrarTodos         = 1,
--                                     @DetalladoXNom          = 1,
--                                     @IncluirNomAbiertas     = 1


Create Or Alter Procedure dbo.SP_NOMINA_TABULAR_XLS_V2
  (@PnCla_RazonSocial        Integer,
   @PsCla_Empresa            Varchar(Max)   = Null,
   @PsCla_Ubicacion          Varchar(Max)   = Null,
   @PsCla_CentroCosto        Varchar(Max)   = Null,
   @PsCla_Depto              Varchar(Max)   = Null,
   @PsCla_RegImss            Varchar(Max)   = Null,
   @PsNominas                Varchar(Max)   = Null,
   @PsCla_TipoNom            Varchar(Max)   = Null,
   @PsCla_Periodo            Varchar(Max)   = Null,
   @PsCla_Trab               Varchar(Max)   = Null,
   @PsCla_Perded             Varchar(Max)   = Null,
   @PsCla_Puestos            Varchar(Max)   = Null,
   @PsStatusNom              Varchar(Max)   = Null,
   @PnClaUsuario             Integer,
   @ClaUniNeg                Integer,
   @PnAnio                   Integer,
   @PnMesIni                 Integer        = 0,
   @PnMesFin                 Integer        = 0,
   @PnTipoConcepto           Integer,
   @MostrarMonto             Integer,
   @MostrarGravExen          Integer,
   @MostrarGravImss          Integer,
   @PbMostrarTodos           Integer,
   @PbMostrarProv            Integer,
   @DetalladoXNom            Integer,
   @IncluirNomAbiertas       Integer,
   @PnError                  Integer        = 0    Output,
   @PsMensaje                Varchar( 250)  = Null Output)
AS

Declare
   @w_desc_error             Varchar(250),
   @w_nom_razon_social       Varchar(350),
   @PnAnioMesIni             Integer,
   @PnAnioMesFin             Integer,
   @IdEnc                    Integer,
   @w_IdEnc                  Integer,
   @OrdenMin                 Integer,
   @Id                       Integer,
   @w_colIniciales           Integer,
   @NumCamposMin             Integer,
   @NumCamposMax             Integer,
   @w_registro               Integer,
   @ClaveConcepto            Varchar(Max),
   @ColumnaMonto             Varchar(Max),
   @ColumnaNombre            Varchar(Max),
   @ColumnaGravado           Varchar(Max),
   @ColumnaExento            Varchar(Max),
   @ColumnaGravImss          Varchar(Max),
   @AlterColumnaMonto        Varchar(Max),
   @AlterColumnaNombre       Varchar(Max),
   @AlterColumnaGravado      Varchar(Max),
   @AlterColumnaExento       Varchar(Max),
   @AlterColumnaGravImss     Varchar(Max),
   @Select                   Varchar(Max),
   @SelectCampos             Varchar(Max),
   @SelectColumna            Varchar(Max),
--
   @w_cla_perded             Integer,
   @w_update                 Varchar(Max),
   @w_update2                Varchar(Max),
   @w_ColInsert              Varchar(Max),
   @w_NomPerded              Varchar(Max),
   @w_groupBy                Varchar(Max),
   @w_groupBy2               Varchar(Max),
   @w_comilla                Char(1),
   @w_columna                Sysname,
   @w_columna2               Sysname,
   @w_campo                  Sysname,
   @w_secuencia              Integer,
   @w_posicion               Integer,
   @w_Error                  Integer,
   @w_sql                    Nvarchar(1500),
   @w_para                   Nvarchar( 750);

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off
   Set Ansi_Warnings Off
   Set Ansi_Padding  On

   Select @PnAnioMesIni = Case When @PnMesIni > 0
                               Then (@PnAnio * 100) + @PnMesIni
                               Else (@PnAnio * 100) + 1
                          End,
         @PnAnioMesFin  = Case When @PnMesFin > 0
                               Then (@PnAnio * 100) + @PnMesFin
                               Else (@PnAnio * 100) + 12
                          End,
        @w_secuencia    = 0,
        @w_comilla      = Char(39),
        @w_NomPerded    = '',
        @w_ColInsert    = 'Select ',
        @ColumnaNombre  = 'Insert Into tmpFinal (',
        @SelectColumna  = 'Select ',
        @SelectCampos   = 'Select ',
        @w_update       = 'Update tmpFinal Set ',
        @w_groupBy      = ' Group By ',
        @w_groupBy2     = ' Group By ';
--
-- Validaciones de Parametros de Entrada.
--

   Select @w_nom_razon_social = Concat(nom_razon_social, ' - ', rfc_emp)
   From   dbo.rh_razon_social
   Where  cla_razon_social = @PnCla_RazonSocial;
   If @@Rowcount = 0
      Begin
         Select @PnError   = 1,
                @PsMensaje = 'La Razón Social Seleccionada no es Válida'

         Select @PnError IdError, @PsMensaje Error
         Set Xact_Abort Off
         Return
      End

  If Isnull(@PnMesIni, 0) != 0  And
     Isnull(@PnMesFin, 0) != 0
      Begin
         If @PnMesIni > @PnMesFin
            Begin
               Select @PnError   = 2,
                      @PsMensaje = 'El mes Final No Debe ser Menor al Mes Inicial'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Creación de tablas temporales.
--

-- Tabla Temporal de Empresa.

   Create Table #TempEmpresa
  (CLA_RAZON_SOCIAL  Integer      Not Null,
   CLA_EMPRESA       Integer      Not Null,
   NOM_EMPRESA       Varchar(120) Not Null,
   Constraint TempEmpresaPk
   Primary Key (CLA_EMPRESA, CLA_RAZON_SOCIAL));


--
-- Tabla Temporal de Ubicación.
--

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
-- Tabla Temporal de Puestos.
--

   Create Table #tmpPuesto
  (CLA_EMPRESA Integer       Not Null,
   CLA_PUESTO  Integer       Not Null,
   NOM_PUESTO  Varchar(250)  Not Null,
   Constraint tmpPuestoPk
   Primary Key (CLA_EMPRESA, CLA_PUESTO));

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
-- Tabla Temporal de Períodos.
--

   Create Table #tempPeriodo
  (CLA_EMPRESA  Integer       Not Null,
   CLA_PERIODO  Integer       Not Null,
   NOM_PERIODO  Varchar(100)  Not Null,
   Constraint tempPeriodoPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO));

--
-- Tabla Temporal de Tipos de Nómina.
--

   Create Table #tempTipoNom
  (TIPO_NOMINA            Integer       Not Null,
   NOM_TIPO_NOMINA        Varchar(100)  Not Null,
   Constraint tempTipoNomPk
   Primary Key (TIPO_NOMINA));

--
-- Tabla Temporal de Trabajadores.
--

   Create Table #tmpTrabNombres
  (CLA_TRAB               Integer        Not Null,
   CLA_EMPRESA            Integer        Not Null,
   NOM_TRAB               Varchar( 40)       Null,
   AP_PATERNO             Varchar( 30)       Null,
   AP_MATERNO             Varchar( 30)       Null,
   NOMBRE                 Varchar(200)       Null,
   NSS                    Varchar( 20)       Null,
   CURP                   Varchar( 20)       Null,
   RFC                    Varchar( 20)       Null,
   FECHA_ING              Varchar( 10)       Null,
   FECHA_ING_GRUPO        Varchar( 10)       Null,
   FECHA_INI_DESCINF      Date               Null,
   FECHA_SUSP_DESC_INF    Date               Null,
   CTA_BANCO              Varchar(20)        Null,
   SINDICALIZADO          Varchar(20)        Null,
   CLA_BANCO              Integer            Null,
   TIPO_SALARIO           Varchar(20)        Null,
   Constraint tmpTrabNombresPk
   Primary Key (CLA_EMPRESA, CLA_TRAB));

--
-- Tabla Temporal de Estatus de Nómina.
--

   Create Table #TmpEstatusNomina
  (idEstatus    Integer Not Null Primary Key);


   Create  Table #ColumnasNoAplica
  (NomColumna    Varchar(Max));

   Create Table #ColumnasNoAplica2
  (CLA_PERDED        Integer Not Null Primary Key);

   Create Table #ColumnasNoImprimir
  (campo        Sysname Not Null Primary Key);

   Create  Table #tmpPerded
  (Id                Integer Not Null Identity (1, 1) Primary Key,
   CLA_PERDED        Integer,
   CLA_EMPRESA       Integer,
   NOM_PERDED        Varchar(Max),
   TIPO_PERDED       Integer,
   CLASIFICACION     Integer,
   ES_PROVISION      Integer,
   ESBASE_IMSS       Integer,
   NO_AFECTAR_NETO   Integer,
   ESBASE_ISPT       Integer,
   ORDEN             Integer,
   MOSTRAR_MONTO     Varchar(Max),
   Index tmpPerdedIdx01 (CLA_EMPRESA,CLA_PERDED));

   Create  Table #tempPerded
  (Id                Integer Not Null Identity (1, 1) Primary Key,CLA_PERDED        Integer,
   CLA_EMPRESA       Integer,
   NOM_PERDED        Varchar(Max),
   TIPO_PERDED       Integer,
   Index I_tempPerdedIdx01 (CLA_EMPRESA, CLA_PERDED));

   Create Table #tempProvisiones
  (cla_empresa      Integer      Not Null,
   cla_perded       Integer      Not Null,
   nom_perded       Varchar(100)     Null
   Constraint tempProvisionesPk
   Primary Key (CLA_EMPRESA, CLA_PERDED));

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
   STRING           Varchar(Max) Not Null,
   Index I_tmpNominasIdx01 (CLA_EMPRESA, CLA_PERIODO, NUM_NOMINA));

   Create Table #tmpRoll
  (CLA_EMPRESA       Integer        Not Null,
   CLA_ROLL          Integer        Not Null,
   NOM_ROLL          Varchar(100)   Not Null,
   Constraint tmpRollPk
   Primary Key (CLA_EMPRESA, CLA_ROLL))

   Create Table  #tmpTabSue
  (CLA_EMPRESA       Integer        Not Null,
   CLA_TAB_SUE       Integer        Not Null,
   NOM_TAB_SUE       Varchar(100)   Not Null,
   Constraint  tmpTabSuePk
   Primary Key (CLA_EMPRESA, CLA_TAB_SUE))

   Create Table  #DIAS_POR_PAGAR
  (CLA_EMPRESA       Integer        Not Null,
   CLA_TRAB          Integer        Not Null,
   CLA_PERIODO       Integer        Not Null,
   NUM_NOMINA        Integer        Not Null,
   ANIO_MES          Integer        Not Null,
   DIAS_POR_PAGAR    Decimal(18, 2) Not Null,
   Index DIAS_POR_PAGARIDX01 (cla_empresa, CLA_TRAB, CLA_PERIODO, NUM_NOMINA, ANIO_MES));

   If dbo.Fn_existe_tabla ('tmpPagosConceptos') = 1
      Begin
         Drop Table tmpPagosConceptos;
      End

   Create Table tmpPagosConceptos
  (CLA_TRAB           Integer           Not Null,
   NOM_TRAB           Varchar(300)      Not Null Default Char(32),
   CLA_EMPRESA        Integer           Not Null,
   NOM_EMPRESA        Varchar(120)      Not Null Default Char(32),
   CLA_PERIODO        Integer           Not Null,
   NUM_NOMINA         Integer           Not Null,
   ANIO_MES           Integer           Not Null,
   FECHA_ING          Varchar( 10)      Not Null Default Char(32),
   FECHA_ING_GRUPO    Varchar( 10)      Not Null Default Char(32),
   NSS                Varchar( 20)      Not Null Default Char(32),
   RFC                Varchar( 20)      Not Null Default Char(32),
   NOM_AREA           Varchar(120)      Not Null Default Char(32),
   CLA_UBICACION      Integer           Not Null,
   NOM_UBICACION      Varchar(150)          Null Default Char(32),
   CLA_CENTRO_COSTO   Integer           Not Null,
   NOM_CENTRO_COSTO   Varchar(150)          Null Default Char(32),
   CLA_DEPTO          Integer           Not Null,
   NOM_DEPTO          Varchar(150)          Null Default Char(32),
   TIPO_COMPANIERO    Varchar( 60)      Not Null Default Char(32),
   INICIO_PER         Varchar( 10)          Null Default Char(32),
   FIN_PER            Varchar( 10)          Null Default Char(32),
   SUE_DIA            Varchar( 30)          Null Default Char(32),
   SUE_INT            Varchar( 30)          Null Default Char(32),
   TOT_PER            Varchar( 30)          Null Default Char(32),
   TOT_DED            Varchar( 30)          Null Default Char(32),
   TOT_NETO           Varchar( 30)          Null Default Char(32),
   DIAS_POR_PAGAR     Varchar( 30)          Null Default Char(32),
   Corte_rep          Bit               Not Null Default 1,
   CLA_PERDED         Integer           Not Null Default 0,
   NOM_PERDED         Varchar(150)          Null Default Char(32),
   MONTO              Decimal(18, 2),
   IMPORTE            Decimal(18, 2),
   EXENTO             Decimal(18, 2),
   GRAVADO            Decimal(18, 2),
   GRAV_IMSS          Decimal(18, 2),
   ACUMULADO          Decimal(18, 2),
   TIPO_PERDED        Integer,
   ES_PROVISION       Integer,
   ESBASE_IMSS        Integer,
   NO_AFECTAR_NETO    Integer,
   ESBASE_ISPT        Integer,
   CLA_RAZON_SOCIAL   Integer,
   ORDEN              Integer,
   LINEA              Integer          Not Null Default 1,
   Index  tmpPagosConceptosIdx01 (CLA_TRAB, CLA_EMPRESA, CLA_PERIODO, NUM_NOMINA, ANIO_MES));

   Set @IdEnc = Object_id('tmpPagosConceptos');

   Create Table #tmpNominasTrab
  (CLA_TRAB          Integer            Null,
   NOM_TRAB          Varchar(150)       Null,
   FECHA_ING         Varchar( 10)       Null,
   FECHA_ING_GRUPO   Varchar( 10)       Null,
   NSS               Varchar( 20)       Null,
   RFC               Varchar( 20)       Null,
   CLA_EMPRESA       Integer        Not Null,
   CLA_RAZON_SOCIAL  Integer        Not Null,
   CLA_PERIODO       Integer        Not Null,
   NUM_NOMINA        Integer        Not Null,
   NOM_AREA          Varchar(150)       Null,
   CLA_UBICACION     Integer        Not Null,
   NOM_UBICACION     Varchar(150)       Null,
   CLA_CENTRO_COSTO  Integer        Not Null,
   NOM_CENTRO_COSTO  Varchar(150)       Null,
   CLA_DEPTO         Integer        Not Null,
   NOM_DEPTO         Varchar(150)       Null,
   NOM_PUESTO        Varchar(150)       Null,
   NOM_PERIODO       Varchar(150)       Null,
   TIPO_COMPANIERO   Varchar(150)       Null,
   ANIO_MES          Integer            Null,
   INICIO_PER        Varchar( 10)       Null,
   FIN_PER           Varchar( 10)       Null,
   SUE_DIA           Decimal(18, 2) Not Null Default 0,
   SUE_INT           Decimal(18, 2) Not Null Default 0,
   TOT_PER           Decimal(18, 2) Not Null Default 0,
   TOT_DED           Decimal(18, 2) Not Null Default 0,
   TOT_NETO          Decimal(18, 2) Not Null Default 0,
   DIAS_POR_PAGAR    Decimal(18, 2)     Null Default 0,
   Index tmpNominasTrabIdx01 (CLA_EMPRESA, CLA_PERIODO, CLA_TRAB, ANIO_MES, NUM_NOMINA));

--
-- Tabla Temporal de Salida.
--

   If dbo.Fn_existe_tabla ('tmpFinal') = 1
      Begin
         Drop Table tmpFinal;
      End

   Create Table tmpFinal
  (Concecutivo   Integer Not Null Identity (1, 1) Primary Key,
   Columna001    Varchar(500),
   Columna002    Varchar(500),
   Columna003    Varchar(500),
   Columna004    Varchar(500),
   Columna005    Varchar(500),
   Columna006    Varchar(500),
   Columna007    Varchar(500),
   Columna008    Varchar(500),
   Columna009    Varchar(500),
   Columna010    Varchar(500),
   Columna011    Varchar(500),
   Columna012    Varchar(500),
   Columna013    Varchar(500),
   Columna014    Varchar(500),
   Columna015    Varchar(500),
   Columna016    Varchar(500),
   Columna017    Varchar(500),
   Columna018    Varchar(500),
   Columna019    Varchar(500),
   Columna020    Varchar(500),
   Columna021    Varchar(500),
   Columna022    Varchar(500),
   Columna023    Varchar(500),
   Columna024    Varchar(500),
   Columna025    Varchar(500),
   Columna026    Varchar(500),
   Columna027    Varchar(500),
   Columna028    Varchar(500),
   Columna029    Varchar(500),
   Columna030    Varchar(500),
   Columna031    Varchar(500),
   Columna032    Varchar(500),
   Columna033    Varchar(500),
   Columna034    Varchar(500),
   Columna035    Varchar(500),
   Columna036    Varchar(500),
   Columna037    Varchar(500),
   Columna038    Varchar(500),
   Columna039    Varchar(500),
   Columna040    Varchar(500),
   Columna041    Varchar(500),
   Columna042    Varchar(500),
   Columna043    Varchar(500),
   Columna044    Varchar(500),
   Columna045    Varchar(500),
   Columna046    Varchar(500),
   Columna047    Varchar(500),
   Columna048    Varchar(500),
   Columna049    Varchar(500),
   Columna050    Varchar(500),
   Columna051    Varchar(500),
   Columna052    Varchar(500),
   Columna053    Varchar(500),
   Columna054    Varchar(500),
   Columna055    Varchar(500),
   Columna056    Varchar(500),
   Columna057    Varchar(500),
   Columna058    Varchar(500),
   Columna059    Varchar(500),
   Columna060    Varchar(500),
   Columna061    Varchar(500),
   Columna062    Varchar(500),
   Columna063    Varchar(500),
   Columna064    Varchar(500),
   Columna065    Varchar(500),
   Columna066    Varchar(500),
   Columna067    Varchar(500),
   Columna068    Varchar(500),
   Columna069    Varchar(500),
   Columna070    Varchar(500),
   Columna071    Varchar(500),
   Columna072    Varchar(500),
   Columna073    Varchar(500),
   Columna074    Varchar(500),
   Columna075    Varchar(500),
   Columna076    Varchar(500),
   Columna077    Varchar(500),
   Columna078    Varchar(500),
   Columna079    Varchar(500),
   Columna080    Varchar(500),
   Columna081    Varchar(500),
   Columna082    Varchar(500),
   Columna083    Varchar(500),
   Columna084    Varchar(500),
   Columna085    Varchar(500),
   Columna086    Varchar(500),
   Columna087    Varchar(500),
   Columna088    Varchar(500),
   Columna089    Varchar(500),
   Columna090    Varchar(500),
   Columna091    Varchar(500),
   Columna092    Varchar(500),
   Columna093    Varchar(500),
   Columna094    Varchar(500),
   Columna095    Varchar(500),
   Columna096    Varchar(500),
   Columna097    Varchar(500),
   Columna098    Varchar(500),
   Columna099    Varchar(500),
   Columna100    Varchar(500),
   Columna101    Varchar(500),
   Columna102    Varchar(500),
   Columna103    Varchar(500),
   Columna104    Varchar(500),
   Columna105    Varchar(500),
   Columna106    Varchar(500),
   Columna107    Varchar(500),
   Columna108    Varchar(500),
   Columna109    Varchar(500),
   Columna110    Varchar(500),
   Columna111    Varchar(500),
   Columna112    Varchar(500),
   Columna113    Varchar(500),
   Columna114    Varchar(500),
   Columna115    Varchar(500),
   Columna116    Varchar(500),
   Columna117    Varchar(500),
   Columna118    Varchar(500),
   Columna119    Varchar(500),
   Columna120    Varchar(500),
   Columna121    Varchar(500),
   Columna122    Varchar(500),
   Columna123    Varchar(500),
   Columna124    Varchar(500),
   Columna125    Varchar(500),
   Columna126    Varchar(500),
   Columna127    Varchar(500),
   Columna128    Varchar(500),
   Columna129    Varchar(500),
   Columna130    Varchar(500),
   Columna131    Varchar(500),
   Columna132    Varchar(500),
   Columna133    Varchar(500),
   Columna134    Varchar(500),
   Columna135    Varchar(500),
   Columna136    Varchar(500),
   Columna137    Varchar(500),
   Columna138    Varchar(500),
   Columna139    Varchar(500),
   Columna140    Varchar(500),
   Columna141    Varchar(500),
   Columna142    Varchar(500),
   Columna143    Varchar(500),
   Columna144    Varchar(500),
   Columna145    Varchar(500),
   Columna146    Varchar(500),
   Columna147    Varchar(500),
   Columna148    Varchar(500),
   Columna149    Varchar(500),
   Columna150    Varchar(500))

   Set @w_IdEnc = Object_id('tmpFinal');

--
-- Inicio de Proceso.
--

--
-- Filtro para Consulta de Empresas
--

   If @PsCla_Empresa Is Null
      Begin
         Insert Into #TempEmpresa
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, NOM_EMPRESA)
         Select Distinct a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,
                a.NOM_EMPRESA
         From   dbo.rh_razon_social a
         Where  a.CLA_RAZON_SOCIAL = @PnCla_RazonSocial;
      End
   Else
      Begin
         Insert Into #TempEmpresa
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, NOM_EMPRESA)
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA,
                b.NOM_EMPRESA
         From   String_split(@PsCla_Empresa, ',') a
         Join   dbo.rh_razon_social               b
         On     b.CLA_EMPRESA    = a.value
         Where  CLA_RAZON_SOCIAL = @PnCla_RazonSocial;
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
-- Filtro para Consulta de Empresas
--

   If @PsStatusNom Is Null
      Begin
         Insert Into #TmpEstatusNomina
         (idEstatus)
         Select distinct a.STATUS_NOMINA
         From   dbo.RH_FECHA_PER a
         Join   #TempEmpresa     b
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
         Join   #TempEmpresa     c
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

   Insert Into  #ColumnasNoAplica
  (NomColumna)
   Select NomColumna
   From   dbo.ColumnasNoAplicaTbl
   Where  procedimiento = 'SP_NOMINA_TABULAR_XLS'
   And    Nivel         = 1
   Order  by secuencia;

   If @PnClaUsuario    = 3    And
      @PsCla_TipoNom = '68'
     Begin
        Insert Into #ColumnasNoAplica
       (NomColumna)
        Select NomColumna
        From   dbo.ColumnasNoAplicaTbl
        Where  procedimiento = 'SP_NOMINA_TABULAR_XLS'
        And    Nivel         = 2
        Order  by secuencia;
     End

   Insert Into #ColumnasNoImprimir
   (campo)
   Select 'CLA_UBICACION'
   Union
   Select 'CLA_CENTRO_COSTO'
   Union
   Select 'CLA_DEPTO';

--

   If @PbMostrarTodos = 0
      Begin
         Insert Into #ColumnasNoAplica2
        (CLA_PERDED)
         Select cla_perded
         From   dbo.RH_PERDED
         Where  ES_PROVISION    = 0
         And    NO_IMPRIMIR     = 1
         And    NO_AFECTAR_NETO = 1;
      End

--
-- Filtro para Consulta de Presentación de Provisiones
--

   If @PbMostrarProv = 1
      Begin
         Insert Into #tempProvisiones
         (cla_empresa, cla_perded, nom_perded)
         Select a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED
         From   dbo.RH_PERDED  a
         Join   #TempEmpresa   b
         On     b.CLA_EMPRESA   = a.Cla_Empresa
         Where  NO_AFECTAR_NETO = 1
         And    NO_IMPRIMIR     = 1
         And    ES_PROVISION    = 1;
      End

--
-- Consulta Filtro de Ubicación.
--

   If @PsCla_Ubicacion Is Null
      Begin
         Insert Into #tmpUbicacion
        (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
         Select a.CLA_EMPRESA, a.CLA_UBICACION, a.NOM_UBICACION
         From   dbo.RH_UBICACION a
         Join   #TempEmpresa     b
         On     b.CLA_EMPRESA = a.Cla_Empresa
      End
   Else
      Begin
         Insert Into #tmpUbicacion
        (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
         Select Distinct b.CLA_EMPRESA, b.CLA_UBICACION, b.NOM_UBICACION
         From   String_split(@PsCla_Ubicacion, ',') a
         Join   dbo.RH_UBICACION                    b
         On     b.CLA_UBICACION   = a.value
         Join   #TempEmpresa                        c
         On     c.CLA_EMPRESA     = b.Cla_Empresa
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
-- Consulta de los centros de Costo.
--

   If @PsCla_CentroCosto Is Null
      Begin
         Insert Into #tmpCentroCosto
        (CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO)
         Select Distinct a.CLA_EMPRESA, a.CLA_CENTRO_COSTO, a.NOM_CENTRO_COSTO
         From   dbo.RH_CENTRO_COSTO a
         Join   #TempEmpresa        b
         On     b.CLA_EMPRESA = a.Cla_Empresa
         Order  By 1, 2;
      End
   Else
      Begin
         Insert Into #tmpCentroCosto
        (CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_CENTRO_COSTO, b.NOM_CENTRO_COSTO
         From   String_split(@PsCla_CentroCosto, ',') a
         Join   dbo.RH_CENTRO_COSTO                   b
         On     b.CLA_CENTRO_COSTO = a.value
         Join   #TempEmpresa        c
         On     c.CLA_EMPRESA = b.Cla_Empresa
         Order  By 1, 2;
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
-- Consulta de los Departamentos
--

   If @PsCla_Depto Is Null
      Begin
         Insert Into #tmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA, NOM_AREA)
         Select Distinct t1.CLA_EMPRESA, t1.CLA_DEPTO, t1.NOM_DEPTO,
                t1.CLA_AREA,    t3.NOM_AREA
         From   dbo.RH_DEPTO     t1
         Join   #TempEmpresa     T2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         LEFT   Join dbo.RH_AREA t3
         On     t3.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t3.CLA_AREA    = t1.CLA_AREA
         Order  By 1, 2, 4;
      End
   Else
      Begin
         Insert Into #tmpDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO, CLA_AREA, NOM_AREA)
         Select Distinct t2.CLA_EMPRESA, t2.CLA_DEPTO, t2.NOM_DEPTO,
                t2.CLA_AREA,    t4.NOM_AREA
         From   String_split(@PsCla_Depto, ',') t1
         Join   dbo.RH_DEPTO                    t2
         On     t2.CLA_DEPTO   = t1.value
         Join   #TempEmpresa                    t3
         On     t3.CLA_EMPRESA = t2.CLA_EMPRESA
         LEFT   Join dbo.RH_AREA                t4
         On     t4.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t4.CLA_AREA    = t2.CLA_AREA
         Order  By 1, 2, 4;
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
-- Consulta de los Puestos.
--

   If @PsCla_Puestos Is Null
      Begin
         Insert Into #tmpPuesto
        (CLA_EMPRESA, CLA_PUESTO, NOM_PUESTO)
         Select Distinct t1.CLA_EMPRESA, t1.CLA_PUESTO,  t1.NOM_PUESTO
         From   dbo.RH_PUESTO t1
         Join   #TempEmpresa  t2
         On     t2.CLA_EMPRESA = t1.Cla_Empresa
         Order  By 1, 2;
      End
   Else
      Begin
         Insert Into #tmpPuesto
        (CLA_EMPRESA, CLA_PUESTO, NOM_PUESTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PUESTO,  b.NOM_PUESTO
         From   String_split(@PsCla_Puestos, ',') a
         Join   dbo.RH_PUESTO                     b
         On     b.CLA_PUESTO  = a.value
         Join   #TempEmpresa                      c
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

   If @PsCla_RegImss Is Null
      Begin
         Insert Into #tmpRegImss
        (CLA_REG_IMSS, CLA_EMPRESA, NOM_REG_IMSS, NUM_REG_IMSS)
         Select Distinct t1.CLA_REG_IMSS, t1.CLA_EMPRESA, t1.NOM_REG_IMSS, t1.NUM_REG_IMSS
         From   dbo.RH_REG_IMSS t1
         Join   #TempEmpresa    t2
         On     t2.CLA_EMPRESA = t1.Cla_Empresa
         Order  By 2, 1;
      End
   Else
       Begin
         Insert Into #tmpRegImss
        (CLA_REG_IMSS, CLA_EMPRESA, NOM_REG_IMSS, NUM_REG_IMSS)
         Select b.CLA_REG_IMSS, b.CLA_EMPRESA, b.NOM_REG_IMSS, b.NUM_REG_IMSS
         From   String_split(@PsCla_RegImss, ',') a
         Join   dbo.RH_REG_IMSS                   b
         On     b.CLA_REG_IMSS = @PsCla_RegImss
         Join   #TempEmpresa                      c
         On     c.CLA_EMPRESA  = b.Cla_Empresa
         Order  By 2, 1;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 8,
                      @PsMensaje = 'La Lista de los Regimen del IMSS Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta de los Tipos de Nomina
--

   If @PsCla_TipoNom Is Null
      Begin
         Insert Into #tempTipoNom
        (TIPO_NOMINA, NOM_TIPO_NOMINA)
         Select TIPO_NOMINA, NOM_TIPO_NOMINA
         From   dbo.RH_TIPO_NOMINA
      End
   Else
      Begin
         Insert Into #tempTipoNom
        (TIPO_NOMINA, NOM_TIPO_NOMINA)
         Select Distinct b.TIPO_NOMINA, b.NOM_TIPO_NOMINA
         From   String_split(@PsCla_TipoNom, ',') a
         Join   dbo.RH_TIPO_NOMINA               b
         On     b.TIPO_NOMINA      = a.value;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 9,
                      @PsMensaje = 'La Lista de los tipos de nómina Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta de los Períodos de Nomina
--

   If @PsCla_Periodo Is Null
      Begin
         Insert Into #tempPeriodo
       (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct a.CLA_EMPRESA, a.CLA_PERIODO, a.NOM_PERIODO
         From   dbo.RH_PERIODO a
         Join   #TempEmpresa   b
         On     b.CLA_EMPRESA      = a.Cla_Empresa
         And    b.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
         Order  By 2;
      End
   Else
      Begin
         Insert Into #tempPeriodo
        (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERIODO, b.NOM_PERIODO
         From   String_split(@PsCla_Periodo, ',') a
         Join   dbo.RH_PERIODO                    b
         On     b.CLA_PERIODO      = a.value
         Join   #TempEmpresa                      c
         On     c.CLA_EMPRESA      = b.Cla_Empresa
         And    c.CLA_RAZON_SOCIAL = b.CLA_RAZON_SOCIAL
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
-- Consulta de conceptos de nómina.
--

   If @PsCla_PerDed Is Null
      Begin
         Insert Into #tempPerded
        (CLA_EMPRESA, CLA_PERDED, NOM_PERDED, TIPO_PERDED)
         Select a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                Case When TIPO_PERDED = 10
                     Then 1
                     Else 2
                End
         From   dbo.RH_PERDED   a
         Join   #TempEmpresa    b
         On     b.CLA_EMPRESA     = a.Cla_Empresa
         Where  a.NO_AFECTAR_NETO = 0
         And    a.NO_IMPRIMIR     = 0
         And    a.ES_PROVISION    = 0
         Union
         Select a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                3
         From   #tempProvisiones a
         Order  By 2;

      End
   Else
      Begin
         Insert Into #tempPerded
        (CLA_EMPRESA, CLA_PERDED, NOM_PERDED, TIPO_PERDED)
         Select b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                Case When b.TIPO_PERDED = 10
                     Then 1
                     Else 2
                End
         From   String_split(@PsCla_PerDed, ',') a
         Join   dbo.RH_PERDED                    b
         On     b.cla_perded      = a.value
         Join   #TempEmpresa                     c
         On     c.CLA_EMPRESA     = b.Cla_Empresa
         Where  b.NO_AFECTAR_NETO = 0
         And    b.NO_IMPRIMIR     = 0
         And    b.ES_PROVISION    = 0
         Union
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                3
         From   String_split(@PsCla_PerDed, ',') a
         Join   #tempProvisiones                 b
         On     b.cla_perded      = a.value
         Join   #TempEmpresa                     c
         On     c.CLA_EMPRESA     = b.Cla_Empresa
         Order  By 2;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 11,
                      @PsMensaje = 'La Lista de Conceptos Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
      End

--
-- Consulta a las nóminas.
--

   If @PsNominas Is Null
      Begin
         Insert Into #tmpNominas
         (CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
          INICIO_PER,       FIN_PER,          ANIO,             NOM_PERIODO,
          TIPO_NOMINA,      NOM_TIPO_NOMINA,  STRING)
         Select Distinct t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,          t1.ANIO_MES,
                t1.INICIO_PER,  t1.FIN_PER,          t1.ANIO_MES / 100 ANIO, t2.NOM_PERIODO,
                t1.TIPO_NOMINA,
                t3.NOM_TIPO_NOMINA, Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
         From   dbo.RH_FECHA_PER    t1
         Join   #tempPeriodo        t2
         On     t2.CLA_EMPRESA      = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO      = t1.CLA_PERIODO
         Join   #tempTipoNom        t3
         On     t3.TIPO_NOMINA      = t1.TIPO_NOMINA
         Join   #TempEmpresa        t4
         On     t4.cla_empresa      = t1.cla_empresa
         Where  t1.ANIO_MES / 100   = @PnAnio
         And    t1.ANIO_MES   Between @PnAnioMesIni And @PnAnioMesFin;
      End
   Else
      Begin
         Insert Into #tmpNominas
         (CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
          INICIO_PER,       FIN_PER,          ANIO,             NOM_PERIODO,
          TIPO_NOMINA,      NOM_TIPO_NOMINA,  STRING)
         Select Distinct t1.CLA_EMPRESA,     t1.CLA_PERIODO,      t1.NUM_NOMINA, t1.ANIO_MES,
                t1.INICIO_PER,      t1.FIN_PER,          t1.ANIO_MES / 100 ANIO, t2.NOM_PERIODO,
                t1.tipo_nomina,     t3.NOM_TIPO_NOMINA,
                Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
         From   String_split(@PsNominas, ',') t0
         Join   dbo.RH_FECHA_PER t1
         On     t1.NUM_NOMINA  = t0.value
         Join   #tempPeriodo     t2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO = t1.CLA_PERIODO
         Join   #tempTipoNom        t3
         On     t3.TIPO_NOMINA      = t1.TIPO_NOMINA
         Join   #TempEmpresa        t4
         On     t4.cla_empresa      = t1.cla_empresa
         Where  t1.ANIO_MES / 100   = @PnAnio
         And    t1.ANIO_MES   Between @PnAnioMesIni And @PnAnioMesFin;;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 12,
                      @PsMensaje = 'La Lista de Nóminas Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End;
      End

--
-- Consulta a los Trabajadores a procesar.
--

   If @PsCla_Trab Is Null
      Begin
         Insert Into  #tmpTrabNombres
        (CLA_TRAB,            CLA_EMPRESA, NOM_TRAB,        AP_PATERNO,
         AP_MATERNO,          NOMBRE,      NSS,             CURP,
         RFC,                 FECHA_ING,   FECHA_ING_GRUPO, FECHA_INI_DESCINF,
         FECHA_SUSP_DESC_INF, CTA_BANCO,   SINDICALIZADO,   CLA_BANCO,
         TIPO_SALARIO)
         Select a.CLA_TRAB, a.CLA_EMPRESA,     Upper(NOM_TRAB), Upper(AP_PATERNO),
                Upper(AP_MATERNO),
                UPPER(Concat(AP_PATERNO, SPACE(1), AP_MATERNO, SPACE(1), NOM_TRAB)),
                NUM_IMSS, CURP,  RFC,
                Convert(Varchar, FECHA_ING,       101) FECHA_ING,
                Convert(Varchar, FECHA_ING_GRUPO, 101) FECHA_ING_GRUPO,
                FECHA_INI_DESCINF, FECHA_SUSP_DESC_INF,
                CTA_BANCO,
                Case When Isnull(SIND, 0) = 0
                     Then 'NO SINDICALIZADO'
                     Else 'SINDICALIZADO'
                End SINDICALIZADO,
                CLA_BANCO,
                Case TIPO_SALARIO When 0
                                  Then 'FIJO'
                                  When 1
                                  Then 'VARIABLE'
                                  When 2
                                  Then 'MIXTO'
                                  Else ''
                End TIPO_SALARIO
         From   dbo.RH_TRAB     a
         Join   #tmpUbicacion   b
         On     b.CLA_EMPRESA         = a.CLA_EMPRESA
         And    b.CLA_UBICACION       = a.CLA_UBICACION_BASE
         Join   #tmpCentroCosto c
         On     C.CLA_EMPRESA         = a.CLA_EMPRESA
         And    C.CLA_CENTRO_COSTO    = a.CLA_CENTRO_COSTO
         Join   #tmpDepto       d
         On     D.CLA_EMPRESA         = a.CLA_EMPRESA
         And    D.CLA_DEPTO           = a.CLA_DEPTO
         Join   #tempPeriodo    e
         On     e.CLA_EMPRESA         = a.CLA_EMPRESA
         And    e.CLA_PERIODO         = a.CLA_PERIODO
         Join   #tmpRegImss     f
         On     f.CLA_EMPRESA         = a.CLA_EMPRESA
         And    f.CLA_REG_IMSS        = a.CLA_REG_IMSS
         Join   #TempEmpresa    g
         On     g.CLA_RAZON_SOCIAL    = a.CLA_RAZON_SOCIAL
         And    g.CLA_EMPRESA         = a.CLA_EMPRESA
         Where dbo.fnc_ValidaSysSeguridadStd(10, a.CLA_EMPRESA, @PnClaUsuario, a.CLA_UBICACION_BASE,
                                                 a.CLA_DEPTO,   a.CLA_PERIODO) > 0;
      End
   Else
      Begin
         Insert Into  #tmpTrabNombres
        (CLA_TRAB,            CLA_EMPRESA, NOM_TRAB,        AP_PATERNO,
         AP_MATERNO,          NOMBRE,      NSS,             CURP,
         RFC,                 FECHA_ING,   FECHA_ING_GRUPO, FECHA_INI_DESCINF,
         FECHA_SUSP_DESC_INF, CTA_BANCO,   SINDICALIZADO,   CLA_BANCO,
         TIPO_SALARIO)
         Select Distinct a.CLA_TRAB, a.CLA_EMPRESA,     Upper(NOM_TRAB), Upper(AP_PATERNO),
                Upper(AP_MATERNO),
                UPPER(Concat(AP_PATERNO, SPACE(1), AP_MATERNO, SPACE(1), NOM_TRAB)),
                NUM_IMSS, CURP,  RFC,
                Convert(Varchar, FECHA_ING,       101) FECHA_ING,
                Convert(Varchar, FECHA_ING_GRUPO, 101) FECHA_ING_GRUPO,
                FECHA_INI_DESCINF, FECHA_SUSP_DESC_INF,
                CTA_BANCO,
                Case When Isnull(SIND, 0) = 0
                     Then 'NO SINDICALIZADO'
                     Else 'SINDICALIZADO'
                End SINDICALIZADO,
                CLA_BANCO,
                Case TIPO_SALARIO When 0
                                  Then 'FIJO'
                                  When 1
                                  Then 'VARIABLE'
                                  When 2
                                  Then 'MIXTO'
                                  Else ''
                End TIPO_SALARIO
         From   String_split(@PsCla_Trab, ',') t0
         Join   dbo.RH_TRAB                    a
         On     a.CLA_TRAB           = t0.value
         Join   #tmpUbicacion   b
         On     b.CLA_EMPRESA         = a.CLA_EMPRESA
         And    b.CLA_UBICACION       = a.CLA_UBICACION_BASE
         Join   #tmpCentroCosto c
         On     C.CLA_EMPRESA         = a.CLA_EMPRESA
         And    C.CLA_CENTRO_COSTO    = a.CLA_CENTRO_COSTO
         Join   #tmpDepto       d
         On     D.CLA_EMPRESA         = a.CLA_EMPRESA
         And    D.CLA_DEPTO           = a.CLA_DEPTO
         Join   #tempPeriodo    e
         On     e.CLA_EMPRESA         = a.CLA_EMPRESA
         And    e.CLA_PERIODO         = a.CLA_PERIODO
         Join   #tmpRegImss     f
         On     f.CLA_EMPRESA         = a.CLA_EMPRESA
         And    f.CLA_REG_IMSS        = a.CLA_REG_IMSS
         Join   #TempEmpresa    g
         On     g.CLA_RAZON_SOCIAL    = a.CLA_RAZON_SOCIAL
         And    g.CLA_EMPRESA         = a.CLA_EMPRESA
         Where  dbo.fnc_ValidaSysSeguridadStd(10, a.CLA_EMPRESA, @PnClaUsuario, a.CLA_UBICACION_BASE,
                                                  a.CLA_DEPTO,   a.CLA_PERIODO) > 0;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 13,
                      @PsMensaje = 'La Lista de Trabajadores Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End

      End

   If Exists ( Select top 1 1
               From   #TmpEstatusNomina
               Where  idEstatus = 9)
      Begin
         Insert Into #tmpPerded
        (CLA_PERDED,    CLA_EMPRESA,  NOM_PERDED,  TIPO_PERDED,
         CLASIFICACION, ES_PROVISION, ESBASE_IMSS, NO_AFECTAR_NETO,
         ESBASE_ISPT,   ORDEN,        MOSTRAR_MONTO)
         Select Distinct t1.CLA_PERDED, t1.CLA_EMPRESA,
                'C' + Convert(Varchar,t1.CLA_PERDED)+'_'+ UPPER(Replace(
                      Replace(Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(Replace(Replace(
                      Replace(Trim(T1.NOM_PERDED),')','_')
                                  ,'(','_'),'%',''),'.',''),'-',''),'/',''),'$',''),'.',''),' ','_'),char(13),''),char(10),''),char(9),'')) NOM_PERDED,
                t1.TIPO_PERDED,
                T1.CLASIFICACION,
                T1.ES_PROVISION,
                T1.ESBASE_IMSS,
                T1.NO_AFECTAR_NETO,
                T1.ESBASE_ISPT,
                T1.ORDEN,
                NULL MOSTRAR_MONTO
         From   dbo.RH_PERDED        T1
         Join   dbo.RH_DET_REC_HISTO T2
         On     T2.CLA_EMPRESA     = T1.CLA_EMPRESA
         And    T2.CLA_PERDED      = T1.CLA_PERDED
         Join   #tmpNominas          T3
         On     T3.NUM_NOMINA      = T2.NUM_NOMINA
         And    T3.CLA_PERIODO     = T2.CLA_PERIODO
         And    T3.CLA_EMPRESA     = T2.CLA_EMPRESA
         Join   #tempPerded          T4
         On     T4.CLA_EMPRESA     = T1.CLA_EMPRESA
         And    T4.CLA_PERDED      = T1.CLA_PERDED
         Join   #tmpTrabNombres      T5
         On     T5.CLA_EMPRESA     = T2.CLA_EMPRESA
         And    T5.CLA_TRAB        = T2.CLA_TRAB
         Join   #tmpPuesto           T6
         On     T6.CLA_EMPRESA     = T2.CLA_EMPRESA
         And    T6.CLA_PUESTO      = T2.CLA_PUESTO
         Join   #TempEmpresa    t7
         On     T7.CLA_EMPRESA         = T1.CLA_EMPRESA
         Where  T1.TIPO_PERDED     = Iif(@PnTipoConcepto = 0, T1.TIPO_PERDED, @PnTipoConcepto)
         And   (T1.NO_AFECTAR_NETO = 0
         Or     Exists             ( Select top 1 1
                                     From   #tempProvisiones
                                     Where  cla_empresa = T1.CLA_EMPRESA
                                     And    cla_perded  = T1.CLA_PERDED))
         Order  By NO_AFECTAR_NETO, ES_PROVISION, TIPO_PERDED, ORDEN, CLA_PERDED;
      End

   If Exists ( Select top 1 1
               From   #TmpEstatusNomina
               Where  idEstatus != 9)
      Begin
         Insert #tmpPerded
        (CLA_PERDED,    CLA_EMPRESA,  NOM_PERDED,  TIPO_PERDED,
         CLASIFICACION, ES_PROVISION, ESBASE_IMSS, NO_AFECTAR_NETO,
         ESBASE_ISPT,   ORDEN,        MOSTRAR_MONTO)
         Select Distinct t1.CLA_PERDED, t1.CLA_EMPRESA,
                'C' + Convert(Varchar,t1.CLA_PERDED)+'_'+ UPPER(Replace(
                      Replace(Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(
                      Replace(Replace(Replace(
                      Replace(RTRIM(LTRIM(T1.NOM_PERDED)),')','_')
                                  ,'(','_'),'%',''),'.',''),'-',''),'/',''),'$',''),'.',''),' ','_'),char(13),''),char(10),''),char(9),'')) NOM_PERDED,
                t1.TIPO_PERDED ,
                T1.CLASIFICACION,
                T1.ES_PROVISION,
                T1.ESBASE_IMSS,
                T1.NO_AFECTAR_NETO,
                T1.ESBASE_ISPT,
                T1.ORDEN,
                Null MOSTRAR_MONTO
         From   dbo.RH_PERDED         T1
         Join   dbo.RH_DET_REC_ACTUAL T2
         On     T2.CLA_EMPRESA     = T1.CLA_EMPRESA
         And    T2.CLA_PERDED      = T1.CLA_PERDED
         Join   #tmpNominas          T3
         On     T3.NUM_NOMINA      = T2.NUM_NOMINA
         And    T3.CLA_PERIODO     = T2.CLA_PERIODO
         And    T3.CLA_EMPRESA     = T2.CLA_EMPRESA
         Join   #tempPerded          T4
         On     T4.CLA_EMPRESA     = T1.CLA_EMPRESA
         And    T4.CLA_PERDED      = T1.CLA_PERDED
         Join   #tmpTrabNombres      T5
         On     T5.CLA_EMPRESA     = T2.CLA_EMPRESA
         And    T5.CLA_TRAB        = T2.CLA_TRAB
         Join   #tmpPuesto           T6
         On     T6.CLA_EMPRESA     = T2.CLA_EMPRESA
         And    T6.CLA_PUESTO      = T2.CLA_PUESTO
         Join   #TempEmpresa    t7
         On     T7.CLA_EMPRESA         = T1.CLA_EMPRESA
         And    T1.TIPO_PERDED     = Iif(@PnTipoConcepto = 0, T1.TIPO_PERDED, @PnTipoConcepto)
         And   (T1.NO_AFECTAR_NETO = 0
         Or     Exists             ( Select top 1 1
                                     From   #tempProvisiones
                                     Where  cla_empresa = T1.CLA_EMPRESA
                                     And    cla_perded  = T1.CLA_PERDED))
         Order  BY NO_AFECTAR_NETO, ES_PROVISION, TIPO_PERDED, ORDEN, CLA_PERDED;
      End
--

   If @PnClaUsuario = 3 And
      @PsCla_TipoNom    = '68'
      Begin
         Delete #tmpPerded
         Where  CLA_PERDED In (280, 2103, 2104, 2105, 2106, 2107)
      End

   Insert Into  #tmpRoll
   Select Distinct a.CLA_EMPRESA, a.CLA_ROLL, a.NOM_ROLL
   From   dbo.RH_ROLL_TURNO a
   Join   #TempEmpresa      b
   On     b.CLA_EMPRESA = a.CLA_EMPRESA
   Where  A.CLA_ROLL   In (Select VALOR_DATO_INT1
                           From   dbo.RH_DET_CONFIG_GENERAL
                           Where  CLA_DATO        = 27
                           And    VALOR_DATO_INT1 = 1)
   Union
   Select Distinct a.CLA_EMPRESA, a.CLA_PERFIL_TURNO, a.NOM_PERFIL_TURNO
   From   dbo.RELOJ_PERFIL_TURNO a
   Join   #TempEmpresa      b
   On     b.CLA_EMPRESA       = a.CLA_EMPRESA
   Where  a.CLA_PERFIL_TURNO In ( Select Top 1 1
                                  From   dbo.RH_DET_CONFIG_GENERAL
                                  Where  CLA_DATO        = 27
                                  And    VALOR_DATO_INT1 = 1);

   Insert Into #tmpTabSue
   Select a.CLA_EMPRESA, a.CLA_TAB_SUE, a.NOM_TAB_SUE
   From   dbo.RH_TAB_SUE    a
   Join   #TempEmpresa      b
   On     b.CLA_EMPRESA       = a.CLA_EMPRESA;

   Insert Into #DIAS_POR_PAGAR
  (CLA_EMPRESA, CLA_TRAB, CLA_PERIODO, NUM_NOMINA,
   ANIO_MES,    DIAS_POR_PAGAR)
   Select a.cla_empresa, a.CLA_TRAB, a.CLA_PERIODO, a.NUM_NOMINA,
          a.ANIO_MES,
          Sum(Case When b.tipo_perded = 10
                   Then importe
                   When b.tipo_perded = 50
                   Then -importe
                   Else 0
              End) DIAS_POR_PAGAR
   From   dbo.RH_det_REC_HISTO a
   Join   dbo.RH_PERDED        b
   On     b.CLA_PERDED       = a.CLA_PERDED
   And    b.CLA_EMPRESA      = a.CLA_EMPRESA
   And    b.GRUPO_CAL1       = 1
   And    b.NO_AFECTAR_NETO  = 0
   Join   #tmpNominas          c
   On     c.ANIO_MES         = a.ANIO_MES
   And    c.CLA_EMPRESA      = a.CLA_EMPRESA
   And    c.CLA_PERIODO      = a.CLA_PERIODO
   And    c.NUM_NOMINA       = a.NUM_NOMINA
   Join   #TempEmpresa      d
   On     d.CLA_EMPRESA      = a.CLA_EMPRESA
   Group  By a.cla_empresa, a.CLA_TRAB, a.CLA_PERIODO, a.ANIO_MES, a.NUM_NOMINA;

--
--
--

   Insert Into #tmpNominasTrab
  (CLA_EMPRESA,      CLA_RAZON_SOCIAL, CLA_PERIODO,   NUM_NOMINA,
   NOM_AREA,         CLA_UBICACION,    NOM_UBICACION, CLA_CENTRO_COSTO,
   NOM_CENTRO_COSTO, CLA_DEPTO,        NOM_DEPTO,     NOM_PUESTO,
   NOM_PERIODO,      CLA_TRAB,         NOM_TRAB,      FECHA_ING,
   FECHA_ING_GRUPO,  NSS,              RFC,           ANIO_MES,
   INICIO_PER,       FIN_PER,          SUE_DIA,       SUE_INT,
   TOT_PER,          TOT_DED,          TOT_NETO,      Tipo_Companiero,
   DIAS_POR_PAGAR)
   Select T1.CLA_EMPRESA,      T2.CLA_RAZON_SOCIAL, T1.CLA_PERIODO,   t1.NUM_NOMINA ,
          t7.NOM_AREA,         t5.CLA_UBICACION,    t5.NOM_UBICACION, t2.CLA_CENTRO_COSTO,
          t6.NOM_CENTRO_COSTO, t2.CLA_PUESTO,       T7.NOM_DEPTO,     t13.NOM_PUESTO,
          t1.NOM_PERIODO,      t2.CLA_TRAB,
          Concat(Trim(t3.AP_PATERNO), ' ', trim(t3.AP_MATERNO), ' ', trim(t3.NOM_TRAB)),
          Convert(Varchar, t3.FECHA_ING,       101),
          Convert(Varchar, t3.FECHA_ING_GRUPO, 101), t3.NSS, t3.RFC,  T2.ANIO_MES,
          Convert(Varchar(10), T1.INICIO_PER,  103),
          Convert(Varchar(10), T1.FIN_PER,     103) FIN_PER,
          t2.SUE_DIA,
          t2.SUE_INT,
          t2.TOT_PER,
          t2.TOT_DED,
          t2.TOT_NETO,
          t3.SINDICALIZADO, Isnull(t99.DIAS_POR_PAGAR, 0)
   From   #tmpNominas          t1
   Join   dbo.RH_ENC_REC_HISTO t2
   On     t2.ANIO_MES    = t1.ANIO_MES
   And    t2.CLA_EMPRESA = t1.CLA_EMPRESA
   And    t2.CLA_PERIODO = t1.CLA_PERIODO
   And    t2.NUM_NOMINA  = t1.NUM_NOMINA
   Join   #TempEmpresa      d
   On     d.CLA_EMPRESA   = T1.CLA_EMPRESA
   Join   #tmpTrabNombres      t3
   On     t3.CLA_EMPRESA = t2.CLA_EMPRESA
   And    t3.CLA_TRAB    = t2.CLA_TRAB
   Join   #tmpRegImss          t4
   On     t4.CLA_EMPRESA  = t2.CLA_EMPRESA
   And    t4.CLA_REG_IMSS = t2.CLA_REG_IMSS
   Join   #tmpUbicacion        t5
   On     t5.CLA_EMPRESA   = t2.CLA_EMPRESA
   And    t5.CLA_UBICACION = t2.CLA_UBICACION_BASE
   Join   #tmpCentroCosto               t6
   On     t6.CLA_EMPRESA        = t2.CLA_EMPRESA
   And    t6.CLA_CENTRO_COSTO   = t2.CLA_CENTRO_COSTO
   Join   #tmpDepto            t7
   On     t7.CLA_EMPRESA        = t2.CLA_EMPRESA
   And    t7.CLA_DEPTO          = t2.CLA_DEPTO
   LEFT   Join dbo.RH_FORMA_PAGO   t8
   On     t8.CLA_EMPRESA        = t2.CLA_EMPRESA
   And    t8.CLA_FORMA_PAGO     = t2.CLA_FORMA_PAGO
   LEFT   Join dbo.RH_BANCO    t9
   On     t9.CLA_BANCO          = t3.CLA_BANCO
   Join   dbo.RH_CLASIFICACION t10
   On     t10.CLA_EMPRESA       = t2.CLA_EMPRESA
   And    t10.CLA_CLASIFICACION = t2.CLA_CLASIFICACION
   Join   #tmpTabSue           t12
   On     t12.CLA_EMPRESA = t2.CLA_EMPRESA
   And    t12.CLA_TAB_SUE = t2.CLA_TAB_SUE
   Left   Join  #tmpPuesto           t13
   On     t13.CLA_EMPRESA = t2.CLA_EMPRESA
   And    t13.CLA_PUESTO  = t2.CLA_PUESTO
   Left   Join  #DIAS_POR_PAGAR T99
   On     t99.CLA_EMPRESA = t2.CLA_EMPRESA
   And    t99.CLA_TRAB    = t2.CLA_TRAB
   And    t99.ANIO_MES    = t2.ANIO_MES
   And    t99.CLA_PERIODO = t2.CLA_PERIODO
   And    t99.NUM_NOMINA  = t2.NUM_NOMINA;

   If @IncluirNomAbiertas = 1 And
      Exists              ( Select top 1 1
                            From   #TmpEstatusNomina
                            Where  idEstatus = 1)
      Begin
         Insert Into #tmpNominasTrab
        (CLA_EMPRESA,      CLA_RAZON_SOCIAL, CLA_PERIODO,   NUM_NOMINA,
         NOM_AREA,         CLA_UBICACION,    NOM_UBICACION, CLA_CENTRO_COSTO,
         NOM_CENTRO_COSTO, CLA_DEPTO,        NOM_DEPTO,     NOM_PUESTO,
         NOM_PERIODO,      CLA_TRAB,         NOM_TRAB,      FECHA_ING,
         FECHA_ING_GRUPO,  NSS,              RFC,           ANIO_MES,
         INICIO_PER,       FIN_PER,          SUE_DIA,       SUE_INT,
         TOT_PER,          TOT_DED,          TOT_NETO,      Tipo_Companiero,
         DIAS_POR_PAGAR)
         Select T1.CLA_EMPRESA,      T2.CLA_RAZON_SOCIAL, T1.CLA_PERIODO,   t1.NUM_NOMINA ,
                t7.NOM_AREA,         t5.CLA_UBICACION,    t5.NOM_UBICACION, t2.CLA_CENTRO_COSTO,
                t6.NOM_CENTRO_COSTO, t2.CLA_PUESTO,       T7.NOM_DEPTO,     t13.NOM_PUESTO,
                t1.NOM_PERIODO,      t2.CLA_TRAB,
                Concat(Trim(t3.AP_PATERNO), ' ', trim(t3.AP_MATERNO), ' ', trim(t3.NOM_TRAB)),
                Convert(Varchar, t3.FECHA_ING,       101),
                Convert(Varchar, t3.FECHA_ING_GRUPO, 101), t3.NSS, t3.RFC,
                T2.ANIO_MES_ISPT ANIO_MES,
                Convert(Varchar(10), T1.INICIO_PER,  103),
                Convert(Varchar(10), T1.FIN_PER,     103) FIN_PER,
                t2.SUE_DIA,
                t2.SUE_INT,
                t2.TOT_PER,
                t2.TOT_DED,
                t2.TOT_NETO,
                t3.SINDICALIZADO, Isnull(t99.DIAS_POR_PAGAR, 0)
         From   #tmpNominas           t1
         Join   dbo.RH_ENC_REC_ACTUAL t2
         On     t2.CLA_EMPRESA   = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO   = t1.CLA_PERIODO
         And    t2.NUM_NOMINA    = t1.NUM_NOMINA
         Join   #TempEmpresa      d
         On     d.CLA_EMPRESA   = T1.CLA_EMPRESA
         Join   #tmpTrabNombres      t3
         On     t3.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t3.CLA_TRAB    = t2.CLA_TRAB
         Join   #tmpRegImss          t4
         On     t4.CLA_EMPRESA  = t2.CLA_EMPRESA
         And    t4.CLA_REG_IMSS = t2.CLA_REG_IMSS
         Join   #tmpUbicacion        t5
         On     t5.CLA_EMPRESA   = t2.CLA_EMPRESA
         And    t5.CLA_UBICACION = t2.CLA_UBICACION_BASE
         Join   #tmpCentroCosto               t6
         On     t6.CLA_EMPRESA        = t2.CLA_EMPRESA
         And    t6.CLA_CENTRO_COSTO   = t2.CLA_CENTRO_COSTO
         Join   #tmpDepto            t7
         On     t7.CLA_EMPRESA        = t2.CLA_EMPRESA
         And    t7.CLA_DEPTO          = t2.CLA_DEPTO
         LEFT   Join dbo.RH_FORMA_PAGO   t8
         On     t8.CLA_EMPRESA        = t2.CLA_EMPRESA
         And    t8.CLA_FORMA_PAGO     = t2.CLA_FORMA_PAGO
         LEFT   Join dbo.RH_BANCO    t9
         On     t9.CLA_BANCO          = t3.CLA_BANCO
         Join   dbo.RH_CLASIFICACION t10
         On     t10.CLA_EMPRESA       = t2.CLA_EMPRESA
         And    t10.CLA_CLASIFICACION = t2.CLA_CLASIFICACION
         Join   #tmpTabSue           t12
         On     t12.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t12.CLA_TAB_SUE = t2.CLA_TAB_SUE
         Left   Join  #tmpPuesto           t13
         On     t13.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t13.CLA_PUESTO  = t2.CLA_PUESTO
         Left   Join  #DIAS_POR_PAGAR T99
         On     t99.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t99.CLA_TRAB    = t2.CLA_TRAB
         And    t99.ANIO_MES    = t2.ANIO_MES_ISPT
         And    t99.CLA_PERIODO = t2.CLA_PERIODO
         And    t99.NUM_NOMINA  = t2.NUM_NOMINA

      End

--
--
--

   Insert Into tmpPagosConceptos
  (CLA_TRAB,        NOM_TRAB,         CLA_EMPRESA,      NOM_EMPRESA,
   CLA_PERIODO,     NUM_NOMINA,       ANIO_MES,         CLA_UBICACION,
   NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
   NOM_DEPTO,       CLA_PERDED,       NOM_PERDED,       MONTO,
   IMPORTE,         EXENTO,           GRAVADO,          GRAV_IMSS,
   ACUMULADO,       TIPO_PERDED,      ES_PROVISION,     ESBASE_IMSS,
   NO_AFECTAR_NETO, ESBASE_ISPT,      CLA_RAZON_SOCIAL, ORDEN)
   Select t1.CLA_TRAB,             t1.NOM_TRAB,         t1.CLA_EMPRESA,            t4.NOM_EMPRESA,
          Max(t1.CLA_PERIODO),     Max(t1.NUM_NOMINA),  Max(t1.ANIO_MES),          T1.CLA_UBICACION,
          T1.NOM_UBICACION,        T1.CLA_CENTRO_COSTO, T1.NOM_CENTRO_COSTO,       t1.CLA_DEPTO,
          T1.NOM_DEPTO,            T3.CLA_PERDED,       Max(t3.NOM_PERDED),        Sum(t2.MONTO),
          Sum(t2.IMPORTE),         Sum(t2.EXENTO),      Sum(t2.IMPORTE-t2.EXENTO), Sum(t2.GRAV_IMSS),
          Sum(t2.Acum),            Max(T3.TIPO_PERDED), Max(t3.ES_PROVISION),      Max(t3.ESBASE_IMSS),
          Max(t3.NO_AFECTAR_NETO), Max(t3.ESBASE_ISPT), Max(t1.CLA_RAZON_SOCIAL),  Max(t3.ORDEN)
   From   #tmpNominasTrab      t1
   Join   dbo.RH_DET_REC_HISTO t2
   On     t2.ANIO_MES    = t1.ANIO_MES
   And    t2.CLA_TRAB    = t1.CLA_TRAB
   And    t2.CLA_EMPRESA = t1.CLA_EMPRESA
   And    t2.CLA_PERIODO = t1.CLA_PERIODO
   And    t2.NUM_NOMINA  = t1.NUM_NOMINA
   Join   #tmpPerded           t3
   On     t3.CLA_EMPRESA = t2.CLA_EMPRESA
   And    t3.CLA_PERDED  = t2.CLA_PERDED
   Join   #TempEmpresa         T4
   On     t4.CLA_EMPRESA      = t2.CLA_EMPRESA
   And    t4.cla_razon_social = t2.cla_razon_social
   Where  t2.IMPORTE         != 0
   Group  By t1.CLA_TRAB,      T1.NOM_TRAB,      t1.CLA_EMPRESA,       t4.NOM_EMPRESA,     T3.CLA_PERDED,
             T1.CLA_UBICACION, T1.NOM_UBICACION, T1.CLA_CENTRO_COSTO,  T1.NOM_CENTRO_COSTO,
             t1.CLA_DEPTO,     T1.NOM_DEPTO;

   If @IncluirNomAbiertas = 1 And
      Exists ( Select top 1 1
               From   #TmpEstatusNomina
               Where  idEstatus = 1)
      Begin
         Insert INTO tmpPagosConceptos
        (CLA_TRAB,        NOM_TRAB,         CLA_EMPRESA,      NOM_EMPRESA,
         CLA_PERIODO,     NUM_NOMINA,       ANIO_MES,         CLA_UBICACION,
         NOM_UBICACION,   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO, CLA_DEPTO,
         NOM_DEPTO,       CLA_PERDED,       NOM_PERDED,       MONTO,
         IMPORTE,         EXENTO,           GRAVADO,          GRAV_IMSS,
         ACUMULADO,       TIPO_PERDED,      ES_PROVISION,     ESBASE_IMSS,
         NO_AFECTAR_NETO, ESBASE_ISPT,      CLA_RAZON_SOCIAL, ORDEN)
         Select t1.CLA_TRAB,             t1.nom_trab,              t1.CLA_EMPRESA,                 t4.NOM_EMPRESA,
                Max(t1.CLA_PERIODO),     Max(t1.NUM_NOMINA),       Max(t1.ANIO_MES),               T1.CLA_UBICACION,
                T1.NOM_UBICACION,        T1.CLA_CENTRO_COSTO,      t1.NOM_CENTRO_COSTO,            t1.CLA_DEPTO,
                T1.NOM_DEPTO,            T3.CLA_PERDED,            Max(t3.NOM_PERDED),             Sum(t2.MONTO),
                Sum(t2.IMPORTE),         Sum(t2.RES_EXE_SQL),      Sum(t2.IMPORTE-t2.RES_EXE_SQL), Sum(t2.GRAV_IMSS),
                Sum(T2.acum),            Max(T3.TIPO_PERDED),      Max(t3.ES_PROVISION),           Max(t3.ESBASE_IMSS),
                Max(t3.NO_AFECTAR_NETO), Max(t1.CLA_RAZON_SOCIAL), Max(t3.ESBASE_ISPT),            Max(t3.ORDEN)
         From   #tmpNominasTrab       t1
         Join   dbo.RH_DET_REC_ACTUAL t2
         On     t2.CLA_TRAB         = t1.CLA_TRAB
         And    t2.CLA_EMPRESA      = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO      = t1.CLA_PERIODO
         And    t2.NUM_NOMINA       = t1.NUM_NOMINA
         Join   #tmpPerded t3
         On     t3.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t3.CLA_PERDED       = t2.CLA_PERDED
         Join   #TempEmpresa          T4
         On     t4.CLA_EMPRESA      = t1.CLA_EMPRESA
         And    t4.cla_razon_social = t1.cla_razon_social
         Where  t2.IMPORTE         != 0
         Group  By t1.CLA_TRAB,         t1.nom_Trab,      t1.CLA_EMPRESA,   t4.NOM_EMPRESA,
                   T3.CLA_PERDED,       T1.CLA_UBICACION, T1.NOM_UBICACION, T1.CLA_CENTRO_COSTO,
                   T1.NOM_CENTRO_COSTO, t1.CLA_DEPTO,     T1.NOM_DEPTO;
      End

-- Subtotal Depto.

   Insert INTO tmpPagosConceptos
  (CLA_TRAB,        CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,
   ANIO_MES,        CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO,
   CLA_PERDED,      NOM_DEPTO,        MONTO,            IMPORTE,
   EXENTO,          GRAVADO,          GRAV_IMSS,        ACUMULADO,
   TIPO_PERDED,     ES_PROVISION,     ESBASE_IMSS,      NO_AFECTAR_NETO,
   ESBASE_ISPT,     CLA_RAZON_SOCIAL, ORDEN,            LINEA)
   Select Max(CLA_TRAB) + 10001, CLA_EMPRESA,                            Max(CLA_PERIODO), Max(NUM_NOMINA),
          Max(ANIO_MES),         CLA_UBICACION,                          CLA_CENTRO_COSTO, CLA_DEPTO,
          Max(CLA_PERDED) + 10001,       Concat('TOTAL DEPARTAMENTO ', NOM_DEPTO),       Sum(MONTO),       SUM(IMPORTE),
          Sum(EXENTO),           Sum(GRAVADO),                            Sum(GRAV_IMSS),   Sum(ACUMULADO),
          Max(TIPO_PERDED),      Max(ES_PROVISION),                       Max(ESBASE_IMSS), Max(NO_AFECTAR_NETO),
          Max(ESBASE_ISPT),      Max(CLA_RAZON_SOCIAL),                   Max(ORDEN),       2
   From   tmpPagosConceptos
   Where  LINEA = 1
   Group  By CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO, CLA_DEPTO, NOM_DEPTO;

-- Subtotal Centro de Costo.

   Insert INTO tmpPagosConceptos
  (CLA_TRAB,        CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,
   ANIO_MES,        CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO,
   CLA_PERDED,      NOM_CENTRO_COSTO, MONTO,            IMPORTE,
   EXENTO,          GRAVADO,          GRAV_IMSS,        ACUMULADO,
   TIPO_PERDED,     ES_PROVISION,     ESBASE_IMSS,      NO_AFECTAR_NETO,
   ESBASE_ISPT,     CLA_RAZON_SOCIAL, ORDEN,            LINEA)
   Select Max(CLA_TRAB) + 10002, CLA_EMPRESA,                                          Max(CLA_PERIODO), Max(NUM_NOMINA),
          Max(ANIO_MES),         CLA_UBICACION,                                        Max(CLA_CENTRO_COSTO) + 10002, Max(CLA_DEPTO) + 10002,
          Max(CLA_PERDED)+ 10002, Concat('TOTAL CENTRO DE COSTO.: ', NOM_CENTRO_COSTO), Sum(MONTO),       SUM(IMPORTE),
          Sum(EXENTO),           Sum(GRAVADO),                                         Sum(GRAV_IMSS),   Sum(ACUMULADO),
          Max(TIPO_PERDED),      Max(ES_PROVISION),                                    Max(ESBASE_IMSS), Max(NO_AFECTAR_NETO),
          Max(ESBASE_ISPT),      Max(CLA_RAZON_SOCIAL),                                Max(ORDEN),       3
   From   tmpPagosConceptos
   Where  LINEA = 1
   Group  By CLA_EMPRESA, CLA_UBICACION, NOM_CENTRO_COSTO;


-- Subtotal Ubicación.

   Insert INTO tmpPagosConceptos
  (CLA_TRAB,        CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,
   ANIO_MES,        CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO,
   CLA_PERDED,      NOM_UBICACION,    MONTO,            IMPORTE,
   EXENTO,          GRAVADO,          GRAV_IMSS,        ACUMULADO,
   TIPO_PERDED,     ES_PROVISION,     ESBASE_IMSS,      NO_AFECTAR_NETO,
   ESBASE_ISPT,     CLA_RAZON_SOCIAL, ORDEN,            LINEA)
   Select Max(CLA_TRAB) + 10003,  CLA_EMPRESA,                              Max(CLA_PERIODO),      Max(NUM_NOMINA),
          Max(ANIO_MES),         CLA_UBICACION + 10003,                     Max(CLA_CENTRO_COSTO) + 10003, Max(CLA_DEPTO) + 10003,
          Max(CLA_PERDED) + 10003, Concat('TOTAL UBICACIÓN  ', NOM_UBICACION), Sum(MONTO),       SUM(IMPORTE),
          Sum(EXENTO),           Sum(GRAVADO),                             Sum(GRAV_IMSS),   Sum(ACUMULADO),
          Max(TIPO_PERDED),      Max(ES_PROVISION),                        Max(ESBASE_IMSS), Max(NO_AFECTAR_NETO),
          Max(ESBASE_ISPT),      Max(CLA_RAZON_SOCIAL),                    Max(ORDEN),       4
   From   tmpPagosConceptos
   Where  LINEA = 1
   Group  By CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION;

-- Subtotal Empresa.

   Insert INTO tmpPagosConceptos
  (CLA_TRAB,        CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,
   ANIO_MES,        CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO,
   CLA_PERDED,      NOM_EMPRESA,      MONTO,            IMPORTE,
   EXENTO,          GRAVADO,          GRAV_IMSS,        ACUMULADO,
   TIPO_PERDED,     ES_PROVISION,     ESBASE_IMSS,      NO_AFECTAR_NETO,
   ESBASE_ISPT,     CLA_RAZON_SOCIAL, ORDEN,            LINEA)
   Select Max(CLA_TRAB) + 10004,  CLA_EMPRESA,                              Max(CLA_PERIODO),      Max(NUM_NOMINA),
          Max(ANIO_MES),         Max(CLA_UBICACION) + 10004,                Max(CLA_CENTRO_COSTO) + 10004, Max(CLA_DEPTO) + 10004,
          Max(CLA_PERDED)+ 10004 , Concat('TOTAL EMPRESA', NOM_EMPRESA), Sum(MONTO),       SUM(IMPORTE),
          Sum(EXENTO),           Sum(GRAVADO),                             Sum(GRAV_IMSS),   Sum(ACUMULADO),
          Max(TIPO_PERDED),      Max(ES_PROVISION),                        Max(ESBASE_IMSS), Max(NO_AFECTAR_NETO),
          Max(ESBASE_ISPT),      Max(CLA_RAZON_SOCIAL),                    Max(ORDEN),       4
   From   tmpPagosConceptos
   Where  LINEA = 1
   Group  By CLA_EMPRESA, NOM_EMPRESA;

   Update tmpPagosConceptos
   Set    FECHA_ING       = T2.FECHA_ING,
          FECHA_ING_GRUPO = T2.FECHA_ING_GRUPO,
          NSS             = T2.NSS,
          RFC             = T2.RFC,
          NOM_AREA        = T2.NOM_AREA,
          TIPO_COMPANIERO = T2.TIPO_COMPANIERO,
          INICIO_PER      = T2.INICIO_PER     ,
          FIN_PER         = T2.FIN_PER        ,
          SUE_DIA         = T2.SUE_DIA        ,
          SUE_INT         = Format(T2.SUE_INT        , '###,###,###.00'),
          TOT_PER         = Format(T2.TOT_PER        , '###,###,###.00'),
          TOT_DED         = Format(T2.TOT_DED        , '###,###,###.00'),
          TOT_NETO        = Format(T2.TOT_NETO       , '###,###,###.00'),
          DIAS_POR_PAGAR  = Format(T2.DIAS_POR_PAGAR , '###,###,###.00')
   From   tmpPagosConceptos t1
   Join   #tmpNominasTrab    t2
   On     t2.CLA_TRAB         = t1.CLA_TRAB
   And    t2.CLA_EMPRESA      = t1.CLA_EMPRESA
   And    t2.CLA_PERIODO      = t1.CLA_PERIODO
   And    t2.NUM_NOMINA       = t1.NUM_NOMINA
   Where  T1.Linea = 1;

--
-- Actualizacion de Fecha de Inicio y Fecha Fin
--

   If @PnMesIni Is Not Null And
      @PnMesFin Is Not Null
      Begin
         Update #tmpNominasTrab
         Set    INICIO_PER = Convert(Date, Concat('01/', @PnMesIni, '/', @PnAnio), 103),
                FIN_PER    = Eomonth(Convert(Date, Concat('01/', @PnMesFin, '/', @PnAnio), 103));
      End

--
-- Búsqueda de columnas Iniciales.
--

  Declare
     C_Columnas Cursor For
     Select t1.name
     From   Sys.syscolumns T1
     Join   SYS.types T2
     On     T1.xtype = T2.system_type_id
     Where  T1.id    = @IdEnc
     Order  By T1.colid;

  Begin
     Open  C_Columnas
     While @@Fetch_status < 1
     Begin
        Fetch C_Columnas Into @w_columna
        If @@Fetch_status != 0
           Begin
              Break
           End

        If Exists ( Select Top 1 1
                    From   #ColumnasNoAplica
                    Where  NomColumna = @w_columna)
           Begin
              Goto Siguiente
           End

        Set @w_secuencia    = @w_secuencia + 1;

        If @w_columna = 'Corte_rep'
           Begin
              Select  @w_secuencia   = @w_secuencia - 1,
                      @w_posicion    = @w_secuencia;
              Break
           End

        If @w_secuencia > 1
           Begin
              Select @ColumnaNombre = @ColumnaNombre + ', ',
                     @SelectColumna = @SelectColumna + ', ',
                     @SelectCampos  = @SelectCampos  + ', ',
                     @w_ColInsert   = @w_ColInsert   + ', ',
                     @w_groupBy     = @w_groupBy     + ', ',
                     @w_groupBy2    = @w_groupBy2    + ', ';
              End

        Select @ColumnaNombre  = @ColumnaNombre + Concat('Columna', Format(@w_secuencia, '000')),
               @SelectColumna  = @SelectColumna + @w_comilla + ' ' + @w_columna + @w_comilla,
               @SelectCampos   = @SelectCampos  + Concat('Columna', Format(@w_secuencia, '000')),
               @w_ColInsert    = @w_ColInsert   + @w_columna,
               @w_columna2     = Concat('Columna', Format(@w_secuencia, '000')),
               @w_groupBy      = @w_groupBy  + ' ' + @w_columna,
               @w_groupBy2     = @w_groupBy2 + ' ' + @w_columna2;

Siguiente:

     End
     Close      C_Columnas
     Deallocate C_Columnas
   End


  Select @ColumnaNombre = @ColumnaNombre + ' ',
         @SelectColumna = @SelectColumna + ' ',
		 @Select        = @ColumnaNombre + ' ' + @SelectColumna,
         @w_ColInsert   = @w_ColInsert   + ' ';

--
-- Búsqueda de columnas de conceptos
--


  Declare
     C_Conceptos Cursor For
     Select Distinct CLA_PERDED, Trim(nom_perded)
     From   tmpPagosConceptos;

  Begin
     Set @w_posicion = 0;
     Open  C_Conceptos
     While @@Fetch_status < 1
     Begin
        Fetch C_Conceptos Into @w_cla_perded, @w_NomPerded;
        If @@Fetch_status != 0
           Begin
              Break
           End

        If @w_NomPerded = ''
           Begin 
              Goto Sigo
           End

        Select @w_secuencia    = @w_secuencia + 1,
               @w_posicion     = @w_posicion  + 1;      

        If @w_posicion != 1
           Begin
              Set @w_update = @w_update + ', ';
           End 

        Select @ColumnaNombre  = @ColumnaNombre + ', ' + Concat('Columna', Format(@w_secuencia, '000')),
               @SelectColumna  = @SelectColumna + ', ' + @w_comilla + @w_NomPerded + @w_comilla,
               @w_columna2     = Concat('Columna', Format(@w_secuencia, '000')),
               @SelectCampos   = @SelectCampos  + ', ' + 
                                 Concat(' Sum(Iif(Isnumeric(', @w_columna2, ' ) = 0, 0, Cast(', @w_columna2, ' As Decimal(18, 2))))'),
               @w_ColInsert    = @w_ColInsert   + ', 0',
			   @w_update       = @w_update + Concat('Columna', Format(@w_secuencia, '000')) + ' = ' +
                                                  ' b.importe';
  
SIGO:

     End
     Close      C_Conceptos
     Deallocate C_Conceptos
   End    

   Select @ColumnaNombre = @ColumnaNombre + ')',
          @SelectColumna = @SelectColumna + ' ',
 		  @Select        = @ColumnaNombre + ' ' + @SelectColumna,
          @w_ColInsert   = @w_ColInsert + ' From tmpPagosConceptos ' + @w_groupBy;

   Execute (@Select)

--

   Set @Select = @ColumnaNombre + ' ' + @w_ColInsert;
   Execute (@Select)

   Select @w_secuencia = T1.colid
   From   Sys.syscolumns T1
   Join   SYS.types T2
   On     T1.xtype = T2.system_type_id
   Where  T1.id    = @w_IdEnc
   And    T1.name  = 'Columna023';

   Declare
     C_Col Cursor For
     Select t1.name
     From   Sys.syscolumns T1
     Join   SYS.types      T2
     On     T1.xtype = T2.system_type_id
     Where  T1.id    = @w_IdEnc
     And    T1.colid > @w_secuencia
     Order  By T1.colid;

  Begin
     Open  C_Col
     While @@Fetch_status < 1
     Begin
        Fetch C_Col Into @w_columna
        If @@Fetch_status != 0
           Begin
              Break
           End

        Select @w_sql  = Concat('Select @o_campo = ', @w_columna,
                               ' From   tmpFinal ',
                               ' Where  Concecutivo = 1'),
               @w_Para = ' @o_campo Sysname Output';

        Execute SP_ExecuteSQL @w_sql, @w_para,  @o_campo = @w_campo Output;

        If @w_campo Is Null
           Begin
              Goto Next
           End

        Set @w_update2 = 'Update tmpFinal '   +
                         'Set   ' + @w_columna + ' = b.importe ' +
                         'From   tmpFinal a ' +
                         'Join   tmpPagosConceptos b ' +
                         'On     Cast(b.cla_Trab As VArchar) = a.columna001 ' +
                         'And    b.NOM_EMPRESA               = a.columna003 ' +
                         'Where  Trim(nom_perded) = ' + @w_comilla + @w_campo + @w_comilla + ' ' +
                         'And    a.Concecutivo   != 1';
    Begin Try
       Execute(@w_update2)
    End Try

    Begin Catch
       Select  @w_Error      = @@Error,
               @w_desc_error = Substring (Error_Message(), 1, 230)
    End   Catch

    If @w_Error != 0
       Begin
          Select @w_Error, @w_desc_error
          Select @w_update2
          Break
       End

Next:

     End
     Close      C_Col
     Deallocate C_Col
  End

  Set @Select = @SelectCampos + ' From  tmpFinal ' + @w_groupBy2 + ' Order By columna011,  columna013, columna001'

  Execute (@Select)

  
--

fin:

--   If dbo.Fn_existe_tabla ('tmpPagosConceptos') = 1
--      Begin
--         Drop Table tmpPagosConceptos;
--      End


   Set Xact_Abort Off
   Return

End
Go
