---
title: Install
description: Install zioscp via Homebrew, the one-line installer, a release binary, or from source.
---

zioscp is a single binary with no runtime dependencies (Linux and Windows
builds are self-contained; macOS uses the `ssh` that ships with the system).
Pick whichever install path you like.

## Homebrew (macOS, Linux)

```sh
brew install deblasis/tap/zioscp
```

## macOS / Linux (one-line installer)

```sh
curl -fsSL https://raw.githubusercontent.com/deblasis/zioscp/master/install.sh | sh
```

It detects your OS and architecture, downloads the matching binary from the
latest release, and installs it to `~/.local/bin` (set `PREFIX=...` to choose
another location).

## Windows

Scoop:

```sh
scoop bucket add deblasis https://github.com/deblasis/scoop-bucket
scoop install deblasis/zioscp
```

Or PowerShell (one-line installer):

```powershell
irm https://raw.githubusercontent.com/deblasis/zioscp/master/install.ps1 | iex
```

Downloads the Windows binary and installs it to `%LOCALAPPDATA%\zioscp`, then
adds that to your user PATH (open a new terminal to use it).

## Download a binary

Grab the right archive for your platform from the
[latest release](https://github.com/deblasis/zioscp/releases/latest), extract it,
and put `zioscp` on your `PATH`:

| Platform | Archive |
| --- | --- |
| macOS (Apple Silicon) | `zioscp-v0.6.0-aarch64-macos.tar.gz` |
| macOS (Intel) | `zioscp-v0.6.0-x86_64-macos.tar.gz` |
| Linux (x86_64) | `zioscp-v0.6.0-x86_64-linux-gnu.tar.gz` |
| Linux (arm64) | `zioscp-v0.6.0-aarch64-linux-gnu.tar.gz` |
| Windows (x86_64) | `zioscp-v0.6.0-x86_64-windows-gnu.zip` |

## Build from source

Requires [Zig 0.16](https://ziglang.org). Clone and build:

```sh
git clone https://github.com/deblasis/zioscp
cd zioscp
zig build -Doptimize=ReleaseFast
```

The binary lands in `zig-out/bin/zioscp`. The default backend on macOS/Linux is
`ssh` (drives the system `ssh`); `-Dbackend=libssh2` builds a fully
self-contained binary (vendors libssh2 + OpenSSL statically) — see
[Transport backends](../guides/backends/).

## Verify

```sh
zioscp --help
```

Next: the [Quickstart](../quickstart/).
