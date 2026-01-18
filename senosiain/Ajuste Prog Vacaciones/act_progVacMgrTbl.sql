Declare
  @w_compania              Char( 4),
  @w_cicloLaboral          Char(10),
  @w_trabajador	           Char(10);

Declare
  C1   Cursor For
  Select  compania, trabajador, cicloLaboral
  From    dbo.progVacMgrTbl
  Order   By 2;

Begin
   Open C1
   While @@Fetch_status < 1
   Begin
      Fetch C1 Into @w_compania, @w_trabajador, @w_cicloLaboral
      If @@Fetch_status != 0
         Begin
            Break
         End

     Update dbo.progVacMgrTbl
     Set    trabajador = trabajador
     Where  compania     = @w_compania
     And    trabajador   = @w_trabajador
     And    cicloLaboral = @w_cicloLaboral;

   End
   Close      C1
   Deallocate C1
   
   Return

End
Go