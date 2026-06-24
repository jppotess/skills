#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${AGENT_DELIVERY_KIT_REPO:-https://github.com/jppotess/skills}"
ARCHIVE_URL="${REPO_URL}/archive/refs/heads/main.tar.gz"
DEST_DIR="${CODEX_SKILLS_DIR:-${AGENT_SKILLS_DIR:-${HOME}/.codex/skills}}"
DRY_RUN=0
LIST_ONLY=0

SKILLS=(
  delivery-kit-setup
  spec-to-ship
  delivery-autopilot
  ship-pr
  coderabbit-gate
)

usage() {
  cat <<'USAGE'
Agent Delivery Kit installer

Usage:
  ./install.sh [--dest PATH] [--dry-run] [--list]

Options:
  --dest PATH   Install skills into PATH instead of ~/.codex/skills.
  --dry-run     Print planned installs without writing files.
  --list        Print bundled skill names and exit.
  --help        Show this help.

Environment:
  CODEX_SKILLS_DIR            Destination override.
  AGENT_SKILLS_DIR            Fallback destination override.
  AGENT_DELIVERY_KIT_REPO     Repository URL for one-command remote install.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --dest" >&2
        exit 2
      fi
      DEST_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --list)
      LIST_ONLY=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "${LIST_ONLY}" -eq 1 ]]; then
  printf '%s\n' "${SKILLS[@]}"
  exit 0
fi

SCRIPT_SOURCE="${BASH_SOURCE[0]:-${0}}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${SCRIPT_SOURCE}")" >/dev/null 2>&1 && pwd || pwd)"
SOURCE_ROOT=""
TEMP_DIR=""

cleanup() {
  if [[ -n "${TEMP_DIR}" && -d "${TEMP_DIR}" ]]; then
    rm -rf "${TEMP_DIR}"
  fi
}
trap cleanup EXIT

if [[ -d "${SCRIPT_DIR}/codex/skills" ]]; then
  SOURCE_ROOT="${SCRIPT_DIR}"
else
  TEMP_DIR="$(mktemp -d)"
  ARCHIVE_PATH="${TEMP_DIR}/skills.tar.gz"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${ARCHIVE_URL}" -o "${ARCHIVE_PATH}"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "${ARCHIVE_PATH}" "${ARCHIVE_URL}"
  else
    echo "Remote install needs curl or wget. Clone ${REPO_URL} and run ./install.sh." >&2
    exit 1
  fi

  tar -xzf "${ARCHIVE_PATH}" -C "${TEMP_DIR}"
  SOURCE_ROOT="$(find "${TEMP_DIR}" -maxdepth 1 -type d -name 'skills-*' | head -n 1)"

  if [[ -z "${SOURCE_ROOT}" || ! -d "${SOURCE_ROOT}/codex/skills" ]]; then
    echo "Downloaded archive did not contain codex/skills." >&2
    exit 1
  fi
fi

SOURCE_DIR="${SOURCE_ROOT}/codex/skills"
DEST_DIR="${DEST_DIR%/}"

if [[ -z "${DEST_DIR}" || "${DEST_DIR}" == "/" ]]; then
  echo "Refusing unsafe install destination: '${DEST_DIR}'" >&2
  exit 1
fi

for skill_name in "${SKILLS[@]}"; do
  skill_dir="${SOURCE_DIR}/${skill_name}"
  target="${DEST_DIR}/${skill_name}"

  if [[ ! -d "${skill_dir}" ]]; then
    echo "Missing bundled skill: ${skill_dir}" >&2
    exit 1
  fi

  case "${target}" in
    "${DEST_DIR}"/*) ;;
    *)
      echo "Refusing unexpected target path: ${target}" >&2
      exit 1
      ;;
  esac

  if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "would install ${skill_name} -> ${target}"
    continue
  fi

  mkdir -p "${DEST_DIR}"
  rm -rf "${target}"
  mkdir -p "${target}"
  cp -R "${skill_dir}/." "${target}/"
  echo "installed ${skill_name} -> ${target}"
done

if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo "dry run complete"
else
  echo "Agent Delivery Kit installed. Start with: Use \$delivery-kit-setup in your project repo."
fi
