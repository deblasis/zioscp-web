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

### A note on antivirus false positives (Windows)

zioscp's Windows binary is self-contained and statically linked, and it does
raw networking, SSH/crypto, and bulk file I/O, which is exactly the behaviour
heuristic antivirus engines associate with malware. Because it is also
**unsigned** (no paid Authenticode certificate), some AV products (Bitdefender,
occasionally Windows Defender) flag it on first download. This is a **false
positive**: the binary is built from public source by GitHub Actions and every
release ships a checksum you can verify (see [Verify](#verify)).

**Why unsigned:** Authenticode code-signing certificates are not free, and
zioscp is a personal open-source project without one yet.

**The plan:** once zioscp has enough traction or sponsorship, releases will be
Authenticode-signed, which removes the AV and SmartScreen warnings for most
users.

If your AV quarantines it in the meantime:

- verify the download against the published checksum (see [Verify](#verify));
- if you trust the source, add an antivirus exclusion for zioscp;
- consider [sponsoring](https://github.com/sponsors/deblasis) the project,
  which is what would fund signing; and
- report the file as a false positive to your antivirus vendor.

## Download a binary

Grab the right archive for your platform from the
[latest release](https://github.com/deblasis/zioscp/releases/latest), extract it,
and put `zioscp` on your `PATH`:

| Platform | Archive |
| --- | --- |
| macOS (Apple Silicon) | `zioscp-v0.7.2-aarch64-macos.tar.gz` |
| macOS (Intel) | `zioscp-v0.7.2-x86_64-macos.tar.gz` |
| Linux (x86_64) | `zioscp-v0.7.2-x86_64-linux-gnu.tar.gz` |
| Linux (arm64) | `zioscp-v0.7.2-aarch64-linux-gnu.tar.gz` |
| Windows (x86_64) | `zioscp-v0.7.2-x86_64-windows-gnu.zip` |

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
zioscp --version
zioscp --help
```

Every release also ships a `SHA256SUMS.txt` so you can confirm a download
hasn't been tampered with:

```sh
curl -fsSL https://github.com/deblasis/zioscp/releases/latest/download/SHA256SUMS.txt
sha256sum -c SHA256SUMS.txt   # after downloading the matching archive(s)
```

Next: the [Quickstart](../quickstart/).
