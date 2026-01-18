Select a.compania, a.trabajador, 
      Replace (nombre, '/', ' ') nombre,  
      a.ciclo_laboral, vac_programadas, vac_disfrutadas, vac_vencidas
from   dbo.saldos_vacaciones a
Join   dbo.trabajadores_grales b
On     b.compania   = a.compania
And    b.trabajador = a.trabajador
And    b.sit_trabajador = 1
Join   trabajadores          d
On     d.trabajador  = a.trabajador
Where  situacion_ciclo  = 1
And    Not Exists ( Select Top 1 1
                    From   programacion_vacaciones
                    Where  compania = a.compania
                    And    trabajador = a.trabajador
                    And    ciclo_laboral = a.ciclo_laboral)
Order  by 1, 2, 4