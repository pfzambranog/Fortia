Select *
from dbo.transacciones_ns a
Where  exists ( Select Top 1 1
                From   progVacMgrTbl
                Where  compania = a.compania
                And    trabajador = a.trabajador
                And    ciclolaboral = a.referencia)
And referencia != '';


Select distinct a.compania, a.trabajador, a.ciclo_laboral
From   dbo.programacion_vacaciones a
Where  exists ( Select Top 1 1
                From   progVacMgrTbl
                Where  compania     = a.compania
                And    trabajador   = a.trabajador
                And    ciclolaboral = a.ciclo_laboral);


declare
    @w_comilla Char(1) = Char(39);

Select Concat('Insert into dbo.programacion_vacaciones Select ',
       @w_comilla, compania,  @w_comilla, ', ', @w_comilla, trabajador, @w_comilla, ', ',
       @w_comilla, ciclo_laboral, @w_comilla, ', ',      tipo_ciclo, ', ',
       sec_prog_vac, ', ', secuencia_ciclo, ', ', tiempo_prog_vac, ', ',
       @w_comilla, Cast(fecha_ini_per_vac As Varchar), @w_comilla, ', ',
       @w_comilla, Cast(fecha_fin_per_vac As Varchar), @w_comilla, ', ',
       @w_comilla, Cast(fecha_pago_vac    As Varchar), @w_comilla, ', ',
       situacion_programa, ', ', tipo_vacaciones, ', ',
       Case When manejo_dias_vac Is Null
            Then Null
       Else manejo_dias_vac
       End, 
       ', ', tipo_mov_vac)
From   dbo.programacion_vacaciones a
Where  exists ( Select Top 1 1
                From   progVacMgrTbl
                Where  compania     = a.compania
                And    trabajador   = a.trabajador
                And    ciclolaboral = a.ciclo_laboral);
