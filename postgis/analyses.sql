-- Analyses spatiales du scenario d'etude : parc photovoltaique a Captieux (Gironde)
-- Pre-requis : scripts/01_recuperer_donnees.sh puis scripts/03_importer_plan_dxf.sh
-- Tous les calculs sont en Lambert-93 (EPSG:2154), donc en metres.
-- Usage : psql -v ON_ERROR_STOP=1 -f postgis/analyses.sql

CREATE SCHEMA IF NOT EXISTS projet;
CREATE SCHEMA IF NOT EXISTS projet_amenagement;

-- 1. Zone eligible : commune privee de tous les zonages de protection
DROP TABLE IF EXISTS projet.zone_eligible;
CREATE TABLE projet.zone_eligible AS
SELECT ST_Multi(ST_Difference(c.geom,
         ST_Union(ARRAY(
           SELECT geom FROM contraintes.natura2000_zps
           UNION ALL SELECT geom FROM contraintes.natura2000_sic
           UNION ALL SELECT geom FROM contraintes.znieff1
           UNION ALL SELECT geom FROM contraintes.znieff2)))) AS geom
FROM zone_etude.limite_communale c;

-- 2. Perimetre du projet : carre de 700 m x 700 m (49 ha) place dans la zone eligible
DROP TABLE IF EXISTS projet.perimetre_projet;
CREATE TABLE projet.perimetre_projet AS
SELECT 1 AS id,
       'Parc photovoltaique Captieux (scenario)'::text AS nom,
       ST_SetSRID(ST_MakeEnvelope(435430.7, 6356476.0, 436130.7, 6357176.0), 2154) AS geom;
ALTER TABLE projet.perimetre_projet ADD PRIMARY KEY (id);

-- 3. Synthese multicritere : distance du perimetre a chaque enjeu
DROP TABLE IF EXISTS projet.synthese_enjeux;
CREATE TABLE projet.synthese_enjeux AS
SELECT 'Natura 2000 - ZPS' AS enjeu, round(min(ST_Distance(p.geom, z.geom))) AS distance_m
  FROM projet.perimetre_projet p, contraintes.natura2000_zps z
UNION ALL SELECT 'Natura 2000 - SIC', round(min(ST_Distance(p.geom, z.geom)))
  FROM projet.perimetre_projet p, contraintes.natura2000_sic z
UNION ALL SELECT 'ZNIEFF type 1', round(min(ST_Distance(p.geom, z.geom)))
  FROM projet.perimetre_projet p, contraintes.znieff1 z
UNION ALL SELECT 'ZNIEFF type 2', round(min(ST_Distance(p.geom, z.geom)))
  FROM projet.perimetre_projet p, contraintes.znieff2 z
UNION ALL SELECT 'Cours d''eau le plus proche', round(min(ST_Distance(p.geom, h.geom)))
  FROM projet.perimetre_projet p, contraintes.hydrographie_lineaire h
UNION ALL SELECT 'Route la plus proche (acces)', round(min(ST_Distance(p.geom, r.geom)))
  FROM projet.perimetre_projet p, contexte.reseau_routier r;
ALTER TABLE projet.synthese_enjeux ADD COLUMN id serial PRIMARY KEY;

-- 4. Zones tampons : 500 m autour de la ZPS, 100 m autour des cours d'eau proches du projet
DROP TABLE IF EXISTS projet.buffer_zps_500m;
CREATE TABLE projet.buffer_zps_500m AS
SELECT 1 AS id, 'Zone tampon 500m - ZPS'::text AS nom, ST_Buffer(geom, 500) AS geom
FROM contraintes.natura2000_zps;
ALTER TABLE projet.buffer_zps_500m ADD PRIMARY KEY (id);

DROP TABLE IF EXISTS projet.buffer_hydro_100m;
CREATE TABLE projet.buffer_hydro_100m AS
SELECT ogc_fid AS id, 'Zone tampon 100m - cours d''eau'::text AS nom, ST_Buffer(geom, 100) AS geom
FROM contraintes.hydrographie_lineaire h
WHERE ST_DWithin(h.geom, (SELECT geom FROM projet.perimetre_projet), 2000);
ALTER TABLE projet.buffer_hydro_100m ADD PRIMARY KEY (id);

-- 5. Conversion DWG -> SIG : les entites fermees du DXF arrivent en lignes fermees, on en fait des polygones
DROP TABLE IF EXISTS projet_amenagement.tables_pv;
CREATE TABLE projet_amenagement.tables_pv AS
SELECT row_number() OVER () AS id, ST_MakePolygon(ST_LineMerge(geom)) AS geom
FROM projet_amenagement.plan_implantation_brut WHERE layer = 'TABLES_PV';
ALTER TABLE projet_amenagement.tables_pv ADD PRIMARY KEY (id);

DROP TABLE IF EXISTS projet_amenagement.cloture;
CREATE TABLE projet_amenagement.cloture AS
SELECT 1 AS id, ST_MakePolygon(ST_LineMerge(geom)) AS geom
FROM projet_amenagement.plan_implantation_brut WHERE layer = 'CLOTURE';
ALTER TABLE projet_amenagement.cloture ADD PRIMARY KEY (id);

DROP TABLE IF EXISTS projet_amenagement.poste_livraison;
CREATE TABLE projet_amenagement.poste_livraison AS
SELECT 1 AS id, ST_MakePolygon(ST_LineMerge(geom)) AS geom
FROM projet_amenagement.plan_implantation_brut WHERE layer = 'POSTE_LIVRAISON';
ALTER TABLE projet_amenagement.poste_livraison ADD PRIMARY KEY (id);

DROP TABLE IF EXISTS projet_amenagement.piste_acces;
CREATE TABLE projet_amenagement.piste_acces AS
SELECT row_number() OVER () AS id, geom
FROM projet_amenagement.plan_implantation_brut WHERE layer = 'PISTE_ACCES';
ALTER TABLE projet_amenagement.piste_acces ADD PRIMARY KEY (id);

-- 6. Controle qualite : tables dans la bande de 100 m des cours d'eau
DROP TABLE IF EXISTS projet_amenagement.anomalies_tables_pv;
CREATE TABLE projet_amenagement.anomalies_tables_pv AS
SELECT t.id, 'Table PV en zone tampon cours d''eau (100m)'::text AS anomalie, t.geom
FROM projet_amenagement.tables_pv t
JOIN projet.buffer_hydro_100m b ON ST_Intersects(t.geom, b.geom);

-- 7. Plan corrige : tables hors de la bande de 100 m
DROP TABLE IF EXISTS projet_amenagement.tables_pv_corrige;
CREATE TABLE projet_amenagement.tables_pv_corrige AS
SELECT t.id, t.geom
FROM projet_amenagement.tables_pv t
WHERE NOT EXISTS (SELECT 1 FROM projet.buffer_hydro_100m b WHERE ST_Intersects(t.geom, b.geom));
ALTER TABLE projet_amenagement.tables_pv_corrige ADD PRIMARY KEY (id);

-- Resultats attendus : 1404 tables, 601 en conflit, 803 conservees, 6,0 ha d'emprise conservee
SELECT (SELECT count(*) FROM projet_amenagement.tables_pv)           AS tables_initiales,
       (SELECT count(*) FROM projet_amenagement.anomalies_tables_pv) AS tables_en_conflit,
       (SELECT count(*) FROM projet_amenagement.tables_pv_corrige)   AS tables_conservees,
       round((SELECT sum(ST_Area(geom)) FROM projet_amenagement.tables_pv_corrige)::numeric / 10000, 1) AS emprise_conservee_ha;
SELECT enjeu, distance_m FROM projet.synthese_enjeux ORDER BY distance_m;
