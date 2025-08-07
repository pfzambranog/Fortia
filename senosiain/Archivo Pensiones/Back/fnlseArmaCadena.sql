Alter function dbo.fnlseArmaCadena    
 (    
  @chCadena  varchar  (3000),  -- Cadena de salida    
  @chDato   varchar (3000),  -- Dato    
  @iPosicion  numeric  (4)  -- Posición del dato    
 )    
returns  varchar (3000)    
    
---------------------------------------------------------------------------------------------      
-- Función:  fnlseArmaCadena    
--       
-- Programó:  Francisco Rodríguez    
--    
-- Objetivo:  Coloca en una cadena el dato proporcionado en la posición    
--     indicada    
--    
-- Fecha de Creación: 5/Dic/2019    
--    
-- Mantenimientos    
--    
-- Autor  Fecha  Objetivo    
--    
--------------------------------------------------------------------------------------------    
    
as    
    
begin    
    
declare @chCadSalida   varchar (3000)    
declare @iLonActual   numeric (4)    
declare @chCadAuxiliar   varchar (3000)    
declare @chDatAuxiliar   varchar (3000)    
    
--    
-- Obtiene la longitud actual de la cadena    
--    
 set @chCadAuxiliar = rtrim (@chCadena)    
 set @chCadAuxiliar = isnull (@chCadAuxiliar, ' ')    
 set @iLonActual = len (@chCadAuxiliar)    
    
--    
-- Revisa el dato y lo convierte en caso de ser nulo    
--    
 set @chDatAuxiliar = rtrim (@chDato)    
 set @chDatAuxiliar = isnull (@chDatAuxiliar, ' ')    
    
--    
-- Anexa el dato en la posición indicada    
--    
 if @iLonActual < @iPosicion    
 begin    
  set @chCadSalida = @chCadAuxiliar + space (@iPosicion - @iLonActual - 1) + @chDatAuxiliar    
 end    
 else    
 begin    
  set @chCadSalida = substring (@chCadAuxiliar, 1, @iPosicion - 1)    
  set @chCadSalida = @chCadSalida + @chDatAuxiliar    
 end    
    
 return (@chCadSalida)    
    
end 
Go
