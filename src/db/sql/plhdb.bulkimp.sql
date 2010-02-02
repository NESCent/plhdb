--
-- Definition of PostgreSQL tables, stored functions, and triggers to
-- enable bulk insert of data to the PLHDB API views using the COPY
-- (or psql \copy) command.
--
-- This file is part of the database definition for the Primate
-- Life Histories Database working group.
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

-- We create this in a separate schema, so ordinary users don't see it.
CREATE SCHEMA bulkimp;

-- The problem we are solving here is that COPY (and hence neither
-- psql \copy) is not allowed for views, because it doesn't trigger
-- the execution of rules. It does, however, execute any triggers
-- defined on a table. Hence, we will mirror the views to which we
-- wish to insert as tables, and then define insert triggers on them
-- that will delegate to the respective view.
 
-- Create tables mirroring the views.
CREATE TABLE bulkimp.biography_imp AS 
SELECT * FROM biography WHERE 1=2;

CREATE TABLE bulkimp.femalefertilityinterval_imp AS 
SELECT * FROM femalefertilityinterval WHERE 1=2;

CREATE TABLE bulkimp.studyinfo_imp AS
SELECT * FROM studyinfo WHERE 1=2;

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

CREATE OR REPLACE FUNCTION bulkimp.femalefertilityinterval_ins_trf()
RETURNS TRIGGER AS
$$
BEGIN
        INSERT INTO femalefertilityinterval (
                StudyID
                , AnimID
                , Startdate
                , Starttype
                , Stopdate
                , Stoptype)
        VALUES (
                new.StudyID
                , new.AnimID
                , new.Startdate
                , new.Starttype
                , new.Stopdate
                , new.Stoptype);
        RETURN NULL; -- no real insert into this table
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bulkimp.studyinfo_ins_trf()
RETURNS TRIGGER AS
$$
BEGIN
        INSERT INTO studyinfo (
                StudyID
                , CommonName
                , SciName
                , SiteID
                , Owners
                , Latitude
                , Longitude)
        VALUES (
                new.StudyID
                , new.CommonName
                , new.SciName
                , new.SiteID
                , new.Owners
                , new.Latitude
                , new.Longitude);
        RETURN NULL; -- no real insert into this table
END;
$$
LANGUAGE plpgsql;

-- Create the insert triggers.
CREATE TRIGGER biography_ins_tr 
BEFORE INSERT ON bulkimp.biography_imp
FOR EACH ROW
EXECUTE PROCEDURE bulkimp.biography_ins_trf();

CREATE TRIGGER femalefertilityinterval_ins_tr 
BEFORE INSERT ON bulkimp.femalefertilityinterval_imp
FOR EACH ROW
EXECUTE PROCEDURE bulkimp.femalefertilityinterval_ins_trf();

CREATE TRIGGER studyinfo_ins_tr 
BEFORE INSERT ON bulkimp.studyinfo_imp
FOR EACH ROW
EXECUTE PROCEDURE bulkimp.studyinfo_ins_trf();