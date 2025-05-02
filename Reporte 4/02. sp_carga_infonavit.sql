if exists (select 1 from sysobjects where name = 'sp_carga_infonavit' and type = 'P')
begin
	drop procedure sp_carga_infonavit
end
go
CREATE procedure sp_carga_infonavit
(
 @cla_empresa	INT	,
 @Cla_usuario	INT	,
 @nom_archivo	VARCHAR(MAX)-- Nombre de Archivo
)

AS
BEGIN

 declare @infonavit as table
 (CLA_EMPRESA	VARCHAR(MAX)	,
 CLA_TRAB		int				,
 NSS			VARCHAR(MAX)	,
 BIM_ANIO		VARCHAR(MAX)	,
 CREDITO		VARCHAR(MAX)	,
 NOM_TRAB		VARCHAR(MAX)	,
 SDI			VARCHAR(MAX)	,
 TIPO_CRED		VARCHAR(MAX)	,
 VALOR_DES		VARCHAR(MAX)	,
 AMORT			VARCHAR(MAX)	,
 ALTA			VARCHAR(MAX)	,
 INICIO_CRED	VARCHAR(MAX)	,
 CRED_SUSP		VARCHAR(MAX)	,
 FECHA_BAJA		VARCHAR(MAX)	,
 EMISION		float			,
 DIFERENCIA		float			,
 OBSERVACION	VARCHAR(MAX)
 
 )

 declare @info_nom as table
 (CLA_EMPRESA	int	,
 CLA_TRAB		int	,
 IMPORTE		float	,
 BIMESTRE		INT
 )

 DECLARE
 @emision		float	,
 @diferencia	float	,
 @obser			varchar(max)


 --Columnas que se enviarán desde el excel
 INSERT INTO @infonavit
 (CLA_EMPRESA	,
 CLA_TRAB		,
 NSS			,
 BIM_ANIO		,
 CREDITO		,
 NOM_TRAB		,
 SDI			,
 TIPO_CRED		,
 VALOR_DES		,
 AMORT			,
 ALTA			,
 INICIO_CRED	,
 CRED_SUSP		,
 FECHA_BAJA		,
 EMISION		,
 DIFERENCIA		)
SELECT
@cla_empresa	,	--CLA_EMPRESA
0				,	--CLA_TRAB
filas.columna001,	--NSS
filas.columna002,	--BIM_ANIO
filas.columna003,	--CREDITO
filas.columna004,	--NOM_TRAB
filas.columna005,	--SDI
filas.columna006,	--TIPO_CRED
filas.columna007,	--VALOR_DES
filas.columna008,	--SEG_VIV
filas.columna009,	--ALTA
filas.columna010,	--INICIO_CRED
filas.columna011,	--CRED_SUSP
filas.columna012,	--FECHA_BAJA
0				,	--EMISION, CERO PORVISIONAL
0					--DIFERENCIA, CERO PORVISIONAL
from dbo.fn_ObtenerTablaDeTextoCSV(rtrim(ltrim(ISNULL(@nom_archivo,''))), ',', 1) as filas--TABULADOR


 --validaciones para valores requeridos  
   update @infonavit
   set OBSERVACION = ISNULL(OBSERVACION, '') +    
   case   
	  when ISNULL(NSS, '')			= '' then 'NSS es requerido. | '
	  when ISNULL(BIM_ANIO,'')		= '' then 'Bimeste-anio es requerido. | '
	  when ISNULL(CREDITO, '')		= '' then 'Numero de credito es requerido. | '
	  when ISNULL(NOM_TRAB, '')		= '' then 'Nombre de colaborador es requerido. | '
	  when ISNULL(SDI, '')			= '' then 'SDI es requerido. | '
	  when ISNULL(TIPO_CRED, '')	= '' then 'Tipo de credito es requerido. | '
	  when ISNULL(VALOR_DES, '')	= '' then 'Valor a descontar es requerido. | '
	  when ISNULL(AMORT, '')		= '' then 'Amort. y seg. viv es requerido. | '
	  when ISNULL(ALTA,'')			= '' then 'Fecha de alta es requerida. | '
	  when ISNULL(INICIO_CRED, '')	= '' then 'Inicio de credito es requerido. | '

  end  

--Tomar el nombre del colaborador en RH_TRAB
-- Si el nombre no existe indicar: “El colaborador no existe”

 update	T1
 set	OBSERVACION = isnull(OBSERVACION,'') + 'El colaborador no existe| ' 
 from	@infonavit T1
 where	not exists (select	CONCAT(LTRIM(RTRIM(AP_PATERNO)), ' ', LTRIM(RTRIM(AP_MATERNO))
					 , ' ', LTRIM(RTRIM(NOM_TRAB)))
					from	RH_TRAB T2
					where	T2.CLA_EMPRESA	= T1.CLA_EMPRESA
					and		T2.CRED_INF		= T1.CREDITO)
 and T1.CLA_EMPRESA = @cla_empresa
 
--Tomar el credito existe en RH_TRAB
-- Si no existe indicar: “El credito no existe”

 update	T1
 set	OBSERVACION = isnull(OBSERVACION,'') + 'El credito no existe| '
 from	@infonavit T1
 where	not exists (select	CRED_INF
					from	RH_TRAB T2
					where	T2.CLA_EMPRESA	= T1.CLA_EMPRESA
					and		T2.CRED_INF		= T1.CREDITO
					and		T2.NUM_IMSS		= T1.NSS)
 and T1.CLA_EMPRESA = @cla_empresa
 
 
--Tomar el NSS existe en RH_TRAB
-- Si no existe indicar: “El NSS no existe”
 update	T1
 set	OBSERVACION = isnull(OBSERVACION,'') + 'El NSS no existe| '
 from	@infonavit T1
 where	not exists (select	NUM_IMSS
					from	RH_TRAB T2
					where	T2.CLA_EMPRESA	= T1.CLA_EMPRESA
					--and		T2.CRED_INF		= T1.CREDITO
					and		T2.NUM_IMSS		= T1.NSS)
 and T1.CLA_EMPRESA = @cla_empresa
 

 --El registro esta duplicado en el archivo
 update	T1
 set	OBSERVACION = isnull(OBSERVACION,'') + 'El registro esta duplicado en el archivo| '
 from	@infonavit T1
 where	exists ( select	1 
				 from	@infonavit T2
				 where	T2.CLA_EMPRESA	= T1.CLA_EMPRESA
				 and	T2.INICIO_CRED	= T1.INICIO_CRED
				 and	T2.CREDITO		= T1.CREDITO
				 and	T2.NOM_TRAB		= T1.NOM_TRAB
				 and	T2.SDI			= T1.SDI
				 and	T2.AMORT		= T1.AMORT
				 group by T2.CREDITO--, T2.CLA_TRAB  
				 having count (*) > 1) 
 
  --Tomar la clave del colaborador
 update	T1
 set	T1.CLA_TRAB		= T2.CLA_TRAB
 from	@infonavit T1
 join   RH_TRAB  T2
 on		T1.CLA_EMPRESA	= T2.CLA_EMPRESA
 and	T1.CREDITO		= T2.CRED_INF
 and	T1.NSS			= T2.NUM_IMSS
 where  T1.CLA_EMPRESA	= @cla_empresa




 insert into @info_nom 
 (CLA_EMPRESA	,
 CLA_TRAB		
 ,IMPORTE		,
 BIMESTRE
 )
 select	T1.CLA_EMPRESA, T1.CLA_TRAB, IMPORTE, ((right(ANIO_MES,2)-1) / 2) +1
 from	RH_DET_REC_HISTO T1
 join   @infonavit T2
 on		T1.CLA_EMPRESA	= T2.CLA_EMPRESA
 and	T1.CLA_TRAB		= T2.CLA_TRAB
 and	CLA_PERDED		= 3116 -- clave de concepto de paso
 and	T1.NUM_NOMINA/1000%100 = 10
 and	((right(ANIO_MES,2)-1) / 2) +1	= ((left(BIM_ANIO,2)-1) / 2) +1
 group by IMPORTE, ANIO_MES,t1.CLA_TRAB,t1.CLA_EMPRESA



 update T1
 set	T1.EMISION		=  IMPORTE
 from	@infonavit T1
 inner join @info_nom T2
 on		T1.CLA_EMPRESA	= T2.CLA_EMPRESA 
 and	T1.CLA_TRAB		= T2.CLA_TRAB 
 and	((left(T1.BIM_ANIO,2)-1) / 2) +1 = T2.BIMESTRE

 update T1
 set	T1.DIFERENCIA	=  EMISION - convert(float(2),replace(AMORT, ',', ''))
 from	@infonavit T1



 update @infonavit set OBSERVACION = '' where OBSERVACION is null or OBSERVACION = ''
 

 select
 NSS			as 'N.S.S',
 BIM_ANIO		as 'Bim/Año' ,
 CREDITO		as 'Crédito' ,
 NOM_TRAB		as 'N O M B R E' ,
 SDI			as 'SDI' ,
 TIPO_CRED		as '% o $ o FD' ,
 VALOR_DES		as 'Valor Desc.' ,
 AMORT			as 'Amort. y Seg. Viv' ,
 ALTA			as 'Fecha Alta' ,
 INICIO_CRED	as 'I.C.V' ,
 CRED_SUSP		as 'Susp. Cred.' ,
 FECHA_BAJA		as 'Fecha Baja' ,
 EMISION		as 'EMISION' ,
 DIFERENCIA		as 'DIF' ,
 OBSERVACION	as 'Observaciones'
 from			@infonavit
 order by		NSS asc
 
 --select 
 --CLA_EMPRESA	as 'emp',
 --CLA_TRAB		as 'trab',
 --IMPORTE		as 'imp',
 --BIMESTRE		AS 'ANIO_MES'
 --from @info_nom

END -- Fin del Proceso



