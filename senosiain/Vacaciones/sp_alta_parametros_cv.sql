CREATE PROCEDURE sp_alta_parametros_cv  
    @compania            CHAR(04) = '',  
    @saldos_vac          SMALLINT  = 0,  
    @horas_dias          TINYINT  = 0,   
    @dias_vac            TINYINT  = 0,  
    @var_antig           VARCHAR(20) = '',  
    @act_kardex          TINYINT  = 0,  
    @cod_kardex          SMALLINT  = 0,  
    @tipo_vac            TINYINT  = 0,  
    @manejo_neg          TINYINT  = 0,  
    @cad_ciclo           DECIMAL(16,8) = 0,  
    @dia_lab_prog        TINYINT  = 0,  
    @agrupacion          CHAR(10) = '',  
    @tipo_manejo         TINYINT  = 0  
AS  
/* ************************************************************** */  
/*  Nombre Ffsico  : sp_alta_parametros_cv                        */  
/*  Fecha_creacion : 13/Octubre/1998                              */  
/*                                                                */  
/*           Autor : Grupo TEA (M=dulo de Vacaciones )            */      
/*                   Fabiola De Jes∑s CortTs                      */  
/*                                                                */  
/*        Proyecto : Control de Vacaciones ADAMV3.0               */  
/*     Descripci=n : El store_proced. "sp_alta_parametros_cv"     */  
/*            inserta los valores de los parametros de vacaciones */  
/*                      en la tabla parametros_cv                 */   
/* ************************************************************** */  
BEGIN  
DECLARE @secuencia_param_cv SMALLINT  
  
 SELECT @secuencia_param_cv = 0  
    
  IF NOT ((@saldos_vac = 0) OR (@saldos_vac = 1))  
   BEGIN  
      RAISERROR 20001 'Estﬂ tratando de insertar un valor no vﬂlido para la variable  
             saldos_vacaciones.'  
      RETURN 1   
   END  
  
  IF ((@saldos_vac = 1) AND @tipo_manejo IS NOT NULL)  
   BEGIN  
      RAISERROR 20001 'El parametro de tipo_manejo solo aplica para los saldos de vacaciones  
                   por Ciclos.'  
      RETURN 1   
   END  
  
    
  IF NOT ((@tipo_manejo = 0) OR (@tipo_manejo = 1))  
   BEGIN  
      RAISERROR 20001 'Estﬂ tratando de insertar un valor no vﬂlido para la variable  
             Tipo_Manejo.'  
      RETURN 1   
   END  
  
  
  IF NOT ((@horas_dias = 0) OR (@horas_dias = 1))  
   BEGIN  
      RAISERROR 20001 'Estﬂ tratando de insertar un valor no vﬂlido para la variable  
            horas_dias.'  
      RETURN 1   
   END  
  
  IF NOT ((@dias_vac = 0) OR (@dias_vac = 1) OR (@dias_vac = 2))  
   BEGIN  
      RAISERROR 20001 'Estﬂ tratando de insertar un valor no vﬂlido para la variable  
            dias_vac.Verifique por favor.'  
      RETURN 1   
   END  
  
  IF(@var_antig = '')  
   BEGIN  
      RAISERROR 20001 'No Estﬂ insertando la variable de Antignedad corresponidente.Verifique por favor.'  
      RETURN 1   
   END  
  
  IF NOT ((@act_kardex = 0) OR (@act_kardex = 1))  
   BEGIN  
      RAISERROR 20001 'Estﬂ tratando de insertar un valor no vﬂlido para la variable  
            act_kardex.Verifique por favor.'  
      RETURN 1   
   END  
  
  IF(@cod_kardex IS NULL)  
   BEGIN  
  
      RAISERROR 20001 'No Estﬂ insertando el valor del c=digo de incidencia de   
                     Kﬂrdex .Verifique por favor.'  
      RETURN 1   
   END  
  
 IF NOT ((@tipo_vac = 0) OR (@tipo_vac = 1))  
   BEGIN  
      RAISERROR 20001 'No estﬂ insertando el valor de la variable Tipo de vacaciones.  
                            Verifique por favor.'  
      RETURN 1   
   END  
  
  IF NOT ((@manejo_neg = 0) OR (@manejo_neg = 1))  
   BEGIN  
      RAISERROR 20001 'No estﬂ insertando el valor de la variable Manejo de Negativos.  
                            Verifique por favor.'  
      RETURN 1   
   END  
  
   IF(@cad_ciclo IS NULL)  
   BEGIN  
      RAISERROR 20001 'No Estﬂ insertando el valor de la caducidad del ciclo de vacaciones   
              Este valor se puede dar en fraccion de a±o.Verifique por favor.'  
      RETURN 1   
   END  
  
  IF NOT ((@dia_lab_prog = 0) OR (@dia_lab_prog = 1))  
   BEGIN  
      RAISERROR 20001 'No estﬂ insertando el valor de la variable Dias laborables programados  
                    para restringir calendario.Verifique por favor.'  
      RETURN 1   
  END  
  
  IF isnull(ltrim(rtrim(@agrupacion)),' ') != ' '  
   BEGIN  
     IF NOT EXISTS(SELECT 1 FROM rel_agr_companias  
                    WHERE compania = @compania AND  
                        agrupacion = @agrupacion )  
      BEGIN   
        RAISERROR 20001 'La agrupaci=n que estﬂ tratando de insertar no existe   
                     para Tsta compa±fa o no estﬂ registrada en [rel_agr_compnias]. Verifique por favor.'  
        RETURN 1   
      END  
   END    
  
  SELECT @secuencia_param_cv = @secuencia_param_cv + 1  
  
  IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                        parametro_cv = 'Saldos_vac')    
    BEGIN  
      UPDATE parametros_cv set entero = @saldos_vac  
       WHERE compania = @compania AND parametro_cv = 'Saldos_vac'  
    END  
 ELSE  
   BEGIN  
    INSERT INTO parametros_cv   
       VALUES(@compania,'Saldos_vac',@secuencia_param_cv,'Acumulaci=n de saldos vacaciones ( 0.- Por ciclos/1.-Globales )',Null,Null,@saldos_vac)  
   END  
  
  
  IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                        parametro_cv = 'Tipo_Manejo')    
    BEGIN  
      UPDATE parametros_cv set entero = @tipo_manejo  
       WHERE compania = @compania AND parametro_cv = 'Tipo_Manejo'  
    END  
 ELSE  
   BEGIN  
    INSERT INTO parametros_cv   
       VALUES(@compania,'Tipo_Manejo',@secuencia_param_cv,'Determina el tipo de manejo para los Saldos de Vacaciones por Ciclos.(0.-Ciclos Laborales 1.-Ciclos Vacacionales)', NULL, NULL, @tipo_manejo)  
   END  
  
  
  IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                        parametro_cv = 'Horas_dias')    
   BEGIN  
      UPDATE parametros_cv set entero = @horas_dias  
       WHERE compania = @compania AND parametro_cv = 'Horas_dias'  
   END  
 ELSE  
   BEGIN    
     INSERT INTO parametros_cv VALUES  
     (@compania,'Horas_dias',@secuencia_param_cv,'Unidad de tiempo para vacaciones (0.-Por Dfas/ 1.-Por  Horas)',Null,Null,@horas_dias)  
   END  
  
 IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                        parametro_cv = 'Dias_vac')    
   BEGIN  
     UPDATE parametros_cv set entero = @dias_vac  
      WHERE compania = @compania AND parametro_cv = 'Dias_vac'  
   END  
 ELSE  
   BEGIN  
     INSERT INTO parametros_cv VALUES  
      (@compania,'Dias_vac',@secuencia_param_cv,'Manejo de dfas para  tomar vacaciones (0.-Dfas Naturales / 1.-Dfas Hﬂbiles/ 2.-calendario de Sistemas Horario)',Null,Null,@dias_vac)  
   END  
  
  IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                        parametro_cv = 'Var_antig')    
   BEGIN  
      UPDATE parametros_cv set alfanumerico = @var_antig   
       WHERE compania = @compania AND parametro_cv = 'Var_antig'  
   END  
  ELSE  
   BEGIN  
     INSERT INTO parametros_cv VALUES  
       (@compania,'Var_antig',@secuencia_param_cv,'Variables del sistema de antignedad para vacaciones',@var_antig,Null,Null)  
   END  
  
  IF EXISTS( SELECT 1 FROM parametros_cv  
              WHERE compania = @compania AND   
                parametro_cv = 'Act_kardex')    
   BEGIN  
      UPDATE parametros_cv set entero = @act_kardex  
     WHERE compania = @compania AND parametro_cv = 'Act_kardex'  
   END  
 ELSE  
   BEGIN  
     INSERT INTO parametros_cv VALUES  
       (@compania,'Act_kardex',@secuencia_param_cv,'Actualiza_Kardex si existe KP (kardex personal) 1.-Si 0.No)',Null,Null,@act_kardex)  
   END  
  
   IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                           parametro_cv = 'Cod_kardex')    
    BEGIN  
      UPDATE parametros_cv set entero = @cod_kardex  
       WHERE compania = @compania AND parametro_cv = 'Cod_kardex'  
    END  
  ELSE  
    BEGIN  
     INSERT INTO parametros_cv VALUES  
       (@compania,'Cod_kardex',@secuencia_param_cv,'C=digo de inicidencia es la clave de incidencia registrada en ADAM/KP que se relaciona con los datos de vac.',Null,Null,@cod_kardex)  
    END  
  
  IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                           parametro_cv = 'Tipo_vac')    
   BEGIN  
      UPDATE parametros_cv set entero = @tipo_vac  
       WHERE compania = @compania AND parametro_cv = 'Tipo_vac'  
   END  
 ELSE  
   BEGIN  
     INSERT INTO parametros_cv VALUES  
       (@compania,'Tipo_vac',@secuencia_param_cv,'Tipo de vacaciones que se van a programar. 1.Anticipadas/Proporcionales  0.Normales.',Null,Null,@tipo_vac)  
   END  
  
  IF EXISTS(SELECT 1 FROM parametros_cv  
             WHERE compania = @compania AND   
               parametro_cv = 'Manejo_Neg')    
   BEGIN  
     UPDATE parametros_cv set entero = @manejo_neg   
      WHERE compania = @compania AND parametro_cv = 'Manejo_Neg'  
   END  
 ELSE  
  BEGIN  
    INSERT INTO parametros_cv VALUES  
      (@compania,'Manejo_Neg',@secuencia_param_cv,'Define si permitirﬂ el manejo de saldos de vacaciones negativos. (1.- Si  0.- No)',Null,Null,@manejo_neg)  
   END  
  
  IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                    parametro_cv = 'Cad_ciclo')    
   BEGIN  
      UPDATE parametros_cv set real = @cad_ciclo   
       WHERE compania = @compania AND parametro_cv = 'Cad_ciclo'  
   END  
 ELSE  
   BEGIN   
     INSERT INTO parametros_cv VALUES  
        (@compania,'Cad_ciclo',@secuencia_param_cv,'Define el tiempo de caducidad para los perfodos de vac. en a±os, pero se pueden manejar fracciones de a±os',Null,@cad_ciclo,Null)  
   END  
  
  
   IF EXISTS( SELECT 1 FROM parametros_cv  
                  WHERE compania = @compania AND   
                    parametro_cv = 'Dia_lab_prog')    
   BEGIN  
       UPDATE parametros_cv set entero = @dia_lab_prog, alfanumerico = @agrupacion  
        WHERE compania = @compania AND parametro_cv = 'Dia_lab_prog'  
   END  
  ELSE    
   BEGIN    
    INSERT INTO parametros_cv VALUES  
      (@compania,'Dia_lab_prog',@secuencia_param_cv,'Def si restringe el calendario de prog.de vac,es decir si no puedo programar en ciertas fechas(1.Si/0.No)',@agrupacion,Null,@dia_lab_prog)  
   END  
  
  
  IF @@error <> 0  
     BEGIN                
        RAISERROR 2067005 "Error en los cambios de la tabla [parametros_cv]"  
        RETURN 1    
     END  
  
  
/* ### DEFNCOPY: END OF DEFINITION */  
    
END  