; Utilities used frequently
WinSwap(PartialTitle, Executable){ ;{ Swap windows of the same PartialTitle
  SetTitleMatchMode, 2 ; Contains
  WinGet, windows_list, List, %PartialTitle%
  If windows_list > 0
    WinActivate, % "ahk_id " windows_list%windows_list%
  Else
    Run, %Executable%
}

WinSwapMin(PartialTitle, AHKEXE, Executable){ ;{ Same as WinSwap, but minimize windows between switching
  If !WinExist(%PartialTitle%)
    Run, %Executable%
  Else If WinActive(%AHKEXE%)
    WinMinimize
  Else
    WinActivate, %AHKEXE%
}

NewTab(url, Rest:=1000, incognito:=false, Executable:="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"){ ;{ Open a new tab to the url
  If(incognito = "false")
    Run, %Executable% %url%
  Else
    Run, %Executable% %url% -%incognito%
  Sleep, %Rest%
  Send, ^0  ; if you've zoomed in previously, Chrome remembers and it will mess up the button click locations
}

Crest(x, y:=0, Rest:=1000, cm:="", right:="false"){ ;{ Click + Rest = Crest. Move to (X,Y) or (x[1],x[2]) coordinates, pause 1 sec, click, rest. cm means CoordMode, and can only be Screen, Relative, Window, or Client - and it will switch back to Window at the end; right:=false - true for right-click.
  CoordMode, Mouse, Window

  ; You can change the coord mode. Possible Values are Screen, Relative and Client - Window is the default.
  If(cm && cm != ""){
    AllowedValues := ["Screen", "Relative", "Client"]
    If (Includes(AllowedValues,cm))
      CoordMode, Mouse, %cm%
    Else {
      WrongParameter("cm","Crest","ahk_utilities",cm,AllowedValues)
      return
    }
  }

  If(IsArray(x)){
    y:=x[2]
    x:=x[1]
    ;;;; ARRAYS ARE 1-BASED ;;;;
  }

  MouseMove, x, y, 5 ; 5 is how fast the mouse will move to that position, 0-100 (0 means instantly)
  Sleep, 1000

  If(right = "RightClick")
    Click, right
  Else
    Click
  Sleep, %Rest%

  if(cm)
    CoordMode, Mouse, Window
}

Seep(TextToGo,Rest:=1000){ ;{ Seep = Send + Sleep
  Send, %TextToGo%
  Sleep, %Rest%
}

; Activate or open new window
; Used like: Act("Atom","C:\Users\theeter\AppData\Local\atom\atom.exe")
Act(PartialTitle, Executable){
  SetTitleMatchMode, 2
  If !WinExist(PartialTitle)
    Run, %Executable%
  If !WinActive(PartialTitle)
    WinActivate
  Sleep, 1000
}

; Select the user from the Phoenix Drop-Down
; Attn: if you add certs to Phoenix, you may need to change the order
; This is aligned with the user selection when you first visit phoenix
SelectUser(userType:="DMAnalyst"){
  AllowedValues := []

  ; The order of certs as they appear on the phoenix cert window
  AllowedValues.Push("Org23TM")         ; 0
  AllowedValues.Push("Org23Admin")      ; 1
  AllowedValues.Push("Org23Analyst")    ; 2
  AllowedValues.Push("ArmyComponent")   ; 3
  AllowedValues.Push("ArmyIno")         ; 4
  AllowedValues.Push("ArmySme")         ; 5
  AllowedValues.Push("ArmyTM")          ; 6
  AllowedValues.Push("ArmySystem")      ; 7
  AllowedValues.Push("ArmyIsso")        ; 8
  AllowedValues.Push("ArmyDataAdmin")   ; 9
  AllowedValues.Push("ArmyAdmin")       ; 10
  AllowedValues.Push("ArmySupervisor")  ; 11
  AllowedValues.Push("ArmyAnalyst")     ; 12
  AllowedValues.Push("DMTM")            ; 13
  AllowedValues.Push("DMIsso")          ; 14
  AllowedValues.Push("DMAdmin")         ; 15
  AllowedValues.Push("DMAnalyst")       ; 16
  AllowedValues.Push("DM_T_M")          ; 17 - Doesn't work; use Org23TM instead
  AllowedValues.Push("DM_Analyst")      ; 18

  If (Includes(AllowedValues,userType))
  {
    ; Since the array is in order, the number of times to press down is the index of the array minus 1
    for index, element in AllowedValues{
      if(userType = element)
        DownTimes := index-1  ; index needs to be converted to zero-based.
    }

    Sleep, 1000
    Send, {Down %DownTimes%}
    Sleep, 500
    Send, {Enter}
    Sleep, 1000

  } Else { ; Handle incorrect params
    WrongParameter("UserType", "SelectUser", "ahk_utilities", userType, AllowedValues)
    return
  }
}

ErrMsg(Title,Message){
  msgBox, 272, %Title%, %Message%
}

CloseAllCMDs(){ ;{ Close all cmd windows
  Loop
  {
    Process, Close, cmd.exe
    If !ErrorLevel
      Break
  }
  Sleep, 1000
}

IsArray(obj){
  return !! obj.MaxIndex()
}

WrongParameter(ParameterName, FunctionName, FileName, ValueSent, ArrayOfPossibleValues){
  Title := "Wrong Parameter: " . ParameterName . " " . FunctionName . " " . FileName
  Message := "You sent a value to " . FunctionName . " that didn't match any allowed values. The value sent was '" . ValueSent . "'. The allowed values are '" . Join(ArrayOfPossibleValues) . "'. See the file, " . FileName . ", for more info."
  ErrMsg(Title,Message)
}

; Rebuilds an ahk script automatically
Rescript(script:="cmd"){
  AllowedValues := []

  AllowedValues.Push("atom")      ;  0 - atom
  AllowedValues.Push("chrome")    ;  1 - chrome
  AllowedValues.Push("cmd")       ;  2 - cmd
  AllowedValues.Push(null)        ;  3 - null
  AllowedValues.Push("exp")       ;  4 - exp
  AllowedValues.Push("git")       ;  5 - git
  AllowedValues.Push(null)        ;  6 - null
  AllowedValues.Push(null)        ;  7 - null
  AllowedValues.Push(null)        ;  8 - null
  AllowedValues.Push("startup")   ;  9 - startup
  AllowedValues.Push("switch")    ; 10 - switchToApps

  If (script && Includes(AllowedValues,script))
  {
    ; Since the array is in order, the number of times to press down is the index of the array minus 1
    for index, element in AllowedValues{
      if(script = element)
        DownTimes := index  ; The first file is .git so this will actually be 1-based
    }
    ; Wait for these keys to be releases
    KeyWait Control
    KeyWait Alt
    KeyWait Shift

    Seep("{F4}")    ; activate file explorer
    Crest(47, 401)  ; click Startup from pinned folders
    Seep("{Tab}")   ; move into the file pane
    Send, {Down %DownTimes%}
    Sleep, 1000
    Seep("{Shift Down}{F10}{Shift Up}")  ; Richt-click with the keyboard
    Seep("{Down 1}")  ; Select "Run Script"
    Seep("{Enter}")


  } Else { ; Handle incorrect params
    WrongParameter("script", "Rescript", "ahk_utilities", script, AllowedValues)
    return
  }

  Sleep, 1000
}

; Join an array together with s, the separator, ", " by default
Join(p,s:=", "){
  for k,v in p
  {
    if isobject(v)
      for k2, v2 in v
        o.=s v2
    else
      o.=s v
  }
  return SubStr(o,StrLen(s)+1)
}

; Does array (a) include value (v) ?
Includes(a,v){
  for i, e in a
    if(e = v)
      return i
  return 0
}
