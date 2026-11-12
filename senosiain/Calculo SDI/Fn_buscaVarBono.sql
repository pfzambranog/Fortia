/*
Select dbo.Fn_buscaVarBono(3)

*/

If Exists (Select Top 1 1
           From   Sysobjects
           Where  Uid  = 1
           And    Type = 'Fn'
           And    Name = 'Fn_buscaVarBono')
   Begin
      Drop Function dbo.Fn_buscaVarBono
   End
Go


Create Function dbo.Fn_buscaVarBono
  (@PnSistemaAntiguedad   Tinyint)
Returns Decimal(10, 3)
As

Begin
/*
  Actualiza:      Pedro Zambrano - Zepga Consultores.
  Fecha:          2026-11-03
  Descripción:    Función que calcula el monto del bono (var_san_05) Para el cálculo del SDI.
  Version:        1.0

*/
   Declare
      @o_salida           Decimal(10, 3)

   Begin
      Select top 1 @o_salida  = Isnull(variable_sa_05, 0)
      From   dbo.sistemas_ant_rangos
      Where  sistema_antiguedad = @PnSistemaAntiguedad
      If @@Rowcount = 0
         Begin
            Set @o_salida = 0.00
         End
   End

   Return(@o_salida)

End
Go

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Función que Busca la Variable 05 del Sistema de Antiguedad.',
   @w_procedimiento  NVarchar(250) = 'Fn_buscaVarBono';

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