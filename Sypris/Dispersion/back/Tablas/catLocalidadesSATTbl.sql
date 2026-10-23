USE ADAM
Go


/*
  Autor:          Pedro Zambrano
  Descripción:    Tabla Catálogo de Localidades del SAT.
  Creacion:       18-oct-2026.
  Version:        1.0
*/

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'U'
            And    Name = 'catLocalidadesSATTbl')
   Begin
      Drop Table dbo.catLocalidadesSATTbl
   End
Go

Create Table dbo.catLocalidadesSATTbl
   (idEstado      Char   (  3) Not Null,
    idLocalidad   Char   (  5) Not Null,
    descripcion   Varchar(100) Not Null,
    idEstatus     Bit          Not Null Default (1),
    fechaAct      Datetime     Not Null Default Getdate(),
Constraint catLocalidadesSATPK
Primary Key Clustered (idEstado, idLocalidad))
Go

Grant Select on catLocalidadesSATTbl to Public
Go

--
-- Comentarios.
--

Declare
   @v_table		Sysname = 'catLocalidadesSATTbl';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Catálogo de Estados del SAT.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table;
Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Código Único del Estado Según SAT',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'idEstado';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Nombre del Estado Según SAT',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'descripcion';


Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Código de Localidad Según SAT',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'idLocalidad';
                                
Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Identificador del Estatus del Registro',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'idEstatus';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Fecha de Actualización del Registro',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'fechaAct';