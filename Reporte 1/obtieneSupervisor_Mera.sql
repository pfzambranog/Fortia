Create function obtieneSupervisor(  
@idempresa int,@idtrab int)  
returns nvarchar(500)  
as  
Begin  
   
 declare  
 @NomSuper nvarchar(500),  
 @idSuper int  
  
 select @idSuper = rt.CLA_TRAB, @NomSuper = LTRIM(RTRIM(rt.NOM_TRAB)) + ' ' + LTRIM(RTRIM(rt.AP_PATERNO)) + ' ' + LTRIM(RTRIM(rt.AP_MATERNO))  
 from SYS_SEG_TRAB sst inner join RH_TRAB rt on sst.CLA_EMPRESA = rt.CLA_EMPRESA and sst.CLA_TRAB = rt.CLA_TRAB  
 where sst.CLA_EMPRESA = @idempresa  
  And sst.CLA_TRAB = @idtrab  
  And sst.FECHA_ULT_CAMBIO = (select max(FECHA_ULT_CAMBIO) from SYS_SEG_TRAB where CLA_EMPRESA = @idempresa And CLA_TRAB = @idtrab)  
  
 select @NomSuper = convert(varchar,@idSuper) + ', '+ LTRIM(RTRIM(@NomSuper))  
  
 return @NomSuper  
  
End