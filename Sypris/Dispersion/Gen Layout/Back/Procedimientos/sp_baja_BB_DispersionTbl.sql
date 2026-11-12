Use Adam
Go

-- /*
-- Declare
   -- @PsIdSession           Varchar(100)    = 'BBDISP01',
   -- @PnEstatus             Integer          = 0,
   -- @PsMensaje             Varchar( 512)    = Null
-- Begin

   -- Execute dbo.sp_baja_BB_DispersionTbl @PsIdSession     = @PsIdSession,
                                        -- @PnEstatus       = @PnEstatus Output,
                                        -- @PsMensaje       = @PsMensaje Output;

   -- If @PnEstatus != 0
      -- Begin
         -- Select @PnEstatus  IdError, @PsMensaje MensajeError;
     -- End

   -- Return;

-- End;
-- Go
-- */

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'P'
            And    Name = 'sp_baja_BB_DispersionTbl')
   Begin
      Drop Procedure dbo.sp_baja_BB_DispersionTbl
   End
Go

Create Procedure dbo.sp_baja_BB_DispersionTbl
  (@PsIdSession           Varchar( 100),
   @PnEstatus             Integer          = 0    Output,
   @PsMensaje             Varchar( 512)    = Null Output)
As

Declare
   @w_Error               Integer,
   @w_sql                 NVarchar(1500);

Begin
/*
  Autor:          Pedro Zambrano
  Descripción:    Procedimiento que Depura la Tabla BB_DispersionTbl
  Creacion:       25-oct-2026.
  Version:        1.0
*/

   Set Nocount            On
   Set Xact_Abort         On
   Set Ansi_Nulls         On

   Select @PnEstatus         = 0,
          @PsMensaje         = Char(32);

   Begin Tran
      Delete dbo.BB_DispersionTbl
      Where  idSession = @PsIdSession;

      Set @w_Error = @@Error
      If @w_error != 0
         Begin
            Rollback Tran
            Select @PnEstatus = @w_error,
                   @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
            Return;

         End

   Commit Tran;

   If Not Exists ( Select Top 1 1
                   From   dbo.BB_DispersionTbl)
      Begin
         Set @w_sql = 'Truncate table dbo.BB_DispersionTbl'
         Execute (@w_sql)

         Set @w_Error = @@Error
         If @w_error != 0
            Begin
               Select @PnEstatus = @w_error,
                      @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
               Return;

            End

      End

   Return

End
Go

Grant Execute On dbo.sp_baja_BB_DispersionTbl to Public
Go

--
-- Comentarios.
--

-- Declare
   -- @w_valor          Varchar(1500) = 'Procedimiento que Depura la Tabla BB_DispersionTbl.',
   -- @w_procedimiento  Varchar( 100) = 'sp_baja_BB_DispersionTbl',
   -- @w_tipo           Varchar(  20) = 'Procedure';

-- If Not Exists (Select Top 1 1
               -- From   sys.extended_properties a
               -- Join   sysobjects  b
               -- On     b.xtype   = 'P'
               -- And    b.name    = @w_procedimiento
               -- And    b.id      = a.major_id)

   -- Begin
      -- Execute  sp_addextendedproperty @name       = N'MS_Description',
                                      -- @value      = @w_valor,
                                      -- @level0type = 'Schema',
                                      -- @level0name = N'Dbo',
                                      -- @level1type = @w_tipo,
                                      -- @level1name = @w_procedimiento;

   -- End
-- Else
   -- Begin
      -- Execute sp_updateextendedproperty @name       = 'MS_Description',
                                        -- @value      = @w_valor,
                                        -- @level0type = 'Schema',
                                        -- @level0name = N'Dbo',
                                        -- @level1type = @w_tipo,
                                        -- @level1name = @w_procedimiento
   -- End
-- Go
