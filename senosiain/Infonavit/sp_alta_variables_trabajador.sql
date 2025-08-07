CREATE PROCEDURE [dbo].[sp_alta_variables_trabajador]  
 @compania       CHAR(4)     = ' ',  
 @trabajador       CHAR(10)     = ' ',  
 @secuencia       SMALLINT      = NULL,  
 @variable_trabajador DECIMAL(19,6) = 0  
  
AS  
BEGIN  
 IF @secuencia IS NULL  
        SELECT  @secuencia = ISNULL(MAX(secuencia), 0) + 1  
        FROM  variables_trabajador  
        WHERE  compania   = @compania  
         AND  trabajador = @trabajador  
     
    IF EXISTS (SELECT 1   
     FROM  variables_trabajador  
     WHERE  compania   = @compania  
         AND  trabajador = @trabajador  
   AND  secuencia  = @secuencia)  
  BEGIN    
    Select 2120003, 'Error al insertar registro duplicado en la tabla [variables_trabajador]'  
    RETURN 1    
  END  
  
 INSERT variables_trabajador(  
  compania,  
  trabajador,  
  secuencia,  
  variable_trabajador)  
 VALUES (@compania,  
  @trabajador,  
  @secuencia,  
  @variable_trabajador)  
  
END  