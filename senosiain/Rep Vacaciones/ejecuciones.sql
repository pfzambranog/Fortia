exec splseObtActTraMovex 

exec splseAltaParAdaptaciones @chCompania=N'LS  ',@iIdModulo=17,@chClaParametro=N'LCL76_Color4',@chDescripcion=N'Color4 del usuario LCL76',@iNumEntero=0,@cNumDecimal=0,@chAlfanumerico=N'0~0~0',@dFecHora='1900-01-01 00:00:00',@chTipo=N'Alfanumerico',@chQuery=N'',@chControl=N'',@chCamValor=N'',@chCamTexto=N''


exec splseVacacionesJefeDivision @chCompania=N'LS  ',@chDatAgr1=N'1         ',@chDatAgr2=N''



exec splseSelDeptoArea @chCompania=N'LS  ',@chClaveAgr=N'PAR_CV_AGR_AREA',@chClaveAgr2=N'PAR_CV_AGR_DEP',@chClaveDato=N'4'   

exec splseSelDeptoArea @chCompania=N'LS  ',@chClaveAgr=N'PAR_CV_AGR_AREA',@chClaveAgr2=N'PAR_CV_AGR_DEP',@chClaveDato=N'4 ' 


exec splse_obten_arbol @padre=1401,@tipo=0,@nivel_tope=0,@agrupacion=N'',@niv_jerarquico=0}


SELECT max(dat.descripcion) as Agr1   FROM rel_trab_agr rta    left outer join datos_agr_trab dat  on rta.agrupacion = dat.agrupacion and rta.dato = dat.dato   WHERE rta.compania =  'LS  '   AND rta.agrupacion = 'ZON'   AND rta.trabajador = '     19942'

SELECT max(dat.descripcion) as Agr1   FROM rel_trab_agr rta    left outer join datos_agr_trab dat  on rta.agrupacion = dat.agrupacion and rta.dato = dat.dato   WHERE rta.compania =  'LS  '   AND rta.agrupacion = 'ZON'   AND rta.trabajador = '     21290'