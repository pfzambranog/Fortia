 CREATE procedure splseLeeParametro  
 ( @chCompania  char (4),  
  @chClaParametro  char (30),  
  @iNumEntero  integer  OUT,  
  @cNumDecimal  decimal (19, 6) OUT,  
  @chAlfanumerico  varchar (250) OUT,  
  @dFecHora  datetime OUT  
 )  
    
  
as  
  
  
Begin  
  
 SET @iNumEntero = NULL  
 SET @cNumDecimal = NULL  
 SET @chAlfanumerico = NULL  
 SET @dFecHora = NULL  
  
 SELECT @iNumEntero = isnull(num_entero, 0), @cNumDecimal = isnull(num_decimal,0),  
   @chAlfanumerico = isnull(alfanumerico,''), @dFecHora = fecha_hora  
  FROM lse_par_adaptaciones  
  WHERE compania = @chCompania  AND  
   cla_parametro = @chClaParametro  
  
 if not exists(SELECT *  
   FROM lse_par_adaptaciones  
   WHERE compania = @chCompania AND  
   cla_parametro = @chClaParametro)  
 begin  
  declare @errDescrip varchar(200)  
  set @errDescrip = 'No se encontró el parámetro ' + rtrim(@chClaParametro) + ' de la Compania ' +  @chCompania  
  raiserror(@errDescrip,16,1)  
 end  
end  
  
  
  