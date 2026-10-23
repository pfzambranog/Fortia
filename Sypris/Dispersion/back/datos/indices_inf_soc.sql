
sp_alta_indices_inf_soc  'BAJIO', 'Beneficiarios', 'BENBAJIO', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
sp_alta_rel_ind_inf_soc_cias  'BAJIO', '1'

sp_cambio_indices_inf_soc  'BAJIO', 'Beneficiarios', 'BENBAJIO', 1, 'Apellido Paterno', 'Apellido Materno', 'Parentesco', NULL, NULL, NULL, 'Primer Nombre', 'Segundo Nombre', NULL, NULL, NULL, NULL, NULL, 'Porcentaje', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dato_01*dato_02*dato_03*dato_07*dato_08*dato_14'

Update indices_inf_soc
Set    orden_columnas = 'dato_07*dato_08*dato_01*dato_02*dato_03*dato_14'
Where  indice_inf_soc like '%BAJIO%'

sp_alta_datos_ind_inf_soc 'BAJIO', 3, 'Esposo (a)', NULL, NULL, NULL
sp_alta_datos_ind_inf_soc 'BAJIO', 3, 'Madre', NULL, NULL, NULL
sp_alta_datos_ind_inf_soc 'BAJIO', 3, 'Padre', NULL, NULL, NULL
sp_alta_datos_ind_inf_soc 'BAJIO', 3, 'Hijo (a)', NULL, NULL, NULL

