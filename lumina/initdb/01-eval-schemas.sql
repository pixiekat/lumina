-- ─────────────────────────────────────────────────────────────────────────────
-- Runs ONCE on first creation of an empty data volume. Editing later does NOT
-- re-run it — you'd nuke the volume (down -v) or apply the SQL by hand.
-- Entrypoint has already created POSTGRES_DB (luminadb) and connected to it.
-- ─────────────────────────────────────────────────────────────────────────────

-- PostGIS: per-database, so enable it here even though the image bundles it.
CREATE EXTENSION IF NOT EXISTS postgis;

-- One schema per evaluation (add more live with CREATE SCHEMA later).
CREATE SCHEMA IF NOT EXISTS eval_baseline;
CREATE SCHEMA IF NOT EXISTS eval_run_001;

-- Shared schemas every eval can read.
CREATE SCHEMA IF NOT EXISTS vocabulary;   -- load Athena vocab once, share it
CREATE SCHEMA IF NOT EXISTS scratch;      -- shared temp / cohort workspace

-- Database-level search_path so every new connection (incl. DBeaver) inherits it.
-- Plain SQL can't read ${LUMINA_POSTGRES_DB}, so the DB name is hardcoded:
ALTER DATABASE luminadb SET search_path TO "$user", public, vocabulary, scratch;
