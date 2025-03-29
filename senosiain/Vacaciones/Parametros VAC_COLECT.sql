--
-- Objetivo:   Actualizar los parámetros de Vacaciones Colectivas.
-- Elaborado: RH Pay Solutions.
-- Fecha:     27-03-2025
--
 
Declare
   @w_compania      Char( 4),
   @w_parametro_rh  Char(10),
   @w_secuencia1    Integer,
   @w_secuencia2    Integer,
   @w_secuencia3   Integer,
   @w_meses         Integer,
   @w_fecha2        Date,
   @w_fecha3        Date;

Begin
   Set nocount On
   
   Select @w_compania     = 'LS',
          @w_parametro_rh = 'VAC_COLECT',
          @w_secuencia1   = 1,
          @w_secuencia2   = 2,
          @w_secuencia3   = 3,
          @w_meses        = 12,  -- Meses de Vigencia
          @w_fecha2       = '2025-04-17',
          @w_fecha3       = '2025-12-23';           

--
-- Secuencia 1 = Meses de Caducidad de Ciclo Vacacional para Vacaciones Colectivas.
--

   If Not Exists ( Select Top 1 1
                   From   dbo.parametros_rh
                   Where  compania            = @w_compania
                   And    parametro_rh        = @w_parametro_rh
                   And    secuencia_parametro = @w_secuencia1)
      Begin
         Insert Into dbo.parametros_rh
        (compania,    parametro_rh, secuencia_parametro,
         descripcion, entero)
         Select @w_compania, @w_parametro_rh, @w_secuencia1,
                'Meses Vigencia Vac Colectivas', @w_meses;
      End
   Else
      Begin
         Update dbo.parametros_rh
         Set    entero = @w_meses
         Where  compania            = @w_compania
         And    parametro_rh        = @w_parametro_rh
         And    secuencia_parametro = @w_secuencia1;
     End

--
-- Secuencia 2 = Fecha Inicio Vacaciones Colectivas Semana Santa.
--

   If Not Exists ( Select Top 1 1
                   From   dbo.parametros_rh
                   Where  compania            = @w_compania
                   And    parametro_rh        = @w_parametro_rh
                   And    secuencia_parametro = @w_secuencia2)
      Begin
         Insert Into dbo.parametros_rh
        (compania,    parametro_rh, secuencia_parametro,
         descripcion, fecha)
         Select @w_compania, @w_parametro_rh, @w_secuencia2,
                'Inicio Vacaciones Semana Santa', @w_fecha2;
      End
   Else
      Begin
         Update dbo.parametros_rh
         Set    fecha = @w_fecha2
         Where  compania            = @w_compania
         And    parametro_rh        = @w_parametro_rh
         And    secuencia_parametro = @w_secuencia2;
     End

--
-- Secuencia 2 = Fecha Inicio Vacaciones Colectivas Semana Santa.
--

   If Not Exists ( Select Top 1 1
                   From   dbo.parametros_rh
                   Where  compania            = @w_compania
                   And    parametro_rh        = @w_parametro_rh
                   And    secuencia_parametro = @w_secuencia3)
      Begin
         Insert Into dbo.parametros_rh
        (compania,    parametro_rh, secuencia_parametro,
         descripcion, fecha)
         Select @w_compania, @w_parametro_rh, @w_secuencia3,
                'Inicio Vacaciones Navidad', @w_fecha3;
      End
   Else
      Begin
         Update dbo.parametros_rh
         Set    fecha = @w_fecha3
         Where  compania            = @w_compania
         And    parametro_rh        = @w_parametro_rh
         And    secuencia_parametro = @w_secuencia3;
     End

End
Go
