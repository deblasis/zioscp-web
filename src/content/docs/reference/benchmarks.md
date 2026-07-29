---
title: Benchmarks
description: How zioscp compares to scp under latency and on many files.
---

zioscp's headline wins are on **high-latency links** and **many small files**.
Every timed run is verified (SHA-256 or file count) before its time is accepted,
so a failed transfer can never report a bogus fast time.

## Many files at 100 ms RTT

Measured with `tc netem` injecting 100 ms RTT on loopback (the control session
rides a different interface), 100 files:

| Command | Time |
| --- | --- |
| `scp -r` | ~53 s |
| `zioscp -r -j4` | ~11 s |

That's roughly **4.7× faster**. Single-file upload and download both match or
beat scp under the same latency.

## Why

- **Pipelining.** Every stream keeps an adaptive, BDP-sized window of SFTP
  requests in flight, sized from how long each ack actually blocks. Even
  `zioscp -j1` beats scp on large transfers because it doesn't wait on one
  request at a time.
- **Parallelism.** `-r -j N` fans a tree across N connections; `-j N` shards one
  file. scp does neither.
- **Lean recursion.** zioscp collects the tree, then transfers — less per-file
  chitchat than scp's recursive protocol.

## Reproducing

The harnesses live in the repo under `tests/`:

- `tests/bench.sh` — stock scp vs zioscp on single-file and many-small-file
  transfers (run after the integration container is up).
- `tests/bench-latency.sh` — the latency-injected comparison above, on a Linux
  host with `tc netem`.

Absolute times vary by host and link; the **ratios** are the stable signal.
