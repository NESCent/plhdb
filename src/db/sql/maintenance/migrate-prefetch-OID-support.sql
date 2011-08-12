--
-- Migration script for the changes necessary to support pre-fetched
-- primary keys for femalefertilityinterval and biography insert
-- operations.
--
-- Two functions are changing their signature, for one it is only a
-- parameter name, and for the other it is adding a parameter. This
-- migration script essentially prepares those two functions for
-- re-running the plhdb.funcs.sql script without errors, and thus the
-- ability to do so within a transaction.
--
-- To complete the migration, first run plhdb.funcs.sql, and then
-- plhdb.rules.sql. The order *is* important, because running the
-- plhdb.funcs.sql script will invalidate some of the rules.
--
-- Copyright (C) 2011, Hilmar Lapp, hlapp at gmx.net
-- Copyright (C) 2011, National Evolutionary Synthesis Center (NESCent)
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
       , p_Oid individual.individual_oid%TYPE
       , p_do_DML integer)
RETURNS individual.individual_oid%TYPE AS
$$
BEGIN
        -- this is only a placeholder body - we will overwrite this subsequently
        RETURN 1;
END;
$$
LANGUAGE plpgsql;

-- #################################################################
-- Functions for PLHDB API views
-- #################################################################

SET search_path TO public, pg_catalog;

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
        , p_Departtype biography.Departtype%TYPE
        , p_Anim_OID biography.Anim_OID%TYPE)
RETURNS INTEGER AS
$$
BEGIN
      -- this is only a placeholder body - we will overwrite this subsequently
      RETURN 1;
END;
$$
LANGUAGE plpgsql;

\echo Do not forget to run plhdb.funcs.sql, and then plhdb.rules.sql, in that ordeer.
\echo There is no need to commit before doing so.