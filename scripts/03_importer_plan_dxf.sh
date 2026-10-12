#!/usr/bin/env bash
# Importe le plan d'implantation DXF dans PostGIS (table brute, une ligne par entite CAO).
# Les entites fermees arrivent en lignes fermees : elles sont converties en polygones par postgis/analyses.sql.
#
# Variables a definir : PGUSER, PGPASSWORD, PGDATABASE (et PGHOST, PGPORT si besoin).
set -euo pipefail
cd "$(dirname "$0")/.."

PGCONN="PG:host=${PGHOST:-localhost} port=${PGPORT:-5432} dbname=${PGDATABASE} user=${PGUSER} password=${PGPASSWORD}"

psql -v ON_ERROR_STOP=1 -q -c "CREATE SCHEMA IF NOT EXISTS projet; CREATE SCHEMA IF NOT EXISTS projet_amenagement;"

# Le DXF ne porte pas de systeme de coordonnees : on affecte Lambert-93, dans lequel le plan est dessine.
ogr2ogr -f PostgreSQL "$PGCONN" dwg/plan_implantation_pv_captieux.dxf \
  -nln projet_amenagement.plan_implantation_brut -overwrite -nlt PROMOTE_TO_MULTI \
  -lco GEOMETRY_NAME=geom -a_srs EPSG:2154

echo "Plan DXF importe dans projet_amenagement.plan_implantation_brut."
