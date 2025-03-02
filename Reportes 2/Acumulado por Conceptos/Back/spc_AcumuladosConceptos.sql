-- Declare
   -- @PnCla_RazonSocial         Integer        = 1,
   -- @PnAnio                    Integer        = 2025,
   -- @PnMesIni                  Integer        = Null,
   -- @PnMesFin                  Integer        = Null,
   -- @PsCla_Ubicacion           Varchar(Max)   = Null,
   -- @PsCla_CentroCosto         Varchar(Max)   = Null,
   -- @PsCla_Depto               Varchar(Max)   = Null,
   -- @PsCla_PerDed              Varchar(Max)   = Null,
   -- @PsCla_Periodo             Varchar(Max)   = Null,
   -- @PsNominas                 Varchar(Max)   = Null,
   -- @PnError                   Integer        = 0,
   -- @PsMensaje                 Varchar( 250)  = ' ';
-- Begin
   -- Execute dbo.spc_AcumuladosConceptos @PnCla_RazonSocial = @PnCla_RazonSocial,
                                       -- @PnAnio            = @PnAnio,
                                       -- @PnMesIni          = @PnMesIni,
                                       -- @PnMesFin          = @PnMesFin,
                                       -- @PsCla_Ubicacion   = @PsCla_Ubicacion,
                                       -- @PsCla_CentroCosto = @PsCla_CentroCosto,
                                       -- @PsCla_Depto       = @PsCla_Depto,
                                       -- @PsCla_PerDed      = @PsCla_PerDed,
                                       -- @PsCla_Periodo     = @PsCla_Periodo,
                                       -- @PsNominas         = @PsNominas,
                                       -- @PnError           = @PnError   Output,
                                       -- @PsMensaje         = @PsMensaje Output;
   -- If @PnError != 0
      -- Begin
         -- Select @PnError, @PsMensaje;
      -- End

   -- Return

-- End
-- Go

Create Or Alter Procedure spc_AcumuladosConceptos
  (@PnCla_RazonSocial         Integer,
   @PnAnio                    Integer,
   @PnMesIni                  Integer        = Null,
   @PnMesFin                  Integer        = Null,
   @PsCla_Ubicacion           Varchar(Max)   = Null,
   @PsCla_CentroCosto         Varchar(Max)   = Null,
   @PsCla_Depto               Varchar(Max)   = Null,
   @PsCla_TipoNom             Varchar(Max)   = Null,
   @PsCla_PerDed              Varchar(Max)   = Null,
   @PsCla_Periodo             Varchar(Max)   = Null,
   @PsNominas                 Varchar(Max)   = Null,
   @PnError                   Integer        = 0    Output,
   @PsMensaje                 Varchar( 250)  = Null Output)
As

Declare
   @w_desc_error              Varchar(250),
   @w_nom_razon_social        Varchar(350),
   @w_tituloRep               Varchar(350),
   @w_fechaProc               Varchar( 10),
   @w_fechaProcIni            Varchar( 10),
   @w_fechaProcFin            Varchar( 10),
   @w_nominas                 Varchar(Max),
   @w_nomina                  Varchar( 10),
   @w_nom_ubicacion           Varchar( 80),
   @w_nom_centro_costo        Varchar( 80),
   @w_nom_depto               Varchar( 80),
   @w_nom_perded              Varchar( 80),
   @w_cla_perded              Varchar( 20),
   @w_chimporte               Varchar( 20),
   @w_cla_depto               Integer,
   @w_cla_ubicacion           Integer,
   @w_cla_centro_costo        Integer,
   @w_Error                   Integer,
   @w_secuencia               Integer,
   @w_registros               Integer,
   @w_cla_empresa             Integer,
   @w_MesIni                  Integer,
   @w_MesFin                  Integer,
   @w_AnioMesIni              Integer,
   @w_AnioMesFin              Integer,
   @w_reg                     Integer,
   @w_secFin                  Integer,
   @w_horaProceso             Char(20);

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off
   Set Ansi_Warnings On

   Select @PnError       = 0,
          @w_reg         = 0,
          @w_registros   = 0,
          @w_secuencia   = 0,
          @w_nominas     = '',
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
-- Validaciones de Parametros de Entrada.
--

   Select @w_cla_empresa      = cla_empresa,
          @w_nom_razon_social = Concat(nom_razon_social, ' - ', rfc_emp)
   From   dbo.rh_razon_social
   Where  cla_razon_social = @PnCla_RazonSocial;
   If @@Rowcount = 0
      Begin
         Select @PnError   = 2,
                @PsMensaje = 'La Razón Social Seleccionada no es Válida'

         Select @PnError IdError, @PsMensaje Error
         Set Xact_Abort Off
         Return
      End

--
-- Creación de Tablas Temporales.
--

   Create  Table #tmpPerded
  (CLA_EMPRESA       Integer      Not Null,
   CLA_PERDED        Integer      Not Null,
   NOM_PERDED        Varchar( 80) Not  Null,
   TIPO_PERDED       Integer      Not Null,
   Constraint tmpPerdedPk
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
   TIPO_NOMINA      INTEGER          Null,
   NOM_TIPO_NOMINA  Varchar( 80) Not Null,
   STRING           Varchar(Max) Not Null,
   Constraint tmpNominasPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO, NUM_NOMINA));

   Create Table #tmpUbicacion
  (CLA_EMPRESA         Integer      Not Null,
   CLA_UBICACION       Integer      Not Null,
   NOM_UBICACION       Varchar(100) Not Null,
   Constraint tmpUbicacionPk
   Primary Key (CLA_EMPRESA, CLA_UBICACION));

   Create Table #tmpCentroCosto
  (CLA_EMPRESA         Integer      Not Null,
   CLA_CENTRO_COSTO    Integer      Not Null,
   NOM_CENTRO_COSTO    Varchar(100) Not Null,
   Constraint tmpCCPk
   Primary Key (CLA_EMPRESA, CLA_CENTRO_COSTO));

   Create Table #tempDepto
  (CLA_EMPRESA         Integer       Not Null,
   CLA_DEPTO           Integer       Not Null,
   NOM_DEPTO           Varchar(100)  Not Null,
   Constraint tmpDeptoPk
   Primary Key (CLA_EMPRESA, CLA_DEPTO));

   Create Table #tempTipoNom
  (TIPO_NOMINA            Integer       Not Null,
   NOM_TIPO_NOMINA        Varchar(100)  Not Null,
   Constraint tempTipoNomPk
   Primary Key (TIPO_NOMINA));

   Create Table #tempPeriodo
  (CLA_EMPRESA  Integer       Not Null,
   CLA_PERIODO  Integer       Not Null,
   NOM_PERIODO  Varchar(100)  Not Null,
   Constraint tempPeriodoPk
   Primary Key (CLA_EMPRESA, CLA_PERIODO));

   Create Table #tmpImporteNominas
  (secuencia         Integer        Not Null Identity (1, 1) Primary Key,
   CLA_EMPRESA       Integer        Not Null,
   CLA_PERIODO       Integer        Not Null,
   NUM_NOMINA        Integer        Not Null,
   CLA_UBICACION     Integer        Not Null,
   NOM_UBICACION     Varchar(150)       Null,
   CLA_CENTRO_COSTO  Integer        Not Null,
   NOM_CENTRO_COSTO  Varchar(150)   Not Null,
   CLA_DEPTO         Integer        Not Null,
   NOM_DEPTO         Varchar(150)   Not Null,
   NOM_PERIODO       Varchar(150)       Null,
   NOM_TIPO_NOMINA   Varchar( 10)       Null,
   ANIO_MES          Integer            Null,
   INICIO_PER        Varchar( 10)       Null,
   FIN_PER           Varchar( 10)       Null,
   CLA_PERDED        Integer        Not Null,
   NOM_PERDED        Varchar( 80)   Not Null,
   TIPO_PERDED       Integer        Not Null,
   IMPORTE           Decimal(18, 2) Not Null Default 0,
   SALDO             Decimal(18, 2) Not Null Default 0,
   SALDO_EXENTO      Decimal(18, 2) Not Null Default 0,
   SALDO_GRAVADO     Decimal(18, 2) Not Null Default 0,
   Index tmpNominasTrabIdx01 (CLA_EMPRESA, CLA_PERIODO, ANIO_MES, NUM_NOMINA, CLA_PERDED));

   Create Table #tmpResultado
  (secuencia           Integer        Not Null Identity (1, 1) Primary Key,
   CLA_UBICACION       Integer        Not Null Default 999999,
   NOM_UBICACION       Varchar(150)   Not Null Default Char(32),
   CLA_CENTRO_COSTO    Integer        Not Null Default 999999,
   NOM_CENTRO_COSTO    Varchar(100)   Not Null Default Char(32),
   CLA_DEPTO           Integer        Not Null Default 999999,
   NOM_DEPTO           Varchar(150)   Not Null Default Char(32),
   CLA_PERDED          Integer        Not Null Default 999999,
   PERDED_1            Varchar( 15)       Null Default Char(32),
   NOMDED_1            Varchar( 80)       Null Default Char(32),
   IMPORTE1            Varchar( 20)       Null Default Char(32),
   SALDO               Varchar( 20)       Null Default Char(32),
   SALDO_EXENTO        Varchar( 20)       Null Default Char(32),
   SALDO_GRAVADO       Varchar( 20)       Null Default Char(32),
   PERDED_2            Varchar( 20)       Null Default Char(32),
   NOMDED_2            Varchar( 80)       Null Default Char(32),
   IMPORTE2            Varchar( 20)       Null Default Char(32),
   PERDED_3            Varchar( 20)       Null Default Char(32),
   NOMDED_3            Varchar( 80)       Null Default Char(32),
   IMPORTE3            Varchar( 20)       Null Default Char(32))

--
-- Consulta de Ubicación.
--

   If @PsCla_Ubicacion Is Null
      Begin
         Insert Into #tmpUbicacion
        (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
         Select CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION
         From   dbo.RH_UBICACION
         Where  CLA_EMPRESA = @w_cla_empresa
      End
   Else
      Begin
         Insert Into #tmpUbicacion
        (CLA_EMPRESA, CLA_UBICACION, NOM_UBICACION)
         Select Distinct b.CLA_EMPRESA, b.CLA_UBICACION, b.NOM_UBICACION
         From   String_split(@PsCla_Ubicacion, ',') a
         Join   dbo.RH_UBICACION                    b
         On     b.CLA_UBICACION   = a.value
         Where  b.CLA_EMPRESA     = @w_cla_empresa;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 2,
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
         Select CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO
         From   dbo.RH_CENTRO_COSTO
         Where  CLA_EMPRESA = @w_cla_empresa
      End
   Else
      Begin
         Insert Into #tmpCentroCosto
        (CLA_EMPRESA, CLA_CENTRO_COSTO, NOM_CENTRO_COSTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_CENTRO_COSTO, b.NOM_CENTRO_COSTO
         From   String_split(@PsCla_CentroCosto, ',') a
         Join   dbo.RH_CENTRO_COSTO                    b
         On     b.CLA_CENTRO_COSTO = a.value
         Where  b.CLA_EMPRESA      = @w_cla_empresa;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 3,
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
         Insert Into #tempDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO)
         Select CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO
         From   dbo.RH_DEPTO
         Where  CLA_EMPRESA = @w_cla_empresa
      End
   Else
      Begin
         Insert Into #tempDepto
        (CLA_EMPRESA, CLA_DEPTO, NOM_DEPTO)
         Select Distinct b.CLA_EMPRESA, b.CLA_DEPTO, b.NOM_DEPTO
         From   String_split(@PsCla_Depto, ',') a
         Join   dbo.RH_DEPTO                    b
         On     b.CLA_DEPTO        = a.value
         Where  b.CLA_EMPRESA      = @w_cla_empresa;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 4,
                      @PsMensaje = 'La Lista de Departamentos Seleccionada no es es Válida'

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
               Select @PnError   = 5,
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
         Select CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO
         From   dbo.RH_PERIODO
         Where  CLA_EMPRESA      = @w_cla_empresa
         And    cla_razon_social = @PnCla_RazonSocial;
      End
   Else
      Begin
         Insert Into #tempPeriodo
        (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERIODO, b.NOM_PERIODO
         From   String_split(@PsCla_Periodo, ',') a
         Join   dbo.RH_PERIODO              b
         On     b.CLA_PERIODO      = a.value
         Where  b.CLA_EMPRESA      = @w_cla_empresa
         And    b.cla_razon_social = @PnCla_RazonSocial;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 6,
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
         Insert Into #tmpPerded
        (CLA_EMPRESA, CLA_PERDED, NOM_PERDED, TIPO_PERDED)
         Select CLA_EMPRESA, CLA_PERDED, NOM_PERDED,
                Case When TIPO_PERDED = 10
                     Then 1
                     Else 2
                End
         From   dbo.RH_PERDED
         Where  CLA_EMPRESA     = @w_cla_empresa
         And    NO_AFECTAR_NETO = 0
         And    NO_IMPRIMIR     = 0
         And    ES_PROVISION    = 0
         Union
         Select CLA_EMPRESA, CLA_PERDED, NOM_PERDED,
                3
         From   dbo.RH_PERDED
         Where  CLA_EMPRESA     = @w_cla_empresa
         And    ES_PROVISION    = 1
      End
   Else
      Begin
         Insert Into #tmpPerded
        (CLA_EMPRESA, CLA_PERDED, NOM_PERDED, TIPO_PERDED)
         Select b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                Case When b.TIPO_PERDED = 10
                     Then 1
                     Else 2
                End
         From   String_split(@PsCla_PerDed, ',') a
         Join   dbo.RH_PERDED                    b
         On     b.cla_perded      = a.value
         Where  b.CLA_EMPRESA     = @w_cla_empresa
         And    b.NO_AFECTAR_NETO = 0
         And    b.NO_IMPRIMIR     = 0
         And    b.ES_PROVISION    = 0
         Union
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                3
         From   String_split(@PsCla_PerDed, ',') a
         Join   dbo.RH_PERDED                    b
         On     b.cla_perded      = a.value
         Where  b.CLA_EMPRESA     = @w_cla_empresa
         And    b.ES_PROVISION    = 1;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 5,
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
         Select t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,          t1.ANIO_MES,
                t1.INICIO_PER,  t1.FIN_PER,          t1.ANIO_MES / 100 ANIO, t2.NOM_PERIODO,
                t4.TIPO_NOMINA,
                t4.NOM_TIPO_NOMINA, Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING
         From   dbo.RH_FECHA_PER t1
         Join   #tempPeriodo     t2
         On     t2.CLA_EMPRESA      = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO      = t1.CLA_PERIODO
         Join   #tempTipoNom        t4
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
         Where  t1.CLA_EMPRESA      = @w_CLA_EMPRESA;
         If @@Rowcount = 0
            Begin
               Select @PnError   = 6,
                      @PsMensaje = 'La Lista de Nóminas Seleccionada no es es Válida'

               Select @PnError IdError, @PsMensaje Error
               Set Xact_Abort Off
               Return
            End
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
         Join   dbo.RH_FECHA_PER t1
         On     t1.NUM_NOMINA  = t0.value
         Join   #tempPeriodo     t2
         On     t2.CLA_EMPRESA = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO = t1.CLA_PERIODO
         Join   #tempTipoNom        t4
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
         Where  t1.CLA_EMPRESA      = @w_CLA_EMPRESA;
      End

   Insert Into #tmpImporteNominas
  (CLA_EMPRESA,     CLA_PERIODO,        NUM_NOMINA,         NOM_UBICACION,
   NOM_DEPTO,       NOM_PERIODO,        ANIO_MES,           INICIO_PER,
   FIN_PER,         CLA_PERDED,         NOM_PERDED,         TIPO_PERDED,
   IMPORTE,         SALDO,              SALDO_GRAVADO,      SALDO_EXENTO,
   NOM_TIPO_NOMINA, NOM_CENTRO_COSTO,   CLA_UBICACION,      CLA_CENTRO_COSTO,
   CLA_DEPTO)
   Select a.CLA_EMPRESA,         a.CLA_PERIODO,   a.NUM_NOMINA,     b.NOM_UBICACION,
          c.NOM_DEPTO,           d.NOM_PERIODO,   d.ANIO_MES,       d.INICIO_PER,
          d.FIN_PER,             e.CLA_PERDED,    e.NOM_PERDED,     e.TIPO_PERDED,
          Sum(a.IMPORTE),        0,               Sum(a.GRAV_IMSS), Sum(EXENTO),
          Concat(Substring(h.NOM_TIPO_NOMINA, 1, 3), '-', Format(a.CLA_PERIODO, '000')),
          f.NOM_CENTRO_COSTO, b.CLA_UBICACION, f.CLA_CENTRO_COSTO, c.CLA_DEPTO
   From   dbo.RH_DET_REC_HISTO a
   Join   #tmpUbicacion        b
   On     b.CLA_EMPRESA      = a.CLA_EMPRESA
   And    b.CLA_UBICACION    = a.CLA_UBICACION_BASE
   Join   #tempDepto           c
   On     c.CLA_EMPRESA      = a.CLA_EMPRESA
   And    c.CLA_DEPTO        = a.CLA_DEPTO
   Join   #tmpNominas          d
   On     d.CLA_EMPRESA      = a.CLA_EMPRESA
   And    d.CLA_PERIODO      = a.CLA_PERIODO
   And    d.NUM_NOMINA       = a.NUM_NOMINA
   Join   #tmpPerded           e
   On     e.CLA_EMPRESA      = a.CLA_EMPRESA
   And    e.CLA_PERDED       = a.CLA_PERDED
   Join   #tmpCentroCosto      f
   On     f.CLA_EMPRESA      = a.CLA_EMPRESA
   And    f.CLA_CENTRO_COSTO = a.CLA_CENTRO_COSTO
   Join   #tempPeriodo         g
   On     g.CLA_EMPRESA      = a.CLA_EMPRESA
   And    g.CLA_PERIODO      = a.CLA_PERIODO
   Join   #tempTipoNom         h
   On     h.TIPO_NOMINA      = d.TIPO_NOMINA
   Where  a.cla_razon_social = @PnCla_RazonSocial
   And    a.CLA_EMPRESA      = @w_cla_empresa
   Group  By a.CLA_EMPRESA,      a.CLA_PERIODO,   a.NUM_NOMINA,  b.NOM_UBICACION,
          c.NOM_DEPTO,           d.NOM_PERIODO,   d.ANIO_MES,    d.INICIO_PER,
          d.FIN_PER,             e.CLA_PERDED,    e.NOM_PERDED,  e.TIPO_PERDED,
          Concat(Substring(h.NOM_TIPO_NOMINA, 1, 3), '-', Format(a.CLA_PERIODO, '000')),
          f.NOM_CENTRO_COSTO, b.CLA_UBICACION, f.CLA_CENTRO_COSTO, c.CLA_DEPTO
   Order  By b.CLA_UBICACION, f.CLA_CENTRO_COSTO, c.CLA_DEPTO;
   Set @w_registros = @@Rowcount;


   Declare
      C_tipoNom  Cursor For
      Select  Distinct NOM_TIPO_NOMINA
      From    #tmpImporteNominas;
   Begin
      Open  C_tipoNom
      While @@Fetch_status < 1
      Begin
         Fetch C_tipoNom Into @w_nomina
         If @@Fetch_status != 0
            Begin
               Break
            End

        If @w_secuencia = 0
           Begin
              Select @w_nominas   = Concat('NOMINA: ', @w_nomina),
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

   Insert Into  #tmpResultado
  (NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO,        PERDED_1,
   NOMDED_1,      IMPORTE1,         SALDO,            SALDO_EXENTO,
   SALDO_GRAVADO, CLA_CENTRO_COSTO, CLA_UBICACION,    CLA_DEPTO,
   CLA_PERDED)
   Select NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, Cast(CLA_PERDED As Varchar),
          NOM_PERDED,
          Format(Sum(IMPORTE),        '##,###,###,###.##'),
          Format(Sum(SALDO),           '##,###,###,###.##'),
          Format(Sum(SALDO_EXENTO),    '##,###,###,###.##'),
          Format(Sum(SALDO_GRAVADO),   '##,###,###,###.##'),
          CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO,
          CLA_PERDED
   From   #tmpImporteNominas
   Where  TIPO_PERDED = 1
   Group  By NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED,
             NOM_PERDED,    CLA_CENTRO_COSTO, CLA_UBICACION,    CLA_DEPTO
   Order By NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED;

   Set @w_secuencia = 0;

   Declare
      C_Deduduciones Cursor  For
         Select NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED,
                NOM_PERDED,
                Format(Sum(IMPORTE),        '##,###,###,###.##'),
                CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO
         From   #tmpImporteNominas
         Where  TIPO_PERDED = 2
         Group  By NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED,
                   NOM_PERDED,    CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO
         Order  By NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED;
   Begin
      Open  C_Deduduciones
      While @@Fetch_status < 1
      Begin
         Fetch C_Deduduciones Into
               @w_nom_ubicacion, @w_nom_centro_costo, @w_nom_depto, @w_cla_perded,
               @w_nom_perded,    @w_chimporte,        @w_cla_centro_costo,
               @w_cla_ubicacion, @w_cla_depto;
         If @@Fetch_status != 0
            Begin
               Break
            End

         Select  @w_secuencia = Min(secuencia)
         From    #tmpResultado
         Where   nom_ubicacion         = @w_nom_ubicacion
         And     nom_centro_costo      = @w_nom_centro_costo
         And     nom_depto             = @w_nom_depto
         And     PERDED_2              = Char(32);

         Update #tmpResultado
         Set    PERDED_2 = @w_cla_perded,
                NOMDED_2 = @w_nom_perded,
                IMPORTE2 = @w_chimporte
         Where  Secuencia = @w_secuencia;
         If @@Rowcount = 0
            Begin
               Insert Into  #tmpResultado
              (NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO,        PERDED_2,
               NOMDED_2,      IMPORTE2,         CLA_CENTRO_COSTO, CLA_UBICACION,
               CLA_DEPTO,     CLA_PERDED)
               Select @w_nom_ubicacion, @w_nom_centro_costo, @w_nom_depto, @w_cla_perded,
                      @w_nom_perded,    @w_chimporte,        @w_cla_centro_costo,
                      @w_cla_ubicacion, @w_cla_depto,        @w_cla_perded;
               Set @w_reg = @w_reg + @@Rowcount
            End

      End
      Close      C_Deduduciones
      Deallocate C_Deduduciones
   End

   Set @w_reg = 0;

   Declare
      C_Provisiones Cursor  For
         Select NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED,
                NOM_PERDED,
                Format(Sum(IMPORTE),        '##,###,###,###.##'),
                CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO
         From   #tmpImporteNominas
         Where  TIPO_PERDED = 3
         Group  By NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO,     CLA_PERDED,
                   NOM_PERDED,    CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO
         Order  By NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED;
   Begin
      Open  C_Provisiones
      While @@Fetch_status < 1
      Begin
         Fetch C_Provisiones Into
               @w_nom_ubicacion, @w_nom_centro_costo, @w_nom_depto,        @w_cla_perded,
               @w_nom_perded,    @w_chimporte,        @w_cla_centro_costo, @w_cla_ubicacion,
               @w_cla_depto;
         If @@Fetch_status != 0
            Begin
               Break
            End

         Select  @w_secuencia = Min(secuencia)
         From    #tmpResultado
         Where   nom_ubicacion         = @w_nom_ubicacion
         And     nom_centro_costo      = @w_nom_centro_costo
         And     nom_depto             = @w_nom_depto
         And     PERDED_3              = Char(32);

         Update #tmpResultado
         Set    PERDED_3 = @w_cla_perded,
                NOMDED_3 = @w_nom_perded,
                IMPORTE3 = @w_chimporte
         Where  Secuencia = @w_secuencia;
         If @@Rowcount = 0
            Begin
               Insert Into  #tmpResultado
              (NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO,        PERDED_3,
               NOMDED_3,      IMPORTE3,         CLA_CENTRO_COSTO, CLA_UBICACION,
               CLA_DEPTO,     cla_perded)
               Select @w_nom_ubicacion, @w_nom_centro_costo, @w_nom_depto,        @w_cla_perded,
                      @w_nom_perded,    @w_chimporte,        @w_cla_centro_costo, @w_cla_ubicacion,
                      @w_cla_depto,     @w_cla_perded;
               Set @w_reg = @w_reg + @@Rowcount
            End

      End
      Close      C_Provisiones
      Deallocate C_Provisiones
   End

   Select @w_fechaProcIni = Min(INICIO_PER),
          @w_fechaProcFin = Max(FIN_PER)
   From   #tmpImporteNominas;

   Select @w_secFin = Max(secuencia)
   From   #tmpResultado

--
-- Subtotal por Departamento.
--

   Insert Into #tmpResultado
  (NOM_UBICACION, NOM_CENTRO_COSTO,  NOM_DEPTO, CLA_CENTRO_COSTO,
   NOMDED_1,      IMPORTE1,          SALDO,
   SALDO_EXENTO,  SALDO_GRAVADO,     IMPORTE2,
   IMPORTE3,      CLA_UBICACION,     CLA_DEPTO)
   Select NOM_UBICACION, NOM_CENTRO_COSTO,  NOM_DEPTO, CLA_CENTRO_COSTO,
          'TOTAL DEPARTAMENTO ' + NOM_DEPTO NOMDED_1,
          Format(Sum(Case When IMPORTE1 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE1, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_EXENTO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_EXENTO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_GRAVADO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_GRAVADO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE2 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE2, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE3 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE3, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          CLA_UBICACION, CLA_DEPTO
   From   #tmpResultado
   Group  By NOM_UBICACION, NOM_CENTRO_COSTO, NOM_DEPTO,
          CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO
   Order  BY CLA_UBICACION, CLA_CENTRO_COSTO, CLA_DEPTO;

--
-- Subtotal por Centro de Costo.
--

   Insert Into #tmpResultado
  (NOM_UBICACION, NOM_CENTRO_COSTO, CLA_UBICACION,
   NOMDED_1,      IMPORTE1,          SALDO,
   SALDO_EXENTO,  SALDO_GRAVADO,     IMPORTE2,
   IMPORTE3,      CLA_CENTRO_COSTO)
   Select NOM_UBICACION, NOM_CENTRO_COSTO,  CLA_UBICACION,
          'TOTAL CENTRO DE COSTO ' + NOM_CENTRO_COSTO NOMDED_1,
          Format(Sum(Case When IMPORTE1 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE1, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_EXENTO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_EXENTO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_GRAVADO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_GRAVADO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE2 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE2, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE3 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE3, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
           CLA_CENTRO_COSTO
   From   #tmpResultado
   Where  Secuencia <= @w_secFin
   Group  By NOM_UBICACION, NOM_CENTRO_COSTO, CLA_UBICACION, CLA_CENTRO_COSTO
   Order  BY CLA_UBICACION, CLA_CENTRO_COSTO;

--
-- Subtotal por Ubicación.
--

   Insert Into #tmpResultado
  (NOM_UBICACION, NOMDED_1,          IMPORTE1,          SALDO,
   SALDO_EXENTO,  SALDO_GRAVADO,     IMPORTE2,
   IMPORTE3,      CLA_UBICACION)
   Select NOM_UBICACION,
         'TOTAL UBICACION ' + NOM_UBICACION NOMDED_1,
          Format(Sum(Case When IMPORTE1 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE1, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_EXENTO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_EXENTO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_GRAVADO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_GRAVADO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE2 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE2, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE3 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE3, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          CLA_UBICACION
   From   #tmpResultado
   Where  Secuencia <= @w_secFin
   Group  By NOM_UBICACION, CLA_UBICACION
   Order  BY CLA_UBICACION;

--
-- Total General
--

   Insert Into #tmpResultado
  (NOMDED_1,          IMPORTE1,          SALDO,
   SALDO_EXENTO,      SALDO_GRAVADO,     IMPORTE2,
   IMPORTE3)
   Select 'TOTAL GENERAL ' NOMDED_1,
          Format(Sum(Case When IMPORTE1 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE1, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_EXENTO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_EXENTO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When SALDO_GRAVADO = Char(32)
                          Then 0
                          Else Cast(Replace(SALDO_GRAVADO, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE2 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE2, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##'),
          Format(Sum(Case When IMPORTE3 = Char(32)
                          Then 0
                          Else Cast(Replace(IMPORTE3, ',', '') As Decimal(18, 2))
                     End), '##,###,###,###.##')
   From   #tmpResultado
   Where  Secuencia <= @w_secFin;

--
-- Presentación del Reporte.
--

   Select @w_nom_razon_social RAZON_SOCIAL, @w_tituloRep tituloRep,
          Concat(@w_nominas, ' DEL ', @w_fechaProcIni, ' AL ', @w_fechaProcFin) titulo1,
          @w_fechaProc FechaProceso, @w_horaProceso horaProceso,
          NOM_UBICACION    UBICACION,
          NOM_CENTRO_COSTO CENTRO_COSTO,
          NOM_DEPTO        Departamento,
          PERDED_1         CONCEPTO_PERCEPCION,
          NOMDED_1         PERCEPCION,
          IMPORTE1         IMPORTE_PERCEPCION,
          SALDO            SALDO,
          SALDO_EXENTO     EXENTO,
          SALDO_GRAVADO    GRAVADO,
          PERDED_2         CONCEPTO_DEDUCCION,
          NOMDED_2         DEDUCCION,
          IMPORTE2         IMPORTE_DEDUCCION,
          PERDED_3         CONCEPTO_PROVISION,
          NOMDED_3         PROVISION,
          IMPORTE3         IMPORTE_PROVISION
   From   #tmpResultado
   Order  by CLA_UBICACION, CLA_CENTRO_COSTO,  CLA_DEPTO, CLA_PERDED;

   Set Xact_Abort Off
   Return

End
Go
