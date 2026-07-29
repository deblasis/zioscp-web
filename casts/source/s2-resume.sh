#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
rm -f /tmp/dl_resume.bin*

banner "zioscp — resume, with end-to-end integrity"

say "First, the SHA-256 of the source file on the server:"
type_run "ssh -p 2222 -i $KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes \
  testuser@localhost sha256sum /config/demo/bigfile.bin"

say "Start the download — then interrupt it partway (Ctrl-C):"
run_interrupt "$ZIO -P 2222 -i $KEY --host-key-check=no --bwlimit 4000000 \
  testuser@localhost:/config/demo/bigfile.bin /tmp/dl_resume.bin" 3

say "A .zioscppart sidecar + per-chunk MAC record exactly where it stopped:"
type_run "ls -lh /tmp/dl_resume.bin*"

say "Re-run the SAME command. It detects the partial, verifies each chunk's MAC,"
say "and continues from where it left off — not from zero:"
type_run "$ZIO -P 2222 -i $KEY --host-key-check=no --bwlimit 6000000 \
  testuser@localhost:/config/demo/bigfile.bin /tmp/dl_resume.bin"

say "Now the SHA-256 of the resumed download — it matches the source, byte for byte:"
type_run "shasum -a 256 /tmp/dl_resume.bin"

say "Interrupted, resumed, and verified. scp would have restarted from zero."
