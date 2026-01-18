Create Or ALter Procedure dbo.sp_prog_vac_mgr
  (@Jsondata              Nvarchar(Max),
   @PnEstatus             Integer      = 0     Output,
   @PsMensaje             Varchar(250) = Null  Output)
As

Declare
   @w_error               Integer,
   @w_registros           Integer,
   @w_linea               Integer,
   @w_desc_error          Varchar ( 250);

Begin
   Set Nocount         On
   Set Xact_Abort      On
   Set Ansi_Nulls      Off
   Set Ansi_Warnings   Off

        -- Validar que el JSON sea válido
   If Isjson(@Jsondata) = 0
   Begin
      Select @PnEstatus = 9999,
             @PsMensaje = 'El Parámetro @Jsondata no tiene formato JSON válido.';

      Set Xact_Abort      Off
      Return
   End

   Begin Try
        -- Insertar datos desde el JSON
      Insert Into dbo.progVacMgrTbl
     (compania, trabajador, ciclolaboral, tipo_nomina)
      Select compania, trabajadores, ciclolaboral, tipo_nomina
      From   Openjson(@Jsondata)
      With  (compania     Char( 4) '$.compania',
             trabajadores Char(10) '$.trabajadores',
             ciclolaboral Char(10) '$.ciclolaboral',
             tipo_nomina  Char( 2) '$.tipo_nomina');
      Set @w_registros = @@Rowcount;

      If @w_registros = 0
            Begin
               Select @PnEstatus = 8888,
                      @PsMensaje = 'No existen registros válidos en el json';
               Return;
            End

    End Try

    Begin Catch
        Select  @w_Error      = @@Error,
                @w_desc_error = Substring (Error_Message(), 1, 230),
                @w_linea      = error_line();
    End Catch

     If Isnull(@w_Error, 0)  <> 0
        Begin
           Select @PnEstatus  = @w_Error,
                  @PsMensaje  = Concat('Error.: ', @w_Error, ' ', @w_desc_error, ' En línea ', @w_linea);

        End

    Return;

End
Go
