--
-- Definition of PostgreSQL RULEs to make the view-based API
-- updateable. This takes the position of triggers for other RDBMSs.
--
-- This file is part of the database definition for the Primate
-- Life Histories Database working group.
--
-- Copyright (C) 2007, 2008, Hilmar Lapp, hlapp at gmx.net
-- Copyright (C) 2007, 2008, National Evolutionary Synthesis Center (NESCent)
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

-- #################################################################
-- Rules for making the view cvterm_relationships updateable (for
-- insert, update, delete)
-- #################################################################

-- we create this in the plhdb schema
SET search_path TO plhdb, public;

CREATE OR REPLACE RULE r_cvterm_relationships_ins AS
       ON INSERT TO cvterm_relationships
       DO INSTEAD (
       -- insert the cvterm_relationship record instead, creating
       -- subject, predicate, and object terms as needed
       INSERT INTO plhdb.cvterm_relationship (subject_oid, 
                                              predicate_oid, 
                                              object_oid)
       VALUES (plhdb.get_cvterm_oid(new.subj_oid, new.subj_name, new.subj_code,
                                    new.subj_identifier, new.subj_namespace,
                                    NULL,
                                    1),
               plhdb.get_cvterm_oid(new.pred_oid, new.pred_name, new.pred_code,
                                    new.pred_identifier, new.pred_namespace,
                                    NULL,
                                    1),
               plhdb.get_cvterm_oid(new.obj_oid, new.obj_name, new.obj_code,
                                    new.obj_identifier, new.obj_namespace,
                                    NULL,
                                    1));
);

CREATE OR REPLACE RULE r_cvterm_relationships_upd AS
       ON UPDATE TO cvterm_relationships
       DO INSTEAD (
       -- update the cvterm_relationship record instead, creating
       -- new subject, predicate, and object terms as needed
       UPDATE plhdb.cvterm_relationship SET
              subject_oid = plhdb.get_cvterm_oid(new.subj_oid, 
                                                 new.subj_name, new.subj_code,
                                                 new.subj_identifier,
                                                 new.subj_namespace,
                                                 NULL,
                                                 3),
              predicate_oid = plhdb.get_cvterm_oid(new.pred_oid, 
                                                   new.pred_name, new.pred_code,
                                                   new.pred_identifier, 
                                                   new.pred_namespace,
                                                   NULL,
                                                   3),
              object_oid = plhdb.get_cvterm_oid(new.obj_oid, 
                                                new.obj_name, new.obj_code,
                                                new.obj_identifier, 
                                                new.obj_namespace,
                                                NULL,
                                                3)
       WHERE subject_oid = old.subj_oid AND object_oid = old.obj_oid;
);

CREATE OR REPLACE RULE r_cvterm_relationships_del AS
       ON DELETE TO cvterm_relationships
       DO INSTEAD (
       -- delete the term relationship in cvterm_relationship instead
       DELETE FROM plhdb.cvterm_relationship
       WHERE subject_oid = old.subj_oid
       AND object_oid = old.obj_oid;
);

SET search_path TO public, pg_catalog;

-- #################################################################
-- Rules for making the view studyinfo updateable (for insert, update,
-- delete)
-- #################################################################

CREATE OR REPLACE RULE r_studyinfo_ins AS
       ON INSERT TO studyinfo 
       DO INSTEAD (
       -- insert study record, while possibly creating (or updating)
       -- the taxon and site master records
       INSERT INTO plhdb.study (id, owners, taxon_oid, site_oid)
       VALUES (new.StudyID, new.Owners,
               plhdb.get_taxon_oid(new.CommonName, new.SciName, 
                                   1 -- insert if not found
               ),
               plhdb.get_site_oid(new.SiteID, 
                                  new.Latitude, 
                                  new.Longitude, 
                                  NULL, -- geodetic_datum
                                  1  -- insert if not found
               )
       );
);

COMMENT ON RULE r_studyinfo_ins IS 'Rule that takes the role of an INSTEAD INSERT trigger on the PLHDB API view studyinfo. It allows inserts into the view. Taxon and site are looked up first, and will only be inserted as new if they are not found.';

CREATE OR REPLACE RULE r_studyinfo_upd AS
       ON UPDATE TO studyinfo 
       DO INSTEAD (
       -- update the study record, while possibly inserting or
       -- updating the taxon and site master records
       UPDATE plhdb.study SET
              id = new.StudyID
              , owners = new.Owners
              , taxon_oid = plhdb.get_taxon_oid(new.CommonName, 
                                                new.SciName, 
                                                3 -- allow update & insert
              )
              , site_oid = plhdb.get_site_oid(new.SiteID, 
                                              new.Latitude, 
                                              new.Longitude, 
                                              NULL, -- geodetic_datum
                                              3  -- allow update & insert
              )
       WHERE id = old.StudyID;
);

COMMENT ON RULE r_studyinfo_upd IS 'Rule that takes the role of an INSTEAD UPDATE trigger on the PLHDB API view studyinfo. It allows updates to the view. The implementation supports changing to a new taxon or site, or updating the attributes of an existing taxon or site. A taxon is first looked up by SciName, then by CommonName; if it is found, CommonName and SciName will be updated. Otherwise, a new taxon is created with the specified values.';

CREATE OR REPLACE RULE r_studyinfo_del AS
       ON DELETE TO studyinfo 
       DO INSTEAD (
       -- delete the study record instead
       DELETE FROM plhdb.study WHERE id = old.StudyID;
);

COMMENT ON RULE r_studyinfo_del IS 'Rule that takes the role of an INSTEAD DELTE trigger on the PLHDB API view studyinfo. It allows deleting rows from the view. The effect of deleting a row from the view is deleting rows from the study table.';

-- #################################################################
-- Rules for making the view biography updateable (for insert, update,
-- delete)
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
                       , new.Anim_Oid
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
              tstamp = timeofday()::timestamp
       WHERE tablename = 'Biography'
       AND rowkey = old.Anim_OID::text 
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

-- #################################################################
-- Rules for making the view femalefertilityinterval updateable (for
-- insert, update, delete)
-- #################################################################

CREATE OR REPLACE RULE r_femalefertilityinterval_ins AS
       ON INSERT TO femalefertilityinterval
       DO INSTEAD (
       -- insert into recording period instead
       INSERT INTO plhdb.recordingperiod (start_oid, end_oid, type_oid, 
                                          recordingperiod_oid)
       VALUES (
               plhdb.get_observation_oid(
                       new.Startdate, NULL,
                       plhdb.get_cvterm_oid(NULL,new.Starttype,
                                            NULL, 'event types',
                                            'start of recording', 0),
                       CASE 
                       WHEN new.Anim_OID IS NULL THEN
                               plhdb.get_individual_oid(new.AnimID, 
                                                        NULL, new.StudyID, 0)
                       ELSE new.Anim_OID
                       END,
                       1 -- insert if not found
               ),
               CASE 
               WHEN new.Stopdate IS NULL THEN NULL 
               ELSE
                       plhdb.get_observation_oid(
                               new.Stopdate, NULL,
                               plhdb.get_cvterm_oid(NULL, new.Stoptype,
                                                    NULL, 'event types',
                                                    'end of recording', 0),
                               CASE 
                               WHEN new.Anim_OID IS NULL THEN
                                       plhdb.get_individual_oid(new.AnimID, 
                                                                NULL, 
                                                                new.StudyID, 0)
                               ELSE new.Anim_OID
                               END,
                               1 -- insert if not found
                        )
               END,
               plhdb.get_cvterm_oid('female fertility period', NULL, NULL,
                                    'period types', NULL, 0),
               CASE
               WHEN new.Interval_OID IS NULL THEN
                    nextval('plhdb.recordingperiod_recordingperiod_oid_seq')
               ELSE new.Interval_OID
               END
       );
       -- since we are logging updates, let's log inserts too
       INSERT INTO audit.dmltrace (tablename, rowkey, optype, usr, tstamp)
       VALUES ('FemaleFertiliyInterval',
               new.AnimID||'-'||COALESCE(new.StudyId,'?')
                         ||'-'||TO_CHAR(new.Startdate,'YYYY-mm-dd'),
               'I',current_user,now());
);

CREATE OR REPLACE RULE r_femalefertilityinterval_upd AS
       ON UPDATE TO femalefertilityinterval
       DO INSTEAD (
       -- at this point this is primarily so applications have a row
       -- count to query - we'll update it at the end
       INSERT INTO audit.dmltrace (tablename, rowkey, optype, usr)
       VALUES ('FemaleFertilityInterval',old.Interval_OID,'U',current_user);
       -- Update the recording period instead. Under the current data
       -- model this means we do have at least a start date, and there
       -- is a non-null recording period record for this female
       -- fertility interval.
       SELECT upd_plhdb_recordingperiod(
                        CASE
                        WHEN new.AnimID != old.AnimID
                             OR new.StudyID != old.StudyID THEN
                                plhdb.get_individual_oid(new.AnimID, 
                                                         NULL, new.StudyID, 0)
                        ELSE new.Anim_OID
                        END
                        , new.Startdate, -1
                        , new.Starttype
                        , new.Stopdate, -1
                        , new.Stoptype
                        , 'female fertility period'
                        , old.Anim_OID
                        , old.Startdate
                        , old.Starttype
                        , old.Stopdate
                        , old.Stoptype);
       -- update so applications have an update row count to query
       UPDATE audit.dmltrace SET
              tstamp = timeofday()::timestamp
       WHERE tablename = 'FemaleFertilityInterval'
       AND rowkey = old.Interval_OID::text 
       AND optype = 'U' AND usr = current_user AND tstamp IS NULL;
);

CREATE OR REPLACE RULE r_femalefertilityinterval_del AS
       ON DELETE TO femalefertilityinterval
       DO INSTEAD (
       -- delete the recording period instead
       DELETE FROM plhdb.recordingperiod
       WHERE start_oid = (
               SELECT observation_oid FROM plhdb.observation
               WHERE time_of_observation = old.Startdate
               AND type_oid = plhdb.get_cvterm_oid(NULL, old.Starttype, 
                                                   NULL, 'event types', 
                                                   'start of recording',
                                                   0)
               AND individual_oid = old.Anim_OID
       )
       AND COALESCE(end_oid,-1) = 
               CASE 
               WHEN old.Stopdate IS NULL THEN -1
               ELSE (
                       SELECT observation_oid FROM plhdb.observation
                       WHERE time_of_observation = old.Stopdate
                       AND type_oid = plhdb.get_cvterm_oid(NULL, old.Stoptype, 
                                                           NULL, 'event types', 
                                                           'end of recording',
                                                           0)
                       AND individual_oid = old.Anim_OID
               )
               END
       AND type_oid = (
               SELECT cvterm_oid FROM plhdb.cvterm
               WHERE name = 'female fertility period'
               AND namespace = 'period types'
       );
);
