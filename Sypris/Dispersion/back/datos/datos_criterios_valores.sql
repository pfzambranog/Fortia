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
   Select 'BCOBAJIO', 1, 'C:\TempAdam\BB_Altas.txt'
   Union
   Select 'BCOBAJIO', 2, '137'
   Union
   Select 'BCOBAJIO', 3, '502171160201'
   Union
   Select 'BCOBAJIO', 4, '270X'
   Union
   Select 'BCOBAJIO', 5, 'SUC 7'
   Union
   Select 'BCOBAJIO', 6, 'EDO_CIVIL'
   Union
   Select 'BCOBAJIO', 7, 'BAJIO'
   Union
   Select 'BCOBAJIO', 8, 'BBOPER01'
   Union
   Select 'BCOBAJIO', 9, 'BBOPER02'
   Union
   Select 'SalBAJIO', 0, 'Salida Repuesta a Procedimiento'
   Union
   Select 'SalBAJIO', 1, 'Salida Archivo Txt a DD'
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

