Select a.compania, a.trabajador, 
       Replace(b.nombre, '/', ' ') nombre,
       variable_trabajador
From   variables_trabajador A
Join   trabajadores   b
On     b.trabajador      = a.trabajador
Join   trabajadores_grales c
On     c.compania       = a.compania
And    c.trabajador     = a.trabajador
Where  c.sit_trabajador = 1
And    a.secuencia      = 5
And    a.compania       = 'LS'
Order by 2