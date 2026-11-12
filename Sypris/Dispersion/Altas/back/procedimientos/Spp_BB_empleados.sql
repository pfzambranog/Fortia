Use Adam
Go


/*
-- Declare
   -- @PsCompania            Char(     4)    = '1',
   -- @PbSalida              Bit             = 1,
   -- @PbActualiza           Bit             = 0,
   -- @PnEstatus             Integer         = 0,
   -- @PsMensaje             Varchar(512)    = Null;
-- Begin

   -- Execute dbo.Spp_BB_empleados @PsCompania   = @PsCompania,
                                -- @PbActualiza  = @PbActualiza,
                                -- @PbSalida     = @PbSalida,
                                -- @PnEstatus    = @PnEstatus Output,
                                -- @PsMensaje    = @PsMensaje Output;

   -- If @PnEstatus != 0
      -- Begin
         -- Select @PnEstatus  IdError, @PsMensaje MensajeError;
     -- End

   -- Return;

-- End;
-- Go
*/

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
   @PsMensaje             Varchar(512)    = Null Output)
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

   If @PbSalida Is Null
      Begin
         Select @PnEstatus = 8005,
                @PsMensaje = 'Error: La opción de Salida es obligatoria';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select top 1 1
                   From   dbo.criterios_valores
                   Where  campo  = 'SalBAJIO'
                   And    item   = @PbSalida)
     Begin
        Select @PnEstatus = 8006,
               @PsMensaje = 'Error: La opción de Salida esta fuera de rango. Validar con el Responsable de Adam.';

        Set Xact_Abort         On
        Raiserror (@PsMensaje, 16, 1)
        Return
     End

   Select @w_inst_deposito = ltrim(ltrim(descripcion))
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 2;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8007,
                @PsMensaje = 'Error: El parámetro de entidad bancaria no existe. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select Top 1 1
                   From   dbo.ins_depositos
                   Where  institucion_deposito = @w_inst_deposito)
      Begin
         Select @PnEstatus = 8008,
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
         Select @PnEstatus = 8009,
                @PsMensaje = 'Error: El parámetro de cuenta bancaria no existe. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_gAfinidad = Substring(ltrim(ltrim(descripcion)), 1, 9)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 4;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8010,
                @PsMensaje = 'Error: El parámetro de Grupo de Afinidad no existe. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_sucursal = Substring(ltrim(ltrim(descripcion)), 1, 7)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 5;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8011,
                @PsMensaje = 'Error: El parámetro de Código de Sucursal no existe. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   Select @w_indice_inf_soc = Substring(ltrim(ltrim(descripcion)), 1, 10)
   From   dbo.criterios_valores
   Where  campo  = 'BCOBAJIO'
   And    item   = 7;
   If @@Rowcount = 0
      Begin
         Select @PnEstatus = 8012,
                @PsMensaje = 'Error: El parámetro de Información Socio Económico no existe. Validar con el Responsable de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists (Select Top 1 1
                  From   dbo.BB_AltasEmpleadosTbl
                  Where  Compania  = @PsCompania
                  And    idEstatus = 0)
      Begin
         Select @PnEstatus  = 8013,
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
         Select @PnEstatus = 8014,
                @PsMensaje = 'Error: El parámetro de entidad bancaria (Tarjeta) no existe. Validar con el Addministrador de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select Top 1 1
                   From   dbo.ins_depositos
                   Where  institucion_deposito = @w_inst_tarjeta)
      Begin
         Select @PnEstatus = 8015,
                @PsMensaje = 'Error: El parámetro de entidad bancaria no se corresponde con la Banco Bajio. Validar con el Addministrador de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End

   If Not Exists ( Select Top 1 1
                   From   dbo.rel_trab_ins_dep
                   Where  compania             = @PsCompania
                   And    institucion_deposito = @w_inst_deposito)
      Begin
         Select @PnEstatus = 8016,
                @PsMensaje = 'Error: No existen Trabajadores Relacionados a Banco Bajio. Validar con el Addministrador de Adam.';

         Set Xact_Abort         On
         Raiserror (@PsMensaje, 16, 1)
         Return
      End


   If @PbSalida = 1
      Begin
         Select @w_rutaCompleta = descripcion
         From   dbo.criterios_valores
         Where  campo  = 'BCOBAJIO'
         And    item   = 1;
         If @@Rowcount        = 0 Or
            @w_rutaCompleta  Is Null
            Begin
               Select @PnEstatus  = 8017,
                      @PsMensaje  = 'Error: La ruta y nombre del archivo de salida está parametrizado';

               Set Xact_Abort         On
               Raiserror (@PsMensaje, 16, 1)
            End

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
  (secuencia        Integer          Not Null Identity (1, 1) Primary Key,
   nivel            Integer          Not NUll Default 1,
   identificador    Char(  2)        Not Null Default '95',
   cuentaEmpresa    Char( 20)        Not Null,
   gAfinidad        Char(  9)        Not Null,
   empresa          Char( 57)        Not Null,
   domicilio        Char( 28)        Not Null,
   colonia          Char( 28)        Not Null,
   poblacion        Char( 28)        Not Null,
   cPostal          Char(  5)        Not Null,
   noMovimientos    Char(  4)        Not Null Default '1',
   sucursal         Char(  7)        Not Null Default Char(32),
   linea            Char(188)        Not Null Default Char(32))


   If Object_id('tempdb..#TempDetalle', 'U') Is Not Null
      Begin
         Drop Table #TempDetalle;
      End

   Create Table #TempDetalle
  (secuencia        Integer          Not Null Identity (1, 1) Primary Key,
   nivel            Integer          Not NUll Default 2,
   identificador    Char(  2)        Not Null Default '95',
   trabajador       Char( 10)        Not Null,
   tipoOperacion    Char(  1)        Not Null Default '1',
   numcuenta        Char( 20)        Not Null Default Char(32),   -- Numerico
   tipoCuenta       Char(  7)        Not Null Default 'Maestra',
   tarjeta        Char( 16)        Not Null Default Replicate('0', 16),     -- Numerico
   enviar           Char(  1)        Not Null Default 'C',
   nombreCorto      Char( 24)        Not Null Default Char(32),
   primerNombre     Char( 19)        Not Null Default Char(32),
   segundoNombre    Char( 25)        Not Null Default Char(32),
   apellidoPaterno  Char( 25)        Not Null Default Char(32),
   apellidoMaterno  Char( 30)        Not Null Default Char(32),
   sexo             Char(  9)        Not Null Default Char(32),
   fechaNacimiento  Char(  8)        Not Null Default Char(32),
   RFC              Char( 13)        Not Null Default Char(32),
   CURP             Char( 18)        Not Null Default Char(32),
   calleNumero      Char( 35)        Not Null Default Char(32),
   coloniaPoblacion Char( 35)        Not Null Default Char(32),
   municipio        Char( 35)        Not Null Default Char(32),
   estado           Char(  4)        Not Null Default Char(32),
   localidad        Char(  8)        Not Null Default Char(32),   -- Numerico
   codigoPostal     Char(  5)        Not Null Default Char(32),   -- Numerico
   claveLada        Char(  3)        Not Null Default Char(32),   -- Numerico
   telefonoCasa     Char(  7)        Not Null Default Char(32),   -- Numerico
   correo           Char( 30)        Not Null Default Char(32),
   estadoCivil      Char(  1)        Not Null Default Char(32),
   PNBeneficiario1  Char( 30)        Not Null Default Char(32),
   SNBeneficiario1  Char( 30)        Not Null Default Char(32),
   APBeneficiario1  Char( 15)        Not Null Default Char(32),
   AMBeneficiario1  Char( 15)        Not Null Default Char(32),
   parentesco1      Char( 10)        Not Null Default Char(32),
   porcentaje1      Char(  4)        Not Null Default '1000',     -- Numerico
   PNBeneficiario2  Char( 30)        Not Null Default Char(32),
   SNBeneficiario2  Char( 30)        Not Null Default Char(32),
   APBeneficiario2  Char( 15)        Not Null Default Char(32),
   AMBeneficiario2  Char( 15)        Not Null Default Char(32),
   parentesco2      Char( 10)        Not Null Default Char(32),
   porcentaje2      Char(  4)        Not Null Default '0000',     -- Numerico
   PNBeneficiario3  Char( 30)        Not Null Default Char(32),
   SNBeneficiario3  Char( 30)        Not Null Default Char(32),
   APBeneficiario3  Char( 15)        Not Null Default Char(32),
   AMBeneficiario3  Char( 15)        Not Null Default Char(32),
   parentesco3      Char( 10)        Not Null Default Char(32),
   porcentaje3      Char(  4)        Not Null Default '0000',               -- Numerico
   celular          Char( 10)        Not Null Default Replicate('0', 10),   -- Numerico
   tipoTarjeta      Char( 16)        Not Null Default Replicate('0', 16),   -- Numerico
   linea            Char(719)        Not Null Default Char(32))

   If Object_id('dbo.TempSalidaBajio', 'U') Is Not Null
      Begin
         Drop Table dbo.TempSalidaBajio;
      End

   Create Table dbo.TempSalidaBajio
  (secuencia        Integer          Not Null Identity (1, 1) Primary Key,
   linea            Char(719)        Not Null Default Char(32))

--
-- Proceso
--

--
-- Encabezado.
--

   Begin Try
      Insert Into #TempCabecero
      (cuentaEmpresa, gAfinidad, empresa, domicilio,
       colonia,       poblacion, cPostal, sucursal)
      Select @w_cuentaEmpresa, @w_gAfinidad,  Substring(nombre_cia,1, 57),
             Isnull(Substring(a.domicilio,  1, 28), Char(32)),
             Isnull(Substring(a.domicilio2, 1, 28), Char(32)),
             Isnull(Substring(a.poblacion,  1, 28), Char(32)),
             Isnull(a.codigo_postal, 'CP101'),
             @w_sucursal
      From   dbo.companias a
      Where  a.compania = @PsCompania;

      Update #TempCabecero
      Set    linea = identificador + cuentaEmpresa + gAfinidad + empresa + domicilio + colonia + poblacion + cPostal +
                     noMovimientos + sucursal;
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
-- Linea detalle.
--

   Insert Into #TempDetalle
  (trabajador,      numcuenta,       tarjeta,    nombreCorto,
   primerNombre,    segundoNombre,
   apellidoPaterno, apellidoMaterno, sexo,         fechaNacimiento,
   RFC,             CURP,            calleNumero,  coloniaPoblacion,
   municipio,       estado,          localidad,    codigoPostal,
   claveLada,       telefonoCasa,    correo,       estadoCivil)
   Select a.trabajador, Substring(a.cuenta_deposito, 1, 20), a.tarjeta,
          Substring(dbo.fn_detallaNombre(b.nombre, 6), 1, 24),
          Substring(dbo.fn_detallaNombre(b.nombre, 4), 1, 19),
          Substring(dbo.fn_detallaNombre(b.nombre, 5), 1, 25),
          Substring(dbo.fn_detallaNombre(b.nombre, 1), 1, 25),
          Substring(dbo.fn_detallaNombre(b.nombre, 2), 1, 30),
          Substring(dbo.Fn_BuscaDescripcionCriterio('sexo', b.sexo), 1, 9),
          Replace(Convert(Char(11), b.fecha_nacimiento, 102), '.', ''),
          b.registro_fiscal, b.clave_unica,
          Isnull(Substring(rtrim(ltrim(b.domicilio)),  1, 35), Char(32)),
          Isnull(Substring(rtrim(ltrim(b.domicilio2)), 1, 35), Char(32)),
          Isnull(Substring(rtrim(ltrim(b.domicilio3)), 1, 35), Char(32)),
          Isnull(Substring(Replicate('0', 4 - len(dbo.Fn_BuscaCodigoEstado('MEX', 'b.estado_provincia'))) +
                               dbo.Fn_BuscaCodigoEstado('MEX', 'b.estado_provincia'), 1, 4), '0000'),
          Replicate('0', 8 - len(dbo.Fn_BuscaCodigoLocalidad(dbo.Fn_BuscaCodigoEstado('MEX', 'b.estado_provincia') , b.poblacion))) +
                        ltrim(dbo.Fn_BuscaCodigoLocalidad(dbo.Fn_BuscaCodigoEstado('MEX', 'b.estado_provincia') , b.poblacion)),
          Isnull((Select Replicate('0', 5 - len(Isnull(codigo_postal, ''))) + Isnull(Ltrim(rtrim(codigo_postal)), '')
                  From   dbo.trabajadores
                  Where  trabajador = a.trabajador
                  And    Isnull(codigo_postal, '') != ''
                  And    Isnumeric(codigo_postal)   = 1), '00000'),
          Isnull(Replicate('0', 3 - Len(dbo.Fn_BuscaClaveLada(a.trabajador)))  + dbo.Fn_BuscaClaveLada(a.trabajador), '000'),
          Isnull(Replicate('0', 7 - Len(Substring(telefono_particular, 4, 7))) + Substring(telefono_particular, 4, 7), '0000000'),
          Substring(Isnull(e_mail, ' '), 1, 30),
          Substring(dbo.Fn_BuscaEdoCivil(a.compania, a.trabajador), 1, 1)
   From   dbo.BB_AltasEmpleadosTbl a
   Join   dbo.trabajadores         b
   On     b.trabajador     = a.trabajador
   Join   dbo.trabajadores_grales  c
   On     c.compania       = a.compania
   And    c.trabajador     = a.trabajador
   Where  a.compania       = @PsCompania
   And    a.idEstatus      = 0
   And    c.sit_trabajador = 1;
   
   Set @w_Error = @@Error
   If @w_error != 0
      Begin
         Select @PnEstatus = @w_error,
                @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
         Goto Salida;
   
      End
          
   Update #TempDetalle
   Set    PNBeneficiario1 = Isnull(dato_07, Char(32)),
          SNBeneficiario1 = Isnull(dato_08, Char(32)),
          APBeneficiario1 = Isnull(dato_01, Char(32)),
          AMBeneficiario1 = Isnull(dato_02, Char(32)),
          parentesco1     = Isnull(dato_03, Char(32)),
          porcentaje1     = Isnull(Right('0000' + Cast(Cast((b.dato_14 * 10) AS Integer) AS Varchar), 4), '0000')
   From   #TempDetalle           a
   Join   dbo.inf_soc_trabajador b
   On     b.trabajador    = a.trabajador
   And    b.secuencia     = 1
   Where  indice_inf_soc  = @w_indice_inf_soc;
   
   Set @w_Error = @@Error
   If @w_error != 0
      Begin
         Select @PnEstatus = @w_error,
                @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
         Goto Salida;
   
      End

   Update #TempDetalle
   Set    PNBeneficiario2 = Isnull(dato_07, Char(32)),
          SNBeneficiario2 = Isnull(dato_08, Char(32)),
          APBeneficiario2 = Isnull(dato_01, Char(32)),
          AMBeneficiario2 = Isnull(dato_02, Char(32)),
          parentesco2     = Isnull(dato_03, Char(32)),
          porcentaje2     = Isnull(Right('0000' + Cast(Cast((b.dato_14 * 10) AS Integer) AS Varchar), 4), '0000')
   From   #TempDetalle a
   Join   dbo.inf_soc_trabajador b
   On     b.trabajador    = a.trabajador
   And    b.secuencia     = 2
   Where  indice_inf_soc  = @w_indice_inf_soc;

   Set @w_Error = @@Error
   If @w_error != 0
      Begin
         Select @PnEstatus = @w_error,
                @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
         Goto Salida;
   
      End
         
   Update #TempDetalle
   Set    PNBeneficiario3 = Isnull(dato_07, Char(32)),
          SNBeneficiario3 = Isnull(dato_08, Char(32)),
          APBeneficiario3 = Isnull(dato_01, Char(32)),
          AMBeneficiario3 = Isnull(dato_02, Char(32)),
          parentesco3     = Isnull(dato_03, Char(32)),
          porcentaje3     = Isnull(Right('0000' + Cast(Cast((b.dato_14 * 10) AS Integer) AS Varchar), 4), '0000')
   From   #TempDetalle a
   Join   dbo.inf_soc_trabajador b
   On     b.trabajador    = a.trabajador
   And    b.secuencia     = 3
   Where  indice_inf_soc  = @w_indice_inf_soc;

   Set @w_Error = @@Error
   If @w_error != 0
      Begin
         Select @PnEstatus = @w_error,
                @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
         Goto Salida;
   
      End
      
--
-- Actualización de la linea a imprimir
--

   Update  #TempDetalle
   Set     linea = identificador    + tipoOperacion   + numcuenta       + tipoCuenta      +
                   tarjeta        + enviar          + nombreCorto     + primerNombre    +
                   segundoNombre    + apellidoPaterno + apellidoMaterno + sexo            +
                   fechaNacimiento  + RFC             + CURP            + calleNumero     +
                   coloniaPoblacion + municipio       + estado          + localidad       +
                   codigoPostal     + claveLada       + telefonoCasa    + correo          +
                   estadoCivil      + PNBeneficiario1 + SNBeneficiario1 + APBeneficiario1 +
                   AMBeneficiario1  + parentesco1     + porcentaje1     + PNBeneficiario2 +
                   SNBeneficiario2  + APBeneficiario2 + AMBeneficiario2 + parentesco2     +
                   porcentaje2      + PNBeneficiario3 + SNBeneficiario3 + APBeneficiario3 +
                   AMBeneficiario3  + parentesco3     + porcentaje3     + celular         +
                   tipoTarjeta;
   Set @w_Error = @@Error
   If @w_error != 0
      Begin
         Select @PnEstatus = @w_error,
                @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
         Goto Salida;
   
      End

   Insert Into dbo.TempSalidaBajio
  (linea)
   Select Linea
   From   #TempCabecero;

   Insert Into dbo.TempSalidaBajio
  (linea)
   Select Linea
   From   #TempDetalle
   Order By secuencia;

--
-- Salida como Archivo Txt
--

   If @PbSalida = 1
      Begin
         Set @w_sql = 'Select Linea '                          +
                      'From ' + @w_dbname + '.dbo.TempSalidaBajio ' + ' ' +
                      'Order by secuencia'

         Set @w_sql = 'bcp "' + @w_sql + '" queryout "' + @w_rutaCompleta + '" -o ' + @w_log + ' -c -t -T -S' + @w_server

         Execute  master..xp_cmdshell @w_sql

         Set @w_Error = @@Error
         If @w_error != 0
            Begin
               Select @PnEstatus = @w_error,
                      @PsMensaje = dbo.fn_ConsultaSysmessages(@w_error)
               Goto Salida;

            End

      End
   Else
      Begin
         Select Linea
         From   dbo.TempSalidaBajio
         Order  by Secuencia;
     End;

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
                            Break;

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
                               Break;

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
                            Break;
                      
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
                            Break;
                      
                         End

                   End -- If  @w_estatus = 0

                   If @w_error != 0
                      Begin
                         Goto Salida
                      End
               End;

         Commit Tran;

      End

Salida:

   If Object_id('tempdb..#TempCabecero', 'U') Is Not Null
      Begin
         Drop Table #TempCabecero;
      End

   If Object_id('tempdb..#TempDetalle', 'U') Is Not Null
      Begin
         Drop Table #TempDetalle;
      End

   If Object_id('dbo.TempSalidaBajio', 'U') Is Not Null
      Begin
         Drop Table dbo.TempSalidaBajio;
      End

   Set Xact_Abort         On
   Return

End
Go

Grant Execute On dbo.Spp_BB_empleados to Public
Go

--
-- Comentarios.
--

Declare
   @w_valor          Varchar(1500) = 'Procedimiento que que genera archivo txt de alta empleados Banco Bajio.',
   @w_procedimiento  Varchar( 100) = 'Spp_BB_empleados',
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

