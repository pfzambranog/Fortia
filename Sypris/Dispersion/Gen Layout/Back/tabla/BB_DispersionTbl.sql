Use Adam
Go

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'U'
            And    Name = 'BB_DispersionTbl')
   Begin
      Drop Table dbo.BB_DispersionTbl
   End
Go

Create Table dbo.BB_DispersionTbl
  (secuencia        Integer          Not Null Identity (1, 1) ,
   idSession        Varchar(100)     Not Null,
   linea            Char(181)        Not Null Default Char(32),
Constraint BB_DispersionPk
Primary Key (secuencia));

Create Index BB_DispersionIdx01 On BB_DispersionTbl (idSession);

--
-- Comentarios
--

Declare
   @v_existe	Bit		= 0,
   @v_table		Sysname = 'BB_DispersionTbl';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Tabla Resultante de la Dispersión Banco Bajío.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table;

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Secuencia Consecutiva de Registros dados de alta.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'Secuencia'

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Identificador de la session de Proceso de la dispersión.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'idSession'
Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Línea de Dispersion.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'linea'
Go