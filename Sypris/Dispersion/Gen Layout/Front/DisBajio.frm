VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Begin VB.Form frmDisBajio 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Dispersión Nómina Banco Bajío"
   ClientHeight    =   3780
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6165
   Icon            =   "DisBajio.frx":0000
   LinkTopic       =   "Dispersion Banco Bajio"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3780
   ScaleWidth      =   6165
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame FrmParametros 
      BackColor       =   &H80000002&
      Caption         =   "Parámetros de Nómina"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3015
      Left            =   0
      TabIndex        =   2
      Top             =   960
      Width           =   7815
      Begin MSFlexGridLib.MSFlexGrid grdPdf 
         Height          =   855
         Left            =   3720
         TabIndex        =   15
         Top             =   1200
         Visible         =   0   'False
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   1508
         _Version        =   393216
         Rows            =   1
         Cols            =   4
         FixedRows       =   0
      End
      Begin VB.ComboBox CmbPeriodo 
         Height          =   315
         Left            =   1680
         TabIndex        =   11
         Top             =   1560
         Width           =   975
      End
      Begin VB.ComboBox CmbAnio 
         Height          =   315
         Left            =   1680
         TabIndex        =   10
         Top             =   1080
         Width           =   975
      End
      Begin VB.ComboBox CmbTipoNomina 
         Height          =   315
         Left            =   1680
         TabIndex        =   6
         Top             =   600
         Width           =   3375
      End
      Begin MSComDlg.CommonDialog CommonDialog1 
         Left            =   6360
         Top             =   2160
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin MSComDlg.CommonDialog CommDir 
         Left            =   7080
         Top             =   2160
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin VB.Label LblPeriodo 
         BackColor       =   &H80000002&
         Caption         =   "Período Nómina"
         Height          =   255
         Left            =   240
         TabIndex        =   9
         Top             =   1680
         Width           =   1335
      End
      Begin VB.Label LblAnio 
         BackColor       =   &H80000002&
         Caption         =   "Año Nómina"
         Height          =   255
         Left            =   240
         TabIndex        =   8
         Top             =   1080
         Width           =   1335
      End
      Begin VB.Label lblTipoNiomina 
         BackColor       =   &H80000002&
         Caption         =   "Tipo de Nómina"
         Height          =   255
         Left            =   240
         TabIndex        =   7
         Top             =   600
         Width           =   1335
      End
   End
   Begin VB.Frame frmAceptar 
      BorderStyle     =   0  'None
      Caption         =   "Recibo Pago Empleados"
      Height          =   165
      Left            =   1680
      TabIndex        =   1
      Top             =   5400
      Width           =   285
      Begin VB.Image cmdAceptar 
         Height          =   480
         Left            =   1440
         Top             =   120
         Width           =   480
      End
      Begin VB.Image cmdCancelar 
         Height          =   480
         Left            =   720
         Top             =   840
         Width           =   480
      End
   End
   Begin VB.Frame Frame3 
      BackColor       =   &H80000002&
      BorderStyle     =   0  'None
      Height          =   975
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   7815
      Begin VB.CommandButton BtnPdf 
         BackColor       =   &H80000002&
         Enabled         =   0   'False
         Height          =   495
         Left            =   720
         Picture         =   "DisBajio.frx":030A
         Style           =   1  'Graphical
         TabIndex        =   14
         ToolTipText     =   "Presentar en Pantalla"
         Top             =   240
         Width           =   615
      End
      Begin VB.TextBox TxtUsuario 
         Appearance      =   0  'Flat
         BackColor       =   &H80000002&
         BorderStyle     =   0  'None
         CausesValidation=   0   'False
         Height          =   285
         Left            =   6120
         TabIndex        =   13
         Top             =   480
         Width           =   1215
      End
      Begin VB.TextBox TxtOperacion 
         Appearance      =   0  'Flat
         BackColor       =   &H80000002&
         BorderStyle     =   0  'None
         CausesValidation=   0   'False
         Height          =   285
         Left            =   6120
         TabIndex        =   12
         Top             =   120
         Width           =   1215
      End
      Begin VB.CommandButton BtnSalir 
         BackColor       =   &H80000002&
         Height          =   495
         Left            =   1920
         Picture         =   "DisBajio.frx":0FC4
         Style           =   1  'Graphical
         TabIndex        =   5
         ToolTipText     =   "Salir"
         Top             =   240
         Width           =   615
      End
      Begin VB.CommandButton BtnRefrescar 
         BackColor       =   &H80000002&
         Height          =   495
         Left            =   1320
         Picture         =   "DisBajio.frx":1646
         Style           =   1  'Graphical
         TabIndex        =   4
         ToolTipText     =   "Refrescar Pantalla"
         Top             =   240
         Width           =   615
      End
      Begin VB.CommandButton BtnEjecutar 
         BackColor       =   &H80000002&
         Enabled         =   0   'False
         Height          =   495
         Left            =   120
         Picture         =   "DisBajio.frx":1CC8
         Style           =   1  'Graphical
         TabIndex        =   3
         ToolTipText     =   "Presentar en Pantalla"
         Top             =   240
         Width           =   615
      End
   End
End
Attribute VB_Name = "frmDisBajio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private arrTipoNomina() As String

Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" ( _
    ByVal hwnd As Long, _
    ByVal lpOperation As String, _
    ByVal lpFile As String, _
    ByVal lpParameters As String, _
    ByVal lpDirectory As String, _
    ByVal nShowCmd As Long) As Long
    
    Private mBanco As String
    Private mClaseNomina As String
    Private mTipoNomina As String
    Private mPeriodo As String
    Private mFechaPago As String

    Private mTotalImporte As Currency
    Private mTotalTrabajadores As Long
    '
    Private mFechaGeneracion As String
    Private mHoraGeneracion As String

Private Sub Form_Load()

    frmConexion.Hide

    BtnEjecutar.Enabled = False
    BtnPdf.Enabled = False
     
    CmbTipoNomina.Enabled = True
    CmbAnio.Enabled = False
    CmbPeriodo.Enabled = False

    Call carga_Parametros

    Me.Show

End Sub

Private Sub carga_Parametros()

    Dim cod As String
    Dim txt As String
    Dim n As Long

    On Error GoTo ErrorHandler

    TxtUsuario.Text = gUserId

    gSql = "Select descripcion " & _
           "From dbo.criterios_valores " & _
           "Where campo = 'BCOBAJIO' " & _
           "And item = 14"

    If Not fEjecuta(2, gSql) Then
        MsgBox "Error al obtener la operación.", vbExclamation
        Exit Sub
    End If

    glOperacion = Trim(MAdo.GetField(1) & "")
    TxtOperacion.Text = glOperacion

    gSql = "Select descripcion " & _
           "From dbo.criterios_valores " & _
           "Where campo = 'BCOBAJIO' " & _
           "And item = 13"

    If Not fEjecuta(2, gSql) Then
        MsgBox "Error al obtener la ruta.", vbExclamation
        Exit Sub
    End If

    glRuta = Trim(MAdo.GetField(1) & "")

    Call LlenarComboTipoNomina
    
    Exit Sub

ErrorHandler:

    MsgBox "Error " & Err.Number & _
           vbCrLf & Err.Description, _
           vbCritical

End Sub

Private Sub BtnEjecutar_Click()

    Dim vTipoNomina As String
    Dim vAnio As Long
    Dim vPeriodo As Long

    If Not fValidar Then Exit Sub

    On Error GoTo ErrorHandler

    If CmbTipoNomina.ListIndex = -1 Then
        MsgBox "Seleccione un Tipo de Nómina", vbExclamation
        Exit Sub
    End If

    If CmbAnio.ListIndex = -1 Then
        MsgBox "Seleccione un Año de Nómina", vbExclamation
        Exit Sub
    End If

    If CmbPeriodo.ListIndex = -1 Then
        MsgBox "Seleccione un Período de Nómina", vbExclamation
        Exit Sub
    End If

    vTipoNomina = arrTipoNomina(CmbTipoNomina.ListIndex)

    vAnio = CLng(CmbAnio.Text)

    vPeriodo = CLng(CmbPeriodo.Text)

    '--------------------------------------------------
    ' Obtener Id Calendario
    '--------------------------------------------------
    gSql = _
        "Select id_calendario " & _
        "From dbo.calendario_procesos " & _
        "Where tipo_nomina = '" & vTipoNomina & "' " & _
        "And anio = " & vAnio & " " & _
        "And periodo = " & vPeriodo

    If Not fEjecuta(2, gSql) Then
        MsgBox "No existe un calendario para los datos seleccionados.", vbExclamation
        Exit Sub
    End If

    glIdCalendario = CStr(CLng(MAdo.GetField(1)))

    gSql = _
        "Declare " & _
        "   @PnEstatus Integer, " & _
        "   @PsMensaje Varchar(250) " & _
        "Begin " & _
        "Execute dbo.Spp_genLayoutBajio " & _
        "   @PsCompania       = '" & gCiaCodigo & "', " & _
        "   @PnId_Calendario  = " & glIdCalendario & ", " & _
        "   @PsOperacion      = '" & glOperacion & "', " & _
        "   @PsUsuario        = '" & gUserId & "', " & _
        "   @PbSalida         = 0, " & _
        "   @PsIdSession      = '" & gSession & "', " & _
        "   @PnEstatus        = @PnEstatus OUTPUT, " & _
        "   @PsMensaje        = @PsMensaje OUTPUT " & _
        "End"

    If Not fEjecuta(1, gSql) Then
        MsgBox "Error al ejecutar el procedimiento de generación.", vbExclamation
        Exit Sub
    End If


    Call GeneraArchivoTxt
   
    gSql = "Execute dbo.sp_baja_BB_DispersionTbl @PsIdSession = '" & gSession & "'"
    


    If Not fEjecuta(1, gSql) Then
        MsgBox "Advertencia: no fue posible limpiar la tabla temporal.", vbExclamation
    End If

    MsgBox "Proceso completado exitosamente.", vbInformation

    Exit Sub

   Call BtnRefrescar_Click
   
ErrorHandler:

    MsgBox "Error: " & Err.Number & _
           vbCrLf & Err.Description, _
           vbCritical

End Sub

Private Sub BtnRefrescar_Click()

    Erase arrTipoNomina

    CmbTipoNomina.Clear
    CmbAnio.Clear
    CmbPeriodo.Clear

    glTipoNomina = ""
    glIdCalendario = 0

    BtnEjecutar.Enabled = False
    BtnPdf.Enabled = False
    
    CmbTipoNomina.Enabled = True
    CmbAnio.Enabled = False
    CmbPeriodo.Enabled = False

    Call LlenarComboTipoNomina

End Sub

Private Sub BtnSalir_Click()
  Unload Me
  End
End Sub
Sub GeneraArchivoTxt()

    On Error GoTo ErrorHandler

    Dim vLinea As String
    Dim fileNum As Integer
    Dim vRutaDestino As String
    Dim vPlantillaRuta As String
    Dim vNombreArchivo As String
    Dim vDirectorio As String
    Dim vRespuesta As Integer

    gSql = "Select descripcion " & _
           "From dbo.criterios_valores " & _
           "Where campo = 'BCOBAJIO' " & _
           "And item = 13"

    If Not fEjecuta(2, gSql) Then
        MsgBox "Error: No existe el parámetro de Ruta (Item 13)", vbExclamation
        Exit Sub
    End If

    vPlantillaRuta = Trim(MAdo.GetField(1) & "")

    If vPlantillaRuta = "" Then
        MsgBox "La ruta configurada para Banco Bajío está vacía.", vbExclamation
        Exit Sub
    End If


    vNombreArchivo = Replace(vPlantillaRuta, "CIA", Trim(gCiaCodigo))
    vNombreArchivo = Replace(vNombreArchivo, "IDCAL", Trim(glIdCalendario))


    vDirectorio = Left(vNombreArchivo, InStrRev(vNombreArchivo, "\") - 1)

    vRutaDestino = ObtenerRutaTxt(vNombreArchivo, vDirectorio)

    If Trim(vRutaDestino) = "" Then Exit Sub

    gSql = "Select linea " & _
           "From dbo.BB_DispersionTbl " & _
           "Where idSession = " & MAdo1.ValorReal(gSession, 2) & " " & _
           "Order By secuencia"

    If Not fEjecuta(2, gSql) Then
        MsgBox "No existen registros para generar el archivo.", vbExclamation
        Exit Sub
    End If

    
    fileNum = FreeFile

    Open vRutaDestino For Output As #fileNum

    While Not MAdo.EOF

        vLinea = Trim(MAdo.GetField(1) & "")

        Print #fileNum, vLinea

        Call MAdo.Mnext(Mlhstmt, MlhDbc)

    Wend

    Close #fileNum
           
    gSql = "dbo.sp_baja_BB_DispersionTbl " & _
           MAdo1.ValorReal(gSession, 2)

    If Not fEjecuta(1, gSql) Then
        MsgBox "Procedimiento de limpieza no ejecutado.", vbExclamation
    End If


    vRespuesta = MsgBox("Archivo generado exitosamente:" & vbCrLf & _
                         vRutaDestino & vbCrLf & vbCrLf & _
                         "¿Desea abrir el archivo generado?", _
                         vbQuestion + vbYesNo, _
                         "Dispersión Banco Bajío")

    If vRespuesta = vbYes Then

    Call ShellExecute(Me.hwnd, "open", vRutaDestino, vbNullString, vbNullString, 1)

End If

Exit Sub

ErrorHandler:

    If fileNum > 0 Then
        Close #fileNum
    End If

    MsgBox "Error " & Err.Number & _
           vbCrLf & Err.Description, _
           vbCritical

End Sub

Private Sub CmbTipoNomina_Click()

    If CmbTipoNomina.ListIndex = -1 Then Exit Sub
    
    glTipoNomina = arrTipoNomina(CmbTipoNomina.ListIndex)
    CmbAnio.Enabled = True
    CmbAnio.Clear
    CmbPeriodo.Clear

    Call LlenarComboAnio

End Sub
Private Sub CmbAnio_Click()

    If CmbAnio.ListIndex = -1 Then Exit Sub

    BtnEjecutar.Enabled = False
    BtnPdf.Enabled = False
     
    CmbPeriodo.Clear
    CmbPeriodo.Enabled = True

    Call llenarComboPeriodo

End Sub

Private Sub CmbPeriodo_Click()

    If CmbPeriodo.ListIndex = -1 Then Exit Sub

    BtnEjecutar.Enabled = True
    BtnPdf.Enabled = True

End Sub
Private Sub LlenarComboTipoNomina()

    Dim cod As String
    Dim txt As String
    Dim n As Long

    gSql = "Select Distinct " & _
           "       a.tipo_nomina, " & _
           "       d.descripcion " & _
           "From dbo.calendario_procesos a " & _
           "Inner Join dbo.cal_proc_cias b " & _
           "        On b.id_calendario = a.id_calendario " & _
           "Inner Join dbo.aut_companias c " & _
           "        On c.compania = b.compania " & _
           "       And c.usuario = '" & gUserId & "' " & _
           "Inner Join dbo.tipos_nomina d " & _
           "        On d.tipo_nomina = a.tipo_nomina " & _
           "       And d.manejo = 1 " & _
           "Where b.sit_periodo In (1,2) " & _
           "And   b.compania = '" & gCiaCodigo & "' " & _
           "Order By d.descripcion"

    CmbTipoNomina.Clear
    Erase arrTipoNomina

    If Not fEjecuta(2, gSql) Then
        MsgBox "Error al cargar Tipos de Nómina.", vbExclamation
        Exit Sub
    End If

    n = 0

    While Not MAdo.EOF

        cod = Trim(MAdo.GetField(1) & "")
        txt = Trim(MAdo.GetField(2) & "")

        ReDim Preserve arrTipoNomina(n)

        arrTipoNomina(n) = cod

        CmbTipoNomina.AddItem txt

        n = n + 1

        Call MAdo.Mnext(Mlhstmt, MlhDbc)

    Wend


    Exit Sub
End Sub

Private Sub LlenarComboAnio()

    Dim vTipoNomina As String

    If CmbTipoNomina.ListIndex = -1 Then Exit Sub

    vTipoNomina = arrTipoNomina(CmbTipoNomina.ListIndex)

    gSql = _
        "Select Distinct a.anio  " & _
        "From dbo.calendario_procesos a " & _
        "Join dbo.cal_proc_cias b On b.id_calendario = a.id_calendario " & _
        "Join dbo.aut_companias c On c.compania = b.compania " & _
        "And c.usuario = '" & gUserId & "' " & _
        "Where b.sit_periodo In (1,2) " & _
        "And b.compania = '" & gCiaCodigo & "' " & _
        "And a.tipo_nomina = '" & vTipoNomina & "' " & _
        "Order By a.anio"

    CmbAnio.Clear

    If Not fEjecuta(2, gSql) Then Exit Sub

    While Not MAdo.EOF

        CmbAnio.AddItem CStr(CLng(MAdo.GetField(1)))

    Call MAdo.Mnext(Mlhstmt, MlhDbc)

    Wend

End Sub
Private Sub llenarComboPeriodo()

    Dim vTipoNomina As String

    If CmbTipoNomina.ListIndex = -1 Then Exit Sub
    If CmbAnio.ListIndex = -1 Then Exit Sub

    vTipoNomina = arrTipoNomina(CmbTipoNomina.ListIndex)

    gSql = _
        "Select Distinct a.periodo " & _
        "From dbo.calendario_procesos a " & _
        "Join dbo.cal_proc_cias b On b.id_calendario = a.id_calendario " & _
        "Join dbo.aut_companias c On c.compania = b.compania " & _
        "And c.usuario = '" & gUserId & "' " & _
        "Where b.sit_periodo In (1,2) " & _
        "And b.compania = '" & gCiaCodigo & "' " & _
        "And a.tipo_nomina = '" & vTipoNomina & "' " & _
        "And a.anio = " & CLng(CmbAnio.Text) & " " & _
        "Order By a.periodo"

    CmbPeriodo.Clear

    If Not fEjecuta(2, gSql) Then Exit Sub

    While Not MAdo.EOF

        CmbPeriodo.AddItem CStr(CLng(MAdo.GetField(1)))

        Call MAdo.Mnext(Mlhstmt, MlhDbc)

    Wend

End Sub

Private Function ObtenerRutaTxt(pNombreProcesado As String, pDirectorio As String) As String
    ObtenerRutaTxt = ""
    
    With Me.CommDir
        .DialogTitle = "Guardar archivo de Dispersión Banco Bajío"
        .Filter = "Archivo de Texto (*.txt)|*.txt"
        .FileName = pNombreProcesado
        
        If Dir(pDirectorio, vbDirectory) <> "" Then
            .InitDir = pDirectorio
        End If
        
        .ShowSave
        If .FileName <> "" Then
            ObtenerRutaTxt = .FileName
            If LCase(Right(ObtenerRutaTxt, 4)) <> ".txt" Then
                ObtenerRutaTxt = ObtenerRutaTxt & ".txt"
            End If
        End If
    End With
End Function

Private Function fValidar() As Boolean

    fValidar = False

    If CmbTipoNomina.ListIndex = -1 Then
        MsgBox "Seleccione un Tipo de Nómina", vbExclamation
        Exit Function
    End If

    If CmbAnio.ListIndex = -1 Then
        MsgBox "Seleccione un Año de Nómina", vbExclamation
        Exit Function
    End If

    If CmbPeriodo.ListIndex = -1 Then
        MsgBox "Seleccione un Período de Nómina", vbExclamation
        Exit Function
    End If

    fValidar = True

End Function

Private Sub BtnPdf_Click()

    Dim vTipoNomina As String
    Dim vAnio As Long
    Dim vPeriodo As Long

    Dim xlLibro As Object
    Dim xlHoja As Object
    Dim xlApp As Object
    Dim ultimaFila As Long

    On Error GoTo ErrorHandler

    If Not fValidar Then Exit Sub

    vTipoNomina = arrTipoNomina(CmbTipoNomina.ListIndex)
    vAnio = CLng(CmbAnio.Text)
    vPeriodo = CLng(CmbPeriodo.Text)


    gSql = _
        "Select id_calendario " & _
        "From dbo.calendario_procesos " & _
        "Where tipo_nomina = '" & vTipoNomina & "' " & _
        "And anio = " & vAnio & " " & _
        "And periodo = " & vPeriodo

    If Not fEjecuta(2, gSql) Then

        MsgBox "No existe un calendario para los datos seleccionados.", _
               vbExclamation

        Exit Sub

    End If

    glIdCalendario = CStr(CLng(MAdo.GetField(1)))

    gSql = _
        "Declare " & _
        "   @PnEstatus Integer, " & _
        "   @PsMensaje Varchar(250) " & _
        "Begin " & _
        "   Execute dbo.spc_repLayoutBajio " & _
        "      @PsCompania      = '" & gCiaCodigo & "', " & _
        "      @PnId_Calendario = " & glIdCalendario & ", " & _
        "      @PsOperacion     = '" & glOperacion & "', " & _
        "      @PsUsuario       = '" & gUserId & "', " & _
        "      @PnEstatus       = @PnEstatus OUTPUT, " & _
        "      @PsMensaje       = @PsMensaje OUTPUT " & _
        "End"

    If Not fEjecuta(2, gSql) Then

        MsgBox "Error al consultar la información.", vbExclamation

        Exit Sub

    End If

    If MAdo.EOF Then

        MsgBox "No existen registros para generar el reporte.", _
               vbExclamation

        Exit Sub

    End If

    If Not CargarDatosPdf() Then Exit Sub

    Call ExportarPdf

    Exit Sub

ErrorHandler:

    MsgBox "Error " & Err.Number & vbCrLf & _
           Err.Description, vbCritical

End Sub

Private Function ObtenerRutaPdf(ByVal pNombreProcesado As String, _
                                ByVal pDirectorio As String) As String

    ObtenerRutaPdf = ""

    With Me.CommDir

        .DialogTitle = "Guardar PDF Dispersión Banco Bajío"

        .Filter = "Archivo PDF (*.pdf)|*.pdf"

        .FileName = pNombreProcesado

        If Dir(pDirectorio, vbDirectory) <> "" Then
            .InitDir = pDirectorio
        End If

        .ShowSave

        If .FileName <> "" Then

            ObtenerRutaPdf = .FileName

            If LCase(Right(ObtenerRutaPdf, 4)) <> ".pdf" Then
                ObtenerRutaPdf = ObtenerRutaPdf & ".pdf"
            End If

        End If

    End With

End Function

Private Sub ExportarPdf()

    Dim xlLibro As Object
    Dim xlHoja As Object
    Dim xlApp As Object

    Dim ultimaFila As Long

    Dim rutaPDF As String
    Dim nombrePDF As String
    Dim directorio As String
    Dim vNombreArchivo As String

    On Error GoTo ErrorHandler

    Set xlLibro = GenerarExcelDispersacion( _
                        xlHoja, _
                        xlApp, _
                        ultimaFila)

    xlApp.Visible = False
    

    vNombreArchivo = Replace( _
                        glRuta, _
                        "CIA", _
                        Trim$(gCiaCodigo))

    vNombreArchivo = Replace( _
                        vNombreArchivo, _
                        "IDCAL", _
                        Trim$(glIdCalendario))

    directorio = Left$( _
                    vNombreArchivo, _
                    InStrRev(vNombreArchivo, "\") - 1)

    nombrePDF = Replace( _
                    Mid$( _
                        vNombreArchivo, _
                        InStrRev(vNombreArchivo, "\") + 1), _
                    ".txt", _
                    ".pdf")

    nombrePDF = Replace( _
                    nombrePDF, _
                    ".TXT", _
                    ".PDF")

    rutaPDF = ObtenerRutaPdf(nombrePDF, directorio)

    If Trim$(rutaPDF) = "" Then GoTo Salida


    xlHoja.ExportAsFixedFormat _
            Type:=0, _
            FileName:=rutaPDF, _
            Quality:=0, _
            IncludeDocProperties:=True, _
            IgnorePrintAreas:=False, _
            OpenAfterPublish:=False

    xlLibro.Close False
    xlApp.Quit

    Set xlHoja = Nothing
    Set xlLibro = Nothing
    Set xlApp = Nothing

    MsgBox "PDF generado correctamente." & _
           vbCrLf & rutaPDF, _
           vbInformation

    Call ShellExecute( _
            Me.hwnd, _
            "open", _
            rutaPDF, _
            vbNullString, _
            vbNullString, _
            1)

    Exit Sub

Salida:

    If Not xlLibro Is Nothing Then xlLibro.Close False

    If Not xlApp Is Nothing Then xlApp.Quit

    Set xlHoja = Nothing
    Set xlLibro = Nothing
    Set xlApp = Nothing

    Exit Sub

ErrorHandler:

    MsgBox "Error al generar PDF:" & vbCrLf & _
           Err.Description, vbCritical

    Resume Salida

End Sub

Private Sub InicializarGridPdf()

    With grdPdf

        .Rows = 1
        .Cols = 4

        .TextMatrix(0, 0) = "Trabajador"
        .TextMatrix(0, 1) = "Nombre"
        .TextMatrix(0, 2) = "Cuenta Trabajador"
        .TextMatrix(0, 3) = "Importe"

        .ColWidth(0) = 1200
        .ColWidth(1) = 4500
        .ColWidth(2) = 2500
        .ColWidth(3) = 1800

    End With

End Sub

Private Function CargarDatosPdf() As Boolean

    Dim fila As Long
    Dim importe As Currency

    On Error GoTo ErrHandler

    Call InicializarGridPdf

    fila = 1

    mTotalImporte = 0
    mTotalTrabajadores = 0

    If MAdo.EOF Then Exit Function

    Do While Not MAdo.EOF

        If fila = 1 Then

            mBanco = Trim(MAdo.GetField(1) & "")
            mClaseNomina = Trim(MAdo.GetField(2) & "")
            mTipoNomina = Trim(MAdo.GetField(3) & "")
            mPeriodo = Trim(MAdo.GetField(5) & "")
            mFechaPago = Trim(MAdo.GetField(6) & "")
            mFechaGeneracion = Trim(MAdo.GetField(4) & "") & " " & Format$(Time$, "hh:nn:ss")

        End If

        grdPdf.Rows = grdPdf.Rows + 1

        grdPdf.TextMatrix(fila, 0) = Trim(MAdo.GetField(7) & "")
        grdPdf.TextMatrix(fila, 1) = Trim(MAdo.GetField(8) & "")
        grdPdf.TextMatrix(fila, 2) = Trim(MAdo.GetField(9) & "")

        importe = CCur(Val(MAdo.GetField(10) & ""))

        grdPdf.TextMatrix(fila, 3) = Format(importe, "#,##0.00")

        mTotalImporte = mTotalImporte + importe

        mTotalTrabajadores = mTotalTrabajadores + 1

        fila = fila + 1

        Call MAdo.Mnext(Mlhstmt, MlhDbc)

    Loop

    CargarDatosPdf = True
     
       
    Exit Function

ErrHandler:

    MsgBox "Error al cargar datos PDF: " & _
           Err.Description, vbCritical

End Function

Private Function GenerarExcelDispersacion(ByRef xlHoja As Object, _
                                          ByRef xlApp As Object, _
                                          ByRef ultimaFila As Long) As Object

    Dim xlLibro As Object

    Set xlApp = CreateObject("Excel.Application")

    Set xlLibro = xlApp.Workbooks.Add

    Set xlHoja = xlLibro.Worksheets(1)

    xlApp.Visible = False

    Call ConstruirReporteBajio(xlHoja, ultimaFila)

    Set GenerarExcelDispersacion = xlLibro

End Function

Private Sub ConstruirReporteBajio(ByVal xlHoja As Object, _
                                  ByRef ultimaFila As Long)

    Dim fila As Long
    Dim i As Long

    xlHoja.Cells.Clear

    xlHoja.Range("A1:F1").Merge
    xlHoja.Cells(1, 1) = UCase$(Trim$(gCiaDescrip))

    With xlHoja.Cells(1, 1)
        .Font.Bold = True
        .Font.Size = 14
        .HorizontalAlignment = -4108      'Centro
    End With

    xlHoja.Range("A2:F2").Merge
    xlHoja.Cells(2, 1) = "REPORTE DISPERSION BANCARIA"

    With xlHoja.Cells(2, 1)
        .Font.Bold = True
        .Font.Size = 12
        .HorizontalAlignment = -4108
    End With

    xlHoja.Range("A3:F3").Merge
    xlHoja.Cells(3, 1) = UCase$(Trim$(mBanco))

    With xlHoja.Cells(3, 1)
        .Font.Bold = True
        .HorizontalAlignment = -4108
    End With

    xlHoja.Cells(5, 1) = "Clase Nómina:"
    xlHoja.Cells(6, 1) = "Tipo Nómina:"
    xlHoja.Cells(7, 1) = "Periodo:"
    xlHoja.Cells(8, 1) = "Fecha Pago:"

    xlHoja.Cells(5, 2) = mClaseNomina
    xlHoja.Cells(6, 2) = mTipoNomina
    xlHoja.Cells(7, 2) = mPeriodo
    xlHoja.Cells(8, 2) = mFechaPago

    xlHoja.Range("A5:A8").Font.Bold = True

    xlHoja.Cells(5, 6) = "Usuario:"
    xlHoja.Cells(6, 6) = "Fecha Generación:"

    xlHoja.Cells(5, 7) = Trim(gUserId)
    xlHoja.Cells(6, 7) = Trim(mFechaGeneracion)

    xlHoja.Range("F5:F7").Font.Bold = True

    fila = 11

    xlHoja.Cells(fila, 1) = "Trabajador"
    xlHoja.Cells(fila, 2) = "Nombre"
    xlHoja.Cells(fila, 3) = "Cuenta Trabajador"
    xlHoja.Cells(fila, 4) = "Importe"

    With xlHoja.Range("A11:D11")

        .Font.Bold = True
        .Interior.Color = RGB(220, 220, 220)
        .HorizontalAlignment = -4108
        .Borders.LineStyle = 1

    End With

    For i = 1 To grdPdf.Rows - 1

        xlHoja.Cells(fila + i, 1) = grdPdf.TextMatrix(i, 0)
        xlHoja.Cells(fila + i, 2) = grdPdf.TextMatrix(i, 1)
        xlHoja.Cells(fila + i, 3) = grdPdf.TextMatrix(i, 2)

        xlHoja.Cells(fila + i, 4) = CDbl(Replace( _
                                        grdPdf.TextMatrix(i, 3), _
                                        ",", ""))

    Next i

    ultimaFila = fila + grdPdf.Rows - 1


    ultimaFila = ultimaFila + 2

    xlHoja.Cells(ultimaFila, 1) = "TOTAL TRABAJADORES:"
    xlHoja.Cells(ultimaFila, 2) = Format$(mTotalTrabajadores, "#,##0")

    xlHoja.Cells(ultimaFila + 1, 1) = "TOTAL IMPORTE:"
    xlHoja.Cells(ultimaFila + 1, 4) = mTotalImporte

    xlHoja.Cells(ultimaFila + 1, 4).NumberFormat = "$ #,##0.00"

    xlHoja.Range("A" & ultimaFila & ":D" & (ultimaFila + 1)).Font.Bold = True

    xlHoja.Columns("A").ColumnWidth = 16
    xlHoja.Columns("B").ColumnWidth = 45
    xlHoja.Columns("C").ColumnWidth = 25
    xlHoja.Columns("D").ColumnWidth = 18
    xlHoja.Columns("F").ColumnWidth = 18
    xlHoja.Columns("G").ColumnWidth = 15

    xlHoja.Columns("D").NumberFormat = "#,##0.00"

    xlHoja.Range("A5:A8").Font.Bold = True

    xlHoja.Range("A11:D11").HorizontalAlignment = -4108

    xlHoja.Columns("D").HorizontalAlignment = -4152

    With xlHoja.Range("A11:D" & (ultimaFila + 1))

        .Borders(7).LineStyle = 1
        .Borders(8).LineStyle = 1
        .Borders(9).LineStyle = 1
        .Borders(10).LineStyle = 1
        .Borders(11).LineStyle = 1
        .Borders(12).LineStyle = 1

    End With

    With xlHoja.PageSetup

        .RightHeader = "Página: &P de &N"

        .PrintTitleRows = "$1:$11"

        .Zoom = False

        .FitToPagesWide = 1
        .FitToPagesTall = False

        .Orientation = 2

        .CenterHorizontally = True

        .TopMargin = 20
        .HeaderMargin = 5

        .LeftMargin = 20
        .RightMargin = 20
        .BottomMargin = 20

    End With

End Sub

