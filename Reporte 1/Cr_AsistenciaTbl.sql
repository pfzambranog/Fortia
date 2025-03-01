  If Exists ( Select Top 1 1
              From   SysObjects
              Where  Uid = 1
              And    Type = 'U'
              And    Name = 'AsistenciaTbl')
     Begin
        Drop Table dbo.AsistenciaTbl
     End

  Create Table dbo.AsistenciaTbl
 (idSecuencia     Bigint            Not Null Identity (1, 1),
  IdEmpresa       Integer           Not Null,
  IdTrabajador    Integer           Not Null,
  IdMes           Integer           Not Null,
  Nombremes       Varchar( 20)      Not Null,
  Nomrazosoci     Varchar(100)      Not Null,
  Nombre          Varchar(200)      Not Null,
  Foto            Image                 Null,
  Fechaalta       Datetime              Null,
  Fechabaja       Datetime              Null,
  Nomdepto        Varchar(100)          Null,
  Nompuesto       Varchar(100)          Null,
  NomUbicacion    Varchar(100)          Null,
  Turno           Varchar(100)          Null,
  Tipo            Integer               Null,
  Clase           Integer               Null,
  Supervisor      Varchar(500)          Null,
  FechaEmision    DateTime              Null,
  TituloKar       Varchar(Max)          Null,
  detfal          Varchar(Max)          Null,
  dia_01          Varchar(  8)      Not Null Default Char(32),
  dia_02          Varchar(  8)      Not Null Default Char(32),
  dia_03          Varchar(  8)      Not Null Default Char(32),
  dia_04          Varchar(  8)      Not Null Default Char(32), 
  dia_05          Varchar(  8)      Not Null Default Char(32),
  dia_06          Varchar(  8)      Not Null Default Char(32),
  dia_07          Varchar(  8)      Not Null Default Char(32),  
  dia_08          Varchar(  8)      Not Null Default Char(32),  
  dia_09          Varchar(  8)      Not Null Default Char(32),  
  dia_10          Varchar(  8)      Not Null Default Char(32),  
  dia_11          Varchar(  8)      Not Null Default Char(32),  
  dia_12          Varchar(  8)      Not Null Default Char(32),  
  dia_13          Varchar(  8)      Not Null Default Char(32),  
  dia_14          Varchar(  8)      Not Null Default Char(32),  
  dia_15          Varchar(  8)      Not Null Default Char(32),  
  dia_16          Varchar(  8)      Not Null Default Char(32),  
  dia_17          Varchar(  8)      Not Null Default Char(32),  
  dia_18          Varchar(  8)      Not Null Default Char(32),  
  dia_19          Varchar(  8)      Not Null Default Char(32),  
  dia_20          Varchar(  8)      Not Null Default Char(32),  
  dia_21          Varchar(  8)      Not Null Default Char(32),  
  dia_22          Varchar(  8)      Not Null Default Char(32),  
  dia_23          Varchar(  8)      Not Null Default Char(32),  
  dia_24          Varchar(  8)      Not Null Default Char(32),  
  dia_25          Varchar(  8)      Not Null Default Char(32),  
  dia_26          Varchar(  8)      Not Null Default Char(32),  
  dia_27          Varchar(  8)      Not Null Default Char(32),  
  dia_28          Varchar(  8)      Not Null Default Char(32),  
  dia_29          Varchar(  8)      Not Null Default Char(32),  
  dia_30          Varchar(  8)      Not Null Default Char(32),  
  dia_31          Varchar(  8)      Not Null Default Char(32),  
  idSession       Uniqueidentifier  Not Null,
  Constraint AsistenciaPk
  Primary Key (idSecuencia),
  Index AsistenciaIdex01 Unique (idSession, idEmpresa, Idtrabajador, idMes),
  Index AsistenciaIdex02(idSession))
Go

--
-- Cometarios
--

Execute  sp_addextendedproperty @name       = N'MS_Description',
                                @value      = N'Tabla de Trabajo para Reporte de Asistencia',
                                @level0type = N'Schema',
                                @level0name = N'Dbo',
                                @level1type = N'Table',
                                @level1name = N'AsistenciaTbl';