Use Adam

/*
  Autor:          Pedro Zambrano
  Descripción:    Tabla de Control de altas de empleados en Banco Bajio.
  Creacion:       18-oct-2026.
  Version:        1.0
*/

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'U'
            And    Name = 'BB_AltasEmpleadosTbl')
   Begin
      Drop Table dbo.BB_AltasEmpleadosTbl
   End
Go

Create Table dbo.BB_AltasEmpleadosTbl
  (registro         Integer        Not Null  Identity (1, 1),
   compania         Char(  4)      Not Null,
   trabajador       Char( 10)      Not Null,
   cuenta_deposito  Char( 20)      Not Null,
   tarjeta          Char( 16)      Not Null,
   idEstatus        Integer        Not Null  Default 0,
   idError          Integer        Not Null  Default 0,
   mensaje          Varchar(512)   Not Null  Default Char(32),
   fechaProceso     Datetime       Not Null  Default Getdate(),
   usuarioAct       Char(20)       Not Null,
Constraint BB_AltasEmpleadosPk
Primary Key (registro))

Create Unique Index BB_AltasEmpleadosIdx01 on dbo.BB_AltasEmpleadosTbl (compania, trabajador);

Grant Select On dbo.BB_AltasEmpleadosTbl to Public;

--
-- Comentarios.
--

Declare
   @v_existe	Bit		= 0,
   @v_table		Sysname = 'BB_AltasEmpleadosTbl';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Tabla de Control de altas de empleados en Banco Bajio.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table;

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Número consecutivo del Registro.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'registro'

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Código Único de Compañía',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'compania'

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Código Único del Trabajador',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'trabajador';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Número de Cuenta Bancaria del Trabajador',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'cuenta_deposito';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Número de Tarjeta Bancaria del Trabajador',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'tarjeta';
                                
Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Identificador del estatus de proceso del trabajador',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'idEstatus';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Identificador del error en el proceso del trabajador',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'idError';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Mensaje del error en el proceso del trabajador',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'mensaje';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Última Fecha de Proceso del Registro.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'fechaProceso';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Último Usuario que realizo el Proceso del Registro.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'usuarioAct';
