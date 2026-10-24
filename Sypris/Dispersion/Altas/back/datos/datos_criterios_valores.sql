Use Adam
Go

Begin
--
-- Parámetros para Archivos planos de Interfase Banco Bajio.
--

   delete dbo.criterios_valores
   Where  campo In ('SalBAJIO', 'BCOBAJIO', 'BCOBAJSTAT');

--
-- Dirección y Nombre del archivo texto de altas.
--

   Insert Into dbo.criterios_valores
   (campo, item, descripcion)
   Select 'BCOBAJIO', 1, 'C:\TempAdam\BB_Altas.txt'          -- Dirección de Alojamiento y Nombre del Archivo de Altas de Cuentas de Trabajadores.
   Union
   Select 'BCOBAJIO', 2, '137'                               -- Código de Identificador de Banco Bajío.
   Union
   Select 'BCOBAJIO', 3, '502171160201'                      -- Código de la Cuenta de Empresa.
   Union
   Select 'BCOBAJIO', 4, '270X'                              -- Código de Grupo de Afinidad 
   Union
   Select 'BCOBAJIO', 5, 'SUC 7'                             -- Código de Sucursal.
   Union
   Select 'BCOBAJIO', 6, 'EDO_CIVIL'                         -- Código de Agrupación de Estado Civil.
   Union
   Select 'BCOBAJIO', 7, 'BAJIO'                             -- Código del índice Socio Económico de los Beneficiaros.
   Union
   Select 'BCOBAJIO', 8, 'BBOPER01'                          -- Código de Operación de Altas.
   Union
   Select 'BCOBAJIO', 9, 'BBOPER02'                          -- Código de Operación de Proceso de Altas.
   Union
   Select 'BCOBAJIO', 10, '030'                              -- Código de Banco Receptor
   Union
   Select 'BCOBAJIO', 11, '90'                               -- Código de Operación para Nómina								
   Union
   Select 'BCOBAJIO', 12, '98'                               -- Código de Identificador de Banco Bajío (Tarjeta).
   Union
   Select 'BCOBAJIO', 13, 'C:\TempAdam\BBAJIOCIAIDCAL.txt'    -- Dirección de Alojamiento y Nombre del Archivo de Dispersion Banco Bajio.
   Union
   Select 'SalBAJIO', 0, 'Salida Repuesta a Procedimiento'   -- Identificador del Archivo de Altas.
   Union
   Select 'SalBAJIO', 1, 'Salida Archivo Txt a DD'           -- Identificador del Archivo de Altas. 
   Union
   Select 'BCOBAJSTAT', 0, 'Registro Pendiente de Proceso'
   Union
   Select 'BCOBAJSTAT', 1, 'Registro Procesado'
   Union
   Select 'BCOBAJSTAT', 2, 'Trabajador Estatus Baja'
   Union
   Select 'BCOBAJSTAT', 3, 'Registro con Error';

   Return
End
Go

