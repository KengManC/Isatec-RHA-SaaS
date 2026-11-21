# Isatec RHA SaaS — Dynatrace work

This repo holds dashboards, notebooks, workflows and custom apps for the Dynatrace SaaS environment **rha75589** (`https://rha75589.apps.dynatrace.com`).

## Layout
- `dashboards/<name>/` — dashboard JSON, pushed with `dtctl apply`
- `notebooks/<name>/` — notebook JSON
- `workflows/<name>/` — workflow YAML
- `apps/<app-name>/` — custom Dynatrace apps (App Toolkit / `dt-app`)
- `scripts/` — repo tooling (session start hook, worktree setup, `scripts/ci/` helpers for GitHub Actions)
- `.github/workflows/` — CI: `pr-checks.yml`, `deploy.yml`, `backup.yml`, `drift.yml`
- `CHANGELOG.md` — Keep a Changelog format

Each new piece of work gets its own folder in the matching area, on its own branch: `feature/<folder-name>`.

## How changes reach Dynatrace
1. Write or edit the definition in its folder on a `feature/<folder-name>` branch.
2. Run `dtctl diff -f <file>` (or note it is a new resource) and show the user.
3. Commit, push, open a PR. CI validates it and posts the Dynatrace diff as a comment.
4. On merge to `main`, `deploy.yml` applies it (snapshot first). New resources get their ID stamped back through an automatic follow-up PR, which must be merged.

Prefer this PR route. Only run `dtctl apply` from a session when the user explicitly asks for it, and still show the diff first.

## Rules
- Save dashboard/notebook/workflow definitions in this repo first. Never change live resources without the source being here.
- Run `dtctl diff` before `dtctl apply` and show the user what will change.
- Name Dynatrace resources created from this repo with the prefix `[RHA] `.
- Keep the `id` field in a definition once it has one, so applies update in place instead of creating duplicates.
- Every PR adds a line under `## [Unreleased]` in `CHANGELOG.md` (label `skip-changelog` only for pure housekeeping).
- Use conventional commit messages: `feat(dashboards): …`, `fix(workflows): …`, `chore(ci): …`.
- Never delete a Dynatrace resource unless the user asks; deleting a file does not delete the resource.
- Don't edit `.github/`, `scripts/` or `.claude/` unless the user asks for pipeline or setup changes.
- Use the dtctl context `rha75589`.
- Credentials come from environment variables (`DT_ENVIRONMENT`, `DT_PLATFORM_TOKEN`) in cloud sessions and CI, or `.claude/settings.local.json` (git-ignored) locally. Never print, log or commit tokens.
- Keep DQL queries efficient: filter early, use short time ranges.
