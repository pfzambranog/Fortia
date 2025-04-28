 CREATE procedure splseAltaParAdaptaciones  
 ( @chCompania   char  (4),  
  @iIdModulo   int,  
  @chClaParametro  char  (30),  
  @chDescripcion  varchar (250),  
  @iNumEntero   int,  
  @cNumDecimal  decimal (19, 6),  
  @chAlfanumerico  varchar (250),  
  @dFecHora   datetime,  
  @chTipo   varchar (15),  
  @chQuery   varchar (3000),  
  @chControl   varchar (15),  
  @chCamValor   varchar (20),  
  @chCamTexto   varchar (20)  
 )  
  
as  
---------------------------------------------------------------------------------------------  
---- Procedimiento:  splseAltaParAdaptaciones   
---- Programó: Fco Rodríguez  
---- Objetivo: Alta en tabla lse_par_adaptaciones  
---- Creado:  02/05/2007  
---- Ejemplo de llamada:  
---- exec splseAltaParAdaptaciones 'LS', 17, 'VAC_ADAM_SS_F1', 'Fecha Inicial de Sem Santa',  
----      NULL, NULL, NULL, '20070102', 'fecha_hora', NULL,  
----      NULL, NULL, NULL, NULL  
----  
---- El parámetro "@chTipo" puede tener los siguientes valores:  
----  Alfanumerico  
----  fecha_hora  
----  num_decimal  
----  num_entero  
----  
---- El parámetro @iIdModulo tiene el valor 17 para el módulo "Control de Vacaciones"  
----  
---- Los valores para los parámetros @chQuery, @chControl, @chCamValor y @chCamTexto  
---- para el caso del módulo de Control de Vacaciones, deben ir en nulo.  
---------------------------------------------------------------------------------------------  
  
  
Begin  
  
 IF NOT EXISTS (SELECT 1  
     FROM lse_par_adaptaciones  
     WHERE compania = @chCompania  AND  
      idModulo = @iIdModulo  AND  
      cla_parametro = @chClaParametro)  
  
  INSERT INTO lse_par_adaptaciones  
   ( compania,  idModulo,  
    cla_parametro, descripcion, num_entero,  
    num_decimal, alfanumerico, fecha_hora,  
    Tipo,   Query,  Control,  
    CampoValor,  CampoTexto  
   )  
   VALUES  
   ( @chCompania, @iIdModulo,  
    @chClaParametro, @chDescripcion, @iNumEntero,  
    @cNumDecimal, @chAlfanumerico, @dFecHora,  
    @chTipo,  @chQuery,  @chControl,  
    @chCamValor, @chCamTexto  
   )  
 ELSE  
  UPDATE lse_par_adaptaciones  
   SET descripcion = @chDescripcion,  
    num_entero = @iNumEntero,  
    num_decimal = @cNumDecimal,  
    alfanumerico = @chAlfanumerico,  
    fecha_hora = @dFecHora,  
    Tipo = @chTipo,  
    Query = @chQuery,  
    Control = @chControl,  
    CampoValor = @chCamValor,  
    CampoTexto = @chCamTexto   
   WHERE compania = @chCompania   AND  
    idModulo = @iIdModulo   AND  
    cla_parametro = @chClaParametro  
  
END  