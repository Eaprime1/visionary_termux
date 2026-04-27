#!/usr/bin/env bash
# setup.sh — Visionary Termux new-user setup
#
# Installs and configures the core Visionary Termux stack:
#   termux-x11 + XFCE + proot-distro + termux-api
#
# Usage:
#   bash setup.sh [OPTIONS]
#
# Options:
#   --minimal              Only install x11 and XFCE; skip proot-distro and termux-api
#   --with-distro <name>   proot-distro distribution to install (default: ubuntu)
#                          choices: ubuntu, debian, fedora, archlinux, alpine
#   --help                 Show this message

set -euo pipefail

# ── Colour helpers ─────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${GREEN}[setup]${NC} $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
die()   { echo -e "${RED}[error]${NC} $*" >&2; exit 1; }
header(){ echo -e "\n${BOLD}$*${NC}"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
MINIMAL=false
DISTRO="ubuntu"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --minimal)       MINIMAL=true; shift ;;
    --with-distro)   DISTRO="$2"; shift 2 ;;
    --help|-h)
      sed -n '/^# setup.sh/,/^[^#]/{ /^[^#]/d; s/^# \{0,2\}//; p }' "$0"
      exit 0
      ;;
    *) die "Unknown option: $1. Run with --help for usage." ;;
  esac
done

# ── Environment check ─────────────────────────────────────────────────────────
if [ -z "${TERMUX_VERSION:-}" ]; then
  die "This script must run inside Termux on Android."
fi

header "Visionary Termux Setup"
echo "  Distribution : ${DISTRO}"
echo "  Minimal mode : ${MINIMAL}"
echo ""

# ── Step 1: Update package index ──────────────────────────────────────────────
header "Step 1/5 — Update package index"
pkg update -y && pkg upgrade -y

# ── Step 2: Install x11-repo and termux-x11 ──────────────────────────────────
header "Step 2/5 — Install termux-x11"
if pkg list-installed 2>/dev/null | grep -q "^x11-repo"; then
  info "x11-repo already installed."
else
  pkg install -y x11-repo
fi

if pkg list-installed 2>/dev/null | grep -q "^termux-x11-nightly"; then
  info "termux-x11-nightly already installed."
else
  pkg install -y termux-x11-nightly
fi

# ── Step 3: Install XFCE desktop environment ─────────────────────────────────
header "Step 3/5 — Install XFCE desktop environment"
if pkg list-installed 2>/dev/null | grep -q "^xfce4 "; then
  info "xfce4 already installed."
else
  pkg install -y xfce4 xfce4-terminal
fi

# ── Step 4: Install proot-distro (unless --minimal) ──────────────────────────
header "Step 4/5 — Install proot-distro"
if [ "$MINIMAL" = "true" ]; then
  info "Skipping proot-distro (--minimal mode)."
else
  if pkg list-installed 2>/dev/null | grep -q "^proot-distro"; then
    info "proot-distro already installed."
  else
    pkg install -y proot-distro
  fi

  if proot-distro list 2>/dev/null | grep -q "^${DISTRO}.*installed"; then
    info "proot-distro ${DISTRO} already installed."
  else
    info "Installing ${DISTRO} via proot-distro..."
    proot-distro install "$DISTRO"
  fi
fi

# ── Step 5: Install termux-api ────────────────────────────────────────────────
header "Step 5/5 — Install termux-api"
if [ "$MINIMAL" = "true" ]; then
  info "Skipping termux-api (--minimal mode)."
else
  if pkg list-installed 2>/dev/null | grep -q "^termux-api"; then
    info "termux-api already installed."
  else
    pkg install -y termux-api
    info "Remember to install the Termux:API Android app from F-Droid as well."
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
header "Setup complete"
echo ""
echo "  Start termux-x11 with XFCE:"
echo "    termux-x11 :1 -xstartup 'xfce4-session'"
echo ""

if [ "$MINIMAL" = "false" ]; then
  echo "  Enter your ${DISTRO} environment (with X11 sharing):"
  echo "    proot-distro login ${DISTRO} --shared-tmp"
  echo ""
  echo "  Inside ${DISTRO}, connect to the X11 display:"
  echo "    export DISPLAY=:1"
  echo "    startxfce4"
  echo ""
fi

echo "  Docs:"
echo "    cat docs/VISION.md        — project overview"
echo "    cat docs/ARCHITECTURE.md  — how the pieces fit together"
echo "    ls  docs/snippets/        — ready-to-use example scripts"
echo ""
