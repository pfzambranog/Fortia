USE ADAM
Go


/*
  Autor:          Pedro Zambrano
  Descripción:    Tabla Catálogo de Estados del SAT.
  Creacion:       18-oct-2026.
  Version:        1.0
*/

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'U'
            And    Name = 'catEstadosSATTbl')
   Begin
      Drop Table dbo.catEstadosSATTbl
   End
Go

Create Table dbo.catEstadosSATTbl
   (idPais        Char   (  5) Not Null,
    idEstado      Char   (  3) Not Null,
    descripcion   Varchar(100) Not Null,
    idEstatus     Bit          Not Null Default (1),
    fechaAct      Datetime     Not Null Default Getdate(),
    ipAct         Varchar(30)      Null,
    macAddressAct Varchar(30)      Null,
Constraint catEstadosSATPK
Primary Key Clustered (idPais, idEstado))
Go

Grant Select on catEstadosSATTbl to Public
Go

--
-- Comentarios.
--

Declare
   @v_table		Sysname = 'catEstadosSATTbl';

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Catálogo de Estados del SAT.',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table;

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Código del Pais Según SAT',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'idPais';

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

Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Dirección IP desde donde se Actualizó el Registro',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'ipAct';
                                
Execute sp_addExtendedproperty	@name		= N'Ms_descripcion',
								@value		= N'Dirección MAC desde donde se Actualizó el Registro',
								@level0type = N'Schema',
								@level0name = N'dbo',
								@level1type = N'Table',
								@level1name = @v_table,
								@level2type = N'column',
								@level2name = 'macAddressAct';
Go