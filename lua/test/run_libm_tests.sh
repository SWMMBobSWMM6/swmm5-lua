#!/bin/bash
# run_libm_tests.sh [N]
# Check the math the Lua engine calls against the system libm (the library EPA's runswmm calls), bit for bit, NaN
# payloads and signs included: N random arguments per function over SWMM's ranges plus special values
# (tools/libm/test/mkvectors.c), an edge-case set (mkedge.c), and the exact functions and C casts (test/mkexact.c), all
# replayed by test/libmcheck.lua in the Lua 5.4 that lupa embeds. The vectors (about 260 MB at N = 1000000) go to
# LUA_LIBM_WORK (default ../build/lua_libm_test) and are deleted. Written by Claude (Anthropic) for Robert
# Dickinson; see ../README.md.
set -e
HERE=$(cd "$(dirname "$0")" && pwd); P=$(cd "$HERE/.." && pwd); ROOT=$(cd "$P/.." && pwd)
N=${1:-1000000}; W=${LUA_LIBM_WORK:-$ROOT/build/lua_libm_test}; rm -rf "$W"; mkdir -p "$W"
gcc -O2 -o "$W/mkvectors" "$ROOT/tools/libm/test/mkvectors.c" -lm
gcc -O2 -o "$W/mkedge" "$ROOT/tools/libm/test/mkedge.c" -lm
gcc -O2 -fno-builtin -o "$W/mkexact" "$HERE/mkexact.c" -lm
"$W/mkvectors" "$N" "$W/vectors.bin" > /dev/null
"$W/mkedge" 100000 "$W/edge.bin" > /dev/null
"$W/mkexact" "$N" "$W/exact.bin" 2> /dev/null > /dev/null
run() { python3 -c 'import sys
from lupa import lua54
L = lua54.LuaRuntime(register_eval=False, register_builtins=False)
L.execute("assert(loadfile((...)))(select(2, ...))", sys.argv[1], sys.argv[2], sys.argv[3])' "$HERE/libmcheck.lua" "$P/swmm5" "$1"; }
echo "== Lua $(python3 -c 'from lupa import lua54; print(lua54.LuaRuntime().eval("_VERSION"))') (lupa $(python3 -c 'import lupa; print(lupa.__version__)')): vectors.bin (N = $N per function)"
run "$W/vectors.bin"
echo "== edge.bin"
run "$W/edge.bin"
echo "== exact.bin (N = $N per function)"
run "$W/exact.bin"
rm -rf "$W"
