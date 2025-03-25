Alter PROCEDURE dbo.sp_gen_sal_ciclos_V5
 @compania         CHAR(04)      = '',
 @trabajador       CHAR(10)      = '',
 @ciclo_laboral    SMALLINT      = 0,  /* parametros */
 @no_ciclos        SMALLINT      = 0,
 @fecha_generacion DATETIME      = '',
 @param_generacion CHAR(01)      = '',
 @contador         TINYINT       = 0

AS
 DECLARE @fecha_gen         CHAR(05),
  @rel_lab2          CHAR(10),
  @campo_ciclo       CHAR(08),
  @campo0            CHAR(04),
  @campo1            CHAR(04),
  @campo2            SMALLINT,
  @campo3            SMALLINT,
  @gen               SMALLINT,
  @gen2              SMALLINT,
  @gen3              CHAR(01),
  @gen4              CHAR(02),
  @gen5              CHAR(01),
  @gen6              CHAR(02),
  @fecha_antiguedad  SMALLDATETIME,
  @fecha2_antiguedad SMALLDATETIME,
  @fecha_actual      DATETIME,
  @fecha_ingreso     SMALLDATETIME,
  @fecha_paso        DATETIME,
  @ano_actual        SMALLINT,
  @ano_generacion    SMALLINT,
  @ano_fec_antig     SMALLINT,
  @fin_generacion    SMALLINT,
  @sit_trabajador    SMALLINT,
  @ciclo_laboral2    SMALLINT,
  @masivo            SMALLINT,
  @status            SMALLINT,
  @caducidad         DECIMAL(16,8),
  @w_programa_sus    VARCHAR(30)

BEGIN
 EXECUTE sp_programas_remplazo @compania, 'sp_gen_sal_ciclos_V5', @w_programa_sus OUTPUT

 IF ISNULL(@w_programa_sus, '') = ''
 BEGIN
  SELECT  @fecha_gen       = '',
          @rel_lab2        = '',
          @campo_ciclo     = '',
          @campo0          = '',
          @campo1          = ''

  SELECT  @campo2          = 0,
          @campo3          = 0,
          @gen             = 0,
          @gen2            = 0,
          @gen3            = '',
          @gen4            = '',
          @gen5            = '',
          @gen6            = ''

  SELECT  @fecha_antiguedad  = '',
          @fecha2_antiguedad = '',
          @fecha_actual      = '',
          @fecha_ingreso     = '',
          @fecha_paso        = ''

  SELECT  @ano_actual        = 0,
          @ano_generacion    = 0,
          @ano_fec_antig     = 0,
          @fin_generacion    = 0,
          @sit_trabajador    = 0,
          @ciclo_laboral2    = 0,
          @masivo            = @contador,
          @status            = 0,
   @caducidad         = 0

  IF @masivo < 2
  BEGIN
   DELETE FROM err_proc_vacaciones
  END

  /* trae el valor real de la caducudad del ciclo */

  SELECT  @caducidad = real
  FROM  parametros_cv
  WHERE  parametro_cv = 'Cad_ciclo'
  AND  compania     = @compania

  IF (@caducidad <= 0 OR @caducidad > 50)
  BEGIN
   RAISERROR 20001 'La caducidad de su ciclo no puede ser menor a 0 o mayor de 50 años'
   RETURN 1
  END

  IF NOT EXISTS(SELECT 1
   FROM  parametros_cv
   WHERE  compania = @compania)
  BEGIN
   RAISERROR 20001 'No existen datos en la tabla [parametros_cv]'
   RETURN 1
  END

  IF NOT ((@fecha_generacion IS NULL) OR (@fecha_generacion = ''))
  BEGIN
   SELECT @ano_generacion = DATEPART(YY,@fecha_generacion)

   IF (@ano_generacion <> @ciclo_laboral)
   BEGIN
    RAISERROR 20001 'Esta tratando generar el ciclos de vacaciones con un año de fecha de generacion diferente al año del ciclo laboral que pretende generar'
    RETURN
   END
  END

  IF NOT EXISTS(SELECT 1
   FROM  trabajadores_grales
   WHERE  compania   = @compania
   AND  trabajador = @trabajador)
  BEGIN
   SELECT @status = 4

   IF @masivo = 1
   BEGIN
    RAISERROR 20001 'El trabajador esta dado de baja.'
    RETURN 1
   END
   ELSE
   BEGIN
    INSERT INTO err_proc_vacaciones
    VALUES (@compania,
     @trabajador,
     @campo_ciclo,
     6)
   END
  END

  IF NOT (@status = 4)
  BEGIN
   SELECT  @fecha_antiguedad = fecha_antiguedad,
    @fecha_ingreso    = fecha_ingreso,
    @rel_lab2    = relacion_laboral,
    @sit_trabajador   = sit_trabajador
   FROM  trabajadores_grales
   WHERE  compania   = @compania
   AND  trabajador = @trabajador

   SET @fecha_actual = GETDATE()
   SET @ano_actual = DATEPART(YY, @fecha_actual)
   SET @ciclo_laboral2 = @ciclo_laboral

   SET @campo0 = CONVERT(CHAR(04), @ciclo_laboral2)
   SET @campo2 = CONVERT(SMALLINT, @campo0)

   SET @campo2 = @campo2 + 1
   SET @campo1 = CONVERT(CHAR(04), @campo2)

   SET @campo_ciclo = (CONVERT(CHAR(04), @campo0) + CONVERT(CHAR(04), @campo1))


   SET @fin_generacion = @ciclo_laboral + @no_ciclos
   SET @fecha2_antiguedad = @fecha_antiguedad

   SET @status = 0

   IF (@sit_trabajador = 2)
   BEGIN
    IF (@masivo >= 1)
    BEGIN   /*  verifica que trabajador sea activo  */
     SET @status = 4

     IF @masivo = 1
     BEGIN
      RAISERROR 20001 'El trabajador esta dado de baja.'
      RETURN 1
     END
     ELSE
     BEGIN
      INSERT INTO err_proc_vacaciones
      VALUES (@compania, @trabajador, @campo_ciclo, 6)
     END

    END
   END

   IF (@fecha_generacion IS NULL) OR (@fecha_generacion = '')
   BEGIN
    IF @param_generacion = '0'
    BEGIN
     SELECT @fecha_paso = @fecha_antiguedad
    END

    IF @param_generacion = '1'
    BEGIN
     SET @fecha_paso = @fecha_ingreso
    END
   END
   ELSE
   BEGIN
    SET @fecha_paso = @fecha_generacion
   END

   SET @gen =  DATEPART(mm,@fecha_paso)
   SET @gen2 = DATEPART(DD,@fecha_paso)

   IF (@gen) < 10
   BEGIN
    SET @gen3 = CONVERT(CHAR(1),@gen)
    SET @gen4 = CONVERT(CHAR(02),('0' + @gen3))
   END
   ELSE
   BEGIN
    SET @gen4 = CONVERT(CHAR(02),@gen)
   END

   IF (@gen2) < 10
   BEGIN
    SET @gen5 = CONVERT(CHAR(1),@gen2)
    SET @gen6 = CONVERT(CHAR(02),('0' + @gen5))
   END
   ELSE
   BEGIN
    SET @gen6 = CONVERT(CHAR(02),@gen2)
   END

     SET @fecha_gen = CONVERT(CHAR(02),@gen4) +  CONVERT(CHAR(02),@gen6)
     SET @ano_fec_antig = DATEPART(YY,@fecha_antiguedad)

Select 'paso', @ciclo_laboral2 < @fin_generacion

   WHILE @ciclo_laboral2 < @fin_generacion
   BEGIN
    IF NOT (@status = 4)
    BEGIN
     EXEC sp_gen_saldos_vacaciones
      @compania,
      @trabajador,
      @ciclo_laboral2,
      @fecha_antiguedad,
      @fecha_gen,
      @fecha_actual,
      @ano_actual,
      @ano_fec_antig,
      @masivo,
      @status,
      @param_generacion,
      @caducidad
    END

    SET @ciclo_laboral2 = @ciclo_laboral2 + 1

   END   /*END WHILE */
  END  /* END DEL PRIMER IF NOT (@status = 4) */
 END
 ELSE
 BEGIN
  EXECUTE @w_programa_sus
   @compania,
   @trabajador,
   @ciclo_laboral,
   @no_ciclos,
   @fecha_generacion,
   @param_generacion,
   @contador

 END
END
Go
