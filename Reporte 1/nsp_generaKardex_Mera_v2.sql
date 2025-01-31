
Create Or Alter Procedure dbo.nsp_generaKardex_Mera_v2
  (@idempresa       Integer,  
   @idtrabajador    Integer,  
   @idanio          Integer)  
As
Declare
   @concatenaFaltas  nvarchar(max) = ''  

Begin  
  
 select @concatenaFaltas = coalesce(@concatenaFaltas,'')+convert(varchar,CLA_FALTA)  
 +': '+LTRIM(RTRIM(NOM_FALTA))+CHAR(9)  
 from RH_FALTA  where CLA_EMPRESA = @idempresa
  
 select @concatenaFaltas = LTRIM(RTRIM(@concatenaFaltas)) + 'V: V, Vacaciones'  
  
 declare @meses table(id Integer identity, mes Integer, nommes varchar(100))  
  
 insert into @meses  
 select 1,'Enero' union select 2,'Febrero' union select 3,'Marzo' union select 4,'Abril' union select 5,'Mayo' union select 6,'Junio' union   
 select 7,'Julio' union select 8,'Agosto' union select 9,'Septiembre' union select 10,'Octubre' union select 11,'Noviembre' union select 12,'Diciembre'   
  
 declare @Asistecia table(Idempresa Integer,  
 Idtrabajador Integer,  
 IdMes Integer,  
 Nombremes varchar(100),  
 Nomrazosoci varchar(MAX),  
 Nomtrab varchar(MAX),  
 Foto varbinary(MAX),  
 Fechaalta smalldatetime,  
 Fechabaja smalldatetime,  
 Nomdepto varchar(MAX),  
 Nompuesto varchar(MAX),  
 Turnoo varchar(MAX),  
 Tipo Integer,  
 Clase Integer,  
 Faltadia1 varchar(8),  
 Faltadia2 varchar(8),  
 Faltadia3 varchar(8),  
 Faltadia4 varchar(8),  
 Faltadia5 varchar(8),  
 Faltadia6 varchar(8),  
 Faltadia7 varchar(8),  
 Faltadia8 varchar(8),  
 Faltadia9 varchar(8),  
 Faltadia10 varchar(8),  
 Faltadia11 varchar(8),  
 Faltadia12 varchar(8),  
 Faltadia13 varchar(8),  
 Faltadia14 varchar(8),  
 Faltadia15 varchar(8),  
 Faltadia16 varchar(8),  
 Faltadia17 varchar(8),  
 Faltadia18 varchar(8),  
 Faltadia19 varchar(8),  
 Faltadia20 varchar(8),  
 Faltadia21 varchar(8),  
 Faltadia22 varchar(8),  
 Faltadia23 varchar(8),  
 Faltadia24 varchar(8),  
 Faltadia25 varchar(8),  
 Faltadia26 varchar(8),  
 Faltadia27 varchar(8),  
 Faltadia28 varchar(8),  
 Faltadia29 varchar(8),  
 Faltadia30 varchar(8),  
 Faltadia31 varchar(8))  
  
 insert into @Asistecia(Idempresa,Idtrabajador,IdMes,Nombremes,Nomrazosoci,Nomtrab,  
 Fechaalta,Fechabaja,Nomdepto,Nompuesto,  
 Turnoo,Tipo,Clase,Foto  
 )  
 select rt.CLA_EMPRESA, rt.CLA_TRAB, m.mes,m.nommes,rrs.NOM_RAZON_SOCIAL,LTRIM(RTRIM(AP_PATERNO))+','+LTRIM(RTRIM(AP_MATERNO))+','+LTRIM(RTRIM(NOM_TRAB)),  
 rt.FECHA_ING,rt.FECHA_BAJA,convert(varchar,rd.CLA_DEPTO)+', '+rd.NOM_DEPTO,convert(varchar,rp.CLA_PUESTO)+', '+rp.NOM_PUESTO,  
 convert(nvarchar,rt.CLA_ROLL)+', '+LTRIM(RTRIM(rpt.NOM_PERFIL_TURNO)),rt.CLA_ROLL,rt.CLA_CLASIFICACION,rt.FOTOGRAFIA  
 from RH_TRAB rt,@meses m,RH_RAZON_SOCIAL rrs,RH_DEPTO rd,RH_PUESTO rp, RELOJ_PERFIL_TURNO rpt  
 where rt.CLA_EMPRESA = @idempresa and (rt.CLA_TRAB = @idtrabajador or @idtrabajador = 0) And DATEPART(YEAR,ISNULL(FECHA_ING_GRUPO,FECHA_ING))<=@idanio  
 And (rt.FECHA_BAJA is null or DATEPART(YEAR,FECHA_BAJA)=@idanio)  
 and rt.CLA_EMPRESA = rrs.CLA_EMPRESA and rt.CLA_RAZON_SOCIAL = rrs.CLA_RAZON_SOCIAL  
 and rt.CLA_EMPRESA = rd.CLA_EMPRESA and rt.CLA_DEPTO = rd.CLA_DEPTO  
 and rt.CLA_EMPRESA = rp.CLA_EMPRESA and rt.CLA_PUESTO = rp.CLA_PUESTO  
 and rt.CLA_EMPRESA = rpt.CLA_EMPRESA and rt.CLA_ROLL = rpt.CLA_PERFIL_TURNO  
  
 update @Asistecia  
 set Faltadia1 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,1),  
 Faltadia2 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,2),  
 Faltadia3 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,3),  
 Faltadia4 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,4),  
 Faltadia5 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,5),  
 Faltadia6 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,6),  
 Faltadia7 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,7),  
 Faltadia8 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,8),  
 Faltadia9 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,9),  
 Faltadia10 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,10),  
 Faltadia11 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,11),  
 Faltadia12 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,12),  
 Faltadia13 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,13),  
 Faltadia14 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,14),  
 Faltadia15 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,15),  
 Faltadia16 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,16),  
 Faltadia17 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,17),  
 Faltadia18 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,18),  
 Faltadia19 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,19),  
 Faltadia20 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,20),  
 Faltadia21 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,21),  
 Faltadia22 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,22),  
 Faltadia23 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,23),  
 Faltadia24 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,24),  
 Faltadia25 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,25),  
 Faltadia26 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,26),  
 Faltadia27 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,27),  
 Faltadia28 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,28),  
 Faltadia29 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,29),  
 Faltadia30 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,30),  
 Faltadia31 = dbo.obtieneclavefalta(Idempresa,Idtrabajador,@idanio,IdMes,31)  
  
 select *, GETDATE()FechaEmision,'Kardex Anual '+ convert(varchar,@idanio) TituloKar,@concatenaFaltas detfal, dbo.obtieneSupervisor(IdEmpresa,IdTrabajador) as NomSuperv from @Asistecia  
 Order by Idempresa,Idtrabajador,IdMes  
  
End