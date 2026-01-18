Create Or Alter Procedure dbo.sp_cierre_nomina_cv_ns  
 @compania  CHAR(4),  
 @id_calendario SMALLINT  
  
AS   
 DECLARE @w_concepto   SMALLINT,  
  @w_trabajador  CHAR(10),  
  @w_tiempo       DECIMAL(8,3),  
       @w_ciclo_laboral CHAR(8),  
       @w_tipo_ciclo  SMALLINT,  
  @w_sec_prog_vac  SMALLINT,  
  @w_fecha_ini_per_vac  SMALLDATETIME,  
  @w_fecha_fin_per_vac  SMALLDATETIME,  
           @w_tipo_mov_vac  INT,  
  
           @w_dias_vac             SMALLINT,  
           @w_concepto_pago    SMALLINT,  
  @w_concepto_ausencia  SMALLINT,  
  
  @w_tipo_nomina  CHAR(2),  
  @w_fecha_inicio_per SMALLDATETIME,  
      @w_fecha_termino_per SMALLDATETIME,  
             
           @w_fecha_kardex  SMALLDATETIME,  
    @w_secuencia            SMALLINT,  
      @w_status_err     TINYINT,  
     @w_act_kardex           TINYINT,  
     @w_cod_kardex           SMALLINT,  
     @w_gen_concepto_ns      SMALLINT,  
  
     @w_sql                  VARCHAR(2000),  
  @w_apo                  CHAR(1),  
  
  @w_programa_sus     VARCHAR(30)  
  
BEGIN  
 EXECUTE sp_programas_remplazo @compania, 'sp_cierre_nomina_cv_ns', @w_programa_sus OUTPUT  
  
 IF ISNULL(@w_programa_sus, '') = ''  
 BEGIN  
  SET @w_apo = CHAR(39)  
  
  /* Se obtiene la información de la tabla calendario_procesos */  
  
  SET @w_tipo_nomina = ''  
  SET @w_fecha_inicio_per = ''  
  SET @w_fecha_termino_per = ''  
  
  SELECT  @w_tipo_nomina       = tipo_nomina,  
   @w_fecha_inicio_per  = fecha_inicio,  
   @w_fecha_termino_per = fecha_termino  
  FROM  calendario_procesos  
  WHERE   id_calendario = @id_calendario  
  
  IF @@ROWCOUNT = 0  
  BEGIN  
       RAISERROR ('El calendario de procesos no existe [cierre_nomina_cv]', 16, 1)  
       RETURN  
  END  
  
  /* verifica si se incorporará a  kárdex */  
  
  SET @w_act_kardex = 0  
  SET @w_act_kardex = dbo.fn_valor_parametros_compania(NULL, @compania, 'cv_vacaciones', 16, GETDATE())  
  
   IF (@w_act_kardex = 1)   /* si actualiza el módulo de kárdex */  
     BEGIN  
      SET @w_cod_kardex = 0  
      SET @w_cod_kardex = dbo.fn_valor_parametros_compania(NULL, @compania, 'cv_vacaciones', 17, GETDATE())  
  
   /* verifica si se incorporará a kardex en forma sumarizada o a detalle */  
  
   SET @w_gen_concepto_ns = 0  
  
             SELECT  @w_gen_concepto_ns = ISNULL(gen_concepto_ns,0)  
   FROM incidencias_kp_def  
             WHERE   compania      = @compania   
   AND incidencia_kp = @w_cod_kardex  
  
      END  
  
  /* Indica como se van a manejar el calculo de días de vacaciones 0 = Dias Naturales, 1 = Dias Habiles y 2 = Sistemas Horario */  
  
  SET @w_dias_vac = dbo.fn_valor_parametros_compania(NULL, @compania, 'cv_vacaciones', 5, GETDATE())  
  
  SET @w_sql = 'DECLARE cr_trans_vacaciones CURSOR FOR '  
  
  SET @w_sql = @w_sql + ' SELECT tn.concepto, tn.trabajador, ISNULL(tn.tiempo,0), '  
  SET @w_sql = @w_sql + ' pv.ciclo_laboral, pv.tipo_ciclo, pv.sec_prog_vac, '  
  SET @w_sql = @w_sql + ' pv.fecha_ini_per_vac, pv.fecha_fin_per_vac, '  
  SET @w_sql = @w_sql + ' dbo.fn_transacciones_ns_val(tn.compania, tn.clase_nomina, tn.id_calendario, tn.concepto, tn.trabajador, tn.referencia, tn.secuencia, 3, 12) '  
  SET @w_sql = @w_sql + ' FROM transacciones_ns tn, programacion_vacaciones pv '  
  SET @w_sql = @w_sql + ' WHERE tn.compania = ' + @w_apo + @compania + @w_apo  
  SET @w_sql = @w_sql + ' AND tn.id_calendario = ' + CAST(@id_calendario AS VARCHAR(5))  
  SET @w_sql = @w_sql + ' AND tn.sit_transaccion = 2 '  
  SET @w_sql = @w_sql + ' AND pv.compania = tn.compania '  
  SET @w_sql = @w_sql + ' AND pv.trabajador = tn.trabajador '  
  SET @w_sql = @w_sql + ' AND pv.ciclo_laboral = SUBSTRING(tn.Referencia, 1, 8) '  
  
  IF EXISTS (SELECT TOP 1 1  
   FROM  transacciones_ns_val  
   WHERE compania     = @compania  
   AND id_calendario    = @id_calendario  
   AND origen_transaccion = 12)  
  BEGIN  
   SET @w_sql = @w_sql + ' AND pv.tipo_ciclo = dbo.fn_transacciones_ns_val(tn.compania, tn.clase_nomina, tn.id_calendario, tn.concepto, tn.trabajador, tn.referencia, tn.secuencia, 1, 12) '  
   SET @w_sql = @w_sql + ' AND pv.sec_prog_vac = dbo.fn_transacciones_ns_val(tn.compania, tn.clase_nomina, tn.id_calendario, tn.concepto, tn.trabajador, tn.referencia, tn.secuencia, 2, 12) '  
  END  
  ELSE  
  BEGIN  
   SET @w_sql = @w_sql + ' AND LTRIM(RTRIM(CAST(pv.sec_prog_vac AS CHAR))) = LTRIM(RTRIM(SUBSTRING(tn.referencia2, 6, 5))) '  
  END  
  
  EXEC(@w_sql)  
  
  OPEN  cr_trans_vacaciones  
        FETCH cr_trans_vacaciones  
   INTO  @w_concepto, @w_trabajador, @w_tiempo,  
    @w_ciclo_laboral, @w_tipo_ciclo, @w_sec_prog_vac,  
   @w_fecha_ini_per_vac, @w_fecha_fin_per_vac, @w_tipo_mov_vac  
  
         WHILE @@FETCH_STATUS = 0  
  BEGIN  
   SET @w_concepto_pago = 0  
   SET @w_concepto_ausencia = 0  
  
   SELECT  @w_concepto_ausencia = concepto_ausencia,  
    @w_concepto_pago     = concepto_pago  
   FROM  tipos_movimientos_vac  
   WHERE compania     = @compania  
   AND tipo_mov_vac = @w_tipo_mov_vac  
  
   IF @w_concepto = @w_concepto_ausencia  
   BEGIN  
    IF @w_fecha_fin_per_vac < @w_fecha_inicio_per   
    OR @w_fecha_fin_per_vac BETWEEN  @w_fecha_inicio_per AND  @w_fecha_termino_per  
              BEGIN  
               UPDATE  programacion_vacaciones  
            SET  situacion_programa = 3,       /* Disfrutadas */  
             tipo_mov_vac       = @w_tipo_mov_vac  
            WHERE   compania     = @compania   
     AND  trabajador     = @w_trabajador   
     AND  ciclo_laboral      = @w_ciclo_laboral  
     AND tipo_ciclo    = @w_tipo_ciclo  
     AND  sec_prog_vac     = @w_sec_prog_vac  
             END  
             ELSE  
             BEGIN  
              UPDATE  programacion_vacaciones  
            SET  situacion_programa = 7,       /* Disfrutadas Parcialmente*/  
             tipo_mov_vac       = @w_tipo_mov_vac  
            WHERE   compania     = @compania   
     AND  trabajador     = @w_trabajador   
     AND  ciclo_laboral      = @w_ciclo_laboral  
     AND tipo_ciclo    = @w_tipo_ciclo  
     AND  sec_prog_vac     = @w_sec_prog_vac  
             END  
            END  
  
            IF @w_concepto = @w_concepto_pago AND ISNULL(@w_concepto_ausencia,0) = 0  
            BEGIN  
              UPDATE  programacion_vacaciones  
           SET  situacion_programa = 6        /* Pagadas */   
           WHERE   compania     = @compania   
    AND  trabajador     = @w_trabajador   
    AND  ciclo_laboral      = @w_ciclo_laboral  
    AND tipo_ciclo    = @w_tipo_ciclo  
    AND  sec_prog_vac     = @w_sec_prog_vac  
   END  
  
   IF @w_act_kardex = 1 AND @w_concepto = @w_concepto_ausencia    /* si actualiza kárdex */  
             BEGIN  
                  IF @w_gen_concepto_ns = 1      /* incoporación individual */  
                  BEGIN  
                   SET @w_status_err  = 0  
                   SET @w_fecha_kardex = @w_fecha_ini_per_vac    
  
                   WHILE @w_fecha_kardex <= @w_fecha_fin_per_vac   
                   BEGIN  
                    SET  @w_status_err = 0  
  
      EXECUTE fn_calcula_fecha_fin_vac   
       @compania,   
       @w_trabajador,   
       @w_fecha_kardex,   
       1,   
       @w_dias_vac,   
       @w_fecha_fin_per_vac OUTPUT  
  
           IF NOT(@w_fecha_fin_per_vac  = '')  
             BEGIN  
              SET @w_secuencia = 0  
  
                     SELECT  @w_secuencia = (ISNULL(MAX(ISNULL(secuencia,0)),0) + 1)   
                     FROM    incidencias_kp  
                     WHERE   compania         = @compania   
       AND trabajador       = @w_trabajador   
       AND incidencia_kp    = @w_cod_kardex    
       AND fecha_incidencia = @w_fecha_kardex   
  
              INSERT INTO incidencias_kp   
                     VALUES (@compania,  
                       @w_trabajador,  
                       @w_cod_kardex,  
                       @w_fecha_kardex,  
                       @w_secuencia ,  
                       NULL,  
                       NULL,  
                       NULL,  
                      NULL,  
                       NULL,  
                       1,  
                       NULL,  
                       NULL,  
                       NULL,  
                       2)  
             END   
  
           SET @w_fecha_kardex = DATEADD(DAY, 1, @w_fecha_kardex)  
  
     END /* WHILE @w_fecha_kardex <= @w_fecha_fin_per_vac */                      
    END   /* IF @w_gen_concepto_ns = 1 */  
  
                  IF @w_gen_concepto_ns = 2     /* incoporación sumarizada */  
                  BEGIN  
                   SET @w_secuencia = 0  
  
                   SELECT @w_secuencia = (ISNULL(MAX(ISNULL(secuencia,0)),0) + 1)   
                   FROM  incidencias_kp  
                   WHERE   compania         = @compania   
     AND trabajador       = @w_trabajador   
     AND incidencia_kp    = @w_cod_kardex    
     AND fecha_incidencia = @w_fecha_ini_per_vac   
  
                   INSERT INTO incidencias_kp   
                   VALUES (@compania,  
                     @w_trabajador,  
                     @w_cod_kardex,  
                     @w_fecha_ini_per_vac,  
                     @w_secuencia ,  
                     NULL,  
                     NULL,  
                     NULL,  
                     NULL,  
                     NULL,  
                     @w_tiempo,  
                     NULL,  
                     NULL,  
                     NULL,  
                     2)  
  
                  END  /* END IF incoporación sumarizada */  
                END /* IF (@w_act_kardex = 1) */  
  
    FETCH cr_trans_vacaciones  
    INTO  @w_concepto, @w_trabajador, @w_tiempo,  
     @w_ciclo_laboral, @w_tipo_ciclo, @w_sec_prog_vac,  
    @w_fecha_ini_per_vac, @w_fecha_fin_per_vac, @w_tipo_mov_vac  
  
  END /* WHILE @@FETCH_STATUS = 0 */  
  
   CLOSE cr_trans_vacaciones   
   DEALLOCATE cr_trans_vacaciones  
  
  EXECUTE sp_cierre_nomina_cv_ns2 @compania, @id_calendario  
  
  /* Ejecuta programas externos */  
  
  DECLARE  cr_programas_externos CURSOR FOR  
  SELECT nombre_programa  
  FROM  programas_foraneos  
  WHERE  compania = @compania  
  AND modulo   = 'CV'  
  AND tipo  = 3  
  ORDER BY prioridad  
  
  OPEN  cr_programas_externos  
  
  FETCH  cr_programas_externos   
  INTO  @w_programa_sus  
  
  WHILE @@FETCH_STATUS = 0   
  BEGIN  
   EXECUTE @w_programa_sus  
    @compania,   
    @id_calendario  
  
   FETCH  cr_programas_externos   
   INTO @w_programa_sus  
  END  
  
  CLOSE cr_programas_externos  
  DEALLOCATE cr_programas_externos  
 END  
 ELSE  
 BEGIN  
  EXECUTE @w_programa_sus  
   @compania,   
   @id_calendario  
 END  
END  