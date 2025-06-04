/*
Declare
   @PsCompania                 Char(4)       = '01',
   @PsTrabajador               CHAR(10)      = ' 1 ',
   @PnSecuencia                Smallint      = 8,
   @PnVariable_trabajador      Decimal(19,6) = 16.01,
   @PnEstatus                  Integer       = 0,
   @PsMensaje                  Varchar(250)  = '';

Begin
   Execute dbo.spu_variables_trabajador @PsCompania, @PsTrabajador, @PnSecuencia, @PnVariable_trabajador, @PnEstatus Output, @PsMensaje Output
   If @PnEstatus != 0
      Begin
         Select @PnEstatus, @PsMensaje
      End

   Return
End

*/

If Exists ( Select Top 1 1
            From   Sysobjects
            Where  Uid  = 1
            And    Type = 'P'
            And    Name = 'spu_variables_trabajador')
   Begin
      Drop Procedure dbo.spu_variables_trabajador;
   End
Go

Create Procedure dbo.spu_variables_trabajador
   (@PsCompania                 Char(4)       = ' ',
    @PsTrabajador               CHAR(10)      = ' ',
    @PnSecuencia                Smallint      = Null,
    @PnVariable_trabajador      Decimal(19,6) = 0,
    @PnEstatus                  Integer       = 0  Output,
    @PsMensaje                  Varchar(250)  = '' Output)
As

Declare
   @w_desc_error         Varchar(250),
   @w_error              Integer,
   @w_linea              Integer,
   @w_variable           Varchar( 10);

Begin
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    Off

   Select @PnEstatus    = 0,
          @PsMensaje    = '',
          @w_linea      = 0;

   Set @w_variable = Concat('var_tra_', Format(@PnVariable_trabajador, '00'));

   If Not Exists ( Select Top 1 1
                   From   dbo.defn_variables_ns
                   Where  compania = @PsCompania)
      Begin
         Select @PnEstatus = 9999,
                @PsMensaje = 'Error.: La Variable Seleccionada no es Válida.'

         Set Xact_Abort Off
         Return
      End

   Set @PsCompania   = Rtrim(ltrim(@PsCompania))
   Set @PsTrabajador = Replicate(' ', 10 - Len(rtrim(ltrim(@PsTrabajador)))) + rtrim(ltrim(@PsTrabajador))

   If Not Exists (Select 1
                  From   dbo.Trabajadores_grales
                  Where  compania   = @PsCompania
                  And    trabajador = @PsTrabajador)
      Begin
         Select @PnEstatus = 9998,
                @PsMensaje = 'Error.: El Trabajador Seleccionado No es Válido.'

         Select @PnEstatus, @PsMensaje

         Set Xact_Abort Off
         Return
      End


   If Not Exists (Select 1
                  From   dbo.variables_trabajador
                  Where  compania   = @PsCompania
                  And    trabajador = @PsTrabajador
                  And    secuencia  = @PnSecuencia)
      Begin
         Select @PnEstatus = 9998,
                @PsMensaje = 'Error.: El Trabajador No tiene Relacionada La Variable Seleccionada.'

         Select @PnEstatus, @PsMensaje
         Set Xact_Abort Off
         Return
      End

   Begin Transaction
      Begin try
         Update dbo.variables_trabajador
         Set    variable_trabajador = @PnVariable_trabajador
         Where  compania   = @PsCompania
         And    trabajador = @PsTrabajador
         And    secuencia  = @PnSecuencia;
      End Try

      Begin Catch
         Select  @w_Error      = @@Error,
                 @w_linea      = Error_line(),
                 @w_desc_error = Substring (Error_Message(), 1, 230)
      End   Catch

      If Isnull(@w_Error, 0) <> 0
         Begin
            Select @PnEstatus = @w_error,
                   @PsMensaje = 'Error.: ' + @w_desc_error

            Select @PnEstatus, @PsMensaje

            Rollback Transaction
            Set Xact_Abort Off
            Return

        End

   Commit Transaction

   Set Xact_Abort Off
   Return

End
Go

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Procedimiento que actualiza variable del trabajador.',
   @w_procedimiento  NVarchar(250) = 'spu_variables_trabajador';

If Not Exists (Select Top 1 1
               From   sys.extended_properties a
               Join   sysobjects  b
               On     b.xtype   = 'P'
               And    b.name    = @w_procedimiento
               And    b.id      = a.major_id)
   Begin
      Execute  sp_addextendedproperty @name       = N'MS_Description',
                                      @value      = @w_valor,
                                      @level0type = 'Schema',
                                      @level0name = N'dbo',
                                      @level1type = 'Procedure',
                                      @level1name = @w_procedimiento

   End
Else
   Begin
      Execute sp_updateextendedproperty @name       = 'MS_Description',
                                        @value      = @w_valor,
                                        @level0type = 'Schema',
                                        @level0name = N'dbo',
                                        @level1type = 'Procedure',
                                        @level1name = @w_procedimiento
   End
Go
