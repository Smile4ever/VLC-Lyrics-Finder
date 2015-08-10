;Product Info
Name "Lyrics Finder"
!define PRODUCT "Lyrics Finder"
!define VERSION "0.3.2"
!include "MUI.nsh"

;--------------------------------
;Configuration
OutFile "..\lyricsfinder-${VERSION}.exe"
BRANDINGTEXT "Hugsmile.eu"

;Compression
SetCompress Auto
SetCompressorDictSize 32
SetDatablockOptimize On

;Remember install folder
InstallDirRegKey HKCU "Software\${PRODUCT}" ""

;--------------------------------
; Welcome page
!insertmacro MUI_PAGE_WELCOME
;License file
;!insertmacro MUI_PAGE_LICENSE "EULA.txt"
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH
;!insertmacro GetParent

!define MUI_ABORTWARNING

;Language
!insertmacro MUI_LANGUAGE "English"
     
Section "section_1" section_1

  SetOverwrite try
  SetOutPath "$PROGRAMFILES\VideoLAN\VLC\lua\extensions\"
  File "..\lyricsfinder.lua"
  SetOutPath "$PROGRAMFILES\VideoLAN\VLC\lua\extensions\lyricsfinder\locale"
  File /r /x Template "..\locale\"

SectionEnd

Section Uninstaller
  !define ARP "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder"
  !include "FileFunc.nsh"
 
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "DisplayName" "${PRODUCT} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "URLInfoAbout" "https://github.com/Smile4ever/VLC-Lyrics-Finder"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "Publisher" "Hugsmile"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "DisplayIcon" "$PROGRAMFILES\VideoLAN\VLC\vlc.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "UninstallString" "$PROGRAMFILES\VideoLAN\VLC\lua\extensions\lyricsfinder\Uninst.exe"
  ;WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "HelpLink"
  WriteRegStr HKCU "Software\${PRODUCT}" "" "$PROGRAMFILES\Lyrics Finder\"

 ${GetSize} "$PROGRAMFILES\VideoLAN\VLC\lua\extensions\lyricsfinder\" "/S=0K" $0 $1 $2
 IntFmt $0 "0x%08X" $0
 WriteRegDWORD HKLM "${ARP}" "EstimatedSize" "$0"
  
  WriteUninstaller "$PROGRAMFILES\VideoLAN\VLC\lua\extensions\lyricsfinder\Uninst.exe"
SectionEnd
 
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer.."
FunctionEnd
  
Function un.onInit 
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
    Abort
FunctionEnd
 
Section "Uninstall"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Lyrics Finder"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder"
     
  SetOverwrite try
  ;Delete "$DESKTOP\desktop.lnk"
  RMDir /r "$PROGRAMFILES\VideoLAN\VLC\lua\extensions\lyricsfinder\"
  Delete "$PROGRAMFILES\VideoLAN\VLC\lua\extensions\lyricsfinder.lua"
  
SectionEnd

Function .onInstSuccess
   ;CreateShortCut "$DESKTOP\desktop.lnk" "$PROGRAMFILES\VideoLAN\VLC\vlc.exe" "" "$PROGRAMFILES\VideoLAN\VLC\vlc.exe"
   ExecShell open "$PROGRAMFILES\VideoLAN\VLC\vlc.exe"
FunctionEnd

;eof