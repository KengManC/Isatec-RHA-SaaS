# Isatec RHA SaaS — Dynatrace work

This repo holds dashboards, notebooks, workflows and custom apps for the Dynatrace SaaS environment **rha75589** (`https://rha75589.apps.dynatrace.com`).

## Layout
- `dashboards/<name>/` — dashboard JSON, pushed with `dtctl apply`
- `notebooks/<name>/` — notebook JSON
- `workflows/<name>/` — workflow YAML
- `apps/<app-name>/` — custom Dynatrace apps (App Toolkit / `dt-app`)
- `scripts/` — repo tooling (e.g. the worktree setup script)

Each new piece of work gets its own folder in the matching area, on its own branch: `feature/<folder-name>`.

## Rules
- Save dashboard/notebook/workflow definitions in this repo first, then push them to Dynatrace with `dtctl apply`. Never change live resources without the source being here.
- Run `dtctl diff` before `dtctl apply` and show the user what will change.
- Name Dynatrace resources created from this repo with the prefix `[RHA] `.
- Use the dtctl context `rha75589`.
- Credentials come from `.claude/settings.local.json` (git-ignored). Never print, log or commit tokens.
- Keep DQL queries efficient: filter early, use short time ranges.
