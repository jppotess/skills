# Getting Started

This repo gives your agent reusable skills. It is not a standalone CLI workflow.

After installation, you still work inside Codex, Claude, or another skill-aware agent. You open the project repo you want changed, then tell the agent to use one of the installed skills.

## The Normal Flow

```text
install skills once
open your project repo in the agent
run $delivery-kit-setup once per repo
run $spec-to-ship or $delivery-autopilot for the work
run $ship-pr when the branch should become a GitHub PR
```

## 1. Install Once

Recommended installer:

```bash
npx skills@latest add jppotess/skills
```

In the installer, choose the agent or agents you use. Install all five skills for the full workflow, or at minimum install `delivery-kit-setup` plus the work skill you want to use.

For Codex, this installs skills under:

```text
~/.codex/skills/delivery-kit-setup
~/.codex/skills/spec-to-ship
~/.codex/skills/delivery-autopilot
~/.codex/skills/ship-pr
~/.codex/skills/coderabbit-gate
```

Fallback setup without `skills.sh`:

```bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.3/setup.sh | bash
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.3/setup.sh | bash -s -- --agent claude
curl -fsSL https://raw.githubusercontent.com/jppotess/skills/v0.1.3/setup.sh | bash -s -- --agent custom --dest /path/to/agent/skills
```

## 2. Open A Real Project Repo

Do not run the workflow inside this `skills` repo unless you are editing the skills themselves.

Open the app, library, or service repo where you want the agent to work. The skills inspect that repo's Git state, docs, package scripts, PR template, and issue/review conventions.

## 3. Configure That Repo Once

First prompt to type inside the target project repo:

```text
Use $delivery-kit-setup to configure this repository for the Agent Delivery Kit. Infer what you can from the repo, create concise docs under docs/agents/ if that fits the repo, and tell me what assumptions remain.
```

Expected result:

- The agent inspects `git status`, remotes, repo instructions, PR templates, and existing docs.
- It creates or updates repo-local guidance such as `docs/agents/delivery.md`, `docs/agents/pr-policy.md`, `docs/agents/review-routing.md`, and `docs/agents/evidence.md`.
- It tells you what it inferred and what decisions still need human input.

You usually do this once per repo, then future runs reuse those local docs.

## 4. Pick The Right Work Skill

Use `$spec-to-ship` when you have a coherent written spec, product brief, migration plan, or feature description.

```text
Use $spec-to-ship with ./SPEC.md as the source of truth. Initialize .zenith/, derive acceptance criteria, implement in checkpoints, validate, run final gap review, then route delivery through review and PR packaging if needed.
```

Expected result:

- The agent freezes the spec in `.zenith/SPEC.lock.md`.
- It derives acceptance criteria and a milestone plan.
- It implements in bounded passes.
- It records validators and progress in `.zenith/`.
- It performs final gap review before claiming the spec is satisfied.
- If GitHub PR delivery is needed, it hands off to review routing and `$ship-pr`.

Use `$delivery-autopilot` when you have an issue, ticket, or task and want the agent to keep driving through implementation, validation, review routing, and handoff.

```text
Use $delivery-autopilot on ISSUE-123 and run the appropriate review chain before PR handoff.
```

Expected result:

- The agent gathers context from the repo and issue if tools are available.
- It implements what is safely in scope.
- It validates with repo-native checks.
- It selects review lanes only when they add value.
- It leaves a handoff with delivery classification: local complete, review routed, ready to release, done, or blocked.

Use `$ship-pr` when the branch should become or update a GitHub PR.

```text
Use $ship-pr to package the current branch into the correct GitHub PR and make the handoff review-ready.
```

Expected result:

- The agent checks the actual branch, base branch, and existing PR state.
- It runs appropriate local checks.
- It fills the repo's PR template.
- It runs `$coderabbit-gate` when CodeRabbit CLI is available or required.
- It pushes the branch and creates or updates the PR.
- It inspects checks/review threads and reports what remains.

Use `$coderabbit-gate` directly only when you specifically want a local CodeRabbit CLI pass:

```text
Use $coderabbit-gate to run a local CodeRabbit review for the current branch.
```

## Common Run-Throughs

### New Repo Setup

```text
Use $delivery-kit-setup to configure this repository for the Agent Delivery Kit. Keep the docs concise and generic to this repo's actual workflow.
```

Then commit the generated repo-local docs if they look right.

### Spec To PR

Create `SPEC.md` in your project repo, then type:

```text
Use $spec-to-ship with ./SPEC.md as the source of truth. Take this from implementation through validation and PR packaging if repo policy says PRs are required.
```

If the agent stops at `Local Complete`, type:

```text
Use $ship-pr to package the current branch into a review-ready GitHub PR.
```

### Issue To Review

```text
Use $delivery-autopilot on ISSUE-123. Implement the issue, validate it, run the appropriate review chain, and use $ship-pr if a GitHub PR is required.
```

### Existing Branch To PR

```text
Use $ship-pr to inspect this branch, choose the correct PR base from repo context, run the required checks, create or update the PR, and report the current check/review state.
```

## What Good Output Looks Like

A good final handoff should tell you:

- what changed
- what files or surfaces matter
- what validation ran and what failed
- whether screenshots or other evidence exist when relevant
- whether review routing happened
- whether a PR exists
- whether the state is `Local Complete`, `Review Routed`, `Ready to Release`, `Done`, or `Blocked`
- the next exact action if anything remains

## Troubleshooting

If the agent says it cannot find the skill, confirm the install destination:

```bash
ls ~/.codex/skills
```

If you use a non-Codex runtime, install into that runtime's skill directory:

```bash
./install.sh --dest /path/to/agent/skills
```

If the agent installed the skills but still does not behave differently, restart the agent session or confirm your client supports local skill discovery.

If you are not sure which skill to use, start with:

```text
Use $delivery-autopilot for this task. If the repo needs delivery policy first, run $delivery-kit-setup before implementation.
```
