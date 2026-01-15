 DECLARE @w_id_proceso CHAR(25),  
  @sTabla         CHAR(20),  
     @sComilla       CHAR(1),  
     @sSql           VARCHAR(2000),  
     @iRegreso       INTEGER,
 @sCompania  CHAR(4)     = 'LS',  
 @iIdcalendario  INTEGER = 4849;
BEGIN

    SET @sComilla = Char(39) 
    SET @w_id_proceso = 'CI' + @sCompania + CONVERT(CHAR(5),@iIdcalendario)  
  
     
  /* Cambia el status del periodo (2 -> Cerrado) */  
  
  EXEC sp_actualiza_sit_periodo 'LS', 4849, 2  
  EXEC sp_baja_debug_procesos  @w_id_proceso  
  
END 




