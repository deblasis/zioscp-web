---
title: Quickstart
description: Copy a file in 30 seconds with zioscp.
---

zioscp uses the same syntax and flags as `scp`. If you know `scp`, you know
zioscp. Point it at the same `[user@]host:path` paths you already use.

## Download

```sh
zioscp prod:/var/log/app.log ./app.log
```

## Upload

```sh
zioscp ./release.tar.gz prod:/srv/releases/
```

## A whole directory, in parallel

```sh
zioscp -r -j4 ./deploy/ prod:/var/www/app/
```

`-r` recurses; `-j 4` fans the tree across four SSH connections at once. See
[Parallel transfers](../guides/parallel/).

## Resume after a drop

If a transfer is interrupted (lost connection, Ctrl-C, full disk), just run the
same command again. zioscp continues from where it stopped instead of
restarting. See [Resume](../guides/resume/).

```sh
zioscp -r -j4 ./deploy/ prod:/var/www/app/   # again — picks up where it left off
```

## One big file, sharded

```sh
zioscp -j4 ./20gb-image.qcow2 backup:/srv/
```

With `-j N` on a single large file, zioscp shards it across N connections,
writing disjoint offset ranges concurrently.

## Keys and ports

```sh
zioscp -i ~/.ssh/deploy_ed25519 -P 2222 app@host:~/data.bin .
```

Server host keys are verified against `~/.ssh/known_hosts` by default, like scp
under BatchMode. Override with `--host-key-check accept-new|no`. See
[Host-key verification](../guides/host-keys/).

## Quiet / verbose

Progress bars render automatically when stderr is a terminal. Add `-v` for one
line per file; pipe the output to suppress the bars entirely.

```sh
zioscp -v -r ./logs/ prod:/var/logs/
```

That's it. For the full flag list, see the [CLI reference](../reference/flags/).
