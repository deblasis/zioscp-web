---
title: License
description: zioscp is dual-licensed MIT OR Apache-2.0.
---

zioscp is dual-licensed under either of:

- the Apache License, Version 2.0, or
- the MIT License.

at your option. This matches the licensing of the broader Zig ecosystem and lets
you pick whichever suits your organization. Contributions intentionally
submitted for inclusion are dual-licensed the same way unless you state
otherwise.

## Vendored dependencies

The self-contained (`libssh2`) backend statically links:

- **OpenSSL 3.6.3** — Apache-2.0.
- **libssh2 1.11.1** — BSD-3-Clause.

Both are compatible with zioscp's dual MIT OR Apache-2.0 license. Their upstream
notices are copied into the `vendor/` directory when the backend is built.

The default `ssh` backend links no third-party crypto — it uses your system
OpenSSH.
