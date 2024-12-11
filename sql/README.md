# SQL

The SQL database is managed by flyway.

Migrations are in sql/migrations.

## What happened to prefixes?

Prefixes are no longer necessary.

## How To Deal With Old Tables

Data may **never** be destroyed by migrations, only deprecated.

Prefix them with `legacy_`.

## Table Groupings

### Backend - `backend_`

Backend store for server systems. Required for persistence to function and for metrics to be recorded.

Contains:

- Metrics
- Repositories
- Filestores

### Character - `character_`

Character store. Required for character persistence and fast character setup handling.

Contains:

- Characters
- Character records
- Character persistence
- Character things in general
