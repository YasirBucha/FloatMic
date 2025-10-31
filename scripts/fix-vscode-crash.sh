#!/bin/zsh
set -euo pipefail

HEADER="[fix-vscode]"

usage() {
  cat <<EOF
${HEADER} VS Code/Electron crash helper

Usage: $(basename "$0") [--diagnose] [--no-extensions] [--list-extensions] [--clear-caches] [--full-reset]

Flags:
  --diagnose         Print versions and basic environment info
  --no-extensions    Launch VS Code without extensions (does not modify settings)
  --list-extensions  List installed extensions to ~/vscode-extensions.txt
  --clear-caches     Safely clear VS Code caches (keeps settings/extensions)
  --full-reset       Backup settings then fully reset VS Code + extensions

Examples:
  $(basename "$0") --diagnose --no-extensions
  $(basename "$0") --clear-caches && $(basename "$0") --no-extensions
  $(basename "$0") --full-reset
EOF
}

die() { echo "${HEADER} ERROR: $*" >&2; exit 1; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

APP_PATH="/Applications/Visual Studio Code.app/Contents/MacOS/Electron"
CODE_BIN="code"

diagnose=false
no_ext=false
list_ext=false
clear_caches=false
full_reset=false

if [[ $# -eq 0 ]]; then
  usage; exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --diagnose) diagnose=true ;;
    --no-extensions) no_ext=true ;;
    --list-extensions) list_ext=true ;;
    --clear-caches) clear_caches=true ;;
    --full-reset) full_reset=true ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown flag: $1" ;;
  esac
  shift
done

run_diagnose() {
  echo "${HEADER} Step: Diagnose"
  if [[ -x "${APP_PATH}" ]]; then
    echo "Electron (VS Code) binary: ${APP_PATH}"
    "${APP_PATH}" --version || true
  else
    echo "${HEADER} Electron binary not found at ${APP_PATH}"
  fi
  if has_cmd "${CODE_BIN}"; then
    ${CODE_BIN} --version || true
  else
    echo "${HEADER} 'code' CLI not found in PATH"
  fi
  sw_vers || true
}

launch_no_extensions() {
  echo "${HEADER} Step: Launch VS Code without extensions"
  if [[ -x "${APP_PATH}" ]]; then
    nohup "${APP_PATH}" --disable-extensions >/dev/null 2>&1 &
    echo "${HEADER} Launched VS Code with --disable-extensions"
  else
    die "Electron binary not found at ${APP_PATH}"
  fi
}

write_extensions_list() {
  echo "${HEADER} Step: List extensions"
  if has_cmd "${CODE_BIN}"; then
    ${CODE_BIN} --list-extensions > ~/vscode-extensions.txt || true
    echo "${HEADER} Saved list to ~/vscode-extensions.txt"
  else
    echo "${HEADER} 'code' CLI not found; skipping list"
  fi
}

clear_code_caches() {
  echo "${HEADER} Step: Clear caches"
  local paths=(
    "$HOME/Library/Application Support/Code/Cache"
    "$HOME/Library/Application Support/Code/CachedData"
    "$HOME/Library/Application Support/Code/Service Worker/CacheStorage"
    "$HOME/Library/Application Support/Code/GPUCache"
    "$HOME/Library/Caches/com.microsoft.VSCode"
  )
  for p in "${paths[@]}"; do
    if [[ -e "$p" ]]; then
      rm -rf "$p"
      echo "${HEADER} Removed: $p"
    fi
  done
  echo "${HEADER} Caches cleared"
}

full_reset_all() {
  echo "${HEADER} Step: Full reset (with backup)"
  local backup_dir="$HOME/Desktop/Code-User-Backup-$(date +%Y%m%d-%H%M%S)"
  local user_dir="$HOME/Library/Application Support/Code/User"
  if [[ -d "$user_dir" ]]; then
    mkdir -p "$backup_dir"
    cp -R "$user_dir" "$backup_dir" || true
    echo "${HEADER} Backed up User settings to: $backup_dir"
  fi
  rm -rf "$HOME/.vscode/extensions"
  rm -rf "$HOME/Library/Application Support/Code"
  rm -rf "$HOME/Library/Caches/com.microsoft.VSCode"
  echo "${HEADER} Full reset completed"
}

${diagnose} && run_diagnose
${list_ext} && write_extensions_list
${clear_caches} && clear_code_caches
${full_reset} && full_reset_all
${no_ext} && launch_no_extensions

echo "${HEADER} Done"


