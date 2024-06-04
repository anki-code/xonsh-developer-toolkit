#!/usr/bin/env python

import os, sys, signal, time
from datetime import datetime

ASK_INPUT = True
OUTPUT_FILE = '/tmp/sig'  # Use `tail -f /tmp/sig` to monitor the process.

def log(msg, file=sys.stdout):
    current_datetime = datetime.now()
    iso_date = current_datetime.isoformat()
    print(f"{os.getpid()} {iso_date} {msg}", file=file)

def get_signal_name(signum):
    for name in dir(signal):
        if name.startswith("SIG") and getattr(signal, name) == signum:
            return name
    return ""

def main():
    if OUTPUT_FILE:
        with open(OUTPUT_FILE, 'a') as f:
            log(f"start catching", file=f)

    def signal_handler(signum, frame):
        if OUTPUT_FILE:
            with open(OUTPUT_FILE, 'a') as f:
                log(f"signal {signum} {get_signal_name(signum)}", file=f)
        log(f"signal {signum} {get_signal_name(signum)}", file=sys.stdout)

    # Set handlers for all signals.
    for sig in range(1, signal.NSIG):
        # Skip system signals.
        if sig in [signal.SIGKILL, signal.SIGSTOP, signal.SIGINT]:
            continue

        # You may remove this if needed.
        if sig in [signal.SIGINT]:
            continue

        try:
            signal.signal(sig, signal_handler)
        except (ValueError, OSError) as e:
            log(f"exception on setting signal {sig} {get_signal_name(sig)}: {e}", file=f)

    log(f"start catching")

    i = 0
    while True:
        if ASK_INPUT:
            # Low level method
            os.read(0, 1024)
            # High level method
            # print(repr(input('Input:')))
            sys.exit()
        else:
            log(f'sleep {i}')
            if echo_sleep:
                time.sleep(1)

        i += 1

if __name__ == "__main__":
    main()
