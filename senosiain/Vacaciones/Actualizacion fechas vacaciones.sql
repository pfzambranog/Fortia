Declare
   @w_trabajador      Char(10) = '     79359',
   @w_fecha_ingreso   Date,
   @w_fecha_caducidad Date,
   @w_cilo_Laboral    Char(8)  = '20182019'

Select @w_fecha_ingreso   = DateAdd(mm, 12, fecha_ingreso),
       @w_fecha_caducidad = DateAdd(mm, 36, fecha_ingreso)
from   trabajadores_grales
Where  compania   = 'LS'
And    trabajador = @w_trabajador;

Begin Transaction
   Update dbo.saldos_vacaciones
   set    fecha_ini_prog_vac = @w_fecha_ingreso,
          fecha_cad_prog_vac = @w_fecha_caducidad
   Where  compania      = 'LS'
   And    trabajador    = @w_trabajador
   And    ciclo_laboral = @w_cilo_Laboral;

   Select *
   from   dbo.saldos_vacaciones
   Where  compania      = 'LS'
   And    trabajador    = @w_trabajador
   And    ciclo_laboral = @w_cilo_Laboral;

commit Transaction



