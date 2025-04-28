CREATE procedure splseVacacionesJefeDivision   
(  
@chCompania varchar(15),  
@chDatAgr1 varchar(15),  
@chDatAgr2 varchar(15)  
)  
as  
DECLARE @iNumEntero  INTEGER  
DECLARE @cNumDecimal  DECIMAL (19, 6)  
DECLARE @chAlfanumerico  VARCHAR (250)  
DECLARE @dFecHora  DATETIME  
  
declare @chParAgr1 varchar(30)  
declare @chParAgr2 varchar(30)  
declare @chAgrupacion1 varchar(30)  
declare @chAgrupacion2 varchar(30)  
begin  
---------------------------------------------------------------------------------------------  
---- Procedimiento:  splseVacacionesJefeDivision   
---- Programó: Oscar Flores González  
---- Objetivo: Generar la información para el reporte de vacaciones  
---- Creado:  06/04/2006  
---- Ejemplo de llamada:  
---- exec splseVacacionesJefeDivision 'LS','ALTIA','3'  
---------------------------------------------------------------------------------------------  
---- Modificado por:   
---- Ultima Modificacion:  
---- Motivo:  
---------------------------------------------------------------------------------------------  
  
  
 SET  @chParAgr1 =   'PAR_AGR_VAC_PRINCIPAL'  
 SET  @chParAgr2 =   'PAR_AGR_VAC_SECUNDARIO'  
  
 EXEC splseLeeParametro @chCompania, @chParAgr1,  
     @iNumEntero out,  
     @cNumDecimal out,  
     @chAgrupacion1 out,  
     @dFecHora out  
  
  
  
 EXEC splseLeeParametro @chCompania, @chParAgr2,  
     @iNumEntero out,  
     @cNumDecimal out,  
     @chAgrupacion2 out,  
     @dFecHora out  
  
--  
-- FRA 17-jul-2023  
--  Se permitirá que se propocione sólamente el departamento  
--  
if (@chDatAgr1 = '' OR @chDatAgr1 = ' ' OR @chDatAgr1 IS NULL) AND  
 (@chDatAgr2 <> '' AND @chDatAgr2 <> ' ' AND @chDatAgr2 IS NOT NULL)  
BEGIN  
  
select  tra.trabajador,  
  rtrim (replace (tra.nombre, '/', ' ')) nombre,  
  pla.silla,  
  pla.silla_superior,  
  trg.fecha_ingreso,  
  isnull (  
    (  
     SELECT convert (varchar(10), tr.trabajador) +  
       ' ' +  
       rtrim (replace (tr.nombre, '/', ' '))   as Agr1  
  
     FROM trabajadores tr  
       left outer join plazas pl   
        on pl.trabajador = tr.trabajador   
     WHERE pl.compania =  @chCompania AND  
      pl.silla = pla.silla_superior  
    ), ''  
   )   jefe  
  
 from trabajadores tra  
  left outer join plazas pla  
   on pla.trabajador = tra.trabajador  
  left outer join trabajadores_grales trg  
   on tra.trabajador = trg.trabajador  
  
 where trg.sit_trabajador = 1 and not silla is null  and  
  tra.trabajador in   
   (  
    SELECT rta.trabajador as Agr1  
  
    FROM rel_trab_agr rta  
      left outer join datos_agr_trab dat  
       on rta.agrupacion = dat.agrupacion and  
       rta.dato = dat.dato  
  
    WHERE rta.compania =  @chCompania  AND  
     rta.agrupacion = @chAgrupacion2  AND  
     rta.dato = @chDatAgr2   AND  
     rta.trabajador = tra.trabajador  
   )  
end       
  
if @chDatAgr2 <> ''   
BEGIN  
  
select  tra.trabajador,  
  rtrim (replace (tra.nombre, '/', ' ')) nombre,  
  pla.silla,  
  pla.silla_superior,  
  trg.fecha_ingreso,  
  isnull (  
    (  
     SELECT convert (varchar(10), tr.trabajador) +  
       ' ' +  
       rtrim (replace (tr.nombre, '/', ' '))   as Agr1  
  
     FROM trabajadores tr  
       left outer join plazas pl   
        on pl.trabajador = tr.trabajador   
     WHERE pl.compania =  @chCompania AND  
      pl.silla = pla.silla_superior  
    ), ''  
   )   jefe  
  
 from trabajadores tra  
  left outer join plazas pla  
   on pla.trabajador = tra.trabajador  
  left outer join trabajadores_grales trg  
   on tra.trabajador = trg.trabajador  
  
 where trg.sit_trabajador = 1 and not silla is null  and  
  tra.trabajador in   
   (  
    SELECT rta.trabajador as Agr1  
  
    FROM rel_trab_agr rta  
  
    WHERE rta.compania =  @chCompania  AND  
     rta.agrupacion = @chAgrupacion1  AND  
     rta.dato = @chDatAgr1   AND  
     rta.trabajador = tra.trabajador  
   )      and  
  tra.trabajador in   
   (  
    SELECT rta.trabajador as Agr1  
  
    FROM rel_trab_agr rta  
      left outer join datos_agr_trab dat  
       on rta.agrupacion = dat.agrupacion and  
       rta.dato = dat.dato  
  
    WHERE rta.compania =  @chCompania  AND  
     rta.agrupacion = @chAgrupacion2  AND  
     rta.dato = @chDatAgr2   AND  
     rta.trabajador = tra.trabajador  
   )  
end  
  
else  
begin  
  
  
select tra.trabajador, rtrim(replace(tra.nombre,'/',' ')) nombre  
 , pla.silla, pla.silla_superior, trg.fecha_ingreso  
 , isnull((SELECT convert(varchar(10), tr.trabajador) + ' ' + rtrim(replace(tr.nombre,'/',' '))   as Agr1  
  FROM trabajadores tr  
   left outer join plazas pl   
   on pl.trabajador = tr.trabajador   
  WHERE pl.compania =  @chCompania  
    AND pl.silla = pla.silla_superior),'') jefe, '' Piop  
 from trabajadores tra  
  left outer join plazas pla on pla.trabajador = tra.trabajador  
  left outer join trabajadores_grales trg on tra.trabajador = trg.trabajador  
 where trg.sit_trabajador = 1 and not silla  is null  
  and tra.trabajador in   
   (SELECT rta.trabajador as Agr1  
    FROM rel_trab_agr rta  
    WHERE rta.compania =  @chCompania  
      AND rta.agrupacion = @chAgrupacion1  
      AND rta.dato = @chDatAgr1  
      AND rta.trabajador = tra.trabajador)  
     and silla_superior  
    not in  
  (  
  select  pla.silla   
  from trabajadores tra  
   left outer join plazas pla on pla.trabajador = tra.trabajador  
   left outer join trabajadores_grales trg on tra.trabajador = trg.trabajador  
  where trg.sit_trabajador = 1 and not silla is null  
   and tra.trabajador in   
    (SELECT rta.trabajador as Agr1  
     FROM rel_trab_agr rta  
     WHERE rta.compania =  @chCompania  
       AND rta.agrupacion = @chAgrupacion1  
       AND rta.dato = @chDatAgr1  
       AND rta.trabajador = tra.trabajador)  
  )  
end  
  
end