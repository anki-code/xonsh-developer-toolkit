<p align="center">
The xonsh developer toolkit contains all spectrum of instrument to develop xonsh shell.
</p>

<p align="center">  
If you like the idea click ⭐ on the repo and <a href="https://twitter.com/intent/tweet?text=Nice%20xontrib%20for%20the%20xonsh%20shell!&url=https://github.com/anki-code/xontrib-jump-to-dir" target="_blank">tweet</a>.
</p>

## Create development environment

### The fastest workflow

```xsh
mkdir -p ~/git && cd ~/git
# For example your name is `alex` and you forked https://github.com/xonsh/xonsh on Github
git clone git@github.com:alex/xonsh.git
cd xonsh
git checkout -b my_awesome_pr

# Install dev packages
# python -m ensurepip --upgrade  # install pip if you have python without pip
pip install -U pip
pip install '.[dev]'

# Make changes: add new environment variable.
vim xonsh/environ.py
git add xonsh/environ.py

# Create test
vim tests/environ.py
pytest tests/environ.py

# Live test
python -m xonsh --no-rc

# Create news file
cd news
cp TEMPLATE.rst my_new_env_var.rst
vim my_new_env_var.rst
git add my_new_env_var.rst
cd ..

# Push
git commit -m "My new environment variable!"
git push

# Create PR: https://github.com/xonsh/xonsh/pulls
```

### IDE

#### PyCharm

The easiest way to start contribute to xonsh core:

1. Install IDE e.g. [PyCharm](https://www.jetbrains.com/pycharm/).
2. Fork https://github.com/xonsh/xonsh and open in IDE.
3. Install dev dependencies: `pip install '.[dev]'` (you need pip >= 24, update it: `python -m pip install -U pip`).
4. Setup IDE e.g. PyCharm:
    ```
    Create project based on xonsh code directory.
    Click "Run" - "Run..." - "Edit Configurations"
    Click "+" and choose "Python". Set:
        Name: "xonsh".
        Run: choose "module" and write "xonsh".
        Script parameters: "--no-rc -DPPP=1" (here "PPP" will help to identify process using `ps ax | grep PPP`).
        Working directory: "/tmp"  # to avoid corrupting the source code during experiments
        Environment variables: add ";XONSH_SHOW_TRACEBACK=1"
        Modify options: click "Emulate terminal in output console".
    Save settings.
    
    Open `xonsh/procs/specs.py` and `def run_subproc` function.
    Put breakpoint to `specs = cmds_to_specs` code. See also: https://www.jetbrains.com/help/pycharm/using-breakpoints.html
    Click "Run" - "Debug..." - "xonsh". Now you can see xonsh prompt.
    Run `echo 1` and now you're in the debug mode on the breakpoint.
    Press F8 to step forward. Good luck!
    ```
5. Create git branch and solve [good first issue](https://github.com/xonsh/xonsh/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22+sort%3Areactions-%2B1-desc) or [popular issue](https://github.com/xonsh/xonsh/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc).
6. Create pull request to xonsh.

## Docs

* TTY
  * [The TTY demystified](https://www.linusakesson.net/programming/tty/)
* Signals
  * [A Deep Dive into the SIGTTIN / SIGTTOU Terminal Access Control Mechanism in Linux](http://curiousthing.org/sigttin-sigttou-deep-dive-linux) 
  * [Job Control Signals](https://www.gnu.org/software/libc/manual/html_node/Job-Control-Signals.html) and [Access to the Controlling Terminal](https://www.gnu.org/software/libc/manual/html_node/Access-to-the-Terminal.html)
  * [man signal - Standard signals](https://man7.org/linux/man-pages/man7/signal.7.html)
  * [Process Signal Mask](https://www.gnu.org/software/libc/manual/html_node/Process-Signal-Mask.html)
  * [Helpful things for knight: basic docs, tools](https://github.com/xonsh/xonsh/pull/5361#issuecomment-2078826181)
  * [SIGINT with multiple threads, each of which has a popen process](https://stackoverflow.com/questions/61854884/c-sigint-handler-not-working-with-multiple-threads-each-of-which-has-a-popen)
* Python threads
  * [Python: signals and threads](https://docs.python.org/3/library/signal.html#signals-and-threads): "Python signal handlers are always executed in the main Python thread of the main interpreter, even if the signal was received in another thread" 
  * [In Python, what are the cons of calling os.waitpid in a program with multiple threads?](https://stackoverflow.com/questions/5691309/in-python-what-are-the-cons-of-calling-os-waitpid-in-a-program-with-multiple-th)
* Misc
  * [fzf source code: Render UI directly to /dev/tty](https://github.com/junegunn/fzf/commit/d274d093afa667a6ac5ee34579807de195ade784)
* Research
  * [Stackoverflow questions around subprocess Popen and PIPE](https://stackoverflow.com/search?tab=newest&q=code%3a%22popen%22%20code%3a%22subprocess%22%20code%3a%22PIPE%22%20answers%3a1&searchOn=3)
  * [Github code around subprocess Popen and PIPE](https://github.com/search?q=Popen+PIPE+language%3APython&type=code&l=Python)

## Pointers

* The main loop for interactive prompt: `main.py` -> `shell.shell.cmdloop()`.
* The main function to run subprocess: `procs/specs.py` -> `run_subproc`.

### Tools for modeling the process behavior

* `echo` - simple capturable and thredable process.
* `fzf` - complex app that read STDIN, print TUI to STDERR, read terminal input from /dev/tty, print result to STDOUT.
* `sudo -k ls` - command that show password prompt to `/dev/tty` and runs process that could be capturable or uncapturable.
* `echo 123 | less` - pipe capturable process to uncapturable process.
