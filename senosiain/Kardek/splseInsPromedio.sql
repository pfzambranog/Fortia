Alter Procedure splseInsPromedio
 @chCompania   Char  (4),
 @chAgrDivision  Char  (10),
 @chDivision   Char  (10),  -- Si biene en blanco entonces se busca por el parametro de trabajador
 @chTrabajador  CHAR  (10),  -- Si biene en blanco entonces se procesan todos los trabajadores
 @iAnio   Int,
 @iMes    Int,
 @iMesAtras   Int,
 @iSitTrabajadores Int,    -- 1 - Activos  | 2 - Bajas
 @iOrden   Int,    -- 1 - Alfanumérico  | 2 - Númerico
 @iIncOtros   INT,    -- 0 - NO Incluir Otras Percepciones | 1 - SI incluir otras percepciones
         --  Este parametro solo aplica para la opcion por trabajador
 @chCompaniaName   varchar (250),
 @chMonthName  varchar (10),
 @iActVariable  TINYINT,   -- 0 No actualizar, 1 Si Actualizar
 @iProTodosMeses  TINYINT   -- 0 Promediar sólo los meses con información
         -- 1 Promediar todos los meses solicitados
AS

--
-- FRA 2016-05-03 Se ajustó la funcionalidad para que en el caso de que el reporte se solicite a nivel de
--    trabajador y se solicite que se promedie con base en todos los meses, el promedio de
--    "Otras percepciones" el cálculo se realice con estas reglas independientemente de los
--    meses que contengan información.
--
 ---------------------------------------------------------------------------------------------
 ---- Modificado por:       Pedro Zambrano.
 ---- Ultima Modificacion:  05-Sep-2025
 ---- Motivo:               Ajuste de valor de comisión (Linea 565).
 ---------------------------------------------------------------------------------------------

Begin


DECLARE @chParAgrConSueldo Char  (30)
DECLARE @chParAgrConComisiones Char  (30)
DECLARE @chParAgrConPremios Char  (30)
DECLARE @chParAgrConOtros Char  (30)
DECLARE @chAgrConSueldo  Char  (3)
DECLARE @chAgrConComisiones Char  (3)
DECLARE @chAgrConPremios  Char  (3)
DECLARE @chAgrConOtros  Char  (3)

DECLARE @chParAgrTraZona  Char  (30)
DECLARE @chParAgrTraRegion Char  (30)
DECLARE @chParAgrTraDepartamento Char (30)

DECLARE @chParVarTraComision Char  (30)
DECLARE @iVarTraComision  SMALLINT

DECLARE @chParVarTraProComision Char  (30)
DECLARE @iVarTraPorComision SMALLINT

DECLARE @chAgrTraZona  Char  (10)
DECLARE @chAgrTraRegion  Char  (10)
DECLARE @chAgrTraDepartamento Char  (10)

DECLARE @iEntero   INT
DECLARE @cDecimal   DECIMAL (19, 6)
DECLARE @dFecha   DATETIME
DECLARE @chAlfanumerico  VARCHAR (250)

DECLARE @chColumnas   VARCHAR (500)
DECLARE @chColAnterior  VARCHAR (500)
DECLARE @chColActual  VARCHAR (500)
DECLARE @chColSalida  VARCHAR (500)
DECLARE @chTablas   VARCHAR (100)
DECLARE @chWhere   VARCHAR (300)
DECLARE @iMesColumna  SMALLINT
DECLARE @iMesInicial  SMALLINT
DECLARE @chMesColumna  CHAR  (2)
DECLARE @iConMeses   SMALLINT
DECLARE @chPrefijo   CHAR  (5)
DECLARE @chColumna   VARCHAR (20)
DECLARE @chQuery   VARCHAR (1000)

DECLARE @iAniAnterior  INT


DECLARE @nombre_cia   Char  (60)
DECLARE @descripcion1  Char  (40)
DECLARE @descripcion2  Char  (40)
DECLARE @clase_nomina  VarChar (2)
DECLARE @trabajador   Char  (10)
DECLARE @nombre   Char  (100)
DECLARE @fecha_ingreso  Char  (10)
DECLARE @dato    VarChar (10)
DECLARE @agr_conceptos  Char  (3)
DECLARE @zona    Numeric (9, 0)
DECLARE @region   Numeric (9, 0)
DECLARE @campa   Numeric (9, 2)
DECLARE @plaza   Char  (4)

DECLARE @iAni01   INT
DECLARE @iAni02   INT
DECLARE @iAni03   INT
DECLARE @iAni04   INT
DECLARE @iAni05   INT
DECLARE @iAni06   INT
DECLARE @iAni07   INT
DECLARE @iAni08   INT
DECLARE @iAni09   INT
DECLARE @iAni10   INT
DECLARE @iAni11   INT
DECLARE @iAni12   INT

DECLARE @iFinCursor   TINYINT
DECLARE @cImp_01   DECIMAL (19, 6)
DECLARE @cImp_02   DECIMAL (19, 6)
DECLARE @cImp_03   DECIMAL (19, 6)
DECLARE @cImp_04   DECIMAL (19, 6)
DECLARE @cImp_05   DECIMAL (19, 6)
DECLARE @cImp_06   DECIMAL (19, 6)
DECLARE @cImp_07   DECIMAL (19, 6)
DECLARE @cImp_08   DECIMAL (19, 6)
DECLARE @cImp_09   DECIMAL (19, 6)
DECLARE @cImp_10   DECIMAL (19, 6)
DECLARE @cImp_11   DECIMAL (19, 6)
DECLARE @cImp_12   DECIMAL (19, 6)

DECLARE @iNumMeses   SMALLINT


SET @chParAgrConSueldo  = 'PAR_PCP_AGR_CON_SUELDO'
SET @chParAgrConComisiones = 'PAR_PCP_AGR_CON_COMISIONES'
SET @chParAgrConPremios = 'PAR_PCP_AGR_CON_PREMIOS'
SET @chParAgrConOtros  = 'PAR_PCP_AGR_CON_OTROS'

SET @chParAgrTraZona   = 'PAR_PCP_AGR_TRA_ZONA'
SET @chParAgrTraRegion = 'PAR_PCP_AGR_TRA_REG'
SET @chParAgrTraDepartamento = 'PAR_PCP_AGR_TRA_DEP'

SET @chParVarTraComision = 'PAR_PCP_VAR_TRA_COM'
SET @chParVarTraProComision = 'PAR_PCP_VAR_TRA_POR_COM'


--  Obteniendo las agrupaciones de conceptos de acuerdo a los parametros
--
EXEC splseLeeParametro  @chCompania, @chParAgrConSueldo,  @iEntero OUT,
     @cDecimal OUT, @chAgrConSueldo OUT,  @dFecha OUT

EXEC splseLeeParametro  @chCompania, @chParAgrConComisiones,  @iEntero OUT,
     @cDecimal OUT, @chAgrConComisiones OUT, @dFecha OUT

EXEC splseLeeParametro  @chCompania, @chParAgrConPremios,  @iEntero OUT,
     @cDecimal OUT, @chAgrConPremios OUT,  @dFecha OUT

EXEC splseLeeParametro  @chCompania, @chParAgrConOtros,  @iEntero OUT,
     @cDecimal OUT, @chAgrConOtros OUT,  @dFecha OUT


EXEC splseLeeParametro  @chCompania, @chParAgrTraZona,   @iEntero OUT,
     @cDecimal OUT, @chAgrTraZona OUT,  @dFecha OUT

EXEC splseLeeParametro  @chCompania, @chParAgrTraRegion,  @iEntero OUT,
     @cDecimal OUT, @chAgrTraRegion OUT,  @dFecha OUT

EXEC splseLeeParametro  @chCompania, @chParAgrTraDepartamento, @iEntero OUT,
     @cDecimal OUT, @chAgrTraDepartamento OUT, @dFecha OUT

EXEC splseLeeParametro  @chCompania, @chParVarTraComision,  @iVarTraComision OUT,
     @cDecimal OUT, @chAlfanumerico OUT,  @dFecha OUT

EXEC splseLeeParametro  @chCompania, @chParVarTraProComision, @iVarTraPorComision OUT,
     @cDecimal OUT, @chAlfanumerico OUT,  @dFecha OUT


--  Se crea la tabla de paso que almacena la informacion del reporte
--
CREATE TABLE #lsePromedio (
 compania  CHAR  (4)  NOT NULL,
 anio   INT    NOT NULL,
 clase_nomina  CHAR  (2)  NOT NULL,
 division  CHAR  (10)  NULL,
 des_division  VARCHAR (40)  NULL,
 trabajador  CHAR  (10)  NOT NULL,
 nombre   CHAR  (100)  NOT NULL,
 comision  DECIMAL (9, 3) NULL,
 fecha_ingreso  DATETIME   NOT NULL,
 agr_conceptos  CHAR  (3)  NULL,
 des_agr_conceptos CHAR  (40)  NULL,
 ord_agr_conceptos SMALLINT   NULL,
 imp_01   DECIMAL (18, 2) NULL,
 imp_02   DECIMAL (18, 2) NULL,
 imp_03   DECIMAL (18, 2) NULL,
 imp_04   DECIMAL (18, 2) NULL,
 imp_05   DECIMAL (18, 2) NULL,
 imp_06   DECIMAL (18, 2) NULL,
 imp_07   DECIMAL (18, 2) NULL,
 imp_08   DECIMAL (18, 2) NULL,
 imp_09   DECIMAL (18, 2) NULL,
 imp_10   DECIMAL (18, 2) NULL,
 imp_11   DECIMAL (18, 2) NULL,
 imp_12   DECIMAL (18, 2) NULL,
 total   DECIMAL (18, 2) NULL,
 tot_mensual  DECIMAL (18, 2) NULL,
 tot_diario  DECIMAL (18, 2) NULL
)

--
--  Se crea la tabla de de salida
--
CREATE TABLE #lseSalida (
 compania  CHAR  (4)  NOT NULL,
 anio   INT    NOT NULL,
 clase_nomina  CHAR  (2)  NOT NULL,
 division  CHAR  (10)  NULL,
 des_division  VARCHAR (40)  NULL,
 zona   CHAR  (10)  NULL,
 region   CHAR  (10)  NULL,
 departamento  CHAR  (10)  NULL,
 puesto   CHAR  (4)  NULL,
 trabajador  CHAR  (10)  NOT NULL,
 nombre   CHAR  (100)  NOT NULL,
 comision              DECIMAL (9, 3) NULL,
 fecha_ingreso         DATETIME   NOT NULL,
 fec_pue_porcentaje    CHAR  (10)  NULL,
 agr_conceptos         CHAR  (3)  NULL,
 des_agr_conceptos CHAR  (40)  NULL,
 ord_agr_conceptos SMALLINT   NULL,
 imp_01   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_02   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_03   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_04   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_05   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_06   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_07   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_08   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_09   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_10   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_11   DECIMAL (18, 2) NULL DEFAULT 0,
 imp_12   DECIMAL (18, 2) NULL DEFAULT 0,
 num_mes_importe  SMALLINT   NULL DEFAULT 0,
 total        DECIMAL (18, 2) NULL DEFAULT 0,
 tot_mensual  DECIMAL (18, 2) NULL DEFAULT 0,
 tot_diario   DECIMAL (18, 2) NULL DEFAULT 0,
 orden        CHAR  (100)
)


-- Obtiene la informacion de acumulados para las agrupaciones que forman el reporte
--  SUELDOS, COMISIONES, PREMIOS, OTROS INGRESOS
--
IF @iMesAtras > @iMes
 SET @iAniAnterior = @iAnio - 1
ELSE
 SET @iAniAnterior = @iAnio

IF @chTrabajador = '' OR @chTrabajador IS NULL
BEGIN
 INSERT INTO  #lsePromedio
  ( compania,   anio,    clase_nomina,
   division,   des_division,
   trabajador,   nombre,
   fecha_ingreso,  agr_conceptos,  des_agr_conceptos,
   imp_01,   imp_02,   imp_03,
   imp_04,   imp_05,   imp_06,
   imp_07,   imp_08,   imp_09,
   imp_10,   imp_11,   imp_12
   )
 SELECT @chCompania,  am.anio,   tg.clase_nomina,
   rta.dato,   dat.descripcion,
   tg.trabajador,  replace (t.nombre, '/', ' '),
   tg.fecha_ingreso,  am.agr_conceptos,  acns.descripcion,
   ISNULL (am.acum_imp_mes_01, 0), ISNULL (am.acum_imp_mes_02, 0), ISNULL (am.acum_imp_mes_03, 0),
   ISNULL (am.acum_imp_mes_04, 0), ISNULL (am.acum_imp_mes_05, 0), ISNULL (am.acum_imp_mes_06, 0),
   ISNULL (am.acum_imp_mes_07, 0), ISNULL (am.acum_imp_mes_08, 0), ISNULL (am.acum_imp_mes_09, 0),
   ISNULL (am.acum_imp_mes_10, 0), ISNULL (am.acum_imp_mes_11, 0), ISNULL (am.acum_imp_mes_12, 0)

  FROM acumulados_mensuales am,
   trabajadores  t,
   trabajadores_grales tg,
   rel_trab_agr  rta,
   agr_conceptos_ns acns,
   datos_agr_trab  dat

  WHERE am.compania = @chCompania   AND
   ( am.anio = @iAnio  OR
    am.anio = @iAniAnterior  ) AND
   am.agr_conceptos in (@chAgrConSueldo, @chAgrConComisiones, @chAgrConPremios, @chAgrConOtros) AND

   t.trabajador = am.trabajador   AND

   tg.compania = am.compania   AND
   tg.trabajador = am.trabajador   AND

   ( (@iSitTrabajadores = 1 AND tg.sit_trabajador = 1) OR
    (@iSitTrabajadores = 2 AND tg.sit_trabajador = 2))  AND

   rta.compania = am.compania   AND
   rta.trabajador = am.trabajador  AND
   rta.agrupacion = @chAgrDivision  AND
   rta.dato = @chDivision    AND

   acns.agr_conceptos = am.agr_conceptos AND

   dat.agrupacion = rta.agrupacion  AND
   dat.dato = rta.dato
End

ELSE
BEGIN
 INSERT INTO  #lsePromedio
  ( compania,   anio,    clase_nomina,
   division,   des_division,
   trabajador,   nombre,
   fecha_ingreso,  agr_conceptos,  des_agr_conceptos,
   imp_01,   imp_02,   imp_03,
   imp_04,   imp_05,   imp_06,
   imp_07,   imp_08,   imp_09,
   imp_10,   imp_11,   imp_12
   )
 SELECT  @chCompania,  am.anio,   tg.clase_nomina,
   rta.dato,   dat.descripcion,
   tg.trabajador,  replace (t.nombre, '/', ' '),
   tg.fecha_ingreso,  am.agr_conceptos,  acns.descripcion,
   ISNULL (am.acum_imp_mes_01, 0), ISNULL (am.acum_imp_mes_02, 0), ISNULL (am.acum_imp_mes_03, 0),
   ISNULL (am.acum_imp_mes_04, 0), ISNULL (am.acum_imp_mes_05, 0), ISNULL (am.acum_imp_mes_06, 0),
   ISNULL (am.acum_imp_mes_07, 0), ISNULL (am.acum_imp_mes_08, 0), ISNULL (am.acum_imp_mes_09, 0),
   ISNULL (am.acum_imp_mes_10, 0), ISNULL (am.acum_imp_mes_11, 0), ISNULL (am.acum_imp_mes_12, 0)

  FROM acumulados_mensuales am,
   trabajadores  t,
   trabajadores_grales tg,
   rel_trab_agr  rta,
   agr_conceptos_ns  acns,
   datos_agr_trab  dat

  WHERE am.compania = @chCompania   AND
   ( am.anio = @iAnio OR
    am.anio = @iAniAnterior  ) AND
   ( am.agr_conceptos = @chAgrConSueldo OR
    am.agr_conceptos = @chAgrConComisiones OR
    am.agr_conceptos = @chAgrConPremios OR
    ( am.agr_conceptos = @chAgrConOtros AND @iIncOtros = 1)
   )       AND
   am.trabajador = @chTrabajador   AND

   t.trabajador = am.trabajador   AND

   tg.compania = am.compania   AND
   tg.trabajador = am.trabajador   AND

   rta.compania = am.compania   AND
   rta.trabajador = am.trabajador  AND
   rta.agrupacion = @chAgrDivision  AND

   acns.agr_conceptos = am.agr_conceptos AND

   dat.agrupacion = rta.agrupacion  AND
   dat.dato = rta.dato
End


-- Complementa la tabla de salida con las agrupaciones que no existan
--
INSERT INTO  #lsePromedio
 ( compania,   anio,    clase_nomina,
  division,   des_division,
  trabajador,   nombre,   comision,
  fecha_ingreso,  agr_conceptos,  des_agr_conceptos,
  imp_01,   imp_02,   imp_03,
  imp_04,   imp_05,   imp_06,
  imp_07,   imp_08,   imp_09,
  imp_10,   imp_11,   imp_12
  )
SELECT DISTINCT
  pr1.compania,  @iAnio,   pr1.clase_nomina,
  pr1.division,  pr1.des_division,
  pr1.trabajador,  pr1.nombre,   pr1.comision,
  pr1.fecha_ingreso, acns.agr_conceptos, acns.descripcion,
  0,    0,    0,
  0,    0,    0,
  0,    0,    0,
  0,    0,    0

 FROM #lsePromedio pr1,
  agr_conceptos_ns acns

 WHERE pr1.trabajador NOT IN
   (SELECT pr2.trabajador
    FROM #lsePromedio pr2
    WHERE pr2.compania = pr1.compania  AND
     pr2.anio = @iAnio    AND
     pr2.clase_nomina = pr1.clase_nomina AND
     pr2.trabajador = pr1.trabajador AND
     pr2.agr_conceptos = acns.agr_conceptos
   )        AND

  ( acns.agr_conceptos IN  (@chAgrConSueldo, @chAgrConComisiones, @chAgrConPremios) OR
    ( (acns.agr_conceptos = @chAgrConOtros AND @chTrabajador = '') OR
     (acns.agr_conceptos = @chAgrConOtros AND @chTrabajador <> '' AND @iIncOtros = 1)
    )
  )         AND

  (pr1.anio = @iAnio or pr1.anio = @iAniAnterior)

IF @iAnio <> @iAniAnterior
 INSERT INTO  #lsePromedio
  ( compania,   anio,    clase_nomina,
   division,   des_division,
   trabajador,   nombre,   comision,
   fecha_ingreso,  agr_conceptos,  des_agr_conceptos,
   imp_01,   imp_02,   imp_03,
   imp_04,   imp_05,   imp_06,
   imp_07,   imp_08,   imp_09,
   imp_10,   imp_11,   imp_12
   )
 SELECT DISTINCT
   pr1.compania,  @iAniAnterior,  pr1.clase_nomina,
   pr1.division,  pr1.des_division,
   pr1.trabajador,  pr1.nombre,   pr1.comision,
   pr1.fecha_ingreso, acns.agr_conceptos, acns.descripcion,
   0,    0,    0,
   0,    0,    0,
   0,    0,    0,
   0,    0,    0

  FROM #lsePromedio pr1,
   agr_conceptos_ns acns

  WHERE pr1.trabajador NOT IN
    (SELECT pr2.trabajador
     FROM #lsePromedio pr2
     WHERE pr2.compania = pr1.compania  AND
      pr2.anio = @iAniAnterior  AND
      pr2.clase_nomina = pr1.clase_nomina AND
      pr2.trabajador = pr1.trabajador AND
      pr2.agr_conceptos = acns.agr_conceptos
    )        AND
   acns.agr_conceptos in (@chAgrConSueldo, @chAgrConComisiones, @chAgrConPremios, @chAgrConOtros) AND
   (pr1.anio = @iAnio or pr1.anio = @iAniAnterior)


--  Determina las columnas a colocar en el query de salida
--
SET @chColAnterior = ''
SET @chColActual = ''
SET @chColSalida = ''

SET @iConMeses = 0
IF @iMesAtras >= @iMes
BEGIN
 SET @iMesInicial = @iMes - @iMesAtras + 1 + 12
 SET @chPrefijo = 'pant.'
End
ELSE
BEGIN
 SET @iMesInicial = @iMes - @iMesAtras + 1
 SET @chPrefijo = 'pact.'
End

WHILE @iConMeses < @iMesAtras
BEGIN
 SET @iMesColumna = @iMesInicial + @iConMeses

 IF @iMesColumna > 12
 BEGIN
  SET @iMesColumna = @iMesColumna - 12
  SET @chPrefijo = 'pact.'
 End

 IF @iMesColumna < 10
  SET @chMesColumna = '0' + CONVERT (CHAR (1), @iMesColumna)
 ELSE
  SET @chMesColumna = CONVERT (CHAR (2), @iMesColumna)

 SET @chColumna = @chPrefijo + 'imp_' + @chMesColumna

 IF @chPrefijo = 'pant.'
  IF @chColAnterior = ''
   SET @chColAnterior = @chColAnterior + @chColumna
  ELSE
   SET @chColAnterior = @chColAnterior + ', ' + @chColumna
 ELSE
  IF @chColActual = ''
   SET @chColActual = @chColActual + @chColumna
  ELSE
   SET @chColActual = @chColActual + ', ' + @chColumna

 IF @chColSalida = ''
  SET @chColSalida = 'imp_' + @chMesColumna
 ELSE
  SET @chColSalida = @chColSalida + ', ' + 'imp_' + @chMesColumna

 SET @iConMeses = @iConMeses + 1
End


IF @chColAnterior <> ''
 SET @chColActual = @chColAnterior + ', ' + @chColActual

IF @iAnio = @iAniAnterior
BEGIN
 SET @chTablas = '#lsePromedio pact'
 SET @chWhere = ''
End
ELSE
BEGIN
 SET @chTablas = '#lsePromedio pact, #lsePromedio pant'
 SET @chWhere = ' WHERE pact.compania = pant.compania    AND ' +
     ' pact.trabajador = pant.trabajador   AND ' +
     ' pact.clase_nomina = pant.clase_nomina  AND ' +
     ' pact.agr_conceptos = pant.agr_conceptos  AND ' +
     ' pact.anio = ' + CONVERT (CHAR (4), @iAnio) + ' AND ' +
     ' pant.anio = ' + CONVERT (CHAR (4), @iAniAnterior)
End


SET @chQuery = 'INSERT INTO #lseSalida ' +
   '( compania,   anio,    clase_nomina, ' +
   ' division,   des_division, ' +
   ' trabajador, ' +
   ' nombre,   comision,   fecha_ingreso, ' +
   ' agr_conceptos,  des_agr_conceptos, ord_agr_conceptos, ' +
   @chColSalida + ') ' +
   'SELECT ' +
   ' pact.compania,  pact.anio,   pact.clase_nomina, ' +
   ' pact.division,  pact.des_division, ' +
   ' pact.trabajador, ' +
   ' pact.nombre,  pact.comision,  pact.fecha_ingreso, ' +
   ' pact.agr_conceptos, pact.des_agr_conceptos, pact.ord_agr_conceptos, ' +
   @chColActual +
   ' FROM ' + @chTablas +
   @chWhere

EXEC (@chQuery)


-- Actualizando la informacion de resumen
--
-- Agrupaciones de Zona, Region, Departamento
--

UPDATE #lseSalida
 SET total = imp_01 + imp_02 + imp_03 + imp_04 + imp_05 + imp_06 +
    imp_07 + imp_08 + imp_09 + imp_10 + imp_11 + imp_12,
  ord_agr_conceptos = case agr_conceptos
       when @chAgrConSueldo then 1
       when @chAgrConComisiones then 2
       when @chAgrConPremios then 3
       when @chAgrConOtros then 4
      End,
  zona = (SELECT rtaz.dato
    FROM rel_trab_agr rtaz
    WHERE rtaz.compania = #lseSalida.compania  AND
     rtaz.agrupacion = @chAgrTraZona  AND
     rtaz.trabajador = #lseSalida.trabajador),
  region = (SELECT rtar.dato
    FROM rel_trab_agr rtar
    WHERE rtar.compania = #lseSalida.compania  AND
     rtar.agrupacion = @chAgrTraRegion  AND
     rtar.trabajador = #lseSalida.trabajador),
  departamento = (SELECT rtad.dato
    FROM rel_trab_agr rtad
    WHERE rtad.compania = #lseSalida.compania  AND
     rtad.agrupacion = @chAgrTraDepartamento AND
     rtad.trabajador = #lseSalida.trabajador),
  comision = (SELECT vt.variable_trabajador
    FROM variables_trabajador vt
    WHERE vt.compania = #lseSalida.compania  AND
     vt.trabajador = #lseSalida.trabajador AND
     vt.secuencia = @iVarTraPorComision),
  puesto = (SELECT  p.puesto
    FROM  plazas p
    WHERE  p.compania = #lseSalida.compania  AND
      p.trabajador = #lseSalida.trabajador)


  UPDATE #lseSalida
  SET    fec_pue_porcentaje = CASE agr_conceptos
                                    WHEN @chAgrConSueldo
                                    THEN Convert (CHAR (10), fecha_ingreso, 101)
                                    WHEN @chAgrConComisiones
                                    THEN puesto
                                    WHEN @chAgrConPremios
                                    THEN Substring(Convert (Char(12), Isnull(comision, 0)), 1, 9) + '%'
                              End,
          orden = CASE @iOrden WHEN 1
                               THEN departamento + SUBSTRING (nombre, 1, 90)
                               WHEN 2 THEN zona + region
                  End

UPDATE #lseSalida
 SET tot_mensual = (SELECT  s.salario * 30
     FROM  sueldos s
     WHERE  s.compania = #lseSalida.compania  AND
       s.trabajador = #lseSalida.trabajador),
  tot_diario = (SELECT  s.salario
     FROM  sueldos s
     WHERE  s.compania = #lseSalida.compania  AND
       s.trabajador = #lseSalida.trabajador)
 WHERE agr_conceptos = @chAgrConSueldo


-- Calculando el numero de meses que contienen importes
--
DECLARE crSalida CURSOR
 FOR
 SELECT imp_01, imp_02, imp_03, imp_04,
   imp_05, imp_06, imp_07, imp_08,
   imp_09, imp_10, imp_11, imp_12
  FROM #lseSalida
 FOR UPDATE

SET @iFinCursor = 0
OPEN crSalida

FETCH crSalida
 INTO @cImp_01, @cImp_02, @cImp_03, @cImp_04,
  @cImp_05, @cImp_06, @cImp_07, @cImp_08,
  @cImp_09, @cImp_10, @cImp_11, @cImp_12
IF @@FETCH_STATUS <> 0
 SET @iFinCursor = 1

WHILE @iFinCursor = 0
BEGIN
 SET @iNumMeses = 0

 IF @cImp_01 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_02 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_03 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_04 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_05 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_06 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_07 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_08 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_09 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_10 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_11 <> 0 SET @iNumMeses = @iNumMeses + 1
 IF @cImp_12 <> 0 SET @iNumMeses = @iNumMeses + 1

 UPDATE #lseSalida
  SET num_mes_importe = @iNumMeses
  WHERE CURRENT OF crSalida

 FETCH crSalida
  INTO @cImp_01, @cImp_02, @cImp_03, @cImp_04,
   @cImp_05, @cImp_06, @cImp_07, @cImp_08,
   @cImp_09, @cImp_10, @cImp_11, @cImp_12
 IF @@FETCH_STATUS <> 0
  SET @iFinCursor = 1
End
CLOSE crSalida
DEALLOCATE crSalida


-- Promedio mensual y Promedio diario
--
IF (@chTrabajador = ' ' OR @chTrabajador IS NULL) OR (@iProTodosMeses = 0)

 UPDATE #lseSalida
  SET tot_mensual = ( imp_01 + imp_02 + imp_03 + imp_04 + imp_05 + imp_06 +
     imp_07 + imp_08 + imp_09 + imp_10 + imp_11 + imp_12 ) / num_mes_importe,
   tot_diario = (( imp_01 + imp_02 + imp_03 + imp_04 + imp_05 + imp_06 +
     imp_07 + imp_08 + imp_09 + imp_10 + imp_11 + imp_12 ) / num_mes_importe) / 30
  WHERE agr_conceptos in (@chAgrConComisiones, @chAgrConPremios, @chAgrConOtros) AND
   num_mes_importe <> 0
ELSE

IF (@chTrabajador IS NOT NULL AND @chTrabajador <> ' ') AND (@iProTodosMeses = 1)

 UPDATE #lseSalida
  SET tot_mensual = ( imp_01 + imp_02 + imp_03 + imp_04 + imp_05 + imp_06 +
     imp_07 + imp_08 + imp_09 + imp_10 + imp_11 + imp_12 ) / @iMesAtras,
   tot_diario = (( imp_01 + imp_02 + imp_03 + imp_04 + imp_05 + imp_06 +
     imp_07 + imp_08 + imp_09 + imp_10 + imp_11 + imp_12 ) / @iMesAtras) / 30
  WHERE agr_conceptos in (@chAgrConComisiones, @chAgrConPremios, @chAgrConOtros) AND
   num_mes_importe <> 0


SET @iAni01 = @iAnio
SET @iAni02 = @iAnio
SET @iAni03 = @iAnio
SET @iAni04 = @iAnio
SET @iAni05 = @iAnio
SET @iAni06 = @iAnio
SET @iAni07 = @iAnio
SET @iAni08 = @iAnio
SET @iAni09 = @iAnio
SET @iAni10 = @iAnio
SET @iAni11 = @iAnio
SET @iAni12 = @iAnio

IF @iAnio <> @iAniAnterior
BEGIN
 IF 1 > @iMes  SET @iAni01 = @iAniAnterior
 IF 2 > @iMes  SET @iAni02 = @iAniAnterior
 IF 3 > @iMes  SET @iAni03 = @iAniAnterior
 IF 4 > @iMes  SET @iAni04 = @iAniAnterior
 IF 5 > @iMes  SET @iAni05 = @iAniAnterior
 IF 6 > @iMes  SET @iAni06 = @iAniAnterior
 IF 7 > @iMes  SET @iAni07 = @iAniAnterior
 IF 8 > @iMes  SET @iAni08 = @iAniAnterior
 IF 9 > @iMes  SET @iAni09 = @iAniAnterior
 IF 10 > @iMes  SET @iAni10 = @iAniAnterior
 IF 11 > @iMes  SET @iAni11 = @iAniAnterior
 IF 12 > @iMes  SET @iAni12 = @iAniAnterior
End


IF @iActVariable = 0
BEGIN
 SELECT orden,  compania,   anio,
   clase_nomina,
   division,  des_division,  zona,
   region,  departamento,  trabajador,
   nombre,  puesto,
   comision,  fecha_ingreso,
   fec_pue_porcentaje,
   agr_conceptos, des_agr_conceptos, ord_agr_conceptos,
   imp_01,  imp_02,   imp_03,
   imp_04,  imp_05,   imp_06,
   imp_07,  imp_08,   imp_09,
   imp_10,  imp_11,   imp_12,
   total,  tot_mensual,  tot_diario,

   @iAni01 ani01, @iAni02 ani02,  @iAni03 ani03,
   @iAni04 ani04, @iAni05 ani05,  @iAni06 ani06,
   @iAni07 ani07, @iAni08 ani08,  @iAni09 ani09,
   @iAni10 ani10, @iAni11 ani11,  @iAni12 ani12

  FROM #lseSalida
  ORDER BY orden, ord_agr_conceptos
End
ELSE
BEGIN
 BEGIN TRANSACTION
  DELETE variables_trabajador
   WHERE compania = @chCompania  AND
    trabajador = (SELECT DISTINCT sal.trabajador
       FROM #lseSalida sal
       WHERE sal.compania = variables_trabajador.compania  AND
        sal.trabajador = variables_trabajador.trabajador AND
        sal.agr_conceptos = @chAgrConComisiones)   AND
    secuencia = @iVarTraComision

  INSERT INTO variables_trabajador
    ( compania,  trabajador,  secuencia,   variable_trabajador)
   SELECT compania,  trabajador,  @iVarTraComision,  tot_diario
    FROM #lseSalida
    WHERE agr_conceptos = @chAgrConComisiones

 COMMIT TRANSACTION
 --fra
  SELECT orden,  compania,   anio,
   clase_nomina,
   division,  des_division,  zona,
   region,  departamento,  trabajador,
   nombre,  puesto,
   comision,  fecha_ingreso,
   fec_pue_porcentaje,
   agr_conceptos, des_agr_conceptos, ord_agr_conceptos,
   imp_01,  imp_02,   imp_03,
   imp_04,  imp_05,   imp_06,
   imp_07,  imp_08,   imp_09,
   imp_10,  imp_11,   imp_12,
   total,  tot_mensual,  tot_diario,
   @iAni01 ani01, @iAni02 ani02,  @iAni03 ani03,
   @iAni04 ani04, @iAni05 ani05,  @iAni06 ani06,
   @iAni07 ani07, @iAni08 ani08,  @iAni09 ani09,
   @iAni10 ani10, @iAni11 ani11,  @iAni12 ani12
  FROM #lseSalida
  ORDER BY orden, ord_agr_conceptos

End
   Return

End
Go
