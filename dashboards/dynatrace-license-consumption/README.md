# [RHA] Dynatrace License consumption

A dashboard **template** for environments on the classic licensing model:
**Davis Data Units (DDU)** and **Digital Experience Monitoring (DEM)** units.

rha75589 runs on a Dynatrace Platform Subscription (DPS), so its `builtin:billing.*` classic billing metrics are empty and the
tiles show no data here. The dashboard is built to be exported and imported into the classic-licensed environment.

## What it shows

| Section | Tiles |
|---|---|
| Summary | Total DDU, metric DDU, estimated DEM, Session Replay share, DDU by pool, DEM by capability (chart + table) |
| Daily trend | DDU per day by pool, estimated DEM per day (RUM / Session Replay / Synthetic) |
| DDU: metrics | Metric DDU by entity type, top 25 entities, top 25 metric keys (built-in / calculated / extension / custom), top 50 hosts with metric DDU consumed, included (`includedMetricDduPerHost`) and billable |
| DDU: other pools | Top entities and sources for Log Monitoring, Events, Traces and Serverless DDU |
| Host units by monitoring mode | **Estimated** host units for Full-Stack hosts, Infrastructure hosts and all hosts, next to the connected host units Dynatrace reports; a donut by mode; a per-mode summary (hosts, hosts consuming, RAM, host units, share, Total row, plus Dynatrace's connected and assigned host units); and every host with mode, state, RAM and host units. Hosts seen in the 2 h before the end of the dashboard timeframe, from the Entities API (`environment-api:entities:read`) |
| DEM | Estimated DEM per web / mobile / custom application (sessions, replay sessions, user action properties), top 10 apps, synthetic monitors (browser actions, HTTP requests, third-party results) |
| Porting check | Each billing metric the dashboard uses, with a status: OK, no data, or not available |

## How it works

* Every data tile is a **code tile** that calls the classic **Metrics API v2** (`@dynatrace-sdk/client-classic-environment-v2`).
  Classic billing metrics aren't in Grail, so DQL tiles can't show them. This also means the dashboard works without Grail.
* The tiles follow the dashboard timeframe. Dashboards pass it to each code tile as `context.$dt_timeframe_from` /
  `$dt_timeframe_to`; the tiles also accept the `$dt_timeframe_*` text substitution and fall back to the last 30 days only if
  neither is available. The first row of the **Billing metric availability** table shows the timeframe used and its source.
  Host units are a point-in-time figure, so those tiles use the hosts seen in the 2 hours before the end of the timeframe.
  Billing metrics arrive with a 1–2 h delay.
* **DDU** values come straight from Dynatrace. **DEM** values are **estimates**: billed counts (sessions filtered to
  `Type = Billed`) × the classic DEM weights in
  `DEM_WEIGHTS` near the top of each DEM tile:

  | Capability | DEM per unit |
  |---|---|
  | Web / mobile / custom app session | 0.25 |
  | Session with Session Replay | 1.0 |
  | User action property | 0.01 |
  | Browser monitor action | 1.0 |
  | HTTP monitor request | 0.1 |
  | Third-party synthetic result | 0.1 |

  For billed figures, use Account Management → License / Subscription.

## Host-unit estimate

Dynatrace does not report host units per host, so the monitoring-mode tiles estimate them from each host's RAM
(`physicalMemory`) with the classic rules: up to 1.6 GiB = 0.1, 4 GiB = 0.25, 8 GiB = 0.5, 16 GiB = 1, then 1 host unit
per started 16 GiB. Infrastructure hosts count 30 % of that, Discovery and unknown-mode hosts 0, and hosts with monitoring
disabled 0. The rules are in `HU_RULES` at the top of each monitoring-mode tile. Compare the estimated total with
**Connected host units (reported by Dynatrace)** (`dsfm:billing.hostunit.connected`) and adjust `HU_RULES` if they differ.

## Porting to the classic-licensed environment

1. The target environment needs the new Dashboards app (`<env>.apps.dynatrace.com`). Viewers need permission to read
   metrics (`environment-api:metrics:read`), to read entities for the monitoring-mode tiles
   (`environment-api:entities:read`) and to run code tiles (`app-engine:functions:run`).
2. Import the JSON: **Dashboards → Upload** with `dynatrace-license-consumption.json`, or run
   `dtctl apply -f dynatrace-license-consumption.json --context <target>`.
   The file has no `id`, so importing it creates a new dashboard.
3. Rename it if you don't want the `[RHA] ` prefix there.
4. Set the timeframe to at least 7 days and check the **Porting check** table:
   * `OK`: the metric works.
   * `No data in timeframe`: the capability isn't used (for example mobile apps or Session Replay). This is expected.
   * `Not available`: the metric key doesn't exist in that environment, or the viewer lacks permission. Adjust the key in
     the affected tiles.
5. If the contract uses different DEM weights, change `DEM_WEIGHTS` in the DEM tiles (the helper block at the top of each tile).
