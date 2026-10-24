Use Adam
Go


/*
Declare
   @PsCompania            Char(     4)    = '1',
   @PnId_Calendario       Integer         = 1095,
   @PsOperacion           Char(     8)    = 'BBDISP01',
   @PsUsuario             Char(    20)    = 'ADAM',
   @PbSalida              Bit             = 1,
   @PnEstatus             Integer         = 0,
   @PsMensaje             Varchar(250)    = Null;
Begin

   Execute dbo.Spp_genLayoutBajio @PsCompania      = @PsCompania,
                                  @PnId_Calendario = @PnId_Calendario,
                                  @PsOperacion     = @PsOperacion,
                                  @PsUsuario       = @PsUsuario,
                                  @PbSalida        = @PbSalida,
                                  @PnEstatus       = @PnEstatus Output,
                                  @PsMensaje       = @PsMensaje Output;

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
            And    Name = 'Spp_genLayoutBajio')
   Begin
      Drop Procedure dbo.Spp_genLayoutBajio
   End
Go

Create Procedure dbo.Spp_genLayoutBajio
  (@PsCompania            Char(     4),
   @PnId_Calendario       Integer,
   @PsOperacion           Char(     8),
   @PsUsuario             Char(    20),
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
   @w_sit_periodo         Integer,
   @w_conc_neto           Integer,
   @w_existe              Integer,
   @w_desc_error          Varchar ( 250),
   @w_sql                 NVarchar(1500),
   @w_par                 NVarchar( 750),
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
   @w_bancoReceptor       Char(       3),
   @w_codigoNomina        Char(       2),
   @w_fechaGeneracion     Char(       8),
   @w_fecha_pago          Char(       8),
   @w_leyenda             Char(      40),
   @w_server              Sysname,
   @w_dbname              Sysname,
   @w_tabla               Sysname,
   @w_tablaProc           Sysname,
   @w_total_importe       Numeric(18, 2);

Begin
/*
  Autor:          Pedro Zambrano
  Descripción:    Procedimiento que genera archivo txt de dispersión de Nómina Banco Bajio.
  Creacion:       23-oct-2026.
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
          @w_fechaGeneracion = Replace(Convert(Char(11), GetDate(), 102), '.', ''),
          @w_server          = @@Servername,
          @w_dbname          = Db_name(),
          @w_tablaProc       = Replace('TablaLayoutBB_' + Substring(Cast(NEWID() as NVarchar(Max)), 1, 10), '-', '_');

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

   Select @w_fecha_pago = Replace(Convert(Char(11), fecha_pago, 102), '.', ''),
          @w_leyenda    = 'Nómina: ' + tipo_nomina + ', Período: ' + Cast(periodo As Varchar) +
                                  ', Año ' + Right('0000' + Cast(Anio As Char(4)), 4)
   From   calendario_procesos
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
                    From   transacciones_ns
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
   Where  compania            = '1'
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

   If @PbSalida Is Null
      Begin
         Select @PnEstatus = 8009,
                @PsMensaje = 'Error: La opción de Salida es obligatoria';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_sql = 'Select @o_total_importe = Sum(importe) '     +
                   'From   dbo.' + @w_tabla + ' ' +
                   'Where  compania        = ' + @w_comilla + @PsCompania + @w_comilla + ' ' +
                   'And    id_calendario   = ' + Cast(@PnId_calendario As Varchar)     + ' ' +
                   'And    concepto        = ' + Cast(@w_conc_neto     As Varchar)     + ' ' +
                   'And    sit_transaccion = 2 '                                             +
                   'And    importe         > 0 ',
          @w_par = '@o_total_importe Integer Output';

   Execute sp_executesql @w_sql, @w_par, @o_total_importe = @w_total_importe Output;

   If Isnull(@w_total_importe, 0) = 0
      Begin
         Select @PnEstatus = 8010,
                @PsMensaje = 'Error: Nómina no tiene Registros para Dispersar.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select top 1 1
                   From   dbo.criterios_valores
                   Where  campo  = 'SalBAJIO'
                   And    item   = @PbSalida)
     Begin
        Select @PnEstatus = 8011,
               @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': La opción de Salida esta fuera de rango. Validar con el Addministrador de Adam.';

        Set Xact_Abort         Off
        Raiserror (@PsMensaje, 16, 1)
        Return
     End

   Select @w_inst_deposito = ltrim(ltrim(descripcion))
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 2;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8012,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de entidad bancaria no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select Top 1 1
                   From   dbo.ins_depositos
                   Where  institucion_deposito = @w_inst_deposito)
      Begin
         Select @PnEstatus = 8013,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de entidad bancaria no se corresponde con la Banco Bajio. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_inst_tarjeta = ltrim(ltrim(descripcion))
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 12;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8014,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de entidad bancaria (Tarjeta) no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select Top 1 1
                   From   dbo.ins_depositos
                   Where  institucion_deposito = @w_inst_tarjeta)
      Begin
         Select @PnEstatus = 8015,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de entidad bancaria no se corresponde con la Banco Bajio. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_cuentaEmpresa = Substring(ltrim(ltrim(descripcion)), 1, 20)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 3;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8016,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de cuenta bancaria no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Set @w_cuentaEmpresa = Replicate('0', 20 - Len(Rtrim(Ltrim(@w_cuentaEmpresa)))) + Rtrim(Ltrim(@w_cuentaEmpresa));

   Select @w_gAfinidad = Substring(ltrim(ltrim(descripcion)), 1, 9)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 4;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8017,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de Grupo de Afinidad no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_bancoReceptor = Substring(ltrim(ltrim(descripcion)), 1, 3)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 10;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8019,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro de Banco Receptor no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_codigoNomina = Substring(ltrim(ltrim(descripcion)), 1, 2)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 11;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8020,
                @PsMensaje = 'Error ' + Cast(@PnEstatus As Varchar) + ': El parámetro Código de Operación para Nómina no Existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If @PbSalida = 1
      Begin
         Select @w_rutaCompleta = descripcion
         From   dbo.criterios_valores
         Where  campo  = 'BCOBAJIO'
         And    item   = 13;
         If @@Rowcount        = 0 Or
            @w_rutaCompleta  Is Null
            Begin
               Select @PnEstatus  = 8018,
                      @PsMensaje  = 'Error ' + Cast(@PnEstatus As Varchar) + ': La ruta y nombre del archivo de salida está parametrizado';

               Set Xact_Abort         Off
               Raiserror (@PsMensaje, 16, 1)
            End

        Set @w_rutaCompleta = Replace(@w_rutaCompleta, 'CIA',   Rtrim(Ltrim(@PsCompania)));
        Set @w_rutaCompleta = Replace(@w_rutaCompleta, 'IDCAL', Cast(@PnId_Calendario as Varchar));
        Set @w_log = Replace(@w_rutaCompleta, '.txt', '.log')

      End

--
--  Creación de tablas temporales.
--

   If Object_id('tempdb..#TempCabecero', 'U') Is Not Null
      Begin
         Drop Table #TempCabecero;
      End

   Create Table #TempCabecero
  (Secuencia        Integer           Not Null Identity (1, 1) Primary Key,
   nivel            Integer           Not NUll Default 1,
   tipoRegistro     Char(  2)         Not Null Default '01',
   numSecuencia     Char(  7)         Not Null Default '0000001',
   bancoReceptor    Char(  3)         Not Null,
   sentido          Char(  1)         Not Null Default 'S',
   codigo           Char(  2)         Not Null,
   filler1          Char(  1)         Not Null Default '0',
   gAfinidad        Char(  7)         Not Null,
   fechaGeneracion  Char(  8)         Not Null,
   numerocuenta     Char(  20)        Not Null,
   usofuturo        Char( 130)        Not Null Default Char(32),
   linea            Char( 181)        Not Null Default Char(32));

--

   If Object_id('tempdb..#TempDetalle', 'U') Is Not Null
      Begin
         Drop Table #TempDetalle;
      End

   Create Table #TempDetalle
  (secuencia          Integer           Not Null Identity (1, 1) Primary Key,
   nivel              Integer           Not Null Default 2,
   tipoRegistro       Char(  2)         Not Null Default '02',
   numeroSecuencia    Char(  7)         Not Null Default '0',
   codigoOperacion    Char(  2)         Not Null,
   fechaPresentacion  Char(  8)         Not Null,
   filler1            Char(  3)         Not Null Default '000',
   banco              Char(  3)         Not Null,
   importe            Char( 15)         Not Null,
   fechaAplicacion    Char(  8)         Not Null,
   fillerEmisor1      Char(  2)         Not Null Default '00',
   cuentaEmisor       Char( 20)         Not Null,
   fillerEmisor2      Char(  1)         Not Null Default Char(32),
   fillerReceptora1   Char(  2)         Not Null Default '00',
   cuentaTrab         Char( 20)         Not Null,
   fillerReceptora2   Char(  1)         Not Null Default Char(32),
   numero             Char(  7)         Not Null Default Char(32),
   leyenda            Char( 40)         Not Null Default Char(32),
   tarjeta            Char( 30)         Not Null Default Char(32),
   filler2            Char( 10)         Not Null Default Replicate('0', 10),
   linea              Char(181)         Not Null Default Char(32));

   If Object_id('tempdb..#TempSumario', 'U') Is Not Null
      Begin
         Drop Table #TempSumario;
      End

   Create Table #TempSumario
  (secuencia          Integer           Not Null Identity (1, 1) Primary Key,
   nivel              Integer           Not Null Default 3,
   tipoRegistro       Char(  2)         Not Null Default '09',
   numeroSecuencia    Char(  7)         Not Null Default '0',
   codigoOperacion    Char(  2)         Not Null,
   cantRegistros      Char(  7)         Not Null,
   importeTotal       Char( 18)         Not Null,
   filler1            Char(145)         Not Null Default Replicate(Char(32), 145),
   linea              Char(181)         Not Null Default Char(32));

   Begin Try
      If Exists (Select Top 1 1
                 From   Sys.tables
                 Where  name = @w_tablaProc)
         Begin
            Set @w_sql = 'Drop Table ' + @w_tablaProc
            Execute (@w_sql)
        End

      Set @w_sql = 'Create Table ' + @w_tablaProc +
                  '(secuencia        Integer          Not Null Identity (1, 1) Primary Key, ' +
                   'linea            Char(181)        Not Null Default Char(32))'
      Execute (@w_sql)
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

         Goto Salida
      End;

--
-- Inicio de Proceso.
--

--
-- Impresion Cabecero
--

   Begin Try
      Insert Into #TempCabecero
     (bancoReceptor,  codigo, gAfinidad, fechaGeneracion, numerocuenta)
      Values(@w_bancoReceptor, @w_codigoNomina, @w_gAfinidad, @w_fechaGeneracion, @w_cuentaEmpresa)

      Update #TempCabecero
      Set    Linea = tipoRegistro + numSecuencia + bancoReceptor + sentido         +
                     codigo       + filler1      + gAfinidad     + fechaGeneracion +
                     numerocuenta + usofuturo;

      Set @w_sql = 'Insert Into ' + @w_tablaProc +
                   '(linea)' +
                   'Select Linea ' +
                   'From   #TempCabecero'
     Execute (@w_sql)
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

         Goto Salida
      End;

--
-- Impresion detalle
--

   Set @w_sql = 'Select ' + @w_comilla + @w_codigoNomina                    + @w_comilla + ', '  +
                            @w_comilla + @w_fechaGeneracion                 + @w_comilla + ', '  +
                            @w_comilla + @w_bancoReceptor                   + @w_comilla + ', '  +
                            'Cast(a.importe As Varchar), '                                       +
                            @w_comilla + @w_fecha_pago                      + @w_comilla + ', '  +
                            @w_comilla + @w_cuentaEmpresa                   + @w_comilla + ', '  +
                            'Substring(dbo.Fn_BuscaCuentaBancTrabajador(a.compania, a.trabajador, '        +
                                         @w_comilla + @w_inst_deposito      + @w_comilla + '), 1, 20), ' +
                            @w_comilla + Cast(@PnId_Calendario As Varchar)  + @w_comilla + ', '  +
                            @w_comilla + @w_leyenda                         + @w_comilla + ', '  +
                            'Substring(dbo.Fn_BuscaCuentaBancTrabajador(a.compania, a.trabajador, '        +
                                         @w_comilla + @w_inst_tarjeta       + @w_comilla + '), 1, 16) ' +
                'From  ' + @w_tabla + ' a ' +
                'Where  compania      = ' + @w_comilla + @PsCompania + @w_comilla + ' ' +
                'And    id_calendario = ' + Cast(@PnId_calendario As Varchar)     + ' ' +
                'And    concepto      = ' + Cast(@w_conc_neto     As Varchar)     + ' ' +
                'And    importe       > 0 '                                             +
                'And    Exists        ( Select Top 1 1 ' +
                                       'From   rel_usu_clase_nom ' +
                                       'Where  clase_nomina = a.clase_nomina ' +
                                       'And    usuario      = ' + @w_comilla + @PsUsuario + @w_comilla + ') ' +
                'Order  By a.trabajador'

   Begin Try
      Insert Into #TempDetalle
     (codigoOperacion, fechaPresentacion,  banco,
      importe,         fechaAplicacion,    cuentaEmisor,
      cuentaTrab,      numero,             leyenda,
      tarjeta)
      Execute(@w_sql)
      Set @w_registros = @@Identity

      Update #TempDetalle
      Set    numeroSecuencia = Right('0000000' + Cast(secuencia As Varchar), 7),
             importe         = Right(Replicate('0', 15) + rtrim(ltrim(importe)), 15),
             cuentaTrab      = Right(Replicate('0', 20) + rtrim(ltrim(cuentaTrab)), 20),
             numero          = Right(Replicate('0',  7) + rtrim(ltrim(numero)), 7),
             tarjeta         = Right(Replicate('0', 30) + rtrim(ltrim(numero)), 30);

     Update #TempDetalle
     Set    linea =   tipoRegistro  + numeroSecuencia  + codigoOperacion + fechaPresentacion  +
                      filler1       + banco            + importe         + fechaAplicacion  +
                      fillerEmisor1 + cuentaEmisor     + fillerEmisor2   + fillerReceptora1 +
                      cuentaTrab    + fillerReceptora2 + numero          + leyenda          +
                      tarjeta       + filler2;

      Set @w_sql = 'Insert Into ' + @w_tablaProc +
                   '(linea)' +
                   'Select Linea ' +
                   'From   #TempDetalle'
     Execute (@w_sql)

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

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End;

--
-- Impresion Línea de Sumario.
--
   Begin Try
      Insert Into #TempSumario
     (numeroSecuencia, codigoOperacion, cantRegistros, importeTotal)
      Select Cast( @w_registros + 1 As Varchar),  @w_codigoNomina, Cast( @w_registros as Varchar),
             Cast(@w_total_importe As Varchar)

      Update #TempSumario
      Set    numeroSecuencia = Right(Replicate('0', 7) + Ltrim(Rtrim(numeroSecuencia)), 7),
             cantRegistros   = Right(Replicate('0', 7) + Ltrim(Rtrim(cantRegistros)),   7),
             importeTotal    = Right(Replicate('0', 7) + Ltrim(Rtrim(importeTotal)),    7);

      Update #TempSumario
      Set    linea = tipoRegistro + numeroSecuencia + codigoOperacion + cantRegistros +
                     importeTotal + filler1;

      Set @w_sql = 'Insert Into ' + @w_tablaProc +
                   '(linea)' +
                   'Select Linea ' +
                   'From   #TempSumario'
     Execute (@w_sql)

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

         Set Xact_Abort         Off
         Raiserror (@PsMensaje, 16, 1)
         Return
      End;

--
-- Salida como Archivo Txt
--

   If @PbSalida = 1
      Begin
         Set @w_sql = 'Select Linea '                          +
                      'From ' + @w_dbname + '.dbo.' + @w_tablaProc + ' ' +
                      'Order by secuencia'

         Set @w_sql = 'bcp "' + @w_sql + '" queryout "' + @w_rutaCompleta + '" -o ' + @w_log + ' -c -t -T -S' + @w_server

         Begin Try
            Execute  master..xp_cmdshell @w_sql
         End  Try

         Begin Catch
            Select  @w_Error      = @@Error,
                    @w_desc_error = 'Error.: ' +  Substring (Error_Message(), 1, 230)

         End   Catch

         If Isnull(@w_Error, 0) <> 0
            Begin
               Select @PnEstatus = @w_Error,
                      @PsMensaje = 'Error.: ' + Rtrim(Ltrim(Cast(@w_Error As Varchar))) + ' ' + @w_desc_error

            End
      End
   Else
      Begin
         Set @w_sql = 'Select Linea '                        +
                      'From ' + '.dbo.' + @w_tablaProc + ' ' +
                      'Order by secuencia'
        Execute (@w_sql)
     End;

Salida:

   If Object_id('tempdb..#TempCabecero', 'U') Is Not Null
      Begin
         Drop Table #TempCabecero;
      End

   If Object_id('tempdb..#TempDetalle', 'U') Is Not Null
      Begin
         Drop Table #TempDetalle;
      End

   If Object_id('tempdb..#TempSumario', 'U') Is Not Null
      Begin
         Drop Table #TempSumario;
      End

    Begin Try
       If Exists (Select Top 1 1
                  From   Sys.tables
                  Where  name = @w_tablaProc)
          Begin
             Set @w_sql = 'Drop Table ' + @w_tablaProc
             Execute (@w_sql)
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

         Goto Salida
      End;

   Set Xact_Abort         Off
   Return

End
Go

Grant Execute On dbo.Spp_genLayoutBajio to Public
Go

--
-- Comentarios.
--

Declare
   @w_valor          Varchar(1500) = 'Procedimiento que que genera el layout de dispersión Banco Bajio.',
   @w_procedimiento  Varchar( 100) = 'Spp_genLayoutBajio',
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
