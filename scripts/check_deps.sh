#!/bin/bash
# check_deps.sh — Check and auto-install dependencies for web-presentation
# Usage: bash check_deps.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_ok()   { echo -e "${GREEN}✅ $1${NC}"; }
log_warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_err()  { echo -e "${RED}❌ $1${NC}"; }
log_install() { echo -e "${YELLOW}🔧 Installing: $1...${NC}"; }

detect_pkg_mgr() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    command -v brew >/dev/null 2>&1 && echo "brew" || echo "none"
  elif [[ -f /etc/debian_version ]]; then
    echo "apt"
  elif [[ -f /etc/redhat-release ]]; then
    command -v dnf >/dev/null 2>&1 && echo "dnf" || echo "yum"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "none"
  fi
}

try_install() {
  local cmd="$1" pkg="${2:-$cmd}" mgr="$3"
  log_install "$cmd ($pkg)"
  case "$mgr" in
    brew) brew install "$pkg" 2>/dev/null ;;
    apt)  sudo apt-get update -qq && sudo apt-get install -y -qq "$pkg" 2>/dev/null ;;
    dnf)  sudo dnf install -y "$pkg" 2>/dev/null ;;
    yum)  sudo yum install -y "$pkg" 2>/dev/null ;;
    pacman) sudo pacman -S --noconfirm "$pkg" 2>/dev/null ;;
    *) return 1 ;;
  esac
}

check_dep() {
  local cmd="$1" pkg="${2:-$cmd}" required="${3:-true}" mgr="$4"
  if command -v "$cmd" >/dev/null 2>&1; then
    local ver=$($cmd --version 2>/dev/null | head -1 || echo "installed")
    log_ok "$cmd — $ver"
    return 0
  fi
  if [[ "$required" == "true" ]]; then
    log_warn "$cmd not found, auto-installing..."
    if [[ "$mgr" == "none" ]]; then
      log_err "Cannot auto-install $cmd — no package manager found"
      echo "  Install manually: $cmd"
      return 1
    fi
    if try_install "$cmd" "$pkg" "$mgr" && command -v "$cmd" >/dev/null 2>&1; then
      log_ok "$cmd installed"
      return 0
    else
      log_err "$cmd installation failed"
      echo "  Install manually: $cmd"
      return 1
    fi
  else
    log_warn "$cmd not installed (optional)"
    return 0
  fi
}

echo "🔍 Checking web-presentation dependencies..."
echo ""

MGR=$(detect_pkg_mgr)
echo "  Package manager: $MGR"
echo ""

FAILED=0
check_dep "git"    "git"    "true" "$MGR" || FAILED=$((FAILED + 1))
check_dep "python3" "python3" "true" "$MGR" || FAILED=$((FAILED + 1))
check_dep "curl"   "curl"   "true" "$MGR" || FAILED=$((FAILED + 1))
check_dep "node"   "node"   "true" "$MGR" || FAILED=$((FAILED + 1))

echo ""

if [[ $FAILED -gt 0 ]]; then
  log_err "$FAILED required dependencies failed to install"
  exit 1
fi

log_ok "All dependencies ready"
echo ""
echo "Next: bash init_project.sh <project-name> <template>"
