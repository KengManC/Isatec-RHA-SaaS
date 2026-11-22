# Changelog

All notable changes to this repository and to the `[RHA] ` resources it deploys to
Dynatrace **rha75589** are recorded here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
uses [Semantic Versioning](https://semver.org/) for release tags (`vMAJOR.MINOR.PATCH`).

Every pull request adds a line under **[Unreleased]** (CI enforces this; label the PR
`skip-changelog` for pure housekeeping). When cutting a release, rename **[Unreleased]** to the
version and date, start a new empty **[Unreleased]**, and tag the merge commit.

Sections: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.

## [Unreleased]

### Changed
- Notebook `[RHA] Claude's Default Testing Notebook`: simplified both tiles (real and mock) to list each
  minute where a JustGo_mobile OS averaged over 30 s, with only `Time start`, `avg_ms` and `OS`.

### Fixed
- Notebook `[RHA] Claude's Default Testing Notebook`: breach tile now uses the chart's own
  `makeTimeseries` average and a nanosecond threshold, so minutes over 30 s show up; default timeframe 24 h.
- Notebook `[RHA] Claude's Default Testing Notebook`: breach table returned nothing because view
  durations were divided by 1,000,000 even when already in ms; units are now detected, the default
  timeframe is 7 days, and services are matched to the breach even when Dynatrace widens the interval.
- PR checks: `dt-diff` no longer fails when a resource has changes (`dtctl diff` exit code 1
  tripped `bash -e`), which also kept Claude PRs from auto-merging.

### Added
- Notebook `[RHA] Claude's Default Testing Notebook`: tile listing the 3 slowest `JustGo`-tagged services
  (avg response time and request count) in each 5-minute window where JustGo_mobile avg view duration
  exceeded 30 s; the breach tile now uses a 5-minute interval.
- Notebook `[RHA] Claude's Default Testing Notebook`: mock-data preview tile showing what the
  JustGo slow-view breach table looks like with breaches.
- Dashboard `[RHA] Junda Smells` (`dashboards/junda-smells/`): standard host (CPU, memory, disk,
  network, load) and service (requests, response time, failures) metrics.
- Notebook `[RHA] Claude's Default Testing Notebook` (`notebooks/claude-default-testing/`): table of
  JustGo_mobile 1-minute windows where avg view duration per OS exceeds 30 s, with the top 5
  slowest `justgo`-tagged services in each window.
- GitHub Actions: PR checks (validation, changelog check, `dtctl diff` comment), deploy on merge
  to `main`, nightly backup to the `backups` branch, daily drift check.
- `CHANGELOG.md`, pull request template, `CODEOWNERS` and Dependabot configuration.
- GitHub Actions: `auto-merge-claude.yml` approves and merges Claude Code PRs (author `KengManC`,
  Claude commit trailers, all PR checks green, no `.github/`/`scripts/`/`.claude/` changes) and
  dispatches the deploy; `deploy.yml` accepts a `before` input and merges its own stamp-IDs PR.

## [0.1.0] - 2026-11-22

### Added
- Claude Code project setup: `CLAUDE.md`, shared permission rules, folder layout
  (`dashboards/`, `notebooks/`, `workflows/`, `apps/`, `scripts/`).
- Cloud session startup hook (`scripts/session-start.sh`) that configures dtctl for rha75589.

[Unreleased]: https://github.com/KengManC/Isatec-RHA-SaaS/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/KengManC/Isatec-RHA-SaaS/releases/tag/v0.1.0
