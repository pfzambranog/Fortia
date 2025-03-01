--EXEC [dbo].[SP_NOMINA_TABULAR_XLS] @ClaEmp=1,@ClaUsuario=2,  
--@ClaUniNeg=0,@ClaRz=1,@ClaPer=1,@ClaUbicacion=0,  
--@ClaRegImss=0,@ClaCentroCosto=0,@ClaDepto=0,  
--@Anio=2025,@MesIni=1,@MesFin=1,@TipoNom='0',  
--@Nominas='202510002',@ClaTrab=0,@TipoConcepto=0,@ClaPerded=0,  
--@MostrarMonto=0,@MostrarGravExen=0,@MostrarGravImss=0,  
--@MostrarTodos=1,@MostrarProv=0,@DetalladoXNom=0,  
--@IncluirNomAbiertas=1,@statusNom=1  
  
  
CREATE   PROCEDURE SP_NOMINA_TABULAR_XLS    
( @ClaEmp INT,    
 @ClaUsuario INT ,    
 @ClaUniNeg INT,    
 @ClaRz INT,    
 @ClaPer VARCHAR(MAX),     
 @ClaUbicacion VARCHAR(MAX),    
 @ClaRegImss VARCHAR(MAX),    
 @ClaCentroCosto VARCHAR(MAX),    
 @ClaDepto VARCHAR(MAX),    
 @Anio INT,    
 @MesIni INT,    
 @MesFin INT,    
 @TipoNom VARCHAR(MAX),     
 @Nominas VARCHAR(MAX),    
 @ClaTrab VARCHAR(MAX),    
 @TipoConcepto INT,    
 @ClaPerded VARCHAR(MAX),    
 @MostrarMonto INT,    
 @MostrarGravExen INT,    
 @MostrarGravImss INT,    
 @MostrarTodos INT,    
 @MostrarProv INT,    
 @DetalladoXNom INT,    
 @IncluirNomAbiertas INT,    
 @statusNom  INT    
)           
AS    
BEGIN    
     
 if not exists ( select CLA_GPO_USUARIO     
      from SYS_DET_GPO_USUARIO    
      where CLA_USUARIO = @ClaUsuario    
      and  CLA_GPO_USUARIO in (select VALOR_VAR_USUARIO     
             from RH_VAR_USUARIO     
             where CLA_VAR  = '$GPOUSRREP'     
             and  CLA_EMPRESA = @ClaEmp))    
  and   (convert(int,@TipoNom) in ( select VALOR_VAR_USUARIO     
            from RH_VAR_USUARIO     
            where CLA_VAR  = '$TIPONOMRP'     
            and  CLA_EMPRESA = @ClaEmp)     
     or convert(int,@Nominas)/1000%100 in ( select VALOR_VAR_USUARIO     
               from RH_VAR_USUARIO     
               where CLA_VAR  = '$TIPONOMRP'     
               and  CLA_EMPRESA = @ClaEmp))    
 begin      
  goto fin    
 end    
    
 DECLARE    
  @AnioMesIni INT,    
  @AnioMesFin INT,    
  @IdEnc INT,    
  @OrdenMin INT,    
  @Id INT,    
  @NumCamposMin INT,    
  @NumCamposMax INT,    
  @ClaveConcepto VARCHAR(MAX),    
  @ColumnaMonto VARCHAR(MAX),    
  @ColumnaNombre VARCHAR(MAX),    
  @ColumnaGravado VARCHAR(MAX),    
  @ColumnaExento VARCHAR(MAX),    
  @ColumnaGravImss VARCHAR(MAX),    
  @AlterColumnaMonto VARCHAR(MAX),    
  @AlterColumnaNombre VARCHAR(MAX),    
  @AlterColumnaGravado VARCHAR(MAX),    
  @AlterColumnaExento VARCHAR(MAX),    
  @AlterColumnaGravImss VARCHAR(MAX),    
  @Update VARCHAR(MAX),    
  @Select VARCHAR(MAX),    
  @SelectCampos VARCHAR(MAX),    
  @SelectColumna VARCHAR(MAX),    
  @ColInsert VARCHAR(MAX)    
     
 CREATE TABLE #tmpFinal    
 (      
  CONCECUTIVO INT IDENTITY ,    
  Columna1 VARCHAR(500),    
  Columna2 VARCHAR(500),    
  Columna3 VARCHAR(500),    
  Columna4 VARCHAR(500),    
  Columna5 VARCHAR(500),    
  Columna6 VARCHAR(500),    
  Columna7 VARCHAR(500),    
  Columna8 VARCHAR(500),    
  Columna9 VARCHAR(500),    
  Columna10 VARCHAR(500),    
  Columna11 VARCHAR(500),    
  Columna12 VARCHAR(500),    
  Columna13 VARCHAR(500),    
  Columna14 VARCHAR(500),    
  Columna15 VARCHAR(500),    
  Columna16 VARCHAR(500),    
  Columna17 VARCHAR(500),    
  Columna18 VARCHAR(500),    
  Columna19 VARCHAR(500),    
  Columna20 VARCHAR(500),    
  Columna21 VARCHAR(500),    
  Columna22 VARCHAR(500),    
  Columna23 VARCHAR(500),    
  Columna24 VARCHAR(500),    
  Columna25 VARCHAR(500),    
  Columna26 VARCHAR(500),    
  Columna27 VARCHAR(500),    
  Columna28 VARCHAR(500),    
  Columna29 VARCHAR(500),    
  Columna30 VARCHAR(500),    
  Columna31 VARCHAR(500),    
  Columna32 VARCHAR(500),    
  Columna33 VARCHAR(500),    
  Columna34 VARCHAR(500),    
  Columna35 VARCHAR(500),    
  Columna36 VARCHAR(500),    
  Columna37 VARCHAR(500),    
  Columna38 VARCHAR(500),    
  Columna39 VARCHAR(500),    
  Columna40 VARCHAR(500),    
  Columna41 VARCHAR(500),    
  Columna42 VARCHAR(500),    
  Columna43 VARCHAR(500),    
  Columna44 VARCHAR(500),    
  Columna45 VARCHAR(500),    
  Columna46 VARCHAR(500),    
  Columna47 VARCHAR(500),    
  Columna48 VARCHAR(500),    
  Columna49 VARCHAR(500),    
  Columna50 VARCHAR(500),    
  Columna51 VARCHAR(500),    
  Columna52 VARCHAR(500),    
  Columna53 VARCHAR(500),    
  Columna54 VARCHAR(500),    
  Columna55 VARCHAR(500),    
  Columna56 VARCHAR(500),    
  Columna57 VARCHAR(500),    
  Columna58 VARCHAR(500),    
  Columna59 VARCHAR(500),    
  Columna60 VARCHAR(500),    
  Columna61 VARCHAR(500),    
  Columna62 VARCHAR(500),    
  Columna63 VARCHAR(500),    
  Columna64 VARCHAR(500),    
  Columna65 VARCHAR(500),    
  Columna66 VARCHAR(500),    
  Columna67 VARCHAR(500),    
  Columna68 VARCHAR(500),    
  Columna69 VARCHAR(500),    
  Columna70 VARCHAR(500),    
  Columna71 VARCHAR(500),    
  Columna72 VARCHAR(500),    
  Columna73 VARCHAR(500),    
  Columna74 VARCHAR(500),    
  Columna75 VARCHAR(500),    
  Columna76 VARCHAR(500),    
  Columna77 VARCHAR(500),    
  Columna78 VARCHAR(500),    
  Columna79 VARCHAR(500),    
  Columna80 VARCHAR(500),    
  Columna81 VARCHAR(500),    
  Columna82 VARCHAR(500),    
  Columna83 VARCHAR(500),    
  Columna84 VARCHAR(500),    
  Columna85 VARCHAR(500),    
  Columna86 VARCHAR(500),    
  Columna87 VARCHAR(500),    
  Columna88 VARCHAR(500),    
  Columna89 VARCHAR(500),    
  Columna90 VARCHAR(500),    
  Columna91 VARCHAR(500),    
  Columna92 VARCHAR(500),    
  Columna93 VARCHAR(500),    
  Columna94 VARCHAR(500),    
  Columna95 VARCHAR(500),    
  Columna96 VARCHAR(500),    
  Columna97 VARCHAR(500),    
  Columna98 VARCHAR(500),    
  Columna99 VARCHAR(500),    
  Columna100 VARCHAR(500),    
  Columna101 VARCHAR(500),    
  Columna102 VARCHAR(500),    
  Columna103 VARCHAR(500),    
  Columna104 VARCHAR(500),    
  Columna105 VARCHAR(500),    
  Columna106 VARCHAR(500),    
  Columna107 VARCHAR(500),    
  Columna108 VARCHAR(500),    
  Columna109 VARCHAR(500),    
  Columna110 VARCHAR(500),    
  Columna111 VARCHAR(500),    
  Columna112 VARCHAR(500),    
  Columna113 VARCHAR(500),    
  Columna114 VARCHAR(500),    
  Columna115 VARCHAR(500),    
  Columna116 VARCHAR(500),    
  Columna117 VARCHAR(500),    
  Columna118 VARCHAR(500),    
  Columna119 VARCHAR(500),    
  Columna120 VARCHAR(500),    
  Columna121 VARCHAR(500),    
  Columna122 VARCHAR(500),    
  Columna123 VARCHAR(500),    
  Columna124 VARCHAR(500),    
  Columna125 VARCHAR(500),    
  Columna126 VARCHAR(500),    
  Columna127 VARCHAR(500),    
  Columna128 VARCHAR(500),    
  Columna129 VARCHAR(500),    
  Columna130 VARCHAR(500),    
  Columna131 VARCHAR(500),    
  Columna132 VARCHAR(500),    
  Columna133 VARCHAR(500),    
  Columna134 VARCHAR(500),    
  Columna135 VARCHAR(500),    
  Columna136 VARCHAR(500),    
  Columna137 VARCHAR(500),    
  Columna138 VARCHAR(500),    
  Columna139 VARCHAR(500),    
  Columna140 VARCHAR(500),    
  Columna141 VARCHAR(500),    
  Columna142 VARCHAR(500),    
  Columna143 VARCHAR(500),    
  Columna144 VARCHAR(500),    
  Columna145 VARCHAR(500),    
  Columna146 VARCHAR(500),    
  Columna147 VARCHAR(500),    
  Columna148 VARCHAR(500),    
  Columna149 VARCHAR(500),    
  Columna150 VARCHAR(500)    
 )     
    
 CREATE TABLE #ColumnasNoAplica    
 (    
  NomColumna VARCHAR(MAX)    
 )    
    
 INSERT  #ColumnasNoAplica    
 (    
     NomColumna    
 )    
 VALUES  ('CLA_EMPRESA') ,    
            ('CLA_PERIODO') ,    
            ('ANIO_MES') ,    
            ('NUM_NOMINA') ,    
            ('CLA_REG_IMSS') ,    
           ('CLA_RAZON_SOCIAL'),    
   ('CLA_UBICACION'),    
  ('CLA_CENTRO_COSTO'),    
  ('CLA_DEPTO'),    
  ('CLA_PUESTO'),    
   ('NOMBRE'),      
   ('CLA_AREA'),    
   ('CLA_CLASIFICACION'),    
   ('CLA_BANCO'),    
   ('CLA_FORMA_PAGO'),    
   ('CLA_ROLL'),    
   ('CLA_TAB_SUE')    
 --  ('NOM_DEPTO'),  
 --   ('NOM_UBICACION'),  
 --('NOM_PUESTO'),  
 --('NOM_PERIODO'),  
  
 --('FECHA_ING'),  
 --('FECHA_ING_GRUPO'),  
 --('NSS'),    
 --  ('RFC')  
  
  
 if @ClaUsuario in (3) and @TipoNom in ('68')    
 begin    
  INSERT  #ColumnasNoAplica    
  (    
   NomColumna    
  )    
  VALUES  ('SUE_INT') ,    
    ('TOT_PER')      
      
 end    
    
 CREATE CLUSTERED INDEX I_tmpFinal ON #tmpFinal(CONCECUTIVO)    
     
      
IF @MesIni>0    
SELECT @AnioMesIni=(@Anio*100)+@MesIni    
ELSE     
SELECT @AnioMesIni=(@Anio*100)+1    
    
IF @MesFin>0    
SELECT @AnioMesFin=(@Anio*100)+@MesFin      
ELSE    
SELECT @AnioMesFin=(@Anio*100)+12      
    
select      
  @ClaUbicacion='['+REPLACE(ISNULL(@ClaUbicacion,'0'),',','],[')+']',     
  @ClaRegImss='['+REPLACE(ISNULL(@ClaRegImss,'0'),',','],[')+']',     
  @ClaCentroCosto ='['+REPLACE(ISNULL(@ClaCentroCosto,'0'),',','],[')+']',     
  @ClaDepto ='['+REPLACE(ISNULL(@ClaDepto,'0'),',','],[')+']',     
  @TipoNom ='['+REPLACE(ISNULL(@TipoNom,'0'),',','],[')+']'     
  if @Nominas is not null    
   select @Nominas ='['+ISNULL(@ClaPer,'0')+'-'+REPLACE(REPLACE(ISNULL(@Nominas,'0'),SPACE(1),''),',','],['+ISNULL(@ClaPer,'0')+'-')+']'    
select     
  @ClaPer='['+REPLACE(ISNULL(@ClaPer,'0'),',','],[')+']',     
  @ClaTrab='['+REPLACE(ISNULL(@ClaTrab,'0'),',','],[')+']',      
  @ClaPerded ='['+REPLACE(ISNULL(@ClaPerded,'0'),',','],[')+']',    
  @MostrarTodos=ISNULL(@MostrarTodos,0),    
  @MostrarProv=ISNULL(@MostrarProv,0),    
  @ClaUniNeg=ISNULL(@ClaUniNeg,0),    
  @TipoConcepto=ISNULL(@TipoConcepto,0),    
  @DetalladoXNom=ISNULL(@DetalladoXNom,0)    
    
  --SELECT @Nominas    
 SELECT  t1.CLA_EMPRESA,    
    t1.CLA_PERIODO,    
    t1.NUM_NOMINA,    
    t1.ANIO_MES,    
    t1.INICIO_PER,    
    t1.FIN_PER,    
    t2.CLA_RAZON_SOCIAL,    
    t1.ANIO_MES/100 ANIO,    
    t2.NOM_PERIODO,    
    t3.NOM_RAZON_SOCIAL,    
    t4.NOM_TIPO_NOMINA,    
    '['+RTRIM(LTRIM(STR(T1.CLA_PERIODO)))+'-'+RTRIM(LTRIM(STR(T1.NUM_NOMINA)))+']'STRING    
 INTO  #tmpNominas    
 FROM  dbo.RH_FECHA_PER t1     
 INNER JOIN dbo.RH_PERIODO t2     
  ON  t2.CLA_EMPRESA = t1.CLA_EMPRESA     
  AND  t2.CLA_PERIODO = t1.CLA_PERIODO     
  --AND t1.ANIO_MES>=@AnioMesIni AND t1.ANIO_MES<=@AnioMesFin    
 INNER JOIN dbo.RH_RAZON_SOCIAL t3     
  ON  t3.CLA_EMPRESA = t2.CLA_EMPRESA     
  AND  t3.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL    
 INNER JOIN dbo.RH_TIPO_NOMINA t4     
  ON  t4.TIPO_NOMINA = t1.TIPO_NOMINA    
 WHERE  t1.CLA_EMPRESA=@ClaEmp     
 AND   (CHARINDEX('['+CONVERT(VARCHAR,T1.CLA_PERIODO)+']',@ClaPer)>0 OR @ClaPer='[0]')     
 AND         (CHARINDEX('['+CONVERT(VARCHAR(2),T1.TIPO_NOMINA)+']',@TipoNom)>0 OR @TipoNom='[0]')     
 AND   (CHARINDEX('['+RTRIM(LTRIM(STR(T1.CLA_PERIODO)))+'-'+RTRIM(LTRIM(STR(T1.NUM_NOMINA)))+']',@Nominas)> 0 OR @Nominas='[0]')    
 AND   t2.CLA_RAZON_SOCIAL=@ClaRz       
 AND   T1.STATUS_NOMINA = @statusNom --GVC    
        
 IF @Nominas is null    
 BEGIN      
  INSERT #tmpNominas    
  SELECT  t1.CLA_EMPRESA,    
     t1.CLA_PERIODO,    
     t1.NUM_NOMINA,    
     t1.ANIO_MES,    
     t1.INICIO_PER,    
     t1.FIN_PER,    
     t2.CLA_RAZON_SOCIAL,    
     t1.ANIO_MES/100 ANIO,    
     t2.NOM_PERIODO,    
     t3.NOM_RAZON_SOCIAL,    
     t4.NOM_TIPO_NOMINA,    
     '['+RTRIM(LTRIM(STR(T1.CLA_PERIODO)))+'-'+RTRIM(LTRIM(STR(T1.NUM_NOMINA)))+']'STRING    
  FROM  dbo.RH_FECHA_PER t1     
  INNER JOIN dbo.RH_PERIODO t2     
   ON  t2.CLA_EMPRESA = t1.CLA_EMPRESA     
   AND  t2.CLA_PERIODO = t1.CLA_PERIODO     
   --AND t1.ANIO_MES>=@AnioMesIni AND t1.ANIO_MES<=@AnioMesFin    
  INNER JOIN dbo.RH_RAZON_SOCIAL t3     
   ON  t3.CLA_EMPRESA = t2.CLA_EMPRESA     
   AND  t3.CLA_RAZON_SOCIAL = t2.CLA_RAZON_SOCIAL    
  INNER JOIN dbo.RH_TIPO_NOMINA t4     
   ON  t4.TIPO_NOMINA = t1.TIPO_NOMINA    
  WHERE  t1.CLA_EMPRESA=@ClaEmp     
  AND   (CHARINDEX('['+CONVERT(VARCHAR,T1.CLA_PERIODO)+']',@ClaPer)>0 OR @ClaPer='[0]')     
  AND   (CHARINDEX('['+CONVERT(VARCHAR(2),T1.TIPO_NOMINA)+']',@TipoNom)>0 OR @TipoNom='[0]')     
  AND   t2.CLA_RAZON_SOCIAL=@ClaRz       
  AND   t1.anio_mes between cast(@Anio as varchar) + right('00'+cast(@MesIni as varchar),2)     
  AND   cast(@Anio as varchar) + right('00'+cast(@MesFin as varchar),2)    
  AND   T1.STATUS_NOMINA = @statusNom --GVC    
       
 END    
     
 SELECT  CLA_TRAB ,    
            CLA_EMPRESA ,    
            UPPER(RTRIM(NOM_TRAB)) NOM_TRAB ,    
UPPER(RTRIM(AP_PATERNO)) AP_PATERNO ,    
            UPPER(RTRIM(AP_MATERNO)) AP_MATERNO ,    
   UPPER(RTRIM(AP_PATERNO)) +SPACE(1)+UPPER(RTRIM(AP_MATERNO))+SPACE(1)+UPPER(RTRIM(NOM_TRAB)) NOMBRE,    
            RTRIM(NUM_IMSS) NSS ,    
            RTRIM(CURP) CURP ,    
            RTRIM(RFC) RFC,    
   CONVERT(VARCHAR, FECHA_ING, 101) AS FECHA_ING,  --JM  
   CONVERT(VARCHAR, FECHA_ING_GRUPO, 101) AS FECHA_ING_GRUPO,  --JM  
   FECHA_INI_DESCINF,    
   FECHA_SUSP_DESC_INF,    
   CTA_BANCO,    
   CASE WHEN ISNULL(SIND,0)=0 THEN 'NO SINDICALIZADO' ELSE 'SINDICALIZADO' END SINDICALIZADO,    
   CLA_BANCO,    
   CASE TIPO_SALARIO WHEN 0 THEN 'FIJO' WHEN 1 THEN 'VARIABLE' WHEN 2 THEN 'MIXTO'  ELSE '' END TIPO_SALARIO    
    INTO    #tmpTrabNombres    
    FROM    dbo.RH_TRAB    
    WHERE   CLA_EMPRESA = @ClaEmp          
    AND dbo.fnc_ValidaSysSeguridadStd(10, CLA_EMPRESA, @ClaUsuario, CLA_UBICACION_BASE, CLA_DEPTO, CLA_PERIODO) > 0      AND    (CHARINDEX('['+CONVERT(VARCHAR,CLA_TRAB)+']',@ClaTrab)>0 OR @ClaTrab='[0]')    
     
 CREATE TABLE #tmpPerded1    
 (CLA_PERDED INT,CLA_EMPRESA INT,NOM_PERDED VARCHAR(MAX),TIPO_PERDED INT,CLASIFICACION INT,ES_PROVISION INT,ESBASE_IMSS INT, NO_AFECTAR_NETO INT, ESBASE_ISPT INT, ORDEN INT, MOSTRAR_MONTO VARCHAR(MAX))    
    
 IF @statusNom = 9    
 BEGIN    
   INSERT #tmpPerded1    
   SELECT      
   DISTINCT t1.CLA_PERDED,    
     t1.CLA_EMPRESA ,    
     'C'+CONVERT(VARCHAR,t1.CLA_PERDED)+'_'+UPPER(REPLACE(    
                 REPLACE(REPLACE(    
                  REPLACE(    
                   REPLACE(    
                    REPLACE(    
                     REPLACE(    
                      REPLACE(     
                        REPLACE(REPLACE(REPLACE(    
                         REPLACE(RTRIM(LTRIM(T1.NOM_PERDED)),')','_')    
                                  ,'(','_'),'%',''),'.',''),'-',''),'/',''),'$',''),'.',''),' ','_'),char(13),''),char(10),''),char(9),''))NOM_PERDED ,    
     t1.TIPO_PERDED ,    
     T1.CLASIFICACION,    
     T1.ES_PROVISION,    
     T1.ESBASE_IMSS,    
     T1.NO_AFECTAR_NETO,    
     T1.ESBASE_ISPT,    
     T1.ORDEN,    
     NULL MOSTRAR_MONTO    
   FROM    dbo.RH_PERDED T1    
    INNER JOIN RH_DET_REC_HISTO T2    
     ON T1.CLA_EMPRESA = T2.CLA_EMPRESA    
     AND T1.CLA_PERDED = T2.CLA_PERDED    
     AND T1.CLA_EMPRESA = T2.CLA_EMPRESA    
    INNER JOIN #tmpNominas T3    
     ON T2.NUM_NOMINA = T3.NUM_NOMINA    
     AND T2.CLA_PERIODO = T3.CLA_PERIODO    
     AND T2.CLA_EMPRESA = T3.CLA_EMPRESA    
   WHERE T1.CLA_EMPRESA = @ClaEmp AND      
     (T1.TIPO_PERDED=@TipoConcepto  OR @TipoConcepto=0) AND    
        (     
         (t1.NO_AFECTAR_NETO=1 AND  @MostrarTodos=1 AND T1.ES_PROVISION=0) OR     
         (t1.NO_AFECTAR_NETO=1 AND  @MostrarProv=1 AND T1.ES_PROVISION=1)  OR     
         (T1.NO_AFECTAR_NETO=0  AND (CHARINDEX('['+CONVERT(VARCHAR,T1.CLA_PERDED)+']',@ClaPerded)>0  OR @ClaPerded='[0]') )    
         )    
   ORDER BY NO_AFECTAR_NETO,ES_PROVISION,TIPO_PERDED,ORDEN,CLA_PERDED;        
 END    
 ELSE BEGIN    
  INSERT #tmpPerded1    
  SELECT  DISTINCT t1.CLA_PERDED,    
     t1.CLA_EMPRESA ,    
     'C'+CONVERT(VARCHAR,t1.CLA_PERDED)+'_'+UPPER(REPLACE(    
                 REPLACE(REPLACE(    
                  REPLACE(    
                   REPLACE(    
                    REPLACE(    
                     REPLACE(    
                      REPLACE(     
                        REPLACE(REPLACE(REPLACE(    
                         REPLACE(RTRIM(LTRIM(T1.NOM_PERDED)),')','_')    
                                  ,'(','_'),'%',''),'.',''),'-',''),'/',''),'$',''),'.',''),' ','_'),char(13),''),char(10),''),char(9),''))NOM_PERDED ,    
     t1.TIPO_PERDED ,    
     T1.CLASIFICACION,    
     T1.ES_PROVISION,    
     T1.ESBASE_IMSS,    
     T1.NO_AFECTAR_NETO,    
     T1.ESBASE_ISPT,    
     T1.ORDEN,    
     NULL MOSTRAR_MONTO    
   FROM    dbo.RH_PERDED T1    
    INNER JOIN RH_DET_REC_ACTUAL T2    
     ON T1.CLA_EMPRESA = T2.CLA_EMPRESA    
     AND T1.CLA_PERDED = T2.CLA_PERDED   
     AND T1.CLA_EMPRESA = T2.CLA_EMPRESA    
    INNER JOIN #tmpNominas T3    
     ON T2.NUM_NOMINA = T3.NUM_NOMINA    
     AND T2.CLA_PERIODO = T3.CLA_PERIODO    
     AND T2.CLA_EMPRESA = T3.CLA_EMPRESA    
   WHERE   T1.CLA_EMPRESA = @ClaEmp AND      
     (T1.TIPO_PERDED=@TipoConcepto  OR @TipoConcepto=0) AND    
        (     
         (t1.NO_AFECTAR_NETO=1 AND  @MostrarTodos=1 AND T1.ES_PROVISION=0) OR     
         (t1.NO_AFECTAR_NETO=1 AND  @MostrarProv=1 AND T1.ES_PROVISION=1)  OR     
         (T1.NO_AFECTAR_NETO=0  AND (CHARINDEX('['+CONVERT(VARCHAR,T1.CLA_PERDED)+']',@ClaPerded)>0  OR @ClaPerded='[0]') )    
         )    
   ORDER BY NO_AFECTAR_NETO,ES_PROVISION,TIPO_PERDED,ORDEN,CLA_PERDED;        
     
 END    
    
 SELECT IDENTITY(INT,1,1)ID,*    
 INTO #tmpPerded    
 FROM #tmpPerded1 T1    
    
 if @ClaUsuario in (3) and @TipoNom in ('68')    
 begin    
  delete #tmpPerded where CLA_PERDED in (280,2103,2104,2105,2106,2107)    
  delete #tmpPerded where CLA_PERDED in (280,2103,2104,2105,2106,2107)    
 end    
    
 SELECT T1.CLA_EMPRESA,T1.CLA_UBICACION,RTRIM(LTRIM(T1.NOM_UBICACION))NOM_UBICACION--,ISNULL(T2.CLA_UNI_NEG,0)CLA_UNI_NEG,ISNULL(T2.NOM_UNI_NEG,'')NOM_UNI_NEG    
 INTO #tmpUbicacion    
 FROM dbo.RH_UBICACION T1     
 WHERE  (CHARINDEX('['+CONVERT(VARCHAR,T1.CLA_UBICACION)+']',@ClaUbicacion)>0 OR @ClaUbicacion='[0]')    
    
 SELECT CLA_EMPRESA,CLA_REG_IMSS,RTRIM(LTRIM(NUM_REG_IMSS))NUM_REG_IMSS,RTRIM(LTRIM(NOM_REG_IMSS))NOM_REG_IMSS    
 INTO #tmpRegImss    
 FROM dbo.RH_REG_IMSS     
 WHERE CLA_EMPRESA=@ClaEmp AND      
    (CHARINDEX('['+CONVERT(VARCHAR,CLA_REG_IMSS)+']',@ClaRegImss)>0 OR @ClaRegImss='[0]')    
        
 SELECT CLA_EMPRESA,CLA_CENTRO_COSTO,RTRIM(LTRIM(NOM_CENTRO_COSTO))NOM_CENTRO_COSTO    
 INTO #tmpCC    
 FROM dbo.RH_CENTRO_COSTO     
 WHERE CLA_EMPRESA=@ClaEmp AND      
    (CHARINDEX('['+CONVERT(VARCHAR,CLA_CENTRO_COSTO)+']',@ClaCentroCosto)>0 OR @ClaCentroCosto='[0]')     
    
 SELECT t1.CLA_EMPRESA,t1.CLA_DEPTO,RTRIM(LTRIM(t1.NOM_DEPTO))NOM_DEPTO,t2.CLA_AREA,ISNULL(RTRIM(LTRIM(t2.NOM_AREA)),'')NOM_AREA    
 INTO #tmpDepto    
 FROM dbo.RH_DEPTO t1 LEFT JOIN dbo.RH_AREA t2 ON t2.CLA_EMPRESA = t1.CLA_EMPRESA AND t2.CLA_AREA = t1.CLA_AREA    
 WHERE t1.CLA_EMPRESA=@ClaEmp AND      
    (CHARINDEX('['+CONVERT(VARCHAR,t1.CLA_DEPTO)+']',@ClaDepto)>0 OR @ClaDepto='[0]')    
    
 SELECT t1.CLA_PUESTO,t1.CLA_EMPRESA,RTRIM(LTRIM(t1.NOM_PUESTO))NOM_PUESTO         
 INTO #tmpPuesto    
 FROM dbo.RH_PUESTO t1      
 WHERE t1.CLA_EMPRESA=@ClaEmp     
    
 SELECT CLA_EMPRESA,CLA_FORMA_PAGO,NOM_FORMA_PAGO     
 INTO #tmpFormaPago    
 FROM dbo.RH_FORMA_PAGO    
 WHERE CLA_EMPRESA=@ClaEmp    
    
 SELECT CLA_BANCO,NOM_BANCO    
 INTO #tmpBanco    
 FROM dbo.RH_BANCO    
    
 SELECT CLA_EMPRESA,CLA_CLASIFICACION,NOM_CLASIFICACION    
 INTO #tmpClasificacion     
 FROM dbo.RH_CLASIFICACION    
 WHERE CLA_EMPRESA=@ClaEmp    
     
 SELECT CLA_EMPRESA,CLA_ROLL,NOM_ROLL     
 INTO #tmpRoll    
 FROM dbo.RH_ROLL_TURNO    
 WHERE CLA_EMPRESA=@ClaEmp AND NOT EXISTS(SELECT VALOR_DATO_INT1 FROM dbo.RH_DET_CONFIG_GENERAL WHERE CLA_DATO=27 AND VALOR_DATO_INT1=1)    
 UNION    
 SELECT CLA_EMPRESA,CLA_PERFIL_TURNO,NOM_PERFIL_TURNO    
 FROM dbo.RELOJ_PERFIL_TURNO    
 WHERE CLA_EMPRESA=@ClaEmp AND EXISTS(SELECT VALOR_DATO_INT1 FROM dbo.RH_DET_CONFIG_GENERAL WHERE CLA_DATO=27 AND VALOR_DATO_INT1=1)    
    
 SELECT CLA_EMPRESA,CLA_TAB_SUE,NOM_TAB_SUE    
 INTO #tmpTabSue    
 FROM dbo.RH_TAB_SUE    
 WHERE CLA_EMPRESA=@ClaEmp    
     
 CREATE CLUSTERED INDEX I_tmpNominas ON #tmpNominas(CLA_EMPRESA,CLA_PERIODO,NUM_NOMINA,ANIO_MES,CLA_RAZON_SOCIAL)    
 CREATE CLUSTERED INDEX I_tmpUbicacion ON #tmpUbicacion(CLA_EMPRESA,CLA_UBICACION)    
 CREATE CLUSTERED INDEX I_tmpRegImss ON #tmpRegImss(CLA_EMPRESA,CLA_REG_IMSS)    
 CREATE CLUSTERED INDEX I_tmpCC ON #tmpCC(CLA_EMPRESA,CLA_CENTRO_COSTO)    
 CREATE CLUSTERED INDEX I_tmpDepto ON #tmpDepto(CLA_EMPRESA,CLA_DEPTO)    
 CREATE CLUSTERED INDEX I_tmpPerded ON #tmpPerded(CLA_EMPRESA,CLA_PERDED)    
 CREATE CLUSTERED INDEX I_tmpTrabNombres ON #tmpTrabNombres(CLA_EMPRESA,CLA_TRAB)    
 CREATE CLUSTERED INDEX I_tmpFormaPago ON #tmpFormaPago(CLA_EMPRESA,CLA_FORMA_PAGO)    
 CREATE CLUSTERED INDEX I_tmpClasificacion ON #tmpClasificacion(CLA_EMPRESA,CLA_CLASIFICACION)    
 CREATE CLUSTERED INDEX I_tmpRoll ON #tmpRoll(CLA_EMPRESA,CLA_ROLL)    
 CREATE CLUSTERED INDEX I_tmpTabSue ON #tmpTabSue(CLA_EMPRESA,CLA_TAB_SUE)    
        
 SELECT      
   T1.CLA_EMPRESA,    
   T1.CLA_RAZON_SOCIAL,    
   T1.CLA_PERIODO,    
   t1.NUM_NOMINA ,    
   t7.NOM_AREA,   
   t5.CLA_UBICACION,  
   t5.NOM_UBICACION,  
   T7.NOM_DEPTO, --- JM AGREGO CAMPOS    
   t13.NOM_PUESTO,    
   t1.NOM_PERIODO,    
   t2.CLA_TRAB,    
   LTRIM(RTRIM(t3.AP_PATERNO))+' '+    
   LTRIM(RTRIM(t3.AP_MATERNO))+' '+    
   LTRIM(RTRIM(t3.NOM_TRAB))+' ' NOM_TRAB,    
   CONVERT(VARCHAR, t3.FECHA_ING, 101) AS FECHA_ING,  --JM  
   CONVERT(VARCHAR, t3.FECHA_ING_GRUPO, 101) AS FECHA_ING_GRUPO,  --JM  
   t3.NSS,    
   t3.RFC,    
   T2.ANIO_MES,    
   CONVERT(VARCHAR(10),T1.INICIO_PER,103)INICIO_PER,    
   CONVERT(VARCHAR(10),T1.FIN_PER,103)FIN_PER,    
   CAST(t2.SUE_DIA AS DECIMAL(10,2))SUE_DIA,    
   CAST(t2.SUE_INT AS DECIMAL(10,2))SUE_INT,    
   CAST(t2.TOT_PER AS DECIMAL(10,2))TOT_PER,    
   CAST(t2.TOT_DED AS DECIMAL(10,2))TOT_DED,    
   CAST(t2.TOT_NETO AS DECIMAL(10,2))TOT_NETO    
 INTO #tmpNominasTrab    
    FROM    #tmpNominas t1 INNER JOIN dbo.RH_ENC_REC_HISTO t2 ON t2.ANIO_MES = t1.ANIO_MES    
                  AND t2.CLA_EMPRESA = t1.CLA_EMPRESA    
                  AND t2.CLA_PERIODO = t1.CLA_PERIODO    
                  AND t2.NUM_NOMINA = t1.NUM_NOMINA    
  
     
       INNER JOIN #tmpTrabNombres t3 ON t3.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                   t3.CLA_TRAB = t2.CLA_TRAB     
       INNER JOIN #tmpRegImss t4 ON t4.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t4.CLA_REG_IMSS = t2.CLA_REG_IMSS    
       INNER JOIN #tmpUbicacion t5 ON t5.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                 t5.CLA_UBICACION=t2.CLA_UBICACION_BASE    
       
       INNER JOIN #tmpCC t6 ON t6.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                 t6.CLA_CENTRO_COSTO = t2.CLA_CENTRO_COSTO    
       INNER JOIN #tmpDepto t7 ON t7.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t7.CLA_DEPTO = t2.CLA_DEPTO                                                             
       LEFT JOIN #tmpFormaPago t8 ON t8.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t8.CLA_FORMA_PAGO = t2.CLA_FORMA_PAGO     
        LEFT JOIN #tmpBanco t9 ON t9.CLA_BANCO = t3.CLA_BANCO    
        INNER JOIN #tmpClasificacion t10 ON t10.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t10.CLA_CLASIFICACION = t2.CLA_CLASIFICACION     
        --   INNER JOIN #tmpRoll t11 ON t11.CLA_EMPRESA = t2.CLA_EMPRESA AND     
      --        t11.CLA_ROLL=t2.CLA_ROLL    
        INNER JOIN #tmpTabSue t12 ON t12.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t12.CLA_TAB_SUE = t2.CLA_TAB_SUE    
        INNER JOIN #tmpPuesto t13 ON t13.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                   t13.CLA_PUESTO = t2.CLA_PUESTO    
 CREATE CLUSTERED INDEX I_tmpNominasTrab ON #tmpNominasTrab(CLA_TRAB,CLA_EMPRESA,CLA_PERIODO,ANIO_MES,NUM_NOMINA)    
      
 IF @IncluirNomAbiertas=1 and @statusNom = 1    
     INSERT INTO #tmpNominasTrab    
      SELECT       
   T1.CLA_EMPRESA,    
   T1.CLA_RAZON_SOCIAL,    
   T1.CLA_PERIODO,    
   t1.NUM_NOMINA ,    
   t7.NOM_AREA,  
   t5.CLA_UBICACION,  
   t5.NOM_UBICACION,    
   t7.NOM_DEPTO,  --JM  
   t13.NOM_PUESTO,    
   t1.NOM_PERIODO,    
   t2.CLA_TRAB,    
   LTRIM(RTRIM(t3.AP_PATERNO))+' '+    
   LTRIM(RTRIM(t3.AP_MATERNO))+' '+    
   LTRIM(RTRIM(t3.NOM_TRAB))+' ' NOM_TRAB,   
   CONVERT(VARCHAR, t3.FECHA_ING, 101) AS FECHA_ING,  --JM  
   CONVERT(VARCHAR, t3.FECHA_ING_GRUPO, 101) AS FECHA_ING_GRUPO,  --JM  
   t3.NSS,    
   t3.RFC,    
   T2.ANIO_MES_ISPT ANIO_MES,    
   CONVERT(VARCHAR(10),T1.INICIO_PER,103)INICIO_PER,    
   CONVERT(VARCHAR(10),T1.FIN_PER,103)FIN_PER,    
   CAST(t2.SUE_DIA AS DECIMAL(10,2))SUE_DIA,    
 CAST(t2.SUE_INT AS DECIMAL(10,2))SUE_INT,    
   CAST(t2.TOT_PER AS DECIMAL(10,2))TOT_PER,    
   CAST(t2.TOT_DED AS DECIMAL(10,2))TOT_DED,    
   CAST(t2.TOT_NETO AS DECIMAL(10,2))TOT_NETO    
    FROM    #tmpNominas t1 INNER JOIN dbo.RH_ENC_REC_ACTUAL t2 ON t2.CLA_EMPRESA = t1.CLA_EMPRESA AND     
                  t2.CLA_PERIODO = t1.CLA_PERIODO AND     
                  t2.NUM_NOMINA = t1.NUM_NOMINA                    
       INNER JOIN #tmpTrabNombres t3 ON t3.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                   t3.CLA_TRAB = t2.CLA_TRAB     
       INNER JOIN #tmpRegImss t4 ON t4.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t4.CLA_REG_IMSS = t2.CLA_REG_IMSS    
       INNER JOIN #tmpUbicacion t5 ON t5.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                 t5.CLA_UBICACION=t2.CLA_UBICACION_BASE    
       INNER JOIN #tmpCC t6 ON t6.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                 t6.CLA_CENTRO_COSTO = t2.CLA_CENTRO_COSTO    
       INNER JOIN #tmpDepto t7 ON t7.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t7.CLA_DEPTO = t2.CLA_DEPTO     
       LEFT JOIN #tmpFormaPago t8 ON t8.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t8.CLA_FORMA_PAGO = t2.CLA_FORMA_PAGO     
       LEFT JOIN #tmpBanco t9 ON t9.CLA_BANCO = t3.CLA_BANCO    
       INNER JOIN #tmpClasificacion t10 ON t10.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t10.CLA_CLASIFICACION = t2.CLA_CLASIFICACION    
       --INNER JOIN #tmpRoll t11 ON t11.CLA_EMPRESA = t2.CLA_EMPRESA AND     
       --       t11.CLA_ROLL=t2.CLA_ROLL    
       INNER JOIN #tmpTabSue t12 ON t12.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                t12.CLA_TAB_SUE = t2.CLA_TAB_SUE    
          INNER JOIN #tmpPuesto t13 ON t13.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                   t13.CLA_PUESTO = t2.CLA_PUESTO    
        
    
         SELECT t1.CLA_TRAB,    
      MAX(t1.CLA_EMPRESA) CLA_EMPRESA,    
      t1.CLA_PERIODO,    
      t1.NUM_NOMINA,    
      MAX(t1.ANIO_MES)ANIO_MES,    
      T3.CLA_PERDED,    
      MAX(t3.NOM_PERDED)NOM_PERDED,    
      SUM(t2.MONTO)MONTO,    
      SUM(CAST(t2.IMPORTE AS DECIMAL(10,2)))IMPORTE,    
      SUM(CAST(t2.EXENTO AS DECIMAL(10,2)))EXENTO,    
      SUM(CAST(t2.IMPORTE-t2.EXENTO AS DECIMAL(10,2)))GRAVADO,    
      SUM(CAST(t2.GRAV_IMSS AS DECIMAL(10,2)))GRAV_IMSS,    
      MAX(T3.TIPO_PERDED)TIPO_PERDED,    
      MAX(t3.ES_PROVISION)ES_PROVISION,    
      MAX(t3.ESBASE_IMSS)ESBASE_IMSS,    
      MAX(t3.NO_AFECTAR_NETO)NO_AFECTAR_NETO,    
      MAX(t3.ESBASE_ISPT)ESBASE_ISPT,    
      MAX(t1.CLA_RAZON_SOCIAL)CLA_RAZON_SOCIAL,    
      MAX(t3.ORDEN)ORDEN    
  INTO #tmpPagosConceptos    
  FROM #tmpNominasTrab t1 INNER JOIN dbo.RH_DET_REC_HISTO t2 ON t2.ANIO_MES = t1.ANIO_MES AND     
                    t2.CLA_TRAB = t1.CLA_TRAB AND     
                    t2.CLA_EMPRESA = t1.CLA_EMPRESA AND     
                    t2.CLA_PERIODO = t1.CLA_PERIODO AND     
                    t2.NUM_NOMINA = t1.NUM_NOMINA    
           INNER JOIN #tmpPerded t3 ON t3.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                  t3.CLA_PERDED = t2.CLA_PERDED             
  GROUP BY t1.CLA_TRAB,t1.CLA_PERIODO,T3.CLA_PERDED,t1.NUM_NOMINA    
     
 IF @IncluirNomAbiertas=1 and @statusNom = 1    
    INSERT INTO #tmpPagosConceptos    
  SELECT t1.CLA_TRAB,    
      MAX(t1.CLA_EMPRESA) CLA_EMPRESA,    
      t1.CLA_PERIODO,    
      t1.NUM_NOMINA,    
      MAX(t1.ANIO_MES)ANIO_MES,    
      T3.CLA_PERDED,    
      MAX(t3.NOM_PERDED)NOM_PERDED,    
      SUM(t2.MONTO)MONTO,    
      SUM(CAST(t2.IMPORTE AS DECIMAL(10,2)))IMPORTE,    
      SUM(CAST(t2.RES_EXE_SQL AS DECIMAL(10,2)))EXENTO,    
      SUM(CAST(t2.IMPORTE-t2.RES_EXE_SQL AS DECIMAL(10,2)))GRAVADO,    
      SUM(CAST(t2.GRAV_IMSS AS DECIMAL(10,2)))GRAV_IMSS,    
      MAX(T3.TIPO_PERDED)TIPO_PERDED,    
      MAX(t3.ES_PROVISION)ES_PROVISION,    
      MAX(t3.ESBASE_IMSS)ESBASE_IMSS,    
      MAX(t3.NO_AFECTAR_NETO)NO_AFECTAR_NETO,    
      MAX(t1.CLA_RAZON_SOCIAL)CLA_RAZON_SOCIAL,    
      MAX(t3.ESBASE_ISPT)ESBASE_ISPT,   
      MAX(t3.ORDEN)ORDEN    
  FROM #tmpNominasTrab t1 INNER JOIN dbo.RH_DET_REC_ACTUAL t2 ON t2.CLA_TRAB = t1.CLA_TRAB AND     
                    t2.CLA_EMPRESA = t1.CLA_EMPRESA AND     
                    t2.CLA_PERIODO = t1.CLA_PERIODO AND     
                    t2.NUM_NOMINA = t1.NUM_NOMINA     
           INNER JOIN #tmpPerded t3 ON t3.CLA_EMPRESA = t2.CLA_EMPRESA AND     
                  t3.CLA_PERDED = t2.CLA_PERDED             
  GROUP BY t1.CLA_TRAB,t1.CLA_PERIODO,T3.CLA_PERDED,t1.NUM_NOMINA    
       
  CREATE CLUSTERED INDEX I_tmpPagosConceptos ON #tmpPagosConceptos(CLA_TRAB,CLA_EMPRESA,CLA_PERIODO,NUM_NOMINA,ANIO_MES)    
    
  SELECT @Id=MIN(ID) FROM #tmpPerded     
    
  WHILE @Id IS NOT NULL     
  BEGIN    
     SELECT     
      @ClaveConcepto=CONVERT(VARCHAR,CLA_PERDED),    
      @ColumnaNombre=NOM_PERDED,    
      @ColumnaMonto=CASE WHEN MOSTRAR_MONTO IS NOT NULL THEN NOM_PERDED+'_'+MOSTRAR_MONTO ELSE NULL END,    
       
      @AlterColumnaMonto='ALTER TABLE #tmpNominasTrab ADD '+CASE WHEN MOSTRAR_MONTO IS NOT NULL THEN NOM_PERDED+'_'+MOSTRAR_MONTO ELSE NULL END+' FLOAT NOT NULL DEFAULT(0)',    
      @AlterColumnaNombre='ALTER TABLE #tmpNominasTrab ADD '+NOM_PERDED+' FLOAT NOT NULL DEFAULT(0)'    
     FROM #tmpPerded    
     WHERE ID=@Id    
    
         
     IF @AlterColumnaMonto IS NOT NULL    
     BEGIN    
       EXECUTE(@AlterColumnaMonto)     
     END    
    
     IF @AlterColumnaNombre IS NOT NULL    
     BEGIN    
       EXECUTE(@AlterColumnaNombre)      
     END    
    
        SELECT @Update= 'UPDATE T1 '+    
              ' SET '+    
                CASE WHEN @AlterColumnaMonto IS NOT NULL THEN @ColumnaMonto+'=t2.MONTO,' ELSE '' END+    
                CASE WHEN @AlterColumnaNombre IS NOT NULL THEN @ColumnaNombre+'=t2.IMPORTE' ELSE '' END+    
              ' FROM #tmpNominasTrab T1 INNER JOIN #tmpPagosConceptos t2 ON t2.ANIO_MES = T1.ANIO_MES '+    
                               ' AND t2.CLA_EMPRESA = T1.CLA_EMPRESA'+    
                               ' AND t2.CLA_PERIODO = T1.CLA_PERIODO'+    
                               ' AND t2.NUM_NOMINA = T1.NUM_NOMINA'+    
                             --  ' AND t2.CLA_RAZON_SOCIAL = T1.CLA_RAZON_SOCIAL'+    
                               ' AND t2.CLA_TRAB = T1.CLA_TRAB'+    
                               ' AND t2.CLA_PERDED = '+@ClaveConcepto     
       --SELECT @Update       
     EXEC (@Update)    
    
     SELECT @Id=MIN(ID) FROM #tmpPerded WHERE ID>@Id    
   END    
    
   SELECT @IdEnc=OBJECT_ID('tempdb..#tmpNominasTrab')     
    
  SELECT @Select='',    
         @SelectCampos='',    
      @SelectColumna=''     
      
  SELECT @OrdenMin=MAX(T1.colorder),         
     @NumCamposMax=COUNT(*)    
  FROM tempdb.sys.syscolumns T1 INNER JOIN tempdb.SYS.types T2 ON T1.xtype=T2.system_type_id AND     
                  T1.id=@IdEnc AND     
                  T1.name NOT IN (SELECT NomColumna FROM #ColumnasNoAplica)          
    
  --SELECT*    
  --FROM tempdb.sys.syscolumns T1 INNER JOIN tempdb.SYS.types T2 ON T1.xtype=T2.system_type_id AND     
  --                T1.id=@IdEnc AND     
  --                T1.name NOT IN (SELECT NomColumna FROM #ColumnasNoAplica)          
      
  IF @DetalladoXNom=1    
  SELECT @SelectCampos=@SelectCampos+CASE WHEN t2.name IN ('float','decimal') THEN  'CAST('+T1.name+' AS decimal(10,2))'  ELSE T1.name END +CASE WHEN @OrdenMin<>T1.colorder THEN ',' ELSE '' END,    
      @SelectColumna=@SelectColumna+''''+T1.name+''''+CASE WHEN @OrdenMin<>T1.colorder THEN ',' ELSE '' END     
     FROM tempdb.sys.syscolumns T1 INNER JOIN tempdb.SYS.types T2 ON T1.xtype=T2.system_type_id WHERE id=@IdEnc AND T1.name NOT IN (SELECT NomColumna FROM #ColumnasNoAplica)          
     ORDER BY T1.colorder    
  ELSE    
  SELECT @SelectCampos=@SelectCampos+CASE WHEN t2.name NOT IN ('int','float','decimal') OR t1.name IN ('ANTIGUEDAD','CLA_TRAB','NOM_TRAB','ANTIGUEDAD_GPO','SUE_DIA','SUE_INT','ANIO','NUMERO','SDI_LFT','PARTE_VARIABLE_LFT','RFC','CURP''NSS') THEN 'MAX('+T
1  
  
.name+')'ELSE 'SUM(CAST('+T1.name+' AS decimal(10,2)))' END+CASE WHEN @OrdenMin<>T1.colorder THEN ',' ELSE '' END ,    
        @SelectColumna=@SelectColumna+''''+T1.name+''''+CASE WHEN @OrdenMin<>T1.colorder THEN ',' ELSE '' END     
     FROM tempdb.sys.syscolumns T1 INNER JOIN tempdb.SYS.types T2 ON T1.xtype=T2.system_type_id WHERE id=@IdEnc AND T1.name NOT IN (SELECT NomColumna FROM #ColumnasNoAplica)          
     ORDER BY T1.colorder    
      
   SELECT @Select='SELECT '+@SelectCampos+' FROM #tmpNominasTrab '+CASE WHEN @DetalladoXNom=0 THEN ' GROUP BY CLA_TRAB ' ELSE ' ' END+' ORDER BY CLA_TRAB '    
        
  SELECT @NumCamposMin=1,@ColInsert=''    
  --SELECT @SelectCampos    
  WHILE @NumCamposMin<=@NumCamposMax    
  BEGIN    
    SELECT @ColInsert=@ColInsert+'Columna'+CONVERT(VARCHAR,@NumCamposMin)+CASE WHEN @NumCamposMin<>@NumCamposMax THEN  ',' ELSE '' END     
    
    SELECT @NumCamposMin=@NumCamposMin+1    
  END    
       
    
  EXEC(' INSERT INTO #tmpFinal ('+@ColInsert+') Select '+@SelectColumna)       
      
  EXEC(' INSERT INTO #tmpFinal ('+@ColInsert+') '+@Select)    
    
  EXEC ('SELECT '+@ColInsert+'  FROM #tmpFinal ORDER BY CONCECUTIVO ASC ')    
     
 fin:    
END 