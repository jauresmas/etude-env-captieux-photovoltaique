#!/usr/bin/env bash
# Contours du departement de la Gironde et des regions metropolitaines (BD Topo, Geoplateforme IGN)
# pour la carte de situation. Les regions sont telechargees a pleine resolution (environ 90 Mo) puis
# simplifiees dans PostGIS en metres (tolerance 800 m), sinon QGIS rame et la carte est illisible.
#
# Variables a definir : PGUSER, PGPASSWORD, PGDATABASE (et PGHOST, PGPORT si besoin).
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p data/brut

PGCONN="PG:host=${PGHOST:-localhost} port=${PGPORT:-5432} dbname=${PGDATABASE} user=${PGUSER} password=${PGPASSWORD}"
WFS="https://data.geopf.fr/wfs/ows?service=WFS&version=2.0.0&request=GetFeature&outputFormat=application/json&srsName=EPSG:4326"

curl -s "${WFS}&typeName=BDTOPO_V3:departement&bbox=-1.6,44.0,0.3,45.6,EPSG:4326" -o data/brut/departement_gironde.geojson
curl -s "${WFS}&typeName=BDTOPO_V3:region" -o data/brut/toutes_regions_france.geojson

# Reprojection d'abord (Lambert-93, metres), simplification ensuite : l'option -simplify de ogr2ogr
# s'exprime dans l'unite du fichier source (degres ici), d'ou la simplification faite en SQL.
ogr2ogr -f PostgreSQL "$PGCONN" data/brut/toutes_regions_france.geojson \
  -nln zone_etude.regions_france_brut -overwrite -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom \
  -t_srs EPSG:2154 -where "code_insee NOT IN ('01','02','03','04','06')"
ogr2ogr -f PostgreSQL "$PGCONN" data/brut/departement_gironde.geojson \
  -nln zone_etude.departement_gironde_brut -overwrite -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom \
  -t_srs EPSG:2154 -where "code_insee = '33'"

psql -v ON_ERROR_STOP=1 -q <<'SQL'
DROP TABLE IF EXISTS zone_etude.regions_france;
CREATE TABLE zone_etude.regions_france AS
SELECT nom_officiel, code_insee, ST_SimplifyPreserveTopology(geom, 800) AS geom
FROM zone_etude.regions_france_brut;
ALTER TABLE zone_etude.regions_france ADD COLUMN ogc_fid serial PRIMARY KEY;
CREATE INDEX ON zone_etude.regions_france USING GIST (geom);

DROP TABLE IF EXISTS zone_etude.departement_gironde;
CREATE TABLE zone_etude.departement_gironde AS
SELECT nom_officiel, code_insee, ST_SimplifyPreserveTopology(geom, 100) AS geom
FROM zone_etude.departement_gironde_brut;
ALTER TABLE zone_etude.departement_gironde ADD COLUMN ogc_fid serial PRIMARY KEY;
DROP TABLE zone_etude.departement_gironde_brut;

ANALYZE zone_etude.regions_france;
ANALYZE zone_etude.departement_gironde;
SELECT 'regions' AS couche, count(*) AS entites, sum(ST_NPoints(geom)) AS points FROM zone_etude.regions_france
UNION ALL SELECT 'departement', count(*), sum(ST_NPoints(geom)) FROM zone_etude.departement_gironde;
SQL
