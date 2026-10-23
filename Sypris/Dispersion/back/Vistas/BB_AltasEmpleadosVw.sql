Use Adam
Go

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'V'
            And    Name = 'BB_AltasEmpleadosVw')
   Begin
      Drop View dbo.BB_AltasEmpleadosVw
   End
Go

Create View dbo.BB_AltasEmpleadosVw
As
Select a.compania, b.nombre_cia, a.trabajador, Substring(dbo.fn_detallaNombre(d.nombre, 6), 1, 24) nombre,
        a.cuenta_deposito, a.tarjeta, a.idEstatus, c.descripcion, a.idError, a.mensaje  
From   dbo.BB_AltasEmpleadosTbl a
Join   dbo.companias     b
On     b.compania = a.compania
Join   dbo.criterios_valores c
On     c.campo  = 'BCOBAJSTAT'
And    c.item   = a.idEstatus
Join   trabajadores d
On     RTRIM(ltrim(d.trabajador)) = RTRIM(ltrim(a.trabajador))
Union
Select a.compania, b.nombre_cia, a.trabajador, 'TRABAJADOR NO EXISTE' nombre,
        a.cuenta_deposito, a.tarjeta, a.idEstatus, c.descripcion, a.idError, a.mensaje  
From   dbo.BB_AltasEmpleadosTbl a
Join   dbo.companias     b
On     b.compania = a.compania
Join   dbo.criterios_valores c
On     c.campo  = 'BCOBAJSTAT'
And    c.item   = a.idEstatus
And    Not Exists ( Select Top 1 1
                    From   dbo.trabajadores
                    Where  RTRIM(ltrim(trabajador)) = RTRIM(ltrim(a.trabajador)))
Go

Grant Select On dbo.BB_AltasEmpleadosVw to Public;
