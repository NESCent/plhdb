--
-- Audit part of the Primate Life Histories Database.
--
-- Copyright (C) 2007, Hilmar Lapp, hlapp at gmx.net
-- Copyright (C) 2007, National Evolutionary Synthesis Center (NESCent)
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

-- At present we create this in a separate schema. This may become a
-- reusable unit in a later version.

CREATE SCHEMA audit;

CREATE TABLE audit.dmltrace (
       dmltrace_oid SERIAL NOT NULL,
       PRIMARY KEY (dmltrace_oid),
       tablename VARCHAR(64) NOT NULL, 
       rowkey VARCHAR(32) NOT NULL, 
       optype char(1) NOT NULL
             CHECK (optype IN ('I','U','D')), 
       usr VARCHAR(16) NOT NULL, 
       tstamp TIMESTAMP,
       CONSTRAINT dmltrace_c1 UNIQUE (rowkey,tablename,optype,usr,tstamp)
);

COMMENT ON TABLE audit.dmltrace IS 'Simple table for tracking DML operations (inserts, updates, deletes). At present, timestamp is optional, but this may change in the future.';

COMMENT ON COLUMN audit.dmltrace.tablename IS 'The name of the table in which a row was changed, inserted, or deleted. Depending on the application, this may also be the name of a view.';

COMMENT ON COLUMN audit.dmltrace.rowkey IS 'The primary or unique key to the row that was affected. For updates and deletes, this should point to the old values, before the change took affect.';

COMMENT ON COLUMN audit.dmltrace.optype IS 'The type of DML operation that was executed, I, U, and D for Insert, Update, and Delete, respectively.';

COMMENT ON COLUMN audit.dmltrace.usr IS 'The name of the user making the DML operation.';

COMMENT ON COLUMN audit.dmltrace.tstamp IS 'The time at which the operation was executed.';
