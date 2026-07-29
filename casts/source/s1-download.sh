#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
rm -f /tmp/dl_big.bin*

banner "zioscp — single-file download"

say "Live bar, throughput, bytes done, and ETA — out of the box."
say "(40 MB download, throttled to 4 MB/s so the bar is visible.)"

type_run "$ZIO -P 2222 -i $KEY --host-key-check=no --bwlimit 4000000 \
  testuser@localhost:/config/demo/bigfile.bin /tmp/dl_big.bin"

say "Done. scp gives you nothing like this."
