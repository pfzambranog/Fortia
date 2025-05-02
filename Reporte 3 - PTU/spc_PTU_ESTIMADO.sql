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
   @w_fechaProcIni            Date,  
   @w_fechaProcFin            Date,  
   @w_fechaInicioPTU          Date,  
   @w_fechaTerminoPTU         Date,  
   @w_anioPtu                 Integer,  
   @w_Error                   Integer,  
   @w_secuencia               Integer,  
   @w_registros               Integer,  
   @w_MesIni                  Integer,  
   @w_MesFin                  Integer,  
   @w_AnioMesIni              Integer,  
   @w_AnioMesFin              Integer,  
   @w_diasEjercicio           Integer,  
   @w_diasGratificacion       Integer,  
   @w_reg                     Integer,  
   @w_secFin                  Integer,  
   @w_dias_prom               Integer,  
   @w_horaProceso             Char(20),  
   @w_inicio                  Bit,  
   @w_importe                 Decimal(18, 2),  
   @w_imp                     Decimal(18, 2),  
   @w_salBasePtu              Decimal(18, 2),  
   @w_PorcBasePtu             Decimal(18, 2),  
   @w_topePtu                 Decimal(18, 2),  
   @w_imp_PTU_A_REPARTIR      Decimal(18, 2),  
   @w_total_dias              Integer,  
   @w_total_salarios          Decimal(18, 2),  
   @w_sec_min                 Integer,  
   @w_sec_max                 Integer,  
   @w_mesIniPtu               Integer,  
   @w_mesFinPtu               Integer,  
   @w_fechaHoy                Date,  
   @w_Factor_Salarios         Float,  
   @w_factor_dias             Float,  
--  
   @w_char47                  Char(1);  
  
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
          @w_char47    = Char(47),  
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
  
   Select @w_dias_prom = VALOR_VAR_USUARIO  
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
   NOM_PERIODO  Varchar(100)  Not Null,  
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
  
   Create  Table #tmpPerded2  
  (CLA_EMPRESA       Integer      Not Null,  
   CLA_PERDED        Integer      Not Null,  
   NOM_PERDED        Varchar( 80) Not  Null,  
   TIPO_PERDED       Integer      Not Null,  
   Constraint tmpPerded2Pk  
   Primary Key (CLA_EMPRESA, TIPO_PERDED, CLA_PERDED));  
  
--  
-- Tabla Temporal de Trabajadores.  
--  
  
   Create Table #TmpTrabajador  
  (CLA_RAZON_SOCIAL    Integer         Not Null,  
   CLA_EMPRESA         Integer         Not Null,  
   CLA_TRAB            Integer         Not Null,  
   NOM_TRAB            Varchar(400)        Null,  
   FECHA_ING_GRUPO     Date                Null,  
   FECHA_BAJA          Date                Null,  
   STATUS_TRAB         Char(1)         Not Null,  
   CLA_PUESTO          Integer         Not Null Default 0,  
   CLA_CENTRO_COSTO    Integer         Not Null Default 0,  
   CLA_CLASIFICACION   Integer         Not Null Default 0,  
   CLA_UBICACION       Integer         Not Null Default 0,  
   CLA_AREA            Integer         Not Null Default 0,  
   CLA_DEPTO           Integer         Not Null Default 0,  
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
   MONTO               Decimal(18, 2)   Not Null,  
   Constraint TmpSalarioPromPk  
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED));  
  
--  
-- Tabla Temporal de Salarios Promedios de Trabajadores.  
--  
  
   Create Table #TmpFaltas  
  (CLA_RAZON_SOCIAL    Integer          Not Null,  
   CLA_EMPRESA         Integer          Not Null,  
   CLA_TRAB            Integer          Not Null,  
   CLA_PERDED          Integer          Not Null,  
   IMPORTE             Decimal(18, 2)   Not Null,  
   MONTO               Decimal(18, 2)   Not Null,  
   Constraint TmpFaltasPk  
   Primary Key (CLA_RAZON_SOCIAL, CLA_EMPRESA, CLA_TRAB, CLA_PERDED));  
  
--  
-- Tabla Temporal de Salarios Promedios de Trabajadores.  
--  
  
   Create Table #TmpIncapacidad  
  (CLA_RAZON_SOCIAL    Integer          Not Null,  
   CLA_EMPRESA         Integer          Not Null,  
   CLA_TRAB            Integer          Not Null,  
   CLA_PERDED          Integer          Not Null,  
   IMPORTE             Decimal(18, 2)   Not Null,  
   MONTO               Decimal(18, 2)   Not Null,  
   Constraint TmpIncapacidadPk  
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
-- Tabla de presentación de la Salida.  
--  
  
   Create Table #tmpResultado  
  (secuencia                 Integer        Not Null Identity (1, 1) Primary Key,  
   CLA_TRAB                  Integer        Not Null,  
   NOM_TRAB                  Varchar(200)   Not Null,  
   ESTATUS                   Varchar( 10)   Not Null,  
   NOM_PUESTO                Varchar(100)   Not Null,  
   NOM_EMPRESA               Varchar(120)   Not Null,  
   NOM_DEPTO                 Varchar(120)   Not Null,  
   NOM_CLASIFICACION         Varchar(120)   Not Null,  
   FECHA_ING_GRUPO           Date           Not Null,  
   FECHA_FINAL               Date           Not Null,  
   CUOTA_DIARIA              Decimal(18, 2) Not Null Default 0,  
   SAL_PROMEDIO              Decimal(18, 2) Not Null Default 0,  
   DIAS_ACTIVOS              Integer        Not Null Default 0,  
   FALTAS                    Integer        Not Null Default 0,  
   INCAPACIDADES             Integer        Not Null Default 0,  
   DIAS_TRABAJADOS           Integer        Not Null Default 0,  
   SALARIO_PARA_PTU          Decimal(18, 2) Not Null Default 0,  
   PTU_DIAS                  Decimal(18, 2) Not Null Default 0,  
   PTU_SALARIOS              Decimal(18, 2) Not Null Default 0,  
   PTU_SIN_TOPE              Decimal(18, 2) Not Null Default 0,  
   PTU_TOPADO                Decimal(18, 2) Not Null Default 0,  
   PTU_POR_PAGAR             Decimal(18, 2) Not Null Default 0,  
   DIAS_GRATIFICACION        Integer        Not Null Default 0,  
   IMPORTE_GRATIFICACION     Decimal(18, 2) Not Null Default 0,  
   GRATIFICACION_POR_PAGAR   Decimal(18, 2) Not Null Default 0,  
   PTU_MAS_GRAT              Decimal(18, 2) Not Null Default 0);  
  
--  
-- Inicio de Cálculo del Reporte.  
--  
  
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
   Where  NOM_TIPO_NOMINA = 'GRATIFICACION ESPECIAL';  
  
--  
-- Filtro de Consulta de Períodos de Nomina  
--  
  
   Insert Into #TmpPeriodo  
  (CLA_EMPRESA, CLA_PERIODO, NOM_PERIODO)  
   Select Distinct a.CLA_EMPRESA, a.CLA_PERIODO, a.NOM_PERIODO  
   From   dbo.RH_PERIODO a  
   Join   #TmpEmpresa    b  
   On     b.CLA_RAZON_SOCIAL = a.CLA_RAZON_SOCIAL  
   And    b.CLA_EMPRESA      = a.CLA_EMPRESA;  
  
   Insert Into #tmpNominas  
  (CLA_EMPRESA,      CLA_PERIODO,      NUM_NOMINA,       ANIO_MES,  
   INICIO_PER,       FIN_PER,          ANIO,             NOM_PERIODO,  
   TIPO_NOMINA,      NOM_TIPO_NOMINA,  STATUS_NOMINA,    STRING)  
   Select Distinct t1.CLA_EMPRESA, t1.CLA_PERIODO,      t1.NUM_NOMINA,          t1.ANIO_MES,  
          t1.INICIO_PER,  t1.FIN_PER,          t1.ANIO_MES / 100 ANIO, t2.NOM_PERIODO,  
          t4.TIPO_NOMINA, t4.NOM_TIPO_NOMINA,  t1.STATUS_NOMINA,  
          Concat('[', T1.CLA_PERIODO, '-', T1.NUM_NOMINA, ']') STRING  
   From   dbo.RH_FECHA_PER t1  
   Join   #TmpPeriodo      t2  
   On     t2.CLA_EMPRESA      = t1.CLA_EMPRESA  
   And    t2.CLA_PERIODO      = t1.CLA_PERIODO  
   Join   #TmpEmpresa      t3  
   On     t3.CLA_EMPRESA      = t1.CLA_EMPRESA  
   Join   #TmpTipoNom      t4  
   On     t4.TIPO_NOMINA      = t1.TIPO_NOMINA;  
  
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
   On     c.CLA_EMPRESA       = a.CLA_EMPRESA  
   And    c.VALOR_VAR_USUARIO = a.CLA_PERDED  
   Where  C.CLA_VAR           = '$prdGSPTU'  
   Order  By a.TIPO_PERDED, a.CLA_PERDED;  
  
--  
-- Filtro para Consulta de conceptos de nómina de4 Faltas.  
--  
  
   Insert Into #tmpPerded2  
  (CLA_EMPRESA,    CLA_PERDED,      NOM_PERDED, TIPO_PERDED)  
   Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,  1 TIPO_PERDED  
   From   dbo.RH_PERDED      a  
   Join   #TmpEmpresa        b  
   On     b.CLA_EMPRESA       = a.CLA_EMPRESA  
   Join   dbo.RH_VAR_USUARIO c  
   On     c.CLA_EMPRESA       = a.CLA_EMPRESA  
   And    c.VALOR_VAR_USUARIO = a.CLA_PERDED  
   Where  C.CLA_VAR           = '$prdfaPTU'  
   Order  By a.CLA_PERDED;  
  
--  
-- Filtro para Consulta de conceptos de nómina de Incapacidades.  
--  
  
   Insert Into #tmpPerded2  
  (CLA_EMPRESA,    CLA_PERDED,      NOM_PERDED, TIPO_PERDED)  
   Select Distinct a.CLA_EMPRESA, a.CLA_PERDED, a.NOM_PERDED,  2 TIPO_PERDED  
   From   dbo.RH_PERDED      a  
   Join   #TmpEmpresa        b  
   On     b.CLA_EMPRESA       = a.CLA_EMPRESA  
   Join   dbo.RH_VAR_USUARIO c  
   On     c.CLA_EMPRESA       = a.CLA_EMPRESA  
   And    c.VALOR_VAR_USUARIO = a.CLA_PERDED  
   Where  C.CLA_VAR           = '$prdinPTU'  
   Order  By a.CLA_PERDED;  
  
--  
-- Filtro para Consulta de los Trabajadores  
--  
  
   Insert Into #TmpTrabajador  
  (CLA_RAZON_SOCIAL, CLA_EMPRESA,       CLA_TRAB,      NOM_TRAB,  
   FECHA_ING_GRUPO,  FECHA_BAJA,        STATUS_TRAB,   CLA_PUESTO,  
   CLA_CENTRO_COSTO, CLA_CLASIFICACION, CLA_UBICACION, CLA_AREA,  
   CLA_DEPTO,        SUELDO_DIA)  
   Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA, b.CLA_TRAB,  
          Concat(Trim(b.NOM_TRAB), ' ', Trim(b.AP_PATERNO), ' ', Trim(b.AP_MATERNO)),  
          FECHA_ING_GRUPO,  Isnull(b.FECHA_BAJA, @w_fechaTerminoPTU),  b.STATUS_TRAB, b.CLA_PUESTO,  
          e.CLA_CENTRO_COSTO, b.CLA_CLASIFICACION, d.CLA_UBICACION,  f.CLA_AREA,  
          b.CLA_DEPTO,        h.SUE_DIA  
   From   dbo.RH_Trab        b  
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
   Join   #tmpRegImss           j  
   On     j.CLA_REG_IMSS     = b.CLA_REG_IMSS  
   And    j.CLA_EMPRESA      = b.CLA_EMPRESA  
   Order  By 1, 2, 3;  
  
--  
-- Datos para el Salario Promedio.  
--  
  
  Insert Into #TmpSalarioProm  
  (CLA_RAZON_SOCIAL, CLA_EMPRESA,       CLA_TRAB,  
   CLA_PERDED,       IMPORTE,          MONTO)  
   Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,       a.CLA_TRAB,  
          b.CLA_PERDED,       Sum(b.importe), Sum(b.monto)  
   From   dbo.RH_ENC_REC_HISTO a  
   Join   dbo.RH_DET_REC_HISTO b  
   On     b.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    b.CLA_TRAB         = a.CLA_TRAB  
   And    b.ANIO_MES         = a.ANIO_MES  
   And    b.NUM_NOMINA       = a.NUM_NOMINA  
   And    b.CLA_PERIODO      = a.CLA_PERIODO  
   Join   #TmpTrabajador      c  
   On     c.cla_razon_social = a.CLA_RAZON_SOCIAL  
   And    c.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    c.CLA_TRAB         = a.CLA_TRAB  
   Join   #tmpPerded          d  
   On     d.CLA_EMPRESA      = b.CLA_EMPRESA  
   And    d.CLA_PERDED       = b.CLA_PERDED  
   Join   #tmpNominas           i  
   On     i.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    i.CLA_PERIODO      = a.CLA_PERIODO  
   And    i.NUM_NOMINA       = a.NUM_NOMINA  
   And    i.ANIO_MES         = a.ANIO_MES  
   Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,  a.CLA_TRAB, b.CLA_PERDED;  
  
--  
-- Datos para las faltas.  
--  
  
  Insert Into #TmpFaltas  
  (CLA_RAZON_SOCIAL, CLA_EMPRESA,       CLA_TRAB,  
   CLA_PERDED,       IMPORTE,          MONTO)  
   Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,       a.CLA_TRAB,  
          b.CLA_PERDED,       Sum(b.importe), Sum(b.monto)  
   From   dbo.RH_ENC_REC_HISTO a  
   Join   dbo.RH_DET_REC_HISTO b  
   On     b.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    b.CLA_TRAB         = a.CLA_TRAB  
   And    b.ANIO_MES         = a.ANIO_MES  
   And    b.NUM_NOMINA       = a.NUM_NOMINA  
   And    b.CLA_PERIODO      = a.CLA_PERIODO  
   Join   #TmpTrabajador       c  
   On     c.cla_razon_social = a.CLA_RAZON_SOCIAL  
   And    c.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    c.CLA_TRAB         = a.CLA_TRAB  
   Join   #tmpPerded2          d  
   On     d.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    d.TIPO_PERDED      = 1  
   And    d.CLA_PERDED       = b.CLA_PERDED  
   Join   #tmpNominas           i  
   On     i.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    i.CLA_PERIODO      = a.CLA_PERIODO  
   And    i.NUM_NOMINA       = a.NUM_NOMINA  
   And    i.ANIO_MES         = a.ANIO_MES  
   Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,  a.CLA_TRAB, b.CLA_PERDED;  
  
--  
-- Datos para las Incapacidades.  
--  
  
  Insert Into #TmpIncapacidad  
  (CLA_RAZON_SOCIAL, CLA_EMPRESA,       CLA_TRAB,  
   CLA_PERDED,       IMPORTE,          MONTO)  
   Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,       a.CLA_TRAB,  
          b.CLA_PERDED,       Sum(b.importe), Sum(b.monto)  
   From   dbo.RH_ENC_REC_HISTO a  
   Join   dbo.RH_DET_REC_HISTO b  
   On     b.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    b.CLA_TRAB         = a.CLA_TRAB  
   And    b.ANIO_MES         = a.ANIO_MES  
   And    b.NUM_NOMINA       = a.NUM_NOMINA  
   And    b.CLA_PERIODO      = a.CLA_PERIODO  
   Join   #TmpTrabajador       c  
   On     c.cla_razon_social = a.CLA_RAZON_SOCIAL  
   And    c.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    c.CLA_TRAB         = a.CLA_TRAB  
   Join   #tmpPerded2          d  
   On     d.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    d.TIPO_PERDED      = 2  
   And    d.CLA_PERDED       = b.CLA_PERDED  
   Join   #tmpNominas          i  
   On     i.CLA_EMPRESA      = a.CLA_EMPRESA  
   And    i.CLA_PERIODO      = a.CLA_PERIODO  
   And    i.NUM_NOMINA       = a.NUM_NOMINA  
   And    i.ANIO_MES         = a.ANIO_MES  
   Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,  a.CLA_TRAB, b.CLA_PERDED;  
  
--  
-- Consulta a las Nóminas Abiertas.  
--  
  
   If Exists ( Select Top 1 1  
               From   #tmpNominas  
               Where  STATUS_NOMINA = 1)  
      Begin  
         Insert Into #TmpTrabajador  
        (CLA_RAZON_SOCIAL, CLA_EMPRESA,       CLA_TRAB,      NOM_TRAB,  
         FECHA_ING_GRUPO,  FECHA_BAJA,        STATUS_TRAB,   CLA_PUESTO,  
         CLA_CENTRO_COSTO, CLA_CLASIFICACION, CLA_UBICACION, CLA_AREA,  
         CLA_DEPTO,        SUELDO_DIA)  
         Select Distinct b.CLA_RAZON_SOCIAL, b.CLA_EMPRESA, b.CLA_TRAB,  
                Concat(Trim(b.NOM_TRAB), ' ', Trim(b.AP_PATERNO), ' ', Trim(b.AP_MATERNO)),  
                FECHA_ING_GRUPO,  Isnull(b.FECHA_BAJA, @w_fechaTerminoPTU),  b.STATUS_TRAB, b.CLA_PUESTO,  
                e.CLA_CENTRO_COSTO, b.CLA_CLASIFICACION, d.CLA_UBICACION,  f.CLA_AREA,  
                b.CLA_DEPTO,        h.SUE_DIA  
         From   dbo.RH_Trab        b  
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
         Join   dbo.RH_ENC_REC_ACTUAL  h  
         On     h.CLA_RAZON_SOCIAL = b.CLA_RAZON_SOCIAL  
         And    h.CLA_EMPRESA      = b.CLA_EMPRESA  
         And    h.CLA_TRAB         = b.CLA_TRAB  
         Join   #tmpNominas          i  
         On     i.CLA_EMPRESA      = h.CLA_EMPRESA  
         And    i.CLA_PERIODO      = h.CLA_PERIODO  
         And    i.NUM_NOMINA       = h.NUM_NOMINA  
         And    i.ANIO_MES         = h.ANIO_MES_ISPT  
         Join   #tmpRegImss          j  
         On     j.CLA_REG_IMSS     = b.CLA_REG_IMSS  
         And    j.CLA_EMPRESA      = b.CLA_EMPRESA  
         Order  By 1, 2, 3;  
  
Select *  
from   #tmpNominas   
  
Select *  
from   #TmpTrabajador;  
Return  
  
--  
-- Datos para el Salario Promedio.  
--  
  
         Insert Into #TmpSalarioProm  
        (CLA_RAZON_SOCIAL, CLA_EMPRESA,       CLA_TRAB,  
         CLA_PERDED,       IMPORTE,          MONTO)  
         Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,       a.CLA_TRAB,  
                b.CLA_PERDED,       Sum(b.importe), Sum(b.monto)  
         From   dbo.RH_ENC_REC_ACTUAL a  
         Join   dbo.RH_DET_REC_ACTUAL b  
         On     b.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    b.CLA_TRAB         = a.CLA_TRAB  
         And    b.NUM_NOMINA       = a.NUM_NOMINA  
         And    b.CLA_PERIODO      = a.CLA_PERIODO  
         Join   #TmpTrabajador      c  
         On     c.cla_razon_social = a.CLA_RAZON_SOCIAL  
         And    c.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    c.CLA_TRAB         = a.CLA_TRAB  
         Join   #tmpPerded          d  
         On     d.CLA_EMPRESA      = b.CLA_EMPRESA  
         And    d.CLA_PERDED       = b.CLA_PERDED  
         Join   #tmpNominas           i  
         On     i.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    i.CLA_PERIODO      = a.CLA_PERIODO  
         And    i.NUM_NOMINA       = a.NUM_NOMINA  
         And    i.ANIO_MES         = a.ANIO_MES_ISPT  
         Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,  a.CLA_TRAB, b.CLA_PERDED;  
  
--  
-- Datos para las faltas.  
--  
  
         Insert Into #TmpFaltas  
        (CLA_RAZON_SOCIAL, CLA_EMPRESA,       CLA_TRAB,  
         CLA_PERDED,       IMPORTE,          MONTO)  
         Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,       a.CLA_TRAB,  
                b.CLA_PERDED,       Sum(b.importe), Sum(b.monto)  
         From   dbo.RH_ENC_REC_ACTUAL a  
         Join   dbo.RH_DET_REC_ACTUAL b  
         On     b.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    b.CLA_TRAB         = a.CLA_TRAB  
         And    b.NUM_NOMINA       = a.NUM_NOMINA  
         And    b.CLA_PERIODO      = a.CLA_PERIODO  
         Join   #TmpTrabajador       c  
         On     c.cla_razon_social = a.CLA_RAZON_SOCIAL  
         And    c.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    c.CLA_TRAB         = a.CLA_TRAB  
         Join   #tmpPerded2          d  
         On     d.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    d.TIPO_PERDED      = 1  
         And    d.CLA_PERDED       = b.CLA_PERDED  
         Join   #tmpNominas           i  
         On     i.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    i.CLA_PERIODO      = a.CLA_PERIODO  
         And    i.NUM_NOMINA       = a.NUM_NOMINA  
         And    i.ANIO_MES         = a.ANIO_MES_ISPT  
         Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,  a.CLA_TRAB, b.CLA_PERDED;  
  
--  
-- Datos para las Incapacodades.  
--  
  
         Insert Into #TmpIncapacidad  
        (CLA_RAZON_SOCIAL, CLA_EMPRESA,      CLA_TRAB,  
         CLA_PERDED,       IMPORTE,          MONTO)  
         Select a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,       a.CLA_TRAB,  
                b.CLA_PERDED,       Sum(b.importe), Sum(b.monto)  
         From   dbo.RH_ENC_REC_ACTUAL a  
         Join   dbo.RH_DET_REC_ACTUAL b  
         On     b.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    b.CLA_TRAB         = a.CLA_TRAB  
         And    b.NUM_NOMINA       = a.NUM_NOMINA  
         And    b.CLA_PERIODO      = a.CLA_PERIODO  
         Join   #TmpTrabajador       c  
         On     c.cla_razon_social = a.CLA_RAZON_SOCIAL  
         And    c.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    c.CLA_TRAB         = a.CLA_TRAB  
         Join   #tmpPerded2          d  
         On     d.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    d.TIPO_PERDED      = 2  
         And    d.CLA_PERDED       = b.CLA_PERDED  
         Join   #tmpNominas           i  
         On     i.CLA_EMPRESA      = a.CLA_EMPRESA  
         And    i.CLA_PERIODO      = a.CLA_PERIODO  
         And    i.NUM_NOMINA       = a.NUM_NOMINA  
         And    i.ANIO_MES         = a.ANIO_MES_ISPT  
         Group  By a.CLA_RAZON_SOCIAL, a.CLA_EMPRESA,  a.CLA_TRAB, b.CLA_PERDED;  
  
      End  
  
Select *  
from   #TmpFaltas  
Return  
  
--  
-- Inicio de Consulta para el reporte.  
--  
  
   Insert Into #tmpResultado  
  (CLA_TRAB,    NOM_TRAB,  ESTATUS,           NOM_PUESTO,  
   NOM_EMPRESA, NOM_DEPTO, NOM_CLASIFICACION, FECHA_ING_GRUPO,  
   FECHA_FINAL, CUOTA_DIARIA)  
   Select a.CLA_TRAB,    a.NOM_TRAB,  Iif(a.STATUS_TRAB = 'A', 'ACTIVO', 'BAJA'), b.NOM_PUESTO,  
          c.NOM_EMPRESA, d.NOM_DEPTO, e.NOM_CLASIFICACION, a.FECHA_ING_GRUPO,  
          a.FECHA_BAJA,  a.SUELDO_DIA  
   From   #TmpTrabajador       a  
   Join   dbo.RH_PUESTO        b  
   On     b.CLA_EMPRESA        = a.CLA_EMPRESA  
   And    b.CLA_PUESTO         = a.CLA_PUESTO  
   Join   #TmpEmpresa          c  
   On     c.CLA_EMPRESA        = a.CLA_EMPRESA  
   And    c.cla_razon_social   = a.CLA_RAZON_SOCIAL  
   Join   #TmpDepto            d  
   On     d.CLA_EMPRESA        = a.CLA_EMPRESA  
   And    d.CLA_DEPTO          = a.CLA_DEPTO  
   Join   dbo.RH_CLASIFICACION e  
   On     e.CLA_EMPRESA        = a.CLA_EMPRESA  
   And    e.CLA_CLASIFICACION  = a.CLA_CLASIFICACION  
   Order  BY 1;  
  
   Update #tmpResultado  
   Set    SAL_PROMEDIO  = Isnull((Select Sum(importe) / @w_dias_prom  
                                  From   #TmpSalarioProm  
                                  Where  CLA_TRAB    = a.CLA_TRAB), 0)  
   From   #tmpResultado a  
   Where  ESTATUS = 'ACTIVO'  
   And    Exists  ( Select Top 1 1  
                    From   #TmpSalarioProm  
                    Where  CLA_TRAB    = a.CLA_TRAB);  
  
   Update #tmpResultado  
   Set    SAL_PROMEDIO  = a.CUOTA_DIARIA  
   From   #tmpResultado a  
   Where  ESTATUS      != 'ACTIVO'  
   Or     SAL_PROMEDIO  = 0;  
  
   Update #tmpResultado  
   Set    DIAS_ACTIVOS  = Iif(FECHA_ING_GRUPO > @w_fechaInicioPTU,  
                              Datediff(dd, FECHA_ING_GRUPO, FECHA_FINAL) + 1, @w_diasEjercicio);  
  
   Update #tmpResultado  
   Set    FALTAS  = (Select Sum(monto)  
                     From   #TmpFaltas  
                     Where  CLA_TRAB    = a.CLA_TRAB)  
   From   #tmpResultado a  
   Where  Exists  ( Select Top 1 1  
                    From   #TmpFaltas  
                    Where  CLA_TRAB    = a.CLA_TRAB);  
  
   Update #tmpResultado  
   Set    INCAPACIDADES  = (Select Sum(monto)  
                            From   #TmpIncapacidad  
                            Where  CLA_TRAB    = a.CLA_TRAB)  
   From   #tmpResultado a  
   Where  Exists           (Select Top 1 1  
                            From   #TmpIncapacidad  
                            Where  CLA_TRAB    = a.CLA_TRAB);  
  
   Update #tmpResultado  
   Set    DIAS_TRABAJADOS = a.DIAS_ACTIVOS - a.FALTAS - a.INCAPACIDADES  
   From   #tmpResultado a  
  
   Update #tmpResultado  
   Set    SALARIO_PARA_PTU = a.DIAS_TRABAJADOS * Iif(a.CUOTA_DIARIA > @w_topePtu, @w_topePtu, a.CUOTA_DIARIA)  
   From   #tmpResultado a  
  
   Select @w_total_dias     = Sum(a.DIAS_TRABAJADOS),  
          @w_total_salarios = Sum(SALARIO_PARA_PTU)  
   From   #tmpResultado a  
  
   Select @w_Factor_Salarios = (@w_imp_PTU_A_REPARTIR / 2) / @w_total_salarios,  
          @w_factor_dias     = (@w_imp_PTU_A_REPARTIR / 2) / @w_total_dias;  
  
   Update #tmpResultado  
   Set    PTU_DIAS           = a.DIAS_TRABAJADOS   * @w_Factor_dias,  
          PTU_SALARIOS       = a.SALARIO_PARA_PTU  * @w_Factor_Salarios,  
          PTU_SIN_TOPE       = (a.DIAS_TRABAJADOS  * @w_Factor_dias) + (a.SALARIO_PARA_PTU  * @w_Factor_Salarios),  
          PTU_TOPADO         = 90.00 * a.CUOTA_DIARIA,  
          DIAS_GRATIFICACION = Iif(a.ESTATUS = 'ACTIVO', @w_diasGratificacion, 0)  
   From   #tmpResultado a  
  
   Update #tmpResultado  
   Set    PTU_POR_PAGAR         = Iif(a.PTU_TOPADO > a.PTU_SIN_TOPE, a.PTU_SIN_TOPE, a.PTU_TOPADO),  
          IMPORTE_GRATIFICACION = a.SAL_PROMEDIO * a.DIAS_GRATIFICACION  
   From   #tmpResultado a;  
  
   Update #tmpResultado  
   Set    GRATIFICACION_POR_PAGAR  = Iif(a.IMPORTE_GRATIFICACION - a.PTU_POR_PAGAR < 0, 0, a.IMPORTE_GRATIFICACION - a.PTU_POR_PAGAR)  
   From   #tmpResultado a;  
  
   Update #tmpResultado  
   Set    PTU_MAS_GRAT  = a.PTU_POR_PAGAR + GRATIFICACION_POR_PAGAR  
   From   #tmpResultado a;  
  
   Select Format(CLA_TRAB, '########0') CLA_TRAB,    NOM_TRAB,  ESTATUS,           NOM_PUESTO,  
          NOM_EMPRESA, NOM_DEPTO, NOM_CLASIFICACION,  
          Format(FECHA_ING_GRUPO,          'dd/MM/yyyy')     FECHA_ING_GRUPO,  
          Format(FECHA_FINAL,              'dd/MM/yyyy')     FECHA_FINAL,  
          Format(CUOTA_DIARIA,             '###,###,##0.00') CUOTA_DIARIA,  
          Format(SAL_PROMEDIO,             '###,###,##0.00') SAL_PROMEDIO,  
          Format(DIAS_ACTIVOS,             '###,###,##0')    DIAS_ACTIVOS,  
          Format(FALTAS,                   '###,###,##0')    FALTAS,  
          Format(INCAPACIDADES,            '###,###,##0')    INCAPACIDADES,  
          Format(DIAS_TRABAJADOS,          '###,###,##0')    DIAS_TRABAJADOS,  
          Format(SALARIO_PARA_PTU,         '###,###,##0.00') SALARIO_PARA_PTU,  
          Format(PTU_DIAS,                 '###,###,##0')    PTU_DIAS,  
          Format(PTU_SALARIOS,             '###,###,##0.00') PTU_SALARIOS,  
          Format(PTU_SIN_TOPE,             '###,###,##0.00') PTU_SIN_TOPE,  
          Format(PTU_TOPADO,               '###,###,##0.00') PTU_TOPADO,  
          Format(PTU_POR_PAGAR,            '###,###,##0.00') PTU_POR_PAGAR,  
          Format(DIAS_GRATIFICACION,       '###,###,##0.00') DIAS_GRATIFICACION,  
          Format(IMPORTE_GRATIFICACION,    '###,###,##0.00') IMPORTE_GRATIFICACION,  
          Format(GRATIFICACION_POR_PAGAR,  '###,###,##0.00') GRATIFICACION_POR_PAGAR,  
          Format(PTU_MAS_GRAT,             '###,###,##0.00') PTU_MAS_GRAT,  
          @w_tituloRep Titulo_Rep,  
          Format(@w_topePtu,               '###,###,##0.00')    Tope_Ptu,  
          Format(@w_imp_PTU_A_REPARTIR,    '###,###,##0.00')    IMP_PTU_A_REPARTIR,  
          Format(@w_total_salarios,        '###,###,##0.00')    TOTAL_SALARIOS,  
          Format(@w_total_dias,            '###,###,##0')       TOTAL_DIAS,  
          Format(@w_Factor_Salarios,       '###,###,##0.00000') FACTOR_SALARIOS,  
          Format(@w_Factor_dias,           '###,###,##0.00000') FACTOR_DIAS  
   From   #tmpResultado  
   Where  secuencia = 1  
   Union  
   Select Format(CLA_TRAB, '########0') CLA_TRAB,    NOM_TRAB,  ESTATUS,           NOM_PUESTO,  
          NOM_EMPRESA, NOM_DEPTO, NOM_CLASIFICACION,  
          Format(FECHA_ING_GRUPO,          'dd/MM/yyyy')     FECHA_ING_GRUPO,  
          Format(FECHA_FINAL,              'dd/MM/yyyy')     FECHA_FINAL,  
          Format(CUOTA_DIARIA,             '###,###,##0.00') CUOTA_DIARIA,  
          Format(SAL_PROMEDIO,             '###,###,##0.00') SAL_PROMEDIO,  
          Format(DIAS_ACTIVOS,             '###,###,##0')    DIAS_ACTIVOS,  
          Format(FALTAS,                   '###,###,##0')    FALTAS,  
          Format(INCAPACIDADES,            '###,###,##0')    INCAPACIDADES,  
          Format(DIAS_TRABAJADOS,          '###,###,##0')    DIAS_TRABAJADOS,  
          Format(SALARIO_PARA_PTU,         '###,###,##0.00') SALARIO_PARA_PTU,  
          Format(PTU_DIAS,                 '###,###,##0')    PTU_DIAS,  
          Format(PTU_SALARIOS,             '###,###,##0.00') PTU_SALARIOS,  
          Format(PTU_SIN_TOPE,             '###,###,##0.00') PTU_SIN_TOPE,  
          Format(PTU_TOPADO,               '###,###,##0.00') PTU_TOPADO,  
          Format(PTU_POR_PAGAR,            '###,###,##0.00') PTU_POR_PAGAR,  
          Format(DIAS_GRATIFICACION,       '###,###,##0.00') DIAS_GRATIFICACION,  
          Format(IMPORTE_GRATIFICACION,    '###,###,##0.00') IMPORTE_GRATIFICACION,  
          Format(GRATIFICACION_POR_PAGAR,  '###,###,##0.00') GRATIFICACION_POR_PAGAR,  
          Format(PTU_MAS_GRAT,             '###,###,##0.00') PTU_MAS_GRAT,  
          Char(32) Titulo_Rep,             Char(32) Tope_Ptu,  
          Char(32) IMP_PTU_A_REPARTIR,  
          Char(32) TOTAL_SALARIOS,  
          Char(32) TOTAL_DIAS,  
          Char(32) Factor_Salarios,  
          Char(32) Factor_Dias  
   From   #tmpResultado  
   Where  secuencia != 1  
   Union  
   Select 'TOTALES' CLA_TRAB,    Char(32) NOM_TRAB,  Char(32) ESTATUS,           Char(32) NOM_PUESTO,  
          Char(32) NOM_EMPRESA, Char(32) NOM_DEPTO, Char(32) NOM_CLASIFICACION,  
          Char(32) FECHA_ING_GRUPO,  
          Char(32) FECHA_FINAL,  
          Char(32) CUOTA_DIARIA,  
          Char(32) SAL_PROMEDIO,  
          Char(32) DIAS_ACTIVOS,  
          Char(32) FALTAS,  
          Char(32) INCAPACIDADES,  
          Char(32) DIAS_TRABAJADOS,  
          Char(32) SALARIO_PARA_PTU,  
          Format(Sum(PTU_DIAS),                 '###,###,##0.00') PTU_DIAS,  
          Format(Sum(PTU_SALARIOS),             '###,###,##0.00') PTU_SALARIOS,  
          Format(Sum(PTU_SIN_TOPE),             '###,###,##0.00') PTU_SIN_TOPE,  
          Format(Sum(PTU_TOPADO),               '###,###,##0.00') PTU_TOPADO,  
          Format(Sum(PTU_POR_PAGAR),            '###,###,##0.00') PTU_POR_PAGAR,  
          Char(32)                                                DIAS_GRATIFICACION,  
          Format(Sum(IMPORTE_GRATIFICACION),    '###,###,##0.00') IMPORTE_GRATIFICACION,  
          Format(Sum(GRATIFICACION_POR_PAGAR),  '###,###,##0.00') GRATIFICACION_POR_PAGAR,  
          Format(Sum(PTU_MAS_GRAT),             '###,###,##0.00') PTU_MAS_GRAT,  
          Char(32) Titulo_Rep,             Char(32) Tope_Ptu,  
          Char(32) IMP_PTU_A_REPARTIR,  
          Char(32) TOTAL_SALARIOS,  
          Char(32) TOTAL_DIAS,  
          Char(32) Factor_Salarios,  
          Char(32) Factor_Dias  
   From   #tmpResultado  
   Order  By 1;  
  
   Set Xact_Abort Off  
   Return  
  
End
Go
