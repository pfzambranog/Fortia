If Exists ( Select Top 1 1
            From   Sysobjects
            Where  uid  = 1
            And    Type = 'U'
            And    Name = 'TablasMgrTbl')
   Begin
      Drop table dbo.TablasMgrTbl
   End
Go

Create Table dbo.TablasMgrTbl
(secuencia     Integer  Not Null Identity (1, 1),
 compania      Char( 2) Not Null,
 id_calendario Integer  Not Null,
 tabla         Sysname  Not Null,
 existe        Tinyint  Not Null Default 0,
Constraint TablasMgrPk
Primary Key (secuencia),
index TablasMgrIdx01 unique (compania, id_calendario),
index TablasMgrIdx02 (tabla));