; atom functions

#Include C:\ahk_scripts\ahk_utils\Functions.ahk

commentOut(start,end:=""){
  ; Go to the line that starts commented out part
  goTo(start)

  ; Enter the start of the comment
  Send, <{!}--
  Sleep, 500

  ; If end is defined, go to that line. Otherwise, assume we're just commenting out one line
  If(end)
    goTo(end)

  ; Go to the end of the line and enter the ending comment
  Send, {End}
  Send, -- ; Atom will autofill the ending comment
  Sleep, 1000
}

CommentPOMs(){
  ; Make sure Atom is active
  Seep("{F3}")

  ; Navigate to the Open Folder Dialog
  Seep("^+o")

  ; Navigate to the current project folder
  Seep("^l")
  Seep(crnt)
  Seep("{Enter}")

  ; Tab to the "Select Folder Button"
;  Send, {Tab 7}
;  Sleep, 1000
;  Send, {Enter}
;  Sleep, 5000
;
;  ; Open Fuzzy Find
;  Send, ^p
;  Sleep, 3000
;
;  ; Open the normal POM file
;  Send, pom
;  Sleep, 1000
;  Send, {Enter}
;  Sleep, 1000
;
;  commentOut(61)
;  commentOut(64,66)
;
;  Send, ^s
;  Sleep, 1000
;
;  ; =========== 2nd POM FIle ===========
;  ; Open Fuzzy Find
;  Send, ^p
;  Sleep, 1000
;  Send, pom
;  Sleep, 1000
;
;  ; Open the common POM
;  Send, {Down 4}
;  Sleep, 1000
;  Send, {Enter}
;  Sleep, 1000
;
;  commentOut(19,20)
;
;  Send, ^s
}

goTo(lineNumber){
  Send, ^g
  Sleep, 500
  Send, %lineNumber%
  Sleep, 500
  Send, {Enter}
  Sleep, 500
}
