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
- Dashboard `[RHA] Dynatrace License consumption`: new section "DDU by host monitoring mode" with DDU for Full-Stack hosts,
  Infrastructure hosts and all hosts, hosts monitored, a per-mode summary (hosts, DDU per pool, included DDU, share, total
  row) with a donut, and a per-host table. Monitoring mode comes from the Entities API; the porting check now also checks it.
- Dashboard `[RHA] Dynatrace License consumption`: template for classic-licensed (DDU + DEM) environments. It shows DDU by pool,
  entity type, entity, metric key and host (vs. included per-host DDU), log/event/trace/serverless DDU sources, estimated DEM by
  capability, application and synthetic monitor, daily trends and a billing-metric availability check. Uses Metrics API v2
  code tiles, so tiles are empty in the DPS environment rha75589; see the folder README for porting steps.
- Dashboard `[RHA] Sean is Happy`: blue-themed overview with coloured single-value KPIs (response time,
  P90, requests, failure rate, CPU, memory, disk, open problems), service and host charts, a OneAgent
  configuration table and a threshold legend, with a "Sean is Happy" banner image at the top.

### Changed
- Notebook `[RHA] Claude's Default Testing Notebook`: both JustGo breach tiles show `User events`, the number
  of view events each `avg_ms` was calculated from.
- Notebook `[RHA] Claude's Default Testing Notebook`: top-3 JustGo services tile shows response time and
  request count in separate, sortable columns for each of the 3 services.
- Notebook `[RHA] Claude's Default Testing Notebook`: top-3 JustGo services tile grouped to one row per
  breach window, with the services side by side (`Slowest #1`–`#3`).
- Notebook `[RHA] Claude's Default Testing Notebook`: simplified both tiles (real and mock) to list each
  minute where a JustGo_mobile OS averaged over 30 s, with only `Time start`, `avg_ms` and `OS`.

### Fixed
- Dashboard `[RHA] Dynatrace License consumption`: the monitoring-mode section showed 0 DDU for Infrastructure hosts and
  "Included DDU" in the billions. It read billable DDU only (`metrics.byEntity`, after the host-unit allowance), the included
  figure was data points (`includedMetricPerHost`), and per-entity queries were cut at 1,000 of ~5,000 series. It now shows
  consumed DDU (`metrics.byEntityRaw`) and billable DDU side by side, uses `includedMetricDduPerHost`, and reads all series.
  The "Hosts: metric DDU vs included allowance" tile gets the same fixes.
- Dashboard `[RHA] Dynatrace License consumption`: "Top 25 metric keys by DDU" returned no records in a DDU environment
  because it split by `metric_key`, while the real dimension there is `Metric Key`. No tile names a dimension in its query any
  more (entity IDs and names are read from whatever dimensions a series has), sorting uses `value(auto, …)` because billing
  metrics only support `auto`/`value`, empty tables and charts now show the API's error or warning instead of "No records",
  and the porting check lists each metric's dimension keys and aggregations.
- Dashboard `[RHA] Dynatrace License consumption`: both daily trend charts showed "The field \"Day\" is no longer
  available" when billing data was returned, because ISO dates (`2026-11-24`) are read as timestamps, which a categorical
  bar chart can't use as its category. Days are now labelled `24 Nov ’26` and still sorted by date.
- Dashboard `[RHA] Dynatrace License consumption`: chart tiles showed "The field … is no longer available" when the
  timeframe had no billing data; they now show a zero-valued "No data in timeframe" row instead.
- Dashboard `[RHA] Dynatrace License consumption`: every code tile failed with "Return statement is not allowed here" because
  the tile code was not wrapped in `export default async function`; the tiles now run.
- Notebook `[RHA] Claude's Default Testing Notebook`: restored the column renames made directly in Dynatrace on
  the top-3 JustGo services tile (`Service #n`, `Response Time #n (ms)`, `Request Count #n`, `Avg_duration`),
  which the previous deploy overwrote.
- Notebook `[RHA] Claude's Default Testing Notebook`: breach tile now uses the chart's own
  `makeTimeseries` average and a nanosecond threshold, so minutes over 30 s show up; default timeframe 24 h.
- Notebook `[RHA] Claude's Default Testing Notebook`: breach table returned nothing because view
  durations were divided by 1,000,000 even when already in ms; units are now detected, the default
  timeframe is 7 days, and services are matched to the breach even when Dynatrace widens the interval.
- PR checks: `dt-diff` no longer fails when a resource has changes (`dtctl diff` exit code 1
  tripped `bash -e`), which also kept Claude PRs from auto-merging.

### Added
- Notebook `[RHA] Claude's Default Testing Notebook`: tile classifying JustGo_mobile failure windows as
  likely client connectivity vs application failure (RUM network/error signals + JustGo backend health),
  with proposed classification rules and false-positive handling.
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
