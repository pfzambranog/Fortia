If Exists ( Select Top 1 1
            From   Sysobjects
            Where  Uid  = 1
            And    Type = 'U'
            And    Name = 'ColumnasNoAplicaTbl')
   Begin
      Drop Table ColumnasNoAplicaTbl;
   End
Go

Create Table ColumnasNoAplicaTbl
(procedimiento     Sysname  Not Null,
 secuencia         Integer  Not Null,
 NomColumna        Sysname  Not Null,
 nivel             Smallint Not Null,
Constraint ColumnasNoAplicaPk
Primary Key (procedimiento, NomColumna),
Index ColumnasNoAplicaIdx01 Unique (Secuencia))
Go
