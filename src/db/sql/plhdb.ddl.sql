--
-- Schema definition for a general, normalized Life Histories
-- Database. The data model API for the Primate Life Histories
-- Database working group, which works on top of this, is in a
-- separate file.
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

--
-- We create the schema in two parts: a more-or-less fully normalized
-- relational model for a Life Histories Database, using tables, and a
-- partially denormalized view layer specific for the Primate Life
-- Histories Database.
--
-- We place the normalized model in a separate schema so that it isn't
-- immediately visible to users accessing the database. Conversely,
-- the Primate Life Histories API views are in the public schema.

CREATE SCHEMA plhdb;

SET search_path TO plhdb, public;

-- Table cvterm: controlled vocabulary and ontology terms.
CREATE TABLE cvterm (
       cvterm_oid SERIAL,
       PRIMARY KEY (cvterm_oid),
       name VARCHAR(64) NOT NULL,
       code VARCHAR(8),
       identifier VARCHAR(16),
       namespace VARCHAR(32) NOT NULL,
       CONSTRAINT cvterm_name UNIQUE (name, namespace),
       CONSTRAINT cvterm_identifier UNIQUE (identifier)
);

CREATE INDEX cvterm_code ON cvterm (code);

COMMENT ON TABLE cvterm IS 'Controlled vocabulary and ontology terms. For simplicity, the name of the vocabulary or ontology is in the column namespace (and hence not normalized). Also, terms may have a short code (which need not be unique).';

COMMENT ON COLUMN cvterm.name IS 'Name of the term. Must be unique within a namespace.';

COMMENT ON COLUMN cvterm.code IS 'An optional code for the name, often only a single letter or number. Note that this need not be unique within a namespace.';

COMMENT ON COLUMN cvterm.identifier IS 'Identifier (in OBO speak called primary dbxref) of the term. If provided, must be unique among all terms.';

COMMENT ON COLUMN cvterm.namespace IS 'The name of the controlled vocabulary or ontology to which a term belongs.';

-- Table cvterm_relationship: Relationships between ontology terms as
-- subject, predicate, object triples.
CREATE TABLE cvterm_relationship (
       cvterm_relationship_oid SERIAL,
       PRIMARY KEY (cvterm_relationship_oid),
       subject_oid INTEGER NOT NULL,
       FOREIGN KEY (subject_oid) REFERENCES cvterm (cvterm_oid)
               ON DELETE CASCADE,
       object_oid INTEGER NOT NULL,
       FOREIGN KEY (object_oid) REFERENCES cvterm (cvterm_oid)
               ON DELETE CASCADE,
       predicate_oid INTEGER NOT NULL,
       FOREIGN KEY (predicate_oid) REFERENCES cvterm (cvterm_oid)
               ON DELETE CASCADE,
       CONSTRAINT cvterm_relationship_c1 UNIQUE (subject_oid,object_oid)
);

CREATE INDEX cvterm_relationship_object ON cvterm_relationship (object_oid);

COMMENT ON TABLE cvterm_relationship IS 'Relationships between ontology terms as subject, predicate, object triples. This triple table is slightly simplified as only one relationship type (predicate) is allowed between a given subject/object pair (though different pairs can have different predicates).';

COMMENT ON COLUMN cvterm_relationship.subject_oid IS 'The subject term of the relationship.';

COMMENT ON COLUMN cvterm_relationship.predicate_oid IS 'The predicate term of the relationship.';

COMMENT ON COLUMN cvterm_relationship.object_oid IS 'The object term of the relationship.';

-- Table taxon: The taxon of the individuals (animals, plants, etc)
-- being studied
CREATE TABLE taxon (
       taxon_oid SERIAL,
       PRIMARY KEY (taxon_oid),
       scientific_name VARCHAR(128) NOT NULL,
       common_name VARCHAR(64),
       CONSTRAINT taxon_scientific_name UNIQUE (scientific_name),
       CONSTRAINT taxon_common_name UNIQUE (common_name)
);

COMMENT ON TABLE taxon IS 'The taxon of the individuals (animals, plants, etc) being studied. For now, this is a very simplified taxon model with no identification of the taxonomy being used, and there can be only two names, one scientific and one common.';

COMMENT ON COLUMN taxon.scientific_name IS 'The scientific name for the taxon, using for example the NCBI or the ITIS taxonomies.';

COMMENT ON COLUMN taxon.common_name IS 'The common name for the taxon. This need not be the most common or generally accepted name, but the common name used within the study.';

-- Table site: The site where the study was or is being conducted
CREATE TABLE site (
       site_oid SERIAL,
       PRIMARY KEY (site_oid),
       name VARCHAR(64) NOT NULL,
       latitude NUMERIC(7,3),
       longitude NUMERIC(7,3),
       geodetic_datum VARCHAR(12) DEFAULT 'WGS84',
       CONSTRAINT site_name UNIQUE (name)
);

COMMENT ON TABLE site IS 'The site where the study was or is being conducted. For now, geographic coordinates are designated to the entire site, not individually to observations (though that would seem desirable over the long term). It would also seem desirable to record the geographic area of the site as a polygon, rather than as a single point.';

COMMENT ON COLUMN site.name IS 'The name of the site, which must be unique. This may be a short or a long name, depending on what the study uses.';

COMMENT ON COLUMN site.latitude IS 'The decimal latitude coordinate of the site, using positive and negative sign to indicate N and S, respectively.';

COMMENT ON COLUMN site.longitude IS 'The decimal longitude coordinate of the site, using positive and negative sign to indicate E and W, respectively.';

COMMENT ON COLUMN site.geodetic_datum IS 'The geodetic system on which the geo-coordinates are based. For geo-coordinates measured between 1984 and 2010, this will typically be WGS84 and is the default value.';

-- Table study: The study within which the individuals have been observed
CREATE TABLE study (
       study_oid SERIAL,
       PRIMARY KEY (study_oid),
       name VARCHAR(32),
       id VARCHAR(12) NOT NULL,
       owners VARCHAR(128),
       taxon_oid INTEGER NOT NULL,
       FOREIGN KEY (taxon_oid) REFERENCES taxon (taxon_oid)
               ON DELETE CASCADE,
       site_oid INTEGER NOT NULL,
       FOREIGN KEY (site_oid) REFERENCES site (site_oid)
               ON DELETE CASCADE,
       CONSTRAINT study_name UNIQUE (name),
       CONSTRAINT study_code UNIQUE (id)
);

COMMENT ON TABLE study IS 'The study within which the individuals have been observed. At present, the same taxon and the same site applies to all individuals within the study.';

COMMENT ON COLUMN study.name IS 'The name of the study. This may be a descriptive or an encoded and must be unique if provided.';

COMMENT ON COLUMN study.id IS 'A short identifier commonly used to refer to the study. This need not be a number, but must be unique, and is required.';

COMMENT ON COLUMN study.owners IS 'The owners of the observational data that this study gave rise to. This may be a single person, an organization, or a (comma-delimited) list of such.';

COMMENT ON COLUMN study.taxon_oid IS 'The taxon for the individuals that were or are being observed in this study.';

COMMENT ON COLUMN study.site_oid IS 'The site where this study was or is being conducted, and where hence the individuals have been observed.';

-- Table individual: The individuals that are the subject of
-- observation, such as the animals in an animal life history study
CREATE TABLE individual (
       individual_oid SERIAL,
       PRIMARY KEY (individual_oid),
       name VARCHAR(128),
       id VARCHAR(16) NOT NULL,
       sex CHAR(1) 
               CHECK (sex IN ('M','F','U')),
       birthgroup VARCHAR(32),
       birthgroup_certainty CHAR(1) 
               CHECK (birthgroup_certainty = 'C' OR birthgroup_certainty = 'U'),
       is_first_born CHAR(1)
               CHECK (is_first_born IN ('Y','N','U')),
       study_oid INTEGER NOT NULL,
       FOREIGN KEY (study_oid) REFERENCES study (study_oid)
               ON DELETE CASCADE;
       CONSTRAINT individual_oid_name UNIQUE (name,study_oid),
       CONSTRAINT individual_oid_code UNIQUE (id,study_oid)
);

COMMENT ON TABLE individual IS 'The individuals that are the subject of observation, such as the animals in an animal life history study. At present, animals can be the subject of only one study; in the future this restriction may need to be lifted. Also, birth groups are recorded directly as an attribute, and hence are denormalized, but at present it is unclear which attributes other than a name a birth group would need to have.';

COMMENT ON COLUMN individual.name IS 'The (long) name of the individual, which must be unique within a study if provided.';

COMMENT ON COLUMN individual.id IS 'The ID or codename or barcode of the individual, which must be unique within the study.';

COMMENT ON COLUMN individual.sex IS 'The gender of the individual. Allowed values are M, F, and U, for male, female, and unknown, respectively. Null values are allowed, meaning that the sex has not been determined.';

COMMENT ON COLUMN individual.birthgroup IS 'Where applicable, the name or code or ID of the group within which the individual was born. May not apply to a study.';

COMMENT ON COLUMN individual.birthgroup_certainty IS 'Whether the birth group assignment is certain (C) or uncertain (U).'; 

COMMENT ON COLUMN individual.is_first_born IS 'Whether the individual is the first born or first offspring from the maternal parent. Values are Y, N, and U, for Yes, No, and Unknown, respectively. Null value is allowed and means that the attribute does not apply.';

COMMENT ON COLUMN individual.study_oid IS 'The study in which this individual was observed.';

-- Table individual_relationship: Parental relationships between individuals
CREATE TABLE individual_relationship (
       individual_relationship_oid SERIAL,
       PRIMARY KEY (individual_relationship_oid),
       parent_oid INTEGER NOT NULL,
       FOREIGN KEY (parent_oid) REFERENCES individual (individual_oid)
               ON DELETE CASCADE,
       child_oid INTEGER NOT NULL,
       FOREIGN KEY (child_oid) REFERENCES individual (individual_oid)
               ON DELETE CASCADE,
       reltype VARCHAR(16) NOT NULL 
               CHECK (reltype='maternal parent' OR reltype='paternal parent'),
       CONSTRAINT individual_relationship_c1 UNIQUE (parent_oid,child_oid)
);

CREATE INDEX individual_relationship_child ON individual_relationship (
       child_oid
);

COMMENT ON TABLE individual_relationship IS 'Parental relationships between individuals.';

COMMENT ON COLUMN individual_relationship.parent_oid IS 'The parental individual in the relationship.';

COMMENT ON COLUMN individual_relationship.child_oid IS 'The offspring individual in the relationship.';

COMMENT ON COLUMN individual_relationship.reltype IS 'The nature of the relationship, currently either ''maternal parent'' or ''paternal parent''.';

-- Table observation: An observation for or of an individual
CREATE TABLE observation (
       observation_oid SERIAL,
       PRIMARY KEY (observation_oid),
       time_of_observation timestamp NOT NULL,
       time_error DOUBLE PRECISION,
       min_boundary timestamp,
       max_boundary timestamp,
       prob_type_oid INTEGER,
       FOREIGN KEY (prob_type_oid) REFERENCES cvterm (cvterm_oid)
               ON DELETE SET NULL,
       type_oid INTEGER NOT NULL,
       FOREIGN KEY (type_oid) REFERENCES cvterm (cvterm_oid),
       individual_oid INTEGER NOT NULL,
       FOREIGN KEY (individual_oid) REFERENCES individual (individual_oid)
               ON DELETE CASCADE,
       CONSTRAINT observation_c1 UNIQUE (time_of_observation,individual_oid,type_oid)
);

CREATE INDEX observation_individual ON observation (individual_oid);

COMMENT ON TABLE observation IS 'An observation for or of an individual. An observation may start a period during which an individual has a certain property (such as disease) or capacity (such as fertility), or may mark the beginning or end of the period over which an individual has been part of the study, or may represent a singular event (such as birth, or death).';

COMMENT ON COLUMN observation.time_of_observation IS 'The time or date when the observation was made.';

COMMENT ON COLUMN observation.time_error IS 'The error with which the time is being stated, meaning that the actual time may have been between the recorded time minus the error to the recorded time plus the error. The unit of error will depend on the study, but should be uniform within a study, for example (fraction of) years, or days.';

COMMENT ON COLUMN observation.min_boundary IS 'The (typically estimated) earliest time at which the observed event could have taken place.';

COMMENT ON COLUMN observation.max_boundary IS 'The (typically estimated) latest time at which the observed event could have taken place.';

COMMENT ON COLUMN observation.prob_type_oid IS 'The probability distribution or function describing the actual time of the event between the min (lower) boundary and the max (upper) boundary. If this is non-null, min and max boundary need to have values too.';

COMMENT ON COLUMN observation.type_oid IS 'The type of the event, such as birth, or death, or feeding.';

COMMENT ON COLUMN observation.individual_oid IS 'The individual for which the observation was made.';

-- Table recordingperiod: A period of time created by an observation
-- that starts the period and one that ends it.
CREATE TABLE recordingperiod (
       recordingperiod_oid SERIAL,
       PRIMARY KEY (recordingperiod_oid),
       start_oid INTEGER NOT NULL,
       FOREIGN KEY (start_oid) REFERENCES observation (observation_oid)
               ON DELETE CASCADE,
       end_oid INTEGER,
       FOREIGN KEY (end_oid) REFERENCES observation (observation_oid)
               ON DELETE SET NULL,
       type_oid INTEGER NOT NULL,
       FOREIGN KEY (type_oid) REFERENCES cvterm (cvterm_oid),
       CONSTRAINT recordingperiod_c1 UNIQUE (start_oid, end_oid, type_oid)
);

CREATE INDEX recordingperiod_end ON recordingperiod (end_oid);

COMMENT ON TABLE recordingperiod IS 'A period of time created by an observation that starts the period and one that ends it. The combination of starting and ending observation and type is unique. A period of time may be continuous, such as one during with an individual has a certain property (for example, disease) or a capacity (for example, fertility), or it may be implicitly discontinuous, such as the total observation period if it has intervening gaps.';

COMMENT ON COLUMN recordingperiod.start_oid IS 'The observation that starts the recording period.';

COMMENT ON COLUMN recordingperiod.end_oid IS 'The observation that ends the period.';

COMMENT ON COLUMN recordingperiod.type_oid IS 'The type of the recording period, such as the property (for example, a disease) or the capacity (for example, fertility) that the individual had during the period.';

SET search_path TO public, pg_catalog;

