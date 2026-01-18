Create Or Alter TRIGGER dbo.trinstransacciones_ns ON transacciones_ns FOR
INSERT, UPDATE
 AS
/**************************************************************/
/* Nombre F›sico:            T0116.TRI                        */
/* Autor:                    H⁄ctor Ortega Gonzﬂlez           */
/* Fecha:                    30/Dic/96                        */
/* modificado:               VJFS. 19/10/2000                 */
/* Proyecto:                 Næmina                           */
/**************************************************************/
DECLARE @tipo_nomina      CHAR(2),
@turno TINYINT,
@rel_laboral CHAR(10),
@agr_01 CHAR(10),
@dato_01_01 CHAR(10),
@dato_01_02 CHAR(10),
@dato_01_03 CHAR(10),
@agr_02 CHAR(10),
@dato_02_01 CHAR(10),
@dato_02_02 CHAR(10),
@dato_02_03 CHAR(10),
@agr_03 CHAR(10),
@dato_03_01 CHAR(10),
@dato_03_02 CHAR(10),
@dato_03_03 CHAR(10),
@con_col CHAR(10),
@sit_periodo TINYINT


BEGIN
 /* SEGURIDAD POR CLASE DE NOMINA */
 IF EXISTS(SELECT 1 FROM inserted i, trabajadores_grales G
  WHERE G.compania      = i.compania   AND
                 G.trabajador    = i.trabajador AND
                 G.clase_nomina != Null         AND
                  NOT EXISTS(SELECT 1 FROM rel_usu_clase_nom R
                        WHERE R.clase_nomina = G.clase_nomina AND
                              R.usuario      = system_user))
 BEGIN
  RAISERROR ('El Usuario no tiene Autoridad para la Clase de Næmina a la que pertenece el trabajador [transacciones_ns]', 16, 1)
  ROLLBACK TRANSACTION
  RETURN
 END

 /* SEGURIDAD POR AGRUPACIONES DE TRABAJADOR */
 IF EXISTS (SELECT 1 FROM rel_trab_agr t, rel_usu_agr_trab u, inserted i
  WHERE t.compania   = i.compania   AND
                  t.trabajador = i.trabajador AND
                  u.agrupacion = t.agrupacion AND
                  u.dato       = t.dato       AND
                  u.usuario    = system_user)
 BEGIN
  RAISERROR ('El Usuario no tiene Autoridad para el Dato de Agrupaciæn al que pertenece el trabajador [transacciones_ns]', 16, 1)
  ROLLBACK TRANSACTION
  RETURN
 END

 SELECT @tipo_nomina = tipo_nomina
 FROM calendario_procesos,inserted
 WHERE inserted.id_calendario = calendario_procesos.id_calendario


 /* rel_conc_tipo_nomina */
   IF EXISTS(SELECT 1 FROM inserted
  WHERE NOT EXISTS(SELECT 1 FROM rel_conc_tipo_nomina
   WHERE inserted.compania = rel_conc_tipo_nomina.compania AND
                                   inserted.concepto = rel_conc_tipo_nomina.concepto AND
                                   @tipo_nomina      = rel_conc_tipo_nomina.tipo_nomina))
 BEGIN
  RAISERROR ('El concepto no estﬂ relacionado con el Tipo de Næmina [transacciones_ns]', 16, 1)
  ROLLBACK TRANSACTION
  RETURN
 END



 /* Verifica si el trabajador cumple con las condiciones del concepto nuevo */
 IF (update(compania) or update(clase_nomina) or update(id_calendario) or update(concepto) or update(trabajador)
 or update(referencia) or update(secuencia) or update(referencia2) or update(fecha) or update(fecha2)
 or update(tiempo) or update(factor_01) or update(factor_02) or update(factor_03) or update(importe_reportado)
 or update(importe) or update(turno_trn) or update(puesto_trn) or update(agrupacion_01_trn)
 or update(dato_01_trn) or update(agrupacion_02_trn) or update(dato_02_trn) or update(agrupacion_03_trn)
 or update(dato_03_trn) or update(agrupacion_04_trn) or update(dato_04_trn) or update(origen_transaccion)
 or update(usuario_registro) or update(fecha_registro) or update(usuario_proceso) or update(fecha_proceso)
 or update(usuario_cambio) or update(fecha_cambio) or update(sit_transaccion)) and exists(select * from deleted)
 BEGIN
  SELECT  @turno = cond_turno,
   @rel_laboral = cond_rel_laboral,
   @agr_01 = cond_agr_01,
   @dato_01_01 = cond_dato_01_01,
   @dato_01_02 = cond_dato_01_02,
   @dato_01_03 = cond_dato_01_03,
   @agr_02 = cond_agr_02,
   @dato_02_01 = cond_dato_02_01,
   @dato_02_02 = cond_dato_02_02,
   @dato_02_03 = cond_dato_02_03,
   @agr_03 = cond_agr_03,
   @dato_03_01 = cond_dato_03_01,
   @dato_03_02 = cond_dato_03_02,
   @dato_03_03 = cond_dato_03_03
  FROM conceptos_ns n, inserted i
  WHERE n.compania = i.compania
  AND n.concepto = i.concepto

  IF @turno IS NOT NULL AND NOT EXISTS (SELECT 1 FROM trabajadores_grales t, inserted i
   WHERE t.compania = i.compania
   AND t.trabajador = i.trabajador
   AND t.turno = @turno)
  BEGIN
   RAISERROR ('El trabajador no pertenece al turno al que estﬂ condicionado el nuevo concepto [transacciones_ns]', 16, 1)
   ROLLBACK TRANSACTION
   RETURN
  END

  IF @rel_laboral IS NOT NULL AND NOT EXISTS (SELECT 1 FROM trabajadores_grales t, inserted i
   WHERE t.compania = i.compania
   AND t.trabajador = i.trabajador
   AND t.relacion_laboral = @rel_laboral)
  BEGIN
   RAISERROR ('El trabajador no tiene la relaciæn laboral a la que estﬂ condicionada el nuevo concepto [transacciones_ns]', 16, 1)
   ROLLBACK TRANSACTION
   RETURN
  END

  IF @agr_01 IS NOT NULL
  BEGIN

   IF NOT EXISTS (SELECT 1 FROM rel_trab_agr r, inserted i
    WHERE r.compania = i.compania
    AND r.trabajador = i.trabajador
    AND r.agrupacion = @agr_01
    AND r.dato IN (@dato_01_01, @dato_01_02, @dato_01_03))
   BEGIN
    RAISERROR ( 'El trabajador no existe en la relacion agrupacion/dato condicionada por el nuevo concepto [transacciones_ns]', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
   END
  END

  IF @agr_02 IS NOT NULL
  BEGIN
   IF NOT EXISTS (SELECT 1 FROM rel_trab_agr r, inserted i
    WHERE r.compania = i.compania
    AND r.trabajador = i.trabajador
    AND r.agrupacion = @agr_02
    AND r.dato IN (@dato_02_01,  @dato_02_02, @dato_02_03))
   BEGIN
    RAISERROR ( 'El trabajador no existe en la relacion agrupacion/dato condicionada por el nuevo concepto [transacciones_ns]', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
   END
  END

  IF @agr_03 IS NOT NULL
  BEGIN
   IF NOT EXISTS (SELECT 1 FROM rel_trab_agr r, inserted i
    WHERE r.compania = i.compania
    AND r.trabajador = i.trabajador
    AND r.agrupacion = @agr_03
    AND r.dato IN (@dato_03_01, @dato_03_02, @dato_03_03))
   BEGIN
    RAISERROR ( 'El trabajador no existe en la relacion agrupacion/dato condicionada por el nuevo concepto [transacciones_ns]', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
   END
   END
 END


 /* clase_nomina del trabajador en trabajadores_grales*/

 SELECT @sit_periodo = 0

 SELECT  @sit_periodo = sit_periodo
 FROM  cal_proc_cias cp, inserted i
 WHERE  cp.compania = i.compania
 AND    cp.id_calendario = i.id_calendario

 IF @sit_periodo <> 4
 BEGIN
   IF EXISTS(SELECT 1 FROM inserted
   WHERE NOT EXISTS(SELECT 1 FROM trabajadores_grales
    WHERE inserted.compania = trabajadores_grales.compania
    AND inserted.trabajador = trabajadores_grales.trabajador
    AND inserted.clase_nomina = trabajadores_grales.clase_nomina))
  BEGIN
   RAISERROR ('El Trabajador no pertenece a la Clase de Næmina [transacciones_indiv]', 16, 1)
   ROLLBACK TRANSACTION
   RETURN
      END
 END
END
