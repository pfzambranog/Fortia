If Exists (Select Top 1 1
           From   sysobjects
           Where  Uid   = 1
           And    Type = 'P'
           And    Name = 'sp_calcula_sdi_bimestral')
   Begin
      Drop Procedure  dbo.sp_calcula_sdi_bimestral;
   End
Go

Create Procedure dbo.sp_calcula_sdi_bimestral
  (@compania       Char(4),
   @bimestre       Tinyint,
   @anio           Smallint,
   @fecha_aplic    Smalldatetime)
AS

Declare @trabajador        Char(10),
   @antiguedad             Tinyint,
   @tipo_sueldo            Tinyint,
   @salario                Decimal(19,6),
   @salario_imss           Decimal(19,6),
   @salario_info           Decimal(19,6),
   @tipo_salario           Tinyint,
   @sistema_antiguedad     Tinyint,
   @sdi                    Decimal(19,6),
   @factor_integracion     Decimal(19,6),
   @tope_imss              Varchar(20),
   @tope_infonavit         Varchar(20),
   @Agr_Tiempo             Varchar(20),
   @Agr_Importe            Varchar(20),
   @sal_minimo             Decimal(19,6),
   @salario_tope_imss      Decimal(19,6),
   @salario_tope_info      Decimal(19,6),
   @percepcion_variable    Decimal(19,6),
   @dias_imss              Decimal(19,6),
   @dias_info              Decimal(19,6),
   @dias_ant               Decimal(19,6),
   @variable_mes1          Decimal(19,6),
   @variable_mes2          Decimal(19,6),
   @variable_bimestre      Decimal(19,6),
   @variable_imss          Decimal(19,6),
   @nvo_sdi_imss           Decimal(19,6),
   @nvo_sdi_info           Decimal(19,6),
   @aplicar_sdi            Tinyint,
   @w_char                 Char(1),
   @w_sql                  Varchar(3000),
   @tope_imss_importe      Decimal(19, 6),
   @tope_infonavit_importe Decimal(19, 6),
   @tipo_dias              Tinyint,
   @dias_mes1              Smallint,
   @dias_mes2              Smallint,
--
   @w_bono                 Decimal(19, 6),
   @w_sueldomasbono        Decimal(19, 6);

Begin

-- ==============================================================================
-- Proyecto: <Salario Diario Integrado>
-- Author:  <Ervin Olvera Ruiz - ITE SOLUCIONES>
-- Create Date: <02/12/2009>
-- Description: <SP Calcula el SDI Bimestral>
--
-- Actualizado Por: Pedro Zambrano. - Zepga Consultores.
-- Fecha:           05-nov-2026.
-- Motivo:          Incorporación del Bono (variable_sa_05) al calculo del SDI.
-- versión:         V02
-- ==============================================================================

   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    On

   Select @tipo_sueldo = 1,
          @w_sql       = Char(32),
          @w_char      = Char(39)
          @tipo_dias   = 1;

   Select @tipo_dias = entero
   FROM parametros_fp
   WHERE compania = @compania AND
    parametro_fp = 'ITE_Ti_SDI'

   Select @Agr_Tiempo = ISNULL(alfanumerico,'W21')
   FROM parametros_fp
   WHERE parametro_fp = 'ITE_Ag_SDI' AND
    compania = @compania AND
    secuencia_parametro = 1

   Select @Agr_Importe = ISNULL(alfanumerico,'W33')
   FROM parametros_fp
   WHERE parametro_fp = 'ITE_Ag_SDI' AND
    compania = @compania AND
    secuencia_parametro = 2

   Select @tipo_sueldo = ISNULL(entero,1)
   FROM parametros_rh
   WHERE parametro_rh = 'Tipo_Sdo' AND
    compania = @compania



   Select @tope_imss = ISNULL(alfanumerico,'var_nom_01')
    FROM parametros_fp
    WHERE compania = @compania AND
       parametro_fp = 'ITE_TopeSI' AND
          secuencia_parametro = 1


    Select @tope_infonavit = ISNULL(alfanumerico,'var_nom_02')
    FROM parametros_fp
    WHERE compania =@compania AND
       parametro_fp = 'ITE_TopeSI' AND
       secuencia_parametro = 2

   Select @tope_imss_importe = real
   FROM parametros_rh
   WHERE compania = @compania AND
    parametro_rh = @tope_imss

   Select @tope_infonavit_importe = real
   FROM parametros_rh
   WHERE compania = @compania AND
    parametro_rh = @tope_infonavit



    Select @sal_minimo = ISNULL(real,0)
    FROM parametros_rh
    WHERE parametro_rh = 'Sal_Minimo' AND
      compania = @compania



    SET @salario_tope_imss = @sal_minimo * @tope_imss_importe
    SET @salario_tope_info = @sal_minimo * @tope_infonavit_importe

   IF @bimestre = 1
    BEGIN
     SET @dias_mes1 = 31
     Select @dias_mes2 = DATEPART(DAY,DATEADD(DAY,-1,DATEADD(MONTH,1,
       DATEADD(DAY,1 - DATEPART(DAY,CAST(CAST(@anio AS Char(4)) + '02' + '01' AS SMALLDATETIME)),
       CAST(CAST(@anio AS Char(4)) + '02' + '01' AS SMALLDATETIME)))))
    END
   IF @bimestre = 2
    BEGIN
     SET @dias_mes1 = 31
     SET @dias_mes2 = 30
    END
   IF @bimestre = 3
    BEGIN
     SET @dias_mes1 = 31
     SET @dias_mes2 = 30
    END
   IF @bimestre = 4
    BEGIN
     SET @dias_mes1 = 31
     SET @dias_mes2 = 31
    END
   IF @bimestre = 5
      BEGIN
     SET @dias_mes1 = 31
     SET @dias_mes2 = 30
    END
   IF @bimestre = 6
    BEGIN
     SET @dias_mes1 = 31
     SET @dias_mes2 = 30
    END



   DECLARE
    cur_SDI CURSOR FOR
    Select  trabajador, antiguedad
    FROM   reporte_sdi
     OPEN cur_SDI
      FETCH cur_SDI INTO @trabajador, @antiguedad
       WHILE @@FETCH_STATUS = 0
        BEGIN

         Select @sistema_antiguedad = Isnull(sistema_antiguedad, 1)
         FROM trabajadores_grales
         WHERE compania = @compania AND
             trabajador = @trabajador

         Select @factor_integracion = Isnull(factor_integracion,0),
                @w_bono             = Isnull(variable_sa_05, 0)
         FROM   sistemas_ant_rangos
         WHERE  sistema_antiguedad = @sistema_antiguedad
         AND    limite_inferior   <= @antiguedad
         AND    limite_superior   >= @antiguedad

         Select @salario = ISNULL(salario,0),
                @salario_imss = ISNULL(salario_integrado,0),
                @salario_info = ISNULL(salario_int_infonav,0),
                @tipo_salario = ISNULL(grupo_salario,0)
         FROM   sueldos
         WHERE compania = @compania AND
           trabajador = @trabajador

         IF  @tipo_sueldo = 1 OR @tipo_sueldo = 5   /*Diario o Por Hora*/
          BEGIN
           IF @tipo_sueldo = 5
            BEGIN
             SET @salario = @salario * 8 /*Por Hora*/
            END
          END
         ELSE IF @tipo_sueldo = 2 OR @tipo_sueldo = 3 OR @tipo_sueldo = 4 /*Semanal, Mensual o Por Año*/
          BEGIN
           IF @tipo_sueldo = 2
            BEGIN
             SET @salario = @salario / 7   /*Semanal*/
            END
           IF @tipo_sueldo = 3
            BEGIN
             SET @salario = @salario / 30  /*Mensual*/
            END
           IF @tipo_sueldo = 4
            BEGIN
             SET @salario = @salario / 365 /*Anual*/
            END
          END

/*
   Ajuste al Calculo del SDI
   05-nov-2026.

         SET @sdi = @salario * @factor_integracion
*/

         Set @w_sueldomasbono = @salario * (1 + @w_bono);
         Set @sdi = @w_sueldomasbono * @factor_integracion;

         IF @bimestre = 1
          BEGIN

           Select @dias_ant = ISNULL(SUM(acum_tie_mes_11) + SUM(acum_tie_mes_12),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio - 1 AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @dias_imss = ISNULL(SUM(acum_tie_mes_01) + SUM(acum_tie_mes_02),0),
               @dias_info = ISNULL(SUM(acum_tie_mes_01) + SUM(acum_tie_mes_02),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
             anio = @anio AND
             trabajador = @trabajador AND
             agr_conceptos = @Agr_Tiempo

           Select @percepcion_variable = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre - 1,@dias_ant)
           Select @variable_bimestre = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre,@dias_imss)


          END
         IF @bimestre = 2
          BEGIN


           Select @dias_ant = ISNULL(SUM(acum_tie_mes_01) + SUM(acum_tie_mes_02),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @dias_imss = ISNULL(SUM(acum_tie_mes_03) + SUM(acum_tie_mes_04),0),
             @dias_info = ISNULL(SUM(acum_tie_mes_03) + SUM(acum_tie_mes_04),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @percepcion_variable = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre - 1,@dias_ant)
           Select @variable_bimestre = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre,@dias_imss)


          END
         IF @bimestre = 3
          BEGIN


           Select @dias_imss = ISNULL(SUM(acum_tie_mes_05) + SUM(acum_tie_mes_06),0),
             @dias_info = ISNULL(SUM(acum_tie_mes_05) + SUM(acum_tie_mes_06),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @dias_ant = ISNULL(SUM(acum_tie_mes_03) + SUM(acum_tie_mes_04),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @percepcion_variable = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre - 1,@dias_ant)
           Select @variable_bimestre = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre,@dias_imss)


          END
         IF @bimestre = 4
          BEGIN

           Select @dias_imss = ISNULL(SUM(acum_tie_mes_07) + SUM(acum_tie_mes_08),0),
             @dias_info = ISNULL(SUM(acum_tie_mes_07) + SUM(acum_tie_mes_08),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @dias_ant = ISNULL(SUM(acum_tie_mes_05) + SUM(acum_tie_mes_06),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @percepcion_variable = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre - 1,@dias_ant)
           Select @variable_bimestre = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre,@dias_imss)

          END
         IF @bimestre = 5
          BEGIN


           Select @dias_imss = ISNULL(SUM(acum_tie_mes_09) + SUM(acum_tie_mes_10),0),
            @dias_info = ISNULL(SUM(acum_tie_mes_09) + SUM(acum_tie_mes_10),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @dias_ant = ISNULL(SUM(acum_tie_mes_07) + SUM(acum_tie_mes_08),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @percepcion_variable = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre - 1,@dias_ant)
           Select @variable_bimestre = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre,@dias_imss)

          END
         IF @bimestre = 6
          BEGIN


           Select @dias_imss = ISNULL(SUM(acum_tie_mes_11) + SUM(acum_tie_mes_12),0),
             @dias_info = ISNULL(SUM(acum_tie_mes_11) + SUM(acum_tie_mes_12),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo

           Select @dias_ant = ISNULL(SUM(acum_tie_mes_09) + SUM(acum_tie_mes_10),0)
           FROM acumulados_mensuales
           WHERE compania = @compania AND
            anio = @anio AND
            trabajador = @trabajador AND
            agr_conceptos = @Agr_Tiempo


           Select @percepcion_variable = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre - 1,@dias_ant)
           Select @variable_bimestre = dbo.fn_percepcion_variable(@compania, @trabajador, @anio,@bimestre,@dias_imss)

          END

         IF @tipo_dias = 1
          BEGIN
           SET @dias_imss = @dias_mes1 + @dias_mes2
           SET @dias_info = @dias_mes1 + @dias_mes2
          END

         IF @dias_imss <= 0 OR @dias_info <= 0
          BEGIN
           SET @nvo_sdi_imss = @salario_imss
           SET @nvo_sdi_info = @salario_info
           SET @aplicar_sdi = 2
           SET @variable_imss = 0
          END
         ELSE
          BEGIN
           SET @variable_imss = @variable_bimestre / @dias_imss

               SET @nvo_sdi_imss = @sdi + @variable_imss
           SET @nvo_sdi_info = @sdi + @variable_imss

           IF @nvo_sdi_imss >= @salario_tope_imss
            BEGIN
             SET @nvo_sdi_imss = @salario_tope_imss
            END

           IF @nvo_sdi_info >= @salario_tope_info
            BEGIN
             SET @nvo_sdi_info = @salario_tope_info
            END

           IF @nvo_sdi_imss <> @salario_imss
            BEGIN
             SET @aplicar_sdi = 1
            END
           ELSE
            BEGIN
             SET @aplicar_sdi = 2
            END

           IF @nvo_sdi_info <> @salario_info
            BEGIN
             SET @aplicar_sdi = 1
            END
           ELSE
            BEGIN
             SET @aplicar_sdi = 2
            END
          END

         UPDATE reporte_sdi
         Set   -- salario_diario   = @w_sueldomasbono,
          salario_diario   = @salario,
          factor_integracion  = @factor_integracion,
          sdi                 = @sdi,
          percepcion_variable = @percepcion_variable,
          sdi_imss_ant = @salario_imss,
          sdi_infonavit_ant = @salario_info,
          tope_imss = @salario_tope_imss,
          tope_infonavit = @salario_tope_info,
          dias_imss = @dias_imss,
          dias_infonavit = @dias_info,
          variable_bimestre = @variable_bimestre,
          variable_imss = @variable_imss,
                fecha_aplicacion = @fecha_aplic,
                 nvo_sdi_imss = @nvo_sdi_imss,
                 nvo_sdi_infonavit = @nvo_sdi_info,
                 aplicar_sdi = @aplicar_sdi,
                 tipo_salario = @tipo_salario
               WHERE trabajador = @trabajador


         FETCH cur_sdi INTO @trabajador, @antiguedad
        END
     CLOSE cur_SDI
   DEALLOCATE cur_SDI

   Delete FROM dbo.reporte_sdi
   WHERE dias_imss = 0 OR  dias_infonavit = 0;

END
Go

Grant Execute On dbo.sp_calcula_sdi_bimestral to Public
Go

--
-- Comentarios.
--

Declare
   @w_valor          Varchar(1500) = 'Procedimiento que calcula el SDI BIMESTRAL.',
   @w_procedimiento  Varchar( 100) = 'sp_calcula_sdi_bimestral'


If Not Exists (Select Top 1 1
               From   sys.extended_properties a
               Join   sysobjects  b
               On     b.xtype   = 'P'
               And    b.name    = @w_procedimiento
               And    b.id      = a.major_id)

   Begin
      Execute  sp_addextendedproperty @name       = N'MS_Description',
                                      @value      = @w_valor,
                                      @level0type = 'Schema',
                                      @level0name = N'Dbo',
                                      @level1type = 'Procedure',
                                      @level1name = @w_procedimiento;

   End

