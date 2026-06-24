# Review Routing Reference

Use this only when the compact routing rules in `SKILL.md` are not enough.

## Minimum Chain Policy

- Prefer one primary review lane plus any mandatory risk lane.
- Run security/risk review first when mandatory risk triggers are present.
- Add extra lanes only when they cover independent risk, not because they are available.
- Continue to `ship-pr` only after selected review lanes pass or are explicitly not needed.
- If the chain becomes too long or uncertain, stop with a decision-owner-ready packet.

## Lane Triggers

### Security / Risk Review

Use for auth, permissions, billing, webhooks, secrets, user data, tenant boundaries, admin surfaces, destructive operations, migrations/RLS, uploads, email/invites, user-to-user contact flows, visibility/reveal controls, privacy education, trial/credit/usage limits, model-spend guardrails, generation/regeneration rate limits, analytics containing sensitive context, cron/background workers, production observability, or external credentials.

For trial/credit/usage/model-spend/rate-limit work, the handoff must state whether the guardrail is atomic and idempotent under concurrent direct API calls before spend.

Use formal Codex Security skills only when the user asks for a security scan/code review or the trust-boundary change is high-risk enough that product-risk review is not sufficient.

### Design / Product Review

Use for UI/product surfaces, onboarding, dashboards, navigation, forms, public pages, product clarity, launch readiness, layout, or design systems.

### Content / Editorial Review

Use for product copy, docs, marketing, articles, emails, help content, onboarding text, operator artifacts, or writing where clarity, tone, proof, usefulness, or non-AI voice matters.

### Functional QA Review

Use for user flows, interactive behavior, state transitions, forms, routing, auth behavior, data behavior, dashboards, public pages, or browser walkthroughs.

### Accessibility Review

Use for complex UI, forms, modals, navigation, dashboard/public-page changes, mobile/responsive changes, or when automated checks flag accessibility risk.

Small UI changes may use an accessibility sub-check inside Design/Product or Functional QA if the risk is narrow.

### Refactor / Cleanup Review

Use when the task is primarily cleanup, refactor, dead-code removal, module boundaries, naming, internal maintainability, or behavior preservation.

### PR Skill

Use when branch packaging, PR creation/update, release path, checks, or review-thread follow-through is needed.

### Decision Owner

Use only when a genuine product/taste/commercial/security/release/risk-tolerance tradeoff remains. Isolate the exact question, options, tradeoffs, recommendation, and consequences.

## Handoff Completeness Gate

Before review, the handoff must include:

- what changed and why
- routes/URLs/start command or preview
- affected surfaces and states
- validation commands and manual checks
- UI evidence attached or embedded when relevant
- yes/no reasons for every review lane
- risk notes for permissions, privacy, spend, atomicity, idempotency, or data boundaries when relevant
- chain selected/executed/skipped when self-routing was requested
- repair packet if a review failed

If any required evidence is missing and still feasible, fix the handoff before claiming done.

## Bounce-Back Repair Packet

When review fails, include:

- exact problem
- why it matters
- route/state/screenshot/evidence
- required fix
- re-test/re-review steps
- suggested next review lane

The next implementation worker should be able to act without re-explanation from the user or decision owner.
