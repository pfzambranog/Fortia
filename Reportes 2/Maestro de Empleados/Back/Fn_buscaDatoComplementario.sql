--
-- Declare
--    @PnCla_Empresa   Integer      = 1,
--    @PnIdTrabajador  Integer      = 400120742,
--    @PsEtiqueta      Varchar(150) = 'Vales de despensa';
--
-- Select dbo.Fn_buscaDatoComplementario (@PnCla_Empresa, @PnIdTrabajador, @PsEtiqueta);

Create Or Alter Function dbo.Fn_buscaDatoComplementario
  (@PnCla_Empresa    Integer,
   @PnIdTrabajador   Integer,
   @PsEtiqueta       Varchar(150))
Returns Varchar(250)
As

Begin
   Declare
      @w_salida   Varchar(250),
      @w_control  Integer,
      @w_valor    varchar(300);

   Begin
      Set @w_salida  = Char(32);

      Select @w_control   = a.cla_control
      From   dbo.RH_DATO_COMPLEMENTARIO       a
      Join   dbo.RH_DATO_COMPLEMENTARIO_VALOR b
      On     b.cla_control       = a.cla_control
      And    b.cla_entidad       = a.cla_entidad
      Where  a.etiqueta          = @PsEtiqueta
      And    b.cla_referencia_1  = @PnCla_Empresa
      And    b.cla_referencia_2  = @PnIdTrabajador;
      
      Select Top 1 @w_valor    = b.valor
      From   dbo.RH_DATO_COMPLEMENTARIO       a
      Join   dbo.RH_DATO_COMPLEMENTARIO_VALOR b
      On     b.cla_control       = a.cla_control
      And    b.cla_entidad       = a.cla_entidad
      Where  a.etiqueta          = @PsEtiqueta
      And    a.cla_control       = @w_control
      And    b.cla_referencia_1  = @PnCla_Empresa
      And    b.cla_referencia_2  = @PnIdTrabajador;

      If Exists (Select top 1 1
                 From   dbo.RH_LISTA_DATO_COMPLEMENTARIO
                 Where  nom_lista = @PsEtiqueta)
         Begin
	        Select @w_salida = b.valor_dato 
	        From   dbo.RH_LISTA_DATO_COMPLEMENTARIO          a 
            Join   dbo.RH_LISTA_ELEMENTO_DATO_COMPLEMENTARIO b
	        On     b.CLA_LISTA = a.CLA_LISTA
	        And    b.CLA_DATO  = @w_valor
            Where  a.NOM_LISTA = @PsEtiqueta;
        End
     Else
        Begin
           Set  @w_salida = @w_valor;
        End
      
   End;
   
   Return Isnull(@w_salida, '')

End
Go
