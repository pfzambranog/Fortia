Use Adam
Go

/*
Select dbo.Fn_BuscaCuentaBancTrabajador('1', '         6', '137')
       
*/

If Exists (Select Top 1 1
           From   Sysobjects
           Where  Uid  = 1
           And    Type = 'Fn'
           And    Name = 'Fn_BuscaCuentaBancTrabajador')
   Begin
      Drop Function dbo.Fn_BuscaCuentaBancTrabajador
   End
Go


Create Function dbo.Fn_BuscaCuentaBancTrabajador
   (@PsCompania    Char( 4),
    @PsTrabajador  Char(10),
    @PsEntidad     Char(20))
Returns Varchar(40)
As

Begin
   Declare
      @o_salida           Varchar(40)

   Begin
      Select @o_salida =  cuenta_deposito  
      From   rel_trab_ins_dep With (NOLOCK)  
      Where  compania   = @PsCompania  
      And    trabajador = @PsTrabajador
      And    institucion_deposito = @PsEntidad;
      If @@Rowcount = 0
         Begin
            Set @o_salida = '0'
         End
   End

   Return(@o_salida)

End
Go

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Función que Busca Cuenta Bancaria del Trabajador en la Entidad Bancaria seleccionada.',
   @w_procedimiento  NVarchar(250) = 'Fn_BuscaCuentaBancTrabajador';

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