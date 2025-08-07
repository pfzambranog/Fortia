Create Or Alter Procedure splseLeeParametro
  (@chCompania       Char    (  4),
   @chClaParametro   Char    ( 30),
   @iNumEntero       Integer         Out,
   @cNumDecimal      Decimal (19, 6) Out,
   @chAlfanumerico   Varchar (250)   Out,
   @dFecHora         Datetime        Out)
As

Declare
   @errDescrip varchar(200)

Begin
   Select @iNumEntero     = Null,
          @cNumDecimal    = Null,
          @chAlfanumerico = Null,
          @dFecHora       = Null;

   Select @iNumEntero     = Isnull(num_entero,  0),
          @cNumDecimal    = isnull(num_decimal, 0),
          @chAlfanumerico = isnull(alfanumerico,''),
          @dFecHora       = fecha_hora
   From   dbo.lse_par_adaptaciones
   Where  compania      = @chCompania
   And    cla_parametro = @chClaParametro;
   If @@Rowcount = 0
   Begin
      set @errDescrip = 'No se encontró el parámetro ' + rtrim(@chClaParametro) + ' de la Compania ' +  @chCompania
      raiserror(@errDescrip,16,1)
   End

   Return

End
Go
