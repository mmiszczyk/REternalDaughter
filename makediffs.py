# I have modified the game .exe by directly changing assembly instructions in OllyDbg
# this script just turned those modifications into a small portable patch file and it isn't used anywhere during
# the execution of reternal.py

import bsdiff4

print("REternal Daughter patching utility")
print("==================================")
print()

print("Making upscale patch...")
# patch 1: this hooks the execution and updates resolution in memory
bsdiff4.file_diff("Eternal Daughter.exe", "fixres1.exe", "patch1")
print("Done!")
print()

print("Making pseudo hi-res patch...")
# patch 2: this changes the resolution only when the window is drawn;
#          as a result, the game isn't upscaled but you also don't get artifacts on smaller levels
bsdiff4.file_diff("Eternal Daughter.exe", "fixres2.exe", "patch2")
print("Done!")
print()

print("Making screen borders patch...")
# patch 3: like patch 2 but adds screen borders; unfortunately, they blink in a really annoying way;
#          requires compiled bmploader.dll and a 640x480 file 'img.bmp' that contains borders (white = transparent)
bsdiff4.file_diff("Eternal Daughter.exe", "fixres3.exe", "patch3")
print("Done!")
print()

print("Making windowed patch...")
# patch 4: this makes the game run in a window
bsdiff4.file_diff("Eternal Daughter.exe", "windowed.exe", "patch4")
print("Done!")
print()

print("Patching completed!")