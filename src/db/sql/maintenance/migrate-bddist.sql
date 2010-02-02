--
-- Migration script for the Aug 2007 version of the PLHDB database to 
-- the changes requested for Birthdate. Specifically, birthdate gets a
-- min and max boundary and a probability distribution indicator.
--
-- Copyright (C) 2008, Hilmar Lapp, hlapp at gmx.net
-- Copyright (C) 2008, National Evolutionary Synthesis Center (NESCent)
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

-- ######################################################################
-- First migrate the tables, functions, and views in the plhdb schema
-- that is hidden from public view.
-- ######################################################################

SET search_path TO plhdb, public;

-- ######################################################################
-- Table observation
-- ######################################################################

ALTER TABLE observation ADD COLUMN min_boundary timestamp;

ALTER TABLE observation ADD COLUMN max_boundary timestamp;

ALTER TABLE observation ADD COLUMN prob_type_oid INTEGER;

ALTER TABLE observation ADD 
      FOREIGN KEY (prob_type_oid) REFERENCES cvterm (cvterm_oid) 
      ON DELETE SET NULL;

-- ######################################################################
-- drop some functions that we won't be able to drop later in this way
-- because the biography reference will be gone.
-- ######################################################################

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
        , p_BDError biography.BDError%TYPE
        , p_Entrydate biography.Entrydate%TYPE
        , p_Entrytype biography.Entrytype%TYPE
        , p_Departdate biography.Departdate%TYPE
        , p_DepartdateError biography.DepartdateError%TYPE
        , p_Departtype biography.Departtype%TYPE)
CASCADE;

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
        , p_BDError biography.BDError%TYPE
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

-- ######################################################################
-- Recreate the view observations. This will cascade to a couple of other
-- objects, among them the biography view.
-- ######################################################################

DROP VIEW observations CASCADE;
CREATE VIEW observations AS
SELECT
        os.observation_oid AS observation_oid
        , os.time_of_observation AS time_of_observation
        , os.time_error AS time_error
        , os.min_boundary AS min_boundary
        , os.max_boundary AS max_boundary
        , osprob.name AS prob_type
        , osprob.code AS prob_type_code
        , ost.name AS event_type
        , ost.code AS event_code
        , ostp.name AS event_type_parent
        , ost.namespace AS event_type_namespace
        , os.individual_oid AS individual_oid
FROM
        observation os 
        JOIN cvterm ost ON (os.type_oid = ost.cvterm_oid)
        JOIN cvterm_relationship cvr ON (ost.cvterm_oid = cvr.subject_oid)
        JOIN cvterm ostp ON (cvr.object_oid = ostp.cvterm_oid)
        LEFT JOIN cvterm osprob ON (os.prob_type_oid = osprob.cvterm_oid)
;

COMMENT ON VIEW observations IS 'Observations and their type, as well as parent term of the type, cast here as the ''category'' of the type.';

COMMENT ON COLUMN observations.observation_oid IS 'The primary key of the observation.';

COMMENT ON COLUMN observations.time_of_observation IS 'The time or date when the observation was made.';

COMMENT ON COLUMN observations.time_error IS 'The error with which the time is being stated, meaning that the actual time may have been between the recorded time minus the error to the recorded time plus the error. The unit of error will depend on the study, but should be uniform within a study, for example (fraction of) years, or days.';

COMMENT ON COLUMN observations.min_boundary IS 'The (typically estimated) earliest time at which the observed event could have taken place.';

COMMENT ON COLUMN observations.max_boundary IS 'The (typically estimated) latest time at which the observed event could have taken place.';

COMMENT ON COLUMN observations.prob_type IS 'The (type of) probability distribution or function describing the actual time of the event between the min (lower) boundary and the max (upper) boundary.';

COMMENT ON COLUMN observations.prob_type_code IS 'The (usually single-letter) code of the probability distribution describing the actual time of the event.';

COMMENT ON COLUMN observations.event_type IS 'The name of the type of the event, such as birth, or death, or feeding.';

COMMENT ON COLUMN observations.event_code IS 'The (optional) code for the name of the event type, often only a single letter or number.';

COMMENT ON COLUMN observations.event_type_parent IS 'The parent term name of the type of the event, such as ''start of recording'' or ''end of recording'', representing categories of event types. Note that event types without parent terms will not match the query of this view.';

COMMENT ON COLUMN observations.event_type_namespace IS 'The name of the controlled vocabulary or ontology to which the event type belongs.';

COMMENT ON COLUMN observations.individual_oid IS 'The individual for which the observation was made.';

-- ######################################################################
-- restore/fix the API functions for the observations table
-- ######################################################################

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
                      , time_error = p_Time_error
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

-- ######################################################################
-- Now for the public part.
-- ######################################################################

SET search_path TO public, pg_catalog;

-- ######################################################################
-- Recreate the biography view:
-- ######################################################################

CREATE VIEW biography AS
SELECT
        st.id AS StudyID
        , an.id AS AnimID
        , an.name AS AnimName
        , an.birthgroup AS Birthgroup
        , an.birthgroup_certainty AS BGQual
        , an.sex AS Sex
        , momrel.parent_id AS MomID
        , an.is_first_born AS FirstBorn
        , bo.time_of_observation AS Birthdate
        , bo.min_boundary AS BDMin
        , bo.max_boundary AS BDMax
        , bo.prob_type_code AS BDDist
        , per.start_time AS Entrydate
        , per.start_event_code AS Entrytype
        , per.end_time AS Departdate
        , per.end_time_error AS DepartdateError
        , per.end_event_code AS Departtype
        , an.individual_oid AS Anim_OID
FROM
        plhdb.individual an 
        INNER JOIN plhdb.study st ON (an.study_oid = st.study_oid)
        INNER JOIN plhdb.recordingperiods per 
                                  ON (per.individual_oid = an.individual_oid
                                      AND per.period_type = 'total observation period')
        INNER JOIN plhdb.observations bo 
                                  ON (bo.individual_oid = an.individual_oid 
                                      AND bo.event_type = 'date of birth' 
                                      AND bo.event_type_namespace = 'event types')
        LEFT JOIN plhdb.individual_relationships momrel 
                                  ON (an.individual_oid = momrel.child_oid)
;

COMMENT ON VIEW biography IS 'PLHD API: Biography of an animal.';

COMMENT ON COLUMN biography.StudyID IS 'Study number. Each study is assigned an arbitrary identifying number that is an integer.';

COMMENT ON COLUMN biography.AnimID IS 'ID, Code not long name. The only ones in here are the seen products of live births.';

COMMENT ON COLUMN biography.AnimName IS 'Long name.';

COMMENT ON COLUMN biography.Birthgroup IS 'Group of birth, characters. ID of the group or unknown.';

COMMENT ON COLUMN biography.BGQual IS 'Quality of the estimate of the group of birth. The degree of certainty about which group this animal was born into. Character: C or U for certain or uncertain.';

COMMENT ON COLUMN biography.Sex IS 'Sex M, F or U for Male, Female or Unknown respectively. Character';

COMMENT ON COLUMN biography.MomID IS 'Mother''s ID. Mother''s AnimID or unknown. Character. Values in this column may or may not also occur in the AnimID column in another row.';

COMMENT ON COLUMN biography.FirstBorn IS 'Is this animal its mother''s first born. Y, N, U for Yes, No or Uncertain respectively. Character.';

COMMENT ON COLUMN biography.Birthdate IS 'Birth date. Animal''s birthdate. The birthdate is either the exactly known date of birth or it is midpoint of the range of possible birthdates. Date: dd-Mmm-yyyy';

COMMENT ON COLUMN biography.BDMin IS 'Estimated earliest birth date. Must differ from Birthdate whenever earliest possible birth date is >7 days before Birthdate. Format: dd-Mmm-yyyy';

COMMENT ON COLUMN biography.BDMax IS 'Estimated latest birth date.  Must differ from Birthdate whenever latest possible birth date is >7 days after Birthdate.  Format: dd-Mmm-yyyy';

COMMENT ON COLUMN biography.BDDist IS 'Probability distribution of the estimated birth date given BDMin, Birthdate, and BDMax. Must be either normal (N) or uniform (U). If N, construct the probability distribution so that BDMin and BDMax represent + 2 standard deviations of Birthdate. If U, the probability distribution is truncated at BDMin and BDMax with equal Birthdate probability within this range. If Birthdate is not at the midpoint of BDMin and BDMax, distribution must be U. If Birthdate is at the midpoint of BDMin and BDMax, distribution may be N or U.';

COMMENT ON COLUMN biography.Entrydate IS 'Date the animal was first seen. Date: dd-Mmm-yyyy. Date on which the animal is first sighted in the study population, either because the animal is recognized and ID''d as of that date or because strong inference indicates group membership from that date. Study population is the studied population at the time of the animal''s entry it it. You are allowed to have entrydate = birthdate if bderror = 0.';

COMMENT ON COLUMN biography.Entrytype IS 'Type of entry into population. Birth, immigration, start of confirmed ID, Initiation of close observation for any other reason. B, I, C, O for birth, immigration into the study population, confirmed ID, and beginning of observation, respectively.';

COMMENT ON COLUMN biography.Departdate IS 'Date: dd-Mmm-yyyy. Date on which the animal was last seen alive in the population.';

COMMENT ON COLUMN biography.DepartdateError IS 'Time between departdate and the first time that the animal was confirmed missing. Expressed as fraction of a year (number of days divided by number of days in a year).	Assign a zero to DepartdateError only if the number of day between departdate and the first time that the animal was confirmed missing was < 15.';

COMMENT ON COLUMN biography.Departtype IS 'Type of departure. D, E, P, O for death, emigration, permanent disappearance and end of observation respectively. Character. Death, permanent disappearance, emigration out of the study population, end of close observation for any other reason, or end of currently entered data period. May be same as Type of Stop in FertilityTable. Death may be assigned only in cases where the evidence is very strong: body found, or circumstantial evidence indicates poor health or other risks contributing to mortality and/or violations of population-specific behavior patterns. Otherwise assign permanent disappearance. Do not assign mortality based solely on inferred risks associated with age.';

COMMENT ON COLUMN biography.Anim_OID IS 'Internal primary key of the animal. Can be used for joining to FemaleFertilityInterval.';

-- ######################################################################
-- Restore/fix the API functions needed by the biography view rules
-- ######################################################################

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
                        , p_Entrydate, NULL
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

-- #################################################################
-- Restore/fix rules for making the view biography updateable (for
-- insert, update, delete)
-- #################################################################

CREATE OR REPLACE RULE r_biography_ins AS
       ON INSERT TO biography
       DO INSTEAD (
       SELECT ins_biography_assocs(
                       new.StudyID 
                       , new.AnimId
                       , new.AnimName
                       , new.Birthgroup
                       , new.BGQual
                       , new.Sex
                       , new.MomID
                       , new.FirstBorn
                       , new.Birthdate
                       , new.BDMin
                       , new.BDMax
                       , new.BDDist
                       , new.Entrydate
                       , new.Entrytype
                       , new.Departdate
                       , new.DepartdateError
                       , new.Departtype
       );
       -- at this point this is primarily so applications have a row
       -- count to query
       INSERT INTO audit.dmltrace (tablename, rowkey, optype, usr, tstamp)
       VALUES ('Biography',new.StudyID||'-'||new.AnimId,'I',current_user,now());
);

CREATE OR REPLACE RULE r_biography_upd AS
       ON UPDATE TO biography
       DO INSTEAD (
       -- at this point this is primarily so applications have a row
       -- count to query - we'll update it at the end
       INSERT INTO audit.dmltrace (tablename, rowkey, optype, usr)
       VALUES ('Biography',old.Anim_OID,'U',current_user);
       -- do the update in a stored function
       SELECT upd_biography_assocs(
                       new.StudyID 
                       , new.AnimId
                       , new.AnimName
                       , new.Birthgroup
                       , new.BGQual
                       , new.Sex
                       , new.MomID
                       , new.FirstBorn
                       , new.Birthdate
                       , new.BDMin
                       , new.BDMax
                       , new.BDDist
                       , new.Entrydate
                       , new.Entrytype
                       , new.Departdate
                       , new.DepartdateError
                       , new.Departtype
                       , old.StudyID
                       , old.AnimId
                       , old.MomID
                       , old.Birthdate
                       , old.Entrydate
                       , old.Entrytype
                       , old.Departdate
                       , old.Departtype
       );
       -- update so applications have an update row count to query
       UPDATE audit.dmltrace SET
              tstamp = now()
       WHERE tablename = 'Biography'
       AND rowkey = old.Anim_OID 
       AND optype = 'U' AND usr = current_user AND tstamp IS NULL;
);

CREATE OR REPLACE RULE r_biography_del AS
       ON DELETE TO biography
       DO INSTEAD (
       -- delete the individual (here: the animal) instead
       DELETE FROM plhdb.individual 
       WHERE id = old.AnimID
       AND study_oid = (
              SELECT study_oid FROM plhdb.study WHERE id = old.StudyID
       );
       -- note that by cascading deletes this will also delete all
       -- observations for this individual, and therefore also all
       -- recording periods
);

-- ######################################################################
-- Recreate the bulk import table for biography to correspond to the new
-- structure.
-- ######################################################################

DROP TABLE bulkimp.biography_imp CASCADE;
CREATE TABLE bulkimp.biography_imp AS 
SELECT * FROM biography WHERE 1=2;

-- Create the trigger functions.
CREATE OR REPLACE FUNCTION bulkimp.biography_ins_trf()
RETURNS TRIGGER AS
$$
BEGIN
        INSERT INTO biography (
                StudyID
                , AnimID
                , AnimName
                , Birthgroup
                , BGQual
                , Sex
                , MomID
                , FirstBorn
                , Birthdate
                , BDMin
                , BDMax
                , BDDist
                , Entrydate
                , Entrytype
                , Departdate
                , DepartdateError
                , Departtype)
        VALUES ( 
                new.StudyID
                , new.AnimID
                , new.AnimName
                , new.Birthgroup
                , new.BGQual
                , new.Sex
                , new.MomID
                , new.FirstBorn
                , new.Birthdate
                , new.BDMin
                , new.BDMax
                , new.BDDist
                , new.Entrydate
                , new.Entrytype
                , new.Departdate
                , new.DepartdateError
                , new.Departtype);
        RETURN NULL; -- no real insert into this table
END;
$$
LANGUAGE plpgsql;

-- Create the insert triggers.
CREATE TRIGGER biography_ins_tr 
BEFORE INSERT ON bulkimp.biography_imp
FOR EACH ROW
EXECUTE PROCEDURE bulkimp.biography_ins_trf();
