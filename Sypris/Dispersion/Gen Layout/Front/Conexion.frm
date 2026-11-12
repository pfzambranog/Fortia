VERSION 5.00
Begin VB.Form frmConexion 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Conexión a la fuente de datos"
   ClientHeight    =   4530
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6000
   Icon            =   "Conexion.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "Conexion.frx":030A
   ScaleHeight     =   4530
   ScaleWidth      =   6000
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtDsn 
      Height          =   315
      Left            =   2400
      TabIndex        =   3
      Top             =   3480
      Width           =   1935
   End
   Begin VB.TextBox txtCiaCodigo 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   2400
      TabIndex        =   4
      Top             =   3840
      Width           =   1935
   End
   Begin VB.TextBox txtPassw 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   2400
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   3120
      Width           =   1935
   End
   Begin VB.TextBox txtUserid 
      Height          =   315
      Left            =   2400
      TabIndex        =   0
      Top             =   2760
      Width           =   1935
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Compañia"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000D&
      Height          =   195
      Left            =   1320
      TabIndex        =   1
      Top             =   3900
      Width           =   840
   End
   Begin VB.Image cmdAceptar 
      Height          =   480
      Left            =   5160
      Picture         =   "Conexion.frx":5A748
      Top             =   3840
      Width           =   480
   End
   Begin VB.Image cmdCancelar 
      Height          =   480
      Left            =   4560
      Picture         =   "Conexion.frx":5AA52
      Top             =   3840
      Width           =   480
   End
   Begin VB.Image imgImagen1 
      Height          =   480
      Index           =   6
      Left            =   60
      Picture         =   "Conexion.frx":5AD5C
      Top             =   1080
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image imgImagen1 
      Height          =   480
      Index           =   4
      Left            =   0
      Picture         =   "Conexion.frx":5B066
      Top             =   0
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image imgImagen1 
      Height          =   480
      Index           =   1
      Left            =   600
      Picture         =   "Conexion.frx":5B370
      Top             =   0
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image imgImagen1 
      Height          =   480
      Index           =   3
      Left            =   600
      Picture         =   "Conexion.frx":5B67A
      Top             =   1080
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image imgImagen1 
      Height          =   480
      Index           =   2
      Left            =   600
      Picture         =   "Conexion.frx":5B984
      Top             =   540
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image imgImagen1 
      Height          =   480
      Index           =   5
      Left            =   0
      Picture         =   "Conexion.frx":5BC8E
      Top             =   600
      Visible         =   0   'False
      Width           =   480
   End
End
Attribute VB_Name = "frmConexion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdAceptar_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  cmdAceptar.Picture = imgImagen1(3).Picture
End Sub

Private Sub cmdAceptar_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  cmdAceptar.Picture = imgImagen1(2).Picture
End Sub

Private Sub cmdAceptar_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
  cmdAceptar.Picture = imgImagen1(1).Picture
End Sub

Private Sub cmdAceptar_Click()
  txtUserid.Text = UCase(Trim(txtUserid.Text))
  txtPassw.Text = txtPassw.Text
  txtDsn.Text = UCase(Trim(txtDsn.Text))
  txtCiaCodigo.Text = UCase(Trim(txtCiaCodigo.Text))
  gUserId = txtUserid.Text
  gPassW = txtPassw.Text
  gDsn = txtDsn.Text
  gCiaCodigo = txtCiaCodigo.Text
  Call pLeerLinCmd
End Sub

Private Sub cmdCancelar_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  cmdCancelar.Picture = imgImagen1(6).Picture
End Sub

Private Sub cmdCancelar_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  cmdCancelar.Picture = imgImagen1(5).Picture
End Sub

Private Sub cmdCancelar_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
  cmdCancelar.Picture = imgImagen1(4).Picture
End Sub

Private Sub cmdCancelar_Click()
  Call MAdo.CloseConnection(MlhDbc, Mlhstmt)
  Unload Me
  End
End Sub

Private Sub Form_Load()
  Call pLeerLinCmd
End Sub

Private Sub pLeerLinCmd()
  Dim vLinCmd As String, i As Integer
  
  If gDsn = "" And gUserId = "" And gPassW = "" And gCiaCodigo = "" Then
    vLinCmd = Trim(Command()) & ","
    For i = 1 To 4
      If InStr(vLinCmd, ",") > 0 Then
        Select Case i
        Case 1
              gDsn = Trim(Mid(vLinCmd, 1, InStr(vLinCmd, ",") - 1))
        Case 2
              gUserId = Trim(Mid(vLinCmd, 1, InStr(vLinCmd, ",") - 1))
        Case 3
              gPassW = Trim(Mid(vLinCmd, 1, InStr(vLinCmd, ",") - 1))
        Case 4
              gCiaCodigo = Trim(Mid(vLinCmd, 1, InStr(vLinCmd, ",") - 1))
        End Select
        vLinCmd = Trim(Mid(vLinCmd, InStr(vLinCmd, ",") + 1))
      End If
    Next
  End If
  If gDsn = "" Or gUserId = "" Or gPassW = "" Or gCiaCodigo = "" Then
    Me.Show
    Exit Sub
  End If
  
  If Not fConectar Then
    Call MsgBox("Error: Conectando a ADAM")
    Me.Show
    txtUserid.SetFocus
    Exit Sub
  End If
  
  Load gForma
  
End Sub

Private Function fConectar() As Boolean
  Dim vConectar As Boolean
  vConectar = MAdo.OpenConEnv(MlhEnv, MlhDbc, Mlhstmt, gDsn, gUserId, gPassW)
  vConectar = MAdo.OpenConnection(MlhEnv, MlhDbc, Mlhstmt, gDsn, gUserId, gPassW)
  
  If vConectar Then
    gSql = "Select Compania From Aut_Companias Where Compania = '" & gCiaCodigo & "' And Usuario = '" & gUserId & "'"
    If Not fEjecuta(2, gSql) Then
      Call MsgBox("Error: Usuario no autorizado")
      fConectar = False
      Exit Function
    End If
    
    gSql = "Select Nombre_Cia From Companias Where Compania = '" & gCiaCodigo & "'"
    If Not fEjecuta(2, gSql) Then
      Call MsgBox("Error: No existe esta compañia")
      fConectar = False
      Exit Function
    End If
    gCiaDescrip = MAdo.GetField(1) & ""
  End If
  fConectar = vConectar
End Function
Private Sub txtDsn_KeyPress(KeyAscii As Integer)
Select Case KeyAscii
      Case 13
      txtCiaCodigo.SetFocus
      End Select
End Sub

Private Sub txtPassw_KeyPress(KeyAscii As Integer)
 Select Case KeyAscii
      Case 13
      txtDsn.SetFocus
      End Select
End Sub

Private Sub txtUserid_KeyPress(KeyAscii As Integer)
 Select Case KeyAscii
      Case 13
      txtPassw.SetFocus
    
      
      End Select
End Sub
