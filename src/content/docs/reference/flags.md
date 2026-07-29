---
title: CLI flags
description: Every zioscp flag and what it does.
---

zioscp mirrors `scp`'s flags and adds a few. Run `zioscp --help` for the
authoritative list generated from your build.

```txt
Usage: zioscp [options] src dest
  One of src/dest is a remote [user@]host:path, the other is local.
```

## Flags

| Flag | Default | Description |
| --- | --- | --- |
| `-r` | off | Copy directories recursively. |
| `-p` | off | Preserve file permissions and mtime. |
| `-P <port>` | `22` | SSH port. |
| `-i <key>` | ssh default | Identity file (private key). |
| `-j <N>` | `1` | Parallel transfer connections. With `-r`, fans a tree across N connections; without `-r`, shards one file across N. See [Parallel](../../guides/parallel/). |
| `--chunk-size <bytes>` | `8388608` (8 MiB) | Transfer chunk size in bytes. |
| `--bwlimit <bytes/sec>` | `0` (unlimited) | Limit transfer to N bytes/sec, paced at chunk granularity. |
| `--no-resume` | off | Overwrite from the start instead of resuming. See [Resume](../../guides/resume/). |
| `--host-key-check <mode>` | `strict` | Server host key check: `strict` \| `accept-new` \| `no`. See [Host keys](../../guides/host-keys/). |
| `-v` | off | Print one progress line per file to stderr. |

Progress bars render automatically when stderr is a terminal and are suppressed
when piped, so logs and scripts stay clean.

## Examples

```sh
# recursive, 4 parallel connections
zioscp -r -j4 ./site/ prod:/var/www/site/

# a single big file, sharded across 4 connections
zioscp -j4 ./image.qcow2 backup:/srv/

# throttle to ~10 MB/s
zioscp --bwlimit 10000000 ./data/ prod:/data/

# custom key + port, accept a new host
zioscp -i ~/.ssh/deploy -P 2222 --host-key-check=accept-new app@host:~/x .
```
