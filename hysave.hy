;;;;;;;;;;;;;;;;;;;;;;;;;;
;       saveutil:        ;
;        part of         ;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;

(import argparse)

; TODO: actual logic, not just cmdline handling
; see this description of CNC Array format: http://community.clickteam.com/threads/41217-specs-for-CNC-ARRAY-format
; offset 0x1e: health
; offset 0x22: setting to 1 enables double jump, I don't think it does anything else
; offset 0x26: ?
; offset 0x2a: ?
; offset 0x2e: ?
; offset 0x32: ?
; offset 0x36: ?
; offest 0x3a: number of gems (ammo for secondary weapon)
; offest 0x3e: ?
; offest 0x42: setting to 1 unlocks hammer
; offest 0x46: ?
; offest 0x4a: ?
; offest 0x4e: ?
; offest 0x52: ?
; offest 0x56: max gems
; offest 0x5a: ?
; offest 0x5e: setting to 1 enables mojak
; offest 0x62: ?
; offest 0x66: ?
; offest 0x6a: ?
; offest 0x6e: ?
; offest 0x72: current weapon 1 - knife 2 - hammer 3 - mojak 4 - ozar 5 - sigil
; offest 0x74: ?
; offest 0x76: setting to 1 enables ozar
; offest 0x7a: setting to 1 makes erlanduru appear as savegame icon
; offest 0x7e: ?
; offest 0x82: ?
; offest 0x86: ?
; offest 0x8a: ?
; offest 0x8e: erlanduru: 0 - no, 1-3 - young, 4 - adult, 5 - adult with mask
; offest 0x92: ?
; offest 0x96: setting to 1 enables sigil
; offest 0xaa: attack power
; offest 0xc5: current position

;handle command line arguments
(setv parser (argparse.ArgumentParser
  :description "Eternal Daughter save reader/editor. Part of the REternal Daughter project"))
(.add_argument parser "slot" :help "Save slot number" :type int)
(.add_argument parser "-p" "--print" :action "store_true" :help "Print information about current savefile")
(.add_argument parser "-l" "--life" :help "Set life to provided value" :type int)
(.add_argument parser "-g" "--gems" :help "Set current number of gems (ammo)" :type int)
(.add_argument parser "-G" "--gems-max" :help "Set maximum number of gems" :type int)
(.add_argument parser "-L" "--location" :help "Teleport to chosen savespot" :type int)
(.add_argument parser "-a" "--attack-power" :help "Set attack power" :type int)
(.add_argument parser "-d" "--doublejump" :help "Enable/disable double jump" :type int :choices [0 1])
(.add_argument parser "-H" "--hammer" :help "Enable/disable hammer" :type int :choices [0 1])
(.add_argument parser "-M" "--mojak" :help "Enable/disable Mojak" :type int :choices [0 1])
(.add_argument parser "-O" "--ozar" :help "Enable/disable Ozar's Flame" :type int :choices [0 1])
(.add_argument parser "-S" "--sigil" :help "Enable/disable Sigil" :type int :choices [0 1])
(.add_argument parser "-W" "--weapon" :help "Current weapon" :type str
                                      :choices ["knife" "hammer" "mojak" "ozar" "sigil"])
(.add_argument parser "-e" "--erlanduru" :help "Pick Erlanduru's form (0 - no Erlanduru, 5 - adult Erlanduru with mask)"
                                         :type int :choices (range 0 6))
(setv arguments (.parse_args parser))