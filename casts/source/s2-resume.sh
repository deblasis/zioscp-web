#!/usr/bin/env bash
. /tmp/zio-casts/lib.sh
rm -f /tmp/dl_resume.bin*

banner "zioscp — resume after an interrupted transfer"

say "Start a 40 MB download, throttled so we can interrupt it mid-way..."
run_interrupt "$ZIO -P 2222 -i $KEY --host-key-check=no --bwlimit 4000000 \
  testuser@localhost:/config/demo/bigfile.bin /tmp/dl_resume.bin" 3

say "A .zioscppart sidecar recorded exactly where it stopped (plus a per-chunk MAC):"
type_run "ls -lh /tmp/dl_resume.bin*"

say "Re-run the SAME command. It detects the partial and continues — verified, not blind:"
type_run "$ZIO -P 2222 -i $KEY --host-key-check=no --bwlimit 6000000 \
  testuser@localhost:/config/demo/bigfile.bin /tmp/dl_resume.bin"

say "Finished from where it left off. scp would restart from byte zero."
