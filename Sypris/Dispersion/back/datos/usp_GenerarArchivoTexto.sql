 Alter PROCEDURE dbo.usp_GenerarArchivoTexto
    @RutaCompleta VARCHAR(255) = 'C:\TempAdam\prueba.txt',   -- Ej: 'C:TempAdam\resultado.txt'
    @Contenido    VARCHAR(8000)= 'Ejercicio Prueba' -- Texto o filas a escribir
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @objFSO INT,
    @objArchivo INT, @hr INT
    DECLARE @Fuente VARCHAR(255), @Descripcion VARCHAR(255)

    -- 1. Crear objeto FileSystemObject
    EXEC @hr = sp_OACreate 'Scripting.FileSystemObject', @objFSO OUT
    IF @hr <> 0 GOTO TratarError

    -- 2. Crear archivo (sobrescribe si existe = TRUE)
    EXEC @hr = sp_OAMethod 
        @objFSO, 
        'CreateTextFile', 
        @objArchivo OUT, 
        @RutaCompleta, 
        1  -- sobrescribir = 1
    IF @hr <> 0 GOTO TratarError

    -- 3. Escribir contenido
    EXEC @hr = sp_OAMethod @objArchivo, 'WriteLine', NULL, @Contenido
    IF @hr <> 0 GOTO TratarError

    -- 4. Cerrar y liberar
    EXEC sp_OADestroy @objArchivo
    EXEC sp_OADestroy @objFSO
    PRINT 'Archivo generado exitosamente: ' + @RutaCompleta
    
    RETURN

TratarError:

    EXEC sp_OAGetErrorInfo @objFSO, @Fuente OUT, @Descripcion OUT
    RAISERROR('Error: %s - %s', 16, 1, @Fuente, @Descripcion)
    IF @objArchivo IS NOT NULL EXEC sp_OADestroy @objArchivo
    IF @objFSO    IS NOT NULL EXEC sp_OADestroy @objFSO
END
GO