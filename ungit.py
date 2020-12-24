#! /usr/bin/env python3

import os
import sys

def error(msg):
    print(msg)
    print(f"Usage: {sys.argv[0]} FILE.gitp8")
    print("  Converts FILE.gitp8 in merge-friendly format to FILE.p8 in pico-8 format.")
    sys.exit(1)

if len(sys.argv) < 2 or len(sys.argv) > 2:
    error("Exactly 1 argument required.")

if not os.path.exists(sys.argv[1]):
    error(f"{sys.argv[1]} does not exist.")

if not sys.argv[1].endswith(".gitp8"):
    error(f"{sys.argv[1]} does not have extension .gitp8")

fname=sys.argv[1]
base=fname.split(".gitp8")[0]
with open(fname, "r") as f:
    lines=f.read().splitlines()

labels = ["__lua__", "__gfx__", "__gff__", "__label__", "__map__", "__sfx__", "__music__"]
def get_segment(lines, label):
    segment=[]
    reading=False
    for line in lines:
        if line == label:
            reading=True
        elif line in labels:
            reading=False
        if reading:
            segment.append(line)
    return segment

def reserialize(lines, w, h, L):
    if not lines:
        return lines

    lbl = lines[0]
    lines = lines[1:]
    CW = L
    CH = len(lines)*w*h//L
    serialized = [['z' for _ in range(CW)] for __ in range(CH)]

    BW = CW // w
    BH = CH // h

    for i in range(len(lines)):
        bx = i % BW
        by = i // BW
        for dx in range(w):
            for dy in range(h):
                serialized[by*h+dy][bx*w+dx] = lines[i][dy*w+dx]
    serialized = ["".join(l) for l in serialized]
    return [lbl] + serialized

hdr = lines[:2]
lua = get_segment(lines, "__lua__")
gfx = get_segment(lines, "__gfx__")
gff = get_segment(lines, "__gff__")
lbl = get_segment(lines, "__label__")
map = get_segment(lines, "__map__")
sfx = get_segment(lines, "__sfx__")
msc = get_segment(lines, "__music__")

gfx = reserialize(gfx, 8, 8, 128)
gff = reserialize(gff, 2, 1, 256)
map = reserialize(map, 2, 1, 256)

if os.path.exists(base+".p8"):
    if input(f"{base}.p8 exists. Overwrite? (y/n) ") not in ["y", "Y"]:
        print("Aborted.")
        sys.exit(1)

with open(base+".p8", "w") as f:
    for lines in [hdr, lua, gfx, gff, lbl, map, sfx, msc]:
        if lines:
            f.write("\r\n".join(lines))
            f.write("\r\n")

