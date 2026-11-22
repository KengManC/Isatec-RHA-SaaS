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

### Added
- Dashboard `[RHA] Junda Smells` (`dashboards/junda-smells/`): standard host (CPU, memory, disk,
  network, load) and service (requests, response time, failures) metrics.
- Notebook `[RHA] Claude's Default Testing Notebook` (`notebooks/claude-default-testing/`): table of
  JustGo_mobile 1-minute windows where avg view duration per OS exceeds 30 s, with the top 5
  slowest `justgo`-tagged services in each window.
- GitHub Actions: PR checks (validation, changelog check, `dtctl diff` comment), deploy on merge
  to `main`, nightly backup to the `backups` branch, daily drift check.
- `CHANGELOG.md`, pull request template, `CODEOWNERS` and Dependabot configuration.

## [0.1.0] - 2026-11-22

### Added
- Claude Code project setup: `CLAUDE.md`, shared permission rules, folder layout
  (`dashboards/`, `notebooks/`, `workflows/`, `apps/`, `scripts/`).
- Cloud session startup hook (`scripts/session-start.sh`) that configures dtctl for rha75589.

[Unreleased]: https://github.com/KengManC/Isatec-RHA-SaaS/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/KengManC/Isatec-RHA-SaaS/releases/tag/v0.1.0
