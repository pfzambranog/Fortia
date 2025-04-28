Declare
   @w_cla_var     Char(10),
   @w_cla_empresa Integer,
   @w_fechaProc   Datetime;

Declare
   @w_tabla   Table
  (cla_var     Char(10) Not Null,
   cla_empresa Integer  Not Null,
   cla_perded  Integer  Not Null);

Begin
   Select @w_cla_var     = '$prdfaPTU',
          @w_cla_empresa = 1,
          @w_fechaProc   = Getdate();

--
   Insert Into @w_tabla
  (cla_var, cla_empresa, cla_perded)
   Values (@w_cla_var, @w_cla_empresa, 2003),
          (@w_cla_var, @w_cla_empresa, 2060),
          (@w_cla_var, @w_cla_empresa, 2062);


--
   If Not Exists (Select top 1 1
                  From   dbo.RHCFG_VARIABLE
                  Where  CLA_VAR = @w_cla_var)
      Begin
         Insert Into dbo.RHCFG_VARIABLE
        (CLA_VAR,      DESC_VAR,         EXP_SQL,      OBSERV_VAR,
         TIPO_VAR,     TIPO_REFER1,      TIPO_REFER2,  TIPO_REFER3,
         TIPO_REFER4,  TIPO_REFER5,      TIPO_REFER6,  TIPO_REFER7,
         TIPO_REFER8,  TIPO_REFER9,      TIPO_REFER10, TIPO_REFER11,
         TIPO_REFER12, TIPO_REFER13,     TIPO_REFER14, TIPO_REFER15,
         SQLREF1,      FECHA_ULT_CAMBIO, ESTATUTO,     ORIGEN)
         Select @w_cla_var, 'PERDED FALTAS GRAT PTU',  @w_cla_var,    Null,
                2    TIPO_VAR,        0    TIPO_REFER1,  0    TIPO_REFER2,  0    TIPO_REFER3,
                0    TIPO_REFER4,     0    TIPO_REFER5,  0    TIPO_REFER6,  0    TIPO_REFER7,
                0    TIPO_REFER8,     0    TIPO_REFER9,  0    TIPO_REFER10, Null TIPO_REFER11,
                Null TIPO_REFER12,    Null TIPO_REFER13, Null TIPO_REFER14, Null TIPO_REFER15,
                Null SQLREF1,         Getdate(),         Null ESTATUTO,     Null ORIGEN;
      End

   Insert Into dbo.RH_VAR_USUARIO
  (CLA_VAR,           LLAVE_REFER,   CLA_EMPRESA,
   VALOR_VAR_USUARIO, FECHA_ULT_CAMBIO, MIGRADO)
   Select CLA_VAR,    Char(32),     cla_empresa,
          cla_perded, @w_fechaProc, Null
   From   @w_tabla a
   Where  Not Exists ( Select Top 1 1
                       From   dbo.RH_VAR_USUARIO
                       Where  CLA_VAR = a.CLA_VAR
                       And    cla_empresa       = a.cla_empresa
                       And    VALOR_VAR_USUARIO = a.cla_perded);

--

   Select @w_cla_var   = '$prdinPTU',
          @w_fechaProc = Getdate();

--
   Delete @w_tabla;

   Insert Into @w_tabla
  (cla_var, cla_empresa, cla_perded)
   Values (@w_cla_var, @w_cla_empresa, 2163);
          
   If Not Exists (Select top 1 1
                  From   dbo.RHCFG_VARIABLE
                  Where  CLA_VAR = @w_cla_var)
      Begin
         Insert Into dbo.RHCFG_VARIABLE
        (CLA_VAR,      DESC_VAR,         EXP_SQL,      OBSERV_VAR,
         TIPO_VAR,     TIPO_REFER1,      TIPO_REFER2,  TIPO_REFER3,
         TIPO_REFER4,  TIPO_REFER5,      TIPO_REFER6,  TIPO_REFER7,
         TIPO_REFER8,  TIPO_REFER9,      TIPO_REFER10, TIPO_REFER11,
         TIPO_REFER12, TIPO_REFER13,     TIPO_REFER14, TIPO_REFER15,
         SQLREF1,      FECHA_ULT_CAMBIO, ESTATUTO,     ORIGEN)
         Select @w_cla_var, 'PERDED INCAPACIDADES GRAT PTU',  @w_cla_var,    Null,
                2    TIPO_VAR,        0    TIPO_REFER1,  0    TIPO_REFER2,  0    TIPO_REFER3,
                0    TIPO_REFER4,     0    TIPO_REFER5,  0    TIPO_REFER6,  0    TIPO_REFER7,
                0    TIPO_REFER8,     0    TIPO_REFER9,  0    TIPO_REFER10, Null TIPO_REFER11,
                Null TIPO_REFER12,    Null TIPO_REFER13, Null TIPO_REFER14, Null TIPO_REFER15,
                Null SQLREF1,         Getdate(),         Null ESTATUTO,     Null ORIGEN;
      End

   Insert Into dbo.RH_VAR_USUARIO
  (CLA_VAR,           LLAVE_REFER,   CLA_EMPRESA,
   VALOR_VAR_USUARIO, FECHA_ULT_CAMBIO, MIGRADO)
   Select CLA_VAR,    Char(32),     cla_empresa,
          cla_perded, @w_fechaProc, Null
   From   @w_tabla a
   Where  Not Exists ( Select Top 1 1
                       From   dbo.RH_VAR_USUARIO
                       Where  CLA_VAR = a.CLA_VAR
                       And    cla_empresa       = a.cla_empresa
                       And    VALOR_VAR_USUARIO = a.cla_perded);

--

   Select @w_cla_var   = '$diaGraesp',
          @w_fechaProc = Getdate();

--
   Delete @w_tabla;

   Insert Into @w_tabla
  (cla_var, cla_empresa, cla_perded)
   Values (@w_cla_var, @w_cla_empresa, 130);
          
   If Not Exists (Select top 1 1
                  From   dbo.RHCFG_VARIABLE
                  Where  CLA_VAR = @w_cla_var)
      Begin
         Insert Into dbo.RHCFG_VARIABLE
        (CLA_VAR,      DESC_VAR,         EXP_SQL,      OBSERV_VAR,
         TIPO_VAR,     TIPO_REFER1,      TIPO_REFER2,  TIPO_REFER3,
         TIPO_REFER4,  TIPO_REFER5,      TIPO_REFER6,  TIPO_REFER7,
         TIPO_REFER8,  TIPO_REFER9,      TIPO_REFER10, TIPO_REFER11,
         TIPO_REFER12, TIPO_REFER13,     TIPO_REFER14, TIPO_REFER15,
         SQLREF1,      FECHA_ULT_CAMBIO, ESTATUTO,     ORIGEN)
         Select @w_cla_var, 'DIAS GRATIFICACION ESPECIAL PTU',  @w_cla_var,    Null,
                2    TIPO_VAR,        0    TIPO_REFER1,  0    TIPO_REFER2,  0    TIPO_REFER3,
                0    TIPO_REFER4,     0    TIPO_REFER5,  0    TIPO_REFER6,  0    TIPO_REFER7,
                0    TIPO_REFER8,     0    TIPO_REFER9,  0    TIPO_REFER10, Null TIPO_REFER11,
                Null TIPO_REFER12,    Null TIPO_REFER13, Null TIPO_REFER14, Null TIPO_REFER15,
                Null SQLREF1,         Getdate(),         Null ESTATUTO,     Null ORIGEN;
      End

   Insert Into dbo.RH_VAR_USUARIO
  (CLA_VAR,           LLAVE_REFER,   CLA_EMPRESA,
   VALOR_VAR_USUARIO, FECHA_ULT_CAMBIO, MIGRADO)
   Select CLA_VAR,    Char(32),     cla_empresa,
          cla_perded, @w_fechaProc, Null
   From   @w_tabla a
   Where  Not Exists ( Select Top 1 1
                       From   dbo.RH_VAR_USUARIO
                       Where  CLA_VAR           = a.CLA_VAR
                       And    cla_empresa       = a.cla_empresa
                       And    VALOR_VAR_USUARIO = a.cla_perded);

   Return

End
Go
