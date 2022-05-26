; Block Traffic by Melo
; melo@meloprofessional.com


/*@Ahk2Exe-Keep
#SingleInstance Force
gui_title := "Block Traffic"
WinShow %gui_title% ahk_class AutoHotkeyGUI
if WinExist(gui_title " ahk_class AutoHotkeyGUI")
    ExitApp
*/

;@Ahk2Exe-SetName Block Traffic
;@Ahk2Exe-SetFileVersion 1.0
;@Ahk2Exe-SetCopyright © Melo. All rights reserved.
;@Ahk2Exe-UpdateManifest 1

;@Ahk2Exe-IgnoreBegin
#SingleInstance Off
gui_title := "Block Traffic"
WinShow %gui_title% ahk_class AutoHotkeyGUI
if WinExist(gui_title " ahk_class AutoHotkeyGUI")
    ExitApp
	if not (RegExMatch(DllCall("GetCommandLine", "str"), " /restart(?!\S)")) 
	{
		Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%",, UseErrorLevel
		ExitApp
	}
;@Ahk2Exe-IgnoreEnd



#Include AppFactory.ahk
#Persistent
Appname := "Block Traffic"
Version := "1.0"
SplitPath, A_ScriptName,,,, ScriptName
ScriptName = %ScriptName%.ini
global Appname, Version
global ScriptName, factory, timer, timerms
SetWorkingDir %temp%
Menu, tray, NoStandard
Menu, tray, deleteall
Menu, Tray, Tip , %Appname%
TrayTip, %Appname%, Running at system tray, 6


factory := new AppFactory()
Gui, Margin , 20, 20
Gui, Add, Text, y+25 w94, Keybind:
factory.AddInputButton("MyHotkey", "x+50 yp-10 w100", Func("TypeGreeting"))
Gui, Add, Text, xm yp+60 w94, Timeout (seconds):
factory.AddControl("MyEdit", "Edit", "x+105 yp-3 w40", "10", Func("EditChanged"))
Gui, Add, Button, w80 x100 y+35, &OK
timer := factory.GuiControls.MyEdit.Get()
timerms := timer * 1000

if !FileExist(ScriptName)
{
;FileInstall, blocktraffic.ini, blocktraffic.ini
;Gui, -LastFound -AlwaysOnTop +Caption -ToolWindow
Gui, Show, center, %Appname% v %Version%
;Sleep 1000
}

else
{
Gui Starting:new
Gui Starting:+Owner +AlwaysOnTop -Caption +ToolWindow +Border
Gui Starting:add, Text,, Block Traffic waiting
;Gui, Starting:+LastFound +AlwaysOnTop -Caption +ToolWindow +Border
Gui Starting:show, AutoSize Center NoActivate
Sleep 4000
Gui Starting:Destroy
}

EditChanged(state){
	global timer, timerms
	if (timer){
timer := factory.GuiControls.MyEdit.Get()
timerms := timer * 1000
	}
}


TypeGreeting(state){
global factory
;global Guiblockplaceholder
if (state){
WinGet, Path, ProcessPath, A
Run cmd.exe /c netsh advfirewall firewall add rule name="_My Custom Traffic Blocking" dir=in action=block profile=any program="%Path%" >nul,, hide
Run cmd.exe /c netsh advfirewall firewall add rule name="_My Custom Traffic Blocking" dir=out action=block profile=any program="%Path%" >nul,, hide
Winget,AppBlockedName,ProcessName,A
;WinGetActiveTitle, AppBlockedName
;WinGetTitle,AppBlockedName,A

Gui, Blocking:new
;Gui, Blocking:add, Text, vGuiblockplaceholder, Blocking Traffic for %AppBlockedName%
Gui, Blocking:add, Text, Center, Blocking Traffic for %AppBlockedName%`n`n wait %timer% seconds...
Gui, Blocking:+LastFound +AlwaysOnTop -Caption +ToolWindow +Border
Gui, Blocking:show, AutoSize Center NoActivate
Sleep timerms
Run cmd.exe /c netsh advfirewall firewall delete rule name="_My Custom Traffic Blocking" >nul,, hide
;GuiControl,, Guiblockplaceholder, Done

Gui, Blocking:Cancel

Gui, Blocking:new
;Gui, Blocking:add, Text, vGuiblockplaceholder, Done
Gui, Blocking:add, Text, , Done
Gui, Blocking:+LastFound +AlwaysOnTop -Caption +ToolWindow +Border
Gui, Blocking:show, AutoSize Center NoActivate
Sleep 2000
Gui, Blocking:Cancel
}
}

Menu, tray, NoStandard
Menu, tray, deleteall
Menu, Tray, MainWindow
Menu, Tray, Tip , %Appname%
Menu, Tray, Add, Settings , Settings
Menu, Tray, Add, Restart , Restart
Menu, Tray, Add, About, About
Menu, Tray, add
Menu, Tray, Add, Exit, Exit
Menu, Tray, Default, Settings
Menu, Tray, Click, 1
;Menu, Tray, Show
return

Settings:
;factory := new AppFactory()
;factory.AddInputButton("MyHotkey", "w250", Func("TypeGreeting"))
;Gui, Show, x0 y0
;Gui, +LastFound +AlwaysOnTop +Caption +ToolWindow
Gui, -LastFound -AlwaysOnTop +Caption -ToolWindow
Gui, Show, center, %Appname% v %Version%
return

Restart:
Gui, Restart:new
Gui, Restart:+LastFound +AlwaysOnTop -Caption +ToolWindow +Border
Gui, Restart:add, Text,, Restarting %Appname%
Gui, Restart:show, AutoSize Center NoActivate
Sleep 2000
Gui, Restart:Cancel
Reload
Sleep 5000
MsgBox,,, Error restarting %Appname%
ExitApp
return

About:
MsgBox ,,%Appname%,Block Traffic`nversion %Version%`n`nA small program to block network traffic from any active window.`n`n`n`nBy Melo`nmelo@meloprofessional.com`n© Melo. All rights reserved.
return

GuiClose:
ButtonOK:
Gui, Submit
return

Exit:
ExitApp
return

