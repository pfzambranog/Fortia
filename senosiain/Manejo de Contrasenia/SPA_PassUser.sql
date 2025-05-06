/*

Declare
   @PsUsuario  sysname = 'Adam',
   @PassNew    Sysname = 'AdamV3'
Begin

   Execute dbo.SPA_PassUser @PsUsuario = @PsUsuario,
                            @PassNew   = @PassNew;

   Return

End
Go

*/

If Exists ( Select Top 1 1
            From   SysObjects
            Where  Type = 'P'
            And    Name = 'SPA_PassUser')
   Begin
      Drop Procedure dbo.SPA_PassUser
   End
Go

Create Procedure dbo.SPA_PassUser
  (@PsUsuario  sysname,
   @PassNew    Sysname)
As

Declare
   @w_respuesta  Integer;

Begin
   Set nocount On

   If Not Exists (select Top 1 1
                  From   master.dbo.syslogins
                  where  loginname = @PsUsuario
                  and    isntname  = 0)
     Begin
        Select 'El Usuario No es Válido para Actualizar' Mensaje
        Return;
     End

   Execute @w_respuesta = sp_password @loginame = @PsUsuario, @new = @PassNew;
   If @w_respuesta = 0
      Begin
         Select 'Usuario Actualizado' Resultado
      End
   Else
      Begin
         Select 'Usuario NO Actualizado' MensajeError
      End

   Return

End
Go

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Procedimiento de Actualización de Password.',
   @w_procedimiento  NVarchar(250) = 'SPA_PassUser';

Begin
   Execute  sp_addextendedproperty @name       = N'MS_Description',
                                   @value      = @w_valor,
                                   @level0type = 'Schema',
                                   @level0name = N'dbo',
                                   @level1type = 'Procedure', 
                                   @level1name = @w_procedimiento

End
Go
