If Exists ( Select Top  1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'Fn'
            And    Name = 'fn_formato_trabajador')
   Begin
      Drop Function dbo.fn_formato_trabajador;
   End;
Go

Create Function dbo.fn_formato_trabajador
  (@trabajador   Char(10))
Returns Char(10)
As

Begin
   Declare
      @w_alfanumerico   Varchar(100),
      @w_real           Decimal(16,6),
      @w_longitud       Integer,
      @w_clave          Char(10);

   Begin
      Set @w_clave = Ltrim(Rtrim(@trabajador))

      Select @w_alfanumerico = alfanumerico
      From   dbo.parametros_rh
      Where  compania            = '0'
      And    parametro_rh        = 'Cve_Emp'
      And    secuencia_parametro = 1;

      Select @w_real = real
      From   dbo.parametros_rh
      Where  compania            = '0'
      And    parametro_rh        = 'Folio_Emp'
      And    secuencia_parametro = 1

      Set @w_longitud = (10 - Len(@w_clave))

      If @w_real = 2
         Begin
            Set @w_clave = Replicate(' ', @w_longitud) + @w_clave

            If @w_alfanumerico = 'S'
               Begin
                  Set @w_clave = Replace(@w_clave, ' ', '0')
               End
         End
      Else
         Begin
            Set @w_clave = Rtrim(@w_clave) + Replicate(' ', @w_longitud)
         End
   End

   Return @w_clave

End
Go

Grant execute On dbo.fn_formato_trabajador To Public
Go
