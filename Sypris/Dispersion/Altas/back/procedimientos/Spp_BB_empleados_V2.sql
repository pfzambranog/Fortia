Use Adam
Go


-- /*
-- Declare
   -- @PsCompania            Char(     4),
   -- @PbActualiza           Bit,
   -- @PnEstatus             Integer,
   -- @PsMensaje             Varchar(250);
-- Begin

   -- Select    @PsCompania   = 'SYPR',
             -- @PbActualiza  = 1,
             -- @PnEstatus    = 0,
             -- @PsMensaje    = Null;

   -- Execute dbo.Spp_BB_empleados @PsCompania   = @PsCompania,
                                -- @PbActualiza  = @PbActualiza,
                                -- @PnEstatus    = @PnEstatus Output,
                                -- @PsMensaje    = @PsMensaje Output;

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
            And    Name = 'Spp_BB_empleados')
   Begin
      Drop Procedure dbo.Spp_BB_empleados
   End
Go

Create Procedure dbo.Spp_BB_empleados
  (@PsCompania            Char(     4),
   @PbActualiza           Bit             = 0,
   @PbSalida              Tinyint         = 0,                          -- 0 = 1 = Archivo Texto en DD,
   @PnEstatus             Integer         = 0    Output,
   @PsMensaje             Varchar(250)    = Null Output)
As

Declare
   @w_idObjeto            Integer,
   @w_objArchivo          Integer,
   @w_Error               Integer,
   @w_secuencia           Integer,
   @w_registros           Integer,
   @w_linea               Integer,
   @w_desc_error          Varchar ( 250),
   @w_sql                 NVarchar(1500),
   @w_Contenido           Varchar (8000),
   @w_rutaCompleta        Varchar ( 255),
   @w_log                 Varchar ( 255),
   @w_fuente              Varchar ( 255),
   @w_descripcion         Varchar ( 255),
   @w_inst_deposito       Char(      20),
   @w_inst_tarjeta        Char(      20),
   @w_cuentaEmpresa       Char(      20),
   @w_comilla             Char(       1),
   @w_gAfinidad           Char(       9),
   @w_sucursal            Char(       7),
   @w_operacion           Char(       8),
   @w_usuario             Char(      30),
   @w_cuenta_deposito     Char(      40),
   @w_tarjeta             Char(      40),
   @w_indice_inf_soc      Char(      10),
   @w_trabajador          Char(      10),
   @w_idEstatus           Tinyint,
   @w_server              Sysname,
   @w_dbname              Sysname;

Begin
/*
  Autor:          Pedro Zambrano
  Descripción:    Procedimiento que genera archivo txt de alta empleados Banco Bajio.
  Creacion:       18-oct-2026.
  Version:        1.0
*/

   Set Quoted_identifier Off
   Set Nocount            On
   Set Xact_Abort         On
   Set Ansi_Nulls         On

   Select @PnEstatus         = 0,
          @w_secuencia       = 0,
          @PsMensaje         = Char(32),
          @w_comilla         = Char(39),
          @w_sucursal        = Replicate(7, ' '),
          @w_usuario         = System_user,
          @w_server          = @@Servername,
          @w_dbname          = Db_name();

--
-- Validaciones y Consulta de Parametros
--

   If Not Exists (Select Top 1 1
                  From   dbo.companias
                  Where  compania = @PsCompania)
      Begin
         Select @PnEstatus = 8001,
                @PsMensaje = 'Error: la compañia seleccionada ' + @PsCompania + ' No es Valida.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         On
         Return
      End


   If Not Exists (Select Top 1 1
                  From   dbo.aut_companias
                  Where  compania = @PsCompania
                  And    usuario  = @w_usuario )
      Begin
         Select @PnEstatus = 8002,
                @PsMensaje = 'Error: El Usuario no tiene permiso a la compañia seleccionada ' + @PsCompania;

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         On
         Return
      End

   Select top 1 @w_operacion = Substring(descripcion, 1, 8)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 9;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8003,
                @PsMensaje = 'Error 8001: La Opcion de la Operación no está dada de alta. Validar con el Responsable de Adam.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         On
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.aut_operaciones
                  Where  operacion       = @w_operacion
                  And    usuario         = @w_usuario
                  And    nivel_seguridad = 4)
      Begin
         Select @PnEstatus = 8004,
                @PsMensaje = 'Error 8002: El Usuario no tiene permiso a la operación seleccionada ' + @w_operacion;

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         On
         Return
      End

   Select @w_inst_deposito = ltrim(ltrim(descripcion))
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 2;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8005,
                @PsMensaje = 'Error: El parámetro de entidad bancaria no existe. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select Top 1 1
                   From   dbo.ins_depositos
                   Where  institucion_deposito = @w_inst_deposito)
      Begin
         Select @PnEstatus = 806,
                @PsMensaje = 'Error: El parámetro de entidad bancaria no se corresponde con la Banco Bajio. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_cuentaEmpresa = Substring(ltrim(ltrim(descripcion)), 1, 20)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 3;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8007,
                @PsMensaje = 'Error: El parámetro de cuenta bancaria no existe. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.BB_AltasEmpleadosTbl
                  Where  Compania  = @PsCompania
                  And    idEstatus = 0)
      Begin
         Select @PnEstatus  = 8008,
                @PsMensaje  = 'Error: No Existen Registros Pendientes, para Procesar el Reporte';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_inst_tarjeta = ltrim(ltrim(descripcion))
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 12;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8009,
                @PsMensaje = 'Error: El parámetro de entidad bancaria (Tarjeta) no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End
      
   If Not Exists ( Select Top 1 1
                   From   dbo.ins_depositos
                   Where  institucion_deposito = @w_inst_tarjeta)
      Begin
         Select @PnEstatus = 8010,
                @PsMensaje = 'Error: El parámetro de entidad bancaria no se corresponde con la Banco Bajio. Validar con el Addministrador de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

--
-- Proceso
--

   If @PbActualiza = 1
      Begin
         Select @w_secuencia = Min(registro) -1,
                @w_registros = max(registro)
         From   dbo.BB_AltasEmpleadosTbl
         Where  idEstatus = 0;

         Begin Tran
               
               While @w_secuencia < @w_registros
               Begin
                  Set @w_secuencia = @w_secuencia + 1;
                  
                  Select @w_trabajador      = dbo.fn_formato_trabajador(@w_trabajador),
                         @w_idEstatus       = idEstatus,
                         @w_cuenta_deposito = cuenta_deposito,
                         @w_tarjeta         = Case When Isnull(tarjeta, '0') = '0'
                                                   Then Replicate('0', 16)
                                                   When Ltrim(Rtrim(tarjeta)) = ''
                                                   Then Replicate('0', 16)
                                                   Else tarjeta
                                              End
                  From   dbo.BB_AltasEmpleadosTbl
                  Where  registro = @w_secuencia;
                  If @@Rowcount = 0
                     Begin
                        Set @w_idEstatus = 9;
                     End

                  If  @w_idestatus = 0
                      Begin
                      
                         Update dbo.rel_trab_ins_dep
                         Set    ins_dep_principal = 0
                         Where  compania             = @PsCompania
                         And    trabajador           = @w_trabajador;
                         Set @w_Error = @@Error
                         If @w_error != 0
                            Begin
                               Rollback Tran
                               Select @PnEstatus = @w_error,
                                      @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
                               Return;
                               
                            End

                         If Exists ( Select Top 1 1
                                     From   dbo.rel_trab_ins_dep
                                     Where  compania             = @PsCompania
                                     And    trabajador           = @w_trabajador
                                     And    institucion_deposito = @w_inst_deposito)
                            Begin
                               Update dbo.rel_trab_ins_dep
                               Set    cuenta_deposito   = @w_cuenta_deposito,
                                      ins_dep_principal = 1
                               Where  compania             = @PsCompania
                               And    trabajador           = @w_trabajador
                               And    institucion_deposito = @w_inst_deposito;
                            End
                         Else
                            Begin
                               Insert Into dbo.rel_trab_ins_dep
                              (compania, trabajador, institucion_deposito, cuenta_deposito,
                               ins_dep_principal)
                               Select @PsCompania, @w_trabajador, @w_inst_deposito, @w_cuenta_deposito,
                                     1
                            End

                         Set @w_Error = @@Error
                         If @w_error != 0
                            Begin
                               Rollback Tran
                               Select @PnEstatus = @w_error,
                                      @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
                               Return;
                               
                            End
                            
--
-- Actualización Datos de tarjeta
--

                         If Exists ( Select Top 1 1
                                     From   dbo.rel_trab_ins_dep
                                     Where  compania             = @PsCompania
                                     And    trabajador           = @w_trabajador
                                     And    institucion_deposito = @w_inst_tarjeta)
                            Begin
                               Update dbo.rel_trab_ins_dep
                               Set    cuenta_deposito   = @w_tarjeta,
                                      ins_dep_principal = 0
                               Where  compania             = @PsCompania
                               And    trabajador           = @w_trabajador
                               And    institucion_deposito = @w_inst_tarjeta;
                            End
                         Else
                            Begin
                               Insert Into dbo.rel_trab_ins_dep
                              (compania, trabajador, institucion_deposito, cuenta_deposito,
                               ins_dep_principal)
                               Select @PsCompania, @w_trabajador, @w_inst_tarjeta, @w_tarjeta,
                               0
                            End

                         Set @w_Error = @@Error;
                         If @w_error != 0
                            Begin
                               Rollback Tran
                               Select @PnEstatus = @w_error,
                                      @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
                               Return;
                               
                            End                         
--
-- Actualización Entidad de Control
--
               
                         Update dbo.BB_AltasEmpleadosTbl
                         Set    idEstatus     = 1,
                                fechaProceso  = Getdate()
                         Where  registro = @w_secuencia;

                         Set @w_Error = @@Error
                         If @w_error != 0
                            Begin
                               Rollback Tran
                               Select @PnEstatus = @w_error,
                                      @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
                               Return;
                               
                            End 
                         
                      End -- If  @w_estatus = 0
                      
               End;    -- While

         Commit Tran;

      End

Salida:

   Set Xact_Abort         On
   Return

End
Go

Grant Execute On dbo.Spp_BB_empleados to Public
Go

--
-- Comentarios.
--

-- Declare
   -- @w_valor          Varchar(1500) = 'Procedimiento que genera la alta empleados en le entidad Banco Bajio.',
   -- @w_procedimiento  Varchar( 100) = 'Spp_BB_empleados',
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

