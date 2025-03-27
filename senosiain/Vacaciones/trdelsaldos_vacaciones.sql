USE [ADAMP]
GO
/****** Object:  Trigger [dbo].[trdelsaldos_vacaciones]    Script Date: 03/25/2025 12:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trdelsaldos_vacaciones] 
ON [dbo].[saldos_vacaciones] 
AFTER DELETE

AS
BEGIN
	SET CONCAT_NULL_YIELDS_NULL OFF

	DECLARE	@w_tabla		VARCHAR(50),
		@w_tipo_movimiento	SMALLINT,
		@w_valor_anterior	VARCHAR(4000),
		@w_valor_actual		VARCHAR(4000),
		@w_error		TINYINT,

		@d_compania		CHAR(4),
		@d_trabajador		CHAR(10),
		@d_ciclo_laboral	CHAR(8),
		@d_tipo_ciclo		SMALLINT,
		@d_secuencia_ciclo	SMALLINT,
        	@d_fecha_ini_prog_vac	SMALLDATETIME,
		@d_fecha_cad_prog_vac	DATETIME,
		@d_vac_por_ciclo	DECIMAL(8,3),
		@d_acumulado_ciclo_ant	DECIMAL(8,3),
		@d_vac_disfrutadas	DECIMAL(8,3),
		@d_vac_programadas	DECIMAL(8,3),
		@d_vac_vencidas		DECIMAL(8,3),
		@d_situacion_ciclo	TINYINT,
		@d_dias_lab		DECIMAL(8,3),
		@d_dias_no_lab          DECIMAL(8,3)

	SET @w_tabla = 'saldos_vacaciones'
	SET @w_tipo_movimiento = 3
	SET @w_valor_anterior = NULL
	SET @w_error = 0

	DECLARE cur_borrado_sv CURSOR FOR
	SELECT 	compania,
		trabajador,
		ciclo_laboral,
		tipo_ciclo,
		secuencia_ciclo,
		fecha_ini_prog_vac,
		fecha_cad_prog_vac,
		vac_por_ciclo,
		acumulado_ciclo_ant,
		vac_disfrutadas,
		vac_programadas,
		vac_vencidas,
		situacion_ciclo,
		dias_lab,
		dias_no_lab
	FROM 	DELETED 

	OPEN  	cur_borrado_sv

	WHILE 1 = 1
    	BEGIN
    		FETCH 	cur_borrado_sv 
		INTO 	@d_compania,
			@d_trabajador,
			@d_ciclo_laboral,
			@d_tipo_ciclo,
			@d_secuencia_ciclo,
			@d_fecha_ini_prog_vac,
			@d_fecha_cad_prog_vac,
			@d_vac_por_ciclo,
			@d_acumulado_ciclo_ant,
			@d_vac_disfrutadas,
			@d_vac_programadas,
			@d_vac_vencidas,
			@d_situacion_ciclo,
			@d_dias_lab,
			@d_dias_no_lab


		IF @@FETCH_STATUS != 0 
    	        	BREAK

    		SET @w_valor_actual = LTRIM(RTRIM(@d_compania)) + ';;'
		SET @w_valor_actual = @w_valor_actual + LTRIM(RTRIM(@d_trabajador)) + ';;'
		SET @w_valor_actual = @w_valor_actual + LTRIM(RTRIM(@d_ciclo_laboral)) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_tipo_ciclo AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_secuencia_ciclo AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_fecha_ini_prog_vac AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_fecha_cad_prog_vac AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_vac_por_ciclo AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_acumulado_ciclo_ant AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_vac_disfrutadas AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_vac_programadas AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_vac_vencidas AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_situacion_ciclo AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_dias_lab AS VARCHAR) + ';;'
		SET @w_valor_actual = @w_valor_actual + CAST(@d_dias_no_lab AS VARCHAR)

		EXECUTE sp_val_saldos_vacaciones 
			@d_compania,
			@d_trabajador,
			@d_ciclo_laboral,
			@d_tipo_ciclo,
			@d_secuencia_ciclo,
			@d_fecha_ini_prog_vac,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@w_tipo_movimiento,
			@w_error OUTPUT

		IF @w_error = 0
		BEGIN
			DELETE	programacion_vacaciones
			WHERE  	compania      	= @d_compania
			AND  	trabajador    	= @d_trabajador
			AND 	ciclo_laboral 	= @d_ciclo_laboral
			AND	tipo_ciclo    	= @d_tipo_ciclo
			AND	secuencia_ciclo = @d_secuencia_ciclo

			EXECUTE sp_alta_historico_transaccione 
				@w_tabla, 
				@w_tipo_movimiento, 
				@w_valor_anterior, 
				@w_valor_actual
		END
	END

	CLOSE cur_borrado_sv
	DEALLOCATE cur_borrado_sv

	SET CONCAT_NULL_YIELDS_NULL ON

	IF @w_error = 1
		RETURN
END

