#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
rm -rf /tmp/dl_many

banner "zioscp — parallel recursive copy (-r -j)"

say "Copy a folder of 60 files across 4 SSH connections at once."
say "One aggregate line tracks the whole run: files, bytes, throughput, ETA."

type_run "$ZIO -r -j4 -P 2222 -i $KEY --host-key-check=no --bwlimit 1500000 \
  testuser@localhost:/config/demo/manysmall/ /tmp/dl_many/"

say "60 files, fanned across 4 connections — finished, with one clean progress line."
