Dim fso, dir, pythonw, script, oShell, oWMI, oProcs, oProc

Set fso    = CreateObject("Scripting.FileSystemObject")
Set oShell = CreateObject("WScript.Shell")
dir        = fso.GetParentFolderName(WScript.ScriptFullName)
pythonw    = "C:\Users\Admin\AppData\Local\Programs\Python\Python312\pythonw.exe"
script     = dir & "\freddy_server.py"

' Alten FREDDY-Server beenden (falls noch aktiv)
Set oWMI   = GetObject("winmgmts:\\.\root\cimv2")
Set oProcs = oWMI.ExecQuery("SELECT * FROM Win32_Process WHERE Name='pythonw.exe'")
For Each oProc In oProcs
    If InStr(LCase(oProc.CommandLine), "freddy_server") > 0 Then
        oProc.Terminate()
    End If
Next

' Kurz warten bis Port frei ist
WScript.Sleep 1500

' Neuen Server starten (ohne Konsolenfenster)
oShell.CurrentDirectory = dir
oShell.Run """" & pythonw & """ -X utf8 """ & script & """", 0, False
