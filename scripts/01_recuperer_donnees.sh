#!/usr/bin/env bash
# Telecharge les donnees ouvertes autour de Captieux (Gironde) et les importe dans PostGIS.
#
# Prerequis : curl, psql, ogr2ogr (GDAL), un interpreteur Python 3 (variable PYTHON, python3 par defaut).
# Variables a definir : PGUSER, PGPASSWORD, PGDATABASE (et PGHOST, PGPORT si besoin).
# Sous Windows, lancer depuis l'OSGeo4W Shell ou un Git Bash dont le PATH contient QGIS/bin.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p data/brut

PYTHON="${PYTHON:-python3}"
PGCONN="PG:host=${PGHOST:-localhost} port=${PGPORT:-5432} dbname=${PGDATABASE} user=${PGUSER} password=${PGPASSWORD}"
BBOX="-0.40,44.15,-0.15,44.40,EPSG:4326"
WFS="https://data.geopf.fr/wfs/ows?service=WFS&version=2.0.0&request=GetFeature&outputFormat=application/json&srsName=EPSG:4326"

psql -v ON_ERROR_STOP=1 -q -c "CREATE EXTENSION IF NOT EXISTS postgis;
  CREATE SCHEMA IF NOT EXISTS zone_etude; CREATE SCHEMA IF NOT EXISTS contraintes; CREATE SCHEMA IF NOT EXISTS contexte;"

importer() {  # <fichier geojson> <table cible>
  ogr2ogr -f PostgreSQL "$PGCONN" "$1" -nln "$2" -overwrite -nlt PROMOTE_TO_MULTI \
    -lco GEOMETRY_NAME=geom -t_srs EPSG:2154
}

telecharger() {  # <couche WFS> <nom de fichier>
  curl -s "${WFS}&typeName=$1&bbox=${BBOX}&count=2000" -o "data/brut/$2.geojson"
}

# Limite communale (API geo.api.gouv.fr) : la reponse est une liste JSON, a convertir en FeatureCollection
curl -s "https://geo.api.gouv.fr/communes?nom=Captieux&fields=nom,code,codeDepartement,codeRegion,population,surface,contour&format=json&geometry=contour" \
  -o data/brut/captieux_commune.json
"$PYTHON" - <<'PYEOF'
import json
with open("data/brut/captieux_commune.json", encoding="utf-8") as f:
    communes = json.load(f)
features = []
for c in communes:
    geometrie = c.pop("contour")
    features.append({"type": "Feature", "geometry": geometrie, "properties": c})
with open("data/brut/captieux_commune.geojson", "w", encoding="utf-8") as f:
    json.dump({"type": "FeatureCollection", "features": features}, f, ensure_ascii=False)
PYEOF
importer data/brut/captieux_commune.geojson zone_etude.limite_communale

# Zonages de protection (Patrinat / INPN via la Geoplateforme IGN)
telecharger patrinat_sic:sic          sic;          importer data/brut/sic.geojson          contraintes.natura2000_sic
telecharger patrinat_zps:zps          zps;          importer data/brut/zps.geojson          contraintes.natura2000_zps
telecharger patrinat_znieff1:znieff1  znieff1;      importer data/brut/znieff1.geojson      contraintes.znieff1
telecharger patrinat_znieff2:znieff2  znieff2;      importer data/brut/znieff2.geojson      contraintes.znieff2

# Hydrographie, foret publique et routes (BD Topo)
telecharger BDTOPO_V3:troncon_hydrographique troncon_hydrographique; importer data/brut/troncon_hydrographique.geojson contraintes.hydrographie_lineaire
telecharger BDTOPO_V3:surface_hydrographique surface_hydrographique; importer data/brut/surface_hydrographique.geojson contraintes.hydrographie_surfacique
telecharger BDTOPO_V3:foret_publique         foret_publique;         importer data/brut/foret_publique.geojson         contexte.foret_publique
telecharger BDTOPO_V3:troncon_de_route       troncon_de_route;       importer data/brut/troncon_de_route.geojson       contexte.reseau_routier

echo "Donnees importees dans la base ${PGDATABASE}."
