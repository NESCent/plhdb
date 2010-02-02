--
-- Definition of PostgreSQL stored functions, mostly geared towards
-- making views updateable. Use of the functions is not tied to views,
-- though.
--
-- This file is part of the database definition for the Primate
-- Life Histories Database working group.
--
-- Copyright (C) 2007-2008, Hilmar Lapp, hlapp at gmx.net
-- Copyright (C) 2007-2008, National Evolutionary Synthesis Center (NESCent)
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--

SET search_path TO plhdb, public;

-- #################################################################
-- Looking up, inserting, or updating rows in table cvterm
-- #################################################################

DROP FUNCTION get_cvterm_oid(
       p_Name cvterm.name%TYPE
       , p_Code cvterm.code%TYPE
       , p_Identifier cvterm.identifier%TYPE
       , p_Namespace cvterm.namespace%TYPE
       , p_Parent_Name cvterm.name%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_cvterm_oid(
       p_Name cvterm.name%TYPE
       , p_Code cvterm.code%TYPE
       , p_Identifier cvterm.identifier%TYPE
       , p_Namespace cvterm.namespace%TYPE
       , p_Parent_Name cvterm.name%TYPE
       , p_do_DML integer)
RETURNS cvterm.cvterm_oid%TYPE AS
$$
DECLARE
        v_term_oid plhdb.cvterm.cvterm_oid%TYPE;
BEGIN
        -- obtain term primary key, first by identifier
        IF p_Identifier IS NOT NULL THEN
               SELECT INTO v_term_oid cvterm_oid 
               FROM plhdb.cvterm WHERE identifier = p_Identifier;
        END IF;
        -- if not found, try by name and namespace
        IF v_term_oid IS NULL AND p_Name IS NOT NULL THEN
               SELECT INTO v_term_oid cvterm_oid
               FROM plhdb.cvterm 
               WHERE name = p_Name AND namespace = p_Namespace;
        END IF;
        -- if still not found, try by code, parent term, and namespace
        IF v_term_oid IS NULL AND p_Code IS NOT NULL THEN
               SELECT INTO v_term_oid t.cvterm_oid 
               FROM plhdb.cvterm t 
                    JOIN plhdb.cvterm_relationship rel ON (rel.subject_oid = t.cvterm_oid)
                    JOIN plhdb.cvterm p ON (rel.object_oid = p.cvterm_oid)
               WHERE t.code = p_Code AND t.namespace = p_Namespace
               AND   p.name = p_Parent_Name AND p.namespace = p_Namespace;
        END IF;
        -- if DML is not allowed we've done all we can
        IF p_do_DML = 0 THEN
               RETURN v_term_oid;
        END IF;
        -- otherwise create if not found, and update otherwise
        IF v_term_oid IS NULL AND p_do_DML & 1 = 1 THEN
               INSERT INTO plhdb.cvterm (name, code, identifier, namespace)
               VALUES (p_Name, p_Code, p_Identifier, p_Namespace);
               SELECT INTO v_term_oid CURRVAL('plhdb.cvterm_cvterm_oid_seq');
        ELSIF p_do_DML & 2 = 2 THEN
               UPDATE plhdb.cvterm SET
                      name = COALESCE(p_Name, name)
                      , code = COALESCE(p_Code, code)
                      , identifier = COALESCE(p_Identifier, identifier)
                      , namespace = COALESCE(p_Namespace, namespace)
               WHERE cvterm_oid = v_term_oid;
        END IF;
        RETURN v_term_oid;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION get_cvterm_oid(
       p_Oid cvterm.cvterm_oid%TYPE
       , p_Name cvterm.name%TYPE
       , p_Code cvterm.code%TYPE
       , p_Identifier cvterm.identifier%TYPE
       , p_Namespace cvterm.namespace%TYPE
       , p_Parent_Name cvterm.name%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_cvterm_oid(
       p_Oid cvterm.cvterm_oid%TYPE
       , p_Name cvterm.name%TYPE
       , p_Code cvterm.code%TYPE
       , p_Identifier cvterm.identifier%TYPE
       , p_Namespace cvterm.namespace%TYPE
       , p_Parent_Name cvterm.name%TYPE
       , p_do_DML integer)
RETURNS cvterm.cvterm_oid%TYPE AS
$$
DECLARE
        v_term_oid plhdb.cvterm.cvterm_oid%TYPE;
BEGIN
        IF p_Oid IS NOT NULL THEN
               RETURN p_Oid;
        END IF;
        v_term_oid := plhdb.get_cvterm_oid(p_Name
                                           , p_Code
                                           , p_Identifier
                                           , p_Namespace
                                           , p_Parent_Name
                                           , p_do_DML);
        RETURN v_term_oid;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Looking up, inserting, or updating rows in table cvterm_relationship
-- #################################################################

DROP FUNCTION get_cvterm_relationship_oid(
       p_Subj_Oid cvterm.cvterm_oid%TYPE
       , p_Subj_Name cvterm.name%TYPE
       , p_Subj_Code cvterm.code%TYPE
       , p_Subj_Identifier cvterm.identifier%TYPE
       , p_Subj_Namespace cvterm.namespace%TYPE
       , p_Pred_Oid cvterm.cvterm_oid%TYPE
       , p_Pred_Name cvterm.name%TYPE
       , p_Pred_Code cvterm.code%TYPE
       , p_Pred_Identifier cvterm.identifier%TYPE
       , p_Pred_Namespace cvterm.namespace%TYPE
       , p_Obj_Oid cvterm.cvterm_oid%TYPE
       , p_Obj_Name cvterm.name%TYPE
       , p_Obj_Code cvterm.code%TYPE
       , p_Obj_Identifier cvterm.identifier%TYPE
       , p_Obj_Namespace cvterm.namespace%TYPE
       , p_Old_Subj_Oid cvterm.cvterm_oid%TYPE
       , p_Old_Obj_Oid cvterm.cvterm_oid%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_cvterm_relationship_oid(
       p_Subj_Oid cvterm.cvterm_oid%TYPE
       , p_Subj_Name cvterm.name%TYPE
       , p_Subj_Code cvterm.code%TYPE
       , p_Subj_Identifier cvterm.identifier%TYPE
       , p_Subj_Namespace cvterm.namespace%TYPE
       , p_Pred_Oid cvterm.cvterm_oid%TYPE
       , p_Pred_Name cvterm.name%TYPE
       , p_Pred_Code cvterm.code%TYPE
       , p_Pred_Identifier cvterm.identifier%TYPE
       , p_Pred_Namespace cvterm.namespace%TYPE
       , p_Obj_Oid cvterm.cvterm_oid%TYPE
       , p_Obj_Name cvterm.name%TYPE
       , p_Obj_Code cvterm.code%TYPE
       , p_Obj_Identifier cvterm.identifier%TYPE
       , p_Obj_Namespace cvterm.namespace%TYPE
       , p_Old_Subj_Oid cvterm.cvterm_oid%TYPE
       , p_Old_Obj_Oid cvterm.cvterm_oid%TYPE
       , p_do_DML integer)
RETURNS cvterm_relationship.cvterm_relationship_oid%TYPE AS
$$
DECLARE
        v_rel_oid plhdb.cvterm_relationship.cvterm_relationship_oid%TYPE;
        v_subj_oid plhdb.cvterm.cvterm_oid%TYPE;
        v_pred_oid plhdb.cvterm.cvterm_oid%TYPE;
        v_obj_oid plhdb.cvterm.cvterm_oid%TYPE;
BEGIN
        -- obtain primary key of subject term (create if necessary)
        IF p_Subj_Oid IS NULL THEN
               v_subj_oid := plhdb.get_cvterm_oid(p_Subj_Name
                                                  , p_Subj_Code
                                                  , p_Subj_Identifier
                                                  , p_Subj_Namespace
                                                  , NULL
                                                  , p_do_DML);
        ELSE
               v_subj_oid := p_Subj_Oid;
        END IF;
        -- obtain primary key of predicate term (create if necessary)
        IF p_Pred_Oid IS NULL THEN
               v_pred_oid := plhdb.get_cvterm_oid(p_Pred_Name
                                                  , p_Pred_Code
                                                  , p_Pred_Identifier
                                                  , p_Pred_Namespace
                                                  , NULL
                                                  , p_do_DML);
        ELSE
               v_pred_oid := p_Pred_Oid;
        END IF;
        -- obtain primary key of object term (create if necessary)
        IF p_Obj_Oid IS NULL THEN
               v_obj_oid := plhdb.get_cvterm_oid(p_Obj_Name
                                                 , p_Obj_Code
                                                 , p_Obj_Identifier
                                                 , p_Obj_Namespace
                                                 , NULL
                                                 , p_do_DML);
        ELSE
               v_obj_oid := p_Obj_Oid;
        END IF;
        -- obtain primary key of relationship (if it exists already)
        SELECT INTO v_rel_oid cvterm_relationship_oid
        FROM plhdb.cvterm_relationship
        WHERE subject_oid = COALESCE(p_Old_Subj_Oid, v_subj_oid)
        AND object_oid = COALESCE(p_Old_Obj_Oid, v_obj_oid);
        -- if no DML allowed, we've done all we can
        IF p_do_DML = 0 THEN
               RETURN v_rel_oid;
        END IF;
        -- insert if not found, and update otherwise
        IF v_rel_oid IS NULL AND p_do_DML & 1 = 1 THEN
               INSERT INTO plhdb.cvterm_relationship (subject_oid, 
                                                      predicate_oid, 
                                                      object_oid)
               VALUES (v_subj_oid, v_pred_oid, v_obj_oid);
               SELECT INTO v_rel_oid CURRVAL('plhdb.cvterm_relationship_cvterm_relationship_oid_seq');
        ELSIF p_do_DML & 2 = 2 THEN
               UPDATE plhdb.cvterm_relationship SET
                      subject_oid = v_subj_oid
                      , predicate_oid = v_pred_oid
                      , object_oid = v_obj_oid
               WHERE cvterm_relationship_oid = v_rel_oid;
        END IF;
        RETURN v_rel_oid;
END;
$$
LANGUAGE plpgsql;
       

-- #################################################################
-- Looking up, inserting, or updating rows in table taxon
-- #################################################################

DROP FUNCTION get_taxon_oid(p_Common_Name taxon.Common_Name%TYPE
                            , p_Scientific_Name taxon.Scientific_Name%TYPE
                            , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_taxon_oid(p_Common_Name taxon.Common_Name%TYPE
                              , p_Scientific_Name taxon.Scientific_Name%TYPE
                              , p_do_DML integer)
RETURNS taxon.taxon_oid%TYPE AS 
$$
DECLARE
        v_taxon_oid plhdb.taxon.taxon_oid%TYPE;
BEGIN
        -- obtain taxon by scientific name
        SELECT INTO v_taxon_oid taxon_oid 
               FROM plhdb.taxon WHERE scientific_name = p_Scientific_Name;
        -- if unsuccessful try by common name
        IF NOT FOUND THEN
               SELECT INTO v_taxon_oid taxon_oid 
                      FROM plhdb.taxon WHERE common_name = p_common_Name;
        END IF;
        -- if no DML allowed, we've done all we can
        IF p_do_DML = 0 THEN
               RETURN v_taxon_oid;
        END IF;
        -- if not found, insert as new, otherwise update
        IF v_taxon_oid IS NULL AND p_do_DML & 1 = 1 THEN
               INSERT INTO plhdb.taxon (scientific_name, common_name)
               VALUES (p_Scientific_Name, p_Common_Name);
               SELECT INTO v_taxon_oid CURRVAL('plhdb.taxon_taxon_oid_seq');
        ELSIF p_do_DML & 2 = 2 THEN
               UPDATE plhdb.taxon SET
                      common_name = p_Common_Name
                      , scientific_name = p_Scientific_Name
               WHERE taxon_oid = v_taxon_oid;
        END IF;
        RETURN v_taxon_oid;
END;
$$
LANGUAGE plpgsql;

COMMENT ON FUNCTION get_taxon_oid(p_Common_Name taxon.Common_Name%TYPE
                                  , p_Scientific_Name taxon.Scientific_Name%TYPE
                                  , p_do_DML integer)
IS 'Retrieves the primary key of the taxon qualified by the given parameters, creating the record if not found, and updating it otherwise, provided the DML parameter is non-zero. Params: common name, scientific name, 0 to disallow DML and bit-wise OR of 1 and 2 to allow insert and update, respectively.'; 


-- #################################################################
-- Looking up, inserting, or updating rows in table site
-- #################################################################

DROP FUNCTION get_site_oid(p_Name site.name%TYPE
                           , p_Latitude site.Latitude%TYPE
                           , p_Longitude site.Longitude%TYPE
                           , p_Geodetic_Datum site.geodetic_datum%TYPE
                           , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_site_oid(p_Name site.name%TYPE
                             , p_Latitude site.Latitude%TYPE
                             , p_Longitude site.Longitude%TYPE
                             , p_Geodetic_Datum site.geodetic_datum%TYPE
                             , p_do_DML integer)
RETURNS site.site_oid%TYPE AS 
$$
DECLARE
        v_site_oid plhdb.site.site_oid%TYPE;
BEGIN
        -- obtain or, if new, insert site
        SELECT INTO v_site_oid site_oid 
               FROM plhdb.site WHERE name = p_Name;
        -- if no DML allowed, we've done all we can
        IF p_do_DML = 0 THEN
               RETURN v_site_oid;
        END IF;
        -- if not found, insert as new, otherwise update
        IF v_site_oid IS NULL AND p_do_DML & 1 = 1 THEN
               IF p_Geodetic_Datum IS NULL THEN
                       -- allow default value of geodetic_datum to take effect
                       INSERT INTO plhdb.site (name, latitude, longitude)
                       VALUES (p_Name, p_Latitude, p_Longitude);
               ELSE
                       INSERT INTO plhdb.site (name,latitude,longitude,geodetic_datum)
                       VALUES (p_Name,p_Latitude,p_Longitude,p_Geodetic_Datum);
               END IF;
               SELECT INTO v_site_oid CURRVAL('plhdb.site_site_oid_seq');
        ELSIF p_do_DML & 2 = 2 THEN
               UPDATE plhdb.site SET
                       name = p_Name
                       , latitude = p_Latitude
                       , longitude = p_Longitude
                       , geodetic_datum = COALESCE(p_Geodetic_Datum, 
                                                   geodetic_datum)
               WHERE site_oid = v_site_oid;
        END IF;
        RETURN v_site_oid;
END;
$$
LANGUAGE plpgsql;

COMMENT ON FUNCTION get_site_oid(p_Name site.name%TYPE
                                 , p_Latitude site.Latitude%TYPE
                                 , p_Longitude site.Longitude%TYPE
                                 , p_Geodetic_Datum site.geodetic_datum%TYPE
                                 , p_do_DML integer)
IS 'Retrieves the primary key of the site identified by the given name, creating the record if not found and updating it otherwise, provided the DML parameter is true. Params: name, latitude, longitude, geodetic datum, 0 to disallow DML and bit-wise OR of 1 and 2 to allow insert and update, respectively. If geodetic datum is NULL, the default (or existing) value will take effect.'; 

-- #################################################################
-- Looking up, inserting, or updating rows in table study
-- #################################################################

DROP FUNCTION get_study_oid(p_Id study.id%TYPE) CASCADE;

CREATE FUNCTION get_study_oid(p_Id study.id%TYPE)
RETURNS study.study_oid%TYPE AS
$$
DECLARE
        v_study_oid plhdb.study.study_oid%TYPE;
BEGIN
        SELECT INTO v_study_oid study_oid FROM plhdb.study WHERE id = p_Id;
        RETURN v_study_oid;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Looking up, inserting, or updating rows in table individual
-- #################################################################

DROP FUNCTION get_individual_oid(
       p_Name individual.name%TYPE
       , p_Id individual.id%TYPE
       , p_Sex individual.sex%TYPE
       , p_Birthgroup individual.birthgroup%TYPE
       , p_Birthgroup_certainty individual.birthgroup_certainty%TYPE
       , p_Is_first_born individual.is_first_born%TYPE
       , p_Study_Oid study.study_oid%TYPE
       , p_Study_ID study.id%TYPE
       , p_Old_Oid individual.individual_oid%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_individual_oid(
       p_Name individual.name%TYPE
       , p_Id individual.id%TYPE
       , p_Sex individual.sex%TYPE
       , p_Birthgroup individual.birthgroup%TYPE
       , p_Birthgroup_certainty individual.birthgroup_certainty%TYPE
       , p_Is_first_born individual.is_first_born%TYPE
       , p_Study_Oid study.study_oid%TYPE
       , p_Study_ID study.id%TYPE
       , p_Old_Oid individual.individual_oid%TYPE
       , p_do_DML integer)
RETURNS individual.individual_oid%TYPE AS
$$
DECLARE
        v_ind_oid plhdb.individual.individual_oid%TYPE;
        v_study_oid plhdb.study.study_oid%TYPE;
BEGIN
        -- obtain the primary key of the study
        IF p_Study_Oid IS NULL THEN
               SELECT INTO v_study_oid study_oid 
               FROM plhdb.study WHERE id = p_Study_ID;
        ELSE
               v_study_oid := p_Study_Oid;
        END IF;
        -- obtain the primary key of the individual
        IF p_Old_Oid IS NULL THEN
               -- look up: first by id
               SELECT INTO v_ind_oid individual_oid 
               FROM plhdb.individual 
               WHERE id = p_Id AND study_oid = v_study_oid;
               -- if unsuccessful try by name
               IF NOT FOUND THEN
                      SELECT INTO v_ind_oid individual_oid 
                      FROM plhdb.individual 
                      WHERE name = p_Name AND study_oid = v_study_oid;
               END IF;
        ELSE 
               -- we will be updating the old record
               v_ind_oid := p_Old_Oid;
        END IF;
        -- if no DML allowed, we've done all we can
        IF p_do_DML = 0 THEN
               RETURN v_ind_oid;
        END IF;
        -- if not found, insert as new, otherwise update
        IF v_ind_oid IS NULL AND p_do_DML & 1 = 1 THEN
               INSERT INTO plhdb.individual (
                                       name, id, sex
                                       , birthgroup, birthgroup_certainty
                                       , is_first_born, study_oid)
               VALUES (p_Name, p_Id, p_Sex, p_Birthgroup, p_Birthgroup_certainty
                       , p_Is_first_born, v_study_oid);
               SELECT INTO v_ind_oid 
                      CURRVAL('plhdb.individual_individual_oid_seq');
        ELSIF p_do_DML & 2 = 2 THEN
               UPDATE plhdb.individual SET
                      name = p_Name
                      , id = p_Id
                      , sex = p_Sex
                      , birthgroup = p_Birthgroup
                      , birthgroup_certainty = p_Birthgroup_certainty
                      , is_first_born = p_Is_First_Born
                      , study_oid = v_study_oid
               WHERE individual_oid = v_ind_oid;               
        END IF;
        RETURN v_ind_oid;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION get_individual_oid(
       p_Id individual.id%TYPE
       , p_Study_Oid study.study_oid%TYPE
       , p_Study_ID study.id%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_individual_oid(
       p_Id individual.id%TYPE
       , p_Study_Oid study.study_oid%TYPE
       , p_Study_ID study.id%TYPE
       , p_do_DML integer)
RETURNS individual.individual_oid%TYPE AS
$$
DECLARE
        v_ind_oid plhdb.individual.individual_oid%TYPE;
        indrec RECORD;
        v_studies TEXT;
        v_numstudies INTEGER;
BEGIN
        -- as a shortcut to save time, and to prevent existing records
        -- from having most of their attributes updates to null, run
        -- query directly
        IF p_Study_Oid IS NULL THEN
               IF p_Study_ID IS NULL THEN
                      v_numstudies := 0;
                      v_studies := '';
                      FOR indrec IN SELECT i.individual_oid, s.id AS sid
                                    FROM plhdb.individual i 
                                      JOIN plhdb.study s 
                                      ON (i.study_oid = s.study_oid)
                                    WHERE i.id = p_Id
                      LOOP
                             v_ind_oid := indrec.individual_oid;
                             v_numstudies := v_numstudies+1;
                             IF v_numstudies > 1 THEN
                                     v_studies := v_studies || ', ';
                             END IF;
                             v_studies := v_studies || indrec.sid; 
                      END LOOP;
                      IF v_numstudies > 1 THEN
                             RAISE EXCEPTION 'ID % is ambiguous for individual, is in % different studies (%)', p_Id, v_numstudies, v_studies;
                      END IF;
               ELSE
                      SELECT INTO v_ind_oid i.individual_oid
                      FROM plhdb.individual i 
                        JOIN plhdb.study s ON (i.study_oid = s.study_oid)
                      WHERE i.id = p_Id AND s.id = p_Study_ID;
               END IF;
        ELSE
               SELECT INTO v_ind_oid i.individual_oid
               FROM plhdb.individual i 
               WHERE i.id = p_Id AND i.study_oid = p_Study_Oid;
        END IF;
        -- update/insert only if not found, and if DML allowed
        IF p_do_DML > 0 AND v_ind_oid IS NULL THEN
               v_ind_oid := plhdb.get_individual_oid(NULL,
                                                     p_Id,
                                                     NULL,NULL,NULL,NULL,
                                                     p_Study_Oid,
                                                     p_Study_ID,
                                                     NULL,
                                                     p_do_DML);
        END IF;
        RETURN v_ind_oid;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Looking up, inserting, or updating rows in table individual_relationship
-- #################################################################

DROP FUNCTION get_parent_rel_oid(
       p_Child_oid individual.individual_oid%TYPE
       , p_Parent_oid individual.individual_oid%TYPE
       , p_Old_Parent_oid individual.individual_oid%TYPE
       , p_Reltype individual_relationship.reltype%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_parent_rel_oid(
       p_Child_oid individual.individual_oid%TYPE
       , p_Parent_oid individual.individual_oid%TYPE
       , p_Old_Parent_oid individual.individual_oid%TYPE
       , p_Reltype individual_relationship.reltype%TYPE
       , p_do_DML integer)
RETURNS individual_relationship.individual_relationship_oid%TYPE AS
$$
DECLARE
        v_rel_oid plhdb.individual_relationship.individual_relationship_oid%TYPE;
BEGIN
        -- obtain the relationship record to update for the child, and either
        -- old parent or new parent
        SELECT INTO v_rel_oid individual_relationship_oid
        FROM plhdb.individual_relationship
        WHERE child_oid = p_Child_oid 
        AND parent_oid = COALESCE(p_Old_Parent_oid, p_Parent_oid);
        -- if DML is not allowed, this is all we can do
        IF p_do_DML = 0 THEN
               RETURN v_rel_oid;
        END IF;
        -- if we are updating the parent to null, it means to delete the record
        IF p_Old_Parent_oid IS NOT NULL AND p_Parent_oid IS NULL THEN
               DELETE FROM plhdb.individual_relationship 
               WHERE individual_relationship_oid = v_rel_oid;
        END IF;
        -- otherwise, either insert (if relationship wasn't found) or update
        --
        -- but be careful not to create a relationship to indicate the
        -- absence of one (and no relationship is different from
        -- failing to find the parent, which we do want to cause a
        -- failure in the following insert or update)
        IF v_rel_oid IS NULL AND p_Parent_Oid IS NOT NULL THEN
               INSERT INTO plhdb.individual_relationship (child_oid, 
                                                          parent_oid,
                                                          reltype)
               VALUES (p_Child_oid, p_Parent_oid, p_Reltype);
               SELECT INTO v_rel_oid CURRVAL('plhdb.individual_relationship_individual_relationship_oid_seq');
        ELSIF p_Parent_Oid IS NOT NULL THEN
               UPDATE plhdb.individual_relationship SET
                      parent_oid = p_Parent_oid
                      , reltype = p_Reltype
               WHERE individual_relationship_oid = v_rel_oid;
        END IF;
        RETURN v_rel_oid;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Looking up, inserting, or updating rows in table observation
-- #################################################################

DROP FUNCTION get_observation_oid(
       p_Time_of_observation observation.time_of_observation%TYPE
       , p_Time_error observation.time_error%TYPE
       , p_Min_boundary observation.min_boundary%TYPE
       , p_Max_boundary observation.max_boundary%TYPE
       , p_Prob_type_oid cvterm.cvterm_oid%TYPE
       , p_CvTerm_oid cvterm.cvterm_oid%TYPE
       , p_Individual_oid individual.individual_oid%TYPE
       , p_Old_Observation observation.observation_oid%TYPE
       , p_do_DML integer
       )
CASCADE;

CREATE FUNCTION get_observation_oid(
       p_Time_of_observation observation.time_of_observation%TYPE
       , p_Time_error observation.time_error%TYPE
       , p_Min_boundary observation.min_boundary%TYPE
       , p_Max_boundary observation.max_boundary%TYPE
       , p_Prob_type_oid cvterm.cvterm_oid%TYPE
       , p_CvTerm_oid cvterm.cvterm_oid%TYPE
       , p_Individual_oid individual.individual_oid%TYPE
       , p_Old_Observation observation.observation_oid%TYPE
       , p_do_DML integer
       )
RETURNS observation.observation_oid%TYPE AS
$$
DECLARE
        v_obs_oid plhdb.observation.observation_oid%TYPE;
        v_newobs_oid plhdb.observation.observation_oid%TYPE;
BEGIN
        -- try to find observation record if it exists already
        SELECT INTO v_obs_oid observation_oid FROM plhdb.observation 
        WHERE time_of_observation = p_Time_of_observation
        AND type_oid = p_CvTerm_oid
        AND individual_oid = p_Individual_oid;
        -- If we are updating from an old record, the record with the
        -- new unique key values may exist already, and therefore
        -- would clash if we updated the existing one. Hence, do so
        -- only if the new unique values haven't been found.
        IF p_Old_Observation IS NOT NULL AND v_obs_oid IS NULL THEN
               v_obs_oid := p_Old_Observation;
        END IF;
        -- if DML is not allowed, we've done all we can
        IF p_do_DML = 0 THEN
               RETURN v_obs_oid;
        END IF;
        -- insert if not found and update otherwise
        IF v_obs_oid IS NULL AND p_do_DML & 1 = 1 THEN
               INSERT INTO plhdb.observation (time_of_observation
                                              , time_error
                                              , min_boundary
                                              , max_boundary
                                              , prob_type_oid
                                              , type_oid
                                              , individual_oid)
               VALUES (p_Time_of_observation, 
                       p_Time_error, p_Min_boundary, p_Max_boundary,
                       p_Prob_type_oid, p_CvTerm_oid, p_Individual_Oid);
               SELECT INTO v_obs_oid 
                      CURRVAL('plhdb.observation_observation_oid_seq');
        ELSIF p_do_DML & 2 = 2 THEN
               UPDATE plhdb.observation SET
                      time_of_observation = p_Time_of_observation
                      , time_error = CASE WHEN p_Time_error < 0 
                                     THEN time_error
                                     ELSE p_Time_error
                                     END
                      , min_boundary = p_Min_boundary
                      , max_boundary = p_Max_boundary
                      , prob_type_oid = p_Prob_type_oid
                      , type_oid = p_CvTerm_oid
                      , individual_oid = p_Individual_oid
               WHERE observation_oid = v_obs_oid;
        END IF; 
        RETURN v_obs_oid;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION get_observation_oid(
       p_Time_of_observation observation.time_of_observation%TYPE
       , p_Time_error observation.time_error%TYPE
       , p_CvTerm_oid cvterm.cvterm_oid%TYPE
       , p_Individual_oid individual.individual_oid%TYPE
       , p_do_DML integer
       )
CASCADE;

CREATE FUNCTION get_observation_oid(
       p_Time_of_observation observation.time_of_observation%TYPE
       , p_Time_error observation.time_error%TYPE
       , p_CvTerm_oid cvterm.cvterm_oid%TYPE
       , p_Individual_oid individual.individual_oid%TYPE
       , p_do_DML integer
       )
RETURNS observation.observation_oid%TYPE AS
$$
DECLARE
        v_obs_oid plhdb.observation.observation_oid%TYPE;
BEGIN
        v_obs_oid := plhdb.get_observation_oid(
                                         p_Time_of_observation
                                         , p_Time_error
                                         , NULL
                                         , NULL
                                         , NULL
                                         , p_CvTerm_oid
                                         , p_Individual_oid
                                         , NULL
                                         , p_do_DML);
        RETURN v_obs_oid;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION get_observation_oid(
       p_Time_of_observation observation.time_of_observation%TYPE
       , p_Time_error observation.time_error%TYPE
       , p_CvTerm_oid cvterm.cvterm_oid%TYPE
       , p_Individual_oid individual.individual_oid%TYPE
       , p_Old_Observation observation.observation_oid%TYPE
       , p_do_DML integer
       )
CASCADE;

CREATE FUNCTION get_observation_oid(
       p_Time_of_observation observation.time_of_observation%TYPE
       , p_Time_error observation.time_error%TYPE
       , p_CvTerm_oid cvterm.cvterm_oid%TYPE
       , p_Individual_oid individual.individual_oid%TYPE
       , p_Old_Observation observation.observation_oid%TYPE
       , p_do_DML integer
       )
RETURNS observation.observation_oid%TYPE AS
$$
DECLARE
        v_obs_oid plhdb.observation.observation_oid%TYPE;
BEGIN
        v_obs_oid := plhdb.get_observation_oid(
                                         p_Time_of_observation
                                         , p_Time_error
                                         , NULL
                                         , NULL
                                         , NULL
                                         , p_CvTerm_oid
                                         , p_Individual_oid
                                         , p_Old_Observation
                                         , p_do_DML);
        RETURN v_obs_oid;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Looking up, inserting, or updating rows in table recording_period
-- #################################################################

DROP FUNCTION get_recordingperiod_oid(
       p_Start_Oid observation.observation_oid%TYPE
       , p_End_Oid observation.observation_oid%TYPE
       , p_Type_Oid cvterm.cvterm_oid%TYPE
       , p_Old_Start_Oid observation.observation_oid%TYPE
       , p_Old_End_Oid observation.observation_oid%TYPE
       , p_Old_Type_Oid cvterm.cvterm_oid%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_recordingperiod_oid(
       p_Start_Oid observation.observation_oid%TYPE
       , p_End_Oid observation.observation_oid%TYPE
       , p_Type_Oid cvterm.cvterm_oid%TYPE
       , p_Old_Start_Oid observation.observation_oid%TYPE
       , p_Old_End_Oid observation.observation_oid%TYPE
       , p_Old_Type_Oid cvterm.cvterm_oid%TYPE
       , p_do_DML integer)
RETURNS recordingperiod.recordingperiod_oid%TYPE AS
$$
DECLARE
        v_recper_oid plhdb.recordingperiod.recordingperiod_oid%TYPE;
        v_newrec_oid plhdb.recordingperiod.recordingperiod_oid%TYPE;
BEGIN
        -- obtain the primary key of the record, possibly locating it
        -- by old values
        SELECT INTO v_recper_oid recordingperiod_oid
        FROM plhdb.recordingperiod
        WHERE start_oid = p_Start_Oid
        AND   COALESCE(end_oid, -1) = COALESCE(p_End_Oid, -1)
        AND   type_oid = p_Type_Oid;
        -- locating new and old records needs to be done separately
        -- because one of the unique key columns (end_oid) is nullable
        IF p_Old_Start_Oid IS NOT NULL THEN
               v_newrec_oid := v_recper_oid;
               SELECT INTO v_recper_oid recordingperiod_oid
               FROM plhdb.recordingperiod
               WHERE start_oid = p_Old_Start_Oid
               AND   COALESCE(end_oid, -1) = COALESCE(p_Old_End_Oid, -1)
               AND   type_oid = p_Old_Type_Oid;
               -- If the old record is found and a record with the new
               -- values exists already (and is different one than the
               -- old), we can't update the old one to the new values,
               -- nor insert the new values as a new record as
               -- otherwise we'd get a unique key failure. We'll
               -- interpret this as a request to delete the old record
               -- (provided it is different from the new one), so as
               -- to switch it to the new. This may have undesirable
               -- effects, and may need to be changed.
               IF FOUND AND v_newrec_oid != v_recper_oid THEN
                      DELETE FROM plhdb.recordingperiod 
                      WHERE recordingperiod_oid = v_recper_oid;
                      v_recper_oid := v_newrec_oid;
               ELSIF v_newrec_oid IS NOT NULL THEN
                      -- getting here means that either the old record
                      -- hasn't been found but the new one has, or
                      -- that both old and new are identical
                      v_recper_oid := v_newrec_oid;
               END IF;
        END IF;
        -- If DML is not allowed, we've done all we can. Also, if the
        -- new record exists already, there's nothing to be updated
        -- because all columns are in the unique key constraint.
        IF (p_do_DML = 0)
           -- are we updating but the new values already form a record?
           OR (v_recper_oid = v_newrec_oid)
           -- are we inserting but the record exists already?
           OR (v_recper_oid IS NOT NULL AND p_Old_Start_Oid IS NULL) THEN
               RETURN v_recper_oid;
        END IF;
        -- insert if not found, and update to new values otherwise
        IF v_recper_oid IS NULL AND p_do_DML & 1 = 1 THEN
               INSERT INTO plhdb.recordingperiod (start_oid, end_oid, type_oid)
               VALUES (p_Start_Oid, p_End_Oid, p_Type_Oid);
               SELECT INTO v_recper_oid CURRVAL('plhdb.recordingperiod_recordingperiod_oid_seq');
        ELSIF p_do_DML & 2 = 2 THEN
               UPDATE plhdb.recordingperiod SET
                      start_oid = p_Start_Oid
                      , end_oid = p_End_Oid
                      , type_oid = p_Type_Oid
               WHERE recordingperiod_oid = v_recper_oid;
        END IF;
        RETURN v_recper_oid;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION get_recordingperiod_oid(
       p_Start_Oid observation.observation_oid%TYPE
       , p_End_Oid observation.observation_oid%TYPE
       , p_Type_Oid cvterm.cvterm_oid%TYPE
       , p_do_DML integer)
CASCADE;

CREATE FUNCTION get_recordingperiod_oid(
       p_Start_Oid observation.observation_oid%TYPE
       , p_End_Oid observation.observation_oid%TYPE
       , p_Type_Oid cvterm.cvterm_oid%TYPE
       , p_do_DML integer)
RETURNS recordingperiod.recordingperiod_oid%TYPE AS
$$
DECLARE
        v_recper_oid plhdb.recordingperiod.recordingperiod_oid%TYPE;
BEGIN
        v_recper_oid := plhdb.get_recordingperiod_oid(
                                            p_Start_Oid, p_End_Oid, p_Type_Oid
                                            , NULL, NULL, NULL
                                            , p_do_DML);
        RETURN v_recper_oid;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Functions for PLHDB API views
-- #################################################################

SET search_path TO public, pg_catalog;

-- #################################################################
-- Updating PLHDB recordingperiods
-- #################################################################

DROP FUNCTION upd_plhdb_recordingperiod(
        p_Anim_OID plhdb.individual.individual_oid%TYPE
        , p_Startdate plhdb.observation.time_of_observation%TYPE
        , p_Startdate_Error plhdb.observation.time_error%TYPE
        , p_Starttype plhdb.cvterm.code%TYPE
        , p_Stopdate plhdb.observation.time_of_observation%TYPE
        , p_Stopdate_Error plhdb.observation.time_error%TYPE
        , p_Stoptype plhdb.cvterm.code%TYPE
        , p_Periodtype plhdb.cvterm.name%TYPE
        , p_Old_Anim_OID plhdb.individual.individual_oid%TYPE
        , p_Old_Startdate plhdb.observation.time_of_observation%TYPE
        , p_Old_Starttype plhdb.cvterm.code%TYPE
        , p_Old_Stopdate plhdb.observation.time_of_observation%TYPE
        , p_Old_Stoptype plhdb.cvterm.code%TYPE)
CASCADE;

CREATE FUNCTION upd_plhdb_recordingperiod(
        p_Anim_OID plhdb.individual.individual_oid%TYPE
        , p_Startdate plhdb.observation.time_of_observation%TYPE
        , p_Startdate_Error plhdb.observation.time_error%TYPE
        , p_Starttype plhdb.cvterm.code%TYPE
        , p_Stopdate plhdb.observation.time_of_observation%TYPE
        , p_Stopdate_Error plhdb.observation.time_error%TYPE
        , p_Stoptype plhdb.cvterm.code%TYPE
        , p_Periodtype plhdb.cvterm.name%TYPE
        , p_Old_Anim_OID plhdb.individual.individual_oid%TYPE
        , p_Old_Startdate plhdb.observation.time_of_observation%TYPE
        , p_Old_Starttype plhdb.cvterm.code%TYPE
        , p_Old_Stopdate plhdb.observation.time_of_observation%TYPE
        , p_Old_Stoptype plhdb.cvterm.code%TYPE)
RETURNS boolean AS
$$
DECLARE
      v_pterm_oid plhdb.cvterm.cvterm_oid%TYPE;
      v_ostart_oid plhdb.observation.observation_oid%TYPE;
      v_nstart_oid plhdb.observation.observation_oid%TYPE;
      v_oend_oid plhdb.observation.observation_oid%TYPE;
      v_nend_oid plhdb.observation.observation_oid%TYPE;
      v_ostart_type_oid plhdb.cvterm.cvterm_oid%TYPE;
      v_oend_type_oid plhdb.cvterm.cvterm_oid%TYPE;
BEGIN
       -- Update the recording period means under the current data model
       -- that we do have at least a start date, and there is a
       -- non-null recording period record to update.
       --
       -- To locate the existing recording period we will need the old
       -- start and end observation, as well as the period type term.
       v_pterm_oid := plhdb.get_cvterm_oid(p_Periodtype,
                                           NULL, NULL, 'period types', NULL,
                                           0);
       -- old and new start type might be identical, so let's store the
       -- primary key to possibly save a second lookup (note that this
       -- must exist)
       v_ostart_type_oid := plhdb.get_cvterm_oid(NULL, p_Old_Starttype,
                                                 NULL, 'event types',
                                                 'start of recording', 0);
       v_ostart_oid := plhdb.get_observation_oid(p_Old_Startdate, NULL, 
                                                 v_ostart_type_oid, 
                                                 p_Old_Anim_OID, 
                                                 0);
       -- the old end observation may be null (if there was no stop date)
       IF p_Old_Stopdate IS NOT NULL THEN
              -- similarly as for the start observation, the type of
              -- the end observation may not have changed, so save the
              -- value to possibly reuse it
              v_oend_type_oid := plhdb.get_cvterm_oid(NULL, p_Old_Stoptype,
                                                      NULL, 'event types',
                                                      'end of recording',
                                                      0);
              v_oend_oid := plhdb.get_observation_oid(p_Old_Stopdate, NULL,
                                                      v_oend_type_oid, 
                                                      p_Old_Anim_OID, 0);
       END IF;
       -- Since the start date is required, updating to an empty start
       -- date is not allowed (it will lead to a NOT NULL constraint
       -- error when executing the actual UPDATE).
       IF p_Startdate IS NOT NULL THEN
              -- update the start observation as needed
              v_nstart_oid := plhdb.get_observation_oid(
                       p_Startdate, p_Startdate_Error,
                       CASE WHEN p_Old_Starttype = p_Starttype THEN 
                                 v_ostart_type_oid
                            ELSE
                                 plhdb.get_cvterm_oid(NULL, p_Starttype, NULL,
                                                      'event types',
                                                      'start of recording',
                                                      0)
                       END,
                       p_Anim_OID,
                       v_ostart_oid,
                       3);
       END IF;
       -- if the departure date changes to null, we will simply
       -- update the recording period to set the end
       -- observation to null (default value for v_nend_oid),
       -- and don't bother updating the end observation itself
       IF p_Stopdate IS NOT NULL THEN
               -- otherwise update (or create) the end observation
               v_nend_oid := plhdb.get_observation_oid(
                       p_Stopdate, p_Stopdate_Error,
                       CASE WHEN p_Stoptype = p_Old_Stoptype THEN
                                 v_oend_type_oid
                            ELSE
                                 plhdb.get_cvterm_oid(NULL,p_Stoptype,
                                                      NULL,'event types',
                                                      'end of recording',
                                                      0)
                       END,
                       p_Anim_OID,
                       v_oend_oid,
                       3);
       END IF;
       -- finally, update the recording period (which according
       -- to our data model must exist if we are updating)
       UPDATE plhdb.recordingperiod SET
              start_oid = v_nstart_oid
              , end_oid = v_nend_oid
       WHERE start_oid = v_ostart_oid
       AND COALESCE(end_oid, -1) = COALESCE(v_oend_oid, -1)
       AND type_oid = v_pterm_oid;
       RETURN FOUND;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Inserting biographies
-- #################################################################

DROP FUNCTION ins_biography_assocs (
        p_StudyID biography.StudyID%TYPE
        , p_AnimID biography.AnimID%TYPE
        , p_AnimName biography.AnimName%TYPE
        , p_Birthgroup biography.Birthgroup%TYPE
        , p_BGQual biography.BGQual%TYPE
        , p_Sex biography.Sex%TYPE
        , p_MomID biography.MomID%TYPE
        , p_FirstBorn biography.FirstBorn%TYPE
        , p_Birthdate biography.Birthdate%TYPE
        , p_BDMin biography.BDMin%TYPE
        , p_BDMax biography.BDMax%TYPE
        , p_BDDist biography.BDDist%TYPE
        , p_Entrydate biography.Entrydate%TYPE
        , p_Entrytype biography.Entrytype%TYPE
        , p_Departdate biography.Departdate%TYPE
        , p_DepartdateError biography.DepartdateError%TYPE
        , p_Departtype biography.Departtype%TYPE)
CASCADE;

CREATE FUNCTION ins_biography_assocs (
        p_StudyID biography.StudyID%TYPE
        , p_AnimID biography.AnimID%TYPE
        , p_AnimName biography.AnimName%TYPE
        , p_Birthgroup biography.Birthgroup%TYPE
        , p_BGQual biography.BGQual%TYPE
        , p_Sex biography.Sex%TYPE
        , p_MomID biography.MomID%TYPE
        , p_FirstBorn biography.FirstBorn%TYPE
        , p_Birthdate biography.Birthdate%TYPE
        , p_BDMin biography.BDMin%TYPE
        , p_BDMax biography.BDMax%TYPE
        , p_BDDist biography.BDDist%TYPE
        , p_Entrydate biography.Entrydate%TYPE
        , p_Entrytype biography.Entrytype%TYPE
        , p_Departdate biography.Departdate%TYPE
        , p_DepartdateError biography.DepartdateError%TYPE
        , p_Departtype biography.Departtype%TYPE)
RETURNS INTEGER AS
$$
DECLARE
       v_study_oid plhdb.study.study_oid%TYPE;
       v_ind_oid plhdb.individual.individual_oid%TYPE;
BEGIN
       -- the current model is that each individual has only one entry
       -- in biography, so we will insert that record first
       --
       -- look up study first for later reuse
       SELECT INTO v_study_oid study_oid
       FROM plhdb.study WHERE id = p_StudyID;
       -- the individual (here: animal)
       v_ind_oid := plhdb.get_individual_oid(
                                   p_AnimName, p_AnimId, p_Sex, 
                                   p_Birthgroup, p_BGQual, p_FirstBorn,
                                   v_study_oid, NULL, 
                                   NULL, -- no old study here
                                   3 -- allow insert and update
       );
       -- create (or update) the relationship to the parent (here: mother)
       IF p_MomID IS NOT NULL THEN
              PERFORM plhdb.get_parent_rel_oid(
                                 v_ind_oid, 
                                 plhdb.get_individual_oid(p_MomID, v_study_oid, 
                                                          NULL, 1),
                                 NULL, -- no old parent here
                                 'maternal parent',
                                 3 -- allow insert and update
              );
       END IF;
       -- create (or update) the birth observation
       PERFORM plhdb.get_observation_oid(
                                 p_Birthdate, NULL,
                                 p_BDMin, p_BDMax,
                                 plhdb.get_cvterm_oid(NULL, p_BDDist, NULL,
                                                    'probability types',
                                                    'probability distribution', 
                                                    0),
                                 plhdb.get_cvterm_oid('date of birth', 
                                                      NULL, NULL,
                                                      'event types', NULL, 
                                                      0),
                                 v_ind_oid,
                                 NULL,
                                 3 -- allow insert and update
       );
       -- create the recording period (note that according to our
       -- datamodel, a new record with no entry date will actually not
       -- show up)
       IF p_Entrydate IS NOT NULL THEN
              PERFORM plhdb.get_recordingperiod_oid(
                        plhdb.get_observation_oid(
                                  p_Entrydate, NULL,
                                  plhdb.get_cvterm_oid(NULL,p_Entrytype,NULL,
                                                       'event types',
                                                       'start of recording',
                                                       0),
                                  v_ind_oid,
                                  3 -- allow insert and update
                        ),
                        CASE WHEN p_Departdate IS NULL THEN NULL ELSE
                        plhdb.get_observation_oid(
                                  p_Departdate, p_DepartdateError,
                                  plhdb.get_cvterm_oid(NULL,p_Departtype,NULL,
                                                       'event types',
                                                       'end of recording',
                                                       0),
                                  v_ind_oid,
                                  3 -- allow insert and update
                        )
                        END,
                        plhdb.get_cvterm_oid('total observation period',
                                             NULL, NULL,
                                             'period types', NULL,
                                             0),
                        1 -- allow insert 
              );
      END IF;
      RETURN v_ind_oid;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Updating biographies
-- #################################################################

DROP FUNCTION upd_biography_assocs (
        p_StudyID biography.StudyID%TYPE
        , p_AnimID biography.AnimID%TYPE
        , p_AnimName biography.AnimName%TYPE
        , p_Birthgroup biography.Birthgroup%TYPE
        , p_BGQual biography.BGQual%TYPE
        , p_Sex biography.Sex%TYPE
        , p_MomID biography.MomID%TYPE
        , p_FirstBorn biography.FirstBorn%TYPE
        , p_Birthdate biography.Birthdate%TYPE
        , p_BDMin biography.BDMin%TYPE
        , p_BDMax biography.BDMax%TYPE
        , p_BDDist biography.BDDist%TYPE
        , p_Entrydate biography.Entrydate%TYPE
        , p_Entrytype biography.Entrytype%TYPE
        , p_Departdate biography.Departdate%TYPE
        , p_DepartdateError biography.DepartdateError%TYPE
        , p_Departtype biography.Departtype%TYPE
        , p_Old_StudyID biography.StudyID%TYPE
        , p_Old_AnimID biography.AnimID%TYPE
        , p_Old_MomID biography.MomID%TYPE
        , p_Old_Birthdate biography.Birthdate%TYPE
        , p_Old_Entrydate biography.Entrydate%TYPE
        , p_Old_Entrytype biography.Entrytype%TYPE
        , p_Old_Departdate biography.Departdate%TYPE
        , p_Old_Departtype biography.Departtype%TYPE)
CASCADE;

CREATE FUNCTION upd_biography_assocs (
        p_StudyID biography.StudyID%TYPE
        , p_AnimID biography.AnimID%TYPE
        , p_AnimName biography.AnimName%TYPE
        , p_Birthgroup biography.Birthgroup%TYPE
        , p_BGQual biography.BGQual%TYPE
        , p_Sex biography.Sex%TYPE
        , p_MomID biography.MomID%TYPE
        , p_FirstBorn biography.FirstBorn%TYPE
        , p_Birthdate biography.Birthdate%TYPE
        , p_BDMin biography.BDMin%TYPE
        , p_BDMax biography.BDMax%TYPE
        , p_BDDist biography.BDDist%TYPE
        , p_Entrydate biography.Entrydate%TYPE
        , p_Entrytype biography.Entrytype%TYPE
        , p_Departdate biography.Departdate%TYPE
        , p_DepartdateError biography.DepartdateError%TYPE
        , p_Departtype biography.Departtype%TYPE
        , p_Old_StudyID biography.StudyID%TYPE
        , p_Old_AnimID biography.AnimID%TYPE
        , p_Old_MomID biography.MomID%TYPE
        , p_Old_Birthdate biography.Birthdate%TYPE
        , p_Old_Entrydate biography.Entrydate%TYPE
        , p_Old_Entrytype biography.Entrytype%TYPE
        , p_Old_Departdate biography.Departdate%TYPE
        , p_Old_Departtype biography.Departtype%TYPE
)
RETURNS boolean AS
$$
DECLARE
      v_study_oid plhdb.study.study_oid%TYPE;
      v_ind_oid plhdb.individual.individual_oid%TYPE;
      v_old_study_oid plhdb.study.study_oid%TYPE;
      v_bterm_oid plhdb.cvterm.cvterm_oid%TYPE;
      v_obirth_oid plhdb.observation.observation_oid%TYPE;
      v_ret boolean;
BEGIN
       -- the current model is that each individual has only one entry
       -- in biography, so we will update that record
       --
       -- look up study (old and new) first for later reuse
       SELECT INTO v_study_oid study_oid
       FROM plhdb.study WHERE id = p_StudyID;
       -- if studyID is unchanged then the oid is unchanged too, so
       -- save a lookup
       IF p_studyID = p_Old_StudyID THEN
               v_old_study_oid := v_study_oid;
       ELSE
               SELECT INTO v_old_study_oid study_oid
               FROM plhdb.study WHERE id = p_Old_StudyID;
       END IF;
       -- Obtain the primary key of the individual using the old
       -- values. Even if study or ID changed, we will be updating the
       -- individual. This has the (desirable) side effect that
       -- changing ID or study to values that will cause a unique key
       -- conflict will result in an error.
       SELECT INTO v_ind_oid individual_oid
       FROM plhdb.individual 
       WHERE id = p_Old_AnimID AND study_oid = v_old_study_oid;
       -- update the individual (here: animal)
       UPDATE plhdb.individual SET
              name = p_AnimName
              , id = p_AnimId
              , sex = p_Sex
              , birthgroup = p_Birthgroup
              , birthgroup_certainty = p_BGQual
              , is_first_born = p_FirstBorn
              , study_oid = v_study_oid
       WHERE individual_oid = v_ind_oid;
       -- create (or update) the relationship to the parent (here: mother)
       IF p_Old_MomID IS NOT NULL AND p_MomID IS NULL THEN
              DELETE FROM plhdb.individual_relationship
              WHERE child_oid = v_ind_oid
              AND parent_oid = (
                     SELECT individual_oid FROM plhdb.individual
                     WHERE id = p_Old_MomID AND study_oid = v_old_study_oid
              );
       ELSIF p_MomID IS NOT NULL 
             AND (p_Old_MomID IS NULL OR p_Old_MomID != p_MomID) THEN
              PERFORM plhdb.get_parent_rel_oid(
                                 v_ind_oid,
                                 plhdb.get_individual_oid(p_MomID, v_study_oid, 
                                                          NULL, 1),
                                 CASE WHEN p_Old_MomID IS NULL THEN NULL ELSE
                                      plhdb.get_individual_oid(p_Old_MomId,
                                                               v_old_study_oid, 
                                                               NULL,
                                                               0)
                                 END,
                                 'maternal parent',
                                 3 -- allow insert and update
              );
       ELSIF p_Old_MomID IS NOT NULL AND v_study_oid != v_old_study_oid THEN
              -- if we are not removing or updating the mother, but
              -- change the study for the individual, we will also
              -- need to change the study for the mother (because in
              -- the current biography model the study for the mother
              -- individual is tied to be the same as for the child)
              UPDATE plhdb.individual SET
                     study_oid = v_study_oid
              WHERE id = p_Old_MomID AND study_oid = v_old_study_oid;
       END IF;
       -- Create or update the birth observation. We could check
       -- whether dates and date errors are identical and save the
       -- update then (but would then need to pass old error as a
       -- parameter).
       --
       -- obtain primary key of birth event type term (must exist)
       v_bterm_oid := plhdb.get_cvterm_oid('date of birth', NULL, NULL,
                                           'event types', NULL, 0);
       -- if there was a birth date, obtain the primary key of
       -- the observation
       IF p_Old_Birthdate IS NOT NULL THEN 
              v_obirth_oid := plhdb.get_observation_oid(
                                          p_Old_Birthdate, NULL, 
                                          v_bterm_oid, v_ind_oid, 
                                          0);
       END IF;
       -- otherwise update the existing observation, or
       -- create new one of there wasn't one before
       PERFORM plhdb.get_observation_oid(p_Birthdate, NULL, p_BDMin, p_BDMax,
                                         plhdb.get_cvterm_oid(
                                                NULL, p_BDDist, NULL,
                                                'probability types', 
                                                'probability distribution', 0),
                                         v_bterm_oid, v_ind_oid,
                                         v_obirth_oid,
                                         3 -- allow DML
       );
       -- Update the recording period for entry and departure into and
       -- from observation, respectively.
       v_ret := upd_plhdb_recordingperiod(
                        v_ind_oid
                        , p_Entrydate, -1
                        , p_Entrytype
                        , p_Departdate, p_DepartdateError
                        , p_Departtype
                        , 'total observation period'
                        , v_ind_oid
                        , p_Old_Entrydate
                        , p_Old_Entrytype
                        , p_Old_Departdate
                        , p_Old_Departtype);
      RETURN v_ret;
END;
$$
LANGUAGE plpgsql;
