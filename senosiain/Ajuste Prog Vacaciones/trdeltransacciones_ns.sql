CREATE Or Alter TRIGGER dbo.trdeltransacciones_ns ON transacciones_ns FOR DELETE AS
/************************************************************** */
/*Nombre F_sico:            T0116.TRD                           */
/*Autor:                    H_ctor Ortega Gonzlez              */
/*Fecha:                    30/Dic/96                           */
/*Proyecto:                 N_mina                              */
/****************************************************************/
IF @@rowcount = 0
RETURN

/* SEGURIDAD POR CLASE DE NOMINA */

IF EXISTS(SELECT 1 FROM deleted d, trabajadores_grales g
           WHERE g.compania      = d.compania   AND
                 g.trabajador    = d.trabajador AND
                 g.clase_nomina != Null
             AND NOT EXISTS(SELECT 1 FROM rel_usu_clase_nom r
                             WHERE r.clase_nomina = g.clase_nomina
                               AND r.usuario      = system_user ))
BEGIN
   RAISERROR ('El Usuario no tiene Autoridad para la Clase de N¾mina a la que pertenece el trabajador [transacciones_ns]', 16, 1)
   ROLLBACK TRANSACTION
   RETURN
END

-- /* SEGURIDAD POR AGRUPACIONES DE TRABAJADOR */
IF EXISTS (SELECT 1 FROM rel_trab_agr t, rel_usu_agr_trab u, deleted d
            WHERE t.compania   = d.compania   AND
                  t.trabajador = d.trabajador AND
                  u.agrupacion = t.agrupacion AND
                  u.dato       = t.dato       AND
                  u.usuario    = system_user )
BEGIN
   RAISERROR ('El Usuario no tiene Autoridad para el Dato de Agrupaci¾n al que pertenece el trabajador [transacciones_ns]', 16, 1)
   ROLLBACK TRANSACTION
   RETURN
END

/* ELIMINA REGISTROS DE TABLAS DEPENDIENTES */
DELETE trans_ns_errores
  FROM trans_ns_errores, deleted
 WHERE trans_ns_errores.compania      = deleted.compania      AND
       trans_ns_errores.id_calendario = deleted.id_calendario AND
       trans_ns_errores.clase_nomina  = deleted.clase_nomina  AND
       trans_ns_errores.concepto      = deleted.concepto      AND
       trans_ns_errores.trabajador    = deleted.trabajador    AND
       trans_ns_errores.referencia    = deleted.referencia    AND
       trans_ns_errores.secuencia     = deleted.secuencia


