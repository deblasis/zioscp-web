---
title: Host-key verification
description: zioscp verifies server host keys by default, like scp under BatchMode.
---

By default zioscp verifies the server's host key against your
`~/.ssh/known_hosts`, exactly like `scp`/`ssh` under `BatchMode=yes`: an unknown
key is refused, and a key that has **changed** is refused (the standard
machine-in-the-middle protection).

```sh
zioscp prod:/data.bin .                      # strict (default)
zioscp --host-key-check=accept-new prod:...  # record a new host on first use
zioscp --host-key-check=no prod:...          # do not verify (not recommended)
```

`--host-key-check` mirrors ssh's `StrictHostKeyChecking`:

| Value | Unknown key | Changed key |
| --- | --- | --- |
| `strict` (default) | refused | refused |
| `accept-new` | added to known_hosts | refused |
| `no` | accepted | accepted |

## How each backend checks

- **ssh backend** passes the value through as
  `-o StrictHostKeyChecking=...`, so verification is whatever your system
  OpenSSH does — full parity with ssh.
- **libssh2 backend** checks `~/.ssh/known_hosts` directly via libssh2, covering
  plain and hashed entries and the common key types (Ed25519, ECDSA, RSA).

The libssh2 path does not implement ssh's `@cert-authority`, revocation,
`CheckHostIP`, or canonicalization rules. For nearly all setups that's a
non-issue; if you rely on those, use the ssh backend.
