# Installation

Agent Delivery Kit skills live under `codex/skills` and can be installed into any compatible skill root.

## Codex

Install from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.0/install.sh | bash
```

Install from a clone:

```bash
git clone https://github.com/jppotess/skills.git
cd skills
./install.sh
```

The default destination is:

```text
~/.codex/skills
```

## Custom Skill Roots

Use `--dest` for another local agent runtime:

```bash
./install.sh --dest ~/.agents/skills
./install.sh --dest /path/to/agent/skills
```

Environment variables also work:

```bash
CODEX_SKILLS_DIR=/path/to/skills ./install.sh
AGENT_SKILLS_DIR=/path/to/skills ./install.sh
```

## Claude-Compatible Clients

The repository includes `.claude-plugin/plugin.json`:

```json
{
  "name": "agent-delivery-kit",
  "skills": [
    "./codex/skills/delivery-kit-setup",
    "./codex/skills/spec-to-ship",
    "./codex/skills/delivery-autopilot",
    "./codex/skills/ship-pr",
    "./codex/skills/coderabbit-gate"
  ]
}
```

Clients that understand this manifest can load the same skill folders without maintaining separate copies.

## Verify An Install

List installed folders:

```bash
ls ~/.codex/skills
```

Dry-run the installer:

```bash
./install.sh --dry-run
```

Validate the source checkout:

```bash
scripts/validate-skills.sh
```
