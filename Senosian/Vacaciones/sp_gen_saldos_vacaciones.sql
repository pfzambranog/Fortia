Alter PROCEDURE dbo.sp_gen_saldos_vacaciones
 @compania          CHAR(04)      = '',
 @trabajador        CHAR(10)      = '',
 @ciclo_laboral     SMALLINT      = 0,
 @fecha_antiguedad  SMALLDATETIME = 0,
 @fecha_gen         CHAR(05)      = '',
 @fecha_actual      DATETIME   = '',
 @ano_actual        SMALLINT      = 0,
 @ano_fec_antig     SMALLINT      = 0,
 @masivo            TINYINT       = 0,
 @status            TINYINT       = 0,
 @param_generacion  CHAR(01)      = '',
 @caducidad         DECIMAL(16,8) = 0
AS

BEGIN
 DECLARE @ciclo_laboral2        SMALLINT,
         @campo_ciclo           CHAR(08),
         @ant_campo_ciclo       CHAR(08),
         @char_ciclo            CHAR(04),
         @char_ciclo2           VARCHAR(10),
         @fec_act_ciclo         DATETIME,
         @fecha_ini_prog_vac    DATETIME,
         @fecha_cad_prog_vac    DATETIME,
         @ant_fec_ini_prog_vac  DATETIME,
         @meses                 SMALLINT,

         @caducidad2            DECIMAL(16,8),
         @dif_ciclo_vac         SMALLINT,
         @acumulado_ciclo_ant   SMALLINT,
         @vac_disfrutadas       SMALLINT,
         @vac_programadas       SMALLINT,
         @vac_vencidas          SMALLINT,
         @bisiesto              SMALLINT,
         @saldos_vac            TINYINT,
         @tipo_manejo           TINYINT,
         @w_programa_sus     VARCHAR(30)

 SELECT  @w_programa_sus = programa_sus
 FROM  programas_remplazo
 WHERE programa_ori = 'sp_gen_saldos_vacaciones'


 IF ISNULL(@w_programa_sus, '') = ''
 BEGIN
   SELECT @ciclo_laboral2        = 0,
          @campo_ciclo           = '',
          @ant_campo_ciclo       = '',
          @char_ciclo            = '',
          @char_ciclo2           = '',
          @fec_act_ciclo         = '',
          @fecha_ini_prog_vac    = '',
          @fecha_cad_prog_vac    = '',
          @ant_fec_ini_prog_vac  = '',
          @meses                 = 0,
          @caducidad2            = 0,
          @dif_ciclo_vac         = 0,
          @acumulado_ciclo_ant   = 0,
          @vac_disfrutadas       = 0,
          @vac_programadas       = 0,
          @vac_vencidas          = 0,
          @bisiesto              = 0,
          @saldos_vac           = 0,
          @tipo_manejo          = 0

  SET @acumulado_ciclo_ant = 0

  SELECT  @tipo_manejo = entero
  FROM  parametros_cv
  WHERE  compania     = @compania
  AND  parametro_cv = 'Tipo_Manejo'

  SELECT  @saldos_vac = entero
  FROM  parametros_cv
  WHERE  compania     = @compania
  AND  parametro_cv = 'Saldos_vac'

  SET @status  = 0

  SET @caducidad2 = @caducidad
  SET @ciclo_laboral2 = @ciclo_laboral
  SET @campo_ciclo = (CONVERT(CHAR(4),@ciclo_laboral2)) + (CONVERT(CHAR(4),(@ciclo_laboral2)+1))
  SET @ant_campo_ciclo = (CONVERT(CHAR(4),((@ciclo_laboral2)-1))) + (CONVERT(char(4),((@ciclo_laboral2))))
  SET @char_ciclo = (CONVERT(CHAR(4), (@ciclo_laboral2 + 1)))
  SET @bisiesto = (CONVERT(SMALLINT,@char_ciclo) % 4)

  IF ((@bisiesto <> 0) AND (@fecha_gen = '0229'))
   SELECT @fecha_gen = '0228'

  SET @char_ciclo2 = @char_ciclo  + @fecha_gen
  SET @fec_act_ciclo = CONVERT(SMALLDATETIME,@char_ciclo2,103)
  SET @meses = DATEDIFF(mm, @fecha_antiguedad, @fec_act_ciclo)

  IF EXISTS(SELECT 1
            FROM  historico_saldos_vac
            WHERE compania      = @compania
            AND   trabajador    = @trabajador
            AND   ciclo_laboral = @campo_ciclo)
     BEGIN
        IF @masivo >= 1
           BEGIN
              SET @status = 4

              IF @masivo = 1
                 BEGIN
                    RAISERROR 20001 'El registro a insertar ya fué generado y existe en el Histórico de Saldos de Vacaciones. '
                    RETURN 1
                 END
              ELSE
                 BEGIN
                    INSERT INTO err_proc_vacaciones
                    VALUES (@compania,@trabajador,@campo_ciclo,4)
                 END
           END
     END

  IF @meses = 0
     Begin
        Set @meses = 12
     End
     
  IF @meses >= 12
     BEGIN
        SET @fecha_ini_prog_vac = @fec_act_ciclo
        SET @caducidad2 = (12 * @caducidad)

        SET @fecha_cad_prog_vac = DATEADD(mm,@caducidad2, @fecha_ini_prog_vac)
        SET @fecha_cad_prog_vac = DATEADD(dd, -1, @fecha_cad_prog_vac)

        IF @meses >= 24
           BEGIN
              IF EXISTS(SELECT 1
                        FROM  historico_saldos_vac
                        WHERE  compania      = @compania
                        AND trabajador    = @trabajador
                        AND ciclo_laboral = @ant_campo_ciclo)
                 BEGIN
                    SELECT  @acumulado_ciclo_ant = ((ISNULL(vac_por_ciclo,0) + ISNULL(acumulado_ciclo_ant,0)) - (ISNULL(vac_disfrutadas,0)))
                    FROM  historico_saldos_vac
                    WHERE  compania      = @compania
                    AND  trabajador    = @trabajador
                    AND  ciclo_laboral = @ant_campo_ciclo
                    AND  tipo_baja     = '0'
                 END
              ELSE
                 BEGIN
                    SET @acumulado_ciclo_ant = 0

                 END

              IF EXISTS( SELECT 1
                         FROM  saldos_vacaciones
                         WHERE  compania      = @compania
                         AND  trabajador    = @trabajador
                         AND  ciclo_laboral = @ant_campo_ciclo)
                 BEGIN
                    SELECT  @ant_fec_ini_prog_vac = fecha_ini_prog_vac
                    FROM  saldos_vacaciones
                    WHERE  compania      = @compania
                    AND  trabajador    = @trabajador
                    AND  ciclo_laboral = @ant_campo_ciclo

                    SET @dif_ciclo_vac = DATEDIFF(mm, @ant_fec_ini_prog_vac, @fec_act_ciclo)

                    IF NOT ( @dif_ciclo_vac = 12)
                       BEGIN
                          SET @status = 4
                       
                          IF @masivo = 1
                             BEGIN
                                RAISERROR 20001 'Las fechas están traslapadas '
                                RETURN 1
                             END
                          ELSE
                             BEGIN
                                INSERT INTO err_proc_vacaciones
                                VALUES (@compania, @trabajador, @campo_ciclo, 2)
                             END
                       END
                 END
           END
        ELSE
           BEGIN
              IF EXISTS( SELECT 1
                         FROM  saldos_vacaciones
                         WHERE  compania      = @compania
                         AND trabajador    = @trabajador
                         AND ciclo_laboral = @ant_campo_ciclo)
                 BEGIN
                    SELECT  @ant_fec_ini_prog_vac = fecha_ini_prog_vac
                    FROM  saldos_vacaciones
                    WHERE  compania      = @compania
                    AND  trabajador    = @trabajador
                    AND  ciclo_laboral = @ant_campo_ciclo

                    SET @dif_ciclo_vac = DATEDIFF(mm, @ant_fec_ini_prog_vac, @fec_act_ciclo)

                    IF NOT  @dif_ciclo_vac = 12
                       BEGIN
                          IF @masivo = 1
                             BEGIN
                              RAISERROR 20001 'Las fechas están traslapadas '
                              RETURN 1
                             END
                          ELSE
                             BEGIN
                              INSERT INTO err_proc_vacaciones
                              VALUES (@compania, @trabajador, @campo_ciclo, 2)
                             END
                       END
                 END

              SET @acumulado_ciclo_ant = 0

           END
        END
    ELSE
       BEGIN
   IF (@saldos_vac = 0 AND @tipo_manejo = 1)
   BEGIN
    /* si las vacaciones a generar son ciclo vacacionales si puede generarle periodos */

    SET @status = 0

    SET @fecha_ini_prog_vac = CONVERT(SMALLDATETIME,(CONVERT(CHAR(04), @ano_fec_antig) + @fecha_gen), 103)

    SET @caducidad2 = (12 * @caducidad)

    SET @fecha_cad_prog_vac = DATEADD(mm,@caducidad2,@fecha_ini_prog_vac)
    SET @fecha_cad_prog_vac = DATEADD(dd,-1,@fecha_cad_prog_vac)
   END
   ELSE
    SET @status = 4

  END

  SET @vac_disfrutadas = 0
  SET @vac_programadas = 0
  SET @vac_vencidas = 0

  IF NOT (@status = 4)
  BEGIN
   EXEC SP_ALTA_SALDOS_VACACIONES
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
    @status,
    @param_generacion

  END
 END
 ELSE
 BEGIN
  EXECUTE @w_programa_sus
   @compania,
   @trabajador,
   @ciclo_laboral,
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
END