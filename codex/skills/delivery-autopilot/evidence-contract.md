# Evidence Contract

Use this when UI/product/content layout changed or when screenshots/recordings are part of the review handoff.

## Capture Requirements

- Capture screenshots at reviewable resolution.
- Prefer full desktop width and real mobile viewport captures over tiny thumbnails.
- Use one image per important state or viewport.
- Avoid contact sheets unless each panel remains readable.
- Verify local files exist and inspect dimensions/file size before linking.
- Capture review screenshots with blocking overlays dismissed unless the overlay is the state under review.

## Durable Evidence Rule

Screenshots listed only as local filesystem paths are not enough for issue or PR review. Upload or embed the actual images when tools allow. If upload/embed is impossible, explicitly say `Local-only screenshot evidence`, explain why, and provide an alternate review path.

## Issue Tracker Evidence

- Prefer the issue tracker's attachment upload for actual image files.
- For larger screenshots, use the tracker's file upload flow when available and embed the returned durable URL.
- Do not rely on an issue tracker fetching private GitHub raw URLs.
- After updating the issue, re-open/list the comment and verify markdown includes durable URLs or attachments.
- If an image extraction/fetch tool is available, use it against the markdown before calling evidence complete.

## GitHub PR Evidence

- Prefer committed screenshot files under a stable path such as `audit/evidence/<issue-id>/`.
- In PR bodies, use GitHub repository-relative image paths that point at a stable base branch or commit.
- Do not use branch-scoped `raw.githubusercontent.com` URLs when the branch may be deleted after merge.
- If a PR is already merged, point evidence at the base/release branch or permanent commit SHA.
- After editing the PR body, re-fetch it and confirm it does not contain broken branch-scoped raw URLs.

## Recording Guidance

Use short recordings only for multi-step interactions, animations, onboarding, checkout, or flows where screenshots cannot show correctness. Prefer targeted screenshots plus exact routes when they are enough.
