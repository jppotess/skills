# Agent Delivery Kit

Reusable agent skills for taking software work from spec to verified, review-ready delivery.

This is a small public bundle for Codex-first workflows with Claude-compatible metadata. The skills are intentionally workflow-oriented: they preserve the original request, keep reopening gaps, route review, package pull requests, and make the final delivery state explicit instead of stopping at plausible progress.

## Install

One-command install for Codex-compatible skill directories:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/main/install.sh | bash
```

From a local clone:

```bash
git clone https://github.com/jppotess/skills.git
cd skills
./install.sh
```

By default, skills are installed into `~/.codex/skills`. Override the destination when using another agent client or a custom skill root:

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

## Skills

| Skill | Use it for |
| --- | --- |
| `delivery-kit-setup` | Configure repo-local delivery, PR, review, evidence, and issue-tracker policy. |
| `spec-to-ship` | Take a coherent spec from kickoff to verified completion using `.zenith/` state and final gap review. |
| `delivery-autopilot` | Drive implementation work through context gathering, validation, review routing, handoff, and delivery classification. |
| `ship-pr` | Package, validate, push, create or update, and follow through on GitHub pull requests. |
| `coderabbit-gate` | Run and triage local CodeRabbit CLI review without blocking on missing tooling or low-value nits. |

## Quick Start

After installing, run the setup skill inside each project repo that should use the delivery workflow:

```text
Use $delivery-kit-setup to configure this repository for the delivery skill bundle.
```

For a larger implementation task with a written spec:

```text
Use $spec-to-ship with ./SPEC.md as the source of truth. Initialize .zenith/, derive acceptance criteria, implement in checkpoints, validate, run final gap review, then route delivery through review and PR packaging if needed.
```

For an issue or task that should be driven end to end:

```text
Use $delivery-autopilot on ISSUE-123 and run the appropriate review chain before PR handoff.
```

For PR packaging:

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
install.sh                      Portable installer
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
