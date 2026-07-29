#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
rm -rf /tmp/scp_cmp /tmp/zio_cmp

banner "zioscp vs scp — 20 files over a 100ms-RTT link"

say "Same 20 small files over the same slow (100ms RTT) link. First, stock scp -r —"
say "one SSH connection, one file at a time, no progress:"
type_run "time scp -r -P 2333 -i $KEY \
  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes \
  testuser@localhost:/config/demo/compare/ /tmp/scp_cmp/"

say "Now the same copy with zioscp -r -j4 — 4 connections, pipelined, live progress:"
type_run "time $ZIO -r -j4 -P 2333 -i $KEY --host-key-check=no \
  testuser@localhost:/config/demo/compare/ /tmp/zio_cmp/"

say "Faster, and you could watch it happen. The gap widens with more files —"
say "see the benchmarks (zioscp -r -j4 is ~4.7x faster than scp -r at 100ms RTT)."
