# Cast sources

The asciinema recordings in `public/casts/` are real captures of zioscp against
a live sshd. They are regenerated from the scripts here.

## What's here

- `rec.py` — a minimal asciicast-v2 recorder. It forks a PTY (`pty.fork`) and
  captures the command's output with timing, so TTY-gated progress bars render
  even in a headless environment (CI / agents / pipes), where `asciinema rec`
  and `script` can't allocate a controlling terminal.
- `lib.sh` — shared helpers: a typewriter `type_run`, a `run_interrupt` (for the
  resume demo), and narration helpers.
- `s1-download.sh`, `s2-resume.sh`, `s3-parallel.sh`, `s4-vs-scp.sh` — the four
  scenarios, in the order shown on `/demos`.

## Regenerating

Requires the zioscp binary built for the host (`zig build` in the zioscp repo),
a target sshd, and (for the scp comparison) a latency-injecting proxy.

1. Start a key-auth sshd on `localhost:2222` and seed demo files. The zioscp repo
   has `tests/sftp-integration.sh` (a linuxserver/openssh-server container); the
   test user is `testuser`, home `/config`. Seed e.g.:

   ```sh
   ssh -p 2222 ... testuser@localhost 'mkdir -p /config/demo/manysmall
     && for i in $(seq 1 60); do head -c 262144 /dev/urandom > /config/demo/manysmall/f$i.bin; done
     && head -c 40000000 /dev/urandom > /config/demo/bigfile.bin'
   ```

2. For `s4-vs-scp`, inject ~100 ms RTT with toxiproxy in front of the sshd:

   ```sh
   toxiproxy-server &
   curl -X POST :8474/proxies -d '{"name":"zssh","listen":"127.0.0.1:2333","upstream":"127.0.0.1:2222","enabled":true}'
   curl -X POST :8474/proxies/zssh/toxics -d '{"name":"d","type":"latency","stream":"downstream","toxicity":1.0,"attributes":{"latency":50}}'
   curl -X POST :8474/proxies/zssh/toxics -d '{"name":"u","type":"latency","stream":"upstream","toxicity":1.0,"attributes":{"latency":50}}'
   ```

3. Record, from the zioscp repo root (so `zig-out/bin/zioscp` resolves):

   ```sh
   for s in s1-download s2-resume s3-parallel s4-vs-scp; do
     python3 casts/source/rec.py public/casts/$s.cast 28 100 -- bash casts/source/$s.sh
   done
   ```

4. Rebuild the site (`npm run build`); the player picks up the new cast files.

The casts are honest captures — the speeds and bars you see are what actually
happened. Tweak `--bwlimit` in a scenario to make a bar move for longer.
