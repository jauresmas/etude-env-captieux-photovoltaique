--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10
-- Dumped by pg_dump version 15.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: contexte; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA contexte;


--
-- Name: contraintes; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA contraintes;


--
-- Name: ogr_system_tables; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ogr_system_tables;


--
-- Name: projet; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA projet;


--
-- Name: projet_amenagement; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA projet_amenagement;


--
-- Name: terrain; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA terrain;


--
-- Name: zone_etude; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA zone_etude;


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: event_trigger_function_for_metadata(); Type: FUNCTION; Schema: ogr_system_tables; Owner: -
--

CREATE FUNCTION ogr_system_tables.event_trigger_function_for_metadata() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    obj record;
BEGIN
  IF has_schema_privilege('ogr_system_tables', 'USAGE') THEN
   IF has_table_privilege('ogr_system_tables.metadata', 'DELETE') THEN
    FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
    LOOP
        IF obj.object_type = 'table' THEN
            DELETE FROM ogr_system_tables.metadata m WHERE m.schema_name = obj.schema_name AND m.table_name = obj.object_name;
        END IF;
    END LOOP;
   END IF;
  END IF;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: foret_publique; Type: TABLE; Schema: contexte; Owner: -
--

CREATE TABLE contexte.foret_publique (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id character varying,
    cleabs character varying,
    nature character varying,
    toponyme character varying,
    statut_du_toponyme character varying,
    importance character varying,
    date_creation timestamp with time zone,
    date_modification timestamp with time zone,
    date_d_apparition character varying,
    date_de_confirmation date,
    sources character varying,
    identifiants_sources character varying,
    methode_d_acquisition_planimetrique character varying,
    precision_planimetrique integer
);


--
-- Name: foret_publique_ogc_fid_seq; Type: SEQUENCE; Schema: contexte; Owner: -
--

CREATE SEQUENCE contexte.foret_publique_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foret_publique_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contexte; Owner: -
--

ALTER SEQUENCE contexte.foret_publique_ogc_fid_seq OWNED BY contexte.foret_publique.ogc_fid;


--
-- Name: reseau_routier; Type: TABLE; Schema: contexte; Owner: -
--

CREATE TABLE contexte.reseau_routier (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiLineStringZ,2154),
    id character varying,
    cleabs character varying,
    nature character varying,
    nom_collaboratif_gauche character varying,
    nom_collaboratif_droite character varying,
    importance character varying,
    fictif boolean,
    position_par_rapport_au_sol character varying,
    etat_de_l_objet character varying,
    date_creation timestamp with time zone,
    date_modification timestamp with time zone,
    date_d_apparition character varying,
    date_de_confirmation date,
    sources character varying,
    identifiants_sources character varying,
    methode_d_acquisition_planimetrique character varying,
    precision_planimetrique double precision,
    methode_d_acquisition_altimetrique character varying,
    precision_altimetrique double precision,
    nombre_de_voies integer,
    largeur_de_chaussee double precision,
    itineraire_vert boolean,
    prive boolean,
    sens_de_circulation character varying,
    reserve_aux_bus character varying,
    urbain boolean,
    vitesse_moyenne_vl integer,
    acces_vehicule_leger character varying,
    acces_pieton character varying,
    periode_de_fermeture character varying,
    nature_de_la_restriction character varying,
    restriction_de_hauteur character varying,
    restriction_de_poids_total character varying,
    restriction_de_poids_par_essieu integer,
    restriction_de_largeur character varying,
    restriction_de_longueur character varying,
    matieres_dangereuses_interdites boolean,
    borne_debut_gauche character varying,
    borne_debut_droite character varying,
    borne_fin_gauche character varying,
    borne_fin_droite character varying,
    insee_commune_gauche character varying,
    insee_commune_droite character varying,
    alias_gauche character varying,
    alias_droit character varying,
    date_de_mise_en_service character varying,
    liens_vers_route_nommee character varying,
    liens_vers_itineraire_autre character varying,
    cpx_numero character varying,
    cpx_numero_route_europeenne character varying,
    cpx_classement_administratif character varying,
    cpx_gestionnaire character varying,
    cpx_toponyme_route_nommee character varying,
    cpx_toponyme_itineraire_cyclable character varying,
    cpx_toponyme_voie_verte character varying,
    cpx_nature_itineraire_autre character varying,
    cpx_toponyme_itineraire_autre character varying,
    delestage character varying,
    source_voie_ban_gauche character varying,
    source_voie_ban_droite character varying,
    nom_voie_ban_gauche character varying,
    nom_voie_ban_droite character varying,
    lieux_dits_ban_gauche character varying,
    lieux_dits_ban_droite character varying,
    identifiant_voie_ban_gauche character varying,
    identifiant_voie_ban_droite character varying,
    sens_amenagement_cyclable_gauche character varying,
    sens_amenagement_cyclable_droit character varying,
    amenagement_cyclable_gauche character varying,
    amenagement_cyclable_droit character varying,
    aire_de_retournement_dfci character varying,
    gabarit_dfci character varying,
    impasse_dfci character varying,
    nature_detaillee_dfci character varying,
    ouvrage_d_art_limitant_dfci character varying,
    pente_maximale_dfci character varying,
    piste_dfci boolean,
    piste_dfci_debroussaillee boolean,
    piste_dfci_fosses character varying,
    sens_de_circulation_dfci character varying,
    tout_terrain_dfci character varying,
    vitesse_moyenne_dfci integer,
    zone_de_croisement_dfci character varying,
    categorie_dfci character varying,
    vitesse_collaborative character varying,
    id_ban_odonyme_droite character varying,
    id_ban_odonyme_gauche character varying
);


--
-- Name: reseau_routier_ogc_fid_seq; Type: SEQUENCE; Schema: contexte; Owner: -
--

CREATE SEQUENCE contexte.reseau_routier_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reseau_routier_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contexte; Owner: -
--

ALTER SEQUENCE contexte.reseau_routier_ogc_fid_seq OWNED BY contexte.reseau_routier.ogc_fid;


--
-- Name: hydrographie_lineaire; Type: TABLE; Schema: contraintes; Owner: -
--

CREATE TABLE contraintes.hydrographie_lineaire (
    ogc_fid integer NOT NULL,
    id character varying,
    cleabs character varying,
    code_hydrographique character varying,
    code_du_pays character varying,
    nature character varying,
    fictif boolean,
    etat_de_l_objet character varying,
    position_par_rapport_au_sol character varying,
    date_creation timestamp with time zone,
    date_modification timestamp with time zone,
    date_d_apparition character varying,
    date_de_confirmation date,
    sources character varying,
    identifiants_sources character varying,
    methode_d_acquisition_planimetrique character varying,
    precision_planimetrique double precision,
    methode_d_acquisition_altimetrique character varying,
    precision_altimetrique double precision,
    mode_d_obtention_des_coordonnees character varying,
    mode_d_obtention_de_l_altitude character varying,
    statut character varying,
    persistance character varying,
    fosse boolean,
    navigabilite boolean,
    salinite boolean,
    numero_d_ordre character varying,
    strategie_de_classement character varying,
    origine character varying,
    perimetre_d_utilisation_ou_origine character varying,
    sens_de_l_ecoulement character varying,
    reseau_principal_coulant boolean,
    trace_connu boolean,
    classe_de_largeur character varying,
    type_de_bras character varying,
    commentaire_sur_l_objet_hydro character varying,
    code_du_cours_d_eau_bdcarthage character varying,
    inventaire_police_de_l_eau character varying,
    identifiant_police_de_l_eau character varying,
    liens_vers_cours_d_eau character varying,
    lien_vers_noeud_hydrographique_ini character varying,
    lien_vers_noeud_hydrographique_fin character varying,
    liens_vers_surface_hydrographique character varying,
    lien_vers_entite_de_transition character varying,
    cpx_toponyme_de_cours_d_eau character varying,
    cpx_toponyme_d_entite_de_transition character varying,
    geom public.geometry(MultiLineStringZ,2154)
);


--
-- Name: hydrographie_lineaire_ogc_fid_seq; Type: SEQUENCE; Schema: contraintes; Owner: -
--

CREATE SEQUENCE contraintes.hydrographie_lineaire_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hydrographie_lineaire_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contraintes; Owner: -
--

ALTER SEQUENCE contraintes.hydrographie_lineaire_ogc_fid_seq OWNED BY contraintes.hydrographie_lineaire.ogc_fid;


--
-- Name: hydrographie_surfacique; Type: TABLE; Schema: contraintes; Owner: -
--

CREATE TABLE contraintes.hydrographie_surfacique (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygonZ,2154),
    id character varying,
    cleabs character varying,
    code_hydrographique character varying,
    code_du_pays character varying,
    nature character varying,
    position_par_rapport_au_sol character varying,
    etat_de_l_objet character varying,
    date_creation timestamp with time zone,
    date_modification timestamp with time zone,
    date_d_apparition character varying,
    date_de_confirmation date,
    sources character varying,
    identifiants_sources character varying,
    methode_d_acquisition_planimetrique character varying,
    precision_planimetrique double precision,
    methode_d_acquisition_altimetrique character varying,
    precision_altimetrique double precision,
    mode_d_obtention_des_coordonnees character varying,
    mode_d_obtention_de_l_altitude character varying,
    statut character varying,
    persistance character varying,
    salinite boolean,
    origine character varying,
    commentaire_sur_l_objet_hydro character varying,
    liens_vers_plan_d_eau character varying,
    liens_vers_cours_d_eau character varying,
    lien_vers_entite_de_transition character varying,
    cpx_toponyme_de_plan_d_eau character varying,
    cpx_toponyme_de_cours_d_eau character varying,
    cpx_toponyme_d_entite_de_transition character varying
);


--
-- Name: hydrographie_surfacique_ogc_fid_seq; Type: SEQUENCE; Schema: contraintes; Owner: -
--

CREATE SEQUENCE contraintes.hydrographie_surfacique_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hydrographie_surfacique_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contraintes; Owner: -
--

ALTER SEQUENCE contraintes.hydrographie_surfacique_ogc_fid_seq OWNED BY contraintes.hydrographie_surfacique.ogc_fid;


--
-- Name: natura2000_sic; Type: TABLE; Schema: contraintes; Owner: -
--

CREATE TABLE contraintes.natura2000_sic (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id character varying,
    id_local character varying,
    nom_site character varying,
    date_crea date,
    modif_adm date,
    modif_geo date,
    url_fiche character varying,
    surf_off character varying,
    acte_deb character varying,
    acte_fin character varying,
    gest_site character varying,
    operateur character varying,
    "precision" character varying,
    src_geom character varying,
    src_annee character varying,
    marin character varying,
    p1_nature character varying,
    p4_geologi character varying,
    id_mnhn character varying,
    area_sig integer,
    cd_sig character varying,
    territoire character varying
);


--
-- Name: natura2000_sic_ogc_fid_seq; Type: SEQUENCE; Schema: contraintes; Owner: -
--

CREATE SEQUENCE contraintes.natura2000_sic_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: natura2000_sic_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contraintes; Owner: -
--

ALTER SEQUENCE contraintes.natura2000_sic_ogc_fid_seq OWNED BY contraintes.natura2000_sic.ogc_fid;


--
-- Name: natura2000_zps; Type: TABLE; Schema: contraintes; Owner: -
--

CREATE TABLE contraintes.natura2000_zps (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id character varying,
    id_local character varying,
    nom_site character varying,
    date_crea date,
    modif_adm date,
    modif_geo date,
    url_fiche character varying,
    surf_off character varying,
    acte_deb character varying,
    acte_fin character varying,
    gest_site character varying,
    operateur character varying,
    "precision" character varying,
    src_geom character varying,
    src_annee character varying,
    marin character varying,
    p1_nature character varying,
    p4_geologi character varying,
    id_mnhn character varying,
    area_sig integer,
    cd_sig character varying,
    territoire character varying
);


--
-- Name: natura2000_zps_ogc_fid_seq; Type: SEQUENCE; Schema: contraintes; Owner: -
--

CREATE SEQUENCE contraintes.natura2000_zps_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: natura2000_zps_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contraintes; Owner: -
--

ALTER SEQUENCE contraintes.natura2000_zps_ogc_fid_seq OWNED BY contraintes.natura2000_zps.ogc_fid;


--
-- Name: znieff1; Type: TABLE; Schema: contraintes; Owner: -
--

CREATE TABLE contraintes.znieff1 (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id character varying,
    id_local character varying,
    nom_site character varying,
    date_crea date,
    modif_adm date,
    modif_geo date,
    url_fiche character varying,
    surf_off character varying,
    acte_deb character varying,
    acte_fin character varying,
    gest_site character varying,
    operateur character varying,
    "precision" character varying,
    src_geom character varying,
    src_annee character varying,
    marin character varying,
    p1_nature character varying,
    p4_geologi character varying,
    id_mnhn character varying,
    area_sig double precision,
    cd_sig character varying,
    territoire character varying
);


--
-- Name: znieff1_ogc_fid_seq; Type: SEQUENCE; Schema: contraintes; Owner: -
--

CREATE SEQUENCE contraintes.znieff1_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: znieff1_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contraintes; Owner: -
--

ALTER SEQUENCE contraintes.znieff1_ogc_fid_seq OWNED BY contraintes.znieff1.ogc_fid;


--
-- Name: znieff2; Type: TABLE; Schema: contraintes; Owner: -
--

CREATE TABLE contraintes.znieff2 (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id character varying,
    id_local character varying,
    nom_site character varying,
    date_crea date,
    modif_adm date,
    modif_geo date,
    url_fiche character varying,
    surf_off character varying,
    acte_deb character varying,
    acte_fin character varying,
    gest_site character varying,
    operateur character varying,
    "precision" character varying,
    src_geom character varying,
    src_annee character varying,
    marin character varying,
    p1_nature character varying,
    p4_geologi character varying,
    id_mnhn character varying,
    area_sig double precision,
    cd_sig character varying,
    territoire character varying
);


--
-- Name: znieff2_ogc_fid_seq; Type: SEQUENCE; Schema: contraintes; Owner: -
--

CREATE SEQUENCE contraintes.znieff2_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: znieff2_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: contraintes; Owner: -
--

ALTER SEQUENCE contraintes.znieff2_ogc_fid_seq OWNED BY contraintes.znieff2.ogc_fid;


--
-- Name: metadata; Type: TABLE; Schema: ogr_system_tables; Owner: -
--

CREATE TABLE ogr_system_tables.metadata (
    id integer NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    metadata text
);


--
-- Name: metadata_id_seq; Type: SEQUENCE; Schema: ogr_system_tables; Owner: -
--

CREATE SEQUENCE ogr_system_tables.metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: ogr_system_tables; Owner: -
--

ALTER SEQUENCE ogr_system_tables.metadata_id_seq OWNED BY ogr_system_tables.metadata.id;


--
-- Name: buffer_hydro_100m; Type: TABLE; Schema: projet; Owner: -
--

CREATE TABLE projet.buffer_hydro_100m (
    id integer NOT NULL,
    nom text,
    geom public.geometry
);


--
-- Name: buffer_zps_500m; Type: TABLE; Schema: projet; Owner: -
--

CREATE TABLE projet.buffer_zps_500m (
    id integer NOT NULL,
    nom text,
    geom public.geometry
);


--
-- Name: perimetre_projet; Type: TABLE; Schema: projet; Owner: -
--

CREATE TABLE projet.perimetre_projet (
    id integer,
    nom text,
    geom public.geometry
);


--
-- Name: synthese_enjeux; Type: TABLE; Schema: projet; Owner: -
--

CREATE TABLE projet.synthese_enjeux (
    enjeu text,
    distance_m double precision,
    id integer NOT NULL
);


--
-- Name: synthese_enjeux_id_seq; Type: SEQUENCE; Schema: projet; Owner: -
--

CREATE SEQUENCE projet.synthese_enjeux_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: synthese_enjeux_id_seq; Type: SEQUENCE OWNED BY; Schema: projet; Owner: -
--

ALTER SEQUENCE projet.synthese_enjeux_id_seq OWNED BY projet.synthese_enjeux.id;


--
-- Name: zone_eligible; Type: TABLE; Schema: projet; Owner: -
--

CREATE TABLE projet.zone_eligible (
    geom public.geometry
);


--
-- Name: anomalies_tables_pv; Type: TABLE; Schema: projet_amenagement; Owner: -
--

CREATE TABLE projet_amenagement.anomalies_tables_pv (
    id bigint,
    anomalie text,
    geom public.geometry
);


--
-- Name: cloture; Type: TABLE; Schema: projet_amenagement; Owner: -
--

CREATE TABLE projet_amenagement.cloture (
    id integer NOT NULL,
    geom public.geometry
);


--
-- Name: piste_acces; Type: TABLE; Schema: projet_amenagement; Owner: -
--

CREATE TABLE projet_amenagement.piste_acces (
    id bigint NOT NULL,
    geom public.geometry(Geometry,2154)
);


--
-- Name: plan_implantation_brut; Type: TABLE; Schema: projet_amenagement; Owner: -
--

CREATE TABLE projet_amenagement.plan_implantation_brut (
    ogc_fid integer NOT NULL,
    layer character varying,
    paperspace boolean,
    subclasses character varying,
    linetype character varying,
    entityhandle character varying,
    text character varying,
    geom public.geometry(Geometry,2154)
);


--
-- Name: plan_implantation_brut_ogc_fid_seq; Type: SEQUENCE; Schema: projet_amenagement; Owner: -
--

CREATE SEQUENCE projet_amenagement.plan_implantation_brut_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_implantation_brut_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: projet_amenagement; Owner: -
--

ALTER SEQUENCE projet_amenagement.plan_implantation_brut_ogc_fid_seq OWNED BY projet_amenagement.plan_implantation_brut.ogc_fid;


--
-- Name: poste_livraison; Type: TABLE; Schema: projet_amenagement; Owner: -
--

CREATE TABLE projet_amenagement.poste_livraison (
    id integer NOT NULL,
    geom public.geometry
);


--
-- Name: tables_pv; Type: TABLE; Schema: projet_amenagement; Owner: -
--

CREATE TABLE projet_amenagement.tables_pv (
    id bigint NOT NULL,
    geom public.geometry
);


--
-- Name: tables_pv_corrige; Type: TABLE; Schema: projet_amenagement; Owner: -
--

CREATE TABLE projet_amenagement.tables_pv_corrige (
    id bigint NOT NULL,
    geom public.geometry
);


--
-- Name: releve_terrain; Type: TABLE; Schema: terrain; Owner: -
--

CREATE TABLE terrain.releve_terrain (
    id integer NOT NULL,
    date_releve date DEFAULT CURRENT_DATE,
    observateur text,
    type_observation text,
    commentaire text,
    photo text,
    geom public.geometry(Point,2154)
);


--
-- Name: releve_terrain_id_seq; Type: SEQUENCE; Schema: terrain; Owner: -
--

CREATE SEQUENCE terrain.releve_terrain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: releve_terrain_id_seq; Type: SEQUENCE OWNED BY; Schema: terrain; Owner: -
--

ALTER SEQUENCE terrain.releve_terrain_id_seq OWNED BY terrain.releve_terrain.id;


--
-- Name: departement_gironde; Type: TABLE; Schema: zone_etude; Owner: -
--

CREATE TABLE zone_etude.departement_gironde (
    nom_officiel character varying,
    code_insee character varying,
    geom public.geometry,
    ogc_fid integer NOT NULL
);


--
-- Name: departement_gironde_simple_ogc_fid_seq; Type: SEQUENCE; Schema: zone_etude; Owner: -
--

CREATE SEQUENCE zone_etude.departement_gironde_simple_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departement_gironde_simple_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: zone_etude; Owner: -
--

ALTER SEQUENCE zone_etude.departement_gironde_simple_ogc_fid_seq OWNED BY zone_etude.departement_gironde.ogc_fid;


--
-- Name: limite_communale; Type: TABLE; Schema: zone_etude; Owner: -
--

CREATE TABLE zone_etude.limite_communale (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    nom character varying,
    code character varying,
    codedepartement character varying,
    coderegion character varying,
    population integer,
    surface double precision,
    _score integer
);


--
-- Name: limite_communale_ogc_fid_seq; Type: SEQUENCE; Schema: zone_etude; Owner: -
--

CREATE SEQUENCE zone_etude.limite_communale_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: limite_communale_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: zone_etude; Owner: -
--

ALTER SEQUENCE zone_etude.limite_communale_ogc_fid_seq OWNED BY zone_etude.limite_communale.ogc_fid;


--
-- Name: regions_france; Type: TABLE; Schema: zone_etude; Owner: -
--

CREATE TABLE zone_etude.regions_france (
    nom_officiel character varying,
    code_insee character varying,
    geom public.geometry,
    ogc_fid integer NOT NULL
);


--
-- Name: regions_france_brut; Type: TABLE; Schema: zone_etude; Owner: -
--

CREATE TABLE zone_etude.regions_france_brut (
    ogc_fid integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id character varying,
    cleabs character varying,
    nom_officiel character varying,
    code_insee character varying,
    code_siren character varying,
    date_creation timestamp with time zone,
    date_modification timestamp with time zone,
    date_d_apparition character varying,
    date_de_confirmation character varying,
    liens_vers_autorite_administrative character varying
);


--
-- Name: regions_france_brut_ogc_fid_seq; Type: SEQUENCE; Schema: zone_etude; Owner: -
--

CREATE SEQUENCE zone_etude.regions_france_brut_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_france_brut_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: zone_etude; Owner: -
--

ALTER SEQUENCE zone_etude.regions_france_brut_ogc_fid_seq OWNED BY zone_etude.regions_france_brut.ogc_fid;


--
-- Name: regions_france_ogc_fid_seq; Type: SEQUENCE; Schema: zone_etude; Owner: -
--

CREATE SEQUENCE zone_etude.regions_france_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_france_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: zone_etude; Owner: -
--

ALTER SEQUENCE zone_etude.regions_france_ogc_fid_seq OWNED BY zone_etude.regions_france.ogc_fid;


--
-- Name: repere_projet; Type: TABLE; Schema: zone_etude; Owner: -
--

CREATE TABLE zone_etude.repere_projet (
    id integer NOT NULL,
    nom text,
    geom public.geometry
);


--
-- Name: foret_publique ogc_fid; Type: DEFAULT; Schema: contexte; Owner: -
--

ALTER TABLE ONLY contexte.foret_publique ALTER COLUMN ogc_fid SET DEFAULT nextval('contexte.foret_publique_ogc_fid_seq'::regclass);


--
-- Name: reseau_routier ogc_fid; Type: DEFAULT; Schema: contexte; Owner: -
--

ALTER TABLE ONLY contexte.reseau_routier ALTER COLUMN ogc_fid SET DEFAULT nextval('contexte.reseau_routier_ogc_fid_seq'::regclass);


--
-- Name: hydrographie_lineaire ogc_fid; Type: DEFAULT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.hydrographie_lineaire ALTER COLUMN ogc_fid SET DEFAULT nextval('contraintes.hydrographie_lineaire_ogc_fid_seq'::regclass);


--
-- Name: hydrographie_surfacique ogc_fid; Type: DEFAULT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.hydrographie_surfacique ALTER COLUMN ogc_fid SET DEFAULT nextval('contraintes.hydrographie_surfacique_ogc_fid_seq'::regclass);


--
-- Name: natura2000_sic ogc_fid; Type: DEFAULT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.natura2000_sic ALTER COLUMN ogc_fid SET DEFAULT nextval('contraintes.natura2000_sic_ogc_fid_seq'::regclass);


--
-- Name: natura2000_zps ogc_fid; Type: DEFAULT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.natura2000_zps ALTER COLUMN ogc_fid SET DEFAULT nextval('contraintes.natura2000_zps_ogc_fid_seq'::regclass);


--
-- Name: znieff1 ogc_fid; Type: DEFAULT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.znieff1 ALTER COLUMN ogc_fid SET DEFAULT nextval('contraintes.znieff1_ogc_fid_seq'::regclass);


--
-- Name: znieff2 ogc_fid; Type: DEFAULT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.znieff2 ALTER COLUMN ogc_fid SET DEFAULT nextval('contraintes.znieff2_ogc_fid_seq'::regclass);


--
-- Name: metadata id; Type: DEFAULT; Schema: ogr_system_tables; Owner: -
--

ALTER TABLE ONLY ogr_system_tables.metadata ALTER COLUMN id SET DEFAULT nextval('ogr_system_tables.metadata_id_seq'::regclass);


--
-- Name: synthese_enjeux id; Type: DEFAULT; Schema: projet; Owner: -
--

ALTER TABLE ONLY projet.synthese_enjeux ALTER COLUMN id SET DEFAULT nextval('projet.synthese_enjeux_id_seq'::regclass);


--
-- Name: plan_implantation_brut ogc_fid; Type: DEFAULT; Schema: projet_amenagement; Owner: -
--

ALTER TABLE ONLY projet_amenagement.plan_implantation_brut ALTER COLUMN ogc_fid SET DEFAULT nextval('projet_amenagement.plan_implantation_brut_ogc_fid_seq'::regclass);


--
-- Name: releve_terrain id; Type: DEFAULT; Schema: terrain; Owner: -
--

ALTER TABLE ONLY terrain.releve_terrain ALTER COLUMN id SET DEFAULT nextval('terrain.releve_terrain_id_seq'::regclass);


--
-- Name: departement_gironde ogc_fid; Type: DEFAULT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.departement_gironde ALTER COLUMN ogc_fid SET DEFAULT nextval('zone_etude.departement_gironde_simple_ogc_fid_seq'::regclass);


--
-- Name: limite_communale ogc_fid; Type: DEFAULT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.limite_communale ALTER COLUMN ogc_fid SET DEFAULT nextval('zone_etude.limite_communale_ogc_fid_seq'::regclass);


--
-- Name: regions_france ogc_fid; Type: DEFAULT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.regions_france ALTER COLUMN ogc_fid SET DEFAULT nextval('zone_etude.regions_france_ogc_fid_seq'::regclass);


--
-- Name: regions_france_brut ogc_fid; Type: DEFAULT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.regions_france_brut ALTER COLUMN ogc_fid SET DEFAULT nextval('zone_etude.regions_france_brut_ogc_fid_seq'::regclass);


--
-- Name: foret_publique foret_publique_pkey; Type: CONSTRAINT; Schema: contexte; Owner: -
--

ALTER TABLE ONLY contexte.foret_publique
    ADD CONSTRAINT foret_publique_pkey PRIMARY KEY (ogc_fid);


--
-- Name: reseau_routier reseau_routier_pkey; Type: CONSTRAINT; Schema: contexte; Owner: -
--

ALTER TABLE ONLY contexte.reseau_routier
    ADD CONSTRAINT reseau_routier_pkey PRIMARY KEY (ogc_fid);


--
-- Name: hydrographie_lineaire hydrographie_lineaire_pkey; Type: CONSTRAINT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.hydrographie_lineaire
    ADD CONSTRAINT hydrographie_lineaire_pkey PRIMARY KEY (ogc_fid);


--
-- Name: hydrographie_surfacique hydrographie_surfacique_pkey; Type: CONSTRAINT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.hydrographie_surfacique
    ADD CONSTRAINT hydrographie_surfacique_pkey PRIMARY KEY (ogc_fid);


--
-- Name: natura2000_sic natura2000_sic_pkey; Type: CONSTRAINT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.natura2000_sic
    ADD CONSTRAINT natura2000_sic_pkey PRIMARY KEY (ogc_fid);


--
-- Name: natura2000_zps natura2000_zps_pkey; Type: CONSTRAINT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.natura2000_zps
    ADD CONSTRAINT natura2000_zps_pkey PRIMARY KEY (ogc_fid);


--
-- Name: znieff1 znieff1_pkey; Type: CONSTRAINT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.znieff1
    ADD CONSTRAINT znieff1_pkey PRIMARY KEY (ogc_fid);


--
-- Name: znieff2 znieff2_pkey; Type: CONSTRAINT; Schema: contraintes; Owner: -
--

ALTER TABLE ONLY contraintes.znieff2
    ADD CONSTRAINT znieff2_pkey PRIMARY KEY (ogc_fid);


--
-- Name: metadata metadata_schema_name_table_name_key; Type: CONSTRAINT; Schema: ogr_system_tables; Owner: -
--

ALTER TABLE ONLY ogr_system_tables.metadata
    ADD CONSTRAINT metadata_schema_name_table_name_key UNIQUE (schema_name, table_name);


--
-- Name: buffer_hydro_100m buffer_hydro_100m_pkey; Type: CONSTRAINT; Schema: projet; Owner: -
--

ALTER TABLE ONLY projet.buffer_hydro_100m
    ADD CONSTRAINT buffer_hydro_100m_pkey PRIMARY KEY (id);


--
-- Name: buffer_zps_500m buffer_zps_500m_pkey; Type: CONSTRAINT; Schema: projet; Owner: -
--

ALTER TABLE ONLY projet.buffer_zps_500m
    ADD CONSTRAINT buffer_zps_500m_pkey PRIMARY KEY (id);


--
-- Name: synthese_enjeux synthese_enjeux_pkey; Type: CONSTRAINT; Schema: projet; Owner: -
--

ALTER TABLE ONLY projet.synthese_enjeux
    ADD CONSTRAINT synthese_enjeux_pkey PRIMARY KEY (id);


--
-- Name: cloture cloture_pkey; Type: CONSTRAINT; Schema: projet_amenagement; Owner: -
--

ALTER TABLE ONLY projet_amenagement.cloture
    ADD CONSTRAINT cloture_pkey PRIMARY KEY (id);


--
-- Name: piste_acces piste_acces_pkey; Type: CONSTRAINT; Schema: projet_amenagement; Owner: -
--

ALTER TABLE ONLY projet_amenagement.piste_acces
    ADD CONSTRAINT piste_acces_pkey PRIMARY KEY (id);


--
-- Name: plan_implantation_brut plan_implantation_brut_pkey; Type: CONSTRAINT; Schema: projet_amenagement; Owner: -
--

ALTER TABLE ONLY projet_amenagement.plan_implantation_brut
    ADD CONSTRAINT plan_implantation_brut_pkey PRIMARY KEY (ogc_fid);


--
-- Name: poste_livraison poste_livraison_pkey; Type: CONSTRAINT; Schema: projet_amenagement; Owner: -
--

ALTER TABLE ONLY projet_amenagement.poste_livraison
    ADD CONSTRAINT poste_livraison_pkey PRIMARY KEY (id);


--
-- Name: tables_pv_corrige tables_pv_corrige_pkey; Type: CONSTRAINT; Schema: projet_amenagement; Owner: -
--

ALTER TABLE ONLY projet_amenagement.tables_pv_corrige
    ADD CONSTRAINT tables_pv_corrige_pkey PRIMARY KEY (id);


--
-- Name: tables_pv tables_pv_pkey; Type: CONSTRAINT; Schema: projet_amenagement; Owner: -
--

ALTER TABLE ONLY projet_amenagement.tables_pv
    ADD CONSTRAINT tables_pv_pkey PRIMARY KEY (id);


--
-- Name: releve_terrain releve_terrain_pkey; Type: CONSTRAINT; Schema: terrain; Owner: -
--

ALTER TABLE ONLY terrain.releve_terrain
    ADD CONSTRAINT releve_terrain_pkey PRIMARY KEY (id);


--
-- Name: departement_gironde departement_gironde_simple_pkey; Type: CONSTRAINT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.departement_gironde
    ADD CONSTRAINT departement_gironde_simple_pkey PRIMARY KEY (ogc_fid);


--
-- Name: limite_communale limite_communale_pkey; Type: CONSTRAINT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.limite_communale
    ADD CONSTRAINT limite_communale_pkey PRIMARY KEY (ogc_fid);


--
-- Name: regions_france_brut regions_france_brut_pkey; Type: CONSTRAINT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.regions_france_brut
    ADD CONSTRAINT regions_france_brut_pkey PRIMARY KEY (ogc_fid);


--
-- Name: regions_france regions_france_pkey; Type: CONSTRAINT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.regions_france
    ADD CONSTRAINT regions_france_pkey PRIMARY KEY (ogc_fid);


--
-- Name: repere_projet repere_projet_pkey; Type: CONSTRAINT; Schema: zone_etude; Owner: -
--

ALTER TABLE ONLY zone_etude.repere_projet
    ADD CONSTRAINT repere_projet_pkey PRIMARY KEY (id);


--
-- Name: foret_publique_geom_geom_idx; Type: INDEX; Schema: contexte; Owner: -
--

CREATE INDEX foret_publique_geom_geom_idx ON contexte.foret_publique USING gist (geom);


--
-- Name: reseau_routier_geom_geom_idx; Type: INDEX; Schema: contexte; Owner: -
--

CREATE INDEX reseau_routier_geom_geom_idx ON contexte.reseau_routier USING gist (geom);


--
-- Name: hydrographie_lineaire_geom_geom_idx; Type: INDEX; Schema: contraintes; Owner: -
--

CREATE INDEX hydrographie_lineaire_geom_geom_idx ON contraintes.hydrographie_lineaire USING gist (geom);


--
-- Name: hydrographie_surfacique_geom_geom_idx; Type: INDEX; Schema: contraintes; Owner: -
--

CREATE INDEX hydrographie_surfacique_geom_geom_idx ON contraintes.hydrographie_surfacique USING gist (geom);


--
-- Name: natura2000_sic_geom_geom_idx; Type: INDEX; Schema: contraintes; Owner: -
--

CREATE INDEX natura2000_sic_geom_geom_idx ON contraintes.natura2000_sic USING gist (geom);


--
-- Name: natura2000_zps_geom_geom_idx; Type: INDEX; Schema: contraintes; Owner: -
--

CREATE INDEX natura2000_zps_geom_geom_idx ON contraintes.natura2000_zps USING gist (geom);


--
-- Name: znieff1_geom_geom_idx; Type: INDEX; Schema: contraintes; Owner: -
--

CREATE INDEX znieff1_geom_geom_idx ON contraintes.znieff1 USING gist (geom);


--
-- Name: znieff2_geom_geom_idx; Type: INDEX; Schema: contraintes; Owner: -
--

CREATE INDEX znieff2_geom_geom_idx ON contraintes.znieff2 USING gist (geom);


--
-- Name: plan_implantation_brut_geom_geom_idx; Type: INDEX; Schema: projet_amenagement; Owner: -
--

CREATE INDEX plan_implantation_brut_geom_geom_idx ON projet_amenagement.plan_implantation_brut USING gist (geom);


--
-- Name: limite_communale_geom_geom_idx; Type: INDEX; Schema: zone_etude; Owner: -
--

CREATE INDEX limite_communale_geom_geom_idx ON zone_etude.limite_communale USING gist (geom);


--
-- Name: regions_france_brut_geom_geom_idx; Type: INDEX; Schema: zone_etude; Owner: -
--

CREATE INDEX regions_france_brut_geom_geom_idx ON zone_etude.regions_france_brut USING gist (geom);


--
-- Name: regions_france_geom_idx; Type: INDEX; Schema: zone_etude; Owner: -
--

CREATE INDEX regions_france_geom_idx ON zone_etude.regions_france USING gist (geom);


--
-- Name: ogr_system_tables_event_trigger_for_metadata; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER ogr_system_tables_event_trigger_for_metadata ON sql_drop
   EXECUTE FUNCTION ogr_system_tables.event_trigger_function_for_metadata();


--
-- PostgreSQL database dump complete
--

