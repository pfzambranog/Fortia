Alter PROCEDURE dbo.sp_alta_programacion_vac  
 @compania           CHAR(04)     = '',  
 @trabajador         CHAR(10)     = '',  
 @ciclo_laboral      CHAR(08)     = '',  
 @tipo_ciclo         SMALLINT = 1,  
 @secuencia_ciclo    SMALLINT     = 1,  
 @tiempo_prog_vac    DECIMAL(8,3) = 0,  
 @fecha_ini_per_vac  DATETIME     = '',  
 @fecha_fin_per_vac  DATETIME     = '',  
 @fecha_pago_vac     DATETIME     = '',  
 @situacion_programa TINYINT,  
 @tipo_vacaciones    TINYINT      = 0,  
 @manejo_dias_vac    TINYINT      = NULL,  
 @tipo_mov_vac       INT  = 0,  
 @origen_ap_cv       TINYINT      = 0  
AS  

Declare
  @sec_prog_vac           Smallint,  
  @programa               VARCHAR(30),  
  @w_programa_sus         VARCHAR(30),  
  @w_situacion_programa   TINYINT,
--
  @w_fechaComp            Date,
  @w_fechaIng             Date;  
  
Begin  
--select 'fra 1'  
  
 EXECUTE sp_programas_remplazo @compania, 'sp_alta_programacion_vac', @w_programa_sus OUTPUT  
  
--select 'fra 2'  
  
 IF ISNULL(@w_programa_sus, '') = ''  
 BEGIN  
  SET @sec_prog_vac = 0  
  
--select 'fra 3'  
  
  SELECT  @w_situacion_programa = situacion_programa,  
          @programa = programa  
  FROM    tipos_movimientos_vac  
  WHERE   compania     = @compania  
  AND     tipo_mov_vac = 1 -- fra @tipo_mov_vac  
  
--select 'fra 4'  
  
  Select @w_fechaIng = fecha_ingreso
  From   trabajadores_grales
  Where  compania = @compania
  And    trabajador = @trabajador;
  
  Set @w_fechaComp = Convert(Date, Substring(Convert(Char(10), @w_fechaIng, 103), 1, 6) +
                                   Substring(@ciclo_laboral, 5, 4), 103);
  If @fecha_ini_per_vac < @w_fechaComp
     Begin
        Set @tipo_vacaciones = 1;
     End

  IF ISNULL(@situacion_programa, ' ') = ' '  
     BEGIN  
      SET @situacion_programa = @w_situacion_programa  
     END  
  
  IF @origen_ap_cv = 1  
     SET @situacion_programa = 2 /* situacion de vacaciones confirmadas */   
  
--select 'fra 5'  
  
  SELECT  @sec_prog_vac = ISNULL(MAX(ISNULL(sec_prog_vac,0)),0) + 1  
  FROM    programacion_vacaciones  
  WHERE  compania      = @compania   
  AND  trabajador    = @trabajador   
  AND  ciclo_laboral = @ciclo_laboral  
  AND  tipo_ciclo    = @tipo_ciclo  
  
--select 'fra 6'  
  
  INSERT  INTO programacion_vacaciones  
  VALUES (@compania,  
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
  
--select 'fra 7'  
  
  IF ISNULL(@programa, ' ') <> ' '  
  BEGIN  
   EXECUTE @programa  
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
  END  
  
--select 'fra 8'  
  
 END  
 ELSE  
 BEGIN  
  
--select 'fra 9'  
  
  EXECUTE @w_programa_sus  
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
  
--select 'fra 10'  
  
 END  
END  