"""Xonsh Developer Toolkit: callable alias (callias) development."""
  
import sys, os, inspect
from xonsh.tools import unthreadable, uncapturable
from xonsh.built_ins import XSH


def _print_to_tty(message):
    """
    Print message directly to TTY.
    If you will try to put this function into the python file and run in bash `python file.py > /tmp/output`
    you will have "Inappropriate ioctl for device" so this means that redirecting stdout disable TTY.
    """
    try:
        tty_name = os.ttyname(sys.stdout.fileno())
        with open(tty_name, 'w') as tty:
            tty.write(message + '\n')
    except OSError as e:
        print(f"{message}: error TTY: {e}")


def _printer(a,i,o,e):
    """Print into all kinds of streams."""
    try:
        func_name = inspect.stack()[0][3]
        name = XSH.env.get('__ALIAS_NAME', func_name)
    except:
        name = "NONAME"

    print(f"{name}: out alias.stdout", file=o)
    print(f"{name}: err alias.stderr", file=e)
    print(f"{name}: out sys.stdout", file=sys.stdout)
    print(f"{name}: err sys.stderr", file=sys.stderr)
    echo @(f"{name}: out echo stdout")
    echo @(f"{name}: err echo stderr") o>e
    ![echo @(f"{name}: out ![echo]")]
    $[echo @(f"{name}: out $[echo]")]
    _print_to_tty(f"{name}: out tty")  # Use `$[]` to solve "Inappropriate ioctl for device".
    !(echo @(f"{name}: !() THIS MUST BE CAPTURED IF YOU SEE THIS IT IS ISSUE"))
    !(echo @(f"{name}: !(o>e) THIS MUST BE CAPTURED IF YOU SEE THIS IT IS ISSUE") o>e)
    $(echo @(f"{name}: err $(o>e)") o>e)


def _input():
    """Standard input."""
    try:
        o = input('Input: ')
        print('Got input:', repr(o))
    except Exception as e:
        print('Input error:', e)


@aliases.register('ca-th')
def _cath(a,i,o,e):
    """Callias: threadable."""
    _printer(a,i,o,e)


@aliases.register('ca-unth')
@unthreadable
def _cath2(a,i,o,e):
    """Callias: unthreadable."""
    _printer(a,i,o,e)


@aliases.register('ca-unth-uncap')
@unthreadable
@uncapturable
def _cath3(a,i,o,e):
    """Callias: unthreadable, uncapturable."""
    _printer(a,i,o,e)


@aliases.register('ca-th-in')
def _cath4(a,i,o,e):
    """Callias: threadable, input."""
    _printer(a,i,o,e)
    _input()

@aliases.register('ca-unth-in')
@unthreadable
def _cath5(a,i,o,e):
    """Callias: unthredable, input."""
    _printer(a,i,o,e)
    _input()

@aliases.register('ca-th-sudo')
def _cath6(a,i,o,e):
    """Callias: thredable, `sudo -k echo 123`."""
    _printer(a,i,o,e)
    sudo -k echo 123

