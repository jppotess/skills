# Installation

Agent Delivery Kit skills live under `codex/skills` and can be installed into any compatible skill root.

## Guided Setup

Use guided setup when you want to choose the target agent interactively:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.2/setup.sh | bash
```

The menu offers:

```text
1) Codex (~/.codex/skills)
2) Claude-compatible (~/.claude/skills)
3) Generic / OpenAI Agents (~/.agents/skills)
4) Codex + Claude-compatible
5) Custom path
```

From a clone:

```bash
git clone https://github.com/jppotess/skills.git
cd skills
./setup.sh
```

Non-interactive setup:

```bash
./setup.sh --agent codex
./setup.sh --agent claude
./setup.sh --agent agents
./setup.sh --agent both
./setup.sh --agent custom --dest /path/to/agent/skills
```

## Direct Install

Use `install.sh` when you already know the destination path. By default, it installs into `~/.codex/skills`:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.2/install.sh | bash
```

Override the destination:

```bash
./install.sh --dest ~/.codex/skills
./install.sh --dest ~/.claude/skills
./install.sh --dest ~/.agents/skills
./install.sh --dest /path/to/agent/skills
```

Setup and install only copy skill folders into your agent's skill directory. They do not configure a product repo and they do not start a workflow by themselves.

After install, open the project repo you want the agent to work on and type:

```text
Use $delivery-kit-setup to configure this repository for the Agent Delivery Kit.
```

Then use [Getting started](getting-started.md) for the normal run-through.

Environment variables also work:

```bash
CODEX_SKILLS_DIR=/path/to/skills ./install.sh
AGENT_SKILLS_DIR=/path/to/skills ./install.sh
AGENT_DELIVERY_KIT_REF=v0.1.2 ./setup.sh --agent codex
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
./setup.sh --agent both --dry-run
```

Validate the source checkout:

```bash
scripts/validate-skills.sh
```
