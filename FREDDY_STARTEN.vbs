Dim fso, dir, pythonw, watchdog, oShell, oWMI, oProcs, oProc

Set fso    = CreateObject("Scripting.FileSystemObject")
Set oShell = CreateObject("WScript.Shell")
dir        = fso.GetParentFolderName(WScript.ScriptFullName)
pythonw    = "C:\Users\Admin\AppData\Local\Programs\Python\Python312\pythonw.exe"
watchdog   = dir & "\freddy_watchdog.py"

' Alten FREDDY-Server und Watchdog beenden (falls noch aktiv)
Set oWMI   = GetObject("winmgmts:\\.\root\cimv2")
Set oProcs = oWMI.ExecQuery("SELECT * FROM Win32_Process WHERE Name='pythonw.exe'")
For Each oProc In oProcs
    If InStr(LCase(oProc.CommandLine), "freddy_") > 0 Then
        oProc.Terminate()
    End If
Next

' Kurz warten bis Port frei ist
WScript.Sleep 2000

' Watchdog starten — der haelt den Server automatisch am Leben
oShell.CurrentDirectory = dir
oShell.Run """" & pythonw & """ -X utf8 """ & watchdog & """", 0, False

' Browser oeffnen (kurze Verzoegerung damit der Server hochfahren kann)
WScript.Sleep 3000
oShell.Run "http://localhost:7432", 1, False
