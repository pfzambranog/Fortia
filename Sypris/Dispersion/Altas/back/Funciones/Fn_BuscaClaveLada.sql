Use Adam
Go

/*
Select dbo.Fn_BuscaClaveLada('10101')
       
*/

If Exists (Select Top 1 1
           From   Sysobjects
           Where  Uid  = 1
           And    Type = 'Fn'
           And    Name = 'Fn_BuscaClaveLada')
   Begin
      Drop Function dbo.Fn_BuscaClaveLada
   End
Go


Create Function dbo.Fn_BuscaClaveLada
  (@PsTrabajador   Char(10))  
Returns Varchar(3)
As

Begin
   Declare
      @o_salida           Varchar(3)

   Begin
      Select @o_salida = Substring(telefono_particular, 1, 3)
      From   dbo.trabajadores
      Where  trabajador = @PsTrabajador
      If @@Rowcount = 0
         Begin
            Set @o_salida = '999'
         End
   End

   Set @o_salida = Isnull(@o_salida, '999')

   Return(@o_salida)

End
Go

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Función que Busca la Clave Lada Relacionada al Trabajador.',
   @w_procedimiento  NVarchar(250) = 'Fn_BuscaClaveLada';

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