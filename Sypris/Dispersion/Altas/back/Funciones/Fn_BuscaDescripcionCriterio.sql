Use Adam
Go

/*
Select dbo.Fn_BuscaDescripcionCriterio('sexo', 1)
       
*/

If Exists (Select Top 1 1
           From   Sysobjects
           Where  Uid  = 1
           And    Type = 'Fn'
           And    Name = 'Fn_BuscaDescripcionCriterio')
   Begin
      Drop Function dbo.Fn_BuscaDescripcionCriterio
   End
Go


Create Function dbo.Fn_BuscaDescripcionCriterio
  (@PsCriterio     Char(25),
   @PnValor        Tinyint)  
Returns Varchar(100)
As

Begin
   Declare
      @o_salida           Varchar(100)

   Begin
      Select @o_salida = descripcion
      From   dbo.criterios_valores
      Where  campo  = @PsCriterio
      And    item   = @PnValor
      If @@Rowcount = 0
         Begin
            Set @o_salida = ' '
         End
   End

   Set @o_salida = Isnull(@o_salida, ' ')

   Return(@o_salida)

End
Go

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Función que Busca la Descripción del Criterio Seleccionado.',
   @w_procedimiento  NVarchar(250) = 'Fn_BuscaDescripcionCriterio';

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