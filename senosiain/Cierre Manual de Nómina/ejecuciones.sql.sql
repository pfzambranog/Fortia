		SELECT 	sit_proceso = sit_proceso
		FROM 	control_cierre_ns
		WHERE 	compania      ='LS'
		AND	id_calendario = 5150
		AND	cve_proceso   = 5
        
        
        EXEC  sp_rest_resp_cierre 'LS', 5150, 5
        
        EXEC  sp_cierre_nomina_cv_ns  'LS', 5150
        
        EXEC  sp_elimina_resp_cierre 'LS', 5150, 5  
        EXEC sp_alta_debug_procesos 'CILS 5150', 'Termino el cierre de Control de Vacaciones', 1, 'sp_cierre_nomina'  
        
        
		SELECT 	sit_proceso = sit_proceso
		FROM 	control_cierre_ns
		WHERE 	compania      ='LS'
		AND	id_calendario = 5150 
        AND cve_proceso   = 7  
        Resultado Null
        
        EXEC  sp_alta_debug_procesos 'CILS 5150', 'Inicia actualizacion de historial laboral.', 1, 'sp_cierre_nomina' 
        
        EXEC  sp_resp_cierre 'LS', 5150, 7
        
        EXEC  sp_cierre_HL_ns 'LS', 5150
        
        EXEC  sp_elimina_resp_cierre 'LS', 5150, 7
        
        EXEC  sp_alta_debug_procesos 'CILS 5150', 'Termino la actualizacion de historial laboral.', 1, 'sp_cierre_nomina'
        
         SELECT nombre_programa  
         FROM  programas_foraneos  
         WHERE  compania = 'LS'
         AND modulo   = 'NS'  
         AND tipo  = 3  
         ORDER BY prioridad 
         
         EXEC sp_alta_debug_procesos 'CILS 5150', 'Borra la transacciones de la compania e id_calendario ', 1, 'sp_cierre_nomina'
         
         Select count(1)
         From   trans_LS_5150
         858
         
         Select count(1)
         From   transacciones_ns   
         WHERE  compania = 'LS'   
         AND  id_calendario = 5150
         858
         
BEGIN TRANSACTION;

DELETE FROM transacciones_ns
WHERE compania = 'LS'
AND id_calendario = 5150;

IF (XACT_STATE()) = 0
BEGIN
    ROLLBACK TRANSACTION;
    SELECT 'Errores en Borrado - Rollback' AS Result;
END;

IF (XACT_STATE()) = 1
BEGIN
    COMMIT TRANSACTION;
    SELECT 'Borrado Ok' AS Result;
END;

IF (XACT_STATE()) = -1
BEGIN
    PRINT N'The transaction is in an uncommittable state.' +
          N' Rolling back transaction.'
    ROLLBACK TRANSACTION;
	SELECT 'Errores Graves en Borrado - Rollback' AS Result;
END;

         
 DELETE  control_cierre_ns   
         WHERE  compania = 'LS'   
         AND  id_calendario = 5150
     
       EXEC sp_actualiza_sit_periodo 'LS', 5150, 2  
  EXEC sp_baja_debug_procesos  'CILS 5150'
    EXEC sp_baja_debug_procesos  'CILS  5150'