#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

status=0
EXPECTED_SKILLS=(
  delivery-kit-setup
  spec-to-ship
  delivery-autopilot
  ship-pr
  coderabbit-gate
)

validate_skill() {
  local skill_file="$1"
  local name
  local description

  if [[ "$(sed -n '1p' "${skill_file}")" != "---" ]]; then
    echo "FAIL ${skill_file}: missing opening frontmatter delimiter" >&2
    status=1
    return
  fi

  if ! sed -n '2,20p' "${skill_file}" | grep -qx -- "---"; then
    echo "FAIL ${skill_file}: missing closing frontmatter delimiter in first 20 lines" >&2
    status=1
    return
  fi

  name="$(sed -n '2,20p' "${skill_file}" | sed -n 's/^name:[[:space:]]*//p' | head -n 1 | tr -d '"')"
  description="$(sed -n '2,20p' "${skill_file}" | sed -n 's/^description:[[:space:]]*//p' | head -n 1 | tr -d '"')"

  if [[ -z "${name}" ]]; then
    echo "FAIL ${skill_file}: missing name" >&2
    status=1
  elif [[ ! "${name}" =~ ^[a-z0-9-]+$ ]]; then
    echo "FAIL ${skill_file}: invalid name '${name}'" >&2
    status=1
  fi

  if [[ -z "${description}" ]]; then
    echo "FAIL ${skill_file}: missing description" >&2
    status=1
  elif [[ "${description}" == *"<"* || "${description}" == *">"* ]]; then
    echo "FAIL ${skill_file}: description cannot contain angle brackets" >&2
    status=1
  fi
}

while IFS= read -r skill_file; do
  validate_skill "${skill_file}"
done < <(find "${REPO_ROOT}/codex/skills" -name SKILL.md -type f | sort)

mapfile -t actual_skills < <(find "${REPO_ROOT}/codex/skills" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
mapfile -t expected_skills < <(printf '%s\n' "${EXPECTED_SKILLS[@]}" | sort)

if [[ "${actual_skills[*]}" != "${expected_skills[*]}" ]]; then
  echo "FAIL codex/skills: expected bundle does not match actual directories" >&2
  echo "Expected: ${expected_skills[*]}" >&2
  echo "Actual:   ${actual_skills[*]}" >&2
  status=1
fi

if [[ -f "${REPO_ROOT}/.claude-plugin/plugin.json" ]]; then
  python3 - "${REPO_ROOT}" <<'PY'
import json
import pathlib
import sys

repo = pathlib.Path(sys.argv[1])
manifest = repo / ".claude-plugin" / "plugin.json"
data = json.loads(manifest.read_text())

if not data.get("name"):
    raise SystemExit("FAIL .claude-plugin/plugin.json: missing name")

skills = data.get("skills")
if not isinstance(skills, list) or not skills:
    raise SystemExit("FAIL .claude-plugin/plugin.json: missing skills list")

for skill in skills:
    path = (repo / skill).resolve()
    if not path.is_dir():
        raise SystemExit(f"FAIL .claude-plugin/plugin.json: missing skill dir {skill}")
    if not (path / "SKILL.md").is_file():
        raise SystemExit(f"FAIL .claude-plugin/plugin.json: missing SKILL.md for {skill}")
PY
fi

python3 - "${REPO_ROOT}" <<'PY'
import pathlib
import sys

repo = pathlib.Path(sys.argv[1])
forbidden_terms = [
    "FrontierNomad",
    "Frontier Nomad",
    "agent-skills.git",
    "setup-delivery-skills",
    "zenith-runner",
    "Zenith Runner",
    "autonomous-delivery",
    "Autonomous Delivery",
    "coderabbit-review",
    "CodeRabbit Review",
    "/Users/",
    "OpenClaw",
    "openclaw",
    "Jerry",
    "DiveJourney",
    "ShipFoundry",
    "Kitecraft",
    "Shippopotamus",
    "FRO-",
]

skip_dirs = {".git", "node_modules", ".venv", "venv", ".publish"}
skip_files = {repo / "scripts" / "validate-skills.sh"}
matches = []

for path in sorted(repo.rglob("*")):
    if any(part in skip_dirs for part in path.parts):
        continue
    if path in skip_files or not path.is_file():
        continue
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue
    for term in forbidden_terms:
        if term in text:
            matches.append((path.relative_to(repo), term))

if matches:
    for rel, term in matches:
        print(f"FAIL public-safety: {rel} contains stale/private term {term!r}", file=sys.stderr)
    raise SystemExit(1)
PY

if [[ "${status}" -ne 0 ]]; then
  exit "${status}"
fi

echo "Skill validation passed"
