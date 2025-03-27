CREATE PROCEDURE dbo.sp_val_saldos_vacaciones(  
 @i_compania  CHAR(4),  
 @i_trabajador  CHAR(10),  
 @i_ciclo_laboral CHAR(8),  
 @i_tipo_ciclo  SMALLINT,  
 @i_secuencia_ciclo SMALLINT,  
 @i_fecha_ini_prog_vac SMALLDATETIME,  
 @i_fecha_cad_prog_vac DATETIME,  
 @i_vac_por_ciclo DECIMAL(8,3),  
 @i_acumulado_ciclo_ant DECIMAL(8,3),  
 @i_vac_disfrutadas DECIMAL(8,3),  
 @i_vac_programadas DECIMAL(8,3),  
 @i_vac_vencidas  DECIMAL(8,3),  
 @i_situacion_ciclo TINYINT,  
 @i_dias_lab  DECIMAL(8,3),  
 @i_dias_no_lab          DECIMAL(8,3),  
 @w_tipo_operacion TINYINT,  /* 1 = Alta, 2 = Cambio, 3 = Baja, 4 = MIIA */  
 @w_error  TINYINT OUTPUT)  
  
AS  
 DECLARE @w_llave    VARCHAR(300),  
  @w_fecha_hoy  SMALLDATETIME,  
  @w_nombre_tabla  VARCHAR(30),  
  @w_caducidad  DECIMAL(16,8),  
  @w_contador  INT,  
  @tgr_sit_trabajador TINYINT  
  
BEGIN  
 IF NOT EXISTS(SELECT 1 FROM SYSOBJECTS WHERE name = 'TEMP_VAC')  
 BEGIN  
  SET @w_fecha_hoy = GETDATE()  
  SET @w_nombre_tabla = 'saldos_vacaciones'  
  
  /* Valida los campos del registro */  
  
  SET @w_llave = ('Cia: ' + LTRIM(RTRIM(@i_compania)) + ' Tra: ' + LTRIM(RTRIM(@i_trabajador)) + ' Ciclo: ' + LTRIM(RTRIM(@i_ciclo_laboral)) + ' Tipo: ' + CAST(@i_tipo_ciclo AS VARCHAR) + ' Sec: ' + CAST(@i_secuencia_ciclo AS VARCHAR))  
  
  IF @i_compania IS NULL  
  BEGIN  
   EXECUTE sp_alta_errores_movimientos @w_nombre_tabla, @w_llave, 13, 1, @w_error  
   SET @w_error = 1  
  END  
  
  IF NOT EXISTS(SELECT 1   
   FROM  companias   
   WHERE compania = @i_compania)  
  BEGIN  
   EXECUTE sp_alta_errores_movimientos @w_nombre_tabla, @w_llave, 13, 2, @w_error  
   SET @w_error = 1  
  END  
  
  IF @i_trabajador IS NULL  
  BEGIN  
   EXECUTE sp_alta_errores_movimientos @w_nombre_tabla, @w_llave, 13, 3, @w_error  
   SET @w_error = 1  
  END  
  
  IF NOT EXISTS(SELECT 1   
   FROM  trabajadores_grales   
   WHERE compania   = @i_compania  
   AND trabajador = @i_trabajador)  
  BEGIN  
   EXECUTE sp_alta_errores_movimientos @w_nombre_tabla, @w_llave, 13, 4, @w_error  
   SET @w_error = 1  
  END  
  
  IF @w_tipo_operacion = 1  
  BEGIN  
   SET @w_caducidad = dbo.fn_valor_parametros_compania(NULL, @i_compania, 'cv_vacaciones', 1, @w_fecha_hoy)  
  
   IF (@w_caducidad <= 0 OR @w_caducidad > 50)  
   BEGIN  
    EXECUTE sp_alta_errores_movimientos @w_nombre_tabla, @w_llave, 13, 20, @w_error  
    SET @w_error = 1  
   END  
  END  
  
  IF @w_tipo_operacion = 3  
  BEGIN  
   -- SELECT  @w_contador = COUNT(*)  
   -- FROM  saldos_vacaciones  
   -- WHERE  compania     = @i_compania  
   -- AND  trabajador     = @i_trabajador  
   -- AND  (fecha_ini_prog_vac > @i_fecha_ini_prog_vac  
   -- OR   (fecha_ini_prog_vac = @i_fecha_ini_prog_vac
   -- AND   secuencia_ciclo <> @i_secuencia_ciclo))  
   -- AND   situacion_ciclo     = 1  
  
   -- IF @w_contador <> 0  
   -- BEGIN  
    -- EXECUTE sp_alta_errores_movimientos @w_nombre_tabla, @w_llave, 13, 25, @w_error  
    -- SET @w_error = 1  
   -- END  
  
   SELECT  @w_contador = vac_disfrutadas + vac_programadas  
   FROM  saldos_vacaciones  
   WHERE  compania = @i_compania  
   AND  trabajador = @i_trabajador  
   AND  ciclo_laboral = @i_ciclo_laboral  
   AND tipo_ciclo = @i_tipo_ciclo  
   AND secuencia_ciclo = @i_secuencia_ciclo  
  
   IF @w_contador <> 0  
   BEGIN  
    EXECUTE sp_alta_errores_movimientos @w_nombre_tabla, @w_llave, 13, 26, @w_error  
    SET @w_error = 1  
   END  
  END  
 END  
END  