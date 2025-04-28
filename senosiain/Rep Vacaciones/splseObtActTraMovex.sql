CREATE PROCEDURE splseObtActTraMovex  
AS  
BEGIN  
 SELECT  LTRIM(t.trabajador) trabajador, REPLACE (t.nombre, '/', ' ') nombre,  
  CONVERT (INT, CONVERT (CHAR (8), tg.fecha_ingreso, 112)) fec_ingreso,  
  lpac.num_entero compania,  
  SUBSTRING (lpad.alfanumerico, 1, 2) division,  
  lpadc.num_entero dim_contable,  
  SUBSTRING (lpagc.alfanumerico, 1, 1) gru_cuenta,  
  SUBSTRING (lpaic.alfanumerico, 1, 12) ide_cambio,  
  SUBSTRING (REPLACE (t.nombre, '/', ' '), 1, 15) nom_abreviado,  
  CONVERT (INT, REPLACE (CONVERT (char (8), getdate (), 108), ':', '')) hora  
  
 FROM trabajadores_grales tg,  
  trabajadores t,  
  lse_par_adaptaciones lpac,  
  lse_par_adaptaciones lpad,  
  lse_par_adaptaciones lpadc,  
  lse_par_adaptaciones lpagc,  
  lse_par_adaptaciones lpaic  
  
 WHERE tg.compania = 'LS'   AND  
  tg.sit_trabajador = 1   AND -- Trabajadores activos  
  tg.trabajador NOT IN (SELECT ltt.trabajador  
     FROM lse_tra_trabajadores ltt  
     WHERE ltt.compania = tg.compania AND  
      ltt.trabajador = tg.trabajador)  AND  
  
  t.trabajador = tg.trabajador  AND  
  
  lpac.compania = tg.compania  AND  
  lpac.cla_parametro = 'PAR_COM_MOVEX' AND -- Compa;ia Movex  
  
  lpad.compania = tg.compania  AND  
  lpad.cla_parametro = 'PAR_DIV_MOVEX' AND -- Division Movex  
  
  lpadc.compania = tg.compania  AND  
  lpadc.cla_parametro = 'PAR_DIM_CON_MOVEX' AND -- Dimension Contable Movex  
  
  lpagc.compania = tg.compania  AND  
  lpagc.cla_parametro = 'PAR_GRU_CUE_MOVEX' AND -- Grupo de Cuenta Movex  
  
  lpaic.compania = tg.compania  AND  
  lpaic.cla_parametro = 'PAR_IDE_CAM_REG_MOVEX' -- Identificador de Cambio Movex  
  
 UNION ALL  
  
 SELECT  LTRIM(t.trabajador) trabajador, REPLACE (t.nombre, '/', ' ') nombre,  
  CONVERT (INT, CONVERT (CHAR (8), tg.fecha_ingreso, 112)) fec_ingreso,  
  lpac.num_entero compania,  
  SUBSTRING (lpad.alfanumerico, 1, 2) division,  
  lpadc.num_entero dim_contable,  
  SUBSTRING (lpagc.alfanumerico, 1, 1) gru_cuenta,  
  SUBSTRING (lpaic.alfanumerico, 1, 12) ide_cambio,  
  SUBSTRING (REPLACE (t.nombre, '/', ' '), 1, 15) nom_abreviado,  
  CONVERT (INT, REPLACE (CONVERT (char (8), getdate (), 108), ':', '')) hora  
  
 FROM [198.139.21.73].ADAMP.dbo.trabajadores_grales tg,  
  [198.139.21.73].ADAMP.dbo.trabajadores t,  
  lse_par_adaptaciones lpac,  
  lse_par_adaptaciones lpad,  
  lse_par_adaptaciones lpadc,  
  lse_par_adaptaciones lpagc,  
  lse_par_adaptaciones lpaic  
  
 WHERE tg.compania = 'LS'   AND  
  tg.sit_trabajador = 1   AND -- Trabajadores activos  
  tg.trabajador NOT IN (SELECT ltt.trabajador  
     FROM lse_tra_trabajadores ltt  
     WHERE ltt.compania = tg.compania AND  
      ltt.trabajador = tg.trabajador)  AND  
  
  t.trabajador = tg.trabajador  AND  
  
  lpac.compania = tg.compania  AND  
  lpac.cla_parametro = 'PAR_COM_MOVEX' AND -- Compa;ia Movex  
  
  lpad.compania = tg.compania  AND  
  lpad.cla_parametro = 'PAR_DIV_MOVEX' AND -- Division Movex  
  
  lpadc.compania = tg.compania  AND  
  lpadc.cla_parametro = 'PAR_DIM_CON_MOVEX' AND -- Dimension Contable Movex  
  
  lpagc.compania = tg.compania  AND  
  lpagc.cla_parametro = 'PAR_GRU_CUE_MOVEX' AND -- Grupo de Cuenta Movex  
  
  lpaic.compania = tg.compania  AND  
  lpaic.cla_parametro = 'PAR_IDE_CAM_REG_MOVEX' -- Identificador de Cambio Movex  
  
  
  
END  