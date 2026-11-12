/*
Declare
   @chcompania             Char( 4)       = 'LS',
   @chtrabajador           Char(10)       = '     61461',
   @secuencia              Char           = Null,
   @sdtfecha               Smalldatetime  = '2026-11-01',
   @salario                Decimal(15,6)  = 379.87,
   @sdtfechaimss           Smalldatetime  = '2026-11-01',
   @sdtfechainfo           Smalldatetime  = '2026-11-01',
   @causa_aumento          Char(2)        = 'MI',
   @tigrupo_salario        Tinyint        = 0,
   @instancia              Varchar(50)    = 'ABCDE';
Begin
   Execute dbo.sp_salario_integrado @chcompania      = @chcompania,
                                    @chtrabajador    = @chtrabajador,
                                    @secuencia       = @secuencia,
                                    @sdtfecha        = @sdtfecha,
                                    @salario         = @salario,
                                    @sdtfechaimss    = @sdtfechaimss,
                                    @sdtfechainfo    = @sdtfechainfo,
                                    @causa_aumento   = @causa_aumento,
                                    @tigrupo_salario = @tigrupo_salario,
                                    @instancia       = @instancia;

   Return
End;
Go

*/

If Exists (Select Top 1 1
           From   sysobjects
           Where  Uid   = 1
           And    Type = 'P'
           And    Name = 'sp_salario_integrado')
   Begin
      Drop Procedure  dbo.sp_salario_integrado;
   End
Go

Create Procedure dbo.sp_salario_integrado
  (@chcompania             Char( 4),
   @chtrabajador           Char(10),
   @secuencia              Char,
   @sdtfecha               Smalldatetime,
   @salario                Decimal(15,6),
   @sdtfechaimss           Smalldatetime,
   @sdtfechainfo           Smalldatetime,
   @causa_aumento          Char( 2),
   @tigrupo_salario        Tinyint,
   @instancia              Varchar(50))
AS

Declare
   @msdiimss               Decimal(15,6),
   @msdiinfo               Decimal(15,6),
   @tiimss                 Tinyint,
   @entero                 Integer,
   @i_alfa                 Char(23),
   @bandera                Tinyint
--
,  @w_sistema_antiguedad   Tinyint;
--

Begin /*principal*/

/*
  Actualiza:      Pedro Zambrano - Zepga Consultores.
  Descripción:    Procedimiento que inicia el cálculo del SDI.
  Actualización:  2026-11-03.
  Motivo:         Se incorpora un nuevo componente en el cálculo del SDI (var_ant_5)
  Version:        2.0
*/
   Set Nocount       On
   Set Xact_Abort    On
   Set Ansi_Nulls    On


 /* recupera el parámetro de redondeo del Salario Integrado */

   Select  @entero = Isnull(entero,0)
   From    parametros_rh
   Where   compania            = @chcompania
   And     parametro_rh        = 'Red_Sal_Int'
   And     secuencia_parametro = 1

   If @salario         Is Null And
      @sdtfecha        Is Null And
      @tigrupo_salario Is Null And
      @secuencia       Is Null
      Begin
         Select @salario         = salario,
                @sdtfecha        = fecha,
                @tigrupo_salario = grupo_salario
         From   dbo.historico_sueldos a
         Where  compania   = @chcompania
         And    trabajador = @chtrabajador
         And    fecha      = (Select Max(fecha)
                              From   dbo.historico_sueldos
                              Where  compania   = a.compania
                              And    trabajador = a.trabajador)
      End
   Else
      Begin
         If @salario         Is     Null And
            @sdtfecha        Is     Null And
            @tigrupo_salario Is     Null And
            @secuencia       Is Not Null
            Begin
                Select  @salario  = salario,
                        @sdtfecha  = fecha,
                        @tigrupo_salario = grupo_salario
                From    dbo.historico_sueldos
                Where   compania   = @chcompania
                And     trabajador = @chtrabajador
                And     secuencia  = @secuencia
            End
      End

   If @sdtfechaimss Is Not Null
       Begin
          Select @i_alfa = alfanumerico
          From   parametros_rh
          Where  compania            = @chcompania
          And    parametro_rh        ='Funcion_SI'
          And    secuencia_parametro = 1;
       End

--
-- Ajuste del 05-nov-2026
--

   Select @w_sistema_antiguedad = sistema_antiguedad
   From   dbo.trabajadores_grales
   Where  compania   = @chcompania
   And    trabajador = @chtrabajador;

   Set @salario = (@salario * (1 + dbo.Fn_buscaVarBono(@w_sistema_antiguedad)))

--
-- Fin ajuste.
--

   If len(ltrim(@i_alfa)) <= 3    Or
      @i_alfa             Is Null
      Begin
         Set @tiimss = 1
         Execute sp_salario_integ_imss @chcompania, @chtrabajador, @salario, @tigrupo_salario, @sdtfechaimss, @msdiimss output, @tiimss, @instancia
      End
   Else
      Begin
         Set @tiimss = 1
             Execute @i_alfa @chcompania, @chtrabajador, @salario, @tigrupo_salario, @sdtfechaimss, @msdiimss output, @tiimss, @instancia
     End

   If @sdtfechainfo Is Not Null
      If len(ltrim(@i_alfa)) <= 3 or
         @i_alfa Is Null
         Begin
            Set @tiimss = 2
      
            Execute sp_salario_integ_imss @chcompania, @chtrabajador, @salario, @tigrupo_salario, @sdtfechainfo, @msdiinfo output, @tiimss, @instancia
         End
      Else
         Begin
            Set @tiimss = 2
            Execute @i_alfa @chcompania, @chtrabajador, @salario, @tigrupo_salario, @sdtfechainfo, @msdiinfo output, @tiimss, @instancia
         End

   If @entero = 1
      Select  @msdiimss = round(@msdiimss,2),
              @msdiinfo = round(@msdiinfo,2)

   If @secuencia Is Not Null
      Begin
         Set @bandera = 0

         If Exists (Select 1
                       From   dbo.sueldos
                       Where  compania          = @chcompania
                       And    trabajador        = @chtrabajador
                       And    salario_integrado = @msdiimss
                       And    grupo_salario     = @tigrupo_salario)
            Begin
               Set @bandera = 1
            End

         If @bandera = 0
            Begin
               If Exists (Select 1
                          From   dbo.sueldos
                          Where  compania   = @chcompania
                          And    trabajador = @chtrabajador
                          And   (FECHA_IMSS Is Null OR SALARIO_INTEGRADO = 0 ))

                  Begin
                     Select @bandera = 1
                  End
            End

         If @bandera = 0
            Begin
               Execute sp_alta_salint_masivos @chcompania, @chtrabajador,@secuencia, @sdtfecha, @salario, @sdtfechaimss, @msdiimss, @sdtfechainfo, @msdiinfo, @causa_aumento, @tigrupo_salario,@instancia, 1
            End
         Else  /* If Exists (Select 1 From sueldos*/
            Begin
               If ((@sdtfechaimss Is Not Null) OR (@sdtfechainfo Is Not Null))
                  Begin
                     Execute sp_alta_salint_masivos @chcompania, @chtrabajador,@secuencia, @sdtfecha, @salario, @sdtfechaimss, @msdiimss,
                                                    @sdtfechainfo, @msdiinfo, @causa_aumento, @tigrupo_salario,@instancia, 2
                  End
            End

      End
   Else               /*si la secuencia es nula */
 Begin
  If ((@sdtfechaimss Is Not Null) OR (@sdtfechainfo Is Not Null))

  Execute sp_alta_salint_masivos @chcompania, @chtrabajador,@secuencia, @sdtfecha, @salario, @sdtfechaimss, @msdiimss,
                 @sdtfechainfo, @msdiinfo, @causa_aumento, @tigrupo_salario,@instancia, 2

 End /* Else @secuencia Is Null */

End /* fin sp_salario_integrado */
Go

Grant Execute On sp_salario_integrado to Public
Go

--
-- Comentarios.
--

Declare
   @w_valor          Varchar(1500) = 'Procedimiento que obtiene los datos de SDI Para el Reporte.',
   @w_procedimiento  Varchar( 100) = 'sp_salario_integrado'


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
