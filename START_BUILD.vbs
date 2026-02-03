' VBScript для запуска сборки APK

Option Explicit

Dim objShell, objFSO, strProjectPath, strBatFile

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Получаем путь к текущей папке
strProjectPath = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Проверяем наличие Docker
On Error Resume Next
Dim objExec
Set objExec = objShell.Exec("docker --version")
Dim iExitCode
iExitCode = objExec.Status

On Error GoTo 0

If iExitCode <> 0 Then
    MsgBox "Docker не запущен или не установлен." & vbCrLf & vbCrLf & _
           "Пожалуйста:" & vbCrLf & _
           "1. Установите Docker Desktop" & vbCrLf & _
           "2. Запустите Docker Desktop" & vbCrLf & _
           "3. Повторите попытку", _
           vbExclamation, "Docker не найден"
    WScript.Quit 1
End If

' Запускаем bat файл
strBatFile = strProjectPath & "\build_docker.bat"

If objFSO.FileExists(strBatFile) Then
    objShell.Run strBatFile, 1, False
Else
    MsgBox "Файл build_docker.bat не найден в папке проекта", vbCritical, "Ошибка"
    WScript.Quit 1
End If
