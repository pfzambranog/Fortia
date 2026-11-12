Attribute VB_Name = "Module1"
Option Explicit

Global gSql    As String
Global MAdo    As New ODBC.ODBCDirecto
Global MAdo1   As New clsADAM


Global MlhEnv  As Long
Global MlhDbc  As Long
Global Mlhstmt As Long


Global gDirPath           As String
Global gDsn               As String
Global gUserId            As String
Global gPassW             As String
Global gCiaCodigo         As String
Global gCiaDescrip        As String
Global gForma             As Form
Global gOperacion         As String
Global fila               As Long
Global contador           As Integer
Global variablebusqueda   As String
Global glOperacion        As String
Global glRuta             As String
Global glIdCalendario     As Integer
Global gSession           As String
Global glTipoNomina       As String


Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" ( _
    ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, _
    ByVal lpDefault As String, _
    ByVal lpReturnedString As String, _
    ByVal nSize As Long, _
    ByVal lpFileName As String) As Long
    
Public Function LeerINI(ByVal Seccion As String, ByVal Clave As String, ByVal archivo As String) As String

    Dim buffer As String * 255
    Dim ret As Long

    ret = GetPrivateProfileString(Seccion, Clave, "", buffer, Len(buffer), archivo)

    LeerINI = Left$(buffer, ret)

End Function

Public Function LeerINI_Path(ByVal Clave As String) As String

    Dim linea As String
    Dim archivo As String
    Dim enSeccion As Boolean
    Dim posIgual As Integer
    Dim claveActual As String
    Dim valor As String
    Dim f As Integer

    archivo = "C:\Windows\adam.ini"

    f = FreeFile
    Open archivo For Input As #f

    enSeccion = False

    Do While Not EOF(f)

        Line Input #f, linea

        ' Limpieza completa de la línea
        linea = Replace(linea, vbTab, "")
        linea = Trim(linea)

        ' Detectar sección
        If UCase(linea) = "[PATHS]" Then
            enSeccion = True
            GoTo Continuar
        End If

        If Left(linea, 1) = "[" Then
            enSeccion = False
        End If

        If enSeccion Then

            posIgual = InStr(linea, "=")

            If posIgual > 0 Then

                claveActual = Trim(Left(linea, posIgual - 1))
                valor = Trim(Mid(linea, posIgual + 1))

                ' ?? CLAVE: quitar espacios internos también
                claveActual = Replace(claveActual, " ", "")

                If UCase(claveActual) = UCase(Clave) Then
                    LeerINI_Path = valor
                    Close #f
                    Exit Function
                End If

            End If

        End If

Continuar:
    Loop

    Close #f

    LeerINI_Path = ""

End Function


    
    
Sub Main()
  gDirPath = App.Path
  Set gForma = frmDisBajio
  gSession = Format(Time, "HHMMSS")
  Load frmConexion
End Sub

