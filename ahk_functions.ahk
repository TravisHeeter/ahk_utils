#Include C:\ahk_scripts\ahk_utils\ahk_utilities.ahk

CloseAllCMDs(){ ;{ Close all cmd windows
  Loop
  {
    Process, Close, cmd.exe
    If !ErrorLevel
      Break
  }
  Sleep, 1000
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

; A reusable error message notifier
ErrMsg(Title,Message){
  msgBox, 272, %Title%, %Message%
}

; Rebuilds an ahk script automatically
Rescript(script:="cmd", Screen:="Full"){
  AllowedValues := []

  AllowedValues.Push("atom")      ;  0 - atom
  AllowedValues.Push("chrome")    ;  1 - chrome
  AllowedValues.Push("cmd")       ;  2 - cmd
  AllowedValues.Push(null)        ;  3 - null
  AllowedValues.Push("exp")       ;  4 - exp
  AllowedValues.Push("git")       ;  5 - git
  AllowedValues.Push(null)        ;  6 - null
  AllowedValues.Push(null)        ;  7 - null
  AllowedValues.Push("misc")      ;  8 - misc
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

    Seep("{F4}", 500)    ; activate file explorer
    If(Screen = "Full"){
      Crest(47, 401, 500)  ; click Startup from pinned folders
      Send, {Tab}   ; move into the file pane
    } Else If(Screen = "Laptop"){
      Seep("^l")  ; Highlight path location
      Seep(startup_folder)
      Seep("{Tab 3}")  ; Tab into the file pane
    }
    Send, {Down %DownTimes%}
    Sleep, 500
    Seep("{Shift Down}{F10}{Shift Up}", 500)  ; Richt-click with the keyboard
    Seep("{Down 1}", 500)  ; Select "Run Script"
    Seep("{Enter}", 500)


  } Else { ; Handle incorrect params
    WrongParameter("script", "Rescript", "ahk_utilities", script, AllowedValues)
    return
  }

  Sleep, 1000
}

Seep(TextToGo,Rest:=1000){ ;{ Seep = Send + Sleep
  Send, %TextToGo%
  Sleep, %Rest%
}

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

WrongParameter(ParameterName, FunctionName, FileName, ValueSent, ArrayOfPossibleValues){
  Title := "Wrong Parameter: " . ParameterName . " " . FunctionName . " " . FileName
  Message := "You sent a value to " . FunctionName . " that didn't match any allowed values. The value sent was '" . ValueSent . "'. The allowed values are '" . Join(ArrayOfPossibleValues) . "'. See the file, " . FileName . ", for more info."
  ErrMsg(Title,Message)
}
