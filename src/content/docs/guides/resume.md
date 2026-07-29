---
title: Resume
description: Interrupted transfers continue where they stopped, verified.
---

An interrupted `scp` transfer restarts from byte zero. zioscp doesn't. As it
transfers it writes a small sidecar next to the destination, and a re-run of the
same command picks up at the exact offset it reached.

## How it works

For each in-progress file, zioscp writes a `.zioscppart` sidecar recording the
byte offset reached. On re-run, the destination is treated as a partial: the
remote file is read/written starting at that offset instead of from the start.
When the transfer completes, the sidecar is removed and the file is renamed into
place.

## Why it's verified

Offset-only resume has a blind spot: if the partial file is **corrupted on disk
between runs** (a failing drive, a sync accident, a truncated write), plain
resume would keep appending to bad data and silently produce a wrong file.

zioscp closes that hole. For downloads, each completed chunk is also recorded as
a SHA-256 MAC in a `.zioscpmac` file. On resume, the MAC of each already-written
chunk is recomputed and checked. A chunk whose contents no longer match its MAC
is re-fetched rather than trusted — so a flipped byte is detected and fixed, not
baked in.

## Opting out

Pass `--no-resume` to overwrite from the start instead of continuing:

```sh
zioscp --no-resume prod:/data.bin .
```

## In parallel transfers

Resume coordinates across connections for both recursive (`-r -j N`) and
single-file chunked (`-j N`) transfers. For chunked transfers, a
`.zioscpchunks` bitmap records which chunks finished, so a re-run skips the done
chunks and fills only the gaps — without re-truncating the destination.
