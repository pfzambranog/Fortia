Use Adam
Go


/*
Declare
   @PsCompania            Char(     4)    = '1',
   @PsTrabajador          Char(    10)    = '6',
   @PsCuenta_deposito     Char(    20)    = '1019258462'
   @PsTarjeta             Char(    16)    = Null,
   @PnEstatus             Integer         = 0,
   @PsMensaje             Varchar(250)    = Null;
Begin

   Execute dbo.Spa_BB_empleados @PsCompania        = @PsCompania,
                                @PsTrabajador      = @PsTrabajador,
                                @PsCuenta_deposito = @PsCuenta_deposito,
                                @PsTarjeta         = @PsTarjeta,
                                @PnEstatus         = @PnEstatus Output,
                                @PsMensaje         = @PsMensaje Output;

   If @PnEstatus != 0
      Begin
         Select @PnEstatus  IdError, @PsMensaje MensajeError;
     End

   Return;

End;
Go
*/

If Exists ( Select Top 1 1
            From   sysobjects
            Where  Uid  = 1
            And    Type = 'P'
            And    Name = 'Spa_BB_empleados')
   Begin
      Drop Procedure dbo.Spa_BB_empleados
   End
Go

Create Procedure dbo.Spa_BB_empleados
  (@PsCompania            Char(     4),
   @PsTrabajador          Char(    10),
   @PsCuenta_deposito     Char(    20),
   @PsTarjeta             Char(    16),
   @PnEstatus             Integer         = 0    Output,
   @PsMensaje             Varchar(250)    = Null Output)
As

Declare
   @w_Error               Integer,
   @w_linea               Integer,
   @w_registro            Integer,
   @w_idEstatus           Tinyint,
   @w_desc_error          Varchar ( 250),
   @w_trabajador          Varchar (  10),
   @w_inst_deposito       Varchar (  20),
   @w_usuario             Varchar (  20),
   @w_operacion           Varchar (   8);


Begin
/*
  Autor:          Pedro Zambrano
  Descripción:    Procedimiento que Procesael Alta de Registros a la tabla BB_AltasEmpleadosTbl.
  Creacion:       18-oct-2026.
  Version:        1.0
*/

   Set Quoted_identifier Off
   Set Nocount            On
   Set Xact_Abort         On
   Set Ansi_Nulls         On

   Select @PnEstatus         = 0,
          @PsMensaje         = Char(32),
          @w_trabajador      = dbo.fn_formato_trabajador(@PsTrabajador),
          @PsCuenta_deposito = Rtrim(LTrim(@PsCuenta_deposito)),
          @w_usuario         = System_user,
          @PsTarjeta         = Case When Isnull(@PsTarjeta, '0') = '0'
                                    Then Replicate('0', 16)
                                    When Ltrim(Rtrim(@PsTarjeta)) = ''
                                    Then Replicate('0', 16)
                                    Else @PsTarjeta
                               End;

--
-- Validaciones y Consulta de Parametros
--

   Select top 1 @w_operacion = Substring(descripcion, 1, 8)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 8;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8001,
                @PsMensaje = 'Error 8001: La Opcion de la Operación no está dada de alta. Validar con el Responsable de Adam.';

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         On
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.aut_operaciones
                  Where  operacion       = @w_operacion
                  And    usuario         = @w_usuario
                  And    nivel_seguridad > 1)
      Begin
         Select @PnEstatus = 8002,
                @PsMensaje = 'Error 8002: El Usuario no tiene permiso a la operación seleccionada ' + @w_operacion;

         Raiserror (@PsMensaje, 16, 1)
         Set Xact_Abort         On
         Return
      End

   Begin Try
      Select @w_registro = registro
      From   dbo.BB_AltasEmpleadosTbl
      Where  compania                 = @PsCompania
      And    Rtrim(Ltrim(trabajador)) = Rtrim(Ltrim(@PsTrabajador))
      If @@Rowcount = 0
         Begin
            Insert Into dbo.BB_AltasEmpleadosTbl
           (compania, trabajador, cuenta_deposito, tarjeta, usuarioAct)
            Select @PsCompania, @Pstrabajador, @PsCuenta_deposito, @PsTarjeta, @w_usuario;

            Set @w_registro = @@Identity;
         End
      Else
         Begin
            Update dbo.BB_AltasEmpleadosTbl
            Set    cuenta_deposito = @PsCuenta_deposito,
                   idEstatus       = 0,
                   idError         = 0,
                   Mensaje         = Char(32),
                   fechaProceso    = Getdate(),
                   usuarioAct      = @w_usuario
            Where  registro        = @w_registro;
        End

   End Try

   Begin Catch
      Select  @w_Error      = Error_number(),
              @w_linea      = Error_line(),
              @w_desc_error = Substring (Error_Message(), 1, 230)
   End   Catch

   If IsNull(@w_Error, 0) <> 0
      Begin
         Select @PnEstatus = @w_error,
                @PsMensaje = 'Error.: ' + Rtrim(@w_desc_error) + ' en linea ' + Cast(@w_linea as Varchar);

         Set Xact_Abort         On
         Return

      End;

   If Len(@PsTarjeta) != 16
      Begin
         Select @PnEstatus = 8003,
                @PsMensaje = 'Error: La longitud de la tarjeta No es Valida.';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 4,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.companias
                  Where  compania = @PsCompania)
      Begin
         Select @PnEstatus = 8004,
                @PsMensaje = 'Error: La compañia seleccionada [' + @PsCompania + '] No es Valida.';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 3,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.trabajadores
                  Where  trabajador = @w_trabajador)
      Begin
         Select @PnEstatus = 8005,
                @PsMensaje = 'Error: El código de trabajador seleccionado [' + @w_trabajador + '] No es Valido.';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 3,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   Select @w_idEstatus = sit_trabajador
   From   dbo.trabajadores_grales
   Where  compania   = @PsCompania
   And    trabajador = @w_trabajador
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8006,
                @PsMensaje = 'Error: El código de trabajador seleccionado [' + @w_trabajador + '] No esta Relacionado a la Compañía . [' + @PsCompania + ']';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 3,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   If @w_idEstatus != 1
      Begin
         Select @PnEstatus = 8007,
                @PsMensaje = 'Error: El trabajador seleccionado [' + @w_trabajador + '] No esta Activo.';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 2,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   Select @w_inst_deposito = ltrim(ltrim(descripcion))
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 2;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8008,
                @PsMensaje = 'Error: El parámetro de entidad bancaria no existe. Validar con el Responsable de Adam.';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 3,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         -- Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select Top 1 1
                   From   dbo.ins_depositos
                   Where  institucion_deposito = @w_inst_deposito)
      Begin
         Select @PnEstatus = 8009,
                @PsMensaje = 'Error: El parámetro de entidad bancaria no se corresponde con la Banco Bajio. Validar con el Responsable de Adam.';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 3,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   If Exists (Select Top 1 1
              From   dbo.BB_AltasEmpleadosTbl
              Where  compania             = @PsCompania
              And    trabajador          != @PsTrabajador
              And    cuenta_deposito      = @PsCuenta_deposito)
      Begin
         Select @PnEstatus = 8010,
                @PsMensaje = 'Error: La Cuenta Bancaria Esta Asignada en el Proceso a otro Trabajador';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 4,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   If Exists (Select Top 1 1
              From   dbo.rel_trab_ins_dep
              Where  compania             = @PsCompania
              And    trabajador          != @w_trabajador
              And    institucion_deposito = @w_inst_deposito
              And    cuenta_deposito      = @PsCuenta_deposito)
      Begin
         Select @PnEstatus = 8011,
                @PsMensaje = 'Error: La Cuenta Bancaria Esta Asignada a otro Trabajador';

         Update dbo.BB_AltasEmpleadosTbl
         Set    idEstatus    = 3,
                idError      = @PnEstatus,
                Mensaje      = @PsMensaje
         Where  registro     = @w_registro;

         Set Xact_Abort         On
         Return
      End

   If @PsTarjeta != Replicate('0', 16)
      Begin
         If Exists (Select Top 1 1
                    From   dbo.BB_AltasEmpleadosTbl
                    Where  compania             = @PsCompania
                    And    trabajador          != @PsTrabajador
                    And    tarjeta              = @PsTarjeta)
            Begin
               Select @PnEstatus = 8012,
                      @PsMensaje = 'Error: La Tarjeta Bancaria Esta Asignada en el Proceso a otro Trabajador';
      
               Update dbo.BB_AltasEmpleadosTbl
               Set    idEstatus    = 3,
                      idError      = @PnEstatus,
                      Mensaje      = @PsMensaje
               Where  registro     = @w_registro;
      
               Set Xact_Abort On
               Return
            End
      End

   Set Xact_Abort         On
   Return

End
Go

Grant Execute On dbo.Spa_BB_empleados to Public
Go

--
-- Comentarios.
--

Declare
   @w_valor          Varchar(1500) = 'Procedimiento que que genera archivo txt de alta empleados Banco Bajio.',
   @w_procedimiento  Varchar( 100) = 'Spa_BB_empleados',
   @w_tipo           Varchar(  20) = 'Procedure';

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
                                      @level1type = @w_tipo,
                                      @level1name = @w_procedimiento;

   End
Else
   Begin
      Execute sp_updateextendedproperty @name       = 'MS_Description',
                                        @value      = @w_valor,
                                        @level0type = 'Schema',
                                        @level0name = N'Dbo',
                                        @level1type = @w_tipo,
                                        @level1name = @w_procedimiento
   End
Go

