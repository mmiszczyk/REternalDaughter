rem ;;;;;;;;;;;;;;;;;;;;;;;;;;
rem ;                        ;
rem ;    REternal Daughter   ;
rem ;                        ;
rem ;     copyright 2016     ;
rem ;   by Maciej Miszczyk   ;
rem ;                        ;
rem ;  this program is free  ;
rem ;           and          ;
rem ;  open source software  ;
rem ; released under GNU GPL ;
rem ;    (see COPYING for    ;
rem ;    further details)    ;
rem ;                        ;
rem ;  requires a copy of    ;
rem ;  Blackeye Software's   ;
rem ;    Eternal Daughter    ;
rem ; (available as freeware ;
rem ;          from          ;
rem ; derekyu.com/games.html);
rem ;;;;;;;;;;;;;;;;;;;;;;;;;;

rem Launcher for pre-patched release version
rem This requires a lot of executables but I'm not feeling like writing a C-based patcher right now
rem If you really need to save those few megabytes, get the source codes

@echo off
title REternal Daughter v 1.0.0
cls

cd bin

:greet
rem ASCII art greeter
rem this looks misaligned in code but that's just escape sequences
echo          _____)
echo ______    /                          /)
echo ^|_____/   )__   _/_  _  __ __   _   //
echo ^|    \_ /       (___(/_/ (_/ (_(_(_(/_
echo       (_____)
echo    ______
echo   (, /    )            /)
echo     /    / _       _  (/  _/_  _  __
echo   _/___ /_(_(_(_(_(_/_/ )_(___(/_/ (_
echo (_/___ /         .-/
echo                 (_/
echo Eternal Daughter by Blackeye Software, 2002
echo Fix by Maciej Miszczyk, 2016
echo Screen border image originally by Igor
echo Special thanks to Mastigophoran (original windowed mode fix), Andoryuuta (help with border-drawing patch)
echo and Azurinel (help with windowed mode fix).
echo.
echo.

:menu
echo Select game mode:
echo =================
echo.
echo 1. Windowed (recommended)
echo 2. Pseudo-fullscreen
echo 3. Fullscreen with screen borders (experimental)
echo 4. Upscaled fullscreen (experimental)
echo 5. 320x240 fullscreen (no fix)
echo X. Quit
echo.

:choice
set /p option=Your choice:
if "%option%"=="1" call windowed.exe
if "%option%"=="2" call fixres2.exe
if "%option%"=="3" call fixres3.exe
if "%option%"=="4" call fixres1.exe
if "%option%"=="5" call nofix.exe
if "%option%"=="X" goto quit

:quit
cd ..
cls
exit