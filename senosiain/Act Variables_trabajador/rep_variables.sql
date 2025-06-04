Declare
  @w_variable    Integer = 5,
  @w_compania    Char(4) = 'Ls',
  @w_var         Char(10);

Begin
   Set @w_var = Case When @w_variable > 9
                     Then 'var_tra_'  + Cast(@w_variable As Varchar)
                     Else 'var_tra_0' + Cast(@w_variable As Varchar)
                End;
   
  Select a.secuencia,
         (Select top 1 descripcion_var
         From   dbo.defn_variables_ns
         Where  compania = a.compania
         And    variable = Case When a.secuencia > 9
                                Then 'var_tra_'  + Cast(a.secuencia As Varchar)
                                Else 'var_tra_0' + Cast(a.secuencia As Varchar)
                           End) Variable,
         a.trabajador, dbo.Fn_depura_nombre (a.trabajador), 
         a.variable_trabajador
  From   dbo.variables_trabajador a
  Join   dbo.trabajadores_grales  b
  On     b.compania       = a.compania
  And    b.trabajador     = a.trabajador
  Where  a.compania       = @w_compania
  And    a.secuencia      = Case When Isnull(@w_variable, 0) = 0
                                 Then a.secuencia
                                 Else @w_variable
                            End
  And    b.sit_trabajador = 1
  Order  by a.secuencia, a.trabajador

  Return

End
Go
