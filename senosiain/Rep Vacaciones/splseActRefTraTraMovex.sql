-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE splseActRefTraTraMovex  
AS  
BEGIN  
 INSERT INTO lse_tra_trabajadores  
  ( compania, trabajador)  
SELECT  tg.compania, t.trabajador  
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
  
END  