If Exists ( Select Top  1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'Fn'
            And    Name = 'fn_ConsultaSysmessages')
   Begin
      Drop Function dbo.fn_ConsultaSysmessages;
   End;
Go

Create Function dbo.fn_ConsultaSysmessages
  (@PnError   Integer)
Returns Varchar(510)
As

Begin
   Declare
      @o_resultado      Varchar(510);

   Begin
      Select @o_resultado = Convert(Varchar, description)
      From   master.dbo.sysmessages a
      Where  error     = @PnError
      And    msglangid = 1033;
      If @@Rowcount = 0
         Begin
            Set @o_resultado = 'Error No Parametrizado';
         End
   End

   Return (@o_resultado);

End
Go

Grant execute On dbo.fn_ConsultaSysmessages To Public
Go
