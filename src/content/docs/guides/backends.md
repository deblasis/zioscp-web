---
title: Transport backends
description: The ssh and libssh2 backends, and what ships on each platform.
---

zioscp has two interchangeable backends for the SSH transport, chosen at build
time with `-Dbackend`. Both run zioscp's own SFTP stack — so resume, parallel
transfers, pipelining, and MAC-verified resume behave identically on either.

## `ssh` — the system ssh (default on macOS and Linux)

Drives the system `ssh` subprocess (`ssh ... sftp`). It works anywhere OpenSSH
is installed and links nothing extra, so the binary stays small. This is the
default on macOS and Linux.

## `libssh2` — self-contained (default on Windows)

Links libssh2 directly and vendors libssh2 1.11.1 (OpenSSL backend) plus OpenSSL
3.6.3, both built statically with `zig cc`. The resulting binary has **no
`ssh`, `libssh2`, `libssl`, or `libcrypto` dependency** — only the OS runtime.
All common key types work: Ed25519, ECDSA, and RSA public-key auth, plus the
curve25519 key exchange. This is the default on Windows.

## Why Windows defaults to libssh2

The ssh-subprocess backend is not viable on Windows. `ssh.exe` does not serve a
usable SFTP stream over `-s sftp` pipes, and the overlapped stdio pipes surface
EOF before data arrives. The libssh2 backend sidesteps both by dialing its own
blocking winsock socket. (On Windows, `std.Io.net` opens a raw AFD endpoint
handle rather than a winsock SOCKET, so libssh2 — which calls winsock
`send()`/`recv()` — must build the socket itself.)

## Building either

```sh
zig build -Dbackend=ssh        # default on mac/linux
zig build -Dbackend=libssh2    # default on windows; self-contained everywhere
```

The first `libssh2` build fetches and compiles the vendored sources (needs
`autoconf automake libtool perl make curl` and a few minutes); later builds are
cached. See [Install](../../install/).
