#!/bin/sh
# run_crtcheck.sh - check the Lua runtime's printf, strtod and sscanf against the system glibc: tools/crt/test/mkfmt.c
# writes about 1.4 million reference cases from glibc, test/crtcheck.lua replays them through swmm5/rt.lua in the
# Lua 5.4 that lupa embeds (the one runswmm uses) and counts the differences. The vectors go to a temporary folder
# and are deleted. Written by Claude (Anthropic) for Robert Dickinson; see ../README.md.
set -e
cd "$(dirname "$0")/.."
T=$(mktemp -d "${TMPDIR:-/tmp}/luacrt.XXXXXX")
gcc -O2 -o "$T/mkfmt" ../tools/crt/test/mkfmt.c -lm
"$T/mkfmt" > "$T/fmt.txt"
python3 -c 'import sys
from lupa import lua54
L = lua54.LuaRuntime(register_eval=False, register_builtins=False)
L.execute("assert(loadfile((...)))(select(2, ...))", sys.argv[1], sys.argv[2], sys.argv[3])' test/crtcheck.lua "$PWD/swmm5" "$T/fmt.txt"
rm -rf "$T"
