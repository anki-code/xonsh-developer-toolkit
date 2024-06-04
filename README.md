<p align="center">
The xonsh developer toolkit contains all spectrum of instrument to develop xonsh shell.
</p>

<p align="center">  
If you like the idea click ⭐ on the repo and <a href="https://twitter.com/intent/tweet?text=Nice%20xontrib%20for%20the%20xonsh%20shell!&url=https://github.com/anki-code/xontrib-jump-to-dir" target="_blank">tweet</a>.
</p>

## Xonsh Development Toolkit

Install:
```xsh
mkdir ~/git && cd ~/git
git clone git@github.com:anki-code/xonsh-developer-toolkit.git
```
Usage:
```xsh
xonsh --rc ~/git/xonsh-developer-toolkit/dev.xonshrc
```

## Create development environment

### The fastest workflow to contribute to xonsh

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

```xsh
echo 1 # Simple capturable and thredable process.
fzf  # Complex app that read STDIN, print TUI to STDERR, read terminal input from /dev/tty, print result to STDOUT.
sudo -k ls # Command that show password prompt to `/dev/tty` and runs process that could be capturable or uncapturable.
echo 123 | less  # Pipe capturable process to uncapturable process.
sleep 10  # Tool that are easy to run in background and interrupt.
python -c 'input()'  # Easy way to run unkillable (in some cases) input-blocked app.
python -c 'import os, signal, time; time.sleep(0.2); os.kill(os.getpid(), signal.SIGTTIN)'  # Self-signaling.
python -c '__import__('sys').exit(2)'  # Exiting with exit code.
```


### Test in pure Linux environment
```xsh
docker run --rm -it xonsh/xonsh:slim bash -c "pip install -U 'xonsh[full]' && xonsh"
# a1b2c3  # docker container id
apt update && apt install -y vim git procps strace  # to run `ps`
```
```xsh
# Connect to container from other terminal:
docker exec -it a1b2c3 bash
```
```xsh
# Save docker container state to reuse:
docker ps
docker commit c3f279d17e0a local/my_xonsh  # the same for update
docker run --rm -it local/my_xonsh xonsh
```
Trace signals with `strace`:
```xsh
python -c 'input()' & 
# pid 123
strace -p 123
# strace: Process 123 attached
# [ Process PID=123 runs in x32 mode. ]
# --- stopped by SIGTTIN ---
kill -SIGCONT 72  # From another terminal.
# --- SIGCONT {si_signo=SIGCONT, si_code=SI_USER, si_pid=48, si_uid=0} ---
# syscall_0x7ffffff90558(0x5555555c5a00, 0, 0x7fffff634940, 0, 0, 0x3f) = 0x2
# --- SIGTTIN {si_signo=SIGTTIN, si_code=SI_KERNEL} ---
# --- stopped by SIGTTIN ---
```

### Monitor process state codes (STAT)
```xsh
ps ax  # Tool to monitor processes and have the process state in STAT column.
```
```
# STAT:
D    uninterruptible sleep (usually IO)
R    running or runnable (on run queue)
S    interruptible sleep (waiting for an event to complete)
T    stopped, either by a job control signal or because it is being traced.
W    paging (not valid since the 2.6.xx kernel)
X    dead (should never be seen)
Z    defunct ("zombie") process, terminated but not reaped by its parent.
```

### Hot to send [signals](https://man7.org/linux/man-pages/man7/signal.7.html)
```xsh
ps ax | grep fzf   # get pid=123
kill -SIGINT 123
kill -SIGCONT 123

watch -n1 'ps ax | grep fzf'  # Monitor process state after sending signals (STAT).
```

### Decode process signals from [`os.waitpid`](https://docs.python.org/3/library/os.html#os.waitpid)

```xsh
# pid, proc_status = os.waitpid(pid_of_child_process, os.WUNTRACED)
# 123, 5759

from xonsh.tools import describe_waitpid_status
describe_waitpid_status(5759)

WIFEXITED - False  - Return True if the process returning status exited via the exit() system call.
WEXITSTATUS - 22 SIGTTOU - Return the process return code from status.
WIFSIGNALED - False  - Return True if the process returning status was terminated by a signal.
WTERMSIG - 127  - Return the signal that terminated the process that provided the status value.
WIFSTOPPED - True  - Return True if the process returning status was stopped.
WSTOPSIG - 22 SIGTTOU - Return the signal that stopped the process that provided the status value.
WCOREDUMP - False  - Return True if the process returning status was dumped to a core file.
```

### Python app to test catching all signals 

```xsh
python singnals-catch.py
```
*Note! We read in the manual that "Python signal handlers are always executed in the main Python thread of the main interpreter, even if the signal was received in another thread." ([source](https://docs.python.org/3/library/signal.html#signals-and-threads)). But this is not related to situation when we run subprocess. First of all the signal (e.g. SIGINT) will go to foreground subprocess task. So you need to test this carefully for case main_thread+thread+popen_subprocess.*

### Stress test

```xsh
while !(python -c 'import sys; sys.exit(1)') != 0:
    print('.', end='')
```

### Test using bash process manager

You can test any case around processes and signals using bash pipes and streams [*](http://curiousthing.org/sigttin-sigttou-deep-dive-linux):
```xsh
bash
sleep 100 &
# [1] 332211
jobs
# [1]  + running    sleep 100
ps ax | grep sleep  # pid=332211
# 332211 s005  SN     0:00.00 sleep 100
kill -SIGINT 332211

fzf 2>/dev/null &  # run fzf with hidden TUI (fzf is using stderr to show it)
fzf < /dev/null &  # disable stdin
ps fzf | grep fzf
# etc etc etc
```

### You should know about sigmask

Process by itself can catch signals. The [sigmask](https://www.gnu.org/software/libc/manual/html_node/Process-Signal-Mask.html) is describing what signals process intended to catch. I used [sigmask tool](github.com/r4um/sigmask) to decrypt `fzf` sigmask:

```xsh
apt install -y golang-go
go get -v github.com/r4um/sigmask
ps ax | grep fzf  # pid=123

~/go/bin/sigmask 123  # SigCgt - signals that process wants to catch by itself.
# SigPnd
# ShdPnd
# SigBlk SIGUSR1,SIGUSR2,SIGPIPE,SIGALRM,SIGTSTP,SIGTTIN,SIGTTOU,SIGURG,SIGXCPU,SIGXFSZ,SIGVTALRM,SIGIO,SIGPWR,SIGRTMIN
# SigIgn
# SigCgt SIGHUP,SIGINT,SIGQUIT,SIGILL,SIGTRAP,SIGABRT,SIGBUS,SIGFPE,SIGUSR1,SIGSEGV,SIGUSR2,SIGPIPE,SIGALRM,SIGTERM,SIGSTKFLT
```

### Trace xonsh code using [xunter](https://github.com/anki-code/xunter/)
```xsh
mkdir -p ~/git/ && cd ~/git/
git clone git+https://github.com/xonsh/xonsh
cd xonsh
xunter --no-rc ++cwd ++filter 'Q(filename_has="procs/")' ++output /tmp/procs.xun
# In another terminal:
tail -f /tmp/procs.xun
```

### Interesting case for tracing

#### Sleep
```xsh
for i in range(5):
    print(i)
    sleep 10
```
After Ctrl-c we have continue with the next iteration. It's annoying. Here is the related code:

https://github.com/xonsh/xonsh/blob/26c6e119e259ee6eac990233f8b0710cb67ea6b2/xonsh/jobs.py#L269-L288

When we run `sleep 10` the system process go to wait and we stuck on `os.waitpid`. After pressing `Ctrl+C` (sending SIGINT) process get the SIGINT signal and we catch that signal appeared using `WIFSIGNALED` (line 281) but have no actions about stopping the execution entirely and we continue execution.
It would be cool to considering the cases around this (i.e. can we really stop the execution of the whole code?) and stopping the execution carefully here. 

#### Input

```xsh
@aliases.register("mysudo")
def _mysudo():
    input("Password:")
    echo 123

mysudo | grep 1
```

I expect the behavior like `$(sudo -k echo 123 | grep 1)` where you can enter the password and then got captured 123. But it's not working. Tracing this in IDE is very interesting.
