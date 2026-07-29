#!/usr/bin/env python3
"""Minimal asciicast-v2 recorder.

Records a command under a freshly-allocated PTY (pty.fork) and writes an
asciicast v2 file with timing. Allocating our own PTY means the recorded
program sees a real TTY (so TTY-gated progress bars render) even when the
host environment has no controlling terminal (CI, agents, pipes).

Usage: rec.py <out.cast> <rows> <cols> -- <argv...>
"""
import os, pty, sys, json, time, select, fcntl, termios, struct, errno

def main():
    out = sys.argv[1]
    rows = int(sys.argv[2])
    cols = int(sys.argv[3])
    sep = sys.argv.index("--")
    argv = sys.argv[sep + 1:]

    pid, fd = pty.fork()
    if pid == 0:
        os.environ.setdefault("TERM", "xterm-256color")
        os.execvp(argv[0], argv)

    # set the PTY window size so layout/wrapping is sane
    try:
        fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", rows, cols, 0, 0))
    except OSError:
        pass

    events = []
    start = time.monotonic()
    done = False
    while not done:
        try:
            r, _, _ = select.select([fd], [], [], 0.05)
        except (OSError, select.error):
            break
        if fd in r:
            while True:
                try:
                    data = os.read(fd, 65536)
                except OSError as e:
                    data = b""
                if not data:
                    break
                t = time.monotonic() - start
                events.append([round(t, 6), "o", data.decode("utf-8", "replace")])
        # reap child; drain any trailing output after exit
        try:
            wpid, _ = os.waitpid(pid, os.WNOHANG)
            if wpid == pid:
                while True:
                    try:
                        data = os.read(fd, 65536)
                    except OSError:
                        break
                    if not data:
                        break
                    t = time.monotonic() - start
                    events.append([round(t, 6), "o", data.decode("utf-8", "replace")])
                done = True
        except ChildProcessError:
            done = True

    # collapse long idle gaps (paused typing) so playback is watchable
    compressed = []
    prev = 0.0
    for t, ev, data in events:
        gap = t - prev
        t2 = prev + min(gap, 1.5) if compressed else t
        compressed.append([round(t2, 6), ev, data])
        prev = t2

    with open(out, "w") as f:
        f.write(json.dumps({"version": 2, "width": cols, "height": rows,
                            "timestamp": int(time.time()), "title": "zioscp"}) + "\n")
        for e in compressed:
            f.write(json.dumps(e) + "\n")

if __name__ == "__main__":
    main()
