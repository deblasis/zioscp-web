#!/usr/bin/env bash
# Shared helpers for zioscp asciinema casts. Sourced by each scenario script.
# Run recordings from the zioscp repo root so `zig-out/bin/zioscp` + keys resolve.

ZIO="zig-out/bin/zioscp"
KEY="tests/keys/ed25519"
PROMPT=$'\033[1;32m$\033[0m '

banner() {
  printf '\n\033[1;36m### %s ###\033[0m\n\n' "$*"
  sleep 0.7
}
say() {
  printf '\033[2m# %s\033[0m\n' "$*"
  sleep 0.6
}
# Type a command char-by-char (feels live), then execute it in a subshell that
# inherits the PTY so zioscp's TTY-gated progress bars render.
type_run() {
  local cmd="$1"
  printf '%s' "$PROMPT"
  local i=0
  while (( i < ${#cmd} )); do
    printf '%s' "${cmd:i:1}"
    sleep 0.013
    ((i++))
  done
  sleep 0.35
  printf '\n'
  bash -c "$cmd"
  sleep 0.4
}

# Type a clean command, run it in the background, and interrupt it after $2
# seconds (simulating Ctrl-C). Used to demo resume: the .zioscppart sidecar
# persists the last acked offset, so a re-run continues from there.
#
# NOTE: non-interactive bash sets SIGINT to SIG_IGN for background jobs, so
# `kill -INT` is silently ignored (zioscp would run to completion). SIGTERM is
# not ignored by bash for bg jobs, so we use it to actually stop the transfer.
# (zioscp itself responds to a real Ctrl-C in an interactive terminal — this is
# purely a scripting artifact of backgrounding the process.)
run_interrupt() {
  local cmd="$1"; local secs="$2"
  printf '%s' "$PROMPT"
  local i=0
  while (( i < ${#cmd} )); do
    printf '%s' "${cmd:i:1}"
    sleep 0.013
    ((i++))
  done
  sleep 0.3
  printf '\n'
  printf '\033[2m# (Ctrl-C after %ss — interrupted)\033[0m\n' "$secs"
  bash -c "$cmd & p=\$!; sleep $secs; kill -TERM \$p 2>/dev/null; wait \$p 2>/dev/null; true"
  printf '\n'
  sleep 0.4
}
