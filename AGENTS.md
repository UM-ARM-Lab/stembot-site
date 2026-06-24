# Repository Instructions

## Project

This repository contains the paper website for **“STEMbot: A Compliant Robot for
Under-Canopy Plant Navigation.”** The paper has been accepted to IROS 2026. The
work is associated with a pending provisional patent, so treat unpublished
technical and legal details as sensitive.

The current site is adapted from the Nerfies academic-project template. Replace
template content deliberately and preserve attribution or license notices where
required.

## Persistent Project Memory

Use `docs/wiki/` as the repository's persistent project memory.

Before substantive work:

1. Read `docs/wiki/index.md`.
2. Follow links to the pages relevant to the task.
3. Check repository files or other primary sources when the wiki is incomplete
   or when exact wording, values, dates, or implementation details matter.

After substantive work, add concise, reusable knowledge to the wiki. Do not use
the wiki as a transcript or scratchpad.

## Wiki Organization

- `docs/wiki/index.md` is the table of contents and entry point. Keep it current
  whenever pages are added, renamed, or removed.
- `docs/wiki/log.md` is an append-only chronology of meaningful decisions,
  discoveries, and changes. Add dated entries in `YYYY-MM-DD` format, newest
  first.
- Use focused, descriptive Markdown filenames such as `project-overview.md`,
  `site-structure.md`, or `deployment.md`.
- Prefer updating an existing page over creating overlapping pages.
- Link related pages with relative Markdown links.

## Sources and Confidence

- Distinguish confirmed facts from assumptions, proposals, and items awaiting
  verification.
- Prefer primary sources: the accepted manuscript, supplemental material,
  author-provided assets, official conference material, and repository files.
- When summarizing a source, identify it and record its date or version when
  known. Preserve exact quotations only when wording is important.
- If sources conflict, do not silently choose one. Record the conflict, favor
  the most authoritative and recent source, and flag it for author review.
- Use exact dates for chronology. Do not infer event order from file timestamps
  alone.

## Confidentiality and Publication Safety

- Do not add patent claims, invention disclosures, unpublished implementation
  details, private reviewer correspondence, credentials, personal contact
  information, or embargoed assets unless the user explicitly authorizes their
  publication.
- Treat “pending provisional patent” as a sensitivity warning, not as permission
  to describe the invention beyond author-approved public material.
- Before exposing new technical claims or downloadable files on the public
  website, verify that they already appear in an approved public source or have
  explicit author approval.
- Do not provide legal conclusions about patent status. Preserve the exact
  author-approved wording of patent notices.
- Never place secrets in source files, client-side JavaScript, commit history,
  or the wiki.

## Editing the Website

- Keep claims, metrics, author names, affiliations, links, acknowledgments, and
  citation text faithful to approved sources.
- Do not invent placeholder facts. Mark missing content clearly for author
  review.
- Keep the site usable on mobile and desktop, preserve semantic HTML and
  accessibility, and provide useful alt text or captions for visual media.
- Optimize large images and videos for the web without overwriting archival
  originals.
- Remove inherited Nerfies analytics IDs, links, metadata, media, and copy
  unless intentionally retained and properly attributed.
- Make focused changes and avoid unrelated rewrites.

## Validation

For changes within scope:

- Inspect the rendered page at common desktop and mobile widths when practical.
- Check local links, asset paths, page metadata, and browser-console errors.
- Run available formatters, linters, or tests relevant to changed files.
- Search for stale template terms and accidental sensitive content before a
  release.

## Git Commit Workflow

Commit completed work to Git unless the user explicitly asks not to commit.
Keep every commit atomic: it should contain one coherent change and leave the
repository in a valid state.

Before committing:

1. Review `git status` and the complete diff.
2. Separate unrelated work into distinct commits when needed.
3. Stage only files or hunks created for the current task. Never include
   pre-existing user changes, generated artifacts, secrets, or unrelated
   untracked files.
4. Run the relevant validation and `git diff --cached --check`.
5. Review the staged diff before creating the commit.

Use a concise imperative commit subject beginning with `[codex]`, for example:

```text
[codex] Add project wiki policy
```

Do not amend, rewrite, squash, delete, or force-push existing history unless the
user explicitly requests it. After completing and validating the task, push
new commits to the current branch's configured remote unless the user
explicitly asks not to push. Use a normal push; never force-push.

## Wiki Maintenance Check

Before finishing substantive work:

1. Update the relevant wiki page with durable knowledge.
2. Update `docs/wiki/index.md` if wiki structure changed.
3. Add a concise entry to `docs/wiki/log.md`.
4. Ensure the wiki contains no secrets or restricted patent material.
