-- Execute dbo.splseDatosHistorialTrabajador 'LS', '     79169'

Alter procedure dbo.splseDatosHistorialTrabajador
  (@chCompania    Varchar(15),
   @chTrabajador  Char(10))
As

 ---------------------------------------------------------------------------------------------
 ---- Procedimiento:  splseDatosHistorialTrabajador
 ---- Programó: Oscar Flores González
 ---- Objetivo: Generar la información para el reporte de vacaciones
 ---- Creado:  25/05/2006
 ---- Ejemplo de llamada:
 ---- exec splseDatosHistorialTrabajador '     10070','LS'
 ---------------------------------------------------------------------------------------------
 ---- Modificado por:       Francisco Rodríguez
 ---- Ultima Modificacion:  12-Sep-2018
 ---- Motivo:               No se muestran los puestos en el historial para trabajadores
 ----                       de nuevo ingreso.
 ---------------------------------------------------------------------------------------------
 ---- Modificado por:       Pedro Zambrano.
 ---- Ultima Modificacion:  05-Sep-2025
 ---- Motivo:               Selección de la última plaza asignada al trabajador (Por Fecha de Movimiento).
 ---------------------------------------------------------------------------------------------

 ---------------------------------------------------------------------------------------------
 ---- Modificado por:       Pedro Zambrano.
 ---- Ultima Modificacion:  08-Sep-2025
 ---- Motivo:               Reverso al Ajuste del 05-09-2025.
 --                         Se deben presentar todas las plaza asignada al trabajador (Por Fecha de Movimiento).
 ---------------------------------------------------------------------------------------------

Begin

Set nocount Off

--
-- Creación de tablas Temporales
--

   Create Table #TmpHistorialTrab
   (Fecha      Date            Not Null,
    Valor      Varchar(60)     Null,
    Tipo       Varchar(60)     Null);

    Create Index TmpHistorialTrabIdx01 on #TmpHistorialTrab (Fecha);

/*
   Create Table #TmpResultado
   (Fecha      Date            Not Null,
    Depto      Varchar(60)         Null Default ' ',
    Zona       Varchar(60)         Null Default ' ',
    Ruta       Varchar(60)         Null Default ' ',
    Puesto     Varchar(60)         Null Default ' ',
    Sueldo     Varchar(60)         Null Default ' ',
    Comision   Varchar(60)         Null Default ' ');

    Create Index TmpResultadoIdx01 On #TmpResultado (Fecha);

*/

--
-- Inicio de Proceso.
--

   Insert Into   #TmpHistorialTrab
  (Fecha, Valor, Tipo)
   Select his.Fecha,
          convert(varchar(50), Convert(Decimal(10, 2), (salario * 30))) Valor,
          'Sueldo' Tipo
   From   dbo.historico_sueldos his
   Where  his.compania       = @chCompania
   And    his.trabajador     = @chTrabajador
   And    his.causa_aumento <> 'MI'
   Union  All
   Select Cast(valor_03 As Date) Fecha,
          Isnull (dbo.fnlseSelDatHisLaboral (comentario), ' ') 'Valor',
          'Tipo' = Case codigo_incidencia
                        When 'D'   Then 'Depto'
                        When 'RUT' Then 'Ruta'
                        Else 'Zona'
                   End
   From   dbo.HISTORIAL_LABORAL
   Where  compania          = @chCompania
   And    trabajador        = @chTrabajador
   And    not valor_03     is null
   And   (codigo_incidencia = 'D'
    or    codigo_incidencia = 'ZON'
    or    codigo_incidencia = 'RUT')
   Union  All
   Select Cast(valor_03 As Date) Fecha,
          pue.descripcion Valor,
         'Puesto' Tipo
   From   dbo.HISTORIAL_LABORAL
   left   outer join dbo.puestos pue
   on     pue.puesto        = rtrim(Substring(comentario, 1, 4))
   Where  compania          = @chCompania
   And    trabajador        = @chTrabajador
   And    codigo_incidencia = '0000000006'
   And    pue.descripcion  Is Not Null
   Union  All
   Select Isnull (HP.fecha_inicio, TG.FECHA_INGRESO) Fecha,
   Isnull (pue.descripcion, ' ') Valor, 'Puesto' Tipo
   From    dbo.HISTORICO_PLAZAS hp
   Left    join dbo.puestos pue
   on      pue.puesto    = HP.puesto, dbo.Trabajadores_grales TG
   Where   HP.compania   = @chCompania
   And     HP.trabajador = @chTrabajador
   And     HP.COMPANIA   = TG.COMPANIA
   And     HP.TRABAJADOR = TG.TRABAJADOR
   Union   All
   Select  Cast(valor_03 As Date) Fecha,
           convert(varchar(50), valor_02 ) Valor, 'Comision' Tipo
   From   dbo.HISTORIAL_LABORAL Hl
   left   outer join dbo.puestos pue
   on     pue.puesto           = rtrim(Hl.comentario)
   Where  hl.compania          = @chCompania
   And    hl.trabajador        = @chTrabajador
   And    hl.codigo_incidencia = '0000000019'
   And    hl.valor_03         is not null
   Union All
   Select Isnull (hl.valor_03, TG.FECHA_INGRESO) Fecha,
          convert(varchar(50), HL.valor_02 ) Valor,
          'Comision' Tipo
   From   dbo.HISTORIAL_LABORAL  hl
   left   outer join dbo.puestos pue
   on     pue.puesto           = rtrim(HL.comentario), dbo.TRABAJADORES_GRALES TG
   Where  HL.compania          = @chCompania
   And    HL.trabajador        = @chTrabajador
   And    HL.COMPANIA          = TG.COMPANIA
   And    HL.trabajador        = tg.trabajador
   And    HL.codigo_incidencia = 'var_tra_16';

select distinct fecha, valor, tipo
into #TmpHistorialTrabSinRepeticiones
from  #TmpHistorialTrab

select Fecha
 , max(case tipo when 'Depto' then valor else '' end) as Depto
 , max(case tipo when 'Zona' then valor else '' end) as Zona
 , max(case tipo when 'Ruta' then valor else '' end) as Ruta
 , max(case tipo when 'Puesto' then valor else '' end) as Puesto
 , max(case tipo when 'Sueldo' then valor else '' end) as Sueldo
 , max(case tipo when 'Comision' then valor else '' end) as Comision
into #TmpResultado
from #TmpHistorialTrabSinRepeticiones
 group by fecha
 order by fecha desc

/*
    Insert Into #TmpResultado
   (Fecha,  Puesto)
    Select fecha, valor
    From   #TmpHistorialTrab
    Where  tipo = 'Puesto';

    Insert Into #TmpResultado
   (Fecha,  Depto,  Zona,     Ruta,
    Sueldo, Comision)
    Select Fecha,
           Max(Case tipo When 'Depto'    Then valor Else '' End) as Depto,
           Max(Case tipo When 'Zona'     Then valor Else '' End) as Zona,
           Max(Case tipo When 'Ruta'     Then valor Else '' End) as Ruta,
           Max(Case tipo When 'Sueldo'   Then valor Else '' End) as Sueldo,
           Max(Case tipo When 'Comision' Then valor Else '' End) as Comision
    From   #TmpHistorialTrab
    Where  tipo != 'Puesto'
    Group by fecha;

*/

    Select Distinct  Fecha,  Depto,  Zona,     Ruta,
           Puesto, Isnull(Sueldo, '0') sueldo, Comision
    From   #TmpResultado
    Where  Depto    <> '' or
           zona     <> '' or
           ruta     <> '' or
           puesto   <> '' or
           sueldo   <> '' or
           comision <> ''
    Order  by fecha desc;


    Return

End
Go
