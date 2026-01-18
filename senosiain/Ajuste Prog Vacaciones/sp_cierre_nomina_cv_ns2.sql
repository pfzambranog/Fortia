CREATE Or Alter PROCEDURE dbo.sp_cierre_nomina_cv_ns2  
 @Compania   CHAR(4),   
 @Calendario  SMALLINT  
  
AS   
 DECLARE @trabajador  CHAR(10),  
  @fecha_termino  SMALLDATETIME,  
  @concepto_pago   SMALLINT,  
  @chTipoNomina  CHAR(2),  
  @no_procesa  TINYINT,  
  @tiempo          DECIMAL(8,3),  
  @tipo_mov_vac  INT,  
  @w_error  TINYINT  
  
BEGIN  
     SET @no_procesa = 0  
  
 /* Se obtiene la información de la tabla calendario_procesos */  
  
 SELECT  @chTipoNomina  = tipo_nomina,  
  @fecha_termino = fecha_termino  
 FROM  calendario_procesos  
 WHERE  id_calendario = @Calendario  
  
 IF @@ROWCOUNT = 0  
 BEGIN  
  RAISERROR ('El calendario de procesos no existe [cierre_nomina_cv]', 16, 1) 
  RETURN  
 END  
  
  /* Obtiene el Tipo de movimiento para pago de vacaciones por nómina */  
  
 SET @tipo_mov_vac = dbo.fn_valor_parametros_compania(NULL, @compania, 'cv_vacaciones', 10, GETDATE())  
  
 SELECT  @concepto_pago = concepto_pago  
 FROM  tipos_movimientos_vac  
 WHERE compania     = @compania  
 AND tipo_mov_vac = @tipo_mov_vac  
  
 IF NOT EXISTS(SELECT 1   
  FROM  rel_conc_tipo_nomina  
  WHERE compania     = @compania  
  AND     concepto     = @concepto_pago  
  AND     tipo_nomina  = @chTipoNomina)  
  SET @no_procesa = 1  
 ELSE  
  SET @no_procesa = 0  
  
 IF @@ROWCOUNT = 0  
  SELECT @no_procesa = 1  
  
 IF @no_procesa = 0  
 BEGIN  
  DECLARE cr_transacciones CURSOR FOR  
  SELECT  tr.trabajador,   
   tr.tiempo  
  FROM  transacciones_ns tr  
  WHERE   tr.compania   = @Compania  
  AND  tr.id_calendario = @Calendario  
  AND  tr.concepto   = @concepto_pago  
  ORDER BY tr.referencia DESC  
  
  OPEN  cr_transacciones  
   FETCH  cr_transacciones   
   INTO  @trabajador, @tiempo  
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN  
   IF @tiempo > 0  
   BEGIN  
    EXECUTE sp_calcula_vacaciones  
     @Compania,  
     @trabajador,  
     @tiempo,  
     NULL,  
     6,  
     5,  
     0,  
     @fecha_termino,  
     @tipo_mov_vac,  
     0,  
     @w_error OUTPUT  
   END  
  
   FETCH  cr_transacciones   
    INTO  @trabajador, @tiempo  
  
  END  
  
  CLOSE cr_transacciones   
   DEALLOCATE cr_transacciones   
  END  
END  