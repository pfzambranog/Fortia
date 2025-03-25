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
   -- @PbImprimeProv             Bit            = 1,
   -- @PnError                   Integer        = 0,
   -- @PsMensaje                 Varchar( 250)  = ' ';
-- Begin
   -- Execute dbo.spc_AcumuladosConceptos @PsRazon_Social    = @PsRazon_Social,
                                       -- @PsCla_Empresa     = @PsCla_Empresa,
                                       -- @PnAnio            = @PnAnio,
                                       -- @PnMesIni          = @PnMesIni,
                                       -- @PnMesFin          = @PnMesFin,
                                       -- @PsCla_Ubicacion   = @PsCla_Ubicacion,
                                       -- @PsCla_CentroCosto = @PsCla_CentroCosto,
                                       -- @PsCla_Area        = @PsCla_Area,
                                       -- @PsCla_Depto       = @PsCla_Depto,
                                       -- @PsCla_RegImss     = @PsCla_RegImss,
                                       -- @PsCla_PerDed      = @PsCla_PerDed,
                                       -- @PsCla_Periodo     = @PsCla_Periodo,
                                       -- @PsNominas         = @PsNominas,
                                       -- @PsCla_Trab        = @PsCla_Trab,
                                       -- @PbImprimeProv     = @PbImprimeProv,
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
   @PbImprimeProv             Bit            = 1,
   @PnError                   Integer        = 0    Output,
   @PsMensaje                 Varchar( 250)  = Null Output)
As

Declare
   @w_desc_error              Varchar(250),
   @w_tituloRep               Varchar(350),
   @w_fechaProc               Varchar( 10),
   @w_fechaProcIni            Varchar( 10),
   @w_fechaProcFin            Varchar( 10),
   @w_nominas                 Varchar(Max),
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
   @w_chimporte               Varchar( 20),
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
   @w_horaProceso             Char(20),
   @w_inicio                  Bit,
   @w_importe                 Decimal(18, 2),
   @w_importe_Trab            Decimal(18, 2),
   @w_importe_Depto           Decimal(18, 2),
   @w_importe_Ceco            Decimal(18, 2),
   @w_importe_Ubic            Decimal(18, 2),
   @w_importe_Empr            Decimal(18, 2),
   @w_importe_RZ              Decimal(18, 2),
   @w_importe_Total           Decimal(18, 2),
   @w_saldo                   Decimal(18, 2),
   @w_saldo_trab              Decimal(18, 2),
   @w_saldo_Depto             Decimal(18, 2),
   @w_saldo_Ceco              Decimal(18, 2),
   @w_saldo_Ubic              Decimal(18, 2),
   @w_saldo_Empr              Decimal(18, 2),
   @w_saldo_RZ                Decimal(18, 2),
   @w_saldo_Total             Decimal(18, 2),
   @w_saldo_exento            Decimal(18, 2),
   @w_saldo_exento_trab       Decimal(18, 2),
   @w_saldo_exento_Depto      Decimal(18, 2),
   @w_saldo_exento_Ceco       Decimal(18, 2),
   @w_saldo_exento_Ubic       Decimal(18, 2),
   @w_saldo_exento_Empr       Decimal(18, 2),
   @w_saldo_exento_RZ         Decimal(18, 2),
   @w_saldo_exento_Total      Decimal(18, 2),
   @w_saldo_gravado           Decimal(18, 2),
   @w_saldo_gravado_trab      Decimal(18, 2),
   @w_saldo_gravado_Depto     Decimal(18, 2),
   @w_saldo_gravado_Ceco      Decimal(18, 2),
   @w_saldo_gravado_Ubic      Decimal(18, 2),
   @w_saldo_gravado_Empr      Decimal(18, 2),
   @w_saldo_gravado_RZ        Decimal(18, 2),
   @w_saldo_gravado_Total     Decimal(18, 2),
   @w_sec_min                 Integer,
   @w_sec_max                 Integer,
   @w_imp                     Decimal(18, 2),
   @w_fechaHoy                Date,
--
   @w_fechaNac                Varchar( 10),
   @w_edad                    Varchar(  5);

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off
   Set Ansi_Warnings On

   Select @PnError       = 0,
          @w_reg         = 0,
          @w_registros   = 0,
          @w_secuencia   = 0,
          @w_inicio      = 1,
          @w_nominas     = '',
          @w_fechaHoy    = Getdate(),
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
   NOM_PERDED        Varchar( 80) Not  Null,
   TIPO_PERDED       Integer      Not Null,
   MOSTRAR_SALDO     INTEGER      Not Null Default 0,
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

--
-- Tabla Temporal de Trabajadores.
--

   Create Table #TmpTrabajador
  (CLA_RAZON_SOCIAL Integer      Not Null,
   CLA_EMPRESA      Integer      Not Null,
   CLA_TRAB         Integer      Not Null,
   NOM_TRAB         Varchar(400)     Null,
   FECHA_NAC        Varchar( 10)     Null Default Char(32),
   EDAD             Varchar(  4)     Null Default Char(32),          
   Constraint TmpTrabajadorPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB));

   Create Table #tmpImporteNominas
  (secuencia         Integer        Not Null Identity (1, 1) Primary Key,
   CLA_RAZON_SOCIAL  Integer        Not Null,
   NOM_RAZON_SOCIAL  Varchar(300)   Not Null,
   CLA_EMPRESA       Integer        Not Null,
   NOM_EMPRESA       Varchar(300)   Not Null,
   CLA_PERIODO       Integer        Not Null,
   NUM_NOMINA        Integer        Not Null,
   CLA_UBICACION     Integer        Not Null,
   NOM_UBICACION     Varchar(150)       Null,
   CLA_CENTRO_COSTO  Integer        Not Null,
   NOM_CENTRO_COSTO  Varchar(150)   Not Null,
   CLA_DEPTO         Integer        Not Null,
   NOM_DEPTO         Varchar(150)   Not Null,
   CLA_TRAB          Integer            Null,
   NOM_TRAB          Varchar(300)       Null,
   FECHA_NAC        Varchar( 10)        Null Default Char(32),
   EDAD             Varchar(  4)        Null Default Char(32),  
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
   Index tmpNominasTrabIdx01 (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_PERIODO, ANIO_MES,
   NUM_NOMINA, CLA_PERDED));

--
-- Tabla de Salida.
--

   Create Table #tmpResultado
  (secuencia           Integer        Not Null Identity (1, 1) Primary Key,
   CLA_RAZON_SOCIAL    Integer        Not Null,
   NOM_RAZON_SOCIAL    Varchar(300)   Not Null Default Char(32),
   CLA_EMPRESA         Integer            Null,
   NOM_EMPRESA         Varchar(350)       Null Default Char(32),
   CLA_TRAB            Integer            Null,
   NOM_TRAB            Varchar(300)       Null Default Char(32),
   FECHA_NAC           Varchar( 10)     Null Default Char(32),
   EDAD                Varchar(  4)     Null Default Char(32),  
   CLA_UBICACION       Integer            Null,
   NOM_UBICACION       Varchar(150)       Null Default Char(32),
   CLA_CENTRO_COSTO    Integer            Null,
   NOM_CENTRO_COSTO    Varchar(100)       Null Default Char(32),
   CLA_DEPTO           Integer            Null,
   NOM_DEPTO           Varchar(150)       Null Default Char(32),
   PERDED_1            Varchar( 15)       Null Default Char(32),
   NOMDED_1            Varchar( 80)       Null Default Char(32),
   IMPORTE1            Varchar( 20)       Null Default Char(32),
   SALDO               Varchar( 20)       Null Default Char(32),
   SALDO_EXENTO        Varchar( 20)       Null Default Char(32),
   SALDO_GRAVADO       Varchar( 20)       Null Default Char(32),
   PERDED_2            Varchar( 20)       Null Default Char(32),
   NOMDED_2            Varchar( 80)       Null Default Char(32),
   IMPORTE2            Varchar( 20)       Null Default Char(32),
   SALDO2              Varchar( 20)       Null Default Char(32),
   PERDED_3            Varchar( 20)       Null Default Char(32),
   NOMDED_3            Varchar( 80)       Null Default Char(32),
   IMPORTE3            Varchar( 20)       Null Default Char(32),
   SALDO3              Varchar( 20)       Null Default Char(32),
   tipo                Char(2)        Not Null Default 'L0',
   orden               Integer        Not Null Default 1,
   Index tmpResultadoIdx01 (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION,
                            CLA_CENTRO_COSTO, CLA_DEPTO,   CLA_TRAB,
                            Tipo),
   Index tmpResultadoIdx02 (Orden));

--
-- Filtro para Consulta de Razon Social.
--

   If Isnull(@PsRazon_Social, '') = ''
      Begin
         Insert Into #TempRazon_Social
        (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL, CLA_EMPRESA)
         Select CLA_RAZON_SOCIAL, Concat(nom_razon_social, ' - ', rfc_emp), CLA_EMPRESA
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
-- Consulta de Ubicación.
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
-- Consulta de los centros de Costo.
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
-- Consulta de Areas
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
-- Consulta de los Tipos de Nomina
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
-- Consulta de los Períodos de Nomina
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
-- Consulta de conceptos de nómina.
--

   If Isnull(@PsCla_PerDed, '') = ''
      Begin
         Insert Into #tmpPerded
        (CLA_EMPRESA, CLA_PERDED, NOM_PERDED, TIPO_PERDED, MOSTRAR_SALDO)
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                Case When TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(a.MOSTRAR_SALDO, 0)
         From   dbo.RH_PERDED  a
         Join   #TmpEmpresa    b
         On     b.CLA_EMPRESA     = a.CLA_EMPRESA
         Where  a.NO_AFECTAR_NETO = 0
         And    a.NO_IMPRIMIR     = 0
         And    a.ES_PROVISION    = 0
         Union
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                3, Isnull(a.MOSTRAR_SALDO, 0)
         From   dbo.RH_PERDED a
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
         MOSTRAR_SALDO)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                Case When b.TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(b.MOSTRAR_SALDO, 0)
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
                3, Isnull(b.MOSTRAR_SALDO, 0)
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

--
-- Consulta a las nóminas.
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
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, NOM_TRAB,
         FECHA_NAC,        EDAD)
         Select Distinct a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_TRAB,
                Concat(Trim(a.NOM_TRAB), ' ', Trim(a.AP_PATERNO), ' ', Trim(a.AP_MATERNO)),
                Convert(Char(10), a.FECHA_NAC, 103), dbo.fnCalcEdad(a.FECHA_NAC, @w_fechaHoy)
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
         Order  By 1, 2, 3;
      End
   Else
      Begin
         Insert Into #TmpTrabajador
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, NOM_TRAB,
         FECHA_NAC,        EDAD)
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA, b.CLA_TRAB,
                Concat(Trim(b.NOM_TRAB), ' ', Trim(b.AP_PATERNO), ' ', Trim(b.AP_MATERNO)),
                Convert(Char(10), a.FECHA_NAC, 103), dbo.fnCalcEdad(a.FECHA_NAC, @w_fechaHoy)
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
-- Inicio de Consulta para el reporte.
--

   Insert Into #tmpImporteNominas
  (CLA_EMPRESA,     CLA_PERIODO,        NUM_NOMINA,         NOM_UBICACION,
   NOM_DEPTO,       NOM_PERIODO,        ANIO_MES,           INICIO_PER,
   FIN_PER,         CLA_PERDED,         NOM_PERDED,         TIPO_PERDED,
   IMPORTE,         SALDO,              SALDO_GRAVADO,      SALDO_EXENTO,
   NOM_TIPO_NOMINA, NOM_CENTRO_COSTO,   CLA_UBICACION,      CLA_CENTRO_COSTO,
   CLA_DEPTO,       CLA_RAZON_SOCIAL,   NOM_RAZON_SOCIAL,   CLA_TRAB,
   NOM_TRAB,        NOM_EMPRESA,        FECHA_NAC,          EDAD)
   Select a.CLA_EMPRESA,         a.CLA_PERIODO,   a.NUM_NOMINA,     b.NOM_UBICACION,
          c.NOM_DEPTO,           d.NOM_PERIODO,   d.ANIO_MES,       d.INICIO_PER,
          d.FIN_PER,             e.CLA_PERDED,    e.NOM_PERDED,     e.TIPO_PERDED,
          Sum(a.IMPORTE),        Sum(a.acum),     Sum(a.GRAV_IMSS), Sum(EXENTO),
          Concat(Substring(h.NOM_TIPO_NOMINA, 1, 3), '-', Format(a.CLA_PERIODO, '000')),
          f.NOM_CENTRO_COSTO,  b.CLA_UBICACION, f.CLA_CENTRO_COSTO, c.CLA_DEPTO,
          T1.CLA_RAZON_SOCIAL, T1.nom_razon_social, a.CLA_TRAB,     i.NOM_TRAB,
          T2.NOM_EMPRESA,      i.FECHA_NAC,         i.EDAD
   From   dbo.RH_DET_REC_HISTO a
   Join   #TempRazon_Social    T1
   On     T1.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    T1.CLA_EMPRESA      = a.cla_empresa
   Join   #TmpEmpresa         T2
   On     T2.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    T2.CLA_EMPRESA      = a.cla_empresa
   Join   #tmpUbicacion        b
   On     b.CLA_EMPRESA      = a.CLA_EMPRESA
   And    b.CLA_UBICACION    = a.CLA_UBICACION_BASE
   Join   #TmpDepto           c
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
   Join   #TmpPeriodo          g
   On     g.CLA_EMPRESA      = a.CLA_EMPRESA
   And    g.CLA_PERIODO      = a.CLA_PERIODO
   Join   #TmpTipoNom          h
   On     h.TIPO_NOMINA      = d.TIPO_NOMINA
   Join   #TmpTrabajador       i
   On     i.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
   And    i.CLA_EMPRESA      = a.CLA_EMPRESA
   And    i.CLA_TRAB         = a.CLA_TRAB
   Where  a.importe         != 0
   Group  By a.CLA_EMPRESA,      a.CLA_PERIODO,   a.NUM_NOMINA,  b.NOM_UBICACION,
          c.NOM_DEPTO,           d.NOM_PERIODO,   d.ANIO_MES,    d.INICIO_PER,
          d.FIN_PER,             e.CLA_PERDED,    e.NOM_PERDED,  e.TIPO_PERDED,
          Concat(Substring(h.NOM_TIPO_NOMINA, 1, 3), '-', Format(a.CLA_PERIODO, '000')),
          f.NOM_CENTRO_COSTO, b.CLA_UBICACION, f.CLA_CENTRO_COSTO, c.CLA_DEPTO,
          T1.CLA_RAZON_SOCIAL, T1.nom_razon_social,  a.CLA_TRAB,     i.NOM_TRAB,
          T2.NOM_EMPRESA,      i.FECHA_NAC,          i.EDAD
   Order  By T1.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, b.CLA_UBICACION, f.CLA_CENTRO_COSTO,
          c.CLA_DEPTO, a.CLA_TRAB;
   Set @w_registros = @@Rowcount;

   Update #tmpImporteNominas
   Set    SALDO = 0
   From   #tmpImporteNominas a
   Where  SALDO != 0
   And    Not Exists ( Select Top 1 1
                       From   #tmpPerded
                       Where  CLA_EMPRESA   = a.CLA_EMPRESA
                       And    CLA_PERDED    = a.CLA_PERDED
                       And    MOSTRAR_SALDO = 1)

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

--
-- Carga de Percepciones
--

   Declare
      C_Percepciones Cursor  For
         Select CLA_RAZON_SOCIAL,  NOM_RAZON_SOCIAL,
                CLA_EMPRESA,       NOM_EMPRESA,
                CLA_UBICACION,     NOM_UBICACION,
                CLA_CENTRO_COSTO,  NOM_CENTRO_COSTO,
                CLA_DEPTO,         NOM_DEPTO,
                CLA_TRAB,          NOM_TRAB,
                CLA_PERDED,        NOM_PERDED,
                Sum(IMPORTE),      Sum(Saldo),
                Sum(SALDO_EXENTO), Sum(Saldo_gravado),
                FECHA_NAC,         EDAD
         From   #tmpImporteNominas
         Where  TIPO_PERDED        = 1
         And    Isnull(IMPORTE,0) != 0
         Group  By CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
                   CLA_EMPRESA,      NOM_EMPRESA,
                   NOM_UBICACION,    NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED,
                   NOM_PERDED,       CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO,
                   CLA_TRAB,         NOM_TRAB,         FECHA_NAC,
                   EDAD
         Order  By CLA_RAZON_SOCIAL, CLA_EMPRESA,
                   CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO, CLA_TRAB, CLA_PERDED;
   Begin
      Open  C_Percepciones
      While @@Fetch_status < 1
      Begin
         Fetch C_Percepciones Into
               @w_cla_razon_social, @w_nom_razon_social,
               @w_cla_empresa,      @w_nom_empresa,
               @w_cla_ubicacion,    @w_nom_ubicacion,
               @w_cla_centro_costo, @w_nom_centro_costo,
               @w_cla_depto,        @w_nom_depto,
               @w_cla_trab,         @w_nom_trab,
               @w_cla_perded,       @w_nom_perded,
               @w_importe,          @w_saldo,
               @w_saldo_exento,     @w_saldo_gravado,
               @w_fechaNac,         @w_edad;
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
                      @w_importe_Trab            = 0,
                      @w_importe_Depto           = 0,
                      @w_importe_Ceco            = 0,
                      @w_importe_Ubic            = 0,
                      @w_importe_Empr            = 0,
                      @w_importe_RZ              = 0,
                      @w_importe_Total           = 0,
                      @w_saldo_trab             = 0,
                      @w_saldo_Depto             = 0,
                      @w_saldo_Ceco              = 0,
                      @w_saldo_Ubic              = 0,
                      @w_saldo_Empr              = 0,
                      @w_saldo_RZ                = 0,
                      @w_saldo_Total             = 0,
                      @w_saldo_exento_trab       = 0,
                      @w_saldo_exento_Depto      = 0,
                      @w_saldo_exento_Ceco       = 0,
                      @w_saldo_exento_Ubic       = 0,
                      @w_saldo_exento_Empr       = 0,
                      @w_saldo_exento_RZ         = 0,
                      @w_saldo_exento_Total      = 0,
                      @w_saldo_gravado_trab      = 0,
                      @w_saldo_gravado_Depto     = 0,
                      @w_saldo_gravado_Ceco      = 0,
                      @w_saldo_gravado_Ubic      = 0,
                      @w_saldo_gravado_Empr      = 0,
                      @w_saldo_gravado_RZ        = 0,
                      @w_saldo_gravado_Total     = 0;

            End

--
-- Total por Trabajador.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion    Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo Or
            @w_cla_depto_ante          != @w_cla_depto        Or
            @w_cla_trab_ante           != @w_cla_trab
            Begin
               Insert Into  #tmpResultado
              (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
               CLA_EMPRESA,      NOM_EMPRESA,
               CLA_UBICACION,    NOM_UBICACION,
               CLA_CENTRO_COSTO, NOM_CENTRO_COSTO,
               CLA_DEPTO,        NOM_DEPTO,
               CLA_TRAb,         NOM_TRAB,
               IMPORTE1,         SALDO,
               SALDO_EXENTO,     SALDO_GRAVADO,
               tipo)
               Select @w_cla_razon_social_ante,      Char(32),
                      @w_cla_empresa_ante,           Char(32),
                      @w_cla_ubicacion_ante,         Char(32),
                      @w_cla_centro_costo_ante,      Char(32),
                      @w_cla_depto_ante,             Char(32),
                      @w_cla_trab_ante,              Concat('Total Trabajador.: ', @w_cla_trab_ante),
                      Format(@w_importe_trab,       '##,###,###,##0.00'),
                      Format(@w_saldo_trab,         '##,###,###,##0.00'),
                      Format(@w_saldo_exento_trab,  '##,###,###,##0.00'),
                      Format(@w_saldo_gravado_trab, '##,###,###,##0.00'),
                      'L1';

               Select @w_importe_trab       = 0,
                      @w_saldo_trab         = 0,
                      @w_saldo_exento_trab  = 0,
                      @w_saldo_gravado_trab = 0;

            End
--
-- Total por Departamento.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion    Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo Or
            @w_cla_depto_ante          != @w_cla_depto
            Begin
               Insert Into  #tmpResultado
              (CLA_RAZON_SOCIAL, NOM_DEPTO,
               CLA_EMPRESA,
               CLA_UBICACION,
               CLA_CENTRO_COSTO,
               CLA_DEPTO,        CLA_TRAB,
               IMPORTE1,         SALDO,
               SALDO_EXENTO,     SALDO_GRAVADO,
               tipo)
               Select @w_cla_razon_social_ante,      'Total Departamento.: ' + @w_nom_depto_ante,
                      @w_cla_empresa_ante,
                      @w_cla_ubicacion_ante,
                      @w_cla_centro_costo_ante,
                      @w_cla_depto_ante,             @w_cla_trab_ante,
                      Format(@w_importe_Depto,       '##,###,###,##0.00'),
                      Format(@w_saldo_Depto,         '##,###,###,##0.00'),
                      Format(@w_saldo_exento_Depto,  '##,###,###,##0.00'),
                      Format(@w_saldo_gravado_Depto, '##,###,###,##0.00'),
                      'L2';

               Select @w_importe_Depto       = 0,
                      @w_saldo_Depto         = 0,
                      @w_saldo_exento_Depto  = 0,
                      @w_saldo_gravado_Depto = 0;

            End
--
-- Total por Centro de Costo.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo
            Begin
               Insert Into  #tmpResultado
              (CLA_RAZON_SOCIAL, NOM_CENTRO_COSTO,
               CLA_EMPRESA,
               CLA_UBICACION,
               CLA_CENTRO_COSTO, CLA_DEPTO,
               CLA_TRAB,
               IMPORTE1,         SALDO,
               SALDO_EXENTO,     SALDO_GRAVADO,
               tipo)
               Select @w_cla_razon_social_ante,     'Total Centro de Costo.: ' + @w_nom_centro_costo_ante,
                      @w_cla_empresa_ante,
                      @w_cla_ubicacion_ante,
                      @w_cla_centro_costo_ante,     @w_cla_Depto_ante,
                      @w_cla_trab_ante,
                      Format(@w_importe_Ceco,       '##,###,###,##0.00'),
                      Format(@w_saldo_Ceco,         '##,###,###,##0.00'),
                      Format(@w_saldo_exento_Ceco,  '##,###,###,##0.00'),
                      Format(@w_saldo_gravado_Ceco, '##,###,###,##0.00'),
                      'L3';

               Select @w_importe_Ceco          = 0,
                      @w_saldo_Ceco            = 0,
                      @w_saldo_exento_Ceco     = 0,
                      @w_saldo_gravado_Ceco    = 0;
            End;

--
-- Total por Ubicación.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion
            Begin
               Insert Into  #tmpResultado
              (CLA_RAZON_SOCIAL, NOM_UBICACION,
               CLA_EMPRESA,
               CLA_UBICACION,    CLA_CENTRO_COSTO,
               CLA_DEPTO,        CLA_TRAB,
               IMPORTE1,         SALDO,
               SALDO_EXENTO,     SALDO_GRAVADO,
               tipo)
               Select @w_cla_razon_social_ante,     'Total Ubicación.: ' + @w_nom_ubicacion_ante,
                      @w_cla_empresa_ante,
                      @w_cla_ubicacion_ante,        @w_cla_centro_costo_ante,
                      @w_cla_depto_ante,            @w_cla_trab_ante,
                      Format(@w_importe_Ubic,       '##,###,###,##0.00'),
                      Format(@w_saldo_Ubic,         '##,###,###,##0.00'),
                      Format(@w_saldo_exento_Ubic,  '##,###,###,##0.00'),
                      Format(@w_saldo_gravado_Ubic, '##,###,###,##0.00'),
                      'L4';

               Select @w_importe_Ubic          = 0,
                      @w_saldo_Ubic            = 0,
                      @w_saldo_exento_Ubic     = 0,
                      @w_saldo_gravado_Ubic    = 0;
            End;

--
-- Total por Empresa.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa
            Begin
               Insert Into  #tmpResultado
              (CLA_RAZON_SOCIAL, NOM_EMPRESA,
               CLA_EMPRESA,
               CLA_UBICACION,    CLA_CENTRO_COSTO,
               CLA_DEPTO,        CLA_TRAB,
               IMPORTE1,         SALDO,
               SALDO_EXENTO,     SALDO_GRAVADO,
               tipo)
               Select @w_cla_razon_social_ante,     ' Total Empresa ' + @w_nom_empresa_ante,
                      @w_cla_empresa_ante,
                      @w_cla_ubicacion_ante,        @w_cla_centro_costo_ante,
                      @w_cla_depto_ante,            @w_cla_trab_ante,
                      Format(@w_importe_Empr,       '##,###,###,##0.00'),
                      Format(@w_saldo_Empr,         '##,###,###,##0.00'),
                      Format(@w_saldo_exento_Empr,  '##,###,###,##0.00'),
                      Format(@w_saldo_gravado_Empr, '##,###,###,##0.00'),
                      'L5';

               Select @w_importe_Empr          = 0,
                      @w_saldo_Empr            = 0,
                      @w_saldo_exento_Empr     = 0,
                      @w_saldo_gravado_Empr    = 0;

            End;

--
-- Total por Razón Social.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social
            Begin
               Insert Into  #tmpResultado
              (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
               CLA_EMPRESA,      CLA_UBICACION,
               CLA_CENTRO_COSTO, CLA_DEPTO,
               CLA_TRAB,
               IMPORTE1,         SALDO,
               SALDO_EXENTO,     SALDO_GRAVADO,
               tipo)
               Select @w_cla_razon_social_ante,   ' Total Razón Social.: ' + @w_nom_razon_social_ante,
                      @w_cla_empresa_ante,        @w_cla_ubicacion_ante,
                      @w_cla_centro_costo_ante,   @w_cla_depto_ante,
                      @w_cla_trab_ante,
                      Format(@w_importe_RZ,       '##,###,###,##0.00'),
                      Format(@w_saldo_RZ,         '##,###,###,##0.00'),
                      Format(@w_saldo_exento_RZ,  '##,###,###,##0.00'),
                      Format(@w_saldo_gravado_RZ, '##,###,###,##0.00'),
                      'L6';

               Select @w_importe_RZ            = 0,
                      @w_saldo_RZ              = 0,
                      @w_saldo_RZ              = 0,
                      @w_saldo_gravado_RZ      = 0;

            End;

          Insert Into  #tmpResultado
         (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
          CLA_EMPRESA,      NOM_EMPRESA,
          CLA_UBICACION,    NOM_UBICACION,
          CLA_CENTRO_COSTO, NOM_CENTRO_COSTO,
          CLA_DEPTO,        NOM_DEPTO,
          CLA_TRAB,         NOM_TRAB,
          PERDED_1,         NOMDED_1,
          IMPORTE1,         SALDO,
          SALDO_EXENTO,     SALDO_GRAVADO,
          tipo,             fecha_nac,
          edad)
          Select @w_cla_razon_social,     @w_nom_razon_social,
                 @w_cla_empresa,          @w_nom_empresa,
                 @w_cla_ubicacion,        @w_nom_ubicacion,
                 @w_cla_centro_costo,     @w_nom_centro_costo,
                 @w_cla_depto,            @w_nom_depto,
                 @w_cla_trab,             @w_nom_trab,
                 @w_cla_perded,           @w_nom_perded,
                 Format(@w_importe,       '##,###,###,##0.00'),
                 Format(@w_saldo,         '##,###,###,##0.00'),
                 Format(@w_saldo_exento,  '##,###,###,##0.00'),
                 Format(@w_saldo_gravado, '##,###,###,##0.00'),
                 'L0',                    @w_fechaNac,
                 @w_edad;

          Select @w_importe_Trab            = @w_importe_trab        + @w_importe,
                 @w_importe_Depto           = @w_importe_Depto       + @w_importe,
                 @w_importe_Ceco            = @w_importe_Ceco        + @w_importe,
                 @w_importe_Ubic            = @w_importe_Ubic        + @w_importe,
                 @w_importe_Empr            = @w_importe_Empr        + @w_importe,
                 @w_importe_RZ              = @w_importe_RZ          + @w_importe,
                 @w_importe_Total           = @w_importe_Total       + @w_importe,
                 @w_saldo_trab              = @w_saldo_trab          + @w_saldo,
                 @w_saldo_Depto             = @w_saldo_Depto         + @w_saldo,
                 @w_saldo_Ceco              = @w_saldo_Ceco          + @w_saldo,
                 @w_saldo_Ubic              = @w_saldo_Ubic          + @w_saldo,
                 @w_saldo_Empr              = @w_saldo_Empr          + @w_saldo,
                 @w_saldo_RZ                = @w_saldo_RZ            + @w_saldo,
                 @w_saldo_Total             = @w_saldo_Total         + @w_saldo,
                 @w_saldo_exento_trab       = @w_saldo_exento_trab   + @w_saldo_exento,
                 @w_saldo_exento_Depto      = @w_saldo_exento_Depto  + @w_saldo_exento,
                 @w_saldo_exento_Ceco       = @w_saldo_exento_Ceco   + @w_saldo_exento,
                 @w_saldo_exento_Ubic       = @w_saldo_exento_Ubic   + @w_saldo_exento,
                 @w_saldo_exento_Empr       = @w_saldo_exento_Empr   + @w_saldo_exento,
                 @w_saldo_exento_RZ         = @w_saldo_exento_RZ     + @w_saldo_exento,
                 @w_saldo_exento_Total      = @w_saldo_exento_Total  + @w_saldo_exento,
                 @w_saldo_gravado_trab      = @w_saldo_gravado_trab  + @w_saldo_gravado,
                 @w_saldo_gravado_Depto     = @w_saldo_gravado_Depto + @w_saldo_gravado,
                 @w_saldo_gravado_Ceco      = @w_saldo_gravado_Ceco  + @w_saldo_gravado,
                 @w_saldo_gravado_Ubic      = @w_saldo_gravado_Ubic  + @w_saldo_gravado,
                 @w_saldo_gravado_Empr      = @w_saldo_gravado_Empr  + @w_saldo_gravado,
                 @w_saldo_gravado_RZ        = @w_saldo_gravado_RZ    + @w_saldo_gravado,
                 @w_saldo_gravado_Total     = @w_saldo_gravado_Total + @w_saldo_gravado,
                 @w_cla_razon_social_ante   = @w_cla_razon_social,
                 @w_nom_razon_social_ante   = @w_nom_razon_social,
                 @w_cla_empresa_ante        = @w_cla_empresa,
                 @w_cla_ubicacion_ante      = @w_cla_ubicacion,
                 @w_nom_ubicacion_ante      = @w_nom_ubicacion,
                 @w_cla_centro_costo_ante   = @w_cla_centro_costo,
                 @w_nom_centro_costo_ante   = @w_nom_centro_costo,
                 @w_cla_depto_ante          = @w_cla_depto,
                 @w_nom_depto_ante          = @w_nom_depto,
                 @w_cla_trab_ante           = @w_cla_trab,
                 @w_nom_trab_ante           = @w_nom_trab;


      End
      Close      C_Percepciones
      Deallocate C_Percepciones
   End

--
-- Total por Trabajador.
--

   Insert Into  #tmpResultado
  (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
   CLA_EMPRESA,      NOM_EMPRESA,
   CLA_UBICACION,    NOM_UBICACION,
   CLA_CENTRO_COSTO, NOM_CENTRO_COSTO,
   CLA_TRAB,         NOM_TRAB,
   CLA_DEPTO,        NOM_DEPTO,
   IMPORTE1,         SALDO,
   SALDO_EXENTO,     SALDO_GRAVADO,
   tipo)
   Select @w_cla_razon_social,      Char(32),
          @w_cla_empresa,           Char(32),
          @w_cla_ubicacion,         Char(32),
          @w_cla_centro_costo,      Char(32),
          @w_cla_trab,              Concat('Total Trabajador.: ', @w_cla_trab),
          @w_cla_depto,             Char(32),
          Format(@w_importe_trab,       '##,###,###,##0.00'),
          Format(@w_saldo_trab,         '##,###,###,##0.00'),
          Format(@w_saldo_exento_trab,  '##,###,###,##0.00'),
          Format(@w_saldo_gravado_trab, '##,###,###,##0.00'),
          'L1';

--
-- Total por Departamento.
--

   Insert Into  #tmpResultado
  (CLA_RAZON_SOCIAL, NOM_DEPTO,
   CLA_EMPRESA,      CLA_UBICACION,
   CLA_CENTRO_COSTO,
   CLA_DEPTO,        CLA_TRAB,
   IMPORTE1,         SALDO,
   SALDO_EXENTO,     SALDO_GRAVADO,
   tipo)
   Select @w_cla_razon_social,           'Total Departamento.: ' + @w_nom_depto,
          @w_cla_empresa,                @w_cla_ubicacion,
          @w_cla_centro_costo,
          @w_cla_depto,                  @w_cla_trab,
          Format(@w_importe_Depto,       '##,###,###,##0.00'),
          Format(@w_saldo_Depto,         '##,###,###,##0.00'),
          Format(@w_saldo_exento_Depto,  '##,###,###,##0.00'),
          Format(@w_saldo_gravado_Depto, '##,###,###,##0.00'),
          'L2';

--
-- Total por Centro de Costo.
--

   Insert Into  #tmpResultado
  (CLA_RAZON_SOCIAL, NOM_CENTRO_COSTO,
   CLA_EMPRESA,      CLA_UBICACION,
   CLA_CENTRO_COSTO, CLA_DEPTO,
   CLA_TRAB,
   IMPORTE1,         SALDO,
   SALDO_EXENTO,     SALDO_GRAVADO,
   tipo)
   Select @w_cla_razon_social,          'Total Centro de Costo.: ' + @w_nom_centro_costo,
          @w_cla_empresa,               @w_cla_ubicacion,
          @w_cla_centro_costo,          @w_cla_depto,
          @w_cla_trab,
          Format(@w_importe_Ceco,       '##,###,###,##0.00'),
          Format(@w_saldo_Ceco,         '##,###,###,##0.00'),
          Format(@w_saldo_exento_Ceco,  '##,###,###,##0.00'),
          Format(@w_saldo_gravado_Ceco, '##,###,###,##0.00'),
          'L3';

--
-- Total por Ubicación
--

   Insert Into  #tmpResultado
  (CLA_RAZON_SOCIAL, NOM_UBICACION,
   CLA_EMPRESA,      CLA_UBICACION,
   CLA_CENTRO_COSTO, CLA_DEPTO,
   cla_trab,
   IMPORTE1,         SALDO,
   SALDO_EXENTO,     SALDO_GRAVADO,
   tipo)
   Select @w_cla_razon_social,          'Total Ubicación.: ' + @w_nom_ubicacion,
          @w_cla_empresa,               @w_cla_ubicacion,
          @w_cla_centro_costo,          @w_cla_depto,
          @w_cla_trab,
          Format(@w_importe_Ubic,       '##,###,###,##0.00'),
          Format(@w_saldo_Ubic,         '##,###,###,##0.00'),
          Format(@w_saldo_exento_Ubic,  '##,###,###,##0.00'),
          Format(@w_saldo_gravado_Ubic, '##,###,###,##0.00'),
          'L4';

--
-- Total por Empresa.
--

   Insert Into  #tmpResultado
  (CLA_RAZON_SOCIAL, NOM_EMPRESA,
   CLA_EMPRESA,      CLA_UBICACION,
   CLA_CENTRO_COSTO, CLA_DEPTO,
   cla_trab,
   IMPORTE1,         SALDO,
   SALDO_EXENTO,     SALDO_GRAVADO,
   tipo)
   Select @w_cla_razon_social,          ' Total Empresa ' + @w_nom_empresa,
          @w_cla_empresa,               @w_cla_ubicacion,
          @w_cla_centro_costo,          @w_cla_depto,
          @w_cla_trab,
          Format(@w_importe_Empr,       '##,###,###,##0.00'),
          Format(@w_saldo_Empr,         '##,###,###,##0.00'),
          Format(@w_saldo_exento_Empr,  '##,###,###,##0.00'),
          Format(@w_saldo_gravado_Empr, '##,###,###,##0.00'),
          'L5';

--
-- Total por Razón Social.
--

   Insert Into  #tmpResultado
  (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
   CLA_EMPRESA,      CLA_UBICACION,
   CLA_CENTRO_COSTO, CLA_DEPTO,
   CLA_TRAB,
   IMPORTE1,         SALDO,
   SALDO_EXENTO,     SALDO_GRAVADO,
   tipo)
   Select @w_cla_razon_social,        'Total Razón Social.: ' +  @w_nom_razon_social,
          @w_cla_empresa,             @w_cla_ubicacion,
          @w_cla_centro_costo,        @w_cla_depto,
          @w_cla_trab,
          Format(@w_importe_RZ,       '##,###,###,##0.00'),
          Format(@w_saldo_RZ,         '##,###,###,##0.00'),
          Format(@w_saldo_exento_RZ,  '##,###,###,##0.00'),
          Format(@w_saldo_gravado_RZ, '##,###,###,##0.00'),
          'L6';

--
-- Total Reporte.
--

   Insert Into  #tmpResultado
  (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
   CLA_EMPRESA,      CLA_UBICACION,
   CLA_CENTRO_COSTO, CLA_DEPTO,
   CLA_TRAB,
   IMPORTE1,         SALDO,
   SALDO_EXENTO,     SALDO_GRAVADO,
   tipo)
   Select @w_cla_razon_social,     ' Total Reporte ====> ',
          @w_cla_empresa,             @w_cla_ubicacion,
          @w_cla_centro_costo,        @w_cla_depto,
          @w_cla_trab,
          Format(@w_importe_Total,       '##,###,###,##0.00'),
          Format(@w_saldo_Total,         '##,###,###,##0.00'),
          Format(@w_saldo_exento_Total,  '##,###,###,##0.00'),
          Format(@w_saldo_gravado_Total, '##,###,###,##0.00'),
          'L7';

--

   Update  #tmpResultado
   Set     orden = Secuencia;

   Select @w_fechaProcIni = Min(INICIO_PER),
          @w_fechaProcFin = Max(FIN_PER)
   From   #tmpImporteNominas;

--
-- Actualiza de Deducciones.
--

   Set @w_inicio = 1;

   Declare
      C_Deducciones Cursor  For
         Select CLA_RAZON_SOCIAL,  NOM_RAZON_SOCIAL,
                CLA_EMPRESA,       NOM_EMPRESA,
                CLA_UBICACION,     NOM_UBICACION,
                CLA_CENTRO_COSTO,  NOM_CENTRO_COSTO,
                CLA_DEPTO,         NOM_DEPTO,
                CLA_TRAB,          NOM_TRAB,
                CLA_PERDED,        NOM_PERDED,
                Sum(IMPORTE),      Sum(Saldo),
                FECHA_NAC,         EDAD
         From   #tmpImporteNominas
         Where  TIPO_PERDED         = 2
         And    Isnull(IMPORTE, 0) != 0
         Group  By CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
                   CLA_EMPRESA,      NOM_EMPRESA,
                   NOM_UBICACION,    NOM_CENTRO_COSTO, NOM_DEPTO,     CLA_PERDED,
                   NOM_PERDED,       CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO,
                   CLA_TRAB,         NOM_TRAB,         FECHA_NAC,     EDAD
         Order  By CLA_RAZON_SOCIAL, CLA_EMPRESA,
                   CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO, CLA_TRAB, CLA_PERDED;
   Begin
      Open  C_Deducciones
      While @@Fetch_status < 1
      Begin
         Fetch C_Deducciones Into
               @w_cla_razon_social, @w_nom_razon_social,
               @w_cla_empresa,      @w_nom_empresa,
               @w_cla_ubicacion,    @w_nom_ubicacion,
               @w_cla_centro_costo, @w_nom_centro_costo,
               @w_cla_depto,        @w_nom_depto,
               @w_cla_trab,         @w_nom_trab,
               @w_cla_perded,       @w_nom_perded,
               @w_importe,          @w_saldo,
               @w_fechaNac,         @w_edad;
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
                      @w_importe_trab            = 0,
                      @w_importe_Depto           = 0,
                      @w_importe_Ceco            = 0,
                      @w_importe_Ubic            = 0,
                      @w_importe_Empr            = 0,
                      @w_importe_RZ              = 0,
                      @w_importe_Total           = 0,
                      @w_saldo_trab              = 0,
                      @w_saldo_Depto             = 0,
                      @w_saldo_Ceco              = 0,
                      @w_saldo_Ubic              = 0,
                      @w_saldo_Empr              = 0,
                      @w_saldo_RZ                = 0,
                      @w_saldo_Total             = 0;

               Select @w_sec_max = Max(orden),
                      @w_sec_min = Min(orden)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Trabajador.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion    Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo Or
            @w_cla_depto_ante          != @w_cla_depto        Or
            @w_cla_trab_ante           != @w_cla_trab
            Begin
               Select @w_secuencia = secuencia
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L1';

               Update  #tmpResultado
               Set     IMPORTE2 = Format(@w_importe_trab, '##,###,###,##0.00'),
                       SALDO2   = Format(@w_saldo_trab,   '##,###,###,##0.00')
               Where   secuencia = @w_secuencia;

               Select @w_importe_trab       = 0,
                      @w_saldo_trab         = 0,
                      @w_saldo_exento_trab  = 0,
                      @w_saldo_gravado_trab = 0;

               Select @w_sec_max = Max(secuencia),
                      @w_sec_min = Min(secuencia)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Departamento.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion    Or
            @w_cla_depto_ante          != @w_cla_depto
            Begin

               Select @w_secuencia = secuencia
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L2';

               Update  #tmpResultado
               Set     IMPORTE2 = Format(@w_importe_Depto, '##,###,###,##0.00'),
                       SALDO2   = Format(@w_saldo_Depto,   '##,###,###,##0.00')
               Where   secuencia = @w_secuencia;

               Select @w_importe_Depto       = 0,
                      @w_saldo_Depto         = 0;

               Select @w_sec_max = Max(secuencia),
                      @w_sec_min = Min(secuencia)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Centro de Costo.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo
            Begin
               Select @w_secuencia = secuencia
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L3';

               Update  #tmpResultado
               Set     IMPORTE2 = Format(@w_importe_Ceco, '##,###,###,##0.00'),
                       SALDO2   = Format(@w_saldo_Ceco,   '##,###,###,##0.00')
               Where   secuencia = @w_secuencia;

               Select @w_importe_trab       = 0,
                      @w_saldo_trab         = 0,
                      @w_saldo_exento_trab  = 0,
                      @w_saldo_gravado_trab = 0,
                      @w_importe_Ceco       = 0,
                      @w_saldo_Ceco         = 0;

               Select @w_sec_max = Max(secuencia),
                      @w_sec_min = Min(secuencia)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Ubicación.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion
            Begin
               Select @w_secuencia = secuencia
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L4';

               Update  #tmpResultado
               Set     IMPORTE2 = Format(@w_importe_Ubic, '##,###,###,##0.00'),
                       SALDO2   = Format(@w_saldo_Ubic,   '##,###,###,##0.00')
               Where   secuencia = @w_secuencia;

               Select @w_importe_Ubic       = 0,
                      @w_saldo_Ubic         = 0;

               Select @w_sec_max = Max(secuencia),
                      @w_sec_min = Min(secuencia)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Empresa.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa
            Begin
               Select @w_secuencia = secuencia
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L5';

               Update  #tmpResultado
               Set     IMPORTE2 = Format(@w_importe_Empr, '##,###,###,##0.00'),
                       SALDO2   = Format(@w_saldo_Empr,   '##,###,###,##0.00')
               Where   secuencia = @w_secuencia;

               Select @w_importe_Empr       = 0,
                      @w_saldo_Empr         = 0;

               Select @w_sec_max = Max(secuencia),
                      @w_sec_min = Min(secuencia)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Razón Social.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social
            Begin
               Select @w_secuencia = secuencia
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L6';

               Update  #tmpResultado
               Set     IMPORTE2 = Format(@w_importe_RZ, '##,###,###,##0.00'),
                       SALDO2   = Format(@w_saldo_RZ,   '##,###,###,##0.00')
               Where   secuencia = @w_secuencia;

               Select @w_importe_RZ      = 0,
                      @w_saldo_RZ        = 0;

               Select @w_sec_max = Max(secuencia),
                      @w_sec_min = Min(secuencia)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

        If @w_sec_min <= @w_sec_max
           Begin
              Update #tmpResultado
              Set    PERDED_2  = @w_cla_perded,
                     NOMDED_2  = @w_nom_perded,
                     IMPORTE2 = Format(@w_importe, '##,###,###,##0.00'),
                     SALDO2   = Format(@w_saldo,   '##,###,###,##0.00')
              Where  secuencia = @w_sec_min;
           End
        Else
           Begin
              Insert Into  #tmpResultado
             (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
              CLA_EMPRESA,      NOM_EMPRESA,
              CLA_UBICACION,    NOM_UBICACION,
              CLA_CENTRO_COSTO, NOM_CENTRO_COSTO,
              CLA_DEPTO,        NOM_DEPTO,
              CLA_TRAB,         NOM_TRAB,
              PERDED_2,         NOMDED_2,
              IMPORTE2,         SALDO2,
              Tipo,             Orden,
              FECHA_NAC,        EDAD)
              Select @w_cla_razon_social,     @w_nom_razon_social,
                     @w_cla_empresa,          @w_nom_empresa,
                     @w_cla_ubicacion,        @w_nom_ubicacion,
                     @w_cla_centro_costo,     @w_nom_centro_costo,
                     @w_cla_depto,            @w_nom_depto,
                     @w_cla_trab,             @w_nom_trab,
                     @w_cla_perded,           @w_nom_perded,
                     Format(@w_importe,       '##,###,###,##0.00'),
                     Format(@w_saldo,         '##,###,###,##0.00'),
                     'L0',                    @w_sec_min,
                     @w_fechaNac,             @w_edad;
           End


          Select @w_importe_Trab            = @w_importe_trab        + @w_importe,
                 @w_importe_Depto           = @w_importe_Depto       + @w_importe,
                 @w_importe_Ceco            = @w_importe_Ceco        + @w_importe,
                 @w_importe_Ubic            = @w_importe_Ubic        + @w_importe,
                 @w_importe_Empr            = @w_importe_Empr        + @w_importe,
                 @w_importe_RZ              = @w_importe_RZ          + @w_importe,
                 @w_importe_Total           = @w_importe_Total       + @w_importe,
                 @w_saldo_trab              = @w_saldo_trab          + @w_saldo,
                 @w_saldo_Depto             = @w_saldo_Depto         + @w_saldo,
                 @w_saldo_Ceco              = @w_saldo_Ceco          + @w_saldo,
                 @w_saldo_Ubic              = @w_saldo_Ubic          + @w_saldo,
                 @w_saldo_Empr              = @w_saldo_Empr          + @w_saldo,
                 @w_saldo_RZ                = @w_saldo_RZ            + @w_saldo,
                 @w_saldo_Total             = @w_saldo_Total         + @w_saldo,
                 @w_cla_razon_social_ante   = @w_cla_razon_social,
                 @w_nom_razon_social_ante   = @w_nom_razon_social,
                 @w_cla_empresa_ante        = @w_cla_empresa,
                 @w_cla_ubicacion_ante      = @w_cla_ubicacion,
                 @w_nom_ubicacion_ante      = @w_nom_ubicacion,
                 @w_cla_centro_costo_ante   = @w_cla_centro_costo,
                 @w_nom_centro_costo_ante   = @w_nom_centro_costo,
                 @w_cla_depto_ante          = @w_cla_depto,
                 @w_nom_depto_ante          = @w_nom_depto,
                 @w_cla_trab_ante           = @w_cla_trab,
                 @w_nom_trab_ante           = @w_nom_trab,
                 @w_importe                 = 0,
                 @w_saldo                   = 0,
                 @w_sec_min                 = @w_sec_min + 1;

      End
      Close       C_Deducciones
      Deallocate  C_Deducciones
   End

--
-- Total por Trabajador.
--

   Select @w_secuencia = secuencia
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L1';


   Update  #tmpResultado
   Set     IMPORTE2 = Format(@w_importe_Trab,       '##,###,###,##0.00'),
           SALDO2   = Format(@w_saldo_trab,         '##,###,###,##0.00')
   Where   secuencia = @w_secuencia;

--
-- Total por Departamento.
--

   Select @w_secuencia = secuencia
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L2';

   Update  #tmpResultado
   Set     IMPORTE2 = Format(@w_importe_depto, '##,###,###,##0.00'),
           SALDO2   = Format(@w_saldo_Depto,   '##,###,###,##0.00')
   Where   secuencia = @w_secuencia;

--
-- Total por Centro de Costo.
--

   Select @w_secuencia = secuencia
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L3';

   Update  #tmpResultado
   Set     IMPORTE2 = Format(@w_importe_Ceco, '##,###,###,##0.00'),
           SALDO2   = Format(@w_saldo_Ceco,   '##,###,###,##0.00')
   Where   secuencia = @w_secuencia;

--
-- Total por Centro de Ubicacion.
--

   Select @w_secuencia = secuencia
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L4';

   Update  #tmpResultado
   Set     IMPORTE2 = Format(@w_importe_Ubic, '##,###,###,##0.00'),
           SALDO2   = Format(@w_saldo_Ubic,   '##,###,###,##0.00')
   Where   secuencia = @w_secuencia;

--
-- Total por Empresa
--

   Select @w_secuencia = secuencia
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L5';

   Update  #tmpResultado
   Set     IMPORTE2 = Format(@w_importe_Empr, '##,###,###,##0.00'),
           SALDO2   = Format(@w_saldo_Empr,   '##,###,###,##0.00')
   Where   secuencia = @w_secuencia;

--
-- Total por Razón Social.
--

   Select @w_secuencia = secuencia
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L6';

   Update  #tmpResultado
   Set     IMPORTE2 = Format(@w_importe_RZ, '##,###,###,##0.00'),
           SALDO2   = Format(@w_saldo_RZ,   '##,###,###,##0.00')
   Where   secuencia = @w_secuencia;

--
-- Total General.
--

   Select @w_secuencia = secuencia
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L7';

   Update  #tmpResultado
   Set     IMPORTE2 = Format(@w_importe_Total, '##,###,###,##0.00'),
           SALDO2   = Format(@w_saldo_Total,   '##,###,###,##0.00')
   Where   secuencia = @w_secuencia;

--
-- se reordena la matriz
--
   Select @w_secuencia = 0,
          @w_reg       = 0;

   Declare
      C_secuencia Cursor For
      Select secuencia
      From   #tmpResultado
      Order  by Cla_razon_social, cla_empresa, cla_ubicacion,
                cla_centro_costo, cla_depto,   cla_trab,
                tipo,             secuencia;
   Begin
      Open C_secuencia
      While @@Fetch_status < 1
      Begin
         Fetch C_secuencia Into @w_secuencia;
         If @@Fetch_status != 0
            Begin
               Break
            End

         Set @w_reg = @w_reg + 1;

         Update #tmpResultado
         Set    orden = @w_reg
         Where  secuencia = @w_secuencia;

      End
      Close      C_secuencia
      Deallocate C_secuencia
   End

--
-- Carga de Provisiones.
--

   Set @w_inicio = 1;

   Declare
      C_Provisiones Cursor  For
         Select CLA_RAZON_SOCIAL,  NOM_RAZON_SOCIAL,
                CLA_EMPRESA,       NOM_EMPRESA,
                CLA_UBICACION,     NOM_UBICACION,
                CLA_CENTRO_COSTO,  NOM_CENTRO_COSTO,
                CLA_DEPTO,         NOM_DEPTO,
                CLA_TRAB,          NOM_TRAB,
                CLA_PERDED,        NOM_PERDED,
                Sum(IMPORTE),      Sum(Saldo),
                FECHA_NAC,         EDAD
         From   #tmpImporteNominas
         Where  TIPO_PERDED         = 3
         And    Isnull(IMPORTE, 0) != 0
         Group  By CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
                   CLA_EMPRESA,      NOM_EMPRESA,
                   NOM_UBICACION,    NOM_CENTRO_COSTO, NOM_DEPTO, CLA_PERDED,
                   NOM_PERDED,       CLA_CENTRO_COSTO, CLA_UBICACION, CLA_DEPTO,
                   CLA_TRAB,         NOM_TRAB,         FECHA_NAC,     EDAD
         Order  By CLA_RAZON_SOCIAL, CLA_EMPRESA,
                   CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO, CLA_TRAB, CLA_PERDED;
   Begin
      Open  C_Provisiones
      While @@Fetch_status < 1
      Begin
         Fetch C_Provisiones Into
               @w_cla_razon_social, @w_nom_razon_social,
               @w_cla_empresa,      @w_nom_empresa,
               @w_cla_ubicacion,    @w_nom_ubicacion,
               @w_cla_centro_costo, @w_nom_centro_costo,
               @w_cla_depto,        @w_nom_depto,
               @w_cla_trab,         @w_nom_trab,
               @w_cla_perded,       @w_nom_perded,
               @w_importe,          @w_saldo,
               @e_fecha_nac,        @w_edad;
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
                      @w_importe_trab            = 0,
                      @w_importe_Depto           = 0,
                      @w_importe_Ceco            = 0,
                      @w_importe_Ubic            = 0,
                      @w_importe_Empr            = 0,
                      @w_importe_RZ              = 0,
                      @w_importe_Total           = 0,
                      @w_saldo_trab              = 0,
                      @w_saldo_Depto             = 0,
                      @w_saldo_Ceco              = 0,
                      @w_saldo_Ubic              = 0,
                      @w_saldo_Empr              = 0,
                      @w_saldo_RZ                = 0,
                      @w_saldo_Total             = 0;

               Select @w_sec_max = Max(orden),
                      @w_sec_min = Min(orden)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Trabajador.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion    Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo Or
            @w_cla_depto_ante          != @w_cla_depto        Or
            @w_cla_trab_ante           != @w_cla_trab
            Begin
               Select @w_secuencia = orden
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L1';

               Update  #tmpResultado
               Set     IMPORTE3 = Format(@w_importe_trab, '##,###,###,##0.00'),
                       SALDO3   = Format(@w_saldo_trab,   '##,###,###,##0.00')
               Where   orden = @w_secuencia;

               Select @w_importe_trab       = 0,
                      @w_saldo_trab         = 0,
                      @w_saldo_exento_trab  = 0,
                      @w_saldo_gravado_trab = 0;

               Select @w_sec_max = Max(orden),
                      @w_sec_min = Min(orden)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Departamento.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion    Or
            @w_cla_depto_ante          != @w_cla_depto
            Begin

               Select @w_secuencia = orden
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L2';

               Update  #tmpResultado
               Set     IMPORTE3 = Format(@w_importe_Depto, '##,###,###,##0.00'),
                       SALDO3   = Format(@w_saldo_Depto,   '##,###,###,##0.00')
               Where   orden = @w_secuencia;

               Select @w_importe_Depto       = 0,
                      @w_saldo_Depto         = 0;

               Select @w_sec_max = Max(orden),
                      @w_sec_min = Min(orden)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Centro de Costo.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_centro_costo_ante   != @w_cla_centro_costo
            Begin
               Select @w_secuencia = orden
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L3';

               Update  #tmpResultado
               Set     IMPORTE3 = Format(@w_importe_Ceco, '##,###,###,##0.00'),
                       SALDO3   = Format(@w_saldo_Ceco,   '##,###,###,##0.00')
               Where   orden = @w_secuencia;

               Select @w_importe_trab       = 0,
                      @w_saldo_trab         = 0,
                      @w_saldo_exento_trab  = 0,
                      @w_saldo_gravado_trab = 0,
                      @w_importe_Ceco       = 0,
                      @w_saldo_Ceco         = 0;

               Select @w_sec_max = Max(orden),
                      @w_sec_min = Min(orden)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Ubicación.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa      Or
            @w_cla_ubicacion_ante      != @w_cla_ubicacion
            Begin
               Select @w_secuencia = orden
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L4';

               Update  #tmpResultado
               Set     IMPORTE3 = Format(@w_importe_Ubic, '##,###,###,##0.00'),
                       SALDO3   = Format(@w_saldo_Ubic,   '##,###,###,##0.00')
               Where   orden = @w_secuencia;

               Select @w_importe_Ubic       = 0,
                      @w_saldo_Ubic         = 0;

               Select @w_sec_max = Max(orden),
                      @w_sec_min = Min(orden)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Empresa.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social Or
            @w_cla_empresa_ante        != @w_cla_empresa
            Begin
               Select @w_secuencia = orden
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L5';

               Update  #tmpResultado
               Set     IMPORTE3 = Format(@w_importe_Empr, '##,###,###,##0.00'),
                       SALDO3   = Format(@w_saldo_Empr,   '##,###,###,##0.00')
               Where   orden    = @w_secuencia;

               Select @w_importe_Empr       = 0,
                      @w_saldo_Empr         = 0;

               Select @w_sec_max = Max(orden),
                      @w_sec_min = Min(orden)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

--
-- Total por Razón Social.
--

         If @w_cla_razon_social_ante   != @w_cla_razon_social
            Begin
               Select @w_secuencia = orden
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social_ante
               And    CLA_EMPRESA      = @w_cla_empresa_ante
               And    CLA_UBICACION    = @w_cla_ubicacion_ante
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo_ante
               And    CLA_DEPTO        = @w_cla_depto_ante
               And    CLA_TRAB         = @w_cla_trab_ante
               And    Tipo             = 'L6';

               Update  #tmpResultado
               Set     IMPORTE3 = Format(@w_importe_RZ, '##,###,###,##0.00'),
                       SALDO3   = Format(@w_saldo_RZ,   '##,###,###,##0.00')
               Where   orden    = @w_secuencia;

               Select @w_importe_RZ      = 0,
                      @w_saldo_RZ        = 0;

               Select @w_sec_max = Max(secuencia),
                      @w_sec_min = Min(secuencia)
               From   #tmpResultado
               Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
               And    CLA_EMPRESA      = @w_cla_empresa
               And    CLA_UBICACION    = @w_cla_ubicacion
               And    CLA_CENTRO_COSTO = @w_cla_centro_costo
               And    CLA_DEPTO        = @w_cla_depto
               And    CLA_TRAB         = @w_cla_trab
               And    Tipo             = 'L0';

            End

        If @w_sec_min <= @w_sec_max
           Begin
              Update #tmpResultado
              Set    PERDED_3  = @w_cla_perded,
                     NOMDED_3  = @w_nom_perded,
                     IMPORTE3 = Format(@w_importe, '##,###,###,##0.00'),
                     SALDO3   = Format(@w_saldo,   '##,###,###,##0.00')
              Where  orden = @w_sec_min;
           End
        Else
           Begin
              Insert Into  #tmpResultado
             (CLA_RAZON_SOCIAL, NOM_RAZON_SOCIAL,
              CLA_EMPRESA,      NOM_EMPRESA,
              CLA_UBICACION,    NOM_UBICACION,
              CLA_CENTRO_COSTO, NOM_CENTRO_COSTO,
              CLA_DEPTO,        NOM_DEPTO,
              CLA_TRAB,         NOM_TRAB,
              PERDED_3,         NOMDED_3,
              IMPORTE3,         SALDO3,
              Tipo,             Orden,
              FECHA_NAC,        EDAD)
              Select @w_cla_razon_social,     @w_nom_razon_social,
                     @w_cla_empresa,          @w_nom_empresa,
                     @w_cla_ubicacion,        @w_nom_ubicacion,
                     @w_cla_centro_costo,     @w_nom_centro_costo,
                     @w_cla_depto,            @w_nom_depto,
                     @w_cla_trab,             @w_nom_trab,
                     @w_cla_perded,           @w_nom_perded,
                     Format(@w_importe,       '##,###,###,##0.00'),
                     Format(@w_saldo,         '##,###,###,##0.00'),
                     'L0',                    @w_sec_min,
                     @w_fechaNac,             @w_edad;
           End


          Select @w_importe_Trab            = @w_importe_trab        + @w_importe,
                 @w_importe_Depto           = @w_importe_Depto       + @w_importe,
                 @w_importe_Ceco            = @w_importe_Ceco        + @w_importe,
                 @w_importe_Ubic            = @w_importe_Ubic        + @w_importe,
                 @w_importe_Empr            = @w_importe_Empr        + @w_importe,
                 @w_importe_RZ              = @w_importe_RZ          + @w_importe,
                 @w_importe_Total           = @w_importe_Total       + @w_importe,
                 @w_saldo_trab              = @w_saldo_trab          + @w_saldo,
                 @w_saldo_Depto             = @w_saldo_Depto         + @w_saldo,
                 @w_saldo_Ceco              = @w_saldo_Ceco          + @w_saldo,
                 @w_saldo_Ubic              = @w_saldo_Ubic          + @w_saldo,
                 @w_saldo_Empr              = @w_saldo_Empr          + @w_saldo,
                 @w_saldo_RZ                = @w_saldo_RZ            + @w_saldo,
                 @w_saldo_Total             = @w_saldo_Total         + @w_saldo,
                 @w_cla_razon_social_ante   = @w_cla_razon_social,
                 @w_nom_razon_social_ante   = @w_nom_razon_social,
                 @w_cla_empresa_ante        = @w_cla_empresa,
                 @w_cla_ubicacion_ante      = @w_cla_ubicacion,
                 @w_nom_ubicacion_ante      = @w_nom_ubicacion,
                 @w_cla_centro_costo_ante   = @w_cla_centro_costo,
                 @w_nom_centro_costo_ante   = @w_nom_centro_costo,
                 @w_cla_depto_ante          = @w_cla_depto,
                 @w_nom_depto_ante          = @w_nom_depto,
                 @w_cla_trab_ante           = @w_cla_trab,
                 @w_nom_trab_ante           = @w_nom_trab,
                 @w_importe                 = 0,
                 @w_saldo                   = 0,
                 @w_sec_min                 = @w_sec_min + 1;

      End
      Close       C_Provisiones
      Deallocate  C_Provisiones
   End

--
-- Total por Trabajador.
--

   Select @w_secuencia = orden
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L1';


   Update  #tmpResultado
   Set     IMPORTE3 = Format(@w_importe_Trab,       '##,###,###,##0.00'),
           SALDO3   = Format(@w_saldo_trab,         '##,###,###,##0.00')
   Where   orden = @w_secuencia;

--
-- Total por Departamento.
--

   Select @w_secuencia = orden
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L2';

   Update  #tmpResultado
   Set     IMPORTE3 = Format(@w_importe_depto, '##,###,###,##0.00'),
           SALDO3   = Format(@w_saldo_Depto,   '##,###,###,##0.00')
   Where   orden = @w_secuencia;

--
-- Total por Centro de Costo.
--

   Select @w_secuencia = orden
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L3';

   Update  #tmpResultado
   Set     IMPORTE3 = Format(@w_importe_Ceco, '##,###,###,##0.00'),
           SALDO3   = Format(@w_saldo_Ceco,   '##,###,###,##0.00')
   Where   orden = @w_secuencia;

--
-- Total por Centro de Ubicacion.
--

   Select @w_secuencia = orden
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L4';

   Update  #tmpResultado
   Set     IMPORTE3 = Format(@w_importe_Ubic, '##,###,###,##0.00'),
           SALDO3   = Format(@w_saldo_Ubic,   '##,###,###,##0.00')
   Where   orden    = @w_secuencia;

--
-- Total por Empresa
--

   Select @w_secuencia = orden
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L5';

   Update  #tmpResultado
   Set     IMPORTE3 = Format(@w_importe_Empr, '##,###,###,##0.00'),
           SALDO3   = Format(@w_saldo_Empr,   '##,###,###,##0.00')
   Where   orden = @w_secuencia;

--
-- Total por Razón Social.
--

   Select @w_secuencia = orden
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L6';

   Update  #tmpResultado
   Set     IMPORTE3 = Format(@w_importe_RZ, '##,###,###,##0.00'),
           SALDO3   = Format(@w_saldo_RZ,   '##,###,###,##0.00')
   Where   orden = @w_secuencia;

--
-- Total General.
--

   Select @w_secuencia = orden
   From   #tmpResultado
   Where  CLA_RAZON_SOCIAL = @w_cla_razon_social
   And    CLA_EMPRESA      = @w_cla_empresa
   And    CLA_UBICACION    = @w_cla_ubicacion
   And    CLA_CENTRO_COSTO = @w_cla_centro_costo
   And    CLA_DEPTO        = @w_cla_depto
   And    CLA_TRAB         = @w_cla_trab
   And    Tipo             = 'L7';

   Update  #tmpResultado
   Set     IMPORTE3 = Format(@w_importe_Total, '##,###,###,##0.00'),
           SALDO3   = Format(@w_saldo_Total,   '##,###,###,##0.00')
   Where   orden = @w_secuencia;


--
-- Presentación del Reporte.
--

Select NOM_RAZON_SOCIAL,     NOM_EMPRESA,
       Iif(tipo = 'L0', Cast(CLA_TRAB As varchar), ' ')         TRABAJADOR,          NOM_TRAB,
       FECHA_NAC,            EDAD,
       NOM_UBICACION,
       NOM_CENTRO_COSTO,
       NOM_DEPTO,
       PERDED_1,   NOMDED_1,
       IMPORTE1,   SALDO,     SALDO_EXENTO,    SALDO_GRAVADO,
       PERDED_2,   NOMDED_2,  IMPORTE2,        SALDO2,
       PERDED_3,   NOMDED_3,  IMPORTE3,        SALDO3,
       @w_tituloRep tituloRep,
       Concat(@w_nominas, ' DEL ', @w_fechaProcIni, ' AL ', @w_fechaProcFin) titulo1,
       @w_fechaProc FechaProceso, @w_horaProceso horaProceso
from   #tmpResultado
Order  by CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_UBICACION, CLA_CENTRO_COSTO,
          CLA_DEPTO, CLA_TRAB, TIPO, orden;


   Set Xact_Abort Off
   Return

End
Go
