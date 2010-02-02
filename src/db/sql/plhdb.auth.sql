--
-- This sql script creates tables and sequences that are required for
-- the security module.
--
-- Copyright (C) 2007, Xianhua Liu, xliu at nescent.org
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

CREATE SCHEMA auth;

CREATE TABLE auth.account (	
	user_oid SERIAL,
        PRIMARY KEY (user_oid),
	first_name VARCHAR(64) NOT NULL,
	last_name VARCHAR(64) NOT NULL,
	email VARCHAR(255) NOT NULL,
	password VARCHAR(64) NOT NULL,
	create_date date,
	enable_disable_status VARCHAR(1) NOT NULL,
	admin boolean DEFAULT false
);

CREATE TABLE auth.permission (
        permission_oid SERIAL,
        PRIMARY KEY (permission_oid),
	access VARCHAR(10) NOT NULL,
	study VARCHAR(64) NOT NULL,
	user_oid INTEGER NOT NULL,
        FOREIGN KEY (user_oid) REFERENCES auth.account(user_oid)
                 ON DELETE CASCADE
);

-- TODO:
-- - rename enable_disable_status to is_enabled (pending allowed values as per above)
-- - rename admin to is_admin
-- - rename study to studies (pending allowed values as per above: is this one or more study_oids, IDs, or one row per study and user?)
-- - rename account.user_oid to account_oid
-- - rename sequence user_user_oid_seq to account_account_oid_seq
-- - rename permission.user_oid to permission.account_oid
-- - add appropriate indexes
