Alter PROCEDURE dbo.sp_alta_saldos_vacaciones
 @compania                CHAR(04)      = '',
 @trabajador              CHAR(10)      = '',
 @campo_ciclo             CHAR(08)      = '',
 @ant_campo_ciclo         CHAR(08)      = '',
 @fecha_ini_prog_vac      DATETIME      = '',
 @fecha_cad_prog_vac      DATETIME      = '',
 @acumulado_ciclo_ant     SMALLINT      = 0,
 @vac_disfrutadas         SMALLINT      = 0,
 @vac_programadas         SMALLINT      = 0,
 @vac_vencidas            SMALLINT      = 0,
 @fecha_actual            DATE          = Null,
 @masivo                  SMALLINT      = 0,
 @status_err              TINYINT       = 0,
 @param_generacion        CHAR(1)       = ''
AS

BEGIN
 DECLARE
 @no_dias_ano        DECIMAL(15,6),
  @vac_por_ciclo      SMALLINT,
  @rango              SMALLINT,
  @sistema_antiguedad TINYINT,
  @situacion_ciclo    TINYINT,
  @ano_fec_antiguedad SMALLINT,
  @fecha_antiguedad   SMALLDATETIME,
  @fecha_ingreso      SMALLDATETIME,
  @var_antiguedad     VARCHAR(20),
  @ciclo_laboral3     CHAR(08),
  @i                  CHAR(04),
  @trabajador2        CHAR(10),
  @ano_ciclo          SMALLINT,

  @ciclo              CHAR(08),
  @camp               CHAR(04),
  @camp3              SMALLINT,
  @camp4              SMALLINT,
  @ciclo_after_his    CHAR(08),

  @w_sql2   nVARCHAR(1000),
  @ParmDefinition  nVARCHAR(500),
  @w_programa_sus     VARCHAR(30)

 EXECUTE sp_programas_remplazo @compania, 'sp_alta_saldos_vacaciones', @w_programa_sus OUTPUT

 IF ISNULL(@w_programa_sus, '') = ''
 BEGIN
  SET @no_dias_ano = 0
  SET @rango = 0

  SELECT  @vac_por_ciclo      = 0,
   @sistema_antiguedad = 0,
   @situacion_ciclo    = 0,
   @ano_fec_antiguedad = 0,
   @fecha_antiguedad   = '',
   @fecha_ingreso      = '',
   @var_antiguedad     = '',
   @ciclo_laboral3     = '',
   @i                  = '',
   @trabajador2        = '',
   @ano_ciclo          = 0

  SELECT  @ciclo              = '',
   @camp               = '',
   @camp3              = 0,
   @camp4              = 0,
   @ciclo_after_his    = ''

  SELECT  @fecha_antiguedad = fecha_antiguedad,
   @fecha_ingreso    = fecha_ingreso
  FROM  trabajadores_grales
  WHERE  compania   = @compania
  AND  trabajador = @trabajador

  IF ((@param_generacion = '0') OR (@param_generacion IS NULL) OR (@param_generacion = ''))
   SET @ano_fec_antiguedad = DATEPART(YY, @fecha_antiguedad)

  IF (@param_generacion = '1')
         SET @ano_fec_antiguedad = DATEPART(YY, @fecha_ingreso)

  SET @i = CONVERT(CHAR(04), @campo_ciclo)
  SET @ano_ciclo = CONVERT(SMALLINT,@i)



  --IF(@ano_ciclo < @ano_fec_antiguedad)
  --  Begin
  --     SET @status_err = 4
  --  End


  IF (@status_err <> 4)
  BEGIN
   IF EXISTS( SELECT 1
    FROM  saldos_vacaciones
    WHERE  compania      = @compania
    AND  trabajador    = @trabajador
    AND  ciclo_laboral = @campo_ciclo )
   BEGIN
    SET @status_err = 4

    IF @masivo = 1
    BEGIN
     RAISERROR 20001 'El registro a insertar ya existe. '
     RETURN 1
    END
    ELSE
    BEGIN
     INSERT INTO err_proc_vacaciones
     VALUES (@compania,@trabajador,@campo_ciclo,3)
    END
   END


   IF EXISTS(SELECT 1
             FROM   saldos_vacaciones
             WHERE  compania   = @compania
             AND    trabajador = @trabajador)
      BEGIN
         IF NOT EXISTS(SELECT 1
                       FROM  saldos_vacaciones
                       WHERE  compania      = @compania
                       AND  trabajador    = @trabajador
                       AND  ciclo_laboral = @ant_campo_ciclo )
            BEGIN
               SET @status_err = 4

               IF @masivo = 1
                  BEGIN
                     RAISERROR 20001 'No se pueden insertar periodos laborales discontinuos. '
                     RETURN 1
                  END
               ELSE
                  BEGIN
                     INSERT INTO err_proc_vacaciones
                     VALUES (@compania,@trabajador,@campo_ciclo,1)
                  END
            END
      END
   ELSE
      Begin

         IF EXISTS(SELECT 1
                   FROM    historico_saldos_vac
                   WHERE  compania   = @compania
                   AND     trabajador = @trabajador)
            BEGIN
               DECLARE cur_hist_ciclo CURSOR FOR
               SELECT  ciclo_laboral
               FROM  historico_saldos_vac
               WHERE  compania   = @compania
               AND  trabajador = @trabajador

               OPEN  cur_hist_ciclo
               FETCH  cur_hist_ciclo
               INTO  @ciclo
               WHILE @@FETCH_STATUS = 0
               BEGIN
                  FETCH cur_hist_ciclo INTO @ciclo
               END

               CLOSE cur_hist_ciclo
               DEALLOCATE cur_hist_ciclo


               IF (@ciclo IS NOT NULL)
                   BEGIN
                      SET @camp  = CONVERT(CHAR(04),@ciclo)
                      SET @camp3 = CONVERT(SMALLINT,(CONVERT(SMALLINT,@camp) + 1))
                      SET @camp4 = @camp3 + 1

                      SET @ciclo_after_his = CONVERT(CHAR(08),(CONVERT(CHAR(04),@camp3) + (CONVERT(CHAR(04),@camp4))))

                      IF NOT EXISTS (SELECT 1
                                     FROM  SALDOS_VACACIONES
                                     WHERE  compania      = @compania
                                     AND  trabajador    = @trabajador
                                     AND  ciclo_laboral = @ciclo_after_his)
                         BEGIN
       IF (@ciclo_after_his <> @campo_ciclo)
       BEGIN
        SET @status_err = 4

        IF @masivo = 1
        BEGIN
         RAISERROR 20001 'Debe generar el período laboral posterior al ultimo reg. '
         RETURN 1
        END
        ELSE
        BEGIN
         INSERT INTO err_proc_vacaciones
         VALUES (@compania, @trabajador, @campo_ciclo, 25)
        END
       END
      END
     END
    END
   END



   IF (@fecha_cad_prog_vac < @fecha_actual)
    SET @situacion_ciclo = 2  /* Ciclo Inactivo */
   ELSE
    SET @situacion_ciclo = 1 /* Ciclo activo */

   SELECT  @var_antiguedad = alfanumerico
   FROM  parametros_cv
   WHERE  compania     = @compania
   AND  parametro_cv = 'Var_antig'


   SELECT  @sistema_antiguedad = sistema_antiguedad
   FROM  trabajadores_grales
   WHERE  compania   = @compania
   AND  trabajador = @trabajador


   IF (@sistema_antiguedad IS NULL)
   BEGIN
    SET @status_err = 4

    IF @masivo = 1
    BEGIN
     RAISERROR 20001 'El Sistema de Antiguedad no existe o no tiene rangos definidos. '
     RETURN 1
    END
    ELSE
    BEGIN
     INSERT INTO err_proc_vacaciones
     VALUES (@compania,@trabajador,@campo_ciclo,5)
    END
   END


   IF @status_err <> 4
      BEGIN
         IF NOT EXISTS(SELECT top 1 1
                       FROM  sistemas_antiguedad
                       WHERE  sistema_antiguedad = @sistema_antiguedad)
            BEGIN
               SET @status_err = 4

               IF @masivo = 1
                  BEGIN
                     RAISERROR 20001 'El Sistema de Antiguedad no existe o no tiene rangos definidos. '
                     RETURN 1
                  END
               ELSE
                  BEGIN
                     INSERT INTO err_proc_vacaciones
                     VALUES (@compania, @trabajador, @campo_ciclo, 5)
                  END
            END


        SELECT  @fecha_antiguedad = fecha_antiguedad
        FROM    trabajadores_grales
        WHERE   trabajador = @trabajador
        AND     compania   = @compania

       SET @rango = Datediff(YY, @fecha_antiguedad, @fecha_ini_prog_vac)

       If @fecha_ini_prog_vac > @fecha_antiguedad
          Begin
             Set @fecha_ini_prog_vac = @fecha_antiguedad
          End

    SET @w_sql2 = 'SELECT @w_no_dias_ano = variable_sa_' + SUBSTRING(@var_antiguedad, 9, 2)
    SET @w_sql2 = @w_sql2 + ' FROM sistemas_ant_rangos '
    SET @w_sql2 = @w_sql2 + ' WHERE sistema_antiguedad = ' + CAST(@sistema_antiguedad AS VARCHAR)
    SET @w_sql2 = @w_sql2 + ' AND ' + CAST(@rango AS VARCHAR) + ' BETWEEN limite_inferior AND limite_superior'

    SET @ParmDefinition = '@w_no_dias_ano INT OUTPUT'

    EXECUTE sp_executesql @w_sql2, @ParmDefinition, @w_no_dias_ano = @no_dias_ano OUTPUT

    IF ((@no_dias_ano IS NULL))
    BEGIN
     SET @status_err = 4

     IF @masivo = 1
     BEGIN
      RAISERROR 20001 'El Sistema de Antiguedad no existe o no tiene rangos definidos. '
      RETURN 1
     END
     ELSE
     BEGIN
      INSERT INTO err_proc_vacaciones
      VALUES (@compania, @trabajador, @campo_ciclo, 5)
     END
    END

    SET @vac_por_ciclo = CONVERT(SMALLINT,@no_dias_ano)

    IF NOT (@status_err = 4)
    BEGIN
     BEGIN TRANSACTION

      INSERT INTO saldos_vacaciones(
       compania,
       trabajador,
       ciclo_laboral,
       fecha_ini_prog_vac,
       fecha_cad_prog_vac,
       vac_por_ciclo,
       acumulado_ciclo_ant,
       vac_disfrutadas,
       vac_programadas,
       vac_vencidas,
       situacion_ciclo,
       dias_lab,
       dias_no_lab)
       VALUES (@compania,
       @trabajador,
       @campo_ciclo,
       @fecha_ini_prog_vac,
       @fecha_cad_prog_vac,
       @vac_por_ciclo,
       @acumulado_ciclo_ant,
       @vac_disfrutadas,
       @vac_programadas,
       @vac_vencidas,
       @situacion_ciclo,
       0,
       0)

      IF @@error <> 0
      BEGIN
       ROLLBACK TRANSACTION
       RAISERROR 2106005 'Error al insertar en la tabla [saldos_vacaciones]'
       RETURN 1
      END
     COMMIT TRANSACTION
    END
   END
  END
 END
 ELSE
 BEGIN
  EXECUTE @w_programa_sus
   @compania,
   @trabajador,
   @campo_ciclo,
   @ant_campo_ciclo,
   @fecha_ini_prog_vac,
   @fecha_cad_prog_vac,
   @acumulado_ciclo_ant,
   @vac_disfrutadas,
   @vac_programadas,
   @vac_vencidas,
   @fecha_actual,
   @masivo,
   @status_err,
   @param_generacion

 END
END
Go
