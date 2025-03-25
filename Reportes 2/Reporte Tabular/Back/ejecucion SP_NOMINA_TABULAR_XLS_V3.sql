 Declare
    @PsRazon_Social            Varchar(Max)   = '1',
    @PsCla_Empresa             Varchar(Max)   = '',
    @PnAnio                    Integer        = 2025,
    @PnMesIni                  Integer        = 0,
    @PnMesFin                  Integer        = 0,
    @PsCla_Ubicacion           Varchar(Max)   = '',
    @PsCla_CentroCosto         Varchar(Max)   = '',
    @PsCla_Area                Varchar(Max)   = '',
    @PsCla_Depto               Varchar(Max)   = '',
    @PsCla_RegImss             Varchar(Max)   = '',
    @PsCla_PerDed              Varchar(Max)   = '',
    @PsCla_Periodo             Varchar(Max)   = '',
    @PsNominas                 Varchar(Max)   = '',
    @PsCla_Trab                Varchar(Max)   = '',
    @PsCLa_Puesto              Varchar(Max)   = '',
    @PbImprimeProv             Bit            = 1,
    @PbIncluyeNominaAbierta    Bit            = 1,
    @PsStatusNom               Varchar(Max)   = Null,
    @PnError                   Integer        = 0,
    @PsMensaje                 Varchar( 250)  = ' ';
 Begin
    Execute dbo.SP_NOMINA_TABULAR_XLS_V3 @PsRazon_Social          = @PsRazon_Social,
                                        @PsCla_Empresa            = @PsCla_Empresa,
                                        @PnAnio                   = @PnAnio,
                                        @PnMesIni                 = @PnMesIni,
                                        @PnMesFin                 = @PnMesFin,
                                        @PsCla_Ubicacion          = @PsCla_Ubicacion,
                                        @PsCla_CentroCosto        = @PsCla_CentroCosto,
                                        @PsCla_Area               = @PsCla_Area,
                                        @PsCla_Depto              = @PsCla_Depto,
                                        @PsCla_RegImss            = @PsCla_RegImss,
                                        @PsCla_PerDed             = @PsCla_PerDed,
                                        @PsCla_Periodo            = @PsCla_Periodo,
                                        @PsNominas                = @PsNominas,
                                        @PsCla_Trab               = @PsCla_Trab,
                                        @PsCLa_Puesto             = @PsCLa_Puesto,
                                        @PbImprimeProv            = @PbImprimeProv,
                                        @PsStatusNom              = @PsStatusNom,
                                        @PbIncluyeNominaAbierta   = @PbIncluyeNominaAbierta,
                                        @PnError                  = @PnError   Output,
                                        @PsMensaje                = @PsMensaje Output;
    If @PnError != 0
       Begin
          Select @PnError, @PsMensaje;
       End

    Return

 End
 Go