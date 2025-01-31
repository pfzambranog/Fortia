--
-- Execute dbo.nsp_generaKardex_Mera_v3 1, 0, 2025
--
Create Or Alter Procedure dbo.nsp_generaKardex_Mera_v3
  (@idempresa       Integer,
   @idtrabajador    Integer,
   @idanio          Integer)
As
Declare
   @concatenaFaltas   Varchar(Max),
   @w_sql             Varchar(Max),
   @w_lang            Varchar(100),
   @w_chmes           Varchar( 20),
   @w_claveFalta      Varchar(  5),
   @w_x               Integer,
   @w_y               Integer,
   @w_mesIni          Integer,
   @w_mesFin          Integer,
   @w_secuencia       Integer,
   @w_registros       Integer,
   @w_mes             Integer,
   @w_IdEmpresa       Integer,
   @w_IdTrabajador    Integer,
   @w_IdMes           Integer,
   @w_fecha           Date,
   @w_comilla         Char(1);

Declare
   @tempMesTbl   Table
   (mes       Integer      Not Null Primary Key,
    nommes    Varchar(20)  Not Null);
Begin
   Set Nocount       On
   Set Xact_Abort    On

   Select  @concatenaFaltas = '',
           @w_x             = 0,
           @w_y             = 31,
           @w_mesIni        = 0,
           @w_mesFin        = 12,
           @w_secuencia     = 0,
           @w_registros     = 0,
           @w_comilla       = Char(39),
           @w_fecha         = Cast(Concat(@idanio, '-01-01') as date)

--
-- Creación de Tablas Temporales
--

  Create Table #AsisteciaTbl
 (idSecuencia     Integer       Not null Identity (1, 1) Primary Key,
  IdEmpresa       Integer       Not Null,
  IdTrabajador    Integer       Not Null,
  IdMes           Integer       Not Null,
  Nombremes       Varchar( 20)  Not Null,
  Nomrazosoci     Varchar(100)  Not Null,
  Nombre         Varchar(200)  Not Null,
  Foto            Image             Null,
  Fechaalta       Datetime      Not Null,
  Fechabaja       Datetime          Null,
  Nomdepto        Varchar(100)      Null,
  Nompuesto       Varchar(100)      Null,
  Turnoo          Varchar(100)      Null,
  Tipo            Integer           Null,
  Clase           Integer           Null,
  Supervisor      Varchar(500)      Null,
  Index AsistenciaIdex01 Unique (idEmpresa, Idtrabajador, idMes))

--
-- Inicio de Proceso
--

   Set @w_lang = @@LANGUAGE

   Set language spanish

   While @w_mesIni <@w_mesFin
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

      Set @w_sql = Concat('Alter Table #AsisteciaTbl  Add dia_', Format(@w_x, '00'),
                          ' Varchar(8) Not null Default Char(32) ')
      Execute (@w_sql)


   End

--

   Select @concatenaFaltas = Concat(coalesce(@concatenaFaltas,''), RTrim(CLA_FALTA),
             ': ' + NOM_FALTA + CHAR(9))
   From   dbo.RH_FALTA
   Where  CLA_EMPRESA = @idempresa;

   Set @concatenaFaltas = @concatenaFaltas + 'V: V, Vacaciones'

--

   Insert Into #AsisteciaTbl
  (Idempresa,   Idtrabajador, IdMes,     Nombremes,
   Nomrazosoci, Nombre,       Foto,      Fechaalta,
   Fechabaja,   Nomdepto,     Nompuesto, Turnoo,
   Tipo,        Clase,        Supervisor)
   Select rt.cla_empresa,      rt.cla_trab, m.mes, m.nommes,
          rrs.nom_razon_social,
          concat(trim(ap_paterno),', ', trim(ap_materno), ', ', trim(nom_trab)),
          rt.fotografia,       rt.fecha_ing,
          rt.fecha_baja,       concat(rd.cla_depto, ', ', rd.nom_depto),
          concat(rp.cla_puesto, ', ', rp.nom_puesto),
          concat(rt.cla_roll,   ', ', rpt.nom_perfil_turno),
          rt.cla_roll,  rt.cla_clasificacion, 'Supervisor'
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
   and    rpt.cla_perfil_turno = rt.cla_roll
   Join   @tempMesTbl m
   On     1 = 1
   Where  rt.cla_trab    = iif(@idtrabajador  = 0,  rt.cla_trab, @idtrabajador)
   And    rt.cla_empresa = @idempresa
   And    Datepart(yy, Isnull(fecha_ing_grupo, fecha_ing)) <= @idanio
   And   (rt.fecha_baja           Is Null
   Or     Datepart(yy, FECHA_BAJA) = @idanio)
   Set @w_registros = @@Rowcount

   While @w_secuencia < @w_registros
   Begin
      Set @w_secuencia   += 1

      Select @w_idEmpresa    = Idempresa,
             @w_Idtrabajador = Idtrabajador,
             @w_IdMes        = idMes
      From   #AsisteciaTbl
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
         If @w_claveFalta != ''
		    Begin
               Set @w_sql = Concat('Update a ',
                                   'Set    dia_', Format(@w_x, '00'), ' = ', @w_comilla , @w_claveFalta, @w_comilla,
                                   'From   #AsisteciaTbl a ',
                                   'Where  a.idSecuencia = ', @w_secuencia)
               Execute (@w_sql)
           End

      End

   End

   Select IdEmpresa,   IdTrabajador, IdMes,       Nombremes,
          Nomrazosoci, Nombre,      Foto,        Fechaalta,
          Fechabaja,   Nomdepto,     Nompuesto,   Turnoo,
          Tipo,        Clase,        dia_01 "1",  dia_02 "2",
          dia_03 "3",  dia_04  "4",  dia_05 "5",  dia_06 "6",
          dia_07 "7",  dia_08  "8",  dia_09 "9",  dia_10 "10",
          dia_11 "11", dia_12  "12", dia_13 "13", dia_14 "14",
          dia_15 "15", dia_16  "16", dia_17 "17", dia_18 "18",
          dia_19 "19", dia_20  "20", dia_21 "21", dia_22 "22",
          dia_23 "23", dia_24  "24", dia_25 "25", dia_26 "26",
          dia_27 "27", dia_28  "28", dia_29 "29", dia_30 "30",
          dia_31 "31", Getdate()    FechaEmision,
          Concat('Kardex Anual ', @idanio) TituloKar,
          @concatenaFaltas detfal,
          Supervisor  -- dbo.obtieneSupervisor(IdEmpresa,IdTrabajador)
   From #AsisteciaTbl

   Return
End
Go