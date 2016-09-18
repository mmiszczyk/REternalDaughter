;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        ;
;    REternal Daughter   ;
;                        ;
;     copyright 2016     ;
;   by Maciej Miszczyk   ;
;                        ;
;  this program is free  ;
;           and          ;
;  open source software  ;
; released under GNU GPL ;
;    (see COPYING for    ;
;    further details)    ;
;                        ;
;  requires a copy of    ;
;  Blackeye Software's   ;
;    Eternal Daughter    ;
; (available as freeware ;
;          from          ;
; derekyu.com/games.html);
;;;;;;;;;;;;;;;;;;;;;;;;;;

;TODO: windowed mode, fix upscaling, maybe also upscale by stretching

(import bsdiff4 subprocess os argparse shutil)

(defn replace-with-patch [gamepath patchpath]
  (shutil.copy2 gamepath (+ gamepath ".bak"))
  (bsdiff4.file_patch_inplace gamepath patchpath))

(defn start-custom-game [gamepath patchpath]
  (bsdiff4.file_patch gamepath "temp.exe" patchpath)
  (subprocess.call "temp.exe")
  (os.remove "temp.exe"))

; ASCII art generated with http://patorjk.com/software/taag/
; fonts used: Cyberlarge ("R"), Invita ("Eternal Daughter")
(defn greet[]
  (print"
         _____)
______    /                          /)
|_____/   )__   _/_  _  __ __   _   //
|    \_ /       (___(/_/ (_/ (_(_(_(/_
      (_____)
   ______
  (, /    )            /)
    /    / _       _  (/  _/_  _  __
  _/___ /_(_(_(_(_(_/_/ )_(___(/_/ (_
(_/___ /         .-/
                (_/
")
(print "Eternal Daughter by Blackeye Software, 2002")
(print "Fix by Maciej Miszczyk, 2016")
(print "Screen border image originally by Igor")
(print "Special thanks to Mastigophoran (original windowed mode fix), Andoryuuta (help with border-drawing patch)")
(print "and Azurinel (help with windowed mode fix)."))

;handle command line arguments
(setv parser (argparse.ArgumentParser
  :description "Unofficial Eternal Daughter patch. Default settings work if placed in the game's folder."
  :epilog      "Without other arguments, the game will be started in windowed mode."))
(.add_argument parser "-i" "--input" :help "Input file (default: \"Eternal Daughter.exe\")")
(.add_argument parser "-u" "--upscale" :action "store_true"
                      :help "Upscale the game (experimental)")
(.add_argument parser "-b" "--borders" :action "store_true"
                      :help "High resolution with screen borders (experimental; overrides -u)")
(.add_argument parser "--noborders" :action "store_true" :help "Just force higher resolution (overrides -u and -b)")
(.add_argument parser "-p" "--patchfile" :help "Custom patchfile in BSDiff format (overrides -u, -b and --noborders)")
(.add_argument parser "-n" "--nofix" :action "store_true"
                      :help "Don't fix the game, just run it (overrides -u, -b, --noborders and -p)")
(.add_argument parser "-r" "--replace" :action "store_true"
                      :help "Permanently replace input file with a patched version (overrides -n)")
(.add_argument parser "-c" "--cncs232" :action "store_true" :help "Fix Cncs232.dll (you should only run this once)")
(setv arguments (.parse_args parser))


(cond [arguments.patchfile     (setv patchfile arguments.patchfile)] ; custom patchfile
      [arguments.noborders     (setv patchfile "patch2")]            ; increase resolution but don't upscale
      [arguments.borders       (setv patchfile "patch3")]            ; increase, don't upscale, draw borders
      [arguments.upscale       (setv patchfile "patch1")]            ; increase resolution and upscale
      [True                    (setv patchfile "patch4")])           ; windowed mode (default)

(if arguments.input (setv gamefile arguments.input)         ; custom gamefile
                    (setv gamefile "Eternal Daughter.exe")) ; default
(greet)

(if arguments.cncs232 (replace-with-patch "Cncs232.dll" "cncs-patch")) ; fix Cncs232

(if arguments.replace (replace-with-patch gamefile patchfile)                      ; replace with patch
                      (if arguments.nofix (subprocess.call gamefile)               ; just run
                                          (start-custom-game gamefile patchfile))) ; temporary patch (default)