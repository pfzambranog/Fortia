Create or Alter Trigger dbo.TrinsprogVacMgrTbl
On     dbo.progVacMgrTbl
After  Insert, update
AS

Set Ansi_nulls        On
Set Quoted_identifier On
Set Nocount           On

Declare
  @w_len                   Tinyint,
  @w_trab                  Char(10),
  @w_compania              Char( 4),
  @w_cicloLaboral          Char(10),
  @w_trabajador	           Char(10);

Begin

   Select @w_trabajador   = trabajador,
          @w_compania     = compania,
          @w_ciclolaboral = cicloLaboral
   From   Inserted
   If @@Rowcount = 0
      Begin
         Return
      End

   Set @w_len = Len(ltrim(rtrim(@w_trabajador)));
   
   Set @w_trab = Concat(Replicate(Char(32), 10 - @w_len), ltrim(rtrim(@w_trabajador))); 

   Update dbo.progVacMgrTbl
   Set    trabajador = @w_trab
   Where  compania     = @w_compania
   And    trabajador   = @w_trabajador
   And    cicloLaboral = @w_cicloLaboral;

   Return

End
Go

