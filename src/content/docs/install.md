---
title: Install
description: Build zioscp from source with Zig.
---

zioscp is a single static binary, built with [Zig 0.16](https://ziglang.org).
There is no runtime dependency to install beyond the binary itself.

> **Availability:** zioscp's source is not yet published as a public release.
> The commands below take effect once the repository is public. Until then,
> [v0.5.0](https://github.com/deblasis/zioscp/releases/tag/v0.5.0) documents the
> current state.

## Build from source

```sh
git clone https://github.com/deblasis/zioscp
cd zioscp
zig build -Doptimize=ReleaseFast
```

The binary lands in `zig-out/bin/zioscp`. Put it on your `PATH`.

```sh
sudo install -m 0755 zig-out/bin/zioscp /usr/local/bin/
```

## Choose a transport backend

zioscp has two interchangeable backends, selected at build time with `-Dbackend`:

| Backend | Default on | Needs on the host | Binary |
| --- | --- | --- | --- |
| `ssh` | macOS, Linux | a system `ssh` | links nothing extra |
| `libssh2` | Windows | nothing | self-contained (no `ssh`, `libssl`, or `libcrypto`) |

```sh
zig build -Dbackend=libssh2 -Doptimize=ReleaseFast   # self-contained binary
```

The `libssh2` backend vendors libssh2 1.11.1 and OpenSSL 3.6.3 and builds both
statically with `zig cc`, so the result has no `ssh`, `libssh2`, `libssl`, or
`libcrypto` dependency — only the OS runtime. The first build fetches and
compiles those sources (needs `autoconf automake libtool perl make curl` and a
few minutes); later builds are cached and fast.

See [Transport backends](../guides/backends/) for the trade-offs and the
Windows story.

## Cross-compile

zioscp cross-compiles to Linux and Windows from any host:

```sh
zig build -Dtarget=x86_64-linux-gnu
zig build -Dtarget=x86_64-windows-gnu
```

## Verify

```sh
zioscp --help
```

Next: the [Quickstart](../quickstart/).
