;Product Info
Name "VLC Lyrics Finder"
!define PRODUCT "VLC Lyrics Finder"
!define VERSION "0.3.4.1"
!include "MUI.nsh"
!include x64.nsh

;--------------------------------
;Configuration
OutFile "..\lyricsfinder-${VERSION}.exe"
BRANDINGTEXT "Hugsmile.eu"

;Compression
SetCompressor lzma
;SetCompress auto
SetCompressorDictSize 32
SetDatablockOptimize On

;Remember install folder
InstallDirRegKey HKLM "Software\${PRODUCT}" ""
Var PROG3264

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
	
	${If} ${RunningX64}
	   SetRegView 64
	   StrCpy $PROG3264 "$PROGRAMFILES64"
	${Else}
	   StrCpy $PROG3264 "$PROGRAMFILES32"
	${EndIf}
	StrCpy $INSTDIR "$PROG3264\VideoLAN\VLC\lua\extensions\"

  SetOverwrite try
  SetOutPath "$INSTDIR"
  File "..\lyricsfinder.lua"
  SetOutPath "$INSTDIR\lyricsfinder\locale"
  File /r /x Template "..\locale\"

SectionEnd

Section Uninstaller
  !define ARP "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder"
  !include "FileFunc.nsh"
 
 	${If} ${RunningX64}
	   SetRegView 64
	   StrCpy $PROG3264 "$PROGRAMFILES64"
	${Else}
	   StrCpy $PROG3264 "$PROGRAMFILES32"
	${EndIf}
	StrCpy $INSTDIR "$PROG3264\VideoLAN\VLC\lua\extensions\"
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "DisplayName" "${PRODUCT} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "URLInfoAbout" "https://github.com/Smile4ever/VLC-Lyrics-Finder"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "Publisher" "Hugsmile"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "DisplayIcon" "$PROG3264\VideoLAN\VLC\vlc.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "UninstallString" "$PROG3264\VideoLAN\VLC\lua\extensions\lyricsfinder\Uninst.exe"
  ;WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder" "HelpLink"
  WriteRegStr HKLM "Software\${PRODUCT}" "" "$INSTDIR\lyricsfinder\"

 ${GetSize} "$INSTDIR\lyricsfinder\" "/S=0K" $0 $1 $2
 IntFmt $0 "0x%08X" $0
 WriteRegDWORD HKLM "${ARP}" "EstimatedSize" "$0"
  
  WriteUninstaller "$INSTDIR\lyricsfinder\Uninst.exe"
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
 
    
  ${If} ${RunningX64}
	   SetRegView 64
	   StrCpy $PROG3264 "$PROGRAMFILES64"
  ${Else}
	   StrCpy $PROG3264 "$PROGRAMFILES32"
  ${EndIf}
  StrCpy $INSTDIR "$PROG3264\VideoLAN\VLC\lua\extensions\"
  
  DeleteRegKey HKEY_LOCAL_MACHINE "Software\Lyrics Finder"
  DeleteRegKey HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lyrics Finder"
  
  SetOverwrite try
  RMDir /r "$PROG3264\VideoLAN\VLC\lua\extensions\lyricsfinder\"
  Delete "$PROG3264\VideoLAN\VLC\lua\extensions\lyricsfinder.lua"
  
SectionEnd

Function .onInstSuccess
   ;CreateShortCut "$DESKTOP\desktop.lnk" "$PROGRAMFILES\VideoLAN\VLC\vlc.exe" "" "$PROGRAMFILES\VideoLAN\VLC\vlc.exe"
   
   ${If} ${RunningX64}
	 ExecShell open "$PROG3264\VideoLAN\VLC\vlc.exe"
   ${Else}
     ExecShell open "$PROG3264\VideoLAN\VLC\vlc.exe"
   ${EndIf}
FunctionEnd

;eof