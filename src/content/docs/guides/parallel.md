---
title: Parallel transfers
description: Fan out a tree, or shard one big file, across many connections.
---

zioscp parallelizes in two ways, both over plain SFTP on any unmodified sshd.

## Many files: `-r -j N`

```sh
zioscp -r -j4 ./site/ prod:/var/www/site/
```

`-r` recurses the tree, collecting the full file list first (pre-creating remote
directories). `-j N` then spins up N workers, each with its own SSH connection,
pulling files from a shared lock-free queue. Files are distributed across
workers so no single large file blocks the rest, and per-file failures are logged
and skipped (scp's skip-and-continue semantics) without aborting the whole run.

This is where zioscp beats scp most visibly on latency: at 100 ms RTT, copying
100 small files runs roughly **4.7× faster** than `scp -r`. See
[Benchmarks](../../reference/benchmarks/).

## One big file: `-j N`

```sh
zioscp -j4 ./20gb-image.qcow2 backup:/srv/
```

Without `-r`, `-j N` on a single file shards it: one connection pre-truncates
the destination, then N workers open it for write at disjoint offset ranges and
each pulls its share of chunks from an atomic index. Every chunk is written by
exactly one worker — no overlaps, no holes. Files smaller than one chunk fall
back to a single stream. Resume for this mode uses a `.zioscpchunks` bitmap (see
[Resume](../resume/)).

## Pipelining

Every stream — single, parallel-worker, or chunk-worker — keeps an adaptive,
bandwidth-delay-product-sized window of SFTP requests in flight, so each
connection saturates the server rather than waiting on one request at a time.
That's why even `zioscp -j1` beats stock scp on large transfers.

## Choosing N

`-j` is bounded by what the server will tolerate: each connection is a separate
SSH session. `-j4` is a safe default; higher helps on high-latency or
many-small-file workloads but adds load on the host. A single connection with a
pipelined stream is often enough for one large file on a fast link.
