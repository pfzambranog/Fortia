Drop function obtieneclavefalta
Go
Create function obtieneclavefalta(
@idempresa int,@idtrab int,@anio int,@mes int,@dia int)
returns varchar(8)
as
Begin
	
	declare
	@idFalta varchar(8),
	@fechcons smalldatetime

	if ISDATE(convert(varchar,@anio)+replace(str(@mes,2),' ','0')+replace(str(@dia,2),' ','0')) = 1
	select @fechcons= convert(smalldatetime,convert(varchar,@anio)+replace(str(@mes,2),' ','0')+replace(str(@dia,2),' ','0'))

	if @fechcons is not null
		Select @idFalta = CLA_FALTA from RH_DET_FALTA
		where CLA_EMPRESA = @idempresa and CLA_TRAB = @idtrab and ( @fechcons between FECHA_INICIO And FECHA_FIN)

	if @fechcons is not null And @idFalta is null
		Select @idFalta = 'V' 
		from RH_DET_VACACION
		where CLA_EMPRESA = @idempresa and CLA_TRAB = @idtrab and ( @fechcons between FECHA_INICIO And FECHA_FIN)

	return @idFalta

End