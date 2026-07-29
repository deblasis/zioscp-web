---
title: Roadmap
description: What's done and what's deferred.
---

zioscp's core is complete and battle-tested: resume, parallel transfers,
pipelining, a self-contained backend, and cross-platform builds.

## Done

- **scp-compatible syntax** — `[user@]host:path`, `-r`, `-p`, `-P`, `-i`.
- **Resume** — offset resume with a `.zioscppart` sidecar; downloads are
  MAC-verified per chunk so a corrupted partial is detected, not trusted.
- **Parallel transfers** — `-r -j N` across a tree; `-j N` sharding one file.
- **Pipelining** — an adaptive, BDP-sized window of in-flight SFTP requests on
  every stream.
- **Self-contained backend** — `-Dbackend=libssh2` builds one binary with no
  `ssh`/`libssl`/`libcrypto` dependency; Ed25519, ECDSA, RSA.
- **Cross-platform** — macOS, Linux, Windows (Windows defaults to libssh2).
- **Host-key verification** — strict by default, scp-faithful, on both backends.
- **Bandwidth limiting, progress, mtime preservation** — `--bwlimit`,
  TTY-gated progress bars, `-p`.

## Deferred

These are on the books but not yet built. Neither is required for zioscp to do
its job; both are evaluated against real demand.

- **Delta transfer** (rsync-style incremental). The biggest remaining
  functional win for re-syncing large, slowly-changing files. The honest
  constraint: full rsync delta needs a cooperating server, which conflicts with
  zioscp's "works against any unmodified sshd" promise; the realistic version is
  a client-index incremental.
- **FIPS mode**. Operating with only FIPS-approved algorithms via OpenSSL's FIPS
  provider. A compliance gate for regulated industries, not a capability most
  users need.

## Quality

42/42 integration tests, including disk-full, permission-denied,
parallel-worker-failure, and network-drop scenarios. See the
[releases](https://github.com/deblasis/zioscp/releases) for the changelog.
