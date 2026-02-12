declare
    @w_comilla Char(1) = Char(39);

Select Concat('Insert into dbo.programacion_vacaciones Select ',
       @w_comilla, compania,  @w_comilla, ', ', @w_comilla, trabajador, @w_comilla, ', ',
       @w_comilla, ciclo_laboral, @w_comilla, ', ',      tipo_ciclo, ', ',
       sec_prog_vac, ', ', secuencia_ciclo, ', ', tiempo_prog_vac, ', ',
       'Cast(', @w_comilla, Convert(Char(10), fecha_ini_per_vac, 120), @w_comilla, ' As Date) ', ', ',
       'Cast(', @w_comilla, Convert(Char(10), fecha_fin_per_vac, 120), @w_comilla, ' As Date) ', ', ',
       'Cast(', @w_comilla, Convert(Char(10), fecha_pago_vac,    120), @w_comilla, ' As Date) ', ', ',
       situacion_programa, ', ', tipo_vacaciones, ', ',
       Case When manejo_dias_vac Is Null
            Then 1
            Else manejo_dias_vac
       End, 
       ', ', tipo_mov_vac)
From   dbo.programacion_vacaciones a
Where  exists ( Select Top 1 1
                From   progVacMgrTbl
                Where  compania     = a.compania
                And    trabajador   = a.trabajador
                And    ciclolaboral = a.ciclo_laboral);