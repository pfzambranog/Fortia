Use ADAMP
Go

Disable Trigger All
ON      dbo.programacion_vacaciones;

Use ADAMHIS
Go

Insert into adamp.dbo.programacion_vacaciones
Select a.*
from   dbo.programacion_vacaciones a
Where  exists ( Select Top 1 1
                From   progVacMgrTbl
                Where  compania     = a.compania
                And    trabajador   = a.trabajador
                And    ciclolaboral = a.ciclo_laboral)
And    Not Exists ( Select Top 1 1
                    From   adamp.dbo.programacion_vacaciones
                    Where  compania      = a.compania
                    And    trabajador    = a.trabajador
                    And    ciclo_laboral = a.ciclo_laboral
                    And    sec_prog_vac  = a.sec_prog_vac)

Use ADAMP
Go
                 
Enable Trigger All
ON     adamp.dbo.programacion_vacaciones;