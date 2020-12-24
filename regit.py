#! /usr/bin/env python3

import os
import sys

def error(msg):
    print(msg)
    print(f"Usage: {sys.argv[0]} FILE.p8")
    print("  Converts FILE.p8 in pico-8 format to FILE.gitp8 in merge-friendly format.")
    sys.exit(1)

if len(sys.argv) < 2 or len(sys.argv) > 2:
    error("Exactly 1 argument required.")

if not os.path.exists(sys.argv[1]):
    error(f"{sys.argv[1]} does not exist.")

if not sys.argv[1].endswith(".p8"):
    error(f"{sys.argv[1]} does not have extension .p8")

fname=sys.argv[1]
base=fname.split(".p8")[0]
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

def break_into(lines, w, h):
    if not lines:
        return lines

    lbl = lines[0]
    lines = lines[1:]
    blocks = []
    y = 0
    while y+h <= len(lines):
        x = 0
        while x+w <= len(lines[y]):
            block = ""
            for by in range(h):
                block += lines[y+by][x:x+w]
            blocks.append(block)
            x+=w
        y+=h
    return [lbl] + blocks

hdr = lines[:2]
lua = get_segment(lines, "__lua__")
gfx = get_segment(lines, "__gfx__")
gff = get_segment(lines, "__gff__")
lbl = get_segment(lines, "__label__")
map = get_segment(lines, "__map__")
sfx = get_segment(lines, "__sfx__")
msc = get_segment(lines, "__music__")

gfx = break_into(gfx, 8, 8)
gff = break_into(gff, 2, 1)
map = break_into(map, 2, 1)

if os.path.exists(base+".gitp8"):
    if input(f"{base}.gitp8 exists. Overwrite? (y/n) ") not in ["y", "Y"]:
        print("Aborted.")
        sys.exit(1)

with open(base+".gitp8", "w") as f:
    for lines in [hdr, lua, gfx, gff, lbl, map, sfx, msc]:
        if lines:
            f.write("\r\n".join(lines))
            f.write("\r\n")

