' Run assemblysync hidden
Dim Arg, var1, var2, var3, var4, var5
Set Arg = WScript.Arguments

var1 = Arg(0) 'Path to xml
var2 = Arg(1) 'Output path
var3 = Arg(2) 'Path to credentials
var4 = Arg(3) 'Customer code
var5 = Arg(4) 'Flat build structure

Set objShell = WScript.CreateObject("WScript.Shell")

If StrComp(var5, "False") = 0 Then
    var4 = "CUSTOMER_CODE"
End If

' " Double quotes are also used as escape string in .vbscript :facepalm:
returnCode = objShell.Run("cmd /c assemblysync """ & var1 & """ --dir """ & var2 & """ --extraconfigs """ & var3 & """ --InstallersToSync Shared," & var4 & " --OverwriteUpdateRoot " & var5 & " --logfile """ & var2 &"\\assemblySyncLog.log""", 0, true)

' BELOW COMMENTED CODE IS GOOD FOR TESTING PURPOSES
' returnCode = objShell.Run("cmd /c assemblysync D:\Installer\test\AssemblySyncTesting\assemblysync-0.48.7\enginePickingUp.xml --dir D:\dev\drives\o\ANOTHER_TEST -vvv --extraconfigs C:\\Users\\pavel.pek\\Downloads\\credentials.json --InstallersToSync Shared,WOCRM --OverwriteUpdateRoot True --logfile D:\dev\drives\o\ANOTHER_TEST\\freaking_log.log", 0, true)
WScript.Quit(returnCode)