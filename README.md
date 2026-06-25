# Agent Delivery Kit

Reusable agent skills for taking software work from spec to verified, review-ready delivery.

This is a small public bundle for Codex-first workflows with Claude-compatible metadata. The skills are intentionally workflow-oriented: they preserve the original request, keep reopening gaps, route review, package pull requests, and make the final delivery state explicit instead of stopping at plausible progress.

## Install

Guided setup lets you choose Codex, Claude-compatible, generic agents, both Codex and Claude, or a custom skill root:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.2/setup.sh | bash
```

From a local clone:

```bash
git clone https://github.com/jppotess/skills.git
cd skills
./setup.sh
```

Non-interactive examples:

```bash
./setup.sh --agent codex
./setup.sh --agent claude
./setup.sh --agent both
./setup.sh --agent custom --dest /path/to/agent/skills
```

Direct Codex install is still available:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.2/install.sh | bash
```

Override the destination when using the direct installer:

```bash
./install.sh --dest ~/.codex/skills
./install.sh --dest ~/.agents/skills
CODEX_SKILLS_DIR=/path/to/skills ./install.sh
```

Inspect what would be installed:

```bash
./install.sh --dry-run
./install.sh --list
```

## Start Here: Normal Run-Through

Installing this repo only makes the skills available to your agent. You use them by opening a real project repo in Codex or another skill-aware agent and typing prompts like `Use $delivery-kit-setup ...`.

Normal flow:

1. Install the skills once.
2. Open the product/project repo you want the agent to work on.
3. Run `$delivery-kit-setup` once in that repo so the agent writes local policy docs for PR bases, checks, issue states, evidence, and review rules.
4. For a scoped feature or bug with a written spec, run `$spec-to-ship`.
5. For an issue you want driven through implementation and review routing, run `$delivery-autopilot`.
6. When code is ready for GitHub review, run `$ship-pr`.
7. `$coderabbit-gate` runs inside the PR flow when CodeRabbit CLI is available, or you can invoke it directly.

Copy/paste first prompt inside your project repo:

```text
Use $delivery-kit-setup to configure this repository for the Agent Delivery Kit. Infer what you can from the repo, create concise docs under docs/agents/ if that fits the repo, and tell me what assumptions remain.
```

Then use one of these:

```text
Use $spec-to-ship with ./SPEC.md as the source of truth. Initialize .zenith/, derive acceptance criteria, implement in checkpoints, validate, run final gap review, then route delivery through review and PR packaging if needed.
```

```text
Use $delivery-autopilot on ISSUE-123 and run the appropriate review chain before PR handoff.
```

```text
Use $ship-pr to package the current branch into the correct GitHub PR and make the handoff review-ready.
```

Full walkthrough: [Getting started](docs/getting-started.md).

## Skills

| Skill | Use it for |
| --- | --- |
| `delivery-kit-setup` | Configure repo-local delivery, PR, review, evidence, and issue-tracker policy. |
| `spec-to-ship` | Take a coherent spec from kickoff to verified completion using `.zenith/` state and final gap review. |
| `delivery-autopilot` | Drive implementation work through context gathering, validation, review routing, handoff, and delivery classification. |
| `ship-pr` | Package, validate, push, create or update, and follow through on GitHub pull requests. |
| `coderabbit-gate` | Run and triage local CodeRabbit CLI review without blocking on missing tooling or low-value nits. |

## Short Examples

Configure a repo:

```text
Use $delivery-kit-setup to configure this repository for the delivery skill bundle.
```

Run a spec:

```text
Use $spec-to-ship with ./SPEC.md as the source of truth. Initialize .zenith/, derive acceptance criteria, implement in checkpoints, validate, run final gap review, then route delivery through review and PR packaging if needed.
```

Drive an issue:

```text
Use $delivery-autopilot on ISSUE-123 and run the appropriate review chain before PR handoff.
```

Package a PR:

```text
Use $ship-pr to package the current branch into the correct GitHub PR and make the handoff review-ready.
```

## Platform Notes

`codex/skills` is the source of truth. Codex can install these folders directly into `~/.codex/skills`.

Claude-compatible clients can read `.claude-plugin/plugin.json`, which points at the same skill folders. Other agent clients can install the same directories into their own skill/plugin root with `./install.sh --dest <path>` or by copying `codex/skills/<skill-name>`.

The bundle assumes Git and works best with GitHub pull requests, but team-specific policy belongs in each target project. Use `$delivery-kit-setup` to create repo-local docs for base branches, required checks, issue-tracker states, evidence expectations, and optional review tools.

## Why This Exists

Most coding agents can make progress. The harder problem is getting them to continue until the original requirement is actually satisfied and the next reviewer can trust the handoff.

The delivery loop here is built around five habits:

- preserve the original spec and current delivery state
- repeatedly compare the artifact against the requirement
- keep plans revisable as the repo teaches the agent what is true
- verify with commands, artifacts, review lanes, and PR evidence
- stop only when the delivery state supports the claim

`spec-to-ship` is inspired by Intelligent Internet's post [From RALPH to Zenith: Designing harnesses for long-running agents](https://ii.inc/web/blog/post/zenith-research), which frames long-horizon agent work as a harness/control-loop problem.

## Documentation

- [Installation](docs/installation.md)
- [Getting started](docs/getting-started.md)
- [Skill reference](docs/skill-reference.md)
- [Publication review](docs/publication-review.md)
- [Launch notes](docs/launch-notes.md)

## Validate

Run:

```bash
scripts/validate-skills.sh
```

The validator checks skill frontmatter, the Claude plugin manifest, expected bundle paths, and public-safety terms that should not appear in reusable skills.

## Repository Layout

```text
codex/skills/<skill-name>/      Skill source of truth
.claude-plugin/plugin.json      Claude-compatible bundle manifest
setup.sh                        Guided setup for common agents
install.sh                      Direct installer
scripts/                        Validation and compatibility helpers
docs/                           Public docs and launch notes
```

## Public Scope

This repository is intentionally limited to the public delivery bundle:

- `delivery-kit-setup`
- `spec-to-ship`
- `delivery-autopilot`
- `ship-pr`
- `coderabbit-gate`

Keep reusable skills free of local machine paths, secrets, private repo URLs, and one-company-only assumptions. Put project or team policy in repo-local docs created by `$delivery-kit-setup`, not in the global skill bodies.

If you are publishing from a source repo that previously contained private skills, publish from a clean initial commit so removed files are not exposed through Git history.

## License

MIT. See [LICENSE](LICENSE).
