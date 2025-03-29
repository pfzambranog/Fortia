Alter PROCEDURE dbo.sp_alta_programacion_vac
   @compania              Char(04)     = '',
   @trabajador            Char(10)     = '',
   @ciclo_laboral         Char(08)     = '',
   @tipo_ciclo            Smallint     = 1,
   @secuencia_ciclo       Smallint     = 1,
   @tiempo_prog_vac       Decimal(8,3) = 0,
   @fecha_ini_per_vac     Datetime     = '',
   @fecha_fin_per_vac     Datetime     = '',
   @fecha_pago_vac        Datetime     = '',
   @situacion_programa    Tinyint      = Null,
   @tipo_vacaciones       Tinyint      = 0,
   @manejo_dias_vac       Tinyint      = Null,
   @tipo_mov_vac          Integer      = 0,
   @origen_ap_cv          Tinyint      = 0
AS

Declare
   @sec_prog_vac          Smallint,
   @programa              Varchar(30),
   @w_programa_sus        Varchar(30),
   @w_situacion_programa  Tinyint,
--
   @w_fechaComp           Date,
   @w_fecha_ini_prog      Date,
   @w_vac_por_ciclo       Integer;

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off

--
-- Inicio Ajuste de parrámetro Anticipo de Vacacaciones.
-- Laboratorios SENOSIAIN
--

   If @tipo_vacaciones != 1
      Begin
         Select @w_fecha_ini_prog = fecha_ingreso
         From   dbo.trabajadores_grales
         Where  compania      = @compania
         And    trabajador    = @trabajador
         
         Select @w_vac_por_ciclo   = vac_por_ciclo
         From   dbo.saldos_vacaciones
         Where  compania      = @compania
         And    trabajador    = @trabajador
         And    ciclo_laboral = @ciclo_laboral;
   
         Set @w_fechaComp = DateAdd(mm, 12, @w_fecha_ini_prog);

         If @fecha_ini_per_vac < @w_fechaComp Or
            @w_vac_por_ciclo   < @tiempo_prog_vac
            Begin
               Set @tipo_vacaciones = 1;
            End;

      End;

--
-- Fin Ajuste de parrámetro Anticipo de Vacacaciones.
--

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