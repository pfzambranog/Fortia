If Exists ( Select Top 1 1
            From   Sysobjects
            Where  uid  = 1
            And    Type = 'U'
            And    Name = 'progVacMgrTbl')
   Begin
      Drop table dbo.progVacMgrTbl
   End
Go

Create Table dbo.progVacMgrTbl
(compania         Char( 4)  Not Null,
 trabajador       Char(10)  Not Null,
 ciclolaboral     Char(10)  Not Null,
 tipo_nomina      Char( 2)  Not Null,
 idEstatus        Bit       Not Null Default 0,
Constraint progVacMgrPk
Primary Key (compania, trabajador, ciclolaboral),
Index progVacMgrIdx01 (tipo_nomina));

