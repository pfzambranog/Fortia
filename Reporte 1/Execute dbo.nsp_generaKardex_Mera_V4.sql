 -- Declare
    -- @idempresa          Integer  = 1,
    -- @idanio             Integer = 2024,
    -- @PnMes              Tinyint = 4,
    -- @PnIdRazonSocial    Integer = 0,
    -- @PnIdDepartamento   Integer = 0,
    -- @PnIdUBicacion      Integer = 0,
    -- @idtrabajador       Integer = 0;

 -- Execute dbo.nsp_generaKardex_Mera_v4 @idempresa, @idanio, @PnMes, @PnIdRazonSocial, @PnIdDepartamento, @PnIdUBicacion, @idtrabajador

Create Or Alter Procedure dbo.nsp_generaKardex_Mera_v4
  (@idempresa          Integer,
   @idanio             Integer,
   @PnMes              Tinyint = 0,
   @PnIdRazonSocial    Integer = 0,
   @PnIdDepartamento   Integer = 0,
   @PnIdUBicacion      Integer = 0,
   @idtrabajador       Integer = 0)
As
Declare
   @concatenaFaltas   Varchar(Max),
   @w_sql             Varchar(Max),
   @w_sql2            Varchar(Max),
   @w_lang            Varchar(100),
   @w_chmes           Varchar( 20),
   @w_claveFalta      Varchar(  5),
   @w_x               Integer,
   @w_y               Integer,
   @w_mesIni          Integer,
   @w_mesFin          Integer,
   @w_registros       Integer,
   @w_mes             Integer,
   @w_IdEmpresa       Integer,
   @w_IdTrabajador    Integer,
   @w_IdMes           Integer,
   @w_fecha           Date,
   @w_comilla         Char(1),
   @w_secuencia       Bigint,
   @w_idSession       Uniqueidentifier;

Declare
   @tempMesTbl   Table
   (mes       Integer      Not Null Primary Key,
    nommes    Varchar(20)  Not Null);
Begin
   Set Nocount       On
   Set Ansi_Nulls    Off

   Select  @concatenaFaltas = '',
           @w_x             = 0,
           @w_mesIni        = Case When @PnMes = 0
                                   Then @PnMes
                                   Else @PnMes -1
                              End,
           @w_mesFin        = Case When @PnMes = 0
                                   Then 12
                                   Else @PnMes
                              End,
           @w_secuencia     = 0,
           @w_registros     = 0,
           @w_comilla       = Char(39),
           @w_idSession     = Newid(),
           @w_fecha         = Cast(Concat(@idanio, '-',
                                          Case When  @PnMes = 0
                                               Then  '01'
                                               Else  Format (@PnMes, '00')
                                          End, '-01') as date),
           @w_y             = Case When @PnMes = 0
                                   Then 31
                                   Else DatePart(dd, Eomonth(@w_fecha))
                              End;




--
-- Inicio de Proceso
--

   Select @concatenaFaltas = Concat(coalesce(@concatenaFaltas,''), RTrim(CLA_FALTA),
             ': ' + NOM_FALTA + CHAR(9))
   From   dbo.RH_FALTA
   Where  CLA_EMPRESA = @idempresa;
   Set @concatenaFaltas = @concatenaFaltas + 'V: V, Vacaciones'

--
   
   Set @w_lang = @@LANGUAGE

   Set language spanish

   While @w_mesIni < @w_mesFin
   Begin
      Select @w_mesIni += 1,
             @w_chmes   = Datename(month, @w_fecha)

      Insert Into @tempMesTbl
     (mes, nommes)
     Select @w_mesIni, @w_chmes

     Set @w_fecha = Dateadd(m, 1, @w_fecha);

   End

   Set language @w_lang

   While @w_x < @w_y
   Begin
      Set @w_x    += 1

      Set @w_sql2 = Concat(@w_sql2, 'dia_', Format(@w_x,  '00'), ' "', @w_x, '", ')
   End

--

   Insert Into dbo.AsistenciaTbl
  (Idempresa,    Idtrabajador, IdMes,      Nombremes,
   Nomrazosoci,  Nombre,       Foto,       Fechaalta,
   Fechabaja,    Nomdepto,     Nompuesto,  Turno,
   Tipo,         Clase,        Supervisor, NomUbicacion,
   FechaEmision, TituloKar,    detfal,     idSession)
   Select rt.cla_empresa,      rt.cla_trab, m.mes, m.nommes,
          Concat(rt.cla_razon_social, ', ', rrs.nom_razon_social),
          Concat(trim(ap_paterno),', ', trim(ap_materno), ', ', trim(nom_trab)),
          rt.fotografia,       rt.fecha_ing,
          rt.fecha_baja,       Concat(rd.cla_depto, ', ', rd.nom_depto),
          Concat(rp.cla_puesto, ', ', rp.nom_puesto),
          Concat(rt.cla_roll,   ', ', rpt.nom_perfil_turno),
          rt.cla_roll,  rt.cla_clasificacion,
          Isnull(dbo.obtieneSupervisor(rt.cla_empresa, rt.cla_trab), Char(32)),
          Concat(cla_ubicacion, ', ', ru.nom_ubicacion),
          Getdate(),  Concat('Kardex Anual', @idanio),
          @concatenaFaltas, @w_idSession
   From   dbo.RH_TRAB         rt
   Join   dbo.RH_RAZON_SOCIAL rrs
   On     rrs.cla_empresa      = rt.cla_empresa
   And    rrs.cla_razon_social = rt.cla_razon_social
   Join   dbo.RH_DEPTO rd
   On     rd.cla_empresa = rt.cla_empresa
   And    rd.cla_depto   = rt.cla_depto
   Join   dbo.RH_PUESTO rp
   On     rp.cla_empresa = rt.cla_empresa
   And    rp.cla_puesto  = rt.cla_puesto
   Join   dbo.RELOJ_PERFIL_TURNO rpt
   On     rpt.cla_empresa      = rt.cla_empresa
   And    rpt.cla_perfil_turno = rt.cla_roll
   Join   dbo.RH_UBICACION ru
   On     ru.cla_ubicacion     = rt.cla_ubicacion_base
   And    ru.cla_empresa       = rt.cla_empresa
   Join   @tempMesTbl m
   On     1 = 1
   Where  rt.cla_trab              = iif(@idtrabajador     = 0,  rt.cla_trab, @idtrabajador)
   And    rt.cla_empresa           = @idempresa
   And    rt.cla_razon_social      = Iif(@PnIdRazonSocial  = 0, rt.cla_razon_social, @PnIdRazonSocial)
   And    rt.cla_depto             = Iif(@PnIdDepartamento = 0, rt.cla_depto, @PnIdDepartamento)
   And    rt.cla_ubicacion_base    = Iif(@PnIdUbicacion    = 0, rt.cla_ubicacion_base, @PnIdUbicacion)
   And    Datepart(yy, Isnull(fecha_ing_grupo, fecha_ing)) <= @idanio
   And   (rt.fecha_baja           Is Null
   Or     Datepart(yy, FECHA_BAJA) = @idanio)

   Select @w_secuencia = Min(idSecuencia),
          @w_registros = Max(Idsecuencia)
   From   dbo.AsistenciaTbl
   Where  idSession = @w_idSession;

   While @w_secuencia <= @w_registros
   Begin
      Select @w_idEmpresa    = Idempresa,
             @w_Idtrabajador = Idtrabajador,
             @w_IdMes        = idMes
      From   dbo.AsistenciaTbl
      Where  idSecuencia = @w_secuencia;
      If @@Rowcount = 0
         Begin
            Break
         End

      Set @w_x = 0
      While @w_x < @w_y
      Begin
         Set @w_x    += 1

         Set @w_claveFalta = Isnull(dbo.obtieneclavefalta(@w_idEmpresa, @w_IdTrabajador,
                                                          @idanio,      @w_IdMes, @w_x), Char(32));
         If @w_claveFalta != Char(32)
            Begin
               Set @w_sql = Concat('Update a ',
                                   'Set    dia_', Format(@w_x, '00'), ' = ', @w_comilla , @w_claveFalta, @w_comilla, ' ',
                                   'From   dbo.AsistenciaTbl a ',
                                   'Where  a.idSecuencia = ', @w_secuencia)

               Execute (@w_sql)
           End

      End

      Set @w_secuencia   += 1
   End

   If @w_y = 28
      Begin
         Select IdEmpresa,    IdTrabajador, IdMes,        Nombremes,
                Nomrazosoci,  Nombre,       Foto,         Fechaalta,
                Fechabaja,    Nomdepto,     NomUbicacion, Nompuesto,
                Turno,        Tipo,         Clase,
                dia_01  "01", dia_02  "02", dia_03  "03", dia_04  "04",
                dia_05  "05", dia_06  "06", dia_07  "07", dia_08  "08",
                dia_09  "09", dia_10  "10", dia_11  "11", dia_12  "12",
                dia_13  "13", dia_14  "14", dia_15  "15", dia_16  "16",
                dia_17  "17", dia_18  "18", dia_19  "19", dia_20  "20",
                dia_21  "21", dia_22  "22", dia_23  "23", dia_20  "24",
                dia_25  "25", dia_25  "26", dia_26  "27", dia_28  "28",
                FechaEmision, TituloKar, detfal, Supervisor
         From   dbo.AsistenciaTbl
         Where  idSession = @w_idSession;

         Goto Salida

      End

   If @w_y = 29
      Begin
         Select IdEmpresa,    IdTrabajador, IdMes,        Nombremes,
                Nomrazosoci,  Nombre,       Foto,         Fechaalta,
                Fechabaja,    Nomdepto,     NomUbicacion, Nompuesto,
                Turno,        Tipo,         Clase,
                dia_01  "01", dia_02  "02", dia_03  "03", dia_04  "04",
                dia_05  "05", dia_06  "06", dia_07  "07", dia_08  "08",
                dia_09  "09", dia_10  "10", dia_11  "11", dia_12  "12",
                dia_13  "13", dia_14  "14", dia_15  "15", dia_16  "16",
                dia_17  "17", dia_18  "18", dia_19  "19", dia_20  "20",
                dia_21  "21", dia_22  "22", dia_23  "23", dia_20  "24",
                dia_25  "25", dia_25  "26", dia_26  "27", dia_28  "28",
                dia_29  "29", FechaEmision, TituloKar, detfal, Supervisor
         From   dbo.AsistenciaTbl
         Where  idSession = @w_idSession;

         Goto Salida

      End

   If @w_y = 30
      Begin
         Select IdEmpresa,    IdTrabajador, IdMes,        Nombremes,
                Nomrazosoci,  Nombre,       Foto,         Fechaalta,
                Fechabaja,    Nomdepto,     NomUbicacion, Nompuesto,
                Turno,        Tipo,         Clase,
                dia_01  "01", dia_02  "02", dia_03  "03", dia_04  "04",
                dia_05  "05", dia_06  "06", dia_07  "07", dia_08  "08",
                dia_09  "09", dia_10  "10", dia_11  "11", dia_12  "12",
                dia_13  "13", dia_14  "14", dia_15  "15", dia_16  "16",
                dia_17  "17", dia_18  "18", dia_19  "19", dia_20  "20",
                dia_21  "21", dia_22  "22", dia_23  "23", dia_20  "24",
                dia_25  "25", dia_25  "26", dia_26  "27", dia_28  "28",
                dia_29  "29", dia_30  "30", FechaEmision, TituloKar,
                detfal, Supervisor
         From   dbo.AsistenciaTbl
         Where  idSession = @w_idSession;

         Goto Salida

      End

   If @w_y = 31
      Begin
         Select IdEmpresa,    IdTrabajador, IdMes,        Nombremes,
                Nomrazosoci,  Nombre,       Foto,         Fechaalta,
                Fechabaja,    Nomdepto,     NomUbicacion, Nompuesto,
                Turno,        Tipo,         Clase,
                dia_01  "01", dia_02  "02", dia_03  "03", dia_04  "04",
                dia_05  "05", dia_06  "06", dia_07  "07", dia_08  "08",
                dia_09  "09", dia_10  "10", dia_11  "11", dia_12  "12",
                dia_13  "13", dia_14  "14", dia_15  "15", dia_16  "16",
                dia_17  "17", dia_18  "18", dia_19  "19", dia_20  "20",
                dia_21  "21", dia_22  "22", dia_23  "23", dia_20  "24",
                dia_25  "25", dia_25  "26", dia_26  "27", dia_28  "28",
                dia_29  "29", dia_30  "30", dia_31  "31", FechaEmision,
                TituloKar, detfal, Supervisor
         From   dbo.AsistenciaTbl
         Where  idSession = @w_idSession;

         Goto Salida

      End

Salida:
   Set Xact_Abort    Off   
   Return
End
Go

--
-- Comentarios.
--

Declare
   @w_valor          Varchar(1500) = 'Consulta datospara la generación del Kardek.',
   @w_procedimiento  Varchar( 100) = 'nsp_generaKardex_Mera_v4'


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
Else
   Begin
      Execute sp_updateextendedproperty @name       = 'MS_Description',
                                        @value      = @w_valor,
                                        @level0type = 'Schema',
                                        @level0name = N'Dbo',
                                        @level1type = 'Procedure',
                                        @level1name = @w_procedimiento
   End
Go
