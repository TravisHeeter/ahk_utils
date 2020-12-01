#Include C:\ahk_scripts\ahk_utils\Functions.ahk

; Used in Tester Sometimes
CreateNewCase(){
  ;Crest(2350,218) ; New case button
  Crest(524,558)  ; Incident date input
  Seep("{Enter}") ; Accept default datetime
  Crest(1100,800) ; Incident desc
  FormatTime, dt,, dd-MM-yy HH:mm:ss
  crntvar:=crnt
  ttp:="Testing " crntvar " - " dt
  Seep(ttp)       ; Incident desc
  Seep("{Tab 4}{Enter}{Down 1}{Enter}") ; Responsible Org
  Seep("{Tab 3}{Enter}{Down 1}{Enter}") ; Triage Level
  Seep("{Tab}{Esc}{Tab}{Esc}{Tab}{Tab}Testing") ; Actions to Date
  Seep("{Tab 19}{Enter}") ; Report Thresholds
  Seep("{Tab 20}Richmond") ; City
  Seep("{Tab}v") ; State
  Seep("{Tab 3}{Enter}", 3000) ; Lookup Person Button
  Seep("{Tab}H") ; Last name
  Seep("{Down}{Enter}") ; Autofill name
  Seep("{Tab 2}{Enter}", 6000) ; Find Person
  Crest(1244,494) ; Click to normalize tab distance
  Seep("{Tab 1}{Enter}", 2000) ; Select First Person
  Seep("{Tab 7}{Enter}") ; Accept Person
}

FillSsnDod(){
  Seep("{Tab}")        ; highlight ssn input
  Seep(FakeSSN)  ; enter user's fake ssn
  Seep("{Tab}")        ; highlight dod number input
  Seep(FakeNum)   ; enter fake dod number
  Seep("{Tab 2}")      ; highlight Confirm Button
  Seep("{Enter}")      ; Confirm and close modal
}

; { Open a new Chrome incognito window, navigate to phoenix
LaunchSite(User:="DMAnalyst",Screen:="Full"){
  ; Try to activate Site
  SetTitleMatchMode, 2  ; Contains
  WinActivate, DSOS 3.0
  Sleep, 1000

  ; If there is already a window, close it.
  If WinActive(DSOS 3.0) {
   WinClose
   ; Refresh the page
   ;Send, {F5}
   ;Sleep, 6800
  } ;Else {

  ; Open a new incognito window to phoenix
  Run, %ChromeEXE% -incognito https://localhost:8081/phoenix/
  Sleep, 2000

  SelectUser(User)

  ; Maximize the window
  Sleep, 1000
  WinActivate, DSOS 3.0
  Sleep, 1000
  WinMaximize, DSOS 3.0
  Sleep, 4000

  ; Open dev tools
  Send {F12}
  Sleep, 3000

  LoginSequence(7000,Screen,false)
  Tester()
}

LaunchTimesheet(){
  ; Open the timesheet in a new tab
  NewTab(timesheet_url)

  Sleep, 3000

  ; Click Login to go to Novetta login page
  Crest(923,758,3000)

  ; On the Novetta Login page - username should already be filled out,
  ; click the password input box.
  Crest(1179,747)

  ; Clicking the passowrd input box should bring up an auto-login option,
  ; click the option to autofill passowrd.
  Crest(1216,789)

  ; Click the sign-in button
  Crest(1287,846)

  ; Click the Answer input box
  Crest(1289,658)
  Send, %NovettaSecond%

  ; Click confirm
  Crest(1201,737)
}

; ===================================================
; LoginSequence
; Used to click login, scroll down, then the consent button, this is what you need to do each time Phoenix is reloaded
; Opperates for different browser sizes:
  ; Full (default), which is the monitor's normal size;
  ; Small, which is 1440x990;
  ; Laptop, which is the laptop screen size - but that hasn't been coded yet.
  ; Windowed : The Screen is full, but the browser window is inthe upper-righ t corner of the screen
; ===================================================
LoginSequence(Rest:=2000,Screen:="Full",DockedDevTools:="true"){
  ; When the app starts after a full reload, it takes a little longer.
  WinActivate, DSOS 3.0
  Sleep, %Rest%

  ; X,Y coordinates for the FULL sized monitor screen
  LoginCoords := [2491,156]    ; x,y coords of the login button
  ConsentCoords := [1254,809]  ; coords of the consent button when chome dev tools are docked in the lower part of the browser

  if(DockedDevTools = "false")
    ConsentCoords := [1239,918]

  If(Screen == "Small"){
    LoginCoords := [1513,186]
    ConsentCoords := [758,715]
  }Else If(Screen == "Laptop"){
    LoginCoords := [1513,186]
    ConsentCoords := [758,715]
  }Else If(Screen == "Windowed"){
    LoginCoords := [1200,180]
    ConsentCoords := [600,800]
  }Else If(Screen == "Quarter"){
    LoginCoords := [1200,184]
    ConsentCoords := [602,519]
  }Else If(Screen != "Full"){
    WrongParameter("Screen", "LoginSequence", "chrome_script", Screen, ["Full", "Small", "Laptop"])
    return
  }

  Crest(LoginCoords,,3000)
  Send, {WheelDown 10}
  Sleep, 2000
  Crest(ConsentCoords)
}

NewTab(url, Rest:=1000, incognito:=false, Executable:="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"){ ;{ Open a new tab to the url
  If(incognito = "false")
    Run, %Executable% %url%
  Else
    Run, %Executable% %url% -%incognito%
  Sleep, %Rest%
  Send, ^0  ; if you've zoomed in previously, Chrome remembers and it will mess up the button click locations
}

; ===================================================
; Select the user from the Certs Drop-Down
; Attn: if you add certs, you may need to change the order
; This is aligned with the user selection when you first visit the site
; ===================================================
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

ChromeStartup(){
  ; Open Chrome, wait for loading, maximize window
  NewTab("https://mail.google.com")
  WinMaximize

  ; =========================================================================
    ; MATTERMOST
  ; -------------------------------------------------------------------------
    NewTab(MMurl)
    ; No need to login, you're auto-logged in unless something went wrong.

  ; =========================================================================
    ; JIRA
  ; -------------------------------------------------------------------------
    NewTab(JiraUrl)

    ; Click on the login input
    Crest(1533,329)

    ; Activate the autofill
    Seep("t")

    Crest(1568,381)      ; Autofill Credentials
    Crest(1562,496,2000) ; Login Button
    Crest(434,152,3000)  ; Projects Drop-down
    Crest(434,238,2000)  ; PHOEN Project

  ; =========================================================================
    ; GIT LAB
  ; -------------------------------------------------------------------------
    NewTab("http://gitlab.dev.ditmac.mil/",3000)

    Crest(1764,269)  ; Close Message
    Crest(1558,334)  ; Standard login
    Crest(1432,415)  ; Username
    Crest(1444,469)  ; Credentials
    Crest(1562,590,3000)  ; Login Button
    Crest(809,370)   ; Project


  ; =========================================================================
    ; NOVETTA GMAIL
  ; -------------------------------------------------------------------------
    ; Ctrl + One activates the first tab, Gmail
    Send ^1
    Sleep, 3000

    ; Flash Support Warning dismissal - only happens on first launch after system reset
    ;Click, 2545, 139
    ;Sleep, 1000

    Crest(2529,151,2000)  ; Account Icon
    Crest(2222,460,2000)  ; theeter@novetta.com


  ; =========================================================================
    ; WORK DRIVE FOLDER & COMMON
  ; -------------------------------------------------------------------------
    newTab(DriveUrl)
    newTab(CommonUrl)
}

; Tests comomn scenarios, built in to existing scripts.
Tester(Screen:="Full"){

  ; Create New Case, stop at Cac Options
  ;Crest(2353,217)
  ;Crest(2100,462)

  ; Create New Case, Fill Form
  ;CreateNewCase()


  ; ===========================================
  ; Go To First Case
  ;if(Screen = "Full"){
    ;; Crest(449,230) ; Cases
    ;Crest(525,225) ; RFIs
    ;; Crest(587,486) ; Click the Case
    ;; Crest(256,440) ; Click the RFI
  ;} Else If(Screen = "Windowed"){
    ;;Crest(233,168)  ; Cases
    ;;Crest(367,406)  ; First Case
  ;} Else If(Screen = "Quarter"){
  ;} Else
    ;Crest(400,228)
  ; ==========================================

  ; Go to the workbook section
  ;Send, {WheelDown 10}
  ;CreateNewCase()
}
