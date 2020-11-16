; Git Bash Utilities
; The git bash script was too big, so I moved all the functions here

; Gets the current path from a file explorer window.
GetCurrentPath()
{
  If !WinActive("ahk_class CabinetWClass"){
    MsgBox, File Explorer is not active. Please open a file explorer window and navigate to a phoenix folder.
    Reload ; Stops this script and reloads it, basically what break should do.
  }
  ; This is required to get the full path of the file from the address bar
  WinGetText, full_path, A

  ; Split on newline (`n)
  StringSplit, word_array, full_path, `n

  ; Find and take the element from the array that contains address
  Loop, %word_array0%
  {
      IfInString, word_array%A_Index%, Address
      {
          full_path := word_array%A_Index%
          break
      }
  }

  ; strip to bare address
  full_path := RegExReplace(full_path, "^Address: ", "")

  ; Just in case - remove all carriage returns (`r)
  StringReplace, full_path, full_path, `r, , all

  return full_path
}

; Opens the Git bash shell in the File Explorer path.
OpenGbHere()
{
    full_path := GetCurrentPath()

    IfInString full_path, \
    {
        Run,  C:\Program Files\Git\git-bash.exe, %full_path%
    }
    else
    {
        Run, C:\Program Files\Git\git-bash.exe --cd-to-home
    }
}

Global CheckBranchRepo := "C:/repos/3/plain/phoenix"
; Create a file dump of all branches
CreateGitBranchFile(){
  ; Activate git bash
  Sleep, 500
  Seep("{LWin Down}{F2}{LWin Up}")

  ; Move to checkbranchrepo
  Seep("cd " . CheckBranchRepo . "{Enter}")

  ; fetch
  Seep("git fetch{Enter}", 6000)

  ; Output branches to file
  Seep("git branch -r > C:/Users/theeter/Desktop/branches.txt{Enter}", 2000)
}

; Read the file dump into a variable
ReadGitBranchesFromFile(){
  FileRead, vText, C:\Users\theeter\Desktop\branches.txt
  Branches := StrSplit(vText,"`n","`r")

  return Branches
}

Global Choice
Global Choose
; Load array into drop-down
ArrayToDropDown(items){
  list=
  For each, item in items{
    If(InStr(item,"feature/PHOEN-") And !InStr(item,"XXXX"))
      list .= (!list ? "" : "|") StrReplace(Trim(item),"origin/feature/PHOEN-","")
  }

  ; Sort in Reverse Order
  Sort, list, list, RD|  ; RD| => R = Reverse Order; D => Delimiter Character; | = delimiter character
  StringReplace, list, list, |, ||

  Gui, Add, DropDownList, w500 vChoice, %list%
  Gui, Add, Button, vChoose, Choose
  Gui, Show,,Branches

}
return
ButtonChoose:
  Gui, Submit
  Gui, Destroy
  Seep("{F6}")  ; switch to CMD
  Seep("cd " . CheckBranchRepo . "{Enter}")
  Seep("cd bin{Enter}")
  Seep("cmd /k checkbranch.bat -b feature/PHOEN-" . Choice . "{Enter}")
return
