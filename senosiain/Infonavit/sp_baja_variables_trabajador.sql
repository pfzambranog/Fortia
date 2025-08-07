CREATE PROCEDURE [dbo].[sp_baja_variables_trabajador]  
   @compania   CHAR(4)  = ' ',  
   @trabajador CHAR(10) = ' ',  
   @secuencia  SMALLINT = 0  
AS  
/*************************************************************/   
/* Autor:       NS                                     */    
/* Fecha:       15/May/1998                            */  
/* Proyecto      N¾mina                              */   
/*************************************************************/   
BEGIN  
  
   DELETE variables_trabajador  
   WHERE  compania   = @compania   AND  
          trabajador = @trabajador AND  
          secuencia  = @secuencia  
  
 
END  