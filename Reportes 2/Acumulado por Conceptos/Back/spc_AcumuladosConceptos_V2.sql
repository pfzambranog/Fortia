-- Declare
   -- @PsRazon_Social            Varchar(Max)   = '1',
   -- @PsCla_Empresa             Varchar(Max)   = '',
   -- @PnAnio                    Integer        = 2025,
   -- @PsCla_Ubicacion           Varchar(Max)   = '',
   -- @PsCla_CentroCosto         Varchar(Max)   = '',
   -- @PsCla_Area                Varchar(Max)   = '',
   -- @PsCla_Depto               Varchar(Max)   = '',
   -- @PsCla_RegImss             Varchar(Max)   = '',
   -- @PnMesIni                  Integer        = 2,
   -- @PnMesFin                  Integer        = 2,
   -- @PsCla_TipoNom             Varchar(Max)   = '40',
   -- @PsCla_PerDed              Varchar(Max)   = '',
   -- @PsCla_Periodo             Varchar(Max)   = '',
   -- @PsNominas                 Varchar(Max)   = '202510003',
   -- @PsCla_Trab                Varchar(Max)   = '',
   -- @PsCla_Puesto              Varchar(Max)   = '',
   -- @PbImprimeProv             Bit            = 1,
   -- @PnError                   Integer        = 0,
   -- @PsMensaje                 Varchar( 250)  = Null;
-- Begin
   -- Execute dbo.spc_AcumuladosConceptos @PsRazon_Social   = @PsRazon_Social,
                                       -- @PsCla_Empresa    = @PsCla_Empresa,
                                       -- @PnAnio           = @PnAnio,
                                       -- @PsCla_Ubicacion  = @PsCla_Ubicacion,
                                       -- @PsCla_CentroCosto= @PsCla_CentroCosto,
                                       -- @PsCla_Area       = @PsCla_Area,
                                       -- @PsCla_Depto      = @PsCla_Depto,
                                       -- @PsCla_RegImss    = @PsCla_RegImss,
                                       -- @PnMesIni         = @PnMesIni,
                                       -- @PnMesFin         = @PnMesFin,
                                       -- @PsCla_TipoNom    = @PsCla_TipoNom,
                                       -- @PsCla_PerDed     = @PsCla_PerDed,
                                       -- @PsCla_Periodo    = @PsCla_Periodo,
                                       -- @PsNominas        = @PsNominas,
                                       -- @PsCla_Trab       = @PsCla_Trab,
                                       -- @PsCla_Puesto     = @PsCla_Puesto,
                                       -- @PbImprimeProv    = @PbImprimeProv,
                                       -- @PnError          = @PnError   Output,
                                       -- @PsMensaje        = @PsMensaje Output;
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
   @PsCla_Puesto              Varchar(Max)   = '',
   @PbImprimeProv             Bit            = 1,
   @PnError                   Integer        = 0    Output,
   @PsMensaje                 Varchar( 250)  = Null Output)
As

Declare
   @w_desc_error              Varchar(250),
   @w_tituloRep               Varchar(350),
   @w_fechaProc               Varchar( 10),
   @w_fechaProcIni            Date,
   @w_fechaProcFin            Date,
   @w_fechaInicio             Date,
   @w_fechaTermino            Date,
   @w_nominas                 Varchar(Max),
   @w_nom_tipo_nomina         Varchar(Max),
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
   @w_imp                     Decimal(18, 2),
   @w_sec_min                 Integer,
   @w_sec_max                 Integer,
   @w_cantidad                Integer,
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
          @w_tituloRep   = 'TOTAL NOMINA POR UBICACION, C.COSTO Y DEPARTAMENTO',
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
  (CLA_RAZON_SOCIAL Integer       Not Null,
   CLA_EMPRESA      Integer       Not Null,
   CLA_PERIODO      Integer       Not Null,
   NOM_PERIODO      Varchar(100)  Not Null,
   Constraint tempPeriodoPk
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_PERIODO));

--
-- Tabla Temporal de Conceptos de Nómina.
--

   Create  Table #tmpPerded
  (CLA_EMPRESA       Integer      Not Null,
   CLA_PERDED        Integer      Not Null,
   NOM_PERDED        Varchar( 80) Not  Null,
   TIPO_PERDED       Integer      Not Null,
   MOSTRAR_SALDO     INTEGER      Not Null Default 0,
   NO_AFECTAR_NETO   Integer      Not Null Default 0,
   ESBASE_ISPT       Integer      Not Null Default 0,
   Constraint tmpPerdedPk
   Primary Key (CLA_EMPRESA, CLA_PERDED));

--
-- Tabla Temporal de Nóminas.
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
   FECHA_NAC          Date              Null,
   EDAD               Integer           Null Default 0,
   NSS                Varchar( 20)      Null,
   RFC                Varchar( 20)      Null,
   SINDICALIZADO      Varchar( 30)      Null,
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
   FECHA_NAC         Varchar( 10)       Null Default Char(32),
   EDAD              Varchar(  4)       Null Default Char(32),
   NOM_PERIODO       Varchar(150)       Null,
   NOM_TIPO_NOMINA   Varchar( 10)       Null,
   ANIO_MES          Integer            Null,
   INICIO_PER        Date               Null,
   FIN_PER           Date               Null,
   CLA_PERDED        Integer        Not Null,
   NOM_PERDED        Varchar(120)   Not Null,
   TIPO_PERDED       Integer        Not Null,
   IMPORTE           Decimal(18, 2) Not Null Default 0,
   SALDO             Decimal(18, 2) Not Null Default 0,
   SALDO_EXENTO      Decimal(18, 2) Not Null Default 0,
   SALDO_GRAVADO     Decimal(18, 2) Not Null Default 0,
   Index tmpNominasTrabIdx01 (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_PERIODO, ANIO_MES,
   NUM_NOMINA, CLA_PERDED));

--
-- Tabla de presentación de la Salida.
--

   Create Table #tmpResultado
  (Secuencia           Integer        Not Null Identity (1, 1) Primary Key,
   TIPO_PERDED         Integer        Not Null,
   NOM_TIPO            Varchar( 15)   Not Null Default Char(32),
   CLA_PERDED          Varchar( 15)       Null Default Char(32),
   NOM_PERDED          Varchar( 80)       Null Default Char(32),
   IMPORTE             Varchar( 20)       Null Default Char(32),
   SALDO               Varchar( 20)       Null Default Char(32),
   SALDO_EXENTO        Varchar( 20)       Null Default Char(32),
   SALDO_GRAVADO       Varchar( 20)       Null Default Char(32));

--
-- Tabla de Salida.
--

   Create Table #tmpSalida
  (secuencia           Integer        Not Null Identity (1, 1) Primary Key,
   TIPO_PERDED         Integer        Not Null,
   NOM_TIPO            Varchar( 15)   Not Null Default Char(32),
   CONCEPTO            Varchar( 15)       Null Default Char(32),
   DESCRIPCION         Varchar(200)       Null Default Char(32),
   IMPORTE             Varchar( 20)       Null Default Char(32),
   SALDO               Varchar( 20)       Null Default Char(32),
   SALDO_EXENTO        Varchar( 20)       Null Default Char(32),
   SALDO_GRAVADO       Varchar( 20)       Null Default Char(32),
   TITULO_REP          Varchar(Max)       Null Default Char(32),
   NOMINA              Varchar(Max)       Null Default Char(32),
   FECHA_INICIO        Varchar( 10)       Null Default Char(32),
   FECHA_TERMINO       Varchar( 10)       Null Default Char(32),
   TRABAJADORES        Varchar( 10)   Not Null Default Char(32));
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
-- Filtro de los Puestos.
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
       (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, a.CLA_PERIODO, a.NOM_PERIODO
         From   dbo.RH_PERIODO a
         Join   #TmpEmpresa    b
         On     b.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL
         And    b.CLA_EMPRESA      = a.CLA_EMPRESA;
      End
   Else
      Begin
         Insert Into #TmpPeriodo
        (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA, b.CLA_PERIODO, b.NOM_PERIODO
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
        (CLA_EMPRESA,    CLA_PERDED,      NOM_PERDED, TIPO_PERDED,
         MOSTRAR_SALDO,  NO_AFECTAR_NETO, ESBASE_ISPT)
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                Case When TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(a.MOSTRAR_SALDO, 0), Isnull(a.NO_AFECTAR_NETO, 0),
                Isnull(a.ESBASE_ISPT, 0)
         From   dbo.RH_PERDED  a
         Join   #TmpEmpresa    b
         On     b.CLA_EMPRESA     = a.CLA_EMPRESA
         Where  a.NO_AFECTAR_NETO = 0
         And    a.NO_IMPRIMIR     = 0
         And    a.ES_PROVISION    = 0
         Union
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, '*** ' + a.NOM_PERDED,
                Case When TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(a.MOSTRAR_SALDO, 0), Isnull(a.NO_AFECTAR_NETO, 0),
                Isnull(a.ESBASE_ISPT, 0)
         From   dbo.RH_PERDED  a
         Join   #TmpEmpresa    b
         On     b.CLA_EMPRESA     = a.CLA_EMPRESA
         Where  a.NO_AFECTAR_NETO = 1
         And    a.NO_IMPRIMIR     = 0
         And    a.ES_PROVISION    = 0
         Union
         Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,
                3, Isnull(a.MOSTRAR_SALDO, 0), Isnull(a.NO_AFECTAR_NETO, 0),
                Isnull(a.ESBASE_ISPT, 0)
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
        (CLA_EMPRESA,    CLA_PERDED,      NOM_PERDED, TIPO_PERDED,
         MOSTRAR_SALDO,  NO_AFECTAR_NETO, ESBASE_ISPT)
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, b.NOM_PERDED,
                Case When b.TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(b.MOSTRAR_SALDO, 0), Isnull(b.NO_AFECTAR_NETO, 0),
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
         Select Distinct b.CLA_EMPRESA, b.CLA_PERDED, '*** ' + b.NOM_PERDED,
                Case When b.TIPO_PERDED = 10
                     Then 1
                     Else 2
                End, Isnull(b.MOSTRAR_SALDO, 0), Isnull(b.NO_AFECTAR_NETO, 0),
                Isnull(b.ESBASE_ISPT, 0)
         From   String_split(@PsCla_PerDed, ',') a
         Join   dbo.RH_PERDED                    b
         On     b.cla_perded      = a.value
         Join   #TmpEmpresa                      c
         On     c.CLA_EMPRESA     = b.CLA_EMPRESA
         Where  b.NO_AFECTAR_NETO = 1
         And    b.NO_IMPRIMIR     = 0
         And    b.ES_PROVISION    = 0
         Union
         Select Distinct b.CLA_EMPRESA,   b.CLA_PERDED, b.NOM_PERDED,
                3, Isnull(b.MOSTRAR_SALDO, 0), Isnull(b.NO_AFECTAR_NETO, 0),
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
         On     t3.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
         And    t3.CLA_EMPRESA      = t2.CLA_EMPRESA
         Join   #TmpTipoNom      t4
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
         Where  t1.Anio_Mes  Between @w_AnioMesIni And @w_AnioMesFin
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
         On     t1.NUM_NOMINA       = t0.value
         Join   #TmpPeriodo                   t2
         On     t2.CLA_EMPRESA      = t1.CLA_EMPRESA
         And    t2.CLA_PERIODO      = t1.CLA_PERIODO
         Join   #TmpEmpresa                   t3
         On     t3.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL
         And    t3.CLA_EMPRESA      = t2.CLA_EMPRESA
         Join   #TmpTipoNom                   t4
         On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA
         Where  t1.Anio_Mes   Between @w_AnioMesIni And @w_AnioMesFin;
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

   Select @w_fechaProcIni    = Min(INICIO_PER),
          @w_fechaProcFin    = Max(FIN_PER)
   From   #tmpNominas;

   If Isnull(@PsCla_Trab, '') = ''
      Begin
         Insert Into #TmpTrabajador
        (CLA_RAZON_SOCIAL, CLA_EMPRESA,      CLA_TRAB, NOM_TRAB,
         FECHA_ING,        FECHA_ING_GRUPO,  NSS,      RFC,
         SINDICALIZADO,    CLA_UBICACION,    CLA_CENTRO_COSTO, CLA_DEPTO,
         CLA_PUESTO,       FECHA_NAC,        EDAD,             CLA_PERIODO)
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
         Join   #TmpPeriodo        g
         On     g.CLA_EMPRESA      = a.CLA_EMPRESA
         And    g.CLA_PERIODO      = a.cla_periodo
         Join   #tmpPuesto         i
         On     i.CLA_EMPRESA      = a.CLA_EMPRESA
         And    i.CLA_PUESTO       = a.CLA_PUESTO
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
                b.FECHA_ING,                 b.FECHA_ING_GRUPO, Trim(b.NUM_IMSS), Trim(b.RFC),
                Case When Isnull(SIND, 0) = 0
                     Then 'NO SINDICALIZADO'
                     Else 'SINDICALIZADO'
                End SINDICALIZADO, b.CLA_UBICACION_BASE,    b.CLA_CENTRO_COSTO, b.CLA_DEPTO,
                b.CLA_PUESTO, b.FECHA_NAC, dbo.fnCalcEdad(b.FECHA_NAC, @w_fechaHoy),
                b.CLA_PERIODO
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
         Join   #tmpArea           g
         On     g.Cla_Empresa      = f.Cla_Empresa
         And    g.CLA_AREA         = f.CLA_AREA
         Join   #TmpPeriodo        h
         On     h.CLA_EMPRESA      = b.CLA_EMPRESA
         And    h.CLA_PERIODO      = b.cla_periodo
         Join   #tmpPuesto         i
         On     i.CLA_EMPRESA      = b.CLA_EMPRESA
         And    i.CLA_PUESTO       = b.CLA_PUESTO
         Where  b.FECHA_ING_GRUPO <= @w_fechaProcFin
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
          Sum(a.IMPORTE),        Sum(a.acum),     0 SALDO_GRAVADO,
          Sum(Case When ESBASE_ISPT = 1
                   Then a.EXENTO
                   Else 0
              End) SALDO_EXENTO,
          h.NOM_TIPO_NOMINA,
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
          h.NOM_TIPO_NOMINA,
          f.NOM_CENTRO_COSTO, b.CLA_UBICACION, f.CLA_CENTRO_COSTO, c.CLA_DEPTO,
          T1.CLA_RAZON_SOCIAL, T1.nom_razon_social,  a.CLA_TRAB,     i.NOM_TRAB,
          T2.NOM_EMPRESA,      i.FECHA_NAC,          i.EDAD
   Order  By T1.CLA_RAZON_SOCIAL, a.CLA_EMPRESA, b.CLA_UBICACION, f.CLA_CENTRO_COSTO,
          c.CLA_DEPTO, a.CLA_TRAB;
   Set @w_registros = @@Rowcount;

   Select @w_cantidad = count(Distinct CLA_TRAB)
   From   #tmpImporteNominas

   Select @w_fechaProcIni    = Min(INICIO_PER),
          @w_fechaProcFin    = Max(FIN_PER)
   From   #tmpImporteNominas;

   Update #tmpImporteNominas
   Set    SALDO = 0
   From   #tmpImporteNominas a
   Where  SALDO != 0
   And    Not Exists ( Select Top 1 1
                       From   #tmpPerded
                       Where  CLA_EMPRESA   = a.CLA_EMPRESA
                       And    CLA_PERDED    = a.CLA_PERDED
                       And    MOSTRAR_SALDO = 1)

   Update #tmpImporteNominas
   Set    SALDO_GRAVADO = importe - Isnull(SALDO_EXENTO, 0)
   From   #tmpImporteNominas a
   Where  Exists ( Select Top 1 1
                   From   #tmpPerded
                   Where  CLA_EMPRESA   = a.CLA_EMPRESA
                   And    CLA_PERDED    = a.CLA_PERDED
                   And    ESBASE_ISPT   = 1);


   Declare
      C_tipoNom  Cursor For
      Select  Distinct Concat(NOM_TIPO_NOMINA, '-', anio_mes)
      From    #tmpImporteNominas
      Order   by 1;
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
-- Carga de Cifras
--

  Insert Into #tmpResultado
  (TIPO_PERDED, CLA_PERDED,   NOM_PERDED,
   IMPORTE,     SALDO,        SALDO_EXENTO,
   SALDO_GRAVADO)
   Select TIPO_PERDED,        CLA_PERDED,         NOM_PERDED,
          Format(Sum(Importe),      '##,###,###,##0.00'),
          Format(Sum(SALDO),        '##,###,###,##0.00'),
          Format(Sum(SALDO_EXENTO), '##,###,###,##0.00'),
          Format(Sum(SALDO_GRAVADO),'##,###,###,##0.00')
   From   #tmpImporteNominas
   Group  By TIPO_PERDED, CLA_PERDED,   NOM_PERDED
   Order  By TIPO_PERDED, CLA_PERDED;


  Insert Into #tmpResultado
  (TIPO_PERDED, IMPORTE)
   Select 6,
          Format(Sum(Case When TIPO_PERDED = 1
                          Then Importe
                          Else -IMPORTE
                     End),      '##,###,###,##0.00')
   From   #tmpImporteNominas
   Where  TIPO_PERDED                 In (1, 2)
   And    Substring(NOM_PERDED, 1, 3) != '***';

   Insert Into #tmpSalida
  (TIPO_PERDED, NOM_TIPO,     CONCEPTO,     DESCRIPCION,
   IMPORTE,     SALDO,        SALDO_EXENTO, SALDO_GRAVADO,
   TITULO_REP,  NOMINA,       FECHA_INICIO, FECHA_TERMINO,
   TRABAJADORES)
   Select TIPO_PERDED, 'PERCEPCIONES'     NOM_TIPO,
          Char(32) CONCEPTO, Char(32)     Descripcion,
          Char(32) IMPORTE,
          Char(32) SALDO,    Char(32)     EXENTO, Char(32) GRAVADO,
          @w_tituloRep,      @w_nominas,  Convert(Char(10), @w_fechaProcIni, 103),
          Convert(Char(10), @w_fechaProcFin, 103),
          Format(@w_cantidad, '###,###,##0')
   From   #tmpResultado
   Where  secuencia = 1
   Union
   Select TIPO_PERDED, ' ' NOM_TIPO,   CLA_PERDED CONCEPTO, NOM_PERDED Descripcion,
          IMPORTE,
          SALDO,          SALDO_EXENTO, SALDO_GRAVADO,
          Char(32),       Char(32),     Char(32), Char(32), Char(32)
   From   #tmpResultado
   Where  TIPO_PERDED = 1
   Union
   Select 2 TIPO_PERDED, 'DEDUCCIONES'     NOM_TIPO,   Char(32)  CONCEPTO, Char(32) Descripcion,
          Char(32)   IMPORTE,
          Char(32)   SALDO,  Char(32)   EXENTO, Char(32) GRAVADO,
          Char(32),  Char(32),          Char(32),
          Char(32), Char(32)
   From   #tmpResultado
   Where  secuencia = 1
   Union
   Select TIPO_PERDED, ' ' NOM_TIPO,   CLA_PERDED CONCEPTO, NOM_PERDED  Descripcion, IMPORTE,
          SALDO,          SALDO_EXENTO, SALDO_GRAVADO,
          Char(32),       Char(32),     Char(32), Char(32), Char(32)
   From   #tmpResultado
   Where  TIPO_PERDED = 2
   Order  By  1, 3;

   If @PbImprimeProv = 1
      Begin
         Insert Into #tmpSalida
        (TIPO_PERDED, NOM_TIPO,     CONCEPTO,     DESCRIPCION,
         IMPORTE,     SALDO,        SALDO_EXENTO, SALDO_GRAVADO,
         TITULO_REP,  NOMINA,       FECHA_INICIO, FECHA_TERMINO)
         Select 3 TIPO_PERDED, 'PROVISIONES'     NOM_TIPO,
                Char(32)  CONCEPTO,
                Char(32)  Descripcion,
                Char(32)  IMPORTE,
                Char(32)  SALDO,
                Char(32)  EXENTO,
                Char(32)  GRAVADO,
                Char(32),       Char(32),     Char(32),   Char(32)
         From   #tmpResultado
         Where  secuencia = 1

         Insert Into #tmpSalida
        (TIPO_PERDED, NOM_TIPO,     CONCEPTO,     DESCRIPCION,
         IMPORTE,     SALDO,        SALDO_EXENTO, SALDO_GRAVADO,
         TITULO_REP,  NOMINA,       FECHA_INICIO, FECHA_TERMINO)
         Select TIPO_PERDED, ' ' NOM_TIPO,    CLA_PERDED CONCEPTO,
                NOM_PERDED  Descripcion, IMPORTE,
                SALDO,          SALDO_EXENTO, SALDO_GRAVADO,
                Char(32),       Char(32),     Char(32),   Char(32)
         From   #tmpResultado
         Where  TIPO_PERDED = 3
         Order  By  1, 3;
      End

   Insert Into #tmpSalida
  (TIPO_PERDED, NOM_TIPO, CONCEPTO,     DESCRIPCION,
   IMPORTE,     SALDO,    SALDO_EXENTO, SALDO_GRAVADO)
   Select TIPO_PERDED, ' '     NOM_TIPO,
          Char(32) CONCEPTO,  'TOTAL PERCEPCIONES'     Descripcion,
          Format(Sum(Cast(Replace(IMPORTE, ',', '') as Decimal(18, 2))), '##,###,###,##0.00'),
          Char(32)   SALDO,  Char(32)     EXENTO, Char(32) GRAVADO
   From   #tmpResultado
   Where  TIPO_PERDED                  = 1
   And    Substring(NOM_PERDED, 1, 3) != '***'
   Group  By TIPO_PERDED;


   Insert Into #tmpSalida
  (TIPO_PERDED, NOM_TIPO, CONCEPTO,     DESCRIPCION,
   IMPORTE,     SALDO,    SALDO_EXENTO, SALDO_GRAVADO)
   Select TIPO_PERDED, ' '     NOM_TIPO,
          Char(32) CONCEPTO,  '*** TOTAL VALES DESPENSA '     Descripcion,
          Format(Sum(Cast(Replace(IMPORTE, ',', '') as Decimal(18, 2))), '##,###,###,##0.00'),
          Char(32)   SALDO,  Char(32)     EXENTO, Char(32) GRAVADO
   From   #tmpResultado
   Where  TIPO_PERDED = 1
   And    Substring(NOM_PERDED, 1, 3) = '***'
   Group  By TIPO_PERDED;

   Insert Into #tmpSalida
  (TIPO_PERDED, NOM_TIPO, CONCEPTO,     DESCRIPCION,
   IMPORTE,     SALDO,    SALDO_EXENTO, SALDO_GRAVADO)
   Select TIPO_PERDED, ' '     NOM_TIPO,
          Char(32) CONCEPTO,  'TOTAL DEDUCCIONES'     Descripcion,
          Format(Sum(Cast(Replace(IMPORTE, ',', '') as Decimal(18, 2))), '##,###,###,##0.00'),
          Char(32)   SALDO,  Char(32)     EXENTO, Char(32) GRAVADO
   From   #tmpResultado
   Where  TIPO_PERDED = 2
   Group  By TIPO_PERDED


   If @PbImprimeProv = 1
      Begin
         Insert Into #tmpSalida
        (TIPO_PERDED, NOM_TIPO, CONCEPTO,     DESCRIPCION,
         IMPORTE,     SALDO,    SALDO_EXENTO, SALDO_GRAVADO)
         Select TIPO_PERDED, ' '     NOM_TIPO,
                Char(32) CONCEPTO,  'TOTAL PROVISIONES'     Descripcion,
                Format(Sum(Cast(Replace(IMPORTE, ',', '') as Decimal(18, 2))), '##,###,###,##0.00'),
                Char(32)   SALDO,  Char(32)     EXENTO, Char(32) GRAVADO
         From   #tmpResultado
         Where  TIPO_PERDED = 3
         Group  By TIPO_PERDED
      End

--
-- Neto a Pagar
--

   Insert Into #tmpSalida
  (TIPO_PERDED, NOM_TIPO, CONCEPTO,     DESCRIPCION,
   IMPORTE,     SALDO,    SALDO_EXENTO, SALDO_GRAVADO)
   Select TIPO_PERDED, ' '     NOM_TIPO,
          Char(32) CONCEPTO,  '     NETO  A PAGAR'     Descripcion,
          Format(Sum(Cast(Replace(IMPORTE, ',', '') as Decimal(18, 2))), '##,###,###,##0.00'),
          Char(32)   SALDO,  Char(32)     EXENTO, Char(32) GRAVADO
   From   #tmpResultado
   Where  TIPO_PERDED = 6
   Group  By TIPO_PERDED

--
-- Presentación del reporte.
--

   Select NOM_TIPO,     CONCEPTO,     Descripcion,   IMPORTE,
          SALDO,        SALDO_EXENTO, SALDO_GRAVADO, TITULO_REP,
          NOMINA,       FECHA_INICIO, FECHA_TERMINO, TRABAJADORES
   from   #tmpSalida
   Order  by secuencia;

   Set Xact_Abort Off
   Return

End
Go
