; Git Bash Utilities
; The git bash script was too big, so I moved all the functions here

#Include C:\ahk_scripts\ahk_utils\ahk_functions.ahk

; Global Variables
Global CheckBranchRepo := check_branch_repo
Global Choice
Global Choose

ActivateGitBash(){
  If !WinExist("ahk_exe mintty.exe")
    OpenGbHere()
  Else If WinActive("ahk_exe mintty.exe")
    WinMinimize
  Else
    WinActivate, ahk_exe mintty.exe
}

; Create a file dump of all branches. To be used with Checkbranch.
CB_CreateGitBranchFile(){
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

; Deletes any branches created from checkBranch
CB_DeleteFeatures(){
  Seep("{F4}")
  Crest(47,422,500)
  Seep("^l")
  Seep("{Tab 3}")
  Seep("^a")
  Seep("+{Del}")
}

; Allow user to select which branch to run checkBranch on
CB_SelectCheckBranch(){
  FileRead, vText, C:\Users\theeter\Desktop\branches.txt
  Branches := StrSplit(vText,"`n","`r")
  Branch := ArrayToDropDown(Branches)
}

; Clone the repo.
CloneRepo(){
  if(!IsSet(repo_address)){
    MsgBox, 16, git_bash_utils.ahk - CloneAndFlow, You need to create a Windows Environment Variable called "repo_address" and set it to the repo addres, ending in .git.
    return
  }
  ; Close git bash if it's open
  If WinExist("ahk_exe mintty.exe")
    WinClose, "ahk_exe mintty.exe"
  Sleep, 1000

  ; Switch to File Exp so we can open GB to that location
  WinActivate, ahk_class CabinetWClass
  Sleep, 1000

  ; Open GB to correct location
  OpenGbHere()
  Sleep, 2000

  ; Activate the gb window to perform clone and flow commands
  WinActivate, ahk_exe mintty.exe
  Sleep, 1000

  ; Maximize the window
  WinMaximize, ahk_exe mintty.exe
  Sleep, 1000

  ; Clone Phoenix
  Seep("git clone " . repo_address . "{Enter}",20000)
}

; Clone the repo and create the flow branch (current File Explorer Path)
CloneAndFlow(){
  CloneRepo()

  ; Run flow stuff
  Seep("c:/newFlowBranch.bat{Enter}", 20000)

  ; Change dir so you can confirm the correctness of flow
  Seep("cd phoenix/{Enter}")

  ; Close All CMD windows
  CloseAllCMDs()

  ; re-run cmd_script.ahk
  Rescript()

  ; Rebuild with the new clone
  Seep("!p")
}

; Clone the repo and checkout the branch (current File Explorer Path)
CloneAndCheckout(){
  p := StrReplace(GetCurrentPath(),repo_path)
  CloneRepo()

  Seep("cd phoenix/{Enter}")
  Seep("git checkout feature/PHOEN-" . p . "{Enter}", 12000)
  ChangeCRNT(repo_path . p . "\phoenix")
}

; Change the crnt env variable to the current file explorer path
ChangeCRNT(p:=""){
  ; If the new crnt value isn't sent in, get it from the active Explorer Window
  If(p = "")
    p := GetCurrentPath()
  Sleep, 2000
  If(p = "")
    return

  CloseAllCMDs()
  CmndToC()

  Seep("SET crnt=" . p . "{Enter}")
  Seep("SETX crnt " . p . "{Enter}")

  CloseAllCMDs()
  Sleep, 1000
  Rescript()

  Seep("!p")
}

; Gets the current path from a file explorer window.
GetCurrentPath(){
  If !WinActive("ahk_class CabinetWClass"){
    MsgBox, File Explorer is not active. Please open a file explorer window and navigate to a phoenix folder.
    return
  }
  ; This is required to get the full path of the file from the address bar
  WinGetText, full_path, A

  ; Split on newline (`n)
  StringSplit, word_array, full_path, `n

  ; Find and take the element from the array that contains address
  Loop, %word_array0%
  {
    IfInString, word_array%A_Index%, Address
    {  ; Do not try to move this up, will cause obscure error: "Return's parameter should be left blank..."
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
OpenGbHere(){
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

return ; Ends functions - do not erase

ButtonChoose:
  Gui, Submit
  Gui, Destroy
  Seep("{F6}")  ; switch to CMD
  Seep("cd " . CheckBranchRepo . "{Enter}")
  Seep("cd bin{Enter}")
  Seep("cmd /k checkbranch.bat -b feature/PHOEN-" . Choice . "{Enter}")
return
