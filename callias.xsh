"""Xonsh Developer Toolkit: callable alias (callias) development."""
  
import sys, os, inspect
from xonsh.tools import unthreadable, uncapturable
from xonsh.built_ins import XSH


def _print_to_tty(message):
    """Print message directly to TTY."""
    try:
        tty_name = os.ttyname(sys.stdout.fileno())
        with open(tty_name, 'w') as tty:
            tty.write(message + '\n')
    except OSError as e:
        print(f"{message}: error TTY: {e}")


def _printer(a,i,o,e):
    """Print into all kinds of streams."""
    func_name = inspect.stack()[0][3]
    alias_name = XSH.env.get('__ALIAS_NAME', "NONAME")
    name = alias_name
    print(f"{name}: alias.stdout", file=o)
    print(f"{name}: alias.stderr", file=e)
    print(f"{name}: sys.stdout", file=sys.stdout)
    print(f"{name}: sys.stderr", file=sys.stderr)
    echo @(f"{name}: echo")
    ![echo @(f"{name}: ![echo]")]
    $[echo @(f"{name}: $[echo]")]
    _print_to_tty(f"{name}: tty")
    !(echo @(f"{name}: !() THIS MUST BE CAPTURED IF YOU SEE THIS IT IS ISSUE"))
    $(echo @(f"{name}: $() THIS MUST BE CAPTURED IF YOU SEE THIS IT IS ISSUE"))


@aliases.register('ca-th')
def _cath(a,i,o,e):
    """Callable alias: threadable=default."""
    _printer(a,i,o,e)


@aliases.register('ca-unth')
@unthreadable
def _cath2(a,i,o,e):
    """Callable alias: threadable=unthreadable."""
    _printer(a,i,o,e)


@aliases.register('ca-unth-uncap')
@unthreadable
@uncapturable
def _cath3(a,i,o,e):
    """Callable alias: threadable=unthreadable+uncapturable."""
    _printer(a,i,o,e)


@aliases.register('ca-th-in')
def _cath4(a,i,o,e):
    """Callable alias: threadable=default with `input()` request."""
    _printer(a,i,o,e)
    try:
        o = input('Input: ')
        print('Got input:', repr(o))
    except Exception as e:
        print('Input error:', e)

@aliases.register('ca-th-sudo')
def _cath5(a,i,o,e):
    """Callable alias: threadable=default with `sudo -k echo 123` request."""
    _printer(a,i,o,e)
    sudo -k echo 123

