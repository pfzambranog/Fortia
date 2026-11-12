Attribute VB_Name = "Module2"
Option Explicit

Function fEjecuta(pTipo As Integer, pSql As String) As Boolean
  '
  ' 1 = Ejecutar un procedimiento
  ' 2 = Ejecutar un Select
  '
  Screen.MousePointer = 11
  MAdo.SQL = pSql
  Select Case pTipo
  Case 1:
          If MAdo.ExecSQL(MlhDbc, Mlhstmt) <> 0 Then
            Call MsgBox("Error: Procedimiento no Ejecutado " & Chr(10) & MAdo.LastError & Chr(10) & pSql)
            GoTo Error
          End If
  Case 2:
          If Not MAdo.SendSQL(MlhDbc, Mlhstmt) Then
              Call MsgBox("Error: Ejecutando el Select " & Chr(10) & MAdo.LastError & Chr(10) & pSql)
              GoTo Error
          End If
          If MAdo.EOF Then
              Call MsgBox("Error: No Existe Información " & Chr(10) & MAdo.LastError & Chr(10) & pSql)
              GoTo Error
          End If
  End Select
  fEjecuta = True
Error:
  Screen.MousePointer = 0
End Function

Sub pMostrarLista(pCombo As Object, pFlex As Object)
  pFlex.Left = pCombo.Left
  pFlex.Top = pCombo.Top
  pFlex.Visible = True
  pFlex.SetFocus
End Sub

Function fReplace(ByRef pString As String)
  Dim i As Integer
  For i = 1 To Len(pString)
    If Mid(pString, i, 1) = "/" Then Mid(pString, i, 1) = " "
  Next
  fReplace = pString
End Function

