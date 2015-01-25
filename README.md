Primate Life Histories Database
===============================

Introduction
------------

Primate Life Histories is an online database project with database and
web interface to archive, manage, search and download individual-based
life history data that have been collected from wild primate populations.

Installation:

1. check out source code to a desired location
2. Install required jar files (see Technology)
3. Create a postgresql database by running the sql scripts under the
   src/db.sql folder in the folliwng order
    1. create tables, including:
        * plhdb.ddl.sql: create major tables to hold scientific data
        * plhdb.audit.sql: create table to store audit information 
        * plhdb.auth.sql: create auth schema with tables to store user
          and authentication and authorization information
    2. create views: plhdb.views.sql
    3. install the SQL procedural language if it is not already
       avalable: `CREATE LANGUAGE plpgsql;`
    4. create table: plhdb.bulkimp.sql: tables for bulk data import
    5. create functions:plhdb.funcs.sql
    6. create rules: plhdb.rules.sql
    7. initialize data: import cvterm data in the file
       `src/db/data/event_types.txt` with term relationship defined in
       `src/db/data/cvterms.ttl`
4. Create a user with access to the database
5. Compile java classes and generate web application war file.  The
   web-application is built using Apache Ant. You must have ant
   installed in order to build it.

   Properties need to be specified with the '-D' option:
	* `project.version`: the application version
	* `hibernate.database`: the hibernate database URL 
	* `hibernate.username`: the hibernate database user name
	* `hibernate.password`: the hibernate database password 

	Use the database user account you created in step 4.
6. Copy the war file generated in step 5 to Tomcat or Jboss deploy folder
7. Start Tomcat (restart is not necessary for Jboss)
8. The web application should be visible now at
   http://your.domain.name:8080/plhdb

Technology
----------

* Database: PostgreSQL 8.3
* Database ORM : Hibernate
* Programming Language: java
* Web Framework: Spring
* Other Libraries:
    + c3p0 Database Connection Pooling
    + struts
    + dojo

Source Code
-----------

Source code is available on GitHub (http://github.com/NESCent/plhdb)
under a GPL v3 license (http://www.gnu.org/copyleft/gpl.html). The
original repository on SourceForge (http://sf.net/projects/plhdb) is
no longer maintained.

Credits
-------

* Concept, content, and scientific requirements: the Evolutionary
  Ecology of Primate Life Histories Working Group, Susan C Alberts
  (Duke University, PI), Karen B Strier (University of Wisconsin-Madison, PI).
* Database and application programming: Xianhua Liu (NESCent), Hilmar
  Lapp (NESCent).

How to Cite
-----------

If you use this code or parts of it, please cite the following publication:

> Strier, K. B., Altmann, J., Brockman, D. K., Bronikowski, A. M., Cords, M., Fedigan, L. M., Lapp, H., Liu, X., Morris, W. F., Pusey, A. E., Stoinski, T. S., and Alberts, S. C. "The Primate Life History Database: A Unique Shared Ecological Data Resource". Methods in Ecology and Evolution 1, no. 2 (2010): 199–211.
> http://dx.doi.org/10.1111/j.2041-210X.2010.00023.x

Contact
-------

* The website is maintained by the National Evolutionary Synthesis
  Center (NESCent).

        2024 W. Main Street, Suite A200
        Durham, NC 27705-4667
        Tel: (919) 668-4551
        Fax: (919) 668-9198

* To inquire about the database, send email to the PIs of the working
  group (plhdb-admin@nescent.org), or report bugs and request
  technical help (plhdb-bug@nescent.org).

License
-------

This software is released under the GPL v3 license (see included LICENSE).

>  Primate Life Histories Database
>  Copyright (C) 2007-2012 Hilmar Lapp, Xianhua Liu 
>
>  This program is free software: you can redistribute it and/or modify
>  it under the terms of the GNU General Public License as published by
>  the Free Software Foundation, either version 3 of the License, or
>  (at your option) any later version.
>
>  This program is distributed in the hope that it will be useful,
>  but WITHOUT ANY WARRANTY; without even the implied warranty of
>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  GNU General Public License for more details.
>
>  You should have received a copy of the GNU General Public License
>  along with this program.  If not, see <http://www.gnu.org/licenses/>.
