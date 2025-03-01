Declare
    @w_procedimiento    Sysname;

Begin
   Set @w_procedimiento = 'SP_NOMINA_TABULAR_XLS';

   Delete ColumnasNoAplicaTbl
   Where  procedimiento = @w_procedimiento;

   Insert Into ColumnasNoAplicaTbl
  (procedimiento, secuencia, NomColumna, nivel)
   Select @w_procedimiento,  1, 'CLA_EMPRESA', 1
   Union
   Select @w_procedimiento,  2, 'CLA_PERIODO', 1
   Union
   Select @w_procedimiento,  3, 'ANIO_MES', 1
   Union
   Select @w_procedimiento,  4, 'NUM_NOMINA', 1
   Union
   Select @w_procedimiento,  5, 'CLA_REG_IMSS', 1
   Union
   Select @w_procedimiento,  6, 'CLA_RAZON_SOCIAL', 1
   Union
   Select @w_procedimiento,  7, 'CLA_UBICACION', 1
   Union
   Select @w_procedimiento,  8, 'CLA_CENTRO_COSTO', 1
   Union
   Select @w_procedimiento,  9, 'CLA_DEPTO', 1
   Union
   Select @w_procedimiento, 10, 'CLA_PUESTO', 1
   Union
   Select @w_procedimiento, 11, 'NOMBRE', 1
   Union
   Select @w_procedimiento, 12, 'CLA_AREA', 1
   Union
   Select @w_procedimiento, 13, 'CLA_CLASIFICACION', 1
   Union
   Select @w_procedimiento, 14, 'CLA_BANCO', 1
   Union
   Select @w_procedimiento, 15, 'CLA_FORMA_PAGO', 1
   Union
   Select @w_procedimiento, 16, 'CLA_ROLL', 1
   Union
   Select @w_procedimiento, 17, 'CLA_TAB_SUE', 1
--
   Union
   Select @w_procedimiento, 18, 'SUE_INT', 2
   Union
   Select @w_procedimiento, 19, 'TOT_PER', 2;

   Return;

End
Go
