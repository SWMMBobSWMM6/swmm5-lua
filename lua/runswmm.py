#!/usr/bin/env python3
"""runswmm.py - the Lua port's launcher: starts a Lua 5.4 state (lupa's LuaRuntime, with Python's builtins and
eval kept out of it) and calls swmm5/main.lua with the command line and the working directory (realpath() needs it,
and Lua has no getcwd); the engine and its runtime are all Lua.
    lua/runswmm <input file> <report file> [output file]
Written by Claude (Anthropic) for Robert Dickinson; see README.md."""
import os, sys
from lupa import lua54

here = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'swmm5')
L = lua54.LuaRuntime(register_eval=False, register_builtins=False)
main = L.execute('return dofile(...)', os.path.join(here, 'main.lua'))
rc = main(here, os.getcwd(), *sys.argv[1:])
sys.stdout.flush()
sys.exit(int(rc or 0))
