"""Xonsh Developer Toolkit RC file."""

# $XONSH_SHOW_TRACEBACK=1
# $XONSH_TRACE_SUBPROC=2
# $RAISE_SUBPROC_ERROR=1

cwd = pf'{__file__}'.parent
source @(cwd)/callias.xsh
