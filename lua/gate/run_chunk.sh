#!/bin/bash
# run_chunk.sh NAME IDS_FILE [WAIT_SECONDS [ENGINE]] - one gate run of the Lua port on a chunk of the corpus:
#   python3 gate/gate.py NAME "lua/runswmm_saves.sh" --ids IDS -j 1 --timeout 1800 --prune
# inside flock on the shared corpus lock (waiting at most WAIT_SECONDS, default 3600, for it; ENGINE replaces
# lua/runswmm_saves.sh, e.g. with a clean checkout's wrapper for the independent rerun), with the results
# folder in /dev/shm (lessons/22). Afterwards the outputs of any failing model are copied to gate/results/NAME on
# disk (evidence, lessons/15) and the memory copy removed. The log is gate/NAME_run.txt; the start and end times
# go to lua/gate/NAME_times.txt. Written by Claude (Anthropic) for Robert Dickinson; see ../README.md.
set -u
NAME=$1; IDS=$(cd "$(dirname "$2")" && pwd)/$(basename "$2"); WAIT=${3:-3600}
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
ENGINE=${4:-$ROOT/lua/runswmm_saves.sh}
LOCK=${SWMM_GATE_LOCK:-${TMPDIR:-/tmp}/swmm5-gate.lock}  # one corpus run at a time
cd "$ROOT/gate"
M=/dev/shm/gate_$NAME
rm -rf "$M" && mkdir -p "$M"
[ -e "results/$NAME" ] && rm -rf "results/$NAME"
ln -s "$M" "results/$NAME"
echo "queued $(date -Is)" > "$ROOT/lua/gate/${NAME}_times.txt"
TMPDIR=/dev/shm flock -w "$WAIT" "$LOCK" bash -c "echo \"started \$(date -Is)\" >> '$ROOT/lua/gate/${NAME}_times.txt'; \
  nice -n 10 python3 gate.py '$NAME' '$ENGINE' --ids '$IDS' -j 1 --timeout 1800 --prune" > "${NAME}_run.txt" 2>&1
rc=$?
echo "ended $(date -Is) rc=$rc" >> "$ROOT/lua/gate/${NAME}_times.txt"
rm "results/$NAME"
mkdir -p "results/$NAME"
cp -a "$M"/. "results/$NAME"/ 2>/dev/null
rmdir "results/$NAME" 2>/dev/null
rm -rf "$M"
tail -4 "${NAME}_run.txt"
