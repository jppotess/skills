---
name: coderabbit-gate
description: Run and triage a local CodeRabbit CLI review of the current Git branch or working tree. Use when the user asks for $coderabbit-gate, asks for a CodeRabbit review, or when $ship-pr or an agent workflow wants local review findings before PR packaging, pushing, or updating a pull request.
---

# CodeRabbit Gate

Use this skill as a review helper. Produce actionable findings, fix serious issues when asked or when invoked by `$ship-pr`, and avoid churn from nits. Do not treat this as a PR packaging workflow.

## Setup Checks

1. Confirm repository state:

   ```bash
   git status --short --branch
   ```

2. Find the CLI command:

   ```bash
   command -v cr
   ```

   If `cr` is unavailable, try:

   ```bash
   command -v coderabbit
   ```

3. If neither command exists, skip the review, say CodeRabbit CLI is not installed, and do not block the caller unless CodeRabbit was explicitly required.

4. Check auth/setup when possible:

   ```bash
   cr auth status
   ```

   If that command is unavailable or failing, try:

   ```bash
   cr doctor
   ```

5. If auth/setup is unavailable, skip the review, report the reason, and do not block the caller unless CodeRabbit was explicitly required.

Use `cr` by default. If only `coderabbit` exists, use the equivalent `coderabbit` command.

## Gate Status Contract

Always leave an explicit local CodeRabbit CLI gate status. Use exactly one of:

- `coderabbit-gate ran: <command>`
- `coderabbit-gate skipped: CLI not installed`
- `coderabbit-gate skipped: auth/setup unavailable`
- `coderabbit-gate skipped: rate-limited or unavailable`
- `coderabbit-gate skipped: user did not approve paid usage`

Include the setup probe evidence:

- result of `command -v cr`
- result of `command -v coderabbit`
- auth/status command attempted, when a CLI exists

GitHub CodeRabbit app checks, review approvals, or PR status checks are separate signals. They do not satisfy this local CLI gate.

## Scope Selection

Choose one review scope:

1. If a PR base branch is known:

   ```bash
   cr --agent --base <base-branch>
   ```

2. If reviewing uncommitted work:

   ```bash
   cr --agent --type uncommitted
   ```

3. If reviewing both committed and uncommitted changes:

   ```bash
   cr --agent --type all
   ```

4. If only committed changes should be reviewed:

   ```bash
   cr --agent --type committed
   ```

When invoked by `$ship-pr`, run before the final push or PR create/update and prefer `--base <base-branch>` when the base branch is known.

## Running In Agent Environments

CodeRabbit reviews may take time. Run the review in the background when possible, poll periodically, capture output for triage, and do not assume the command is hung just because it is quiet. Do not spam repeated runs.

Do not enable paid usage-based reviews unless the user explicitly approved it. Do not run CodeRabbit from `pre-commit` as a blocking hook.

## Triage Rules

Prioritize fixes in this order:

1. Critical findings
2. Major findings
3. Security issues
4. Runtime errors
5. Data-loss risks
6. Broken user flows
7. Incorrect assumptions
8. Test gaps for changed behavior
9. Maintainability issues likely to cause real future bugs

Do not churn the diff for minor style preferences, trivial naming nits, subjective formatting comments, broad refactors unrelated to the PR, or suggestions that conflict with repo conventions.

When unsure, prefer minimal targeted fixes over broad rewrites.

## Fix Loop

Default loop:

1. Run CodeRabbit once.
2. Fix critical, major, security, runtime, or data-loss findings.
3. Run the smallest relevant deterministic checks.
4. Re-run CodeRabbit once at most.
5. Stop.

Do not run CodeRabbit more than twice unless the user explicitly asks.

If the second pass still has minor, trivial, or info findings, summarize them as non-blocking and stop.

If the second pass still has critical or major findings, fix them if clearly actionable. Otherwise, report them as blocked or non-actionable with a concrete reason.

## Output

Return a concise handoff with:

- local CodeRabbit CLI gate status, using one of the exact `coderabbit-gate ...` lines above
- whether CodeRabbit ran or skipped
- command and scope used
- setup probe evidence
- findings by severity
- fixes applied
- checks run after fixes
- whether a second pass was run
- remaining findings, if any
- whether the caller can proceed

For `$ship-pr` handoffs, include CodeRabbit status in the final PR summary. Update Flow Learnings only if CodeRabbit reveals a durable repo or process lesson.

Do not claim the branch is clean unless deterministic checks and relevant review gates support that.
