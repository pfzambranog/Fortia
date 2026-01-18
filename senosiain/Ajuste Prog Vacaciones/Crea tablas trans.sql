Declare
   @w_compania              Char( 4),
   @w_tipo_nomina           Char( 2),
   @w_fechaDesde            Date,
   @w_fechaHasta            Date,
   @w_id_calendario         Integer,
   @w_existe                Integer,
   @w_secuencia             Integer,
   @w_registros             Integer,
   @w_sql                   Varchar(Max),
   @w_tabla                 sysname;

Begin
   Select @w_compania    = 'LS',
          @w_tipo_nomina = '01',
          @w_fechaDesde  = '2025-11-01',
          @w_fechaHasta  = '2026-01-15',
          @w_secuencia   = 0;

   If Object_Id('tempdb..#TablaTemp') Is Not Null
      Begin
         Drop Table #TablaTemp
      End

   Create Table #TablaTemp
  (secuencia     Integer  Not Null Identity (1, 1) Primary Key,
   compania      Char( 2) Not Null,
   id_calendario Integer  Not Null,
   tabla         sysname  Not Null,
   existe        bit      Not Null Default 0,
   index TablaTempIdx01 unique (compania, id_calendario),
   index TablaTempIdx02 (tabla));

   Declare
       C_tabla   Cursor For
       Select c.id_calendario, Concat('TRANS', '_', Rtrim(Ltrim(c.compania)), '_', Rtrim(Ltrim(c.id_calendario)))
       from   dbo.tipos_nomina a
       Join   AdamP.dbo.calendario_procesos b
       On     b.tipo_nomina = a.tipo_nomina
       And    b.fecha_inicio Between @w_fechaDesde And @w_fechaHasta
       Join   AdamP.dbo.cal_proc_cias c
       On     c.id_calendario = b.id_calendario
       And    c.compania      = @w_compania
       And    c.sit_periodo   = 2
       Where  a.tipo_nomina   = @w_tipo_nomina
       Order By 1;
   Begin

      Open C_tabla
      While @@Fetch_status < 1
      Begin
         Fetch C_tabla Into @w_id_calendario, @w_tabla;
         If @@Fetch_status != 0
            Begin
               Break
            End


         Select @w_existe = Count(1)
         From   Sys.tables
         Where  name = @w_tabla;
         If @@Rowcount = 0
         Begin
            Set @w_existe = 0;
         End

         If @w_existe = 0
            Begin
               Insert Into #TablaTemp
               (compania, id_calendario, tabla)
               Select @w_compania, @w_id_calendario, @w_tabla;
               Set @w_registros = @@Identity;
            End

      End;
      Close      C_tabla
      Deallocate C_tabla
   End

   While @w_secuencia < @w_registros
   Begin
      Set @w_secuencia = @w_secuencia + 1;
      Select @w_tabla = tabla
      From   #TablaTemp
      Where  secuencia = @w_secuencia;
      If @@Rowcount = 0
         Begin
            Goto proximo
         End;

      Set @w_sql = Concat('Create Table dbo.', @w_tabla, ' ',
                          '(compania           Char(4)       Not Null,',
                          ' clase_nomina       Char(2)       Not Null,',
                          ' id_calendario      Integer       Not Null,',
                          ' concepto           Smallint      Not Null,',
                          ' trabajador         Char(10)      Not Null,',
                          ' referencia         Char(10)      Not Null,',
                          ' secuencia          Smallint      Not Null,',
                          ' referencia2        Char(10)          Null,',
                          ' fecha              Smalldatetime     Null,',
                          ' fecha2             Smalldatetime     Null,',
                          ' tiempo             Decimal(8,3)      Null,',
                          ' factor_01          Decimal(15,6)     Null,',
                          ' factor_02          Decimal(15,6)     Null,',
                          ' factor_03          Decimal(15,6)     Null,',
                          ' importe_reportado  Decimal(13,2)     Null,',
                          ' importe            Decimal(13,2)     Null,',
                          ' turno_trn          Smallint          Null,',
                          ' puesto_trn         Char(15)          Null,',
                          ' agrupacion_01_trn  Char(10)          Null,',
                          ' dato_01_trn        Char(10)          Null,',
                          ' agrupacion_02_trn  Char(10)          Null,',
                          ' dato_02_trn        Char(10)          Null,',
                          ' agrupacion_03_trn  Char(10)          Null,',
                          ' dato_03_trn        Char(10)          Null,',
                          ' agrupacion_04_trn  Char(10)          Null,',
                          ' dato_04_trn        Char(10)          Null,',
                          ' origen_transaccion Smallint      Not Null,',
                          ' usuario_registro   Varchar(30)       Null,',
                          ' fecha_registro     Smalldatetime     Null,',
                          ' usuario_proceso    Varchar(30)       Null,',
                          ' fecha_proceso      Smalldatetime     Null,',
                          ' usuario_cambio     Varchar(30)       Null,',
                          ' fecha_cambio       Smalldatetime     Null,',
                          ' sit_transaccion    Smallint      Not Null,',
                          ' Constraint pk', @w_tabla                   ,
                          ' Primary Key  (compania,clase_nomina,id_calendario, concepto, trabajador, referencia, secuencia),',
                          ' Constraint rl_1', @w_tabla,
                          ' Check (origen_transaccion Between 1 And 14), ',
                          ' Constraint rl_2', @w_tabla,
                          ' Check (sit_transaccion IN (1, 2, 3, 4, 5)))');

      Execute (@w_sql)

      If @@error = 0
         Begin
            Set @w_sql = Concat('Insert Into dbo.', @w_tabla, ' ',
                                'Select * ',
                                'From   AdamP.dbo.', @w_tabla);
            Execute (@w_sql)
            If @@error = 0
               Begin
                  Update #TablaTemp
                  Set    existe = 1
                  Where  secuencia = @w_secuencia;

                  Insert Into dbo.TablasMgrTbl
                 (compania, id_calendario, tabla, existe)
                  Select compania, id_calendario, tabla, existe
                  From   #TablaTemp
                  Where  secuencia = @w_secuencia;;
               End
         End

proximo:

   End

   If Object_Id('tempdb..#TablaTemp') Is Not Null
      Begin
         Drop Table #TablaTemp
      End

   Return;

End;

