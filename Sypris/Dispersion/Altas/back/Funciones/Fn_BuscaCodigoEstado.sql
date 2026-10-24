Use Adam
Go

/*
Select dbo.Fn_BuscaCodigoEstado('MEX', 'ESTADO de MEXICO')
       
*/

If Exists (Select Top 1 1
           From   Sysobjects
           Where  Uid  = 1
           And    Type = 'Fn'
           And    Name = 'Fn_BuscaCodigoEstado')
   Begin
      Drop Function dbo.Fn_BuscaCodigoEstado
   End
Go

Create Function dbo.Fn_BuscaCodigoEstado
 (@PsIdPais     Char(5),
  @PsEstado     Varchar(100))
Returns Char(3)

As

Begin
/*
  Autor:          Pedro Zambrano
  Descripción:    Función que Consulta el Id del Estado de la Tabla catEstadosSATTbl.
  Creacion:       20-oct-2026.
  Version:        1.0
*/

   Declare
      @o_salida           Char(3)

   Begin
      Select @o_salida = idEstado
      From   dbo.catEstadosSATTbl
      Where  idpais      = @PsIdPais
      And    descripcion = @PsEstado;
      If @@Rowcount = 0
         Begin
            Set @o_salida = '999'
         End;

   End;

   Return(@o_salida)

End
Go

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Función que Consulta el Id del Estado de la Tabla catEstadosSATTbl.',
   @w_procedimiento  NVarchar(250) = 'Fn_BuscaCodigoEstado';

If Not Exists (Select Top 1 1
               From   sys.extended_properties a
               Join   sysobjects  b
               On     b.xtype   = 'Fn'
               And    b.name    = @w_procedimiento
               And    b.id      = a.major_id)
   Begin
      Execute  sp_addextendedproperty @name       = N'MS_Description',
                                      @value      = @w_valor,
                                      @level0type = 'Schema',
                                      @level0name = N'dbo',
                                      @level1type = 'Function', 
                                      @level1name = @w_procedimiento

   End
Else
   Begin
      Execute sp_updateextendedproperty @name       = 'MS_Description',
                                        @value      = @w_valor,
                                        @level0type = 'Schema',
                                        @level0name = N'dbo',
                                        @level1type = 'Function', 
                                        @level1name = @w_procedimiento
   End
Go 


