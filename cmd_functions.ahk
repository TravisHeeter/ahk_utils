; cmd_functions

#Include C:\ahk_scripts\GlobalVariables.ahk
#Include C:\ahk_scripts\ahk_utils\ahk_utilities.ahk
#Include C:\ahk_scripts\ahk_utils\ahk_functions.ahk

newCmd(){ ;{ if an explorer window is open, open a cmd prompt to that location
  if WinActive("ahk_class CabinetWClass")
  or WinActive("ahk_class ExploreWClass")
  {
    WinHWND := WinActive()
    For win in ComObjCreate("Shell.Application").Windows
      If (win.HWND = WinHWND){
        currdir := SubStr(win.LocationURL, 9)
        currdir := RegExReplace(currdir, "%20", " ")
        Break
      }
  }
  Run, cmd, % currdir ? currdir : "C:\"
}

RebuildPhoenix(){
  CloseAllCMDs()

  Run, cmd, c:\
  Sleep, 1000

  ; rerun rebuildPhoenix.bat
  Seep("rebuildPhoenix.bat{Enter}")
}

ReloadCaseServer(){
  SetTitleMatchMode, 2 ; Contains
  WinActivate, "Case"
  ;WinClose, "Case"
  ;SetTitleMatchMode, 3 ; Exact
  ;WinActivate, C:\Windows\SYSTEM32\cmd.exe
  ;Send, cd %crnt%\main\common\services
  ;Send, {Enter}
  ;Send, mvn clean install -Dmaven.test.skip -e
  ;Send, {Enter}
  ;Send, cd %crnt%\main\case-management\
  ;Send, {Enter}
  ;Send, mvn clean install -Dmaven.test.skip -e
  ;Send, {Enter}
  ;Send, start "Case Server - PHOENIX" java -jar case-management-1.0-SNAPSHOT.jar}
}

RescriptCMD(){
  Rescript("cmd")
  Seep("{F3}")  ; Switch to Atom
}

WinSwapCMD(){ ; different from regular WinSwap because it needs to call newCmd() to open a new cmd window, sending executable may work, but hasn't been tested.
  SetTitleMatchMode, 2 ; Contains
  WinGet, cmd_windows, List, ahk_exe cmd.exe
  If cmd_windows > 0
    WinActivate, % "ahk_id " cmd_windows%cmd_windows%
  Else
    newCmd()
}
