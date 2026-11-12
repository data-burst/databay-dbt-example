# Databay dbt example

A small dbt project that [Databay](https://databay.databurst.tech) builds in its ClickHouse warehouse from this
repository. It reads five tables a Databay pipeline lands (`users`, `query_logs`, `conversations`, `messages`,
`clicks`) and builds:

| Folder | Models | Stored as |
|---|---|---|
| `models/base` | `base_users`, `base_searches`, `base_conversations`, `base_messages`, `base_clicks` | views |
| `models/marts` | `dim_users`, `fct_search_sessions`, `rpt_weekly_active_users` | tables, rebuilt daily (`rpt_weekly_active_users` hourly) |

## How Databay reads it

- **Sources** are the warehouse's tables, named by the warehouse name you see in Databay: `source('warehouse', 'users')`.
  Databay writes `sources.yml` itself, so this repository has none.
- **`databay.latest_rows(...)`** is a Databay macro that keeps the current version of each replicated row.
- **`dbt_project.yml`** may set only `vars` and folder configs (`materialized`, `unique_key`, `tags`, `enabled`,
  `meta: {databay: {refresh: ...}}`). Seeds, snapshots and packages are refused.
- **Refresh** comes from `meta.databay.refresh`: `every 15m`, `every 1h`, `every 1d`, `after_sources` or `manual`.

## Connect it

In Databay, open a project's Pipelines canvas, click **Git**, choose **GitHub**, install the Databay app on this
repository, then pick branch `main` and folder `/`. Every push to `main` syncs; every pull request gets a
"Databay models" check.

Because it reads Databay's own warehouse tables and macros, this project builds inside Databay rather than with a
local `dbt run`.
