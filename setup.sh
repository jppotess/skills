#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${AGENT_DELIVERY_KIT_REPO:-https://github.com/jppotess/skills}"
REPO_REF="${AGENT_DELIVERY_KIT_REF:-v0.1.2}"
ARCHIVE_URL="${REPO_URL}/archive/refs/tags/${REPO_REF}.tar.gz"

AGENT=""
CUSTOM_DEST=""
DRY_RUN=0
YES=0

usage() {
  cat <<'USAGE'
Agent Delivery Kit guided setup

Usage:
  ./setup.sh
  ./setup.sh --agent codex
  ./setup.sh --agent claude
  ./setup.sh --agent agents
  ./setup.sh --agent both
  ./setup.sh --agent custom --dest PATH

Options:
  --agent NAME   codex, claude, agents, both, or custom.
  --dest PATH    Destination for --agent custom.
  --dry-run      Print planned installs without writing files.
  --yes          Skip confirmation prompts.
  --help         Show this help.

Default destinations:
  codex    ~/.codex/skills
  claude   ~/.claude/skills
  agents   ~/.agents/skills
  both     Codex and Claude-compatible destinations

Environment:
  AGENT_DELIVERY_KIT_REPO     Repository URL for remote setup.
  AGENT_DELIVERY_KIT_REF      Git tag/ref for remote archive setup.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --agent" >&2
        exit 2
      fi
      AGENT="$2"
      shift 2
      ;;
    --dest)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --dest" >&2
        exit 2
      fi
      CUSTOM_DEST="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --yes|-y)
      YES=1
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

if [[ -d "${SCRIPT_DIR}/codex/skills" && -f "${SCRIPT_DIR}/install.sh" ]]; then
  SOURCE_ROOT="${SCRIPT_DIR}"
else
  TEMP_DIR="$(mktemp -d)"
  ARCHIVE_PATH="${TEMP_DIR}/skills.tar.gz"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${ARCHIVE_URL}" -o "${ARCHIVE_PATH}"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "${ARCHIVE_PATH}" "${ARCHIVE_URL}"
  else
    echo "Remote setup needs curl or wget. Clone ${REPO_URL} and run ./setup.sh." >&2
    exit 1
  fi

  tar -xzf "${ARCHIVE_PATH}" -C "${TEMP_DIR}"
  SOURCE_ROOT="$(find "${TEMP_DIR}" -maxdepth 1 -type d -name 'skills-*' | head -n 1)"

  if [[ -z "${SOURCE_ROOT}" || ! -f "${SOURCE_ROOT}/install.sh" ]]; then
    echo "Downloaded archive did not contain install.sh." >&2
    exit 1
  fi
fi

tty_read() {
  local prompt="$1"
  local response=""

  if [[ -r /dev/tty ]]; then
    printf '%s' "${prompt}" > /dev/tty
    IFS= read -r response < /dev/tty
  else
    return 1
  fi

  printf '%s' "${response}"
}

expand_dest() {
  local dest="$1"
  case "${dest}" in
    "~") printf '%s\n' "${HOME}" ;;
    "~/"*) printf '%s/%s\n' "${HOME}" "${dest#"~/"}" ;;
    *) printf '%s\n' "${dest}" ;;
  esac
}

dest_for_agent() {
  case "$1" in
    codex) printf '%s\n' "${HOME}/.codex/skills" ;;
    claude) printf '%s\n' "${HOME}/.claude/skills" ;;
    agents) printf '%s\n' "${HOME}/.agents/skills" ;;
    custom) expand_dest "${CUSTOM_DEST}" ;;
    *)
      echo "Unknown agent: $1" >&2
      exit 2
      ;;
  esac
}

choose_agent() {
  if ! { : > /dev/tty; } 2>/dev/null || [[ ! -r /dev/tty ]]; then
    echo "No interactive terminal available. Re-run with --agent codex, --agent claude, --agent agents, --agent both, or --agent custom --dest PATH." >&2
    exit 2
  fi

  cat > /dev/tty <<'MENU'
Agent Delivery Kit setup

Choose where to install the skills:

  1) Codex (~/.codex/skills)
  2) Claude-compatible (~/.claude/skills)
  3) Generic / OpenAI Agents (~/.agents/skills)
  4) Codex + Claude-compatible
  5) Custom path

MENU

  local choice
  choice="$(tty_read "Select 1-5: ")" || {
    echo "No interactive terminal available. Re-run with --agent codex, --agent claude, --agent agents, --agent both, or --agent custom --dest PATH." >&2
    exit 2
  }

  case "${choice}" in
    1) AGENT="codex" ;;
    2) AGENT="claude" ;;
    3) AGENT="agents" ;;
    4) AGENT="both" ;;
    5) AGENT="custom" ;;
    *)
      echo "Invalid selection: ${choice}" >&2
      exit 2
      ;;
  esac
}

confirm_install() {
  local label="$1"
  local dest="$2"

  if [[ "${YES}" -eq 1 || "${DRY_RUN}" -eq 1 ]]; then
    return 0
  fi

  local answer
  answer="$(tty_read "Install for ${label} at ${dest}? [Y/n] ")" || return 0
  case "${answer}" in
    ""|y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

install_one() {
  local agent="$1"
  local label="$2"
  local dest
  local -a args
  dest="$(dest_for_agent "${agent}")"

  if [[ -z "${dest}" ]]; then
    echo "Missing destination for ${agent}" >&2
    exit 2
  fi

  if confirm_install "${label}" "${dest}"; then
    args=(--dest "${dest}")
    if [[ "${DRY_RUN}" -eq 1 ]]; then
      args+=(--dry-run)
    fi
    "${SOURCE_ROOT}/install.sh" "${args[@]}"
  else
    echo "skipped ${label}"
  fi
}

if [[ -z "${AGENT}" ]]; then
  choose_agent
fi

case "${AGENT}" in
  custom)
    if [[ -z "${CUSTOM_DEST}" ]]; then
      CUSTOM_DEST="$(tty_read "Custom skill root path: ")" || {
        echo "Missing custom destination. Re-run with --agent custom --dest PATH." >&2
        exit 2
      }
    fi
    install_one custom "custom agent"
    ;;
  codex)
    install_one codex "Codex"
    ;;
  claude)
    install_one claude "Claude-compatible"
    ;;
  agents)
    install_one agents "Generic / OpenAI Agents"
    ;;
  both)
    install_one codex "Codex"
    install_one claude "Claude-compatible"
    ;;
  *)
    echo "Unknown --agent value: ${AGENT}" >&2
    usage >&2
    exit 2
    ;;
esac

echo
echo "Setup complete. Next: open a project repo in your agent and type:"
echo "Use \$delivery-kit-setup to configure this repository for the Agent Delivery Kit."
