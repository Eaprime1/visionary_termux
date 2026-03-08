#!/usr/bin/env bash
# check-duplicates.sh — Detect duplicate files between a PR branch and base
#
# Usage:
#   bash check-duplicates.sh [OPTIONS]
#
# Options:
#   --base <ref>          Base ref to compare against (default: origin/master)
#   --head <ref>          Head ref to inspect      (default: HEAD)
#   --include-untracked   Also compare untracked files on disk (for pre-commit use)
#   --output <file>       Write report to file instead of stdout
#   --help                Show this message
#
# Exit codes:
#   0  — completed successfully (duplicates may or may not have been found)
#   1  — script error (bad arguments, not in a git repo, etc.)
#
# How it works:
#   1. Collect files added/modified in HEAD vs BASE.
#   2. For each such file, compute its SHA-256 hash.
#   3. Walk every file in the BASE tree and hash those too.
#   4. Report files that share an identical hash (byte-for-byte duplicate)
#      AND files that share the same basename at different paths (possible dupe).
#
# The script intentionally does NOT remove anything. It only reports.

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
BASE_REF="origin/master"
HEAD_REF="HEAD"
INCLUDE_UNTRACKED=false
OUTPUT_FILE=""

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)             BASE_REF="$2";        shift 2 ;;
    --head)             HEAD_REF="$2";        shift 2 ;;
    --include-untracked) INCLUDE_UNTRACKED=true; shift ;;
    --output)           OUTPUT_FILE="$2";    shift 2 ;;
    --help|-h)
      sed -n '/^# check-duplicates/,/^[^#]/{ /^[^#]/d; s/^# \{0,2\}//; p }' "$0"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# ── Helpers ───────────────────────────────────────────────────────────────────
sha256_file() {
  # Works on Linux (sha256sum) and macOS (shasum -a 256)
  if command -v sha256sum &>/dev/null; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

log() { echo "[check-duplicates] $*" >&2; }

# ── Validate we're in a git repo ──────────────────────────────────────────────
if ! git rev-parse --git-dir &>/dev/null; then
  echo "ERROR: Not inside a git repository." >&2
  exit 1
fi

# ── Collect files changed in this PR ─────────────────────────────────────────
log "Comparing $HEAD_REF against $BASE_REF …"

CHANGED_FILES=()
while IFS= read -r f; do
  [[ -f "$f" ]] && CHANGED_FILES+=("$f")
done < <(git diff --name-only --diff-filter=ACM "$BASE_REF"..."$HEAD_REF" 2>/dev/null || true)

if $INCLUDE_UNTRACKED; then
  while IFS= read -r f; do
    [[ -f "$f" ]] && CHANGED_FILES+=("$f")
  done < <(git ls-files --others --exclude-standard 2>/dev/null || true)
fi

if [[ ${#CHANGED_FILES[@]} -eq 0 ]]; then
  echo "No new or modified files found — nothing to check."
  exit 0
fi

log "Checking ${#CHANGED_FILES[@]} changed file(s) against base tree …"

# ── Build hash map of BASE tree files ────────────────────────────────────────
# key = sha256, value = list of paths
declare -A BASE_HASH_TO_PATHS   # hash → "path1\npath2"
declare -A BASE_BASENAME_TO_PATHS

while IFS= read -r base_file; do
  [[ -f "$base_file" ]] || continue
  h=$(sha256_file "$base_file")
  BASE_HASH_TO_PATHS["$h"]+="${base_file}"$'\n'
  bn=$(basename "$base_file")
  BASE_BASENAME_TO_PATHS["$bn"]+="${base_file}"$'\n'
done < <(git ls-tree -r --name-only "$BASE_REF" 2>/dev/null || true)

# ── Compare each changed file ─────────────────────────────────────────────────
EXACT_DUPES=()
NAME_DUPES=()

for pr_file in "${CHANGED_FILES[@]}"; do
  pr_hash=$(sha256_file "$pr_file")
  pr_bn=$(basename "$pr_file")

  # Exact content match
  if [[ -n "${BASE_HASH_TO_PATHS[$pr_hash]+x}" ]]; then
    base_matches="${BASE_HASH_TO_PATHS[$pr_hash]}"
    while IFS= read -r match; do
      [[ -z "$match" ]] && continue
      # Don't flag if it's the same path (file was in-place modified to same content)
      if [[ "$match" != "$pr_file" ]]; then
        EXACT_DUPES+=("${pr_file} == ${match}")
      fi
    done <<< "$base_matches"
  fi

  # Same basename at a different path (possible duplicate, less certain)
  if [[ -n "${BASE_BASENAME_TO_PATHS[$pr_bn]+x}" ]]; then
    base_matches="${BASE_BASENAME_TO_PATHS[$pr_bn]}"
    while IFS= read -r match; do
      [[ -z "$match" ]] && continue
      if [[ "$match" != "$pr_file" ]]; then
        # Only flag as name-dupe if not already caught as exact dupe
        already_exact=false
        for ed in "${EXACT_DUPES[@]}"; do
          if [[ "$ed" == "${pr_file} == ${match}" ]]; then
            already_exact=true
            break
          fi
        done
        $already_exact || NAME_DUPES+=("${pr_file}  <->  ${match}")
      fi
    done <<< "$base_matches"
  fi
done

# ── Build report ──────────────────────────────────────────────────────────────
REPORT=""

if [[ ${#EXACT_DUPES[@]} -gt 0 ]]; then
  REPORT+=$'\n'"=== EXACT DUPLICATES (byte-for-byte identical) ==="$'\n'
  REPORT+="These files are identical to existing files in ${BASE_REF}."$'\n'
  REPORT+="They should almost certainly be REMOVED from this PR."$'\n\n'
  for d in "${EXACT_DUPES[@]}"; do
    REPORT+="  EXACT: ${d}"$'\n'
  done
fi

if [[ ${#NAME_DUPES[@]} -gt 0 ]]; then
  REPORT+=$'\n'"=== SAME-NAME FILES (different paths — possible duplicates) ==="$'\n'
  REPORT+="These files share a name with existing files. Review carefully."$'\n\n'
  for d in "${NAME_DUPES[@]}"; do
    REPORT+="  NAME:  ${d}"$'\n'
  done
fi

if [[ -z "$REPORT" ]]; then
  REPORT="No duplicates found."
fi

# ── Output ────────────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FILE" ]]; then
  echo "$REPORT" > "$OUTPUT_FILE"
  log "Report written to $OUTPUT_FILE"
else
  echo "$REPORT"
fi

# Summary to stderr so CI logs are clear
if [[ ${#EXACT_DUPES[@]} -gt 0 || ${#NAME_DUPES[@]} -gt 0 ]]; then
  log "Found ${#EXACT_DUPES[@]} exact duplicate(s) and ${#NAME_DUPES[@]} same-name file(s)."
else
  log "No duplicates found."
fi
