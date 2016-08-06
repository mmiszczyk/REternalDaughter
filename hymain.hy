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
(print "Fix by Maciej Miszczyk, 2016"))

;handle command line arguments
(setv parser (argparse.ArgumentParser
  :description "Unofficial Eternal Daughter resolution fix"))
(.add_argument parser "-i" "--input" :help "Input file (default: \"Eternal Daughter.exe\")")
(.add_argument parser "-u" "--upscale" :action "store_true"
                      :help "Upscale the game instead of just forcing higher resolution (experimental)")
(.add_argument parser "-p" "--patchfile" :help "Custom patchfile in BSDiff format (overrides -u)")
(.add_argument parser "-n" "--nofix" :action "store_true" :help "Don't fix the game, just run it (overrides -u and -p)")
(.add_argument parser "-r" "--replace" :action "store_true"
                      :help "Permanently replace input file with a patched version (overrides -n)")
(setv arguments (.parse_args parser))

(if arguments.upscale   (setv patchfile "patch1")             ; increase resolution and upscale
                        (setv patchfile "patch2"))            ; increase resolution but don't upscale
(if arguments.patchfile (setv patchfile arguments.patchfile)) ; custom patchfile

(if arguments.input (setv gamefile arguments.input)         ; custom gamefile
                    (setv gamefile "Eternal Daughter.exe")) ; default
(greet)
(if arguments.replace (replace-with-patch gamefile patchfile)                      ; replace with patch
                      (if arguments.nofix (subprocess.call gamefile)               ; just run
                                          (start-custom-game gamefile patchfile))) ; temporary patch (default)