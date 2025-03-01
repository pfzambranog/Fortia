--Execute dbo.SP_NOMINA_TABULAR_XLS
--@ClaEmp=1,
--@ClaUsuario=3,
--@ClaUniNeg=0,
--@ClaRz = 1,
--@ClaPer=1,
--@ClaUbicacion=0,
--@ClaRegImss=0,@ClaCentroCosto=0,@ClaDepto=0,
--@Anio=2025,
--@MesIni=1,@MesFin=4,
--@TipoNom='10',
--@Nominas= Null,
--@ClaTrab=0,
--@TipoConcepto=0,
--@ClaPerded=0,
--@MostrarMonto=0,
--@MostrarGravExen=0,
--@MostrarGravImss=0,
--@MostrarTodos=1,
--@DetalladoXNom=1,
--@IncluirNomAbiertas=1,
--@statusNom


Create Or Alter Procedure dbo.SP_NOMINA_TABULAR_XLS
  (@ClaEmp                   Integer,
   @ClaUsuario               Integer,
   @ClaUniNeg                Integer,
   @ClaRz                    Integer,
   @ClaPer                   Varchar(Max),
   @ClaUbicacion             Varchar(Max),
   @ClaRegImss               Varchar(Max),
   @ClaCentroCosto           Varchar(Max),
   @ClaDepto                 Varchar(Max),
   @Anio                     Integer,
   @MesIni                   Integer,
   @MesFin                   Integer,
   @TipoNom                  Varchar(Max),
   @Nominas                  Varchar(Max),
   @ClaTrab                  Varchar(Max),
   @TipoConcepto             Integer,
   @ClaPerded                Varchar(Max),
   @MostrarMonto             Integer,
   @MostrarGravExen          Integer,
   @MostrarGravImss          Integer,
   @MostrarTodos             Integer,
   @MostrarProv              Integer = 1,
   @DetalladoXNom            Integer,
   @IncluirNomAbiertas       Integer,
   @statusNom                Integer)
AS

Declare
   @AnioMesIni               Integer,
   @AnioMesFin               Integer,
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
   @Update                   Varchar(Max),
   @Select                   Varchar(Max),
   @SelectCampos             Varchar(Max),
   @SelectColumna            Varchar(Max),
   @ColInsert                Varchar(Max),
   @w_lineaTotal             Varchar(Max);

Begin
   Set Nocount       On
   Set Ansi_Nulls    Off
   SET Ansi_Warnings OFF

   Select @AnioMesIni = Case When @MesIni > 0
                             Then (@Anio * 100) + @MesIni
                             Else (@Anio * 100) + 1
                        End,
         @AnioMesFin  = Case When @MesFin > 0
                             Then (@Anio * 100) + @MesFin
                             Else (@Anio * 100) + 12
                        End,
         @MostrarProv = 1;

   If Not Exists ( Select CLA_GPO_USUARIO
                   From   SYS_DET_GPO_USUARIO
                   Where  CLA_USUARIO      = @ClaUsuario
                   And    CLA_GPO_USUARIO  = (Select VALOR_VAR_USUARIO
                                              From   RH_VAR_USUARIO
                                              Where  CLA_VAR  = '$GPOUSRREP'
                                              And    CLA_EMPRESA = @ClaEmp))
                                              And   (Convert(Integer,@TipoNom) = (Select VALOR_VAR_USUARIO
                                                                                  From   RH_VAR_USUARIO
                                                                                  Where  CLA_VAR    = '$TIPONOMRP'
                                                                                  And   CLA_EMPRESA = @ClaEmp)
                                              Or     Convert(Integer, @Nominas) /1000%100 In ( Select VALOR_VAR_USUARIO
                                                                                               From   RH_VAR_USUARIO
                                                                                               Where  CLA_VAR  = '$TIPONOMRP'
                                                                                               And    CLA_EMPRESA = @ClaEmp))
      Begin
         goto fin
      End

--
-- Creación de tablas temporales.
--

   Create Table #tmpFinal
  (CONCECUTIVO   Integer Not Null IDENTITY (1, 1) Primary Key,
   Columna1      Varchar(500),
   Columna2      Varchar(500),
   Columna3      Varchar(500),
   Columna4      Varchar(500),
   Columna5      Varchar(500),
   Columna6      Varchar(500),
   Columna7      Varchar(500),
   Columna8      Varchar(500),
   Columna9      Varchar(500),
   Columna10     Varchar(500),
   Columna11     Varchar(500),
   Columna12     Varchar(500),
   Columna13     Varchar(500),
   Columna14     Varchar(500),
   Columna15     Varchar(500),
   Columna16     Varchar(500),
   Columna17     Varchar(500),
   Columna18     Varchar(500),
   Columna19     Varchar(500),
   Columna20     Varchar(500),
   Columna21     Varchar(500),
   Columna22     Varchar(500),
   Columna23     Varchar(500),
   Columna24     Varchar(500),
   Columna25     Varchar(500),
   Columna26     Varchar(500),
   Columna27     Varchar(500),
   Columna28     Varchar(500),
   Columna29     Varchar(500),
   Columna30     Varchar(500),
   Columna31     Varchar(500),
   Columna32     Varchar(500),
   Columna33     Varchar(500),
   Columna34     Varchar(500),
   Columna35     Varchar(500),
   Columna36     Varchar(500),
   Columna37     Varchar(500),
   Columna38     Varchar(500),
   Columna39     Varchar(500),
   Columna40     Varchar(500),
   Columna41     Varchar(500),
   Columna42     Varchar(500),
   Columna43     Varchar(500),
   Columna44     Varchar(500),
   Columna45     Varchar(500),
   Columna46     Varchar(500),
   Columna47     Varchar(500),
   Columna48     Varchar(500),
   Columna49     Varchar(500),
   Columna50     Varchar(500),
   Columna51     Varchar(500),
   Columna52     Varchar(500),
   Columna53     Varchar(500),
   Columna54     Varchar(500),
   Columna55     Varchar(500),
   Columna56     Varchar(500),
   Columna57     Varchar(500),
   Columna58     Varchar(500),
   Columna59     Varchar(500),
   Columna60     Varchar(500),
   Columna61     Varchar(500),
   Columna62     Varchar(500),
   Columna63     Varchar(500),
   Columna64     Varchar(500),
   Columna65     Varchar(500),
   Columna66     Varchar(500),
   Columna67     Varchar(500),
   Columna68     Varchar(500),
   Columna69     Varchar(500),
   Columna70     Varchar(500),
   Columna71     Varchar(500),
   Columna72     Varchar(500),
   Columna73     Varchar(500),
   Columna74     Varchar(500),
   Columna75     Varchar(500),
   Columna76     Varchar(500),
   Columna77     Varchar(500),
   Columna78     Varchar(500),
   Columna79     Varchar(500),
   Columna80     Varchar(500),
   Columna81     Varchar(500),
   Columna82     Varchar(500),
   Columna83     Varchar(500),
   Columna84     Varchar(500),
   Columna85     Varchar(500),
   Columna86     Varchar(500),
   Columna87     Varchar(500),
   Columna88     Varchar(500),
   Columna89     Varchar(500),
   Columna90     Varchar(500),
   Columna91     Varchar(500),
   Columna92     Varchar(500),
   Columna93     Varchar(500),
   Columna94     Varchar(500),
   Columna95     Varchar(500),
   Columna96     Varchar(500),
   Columna97     Varchar(500),
   Columna98     Varchar(500),
   Columna99     Varchar(500),
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

   Set @w_IdEnc = Object_id('tempdb..#tmpFinal');

   Create  Table #ColumnasNoAplica
  (NomColumna    Varchar(Max));

   Create Table #ColumnasNoAplica2
  (CLA_PERDED        Integer Not Null Primary Key);

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

   Create  Table #tmpPerded1
  (CLA_PERDED        Integer,
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
   Index I_tmpPerdedIdx01 (CLA_EMPRESA, CLA_PERDED));

   Create Table #tmpNominas
  (CLA_EMPRESA      Integer      Not Null,
   CLA_PERIODO      Integer      Not Null,
   NUM_NOMINA       Integer      Not Null,
   ANIO_MES         Integer      Not Null,
   INICIO_PER       Date         Not Null,
   FIN_PER          Date         Not Null,
   CLA_RAZON_SOCIAL Integer          Null,
   ANIO             Integer          Null,
   NOM_PERIODO      Varchar( 20)     Null,
   NOM_RAZON_SOCIAL Varchar(300)     Null,
   NOM_TIPO_NOMINA  Varchar( 80) Not Null,
   STRING           Varchar(Max) Not Null,
   Index I_tmpNominasIdx01 (CLA_EMPRESA, CLA_PERIODO, NUM_NOMINA));

   Create Table #tmpUbicacion
  (CLA_EMPRESA      Integer      Not Null,
   CLA_UBICACION    Integer      Not Null,
   NOM_UBICACION    Varchar(100) Not Null,
   Constraint tmpUbicacionPk
   Primary Key (CLA_EMPRESA, CLA_UBICACION));

   Create Table #tmpRegImss
  (CLA_EMPRESA      Integer      Not Null,
   CLA_REG_IMSS     Integer      Not Null,
   NUM_REG_IMSS     Varchar( 20) Not Null,
   NOM_REG_IMSS     Varchar(100) Not Null,
   Constraint tmpRegImssPk
   Primary Key (CLA_EMPRESA, NUM_REG_IMSS));

   Create Table #tmpCC
  (CLA_EMPRESA      Integer      Not Null,
   CLA_CENTRO_COSTO Integer      Not Null,
   NOM_CENTRO_COSTO Varchar(100) Not Null,
   Constraint tmpCCPk
   Primary Key (CLA_EMPRESA, CLA_CENTRO_COSTO));

   Create Table #tmpDepto
  (CLA_EMPRESA Integer       Not Null,
   CLA_DEPTO   Integer       Not Null,
   NOM_DEPTO   Varchar(100)  Not Null,
   CLA_AREA    Integer           Null,
   NOM_AREA    Varchar(100)      Null,
   Index tmpDeptoidx(CLA_EMPRESA, CLA_DEPTO));

   Create Table #tmpPuesto
  (CLA_EMPRESA Integer       Not Null,
   CLA_PUESTO  Integer       Not Null,
   NOM_PUESTO  Varchar(250)  Not Null,
   Constraint tmpPuestoPk
   Primary Key (CLA_EMPRESA, CLA_PUESTO));

   Create Table #tmpFormaPago
  (CLA_EMPRESA     Integer        Not Null,
   CLA_FORMA_PAGO  Integer        Not Null,
   NOM_FORMA_PAGO  Varchar(100)   Not Null,
   Constraint tmpFormaPagoPk
   Primary Key (CLA_EMPRESA, CLA_FORMA_PAGO));

   Create Table #tmpBanco
  (CLA_BANCO    Integer        Not Null,
   NOM_BANCO    Varchar(100)   Not Null,
   Constraint tmpBancoPk
   Primary Key (CLA_BANCO));

   Create Table #tmpClasificacion
  (CLA_EMPRESA       Integer        Not Null,
   CLA_CLASIFICACION Integer        Not Null,
   NOM_CLASIFICACION Varchar(100)   Not Null,
   Constraint tmpClasificacionPk
   Primary Key (CLA_EMPRESA, CLA_CLASIFICACION));

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


   Create Table #tmpNominasTrab
  (CLA_TRAB          Integer           Null,
   NOM_TRAB          Varchar(150)      Null,
   FECHA_ING         Varchar( 10)      Null,
   FECHA_ING_GRUPO   Varchar( 10)      Null,
   NSS               Varchar( 20)      Null,
   RFC               Varchar( 20)      Null,
   CLA_EMPRESA       Integer       Not Null,
   CLA_RAZON_SOCIAL  Integer       Not Null,
   CLA_PERIODO       Integer       Not Null,
   NUM_NOMINA        Integer       Not Null,
   NOM_AREA          Varchar(150)      Null,
   CLA_UBICACION     Integer       Not Null,
   NOM_UBICACION     Varchar(150)      Null,
   NOM_DEPTO         Varchar(150)      Null,
   NOM_PUESTO        Varchar(150)      Null,
   NOM_PERIODO       Varchar(150)      Null,
   TIPO_COMPANIERO   Varchar(150)      Null,
   ANIO_MES          Integer           Null,
   INICIO_PER        Varchar( 10)      Null,
   FIN_PER           Varchar( 10)      Null,
   SUE_DIA           Decimal(18, 2) Not Null Default 0,
   SUE_INT           Decimal(18, 2) Not Null Default 0,
   TOT_PER           Decimal(18, 2) Not Null Default 0,
   TOT_DED           Decimal(18, 2) Not Null Default 0,
   TOT_NETO          Decimal(18, 2) Not Null Default 0,
   DIAS_POR_PAGAR    Decimal(18, 2)     Null Default 0,
   Index tmpNominasTrabIdx01 (CLA_EMPRESA, CLA_PERIODO, CLA_TRAB, ANIO_MES, NUM_NOMINA));

   Set @IdEnc = Object_id('tempdb..#tmpNominasTrab');

--
-- Inicio de Proceso.
--

   Insert Into  #ColumnasNoAplica
  (NomColumna)
   Select NomColumna
   From   dbo.ColumnasNoAplicaTbl
   Where  procedimiento = 'SP_NOMINA_TABULAR_XLS'
   And    Nivel         = 1
   Order  by secuencia;

   If @ClaUsuario = 3    And
     @TipoNom     = '68'
     Begin
        Insert Into #ColumnasNoAplica
       (NomColumna)
        Select NomColumna
        From   dbo.ColumnasNoAplicaTbl
        Where  procedimiento = 'SP_NOMINA_TABULAR_XLS'
        And    Nivel         = 2
        Order  by secuencia;
     End
--
   Insert Into #ColumnasNoAplica2
  (CLA_PERDED)
   Select cla_perded
   From   dbo.RH_PERDED
   Where  ES_PROVISION    = 0
   And    NO_IMPRIMIR     = 1
   And    NO_AFECTAR_NETO = 1;

   If @Nominas is not null
      Begin
         Set @Nominas = '[' + Isnull(@ClaPer, '0') + '-' +
                         Replace(Replace(Isnull(@Nominas,'0'),
                         Space(1),''), ',', '],[' + Isnull(@ClaPer,'0') + '-') +']';;
      End

   Select @ClaUbicacion   = '[' + Replace(Isnull(@ClaUbicacion,  '0'), ',', '],[') + ']',
          @ClaRegImss     = '[' + Replace(Isnull(@ClaRegImss,    '0'), ',', '],[') + ']',
          @ClaCentroCosto = '[' + Replace(Isnull(@ClaCentroCosto,'0'), ',', '],[') + ']',
          @ClaDepto       = '[' + Replace(Isnull(@ClaDepto,      '0'), ',', '],[') + ']',
          @TipoNom        = '[' + Replace(Isnull(@TipoNom,       '0'), ',', '],[') + ']',
          @ClaPer         = '['+  Replace(Isnull(@ClaPer,        '0'), ',', '],[') + ']',
          @ClaTrab        = '['+  Replace(Isnull(@ClaTrab,       '0'), ',', '],[') + ']',
          @ClaPerded      = '['+  Replace(Isnull(@ClaPerded,     '0'), ',', '],[') + ']',
          @MostrarTodos   = Isnull(@MostrarTodos,  0),
          @MostrarProv    = Isnull(@MostrarProv,   0),
          @ClaUniNeg      = Isnull(@ClaUniNeg,     0),
          @TipoConcepto   = Isnull(@TipoConcepto,  0),
          @DetalladoXNom  = Isnull(@DetalladoXNom, 0);

   If @Nominas is Not Null
      Begin
         Insert Into #tmpNominas
         (CLA_EMPRESA, CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
          INICIO_PER,  FIN_PER,          CLA_RAZON_SOCIAL, ANIO,
          NOM_PERIODO, NOM_RAZON_SOCIAL, NOM_TIPO_NOMINA,  STRING)
         Select t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,       t1.ANIO_MES,
                t1.INICIO_PER,  t1.FIN_PER,          t2.CLA_RAZON_SOCIAL, t1.ANIO_MES / 100 ANIO,
                t2.NOM_PERIODO, t3.NOM_RAZON_SOCIAL, t4.NOM_TIPO_NOMINA,
                Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
         From   dbo.RH_FECHA_PER t1
         Join   dbo.RH_PERIODO   t2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO = t1.CLA_PERIODO
         Join   dbo.RH_RAZON_SOCIAL t3
         On     t3.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t3.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
         Join   dbo.RH_TIPO_NOMINA t4
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
         Where  t1.CLA_EMPRESA      = @ClaEmp
         And   (Charindex('[' + Convert(Varchar,    T1.CLA_PERIODO) + ']', @ClaPer) > 0
         Or     @ClaPer  = '[0]')
         And   (Charindex('[' + Convert(Varchar(2), T1.TIPO_NOMINA) + ']', @TipoNom) > 0
         Or     @TipoNom = '[0]')
         And   (Charindex('[' + RTRIM(LTRIM(STR(T1.CLA_PERIODO))) + '-' + RTRIM(LTRIM(STR(T1.NUM_NOMINA)))+']',@Nominas)> 0
         Or     @Nominas = '[0]')
         And    t2.CLA_RAZON_SOCIAL  = @ClaRz
         And    T1.STATUS_NOMINA     = @statusNom;
      End
   Else
      Begin
         Insert Into  #tmpNominas
         (CLA_EMPRESA, CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,
          INICIO_PER,  FIN_PER,          CLA_RAZON_SOCIAL, ANIO,
          NOM_PERIODO, NOM_RAZON_SOCIAL, NOM_TIPO_NOMINA,  STRING)
         Select t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,       t1.ANIO_MES,
                t1.INICIO_PER,  t1.FIN_PER,          t2.CLA_RAZON_SOCIAL, t1.ANIO_MES / 100 ANIO,
                t2.NOM_PERIODO, t3.NOM_RAZON_SOCIAL, t4.NOM_TIPO_NOMINA,
                Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
         From   dbo.RH_FECHA_PER t1
         Join   dbo.RH_PERIODO t2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO = t1.CLA_PERIODO
         Join   dbo.RH_RAZON_SOCIAL t3
         On     t3.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t3.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
         Join   dbo.RH_TIPO_NOMINA t4
         On     t4.TIPO_NOMINA = t1.TIPO_NOMINA
         Where  t1.CLA_EMPRESA = @ClaEmp
         And   (Charindex('[' + Convert(Varchar,T1.CLA_PERIODO)+']',@ClaPer)>0 Or @ClaPer='[0]')
         And   (Charindex('[' +Convert(Varchar(2),T1.TIPO_NOMINA)+']',@TipoNom)>0 Or @TipoNom='[0]')
         And   t2.CLA_RAZON_SOCIAL = @ClaRz
         And   t1.anio_mes     Between @AnioMesIni And @AnioMesFin
         And   T1.STATUS_NOMINA       = @statusNom

      End

   Select CLA_TRAB, CLA_EMPRESA,
          UPPER(RTRIM(NOM_TRAB))   NOM_TRAB ,
          UPPER(RTRIM(AP_PATERNO)) AP_PATERNO ,
          UPPER(RTRIM(AP_MATERNO)) AP_MATERNO ,
          UPPER(Concat(AP_PATERNO, SPACE(1), AP_MATERNO, SPACE(1), NOM_TRAB)) NOMBRE,
          RTRIM(NUM_IMSS) NSS ,
          RTRIM(CURP) CURP ,
          RTRIM(RFC) RFC,
          Convert(Varchar, FECHA_ING, 101)       AS FECHA_ING,
          Convert(Varchar, FECHA_ING_GRUPO, 101) AS FECHA_ING_GRUPO,
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
   Into  #tmpTrabNombres
   From  dbo.RH_TRAB
   Where CLA_EMPRESA = @ClaEmp
   And   dbo.fnc_ValidaSysSeguridadStd(10, CLA_EMPRESA, @ClaUsuario, CLA_UBICACION_BASE,
         CLA_DEPTO, CLA_PERIODO) > 0
   And  (Charindex('['+Convert(Varchar,CLA_TRAB)+']',@ClaTrab) > 0
   Or    @ClaTrab  = '[0]')

   Create Index I_tmpTrabNombresIdx01 On #tmpTrabNombres(CLA_EMPRESA, CLA_TRAB);

   If @statusNom = 9
      Begin
         Insert Into #tmpPerded1
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
                NULL MOSTRAR_MONTO
         From   dbo.RH_PERDED        T1
         Join   dbo.RH_DET_REC_HISTO T2
         On     T1.CLA_EMPRESA = T2.CLA_EMPRESA
         And    T1.CLA_PERDED  = T2.CLA_PERDED
         And    T1.CLA_EMPRESA = T2.CLA_EMPRESA
         Join   #tmpNominas T3
         On     T2.NUM_NOMINA      = T3.NUM_NOMINA
         And    T2.CLA_PERIODO     = T3.CLA_PERIODO
         And    T2.CLA_EMPRESA     = T3.CLA_EMPRESA
         Where  T1.CLA_EMPRESA     = @ClaEmp
         And   (T1.TIPO_PERDED     = @TipoConcepto
         Or     @TipoConcepto      = 0 )
         And   (T1.NO_AFECTAR_NETO = 0
         Or    (T1.NO_AFECTAR_NETO = 1
         And    T1.NO_IMPRIMIR     = 1
         And    T1.ES_PROVISION    = @MostrarProv))
         And   (Charindex('[' + Convert(Varchar, T1.CLA_PERDED) + ']', @ClaPerded) > 0
         Or     @ClaPerded         = '[0]')
         And    Not Exists         ( Select Top 1 1
                                     From   #ColumnasNoAplica2
                                     Where  ClaPerded = T1.CLA_PERDED)
         Order  By NO_AFECTAR_NETO, ES_PROVISION, TIPO_PERDED, ORDEN, CLA_PERDED;
      End
   Else
      Begin
         Insert #tmpPerded1
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
         On     T1.CLA_EMPRESA     = T2.CLA_EMPRESA
         And    T1.CLA_PERDED      = T2.CLA_PERDED
         And    T1.CLA_EMPRESA     = T2.CLA_EMPRESA
         Join   #tmpNominas T3
         On     T2.NUM_NOMINA      = T3.NUM_NOMINA
         And    T2.CLA_PERIODO     = T3.CLA_PERIODO
         And    T2.CLA_EMPRESA     = T3.CLA_EMPRESA
         Where  T1.CLA_EMPRESA     = @ClaEmp
         And   (T1.NO_AFECTAR_NETO = 0
         Or    (T1.NO_AFECTAR_NETO = 1
         And    T1.NO_IMPRIMIR     = 1
         And    T1.ES_PROVISION    = @MostrarProv))
         And   (Charindex('[' + Convert(Varchar, T1.CLA_PERDED) + ']', @ClaPerded) > 0
         Or     @ClaPerded         = '[0]')
         And    Not Exists         ( Select Top 1 1
                                     From   #ColumnasNoAplica2
                                     Where  Cla_Perded = T1.CLA_PERDED)
         Order  BY NO_AFECTAR_NETO, ES_PROVISION, TIPO_PERDED, ORDEN, CLA_PERDED;
      End
--
   Insert Into #tmpPerded
  (CLA_PERDED,   CLA_EMPRESA, NOM_PERDED,      TIPO_PERDED,  CLASIFICACION,
   ES_PROVISION, ESBASE_IMSS, NO_AFECTAR_NETO, ESBASE_ISPT,  ORDEN,
   MOSTRAR_MONTO)
   Select CLA_PERDED,   CLA_EMPRESA, NOM_PERDED,      TIPO_PERDED,  CLASIFICACION,
          ES_PROVISION, ESBASE_IMSS, NO_AFECTAR_NETO, ESBASE_ISPT,  ORDEN,
          MOSTRAR_MONTO
   From   #tmpPerded1 T1;

   If @ClaUsuario = 3 And
      @TipoNom    = '68'
      Begin
         Delete #tmpPerded
         Where  CLA_PERDED In (280, 2103, 2104, 2105, 2106, 2107)
      End

   Insert Into #tmpUbicacion
   (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
   Select T1.CLA_EMPRESA, T1.CLA_UBICACION, T1.NOM_UBICACION NOM_UBICACION
   From   dbo.RH_UBICACION T1
   Where  CLA_EMPRESA = @ClaEmp
   And   (Charindex('['+Convert(Varchar,T1.CLA_UBICACION)+']',@ClaUbicacion) > 0
   Or     @ClaUbicacion = '[0]');

   Insert Into #tmpRegImss
   Select CLA_EMPRESA, CLA_REG_IMSS, NUM_REG_IMSS,
          NOM_REG_IMSS
   From   dbo.RH_REG_IMSS
   Where  CLA_EMPRESA = @ClaEmp
   And   (Charindex('[' + Convert(Varchar, CLA_REG_IMSS) + ']', @ClaRegImss) > 0
   Or     @ClaRegImss = '[0]')

   Insert Into   #tmpCC
   Select CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO
   From   dbo.RH_CENTRO_COSTO
   Where  CLA_EMPRESA = @ClaEmp
   And   (Charindex('[' + Convert(Varchar,CLA_CENTRO_COSTO) + ']', @ClaCentroCosto) > 0
   Or     @ClaCentroCosto = '[0]')

   Insert Into #tmpDepto
   Select t1.CLA_EMPRESA, t1.CLA_DEPTO, t1.NOM_DEPTO,
          t2.CLA_AREA,    t2.NOM_AREA
   From   dbo.RH_DEPTO     t1
   LEFT   Join dbo.RH_AREA t2
   On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
   And    t2.CLA_AREA    = t1.CLA_AREA
   Where  t1.CLA_EMPRESA = @ClaEmp
   And   (Charindex('[' + Convert(Varchar, t1.CLA_DEPTO) + ']', @ClaDepto) > 0
   Or     @ClaDepto = '[0]')

   Insert Into #tmpPuesto
   Select t1.CLA_EMPRESA, t1.CLA_PUESTO,  t1.NOM_PUESTO
   From   dbo.RH_PUESTO t1
   Where  t1.CLA_EMPRESA = @ClaEmp;

--

   Insert Into #tmpFormaPago
   Select CLA_EMPRESA, CLA_FORMA_PAGO, NOM_FORMA_PAGO
   From   dbo.RH_FORMA_PAGO
   Where  CLA_EMPRESA = @ClaEmp;

   Insert Into #tmpBanco
   Select CLA_BANCO, NOM_BANCO
   From   dbo.RH_BANCO;

   Insert INTO  #tmpClasificacion
   Select CLA_EMPRESA, CLA_CLASIFICACION, NOM_CLASIFICACION
   From   dbo.RH_CLASIFICACION
   Where  CLA_EMPRESA = @ClaEmp;

   Insert Into  #tmpRoll
   Select CLA_EMPRESA,CLA_ROLL,NOM_ROLL
   From   dbo.RH_ROLL_TURNO
   Where CLA_EMPRESA=@ClaEmp
   And NOT Exists(Select VALOR_DATO_INT1
                  From   dbo.RH_DET_CONFIG_GENERAL
                  Where  CLA_DATO = 27
                  And VALOR_DATO_INT1=1)
   Union
   Select CLA_EMPRESA,CLA_PERFIL_TURNO,NOM_PERFIL_TURNO
   From   dbo.RELOJ_PERFIL_TURNO
   Where  CLA_EMPRESA = @ClaEmp
   And    Exists      ( Select Top 1 1
                        From   dbo.RH_DET_CONFIG_GENERAL
                        Where  CLA_DATO        = 27
                        And    VALOR_DATO_INT1 = 1)

   Insert Into #tmpTabSue
   Select CLA_EMPRESA, CLA_TAB_SUE, NOM_TAB_SUE
   From   dbo.RH_TAB_SUE
   Where  CLA_EMPRESA = @ClaEmp;

   Insert Into #DIAS_POR_PAGAR
  (CLA_EMPRESA, CLA_TRAB, CLA_PERIODO, NUM_NOMINA,
   ANIO_MES,    DIAS_POR_PAGAR)
   Select a.cla_empresa, a.CLA_TRAB, a.CLA_PERIODO, a.NUM_NOMINA, a.ANIO_MES,
          SUM(Case When b.tipo_perded = 10
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
   Group  By a.cla_empresa, a.CLA_TRAB, a.CLA_PERIODO, a.ANIO_MES, a.NUM_NOMINA;

   Insert Into #tmpNominasTrab
  (CLA_EMPRESA, CLA_RAZON_SOCIAL, CLA_PERIODO,   NUM_NOMINA,
   NOM_AREA,    CLA_UBICACION,    NOM_UBICACION, NOM_DEPTO,
   NOM_PUESTO,  NOM_PERIODO,      CLA_TRAB,      NOM_TRAB,
   FECHA_ING,   FECHA_ING_GRUPO,  NSS,           RFC,
   ANIO_MES,    INICIO_PER,       FIN_PER,       SUE_DIA,
   SUE_INT,     TOT_PER,          TOT_DED,       TOT_NETO,
   Tipo_Companiero, DIAS_POR_PAGAR)
   Select T1.CLA_EMPRESA, T1.CLA_RAZON_SOCIAL, T1.CLA_PERIODO,   t1.NUM_NOMINA ,
          t7.NOM_AREA,    t5.CLA_UBICACION,    t5.NOM_UBICACION, T7.NOM_DEPTO,
          t13.NOM_PUESTO, t1.NOM_PERIODO,      t2.CLA_TRAB,
          Concat(t3.AP_PATERNO, ' ', t3.AP_MATERNO, ' ', t3.NOM_TRAB),
          Convert(Varchar, t3.FECHA_ING,       101),
          Convert(Varchar, t3.FECHA_ING_GRUPO, 101),
          t3.NSS, t3.RFC,  T2.ANIO_MES,
          Convert(Varchar(10), T1.INICIO_PER,103),
          Convert(Varchar(10), T1.FIN_PER,103) FIN_PER,
          t2.SUE_DIA,
          t2.SUE_INT,
          t2.TOT_PER,
          t2.TOT_DED,
          t2.TOT_NETO,
          t3.SINDICALIZADO, Isnull(t99.DIAS_POR_PAGAR, 0)
   From  #tmpNominas          t1
   Join  dbo.RH_ENC_REC_HISTO t2
   On    t2.ANIO_MES    = t1.ANIO_MES
   And   t2.CLA_EMPRESA = t1.CLA_EMPRESA
   And   t2.CLA_PERIODO = t1.CLA_PERIODO
   And   t2.NUM_NOMINA  = t1.NUM_NOMINA
   Join  #tmpTrabNombres      t3
   On    t3.CLA_EMPRESA = t2.CLA_EMPRESA
   And   t3.CLA_TRAB    = t2.CLA_TRAB
   Join  #tmpRegImss          t4
   On    t4.CLA_EMPRESA  = t2.CLA_EMPRESA
   And   t4.CLA_REG_IMSS = t2.CLA_REG_IMSS
   Join  #tmpUbicacion        t5
   On    t5.CLA_EMPRESA   = t2.CLA_EMPRESA
   And   t5.CLA_UBICACION = t2.CLA_UBICACION_BASE
   Join  #tmpCC               t6
   On    t6.CLA_EMPRESA      = t2.CLA_EMPRESA
   And   t6.CLA_CENTRO_COSTO = t2.CLA_CENTRO_COSTO
   Join  #tmpDepto            t7
   On    t7.CLA_EMPRESA      = t2.CLA_EMPRESA
   And   t7.CLA_DEPTO        = t2.CLA_DEPTO
   LEFT  Join #tmpFormaPago   t8
   On    t8.CLA_EMPRESA    = t2.CLA_EMPRESA
   And   t8.CLA_FORMA_PAGO = t2.CLA_FORMA_PAGO
   LEFT  Join #tmpBanco       t9
   On    t9.CLA_BANCO      = t3.CLA_BANCO
   Join  #tmpClasificacion    t10
   On    t10.CLA_EMPRESA       = t2.CLA_EMPRESA
   And   t10.CLA_CLASIFICACION = t2.CLA_CLASIFICACION
   Join  #tmpTabSue           t12
   On    t12.CLA_EMPRESA = t2.CLA_EMPRESA
   And   t12.CLA_TAB_SUE = t2.CLA_TAB_SUE
   Left  Join  #tmpPuesto           t13
   On    t13.CLA_EMPRESA = t2.CLA_EMPRESA
   And   t13.CLA_PUESTO  = t2.CLA_PUESTO
   Left  Join  #DIAS_POR_PAGAR T99
   On    t99.CLA_EMPRESA = t2.CLA_EMPRESA
   And   t99.CLA_TRAB    = t2.CLA_TRAB
   And   t99.ANIO_MES    = t2.ANIO_MES
   And   t99.CLA_PERIODO = t2.CLA_PERIODO
   And   t99.NUM_NOMINA  = t2.NUM_NOMINA;

   If @IncluirNomAbiertas = 1
      And @statusNom = 1
      Begin
         Insert Into #tmpNominasTrab
        (CLA_EMPRESA, CLA_RAZON_SOCIAL, CLA_PERIODO,   NUM_NOMINA,
         NOM_AREA,    CLA_UBICACION,    NOM_UBICACION, NOM_DEPTO,
         NOM_PUESTO,  NOM_PERIODO,      CLA_TRAB,      NOM_TRAB,
         FECHA_ING,   FECHA_ING_GRUPO,  NSS,           RFC,
         ANIO_MES,    INICIO_PER,       FIN_PER,       SUE_DIA,
         SUE_INT,     TOT_PER,          TOT_DED,       TOT_NETO,
         Tipo_Companiero, DIAS_POR_PAGAR)
         Select T1.CLA_EMPRESA,   T1.CLA_RAZON_SOCIAL, T1.CLA_PERIODO,
                t1.NUM_NOMINA,    t7.NOM_AREA,         t5.CLA_UBICACION,
                t5.NOM_UBICACION, t7.NOM_DEPTO,        t13.NOM_PUESTO,
                t1.NOM_PERIODO,   t2.CLA_TRAB,
                Concat(t3.AP_PATERNO, ' ', t3.AP_MATERNO, ' ', t3.NOM_TRAB) NOM_TRAB,
                Convert(Varchar, t3.FECHA_ING,       101)  FECHA_ING,
                Convert(Varchar, t3.FECHA_ING_GRUPO, 101)  FECHA_ING_GRUPO,
                t3.NSS,
                t3.RFC,
                T2.ANIO_MES_ISPT ANIO_MES,
                Convert(Varchar(10),T1.INICIO_PER,103) INICIO_PER,
                Convert(Varchar(10),T1.FIN_PER,103) FIN_PER,
                t2.SUE_DIA,
                t2.SUE_INT,
                t2.TOT_PER,
                t2.TOT_DED,
                t2.TOT_NETO,
                t3.SINDICALIZADO, Isnull(t99.DIAS_POR_PAGAR, 0)
         From   #tmpNominas           t1
         Join   dbo.RH_ENC_REC_ACTUAL t2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO = t1.CLA_PERIODO
         And    t2.NUM_NOMINA  = t1.NUM_NOMINA
         Join   #tmpTrabNombres       t3
         On     t3.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t3.CLA_TRAB    = t2.CLA_TRAB
         Join   #tmpRegImss t4
         On     t4.CLA_EMPRESA  = t2.CLA_EMPRESA
         And    t4.CLA_REG_IMSS = t2.CLA_REG_IMSS
         Join   #tmpUbicacion t5
         On     t5.CLA_EMPRESA   = t2.CLA_EMPRESA
         And    t5.CLA_UBICACION = t2.CLA_UBICACION_BASE
         Join   #tmpCC        t6
         On     t6.CLA_EMPRESA      = t2.CLA_EMPRESA
         And    t6.CLA_CENTRO_COSTO = t2.CLA_CENTRO_COSTO
         Join   #tmpDepto          t7
         On     t7.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t7.CLA_DEPTO   = t2.CLA_DEPTO
         Left   Join #tmpFormaPago t8
         On     t8.CLA_EMPRESA    = t2.CLA_EMPRESA
         And    t8.CLA_FORMA_PAGO = t2.CLA_FORMA_PAGO
         Left   Join #tmpBanco     t9
         On     t9.CLA_BANCO = t3.CLA_BANCO
         Join   #tmpClasificacion  t10
         On     t10.CLA_EMPRESA       = t2.CLA_EMPRESA
         And    t10.CLA_CLASIFICACION = t2.CLA_CLASIFICACION
         Join   #tmpTabSue t12 On t12.CLA_EMPRESA = t2.CLA_EMPRESA And
                  t12.CLA_TAB_SUE = t2.CLA_TAB_SUE
         Join   #tmpPuesto t13 On t13.CLA_EMPRESA = t2.CLA_EMPRESA
         And    t13.CLA_PUESTO = t2.CLA_PUESTO
         Left  Join  #DIAS_POR_PAGAR T99
         On    t99.CLA_EMPRESA = t2.CLA_EMPRESA
         And   t99.CLA_TRAB    = t2.CLA_TRAB
         And   t99.ANIO_MES    = t2.ANIO_MES
         And   t99.CLA_PERIODO = t2.CLA_PERIODO
         And   t99.NUM_NOMINA  = t2.NUM_NOMINA;

    End

    Select t1.CLA_TRAB,
      Max(t1.CLA_EMPRESA) CLA_EMPRESA,
      t1.CLA_PERIODO,
      t1.NUM_NOMINA,
      Max(t1.ANIO_MES)ANIO_MES,
      T3.CLA_PERDED,
      Max(t3.NOM_PERDED)NOM_PERDED,
      SUM(t2.MONTO)MONTO,
      SUM(CAST(t2.IMPORTE AS DECIMAL(10,2)))IMPORTE,
      SUM(CAST(t2.EXENTO AS DECIMAL(10,2)))EXENTO,
      SUM(CAST(t2.IMPORTE-t2.EXENTO AS DECIMAL(10,2)))GRAVADO,
      SUM(CAST(t2.GRAV_IMSS AS DECIMAL(10,2)))GRAV_IMSS,
      Max(T3.TIPO_PERDED)TIPO_PERDED,
      Max(t3.ES_PROVISION)ES_PROVISION,
      Max(t3.ESBASE_IMSS)ESBASE_IMSS,
      Max(t3.NO_AFECTAR_NETO)NO_AFECTAR_NETO,
      Max(t3.ESBASE_ISPT)ESBASE_ISPT,
      Max(t1.CLA_RAZON_SOCIAL)CLA_RAZON_SOCIAL,
      Max(t3.ORDEN)ORDEN
  INTO #tmpPagosConceptos
  From #tmpNominasTrab t1
  INNER Join dbo.RH_DET_REC_HISTO t2
  On t2.ANIO_MES = t1.ANIO_MES And
                    t2.CLA_TRAB = t1.CLA_TRAB And
                    t2.CLA_EMPRESA = t1.CLA_EMPRESA And
                    t2.CLA_PERIODO = t1.CLA_PERIODO And
                    t2.NUM_NOMINA = t1.NUM_NOMINA
           INNER Join #tmpPerded t3 On t3.CLA_EMPRESA = t2.CLA_EMPRESA And
                  t3.CLA_PERDED = t2.CLA_PERDED
  GROUP BY t1.CLA_TRAB,t1.CLA_PERIODO,T3.CLA_PERDED,t1.NUM_NOMINA

 If @IncluirNomAbiertas = 1
   And @statusNom = 1


  Insert INTO #tmpPagosConceptos
  Select t1.CLA_TRAB,
      Max(t1.CLA_EMPRESA) CLA_EMPRESA,
      t1.CLA_PERIODO,
      t1.NUM_NOMINA,
      Max(t1.ANIO_MES)ANIO_MES,
      T3.CLA_PERDED,
      Max(t3.NOM_PERDED)NOM_PERDED,
      SUM(t2.MONTO)MONTO,
      SUM(CAST(t2.IMPORTE AS DECIMAL(10,2)))IMPORTE,
      SUM(CAST(t2.RES_EXE_SQL AS DECIMAL(10,2)))EXENTO,
      SUM(CAST(t2.IMPORTE-t2.RES_EXE_SQL AS DECIMAL(10,2)))GRAVADO,
      SUM(CAST(t2.GRAV_IMSS AS DECIMAL(10,2)))GRAV_IMSS,
      Max(T3.TIPO_PERDED)TIPO_PERDED,
      Max(t3.ES_PROVISION)ES_PROVISION,
      Max(t3.ESBASE_IMSS)ESBASE_IMSS,
      Max(t3.NO_AFECTAR_NETO)NO_AFECTAR_NETO,
      Max(t1.CLA_RAZON_SOCIAL)CLA_RAZON_SOCIAL,
      Max(t3.ESBASE_ISPT)ESBASE_ISPT,
      Max(t3.ORDEN)ORDEN
  From #tmpNominasTrab t1 INNER Join dbo.RH_DET_REC_ACTUAL t2 On t2.CLA_TRAB = t1.CLA_TRAB And
                    t2.CLA_EMPRESA = t1.CLA_EMPRESA And
                    t2.CLA_PERIODO = t1.CLA_PERIODO And
                    t2.NUM_NOMINA = t1.NUM_NOMINA
           INNER Join #tmpPerded t3 On t3.CLA_EMPRESA = t2.CLA_EMPRESA And
                  t3.CLA_PERDED = t2.CLA_PERDED
  GROUP BY t1.CLA_TRAB,t1.CLA_PERIODO,T3.CLA_PERDED,t1.NUM_NOMINA

  CREATE CLUSTERED Index I_tmpPagosConceptos On #tmpPagosConceptos(CLA_TRAB,CLA_EMPRESA,CLA_PERIODO,NUM_NOMINA,ANIO_MES)

--
-- Búsqueda de columnas Iniciales.
--

  Select @w_colIniciales  = Count(1)
  From   tempdb.sys.syscolumns T1
  INNER  Join tempdb.SYS.types T2
  On     T1.xtype = T2.system_type_id
  And    T1.id    = @IdEnc;

--

  Select @Id = Min(ID)
  From   #tmpPerded

  WHILE @Id IS NOT NULL
  Begin
     Select @ClaveConcepto = Convert(Varchar,CLA_PERDED),
            @ColumnaNombre = NOM_PERDED,
            @ColumnaMonto  = Case When MOSTRAR_MONTO IS NOT NULL
                                  Then NOM_PERDED + '_' + MOSTRAR_MONTO
                                  Else
                             NULL End,

            @AlterColumnaMonto  = 'ALTER Table #tmpNominasTrab ADD ' + Case When MOSTRAR_MONTO IS NOT NULL Then NOM_PERDED+'_'+MOSTRAR_MONTO Else NULL End+' FLOAT NOT NULL DEFAULT(0)',
            @AlterColumnaNombre = 'ALTER Table #tmpNominasTrab ADD ' + NOM_PERDED+' FLOAT NOT NULL DEFAULT(0)'
     From   #tmpPerded
     Where  ID = @Id

     If @AlterColumnaMonto IS NOT NULL
        Begin
          EXECUTE(@AlterColumnaMonto)
        End

     If @AlterColumnaNombre IS NOT NULL
        Begin
          EXECUTE(@AlterColumnaNombre)
        End

     Set @Update = 'Update T1 ' +
                   ' SET ' + Case When @AlterColumnaMonto IS NOT NULL Then @ColumnaMonto + '=t2.MONTO,' Else '' End+
                             Case When @AlterColumnaNombre IS NOT NULL Then @ColumnaNombre+'=t2.IMPORTE' Else '' End+
                   ' From #tmpNominasTrab T1 ' +
                   ' Join #tmpPagosConceptos t2 On t2.ANIO_MES = T1.ANIO_MES '+
                               ' And t2.CLA_EMPRESA = T1.CLA_EMPRESA'+
                               ' And t2.CLA_PERIODO = T1.CLA_PERIODO'+
                               ' And t2.NUM_NOMINA = T1.NUM_NOMINA'+
                               ' And t2.CLA_TRAB = T1.CLA_TRAB'+
                               ' And t2.CLA_PERDED = '+@ClaveConcepto
     EXEC (@Update)

     Select @Id = Min(ID)
     From   #tmpPerded
     Where  ID > @Id
  End

   Select @Select        = '',
          @SelectCampos  = '',
          @SelectColumna = '',
          @w_lineaTotal  = '',
          @w_lineaTotal  = 'Select ';

  Select @OrdenMin      = Max(T1.colorder),
         @NumCamposMax  = Count(1)
  From   tempdb.sys.syscolumns T1
  INNER  Join tempdb.SYS.types T2
  On     T1.xtype = T2.system_type_id
  And    T1.id    = @IdEnc
  And    T1.name NOT In (Select NomColumna
                         From   #ColumnasNoAplica)
  If @DetalladoXNom = 1
     Begin
        Select @SelectCampos    = @SelectCampos  + Case When t2.name In ('float','decimal')
                                                        Then  'CAST('+T1.name+' AS decimal(10,2))'
                                                        Else T1.name
                                                   End + Case When @OrdenMin <> T1.colorder
                                                         Then ','
                                                         Else ''
                                                   End,
               @SelectColumna   = @SelectColumna + '''' + T1.name+'''' +
                                      Case When @OrdenMin <> T1.colorder
                                           Then ','
                                           Else ''
                                      End,
               @w_lineaTotal    = @w_lineaTotal + Case When T1.colorder <= @w_colIniciales
                                                       Then Char(39) + Char(32) + Char(39)
                                                       Else Concat('Sum(Case When CONCECUTIVO = 1 ',
                                                                           ' Then 0 ',
                                                                           ' Else Cast(Columna', T1.colorder, ' As Decimal(18, 2)) ',
                                                                      ' End )')
                                                  End  + Case When @OrdenMin <> T1.colorder
                                                              Then ','
                                                              Else Char(32)
                                                         End
        From  tempdb.sys.syscolumns T1
        Join  tempdb.SYS.types T2
        On    T1.xtype     = T2.system_type_id
        Where id           = @IdEnc
        And   T1.name Not In (Select NomColumna
                              From   #ColumnasNoAplica)
        Order BY T1.colorder

    End
  Else
     Begin
        Select @SelectCampos  = @SelectCampos + Case When t2.name NOT In ('Integer', 'float','decimal') Or t1.name
                                                                      In ('ANTIGUEDAD','CLA_TRAB','NOM_TRAB','ANTIGUEDAD_GPO','SUE_DIA','SUE_INT','ANIO','NUMERO','SDI_LFT','PARTE_VARIABLE_LFT','RFC','CURP''NSS') Then 'Max('+T1.name+')'Else 'SUM(CAST('+T1.name+' AS decimal(10,2)))' End+Case When @OrdenMin<>T1.colorder Then ',' Else '' End ,
               @SelectColumna = @SelectColumna+''''+T1.name+''''+Case When @OrdenMin<>T1.colorder Then ',' Else '' End,
               @w_lineaTotal    = @w_lineaTotal + Case When T1.colorder <= @w_colIniciales
                                                       Then Char(39) + Char(32) + Char(39)
                                                       Else Concat('Sum(Case When CONCECUTIVO = 1 ',
                                                                           ' Then 0 ',
                                                                           ' Else Cast(Columna', T1.colorder, ' As Decimal(18, 2)) ',
                                                                      ' End )')
                                                  End  + Case When @OrdenMin <> T1.colorder
                                                              Then ','
                                                              Else Char(32)
                                                         End
        From   tempdb.sys.syscolumns T1
        Join   tempdb.SYS.types T2
        On     T1.xtype = T2.system_type_id
        Where  id       = @IdEnc
        And    T1.name NOT In (Select NomColumna
                               From   #ColumnasNoAplica)
        ORDER BY T1.colorder


     End

   Select @Select = 'Select ' + @SelectCampos +
                    ' From #tmpNominasTrab '+Case When @DetalladoXNom=0 Then ' GROUP BY CLA_TRAB ' Else ' ' End+' ORDER BY CLA_TRAB '

  Select @NumCamposMin = 1,
         @ColInsert    = ''

  WHILE @NumCamposMin <= @NumCamposMax
  Begin
    Select @ColInsert=@ColInsert + 'Columna'+Convert(Varchar,@NumCamposMin)+Case When @NumCamposMin<>@NumCamposMax Then  ',' Else '' End

    Select @NumCamposMin=@NumCamposMin + 1
  End

  EXEC('Insert INTO #tmpFinal (' + @ColInsert + ') ' +
       'Select '+ @SelectColumna)

  EXEC(' Insert INTO #tmpFinal (' + @ColInsert +') ' + @Select)

  EXEC(' Insert INTO #tmpFinal (' + @ColInsert +') ' + @w_lineaTotal + ' From #tmpFinal' )

  Set @w_registro = @@Identity;

  Update #tmpFinal
  Set    columna2    = 'TOTALES =====> '
  Where  CONCECUTIVO = @w_registro;

  Execute ('Select ' + @ColInsert + ' From #tmpFinal Order BY Concecutivo')

fin:

   Return

End
Go