# Support Skill Router

Use this only when a task needs domain tooling or platform guidance outside the core product-engineering review lanes.

## Method And Verification

- Tests for changed behavior: use repo-specific test instructions first; otherwise use a testing skill if available.
- Unexpected bugs or test failures: use systematic debugging guidance if available.
- Before claiming substantial work complete: use verification-before-completion guidance if available.
- Worktree isolation: use worktree guidance when a separate branch/worktree is part of the task and such guidance is available.

## UI / Browser / Visual Work

- Browser interaction or localhost inspection: use available browser/playwright tooling.
- Visual evidence or screenshots: use available visual QA tooling or this skill's `evidence-contract.md`.
- New frontend apps or large visual builds: use available frontend-app-builder guidance.
- React/Next/component quality: use matching React/Next/Vercel guidance when available and central to the task.

## Data / Database / Billing

- Supabase tasks: use Supabase guidance when available.
- Postgres/schema/query performance: use Postgres best-practice guidance when available.
- RLS/security policy work: use RLS guardrail guidance when available.
- Drizzle migrations: use Drizzle migration guidance when available.
- Stripe/billing: use Stripe or payments guidance when available.

## AI / Content / Communications

- OpenAI API/product-doc work: use official OpenAI docs or OpenAI API guidance when available.
- Vercel AI SDK/Gateway/UI: use matching Vercel AI guidance when available.
- Email product work: use email/resend/react-email guidance when available.
- Gmail, Slack, Notion, or other app work: use the matching app/tool only when the task explicitly involves that app.

## Product-Specific Local Skills

When working inside a product repo, prefer repo-local skills and instructions over this generic router.
