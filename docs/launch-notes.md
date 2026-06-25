# Launch Notes

Use this copy when sharing the repo publicly.

## Short Description

Agent Delivery Kit is a portable skill bundle for taking software work from spec to verified, review-ready delivery.

## Social Post

I published Agent Delivery Kit, a small set of reusable agent skills for software delivery.

The core idea: coding agents do not usually fail because they cannot make progress. They fail because they stop too early.

This bundle gives Codex-compatible agents a stricter delivery loop:

- freeze the spec
- derive acceptance criteria
- keep reopening gaps
- verify independently
- route specialist review
- package the PR
- leave durable handoff evidence

It includes:

- `delivery-kit-setup`
- `spec-to-ship`
- `delivery-autopilot`
- `ship-pr`
- `coderabbit-gate`

The spec loop is inspired by Intelligent Internet's "From RALPH to Zenith" post on long-running agent harnesses:

https://ii.inc/web/blog/post/zenith-research

Repo:

https://github.com/jppotess/skills

Install:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.2/setup.sh | bash
```

## README Tagline Options

- Reusable skills for verified agent delivery.
- Skills for agents that need to finish, not just make progress.
- A delivery loop for software agents: spec, gaps, verification, review, PR.

## Suggested GitHub Description

Portable agent skills for taking software work from spec to verified, review-ready PR.

## Suggested GitHub Topics

```text
codex
agents
ai-agents
skills
developer-tools
github-pr
coderabbit
claude-compatible
```
