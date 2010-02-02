--
-- Definition of PLHDB views representing the data model API for the
-- Primate Life Histories working group. The data model API operates
-- on top of a general, normalized Life Histories Database model.
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

--
-- We place the views in two schemas: those that are primarily useful
-- programmatically in the plhdb schema, and those for public
-- consumption by working group members in the public schema.
--

-- ######################################################################
-- Programmer-level views
-- ######################################################################

SET search_path TO plhdb, public;

-- ######################################################################
-- The following are several views that denormalize foreign key
-- relationships in a rather general manner. 
--
-- This is primarly a convenience for applications that need to do
-- outer joins to these tables (in which case the master tables that
-- are denormalized here would also have to be outer-joined, which can
-- become rather messy).
-- ######################################################################

-- View cvterm_relationships: denormalizes the
-- subject-predicate-object triple to the actual term attributes
CREATE OR REPLACE VIEW cvterm_relationships AS
SELECT
        s.cvterm_oid AS subj_oid
        , s.name AS subj_name
        , s.code AS subj_code
        , s.identifier AS subj_identifier
        , s.namespace AS subj_namespace
        , p.cvterm_oid AS pred_oid
        , p.name AS pred_name
        , p.code AS pred_code
        , p.identifier AS pred_identifier
        , p.namespace AS pred_namespace
        , o.cvterm_oid AS obj_oid
        , o.name AS obj_name
        , o.code AS obj_code
        , o.identifier AS obj_identifier
        , o.namespace AS obj_namespace
        , rel.cvterm_relationship_oid AS rel_oid
FROM
        cvterm_relationship rel
        JOIN cvterm s ON (rel.subject_oid = s.cvterm_oid)
        JOIN cvterm p ON (rel.predicate_oid = p.cvterm_oid)
        JOIN cvterm o ON (rel.object_oid = o.cvterm_oid)
;

-- View individual_relationships: denormalizes parent and child
-- individual of a relationship between two individuals
CREATE OR REPLACE VIEW individual_relationships AS
SELECT
        rel.parent_oid AS parent_oid
        , p.name AS parent_name
        , p.id AS parent_id
        , rel.child_oid AS child_oid
        , c.name AS child_name
        , c.id AS child_id
        , rel.reltype AS reltype
        , st.study_oid AS study_oid
        , st.name AS study_name
        , st.id AS study_id
FROM
        individual_relationship rel
        JOIN individual p ON (p.individual_oid = rel.parent_oid)
        JOIN individual c ON (c.individual_oid = rel.child_oid)
        JOIN study st ON (c.study_oid = st.study_oid)
;

COMMENT ON VIEW individual_relationships IS 'Parent and child individuals connected by a certain relationship type.';

COMMENT ON COLUMN individual_relationships.parent_oid IS 'The primary key of the parent individual.';

COMMENT ON COLUMN individual_relationships.parent_name IS 'The (long) name of the parent individual.';

COMMENT ON COLUMN individual_relationships.parent_id IS 'The ID or codename or barcode of the parent individual.';

COMMENT ON COLUMN individual_relationships.child_oid IS 'The primary key of the child individual.';

COMMENT ON COLUMN individual_relationships.child_name IS 'The (long) name of the child individual.';

COMMENT ON COLUMN individual_relationships.child_id IS 'The ID or codename or barcode of the child individual.';

COMMENT ON COLUMN individual_relationships.reltype IS 'The nature of the relationship, currently either ''maternal parent'' or ''paternal parent''.';

COMMENT ON COLUMN individual_relationships.study_oid IS 'The primary key of the study to which the child individual belongs.';

COMMENT ON COLUMN individual_relationships.study_name IS 'The name of the study to which the child individual belongs.';

COMMENT ON COLUMN individual_relationships.study_id IS 'The ID of the study to which the child individual belongs.';

-- View observations: denormalizes the event type and the parent term
-- of the event type (assuming that it has one, here called the 'category').
CREATE OR REPLACE VIEW observations AS
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

-- View recordingperiods: denormalizes start and end observation or a
-- recording period, as well the types of the period and the
-- observations.
CREATE OR REPLACE VIEW recordingperiods AS
SELECT
        os.individual_oid AS individual_oid
        , os.observation_oid AS start_observation_oid
        , os.time_of_observation AS start_time
        , os.time_error AS start_time_error
        , ost.name AS start_event_type
        , ost.code AS start_event_code
        , ost.namespace AS start_event_type_namespace
        , oe.observation_oid AS end_observation_oid
        , oe.time_of_observation AS end_time
        , oe.time_error AS end_time_error
        , oet.name AS end_event_type
        , oet.code AS end_event_code
        , oet.namespace AS end_event_type_namespace
        , pert.name AS period_type
        , per.recordingperiod_oid AS period_oid
FROM
        recordingperiod per
        JOIN cvterm pert ON (per.type_oid = pert.cvterm_oid)
        JOIN observation os ON (per.start_oid = os.observation_oid)
        JOIN cvterm ost ON (os.type_oid = ost.cvterm_oid)
        LEFT JOIN observation oe ON (per.end_oid = oe.observation_oid)
        LEFT JOIN cvterm oet ON (oe.type_oid = oet.cvterm_oid)
;

COMMENT ON VIEW recordingperiods IS 'Recording periods with start and end observations, types of those observations, and the type of the period. The end observation (and its attributes) may be null.';

COMMENT ON COLUMN recordingperiods.individual_oid IS 'The database primary key of the individual for which the observation was made.';

COMMENT ON COLUMN recordingperiods.start_observation_oid IS 'The primary key of the observation that starts the recording period.';

COMMENT ON COLUMN recordingperiods.start_time IS 'The time or date when the start observation was made.';

COMMENT ON COLUMN recordingperiods.start_time_error IS 'The error with which the start time is being stated, meaning that the actual time may have been between the recorded time minus the error to the recorded time plus the error. The unit of error will depend on the study, but should be uniform within a study, for example (fraction of) years, or days.';

COMMENT ON COLUMN recordingperiods.start_event_type IS 'The name of the type of the start event, such as birth, or death, or feeding.';

COMMENT ON COLUMN recordingperiods.start_event_code IS 'The (optional) code for the name of the start event type, often only a single letter or number.';

COMMENT ON COLUMN recordingperiods.start_event_type_namespace IS 'The name of the controlled vocabulary or ontology to which the start event type belongs.';

COMMENT ON COLUMN recordingperiods.end_observation_oid IS 'The primary key of the observation that ends the recording period.';

COMMENT ON COLUMN recordingperiods.end_time IS 'The time or date when the end observation was made.';

COMMENT ON COLUMN recordingperiods.end_time_error IS 'The error with which the end time is being stated, meaning that the actual time may have been between the recorded time minus the error to the recorded time plus the error. The unit of error will depend on the study, but should be uniform within a study, for example (fraction of) years, or days.';

COMMENT ON COLUMN recordingperiods.end_event_type IS 'The name of the type of the end event, such as birth, or death, or feeding.';

COMMENT ON COLUMN recordingperiods.end_event_code IS 'The (optional) code for the name of the end event type, often only a single letter or number.';

COMMENT ON COLUMN recordingperiods.end_event_type_namespace IS 'The name of the controlled vocabulary or ontology to which the end event type belongs.';

COMMENT ON COLUMN recordingperiods.period_type IS 'The name of the type of the recording period, such as the property (for example, a disease) or the capacity (for example, fertility) that the individual had during the period.';

COMMENT ON COLUMN recordingperiods.period_oid IS 'The database primary key of the recording period.';

-- ######################################################################
-- Now follows the Primate Life Histories Database API as views. We
-- create these in the public schema, so that users can immediately
-- see it.
-- ######################################################################

SET search_path TO public, pg_catalog;

-- Unless indicated otherwise, column documentation for the Primate
-- Life Histories API views is taken from the PLHDDataTableTemplates
-- specification which the working group determined itself under the
-- leadership of Susan Alberts and Karen Strier.

-- Primate Life Histories API view Biography:
CREATE OR REPLACE VIEW biography AS
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

-- Primate Life Histories API view StudyInfo
CREATE OR REPLACE VIEW studyinfo AS
SELECT
        st.id AS StudyID
        , tax.common_name AS CommonName
        , tax.scientific_name AS SciName
        , site.name AS SiteID
        , st.owners AS Owners
        , site.latitude AS Latitude
        , site.longitude AS Longitude
FROM
        plhdb.study st
        JOIN plhdb.taxon tax ON (st.taxon_oid = tax.taxon_oid)
        JOIN plhdb.site ON (st.site_oid = site.site_oid)
;

COMMENT ON VIEW studyinfo IS 'PLHD API: Information about the studies.';

COMMENT ON COLUMN studyinfo.StudyID IS 'Study number. 1 is Strier/muriquis, 2 is Pat Wright, 3 is Marina, 4 is Anne Pusey, 5 is Tara Stoinski, 6 is Diane Brockman, 7 is Linda Fedigan, 8 is Susan and Jeanne';

COMMENT ON COLUMN studyinfo.CommonName IS 'Species common name. Use whatever you want.';

COMMENT ON COLUMN studyinfo.SciName IS 'Species scientific name. Use whatever you want.';

COMMENT ON COLUMN studyinfo.SiteID IS 'Site location. Amboseli, Gombe, Caratinga, Karisoke, etc.';

COMMENT ON COLUMN studyinfo.Owners IS 'Data ownership. JGI, DFGF, Karen Strier, Altmann & Alberts, etc.';

COMMENT ON COLUMN studyinfo.Latitude IS 'Latitude. Universal Transverse Mercator.';

COMMENT ON COLUMN studyinfo.Longitude IS 'Longitude. Universal Transverse Mercator.';

-- Primate Life Histories API view FemaleFertilityInterval
CREATE OR REPLACE VIEW femalefertilityinterval AS
SELECT
        st.id AS StudyID
        , an.id AS AnimID
        , per.start_time AS Startdate
        , per.start_event_code AS Starttype
        , per.end_time AS Stopdate
        , per.end_event_code AS Stoptype
        , an.individual_oid AS Anim_OID
        , per.period_oid AS Interval_OID
FROM
        plhdb.recordingperiods per
        JOIN plhdb.individual an ON (per.individual_oid = an.individual_oid)
        JOIN plhdb.study st ON (an.study_oid = st.study_oid)
WHERE
        per.period_type = 'female fertility period'
;

COMMENT ON VIEW femalefertilityinterval IS 'PLHD API: Observed fertility interval of a female animal. The natural unique key of this view is the combination of animal OID, start time and type, and stop date and type. Hence it includes all columns except the primary key column.';

COMMENT ON COLUMN femalefertilityinterval.StudyID IS 'ID of the study. The combination of studyID and animID uniquely identifies an animal (as does Anim_OID, the primary key of the animal).';

COMMENT ON COLUMN femalefertilityinterval.AnimID IS 'ID of animal. Every female is required to have an entry. Males may not have entries. All values in this cell must correspond to a value in Biography. Note that in the current data model this column is not guaranteed to uniquely identify the animal as animals from different studies may have the same ID (but not within the same study). Use the animal OID as unique key for the animal.';

COMMENT ON COLUMN femalefertilityinterval.Startdate IS 'Startdate for fertility surveillance. Date on which surveillance of fertility began. Will be equivalent to Entrydate in Biography if this is equivalent to the first time you saw the animal. Will be equivalent to Birthdate in Biography iff Entrydate = Birthdate. This date must not have error associated with it. These dates are conservative: if you are sure that you know about her starting on July 15 but you MIGHT know about her starting on July 1, you must choose the more conservative date which is July 15.';

COMMENT ON COLUMN femalefertilityinterval.Starttype IS 'Reason for the start of surveillance. Birth, immigration, start of confirmed ID, Initiation of close observation for any other reason. B, I, C, O for birth, immigration into the study population, confirmed ID, and beginning of observation, respectively.';

COMMENT ON COLUMN femalefertilityinterval.Stopdate IS 'Stopdate for fertility surveillance. Date on which surveillance of fertility ended. Surveillance ends when you stop seeing the animal for a long enough period of time that births could be missed. This is allowed to be  equivalent to Departdate in Biography only when this is  the last time you saw the animal alive. This date must not have error associated with it. These dates are conservative: if you are sure that you know about her until July 1 but you MIGHT know about her until  July 15, you must choose the more conservative date which is July 1.';

COMMENT ON COLUMN femalefertilityinterval.Stoptype IS 'Cause of the end of surveillance. Cause of the end of surveillance. D, E, P, O for death, emigration, permanent disappearance and end of observation respectively. Character.';

COMMENT ON COLUMN femalefertilityinterval.Anim_OID IS 'Internal primary key of the animal, and hence uniquely identifies it. Can be used for joining to Biography.';

COMMENT ON COLUMN femalefertilityinterval.Interval_OID IS 'Internal primary key of the fertility interval. Can be used for uniquely identifying a fertility interval with a single value.';