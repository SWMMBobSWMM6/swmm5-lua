#!/bin/bash
# make_glibm.sh [GIMPLE_DIR TABLES_JSON]
# Regenerate swmm5/glibm.lua, the Lua translation of glibc 2.39's pow and atan (the FMA variants EPA's runswmm runs
# on x86-64), with tools/libm/gim2x.py's Lua back end, and copy its hand-written runtime tools/libm/glibm_rt.lua
# beside it. Only these two: the Lua port calls glibc itself (Lua's math library) for every other function, and
# needs glibc's pow only where Lua's ^ does not call it (y == 2) and atan, which Lua does not offer. The GIMPLE dumps
# and the constant tables come from tools/libm/build_glibm.sh and extract_tables.py (tools/libm/make_libm.sh runs
# both; they compile glibc's sources, they never run them); the default is the build kept at
# /home/claude/ext/glibm_build. Written by Claude (Anthropic) for Robert Dickinson; see README.md.
set -e
HERE=$(cd "$(dirname "$0")" && pwd); ROOT=$(cd "$HERE/.." && pwd)
G=${1:-/home/claude/ext/glibm_build/gimple}; T=${2:-/home/claude/ext/glibm_build/tables.json}
python3 "$ROOT/tools/libm/gim2x.py" lua "$HERE/swmm5/glibm.lua" $G/e_pow.c.254t.optimized $G/s_atan.c.254t.optimized \
    --tables "$T" --name my_pow=pow --name my_atan=atan
cp "$ROOT/tools/libm/glibm_rt.lua" "$HERE/swmm5/glibm_rt.lua"
