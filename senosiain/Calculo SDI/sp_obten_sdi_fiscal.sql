
/*
Declare
    @compania          Char   ( 4) = 'LS',
    @instancia         Varchar(50) = '01010101010',
    @grupo_salario     Char(   1)  = 0;
Begin
   Execute dbo.sp_obten_sdi_fiscal @compania      = @compania,
                                   @instancia     = @instancia,
                                   @grupo_salario = @grupo_salario;
   Return;

End;
Go

*/

If Exists (Select Top 1 1
           From   sysobjects
           Where  Uid   = 1
           And    Type = 'P'
           And    Name = 'sp_obten_sdi_fiscal')
   Begin
      Drop Procedure  dbo.sp_obten_sdi_fiscal;
   End
Go

Create Procedure dbo.sp_obten_sdi_fiscal
   (@compania          Char   ( 4),
    @instancia         Varchar(50),
    @grupo_salario     Char(   1))

AS

Declare
  @I_ID_SECUENCIA     Integer,
  @secuencia          Smallint,
  @sub_secuencia      Smallint,
  @descripcion        Varchar(  80),
  @campo_view         Varchar(  700),
  @sentencia_view     Varchar(8000)

Begin

/*
  Actualiza:      Pedro Zambrano - Zepga Consultores.
  Fecha:          2026-11-03
  Descripción:    Procedimiento que obtiene los datos de SDI Para el Reporte.
  Actualización:  2026-11-03.
  Motivo:         Se incorpora un nuevo componente en el cálculo del SDI (var_ant_5)
  Version:        2.0
*/
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    On

 /* Inicializa Varibles */

 Select  @secuencia      = 0,
         @sub_secuencia  = 0,
         @descripcion    = '',
         @campo_view     = '',
         @sentencia_view = '';

 /* Seccion Fija */

 SET @sentencia_view =
  ' SELECT v.compania, v.trabajador, nombre, tg.fecha_antiguedad, salario_diario, dbo.Fn_buscaVarBono (tg.sistema_antiguedad) * 100.00 bono,' +
  ' factor_integracion, monto_vales, monto_fonahorro, monto_ayualimenticia, monto_ayuhabitacion,' +
  ' monto_presfijaa, monto_presfijab, monto_presfijac, monto_presfijad, monto_presfijae,' +
  ' salario_variable_mixto, salario_variable, dias, ' +
  ' salario_integrado_imss, ' +
  ' salario_integrado_info,' +
  ' (CASE WHEN ISNULL(grupo_salario,0) = 0 THEN ''Fijo'' WHEN grupo_salario = 1 THEN ''Variable'' WHEN grupo_salario IN (2,5,6) THEN ''Mixto'' END) descripcion_grupo_salario,' +
  ' (CASE WHEN ISNULL(estado,0) = 0 THEN '''' WHEN estado = 1 THEN ''Salario Integrado con Modificaciones'' WHEN estado = 2 THEN ''Salario Integrado sin Modificaciones'' END) descripcion_estado, ' +
  ' ISNULL(estado,0) estado ' +


 DECLARE cr_detalle_sdi CURSOR FOR
 SELECT DISTINCT
  secuencia,
  subsecuencia,
  RTRIM(LTRIM(c1.descripcion)) + '_' + RTRIM(LTRIM(c2.descripcion)) descripcion
 FROM hist_integrado_tra,
  criterios_valores c1,
  criterios_valores c2
 WHERE
  c1.Item = secuencia
  And c2.item  = subsecuencia
  And c1.campo = 'Secuencia'
  And c2.campo = 'Subsecuencia'
  AND secuencia IN (1, 7, 8)
 UNION
--
-- FRA  REVISAR ÍNDICES DE HIST_INTEGRADO
--
 SELECT DISTINCT
  secuencia,
  subsecuencia,
  'W33_' + RTRIM(LTRIM(descripcion))
 FROM  hist_integrado,
  agr_conceptos_ns
 WHERE  secuencia=7
  And agr_conceptos ='W33'

 UNION
 SELECT DISTINCT
  secuencia,
  subsecuencia,
  'W22_' + RTRIM(LTRIM(descripcion))
 FROM  hist_integrado,
  agr_conceptos_ns
 WHERE  secuencia=4
  AND subsecuencia = 16
  And agr_conceptos ='W22'

 UNION
 SELECT DISTINCT
  secuencia,
  subsecuencia,
  'W21_' + RTRIM(LTRIM(descripcion))
 FROM  hist_integrado,
  agr_conceptos_ns
 WHERE  secuencia=8
  And agr_conceptos ='W21'
 ORDER BY descripcion, secuencia, subsecuencia

 OPEN cr_detalle_sdi

 FETCH cr_detalle_sdi INTO
  @secuencia,
  @sub_secuencia,
  @descripcion

 WHILE @@FETCH_STATUS = 0
 BEGIN

  SET @campo_view =
   ' (SELECT DISTINCT dato1 ' +
   '  FROM dbo.hist_integrado_tra ' +
   '  WHERE compania= v.compania' +
   '  AND trabajador= v.trabajador AND fecha = v.fecha' +
   '  AND secuencia= ' + CAST(@secuencia AS VARCHAR(2)) +
   '  AND subsecuencia= ' + CAST(@sub_secuencia AS VARCHAR(2)) +
   '  AND instancia =''' + @instancia + ''')' +
   ' AS [' + @descripcion +'], '

  SET @sentencia_view = @sentencia_view + @campo_view

  FETCH cr_detalle_sdi INTO
  @secuencia,
  @sub_secuencia,
  @descripcion
 END

 CLOSE cr_detalle_sdi
 DEALLOCATE cr_detalle_sdi

 /* Ultima Parte */

 SET @sentencia_view =
  @sentencia_view +
  ' instancia FROM vw_sdi v, trabajadores_grales tg' +
  ' WHERE tg.trabajador = v.trabajador AND tg.compania = v.compania AND instancia = ''' + @instancia + ''''

 IF RTRIM(@grupo_salario) <> ''
    BEGIN
       SET @sentencia_view = @sentencia_view + ' AND grupo_salario= ' + @grupo_salario
    END

 Execute (@sentencia_view)

   Return

END
Go

Grant Execute On dbo.sp_obten_sdi_fiscal to Public
Go

--
-- Comentarios.
--

Declare
   @w_valor          Varchar(1500) = 'Procedimiento que obtiene los datos de SDI Para el Reporte.',
   @w_procedimiento  Varchar( 100) = 'sp_obten_sdi_fiscal'


If Not Exists (Select Top 1 1
               From   sys.extended_properties a
               Join   sysobjects  b
               On     b.xtype   = 'P'
               And    b.name    = @w_procedimiento
               And    b.id      = a.major_id)

   Begin
      Execute  sp_addextendedproperty @name       = N'MS_Description',
                                      @value      = @w_valor,
                                      @level0type = 'Schema',
                                      @level0name = N'Dbo',
                                      @level1type = 'Procedure',
                                      @level1name = @w_procedimiento;

   End
