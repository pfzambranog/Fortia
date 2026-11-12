Use Adam
Go


-- /*
-- Declare
   -- @PsCompania            Char(     4),
   -- @PnId_Calendario       Integer     ,
   -- @PsOperacion           Char(     8),
   -- @PsUsuario             Char(    20),
   -- @PnEstatus             Integer     ,
   -- @PsMensaje             Varchar(512);
-- Begin

   -- Select @PsCompania          = 'SYPR',
          -- @PnId_Calendario     = 2662,
          -- @PsOperacion         = 'BBDISP01',
          -- @PsUsuario           = 'adam',
          -- @PnEstatus           = 0,
          -- @PsMensaje           = Null;

   -- Execute dbo.spc_repLayoutBajio @PsCompania      = @PsCompania,
                                  -- @PnId_Calendario = @PnId_Calendario,
                                  -- @PsOperacion     = @PsOperacion,
                                  -- @PsUsuario       = @PsUsuario,
                                  -- @PnEstatus       = @PnEstatus Output,
                                  -- @PsMensaje       = @PsMensaje Output;

   -- If @PnEstatus != 0
      -- Begin
         -- Select @PnEstatus  IdError, @PsMensaje MensajeError;
     -- End

   -- Return;

-- End;
-- Go
-- */

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'P'
            And    Name = 'spc_repLayoutBajio')
   Begin
      Drop Procedure dbo.spc_repLayoutBajio
   End
Go

Create Procedure dbo.spc_repLayoutBajio
  (@PsCompania            Char(     4),
   @PnId_Calendario       Integer,
   @PsOperacion           Char(     8),
   @PsUsuario             Char(    20),
   @PnEstatus             Integer         = 0    Output,
   @PsMensaje             Varchar(512)    = Null Output)
As

Declare
   @w_idObjeto            Integer,
   @w_objArchivo          Integer,
   @w_Error               Integer,
   @w_secuencia           Integer,
   @w_registros           Integer,
   @w_sit_periodo         Integer,
   @w_conc_neto           Integer,
   @w_existe              Integer,
   @w_desc_error          Varchar ( 250),
   @w_nombreEntidad       Varchar ( 100),
   @w_claseNomina         Varchar ( 100),
   @w_periodo             Varchar (  20),
   @w_sql                 NVarchar(1500),
   @w_par                 NVarchar( 750),
   @w_inst_deposito       Char(      20),
   @w_tipoNomina          Char(       2),   
   @w_comilla             Char(       1),
   @w_fechaGeneracion     Char(      10),
   @w_fecha_pago          Char(      10),
   @w_tabla               Sysname,
   @w_total_importe       Numeric(18, 2);

Begin
/*
  Autor:          Pedro Zambrano
  Descripción:    Procedimiento que genera Reporte de dispersión de Nómina Banco Bajio.
  Creacion:       11-Nov-2026
  Version:        1.0
*/

   Set Nocount            On
   Set Xact_Abort         On
   Set Ansi_Nulls         On

   Select @PnEstatus         = 0,
          @w_secuencia       = 0,
          @PsMensaje         = Char(32),
          @w_comilla         = Char(39),
          @w_fechaGeneracion = Convert(Char(10), Getdate(), 103);

--
-- Validaciones y Consulta de Parametros
--

   If Not Exists (Select Top 1 1
                  From   dbo.companias
                  Where  compania = @PsCompania)
      Begin
         Select @PnEstatus = 8001,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': la compañia seleccionada [' + @PsCompania + '] No es Valida.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         Off
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.aut_companias
                  Where  compania = @PsCompania
                  And    usuario  = @PsUsuario )
      Begin
         Select @PnEstatus = 8002,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El Usuario no tiene permiso a la compañia seleccionada ['
                                      + @PsCompania + '].'
                                      + ' Validar con el Addministrador de Adam.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         Off
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.aut_operaciones
                  Where  operacion       = @PsOperacion
                  And    usuario         = @PsUsuario
                  And    nivel_seguridad = 4)
      Begin
         Select @PnEstatus = 8003,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El Usuario no tiene permiso a la operación seleccionada ['
                                      + @PsOperacion + '].'
                                      + ' Validar con el Addministrador de Adam.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         Off
         Return
      End

   Select @w_sit_periodo = sit_periodo
   From   dbo.cal_proc_cias
   Where  compania = @PsCompania
   And    id_calendario = @PnId_Calendario;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8004,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El Id Calendario Seleccionado ['
                                      + Cast(@PnId_Calendario as Varchar)
                                      + '] No es Válido en la compañia. [' + @PsCompania + ']';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         Off
         Return
      End

   Select @w_fecha_pago = Convert(Char(10), fecha_pago, 103),
          @w_periodo    = Right('0000' + Cast(Anio As Char(4)), 4) + '-' + Cast(periodo As Varchar),
          @w_tipoNomina = tipo_nomina
   From   dbo.calendario_procesos
   Where  id_calendario = @PnId_Calendario;

   If @w_sit_periodo > 2
      Begin
         Select @PnEstatus = 8005,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El Id Calendario Seleccionado ['
                                      + Cast(@PnId_Calendario as Varchar)
                                      + '] se encuentra con transacciones pendietes de cálculo.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         Off
         Return
      End

   Set @w_tabla = Case When @w_sit_periodo = 1
                       Then 'TRANSACCIONES_NS'
                       Else 'TRANS_' + Rtrim(Ltrim(@PsCompania)) + '_' + rtrim(ltrim(Cast(@PnId_calendario As Varchar)))
                  End;

   If @w_sit_periodo = 1
      Begin
         If Exists (Select top 1 1
                    From   dbo.transacciones_ns
                    Where  compania        = @PsCompania
                    And    id_calendario   = @PnId_calendario
                    And    sit_transaccion = 1)
            Begin
               Select @PnEstatus = 8006,
                      @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El Id Calendario Seleccionado ['
                                            + Cast(@PnId_Calendario as Varchar)
                                            + '] se encuentra en situación de error';

               Raiserror (@PsMensaje, 16, 1)
               Set Xact_Abort         Off
               Return
            End
      End

   Execute @w_existe = sp_existe_tabla  @w_tabla

   If @w_existe = 0
      Begin
         Select @PnEstatus = 8007,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': La tabla de nómina relacionada al id_calendario No existe.' +
                                      + ' Validar con el Addministrador de Adam.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         Off
         Return
      End

   Select @w_conc_neto = Isnull(entero, 0)
   From   dbo.parametros_rh
   Where  compania            = @PsCompania
   And    parametro_rh        = 'Conc_Neto'
   And    secuencia_parametro = 1
   If @@Rowcount   = 0 Or
      @w_conc_neto = 0
      Begin
         Select @PnEstatus = 8008,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El Concepto Neto de Nómina no está Parametrizado.'
                                      + 'Validar con el Addministrador de Adam.'

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         Off
         Return
      End

   Select @w_inst_deposito = ltrim(ltrim(descripcion))
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 2;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8009,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de entidad bancaria no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_nombreEntidad = descripcion
   From   dbo.ins_depositos
   Where  institucion_deposito = @w_inst_deposito;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8010,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de entidad bancaria no se corresponde con la Banco Bajio. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

--
--  Creación de tablas temporales.
--

   If Object_id('tempdb..#TempDetalle', 'U') Is Not Null
      Begin
         Drop Table #TempDetalle;
      End

   Create Table #TempDetalle
  (trabajador         Char( 10)         Not Null Primary Key,
   nombre             Char(100)         Not Null Default Char(32),
   cuentaBancaria     Char( 30)         Not Null Default Char(30),
   clase_nomina       Char(  2)         Not Null,
   importe            Decimal(18, 2)    Not Null);
   
--
-- Inicio de Proceso.
--

   Set @w_sql = 'Select a.trabajador, b.cuenta_deposito, a.clase_nomina, a.importe ' +
                'From   dbo.' + @w_tabla  + ' a ' +
                'Join   dbo.rel_trab_ins_dep b ' +
                'On     b.compania             = a.compania ' +
                'And    b.trabajador           = a.trabajador ' +
                'And    b.institucion_deposito = ' + @w_comilla + @w_inst_deposito + @w_comilla  + ' ' +
                'Where  a.compania             = ' + @w_comilla + @PsCompania      + @w_comilla  + ' ' +
                'And    id_calendario          = ' + Cast(@PnId_calendario As Varchar)     + ' ' +
                'And    concepto               = ' + Cast(@w_conc_neto     As Varchar)     + ' ' +
                'And    importe                > 0 '                                             +
                'And    Exists                 ( Select Top 1 1 ' +
                                                'From   rel_usu_clase_nom ' +
                                                'Where  clase_nomina = a.clase_nomina ' +
                                                'And    usuario      = ' + @w_comilla + @PsUsuario + @w_comilla + ') ' +
                'Order  By a.trabajador'

   Insert Into #TempDetalle
  (trabajador, cuentaBancaria, clase_nomina, importe)
   Execute(@w_sql)
  
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8011,
                @PsMensaje = 'Error: Nómina no tiene Registros para Dispersar.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Goto Salida
      End  

   Update #TempDetalle
   Set    nombre =  Replace(b.nombre, '/', ' ')
   From   #TempDetalle     a
   Join   dbo.trabajadores b
   On     b.trabajador = a.trabajador
   
   Set @w_error     = @@Error
   Set @w_registros = @@Identity

   If @w_error != 0
      Begin
         Select @PnEstatus = @w_error,
                @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
         Goto Salida;

      End

   Select @w_nombreEntidad   Banco,           clase_nomina,   @w_tipoNomina   TipoNomina,
          @w_fechaGeneracion fechaGeneracion, @w_periodo      periodo,        @w_fecha_pago
          fecha_pago,        trabajador,      nombre,         cuentaBancaria, importe
   From   #TempDetalle

Salida:

   If Object_id('tempdb..#TempDetalle', 'U') Is Not Null
      Begin
         Drop Table #TempDetalle;
      End

   Set Xact_Abort         Off
   Return

End
Go

Grant Execute On dbo.spc_repLayoutBajio to Public
Go

--
-- Comentarios.
--

-- Declare
   -- @w_valor          Varchar(1500) = 'Procedimiento que que genera el Reporte de dispersión Banco Bajio.',
   -- @w_procedimiento  Varchar( 100) = 'spc_repLayoutBajio',
   -- @w_tipo           Varchar(  20) = 'Procedure';

-- If Not Exists (Select Top 1 1
               -- From   sys.extended_properties a
               -- Join   sysobjects  b
               -- On     b.xtype   = 'P'
               -- And    b.name    = @w_procedimiento
               -- And    b.id      = a.major_id)

   -- Begin
      -- Execute  sp_addextendedproperty @name       = N'MS_Description',
                                      -- @value      = @w_valor,
                                      -- @level0type = 'Schema',
                                      -- @level0name = N'Dbo',
                                      -- @level1type = @w_tipo,
                                      -- @level1name = @w_procedimiento;

   -- End
-- Else
   -- Begin
      -- Execute sp_updateextendedproperty @name       = 'MS_Description',
                                        -- @value      = @w_valor,
                                        -- @level0type = 'Schema',
                                        -- @level0name = N'Dbo',
                                        -- @level1type = @w_tipo,
                                        -- @level1name = @w_procedimiento
   -- End
-- Go
