Alter Procedure dbo.sp_alta_programacion_vac
   @compania                 Char(04)     = '',
   @trabajador               Char(10)     = '',
   @ciclo_laboral            Char(08)     = '',
   @tipo_ciclo               Smallint     = 1,
   @secuencia_ciclo          Smallint     = 1,
   @tiempo_prog_vac          Decimal(8,3) = 0,
   @fecha_ini_per_vac        Date         = '',
   @fecha_fin_per_vac        Date         = '',
   @fecha_pago_vac           Date         = '',
   @situacion_programa       Tinyint      = Null,
   @tipo_vacaciones          Tinyint      = 0,
   @manejo_dias_vac          Tinyint      = Null,
   @tipo_mov_vac             Integer      = 0,
   @origen_ap_cv             Tinyint      = 0
AS

Declare
   @sec_prog_vac             Smallint,
   @programa                 Varchar(30),
   @w_programa_sus           Varchar(30),
   @w_situacion_programa     Tinyint,
--
   @w_fechaComp              Date,
   @w_fecha_ini_prog_vac     Date,
   @w_fecha_ingreso          Date,
   @w_fechaInicioVacCol      Date,
   @w_fecha_generacion       Date,
   @w_vac_por_ciclo          Integer,
   @w_ciclo                  Integer,
   @w_meses                  Integer,
   @w_ciclo_laboral          Char(08);

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off

--
-- Inicio Ajuste de parámetro Anticipo de Vacacaciones.
-- Laboratorios SENOSIAIN
--

   Select @w_vac_por_ciclo      = vac_por_ciclo,
          @w_fecha_ini_prog_vac = fecha_ini_prog_vac
   From   dbo.saldos_vacaciones
   Where  compania      = @compania
   And    trabajador    = @trabajador
   And    ciclo_laboral = @ciclo_laboral;
   If @@Rowcount = 0
      Begin
         Return
      End

   If @tipo_vacaciones != 1
      Begin
         Select @w_fecha_ingreso = fecha_ingreso
         From   dbo.trabajadores_grales
         Where  compania      = @compania
         And    trabajador    = @trabajador

         Set @w_fechaComp = DateAdd(mm, 12, @w_fecha_ingreso);

         If @fecha_ini_per_vac < @w_fechaComp Or
            @w_vac_por_ciclo   < @tiempo_prog_vac
            Begin
               Set @tipo_vacaciones = 1;
            End;

      End;

--
-- Fin Ajuste de parrámetro Anticipo de Vacacaciones.
--

--
-- Inicio Ajuste de Vacacaciones Colectivas.
-- Laboratorios SENOSIAIN
--

   Select Top 1 @w_fechaInicioVacCol = fecha
   From   dbo.parametros_rh
   Where  compania             = @compania
   And    parametro_rh         = 'VAC_COLECT'
   And    secuencia_parametro In (2, 3)
   And    fecha                = @fecha_ini_per_vac;
   If @@Rowcount = 0
      Begin
         Goto Sigue
      End

   Select @w_meses = entero
   From   dbo.parametros_rh
   Where  compania             = @compania
   And    parametro_rh         = 'VAC_COLECT'
   And    secuencia_parametro  = 1;
   If @@Rowcount = 0
      Begin
         Goto Sigue
      End

   Select @w_fechaInicioVacCol = DateAdd(mm, @w_meses, @w_fecha_ini_prog_vac),
          @w_ciclo             = Cast(Substring(@ciclo_laboral, 5, 4) As Integer),
          @w_fecha_generacion  = DateAdd(yy, 1, @w_fecha_ini_prog_vac),
          @w_ciclo_laboral     = Substring(@ciclo_laboral, 5, 4) +
                                        Cast(@w_ciclo + 1 As Char(04));

   If @fecha_ini_per_vac >= @w_fechaInicioVacCol
      Begin

         If Exists ( Select top 1 1
                     From   dbo.saldos_vacaciones
                     Where  compania      = @compania
                     And    trabajador    = @trabajador
                     And    ciclo_laboral = @w_ciclo_laboral)
            Begin
               Set @ciclo_laboral = @w_ciclo_laboral;
               Goto Sigue
            End

         Execute dbo.sp_gen_sal_ciclos_V5 @compania           = @compania,
                                          @trabajador         = @trabajador,
                                          @ciclo_laboral      = @w_ciclo,
                                          @no_ciclos          = 1,
                                          @fecha_generacion   = Null;

         Set @ciclo_laboral = @w_ciclo_laboral;

      End

--
-- Fin Validación de Vigencia de Vacaciones Colectivas.
--

Sigue:

   Execute dbo.sp_programas_remplazo @compania, 'sp_alta_programacion_vac', @w_programa_sus Output

   If Isnull(@w_programa_sus, '') = ''
      Begin
         Set @sec_prog_vac = 0

         Select  @w_situacion_programa = situacion_programa,
                 @programa = programa
         From    tipos_movimientos_vac
         Where   compania     = @compania
         And     tipo_mov_vac = 1 -- fra @tipo_mov_vac

         If Isnull(@situacion_programa, ' ') = ' '
            Begin
               Set @situacion_programa = @w_situacion_programa
            End

         If @origen_ap_cv = 1
            Begin
               Set @situacion_programa = 2 /* situacion de vacaciones confirmadas */
            End

--Select 'fra 5'

         Select  @sec_prog_vac = Isnull(MAX(Isnull(sec_prog_vac,0)),0) + 1
         From    programacion_vacaciones
         Where   compania      = @compania
         And     trabajador    = @trabajador
         And     ciclo_laboral = @ciclo_laboral
         And     tipo_ciclo    = @tipo_ciclo

--Select 'fra 6'

         Insert  Into dbo.programacion_vacaciones
         Values (@compania,
                 @trabajador,
                 @ciclo_laboral,
                 @tipo_ciclo,
                 @sec_prog_vac,
                 @secuencia_ciclo,
                 @tiempo_prog_vac,
                 @fecha_ini_per_vac,
                 @fecha_fin_per_vac,
                 @fecha_pago_vac,
                 2, --FRA @situacion_programa,
                 @tipo_vacaciones,
                 @manejo_dias_vac,
                 1) --fra @tipo_mov_vac)

--Select 'fra 7'

       If Isnull(@programa, ' ') <> ' '
          Begin
             Execute @programa
                     @compania,
                     @trabajador,
                     @ciclo_laboral,
                     @tipo_ciclo,
                     @secuencia_ciclo,
                     @tiempo_prog_vac,
                     @fecha_ini_per_vac,
                     @fecha_fin_per_vac,
                     @fecha_pago_vac,
                     @tipo_vacaciones,
                     @manejo_dias_vac,
                     1, -- fra @tipo_mov_vac,
                     @origen_ap_cv
          End

--Select 'fra 8'

      End
   Else
      Begin

--Select 'fra 9'

         Execute @w_programa_sus
                 @compania,
                 @trabajador,
                 @ciclo_laboral,
                 @tipo_ciclo,
                 @secuencia_ciclo,
                 @tiempo_prog_vac,
                 @fecha_ini_per_vac,
                 @fecha_fin_per_vac,
                 @fecha_pago_vac,
                 @tipo_vacaciones,
                 @manejo_dias_vac,
                 1, -- fra @tipo_mov_vac,
                 @origen_ap_cv

--Select 'fra 10'

      End

   Set Xact_Abort    Off
   Return

End
Go
