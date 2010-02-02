--
-- Migration script for the Aug 2007 version of the data in the PLHDB
-- database to the version accommodating the changes requested for
-- Birthdate. Specifically, birthdate gets a min and max boundary and
-- a probability distribution indicator.
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
-- We need new cvterms for this.
-- ######################################################################

INSERT INTO plhdb.cvterm_relationships (
       subj_name, subj_code, subj_namespace, 
       pred_identifier, pred_namespace,
       obj_name, obj_namespace)
VALUES ('normal distribution','N','probability types',
        'OBO_REL:is_a','relationship',
        'probability distribution','probability types');

INSERT INTO plhdb.cvterm_relationships (
       subj_name, subj_code, subj_namespace, 
       pred_identifier, pred_namespace,
       obj_name, obj_namespace)
VALUES ('uniform distribution','U','probability types',
        'OBO_REL:is_a','relationship',
        'probability distribution','probability types');

-- ######################################################################
-- We will migrate the data directly, using the normalized tables, to
-- avoid generating a huge audit trail.
-- ######################################################################

UPDATE plhdb.observation SET
       min_boundary = time_of_observation-(time_error*365||' days')::interval,
       max_boundary = time_of_observation+(time_error*365||' days')::interval,
       prob_type_oid = (
            SELECT t.cvterm_oid FROM plhdb.cvterm t
            WHERE t.name = 'normal distribution'
            AND t.namespace = 'probability types'
       )
WHERE type_oid = (
      SELECT ot.cvterm_oid FROM plhdb.cvterm ot
      WHERE ot.name = 'date of birth' AND ot.namespace = 'event types'
)
AND   time_error IS NOT NULL
AND   prob_type_oid IS NULL
AND   min_boundary IS NULL
AND   max_boundary IS NULL;

UPDATE plhdb.observation SET time_error = NULL
WHERE type_oid = (
      SELECT ot.cvterm_oid FROM plhdb.cvterm ot
      WHERE ot.name = 'date of birth' AND ot.namespace = 'event types'
)
AND   time_error IS NOT NULL
AND   prob_type_oid IS NOT NULL
AND   min_boundary IS NOT NULL
AND   max_boundary IS NOT NULL;
