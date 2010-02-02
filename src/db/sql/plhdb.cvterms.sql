--
-- cvterms for a general, normalized Life Histories
-- Database
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

--
-- The geodetic datum list is from: http://www.colorado.edu/geography/gcraft/notes/datum/dlist.html. 
--

SET search_path TO plhdb;


ALTER SEQUENCE cvterm_cvterm_oid_seq RESTART WITH 1;

-- insert cvterms into the cvterm table.
insert into cvterm (namespace,name)  values ('recording period type','female fertility period');
insert into cvterm (namespace,name)  values ('recording period type','total observation period');
insert into cvterm (namespace,name)  values ('event types','start of recording');
insert into cvterm (namespace,name)  values ('event types','stop of recording');
insert into cvterm (namespace,name,code)  values ('event types','birth','B');
insert into cvterm (namespace,name,code)  values ('event types','immigration into population','I');
insert into cvterm (namespace,name,code)  values ('event types','confirmed identification','C');
insert into cvterm (namespace,name,code)  values ('event types','beginning of observation','O');
insert into cvterm (namespace,name,code)  values ('event types','death','D');
insert into cvterm (namespace,name,code)  values ('event types','emigration from population','E');
insert into cvterm (namespace,name,code)  values ('event types','permanent disappearance','P');
insert into cvterm (namespace,name,code)  values ('event types','end of observation','O');
insert into cvterm (namespace,name)  values ('geodetic datum','Airy - Ordnance_Survey_of_Great_Britain_36');
insert into cvterm (namespace,name)  values ('geodetic datum','Australian_National - Anna_1_Astro_1965');
insert into cvterm (namespace,name)  values ('geodetic datum','Australian_National - Australian_Geodetic_1984');
insert into cvterm (namespace,name)  values ('geodetic datum','Bessel_1841 - Bukit_Rimpah');
insert into cvterm (namespace,name)  values ('geodetic datum','Bessel_1841 - Djakarta(Batavia)');
insert into cvterm (namespace,name)  values ('geodetic datum','Bessel_1841 - Gunung_Segara');
insert into cvterm (namespace,name)  values ('geodetic datum','Bessel_1841 - Massawa');
insert into cvterm (namespace,name)  values ('geodetic datum','Bessel_1841 - Potsdam_Rauenberg_DHDN');
insert into cvterm (namespace,name)  values ('geodetic datum','Bessel_1841 - Tokyo_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','Bessel_1841_(Namibia) - Schwarzeck');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Alaska/Canada_NAD-27');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Alaska_(NAD-27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Bahamas_(NAD-27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Bermuda_1957');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Canada_Mean_(NAD27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Canal_Zone_(NAD27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Cape_Canaveral_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Carribean_(NAD27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Central_America_(NAD27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Cuba_(NAD27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Greenland_(NAD27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Guam_1963');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - L.C._5_Astro');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Luzon');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Mexico_(NAD27)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Mindanao');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - North_America_1927_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Old_Hawaiian_Kauai');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Old_Hawaiian_Maui');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Old_Hawaiian_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Old_Hawaiian_Oahu');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1866 - Puerto_Rico');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Adindan');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - ARC-1950_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - ARC-1960_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Cape');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Carthage');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Liberia_1964');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Mahe_1971');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Masirah_Is._(Nahrwan)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Merchich');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Minna');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Nahrwan');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Oman');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Unites_Arab_Emirates_(Nahrwan)');
insert into cvterm (namespace,name)  values ('geodetic datum','Clarke_1880 - Viti_Levu_1916');
insert into cvterm (namespace,name)  values ('geodetic datum','Everest - Indian');
insert into cvterm (namespace,name)  values ('geodetic datum','Everest - Kandawala');
insert into cvterm (namespace,name)  values ('geodetic datum','Everest - S.E.Asia_(Indian)');
insert into cvterm (namespace,name)  values ('geodetic datum','Everest - Thai/Viet_(Indian)');
insert into cvterm (namespace,name)  values ('geodetic datum','Everest - Timbalai_1948');
insert into cvterm (namespace,name)  values ('geodetic datum','GRS_80 - North_America_83');
insert into cvterm (namespace,name)  values ('geodetic datum','Helmert_1906 - Old_Egyptian');
insert into cvterm (namespace,name)  values ('geodetic datum','Hough - Wake-Eniwetok_60');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Ain_El_Abd_1970');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Ascension_Island_58');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Astro_B4_Sor.Atoll');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Astro_Beacon_E');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Astro_Pos_71/4');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Astronomic_Stn._52');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Bellevue_(IGN)');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Bogota_Observatory');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Camp_Area_Astro');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Campo_Inchauspe');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Canton_Island_1966');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Chatham_1971');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Chua_Astro');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Corrego_Alegre');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Corrego_Alegre_(Provisional)');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Cyprus');
insert into cvterm (namespace,name)  values ('geodetic datum','International - DOS_1968');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Easter_lsland_1967');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Egypt');
insert into cvterm (namespace,name)  values ('geodetic datum','International - European_1950');
insert into cvterm (namespace,name)  values ('geodetic datum','International - European_1950_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','International - European_1979_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Finnish_Nautical_Chart');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Gandajika_Base');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Geodetic_Datum_49');
insert into cvterm (namespace,name)  values ('geodetic datum','International - GUX_1_Astro');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Herat_North');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Hjorsey_1955');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Hong_Kong_1963');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Hu-Tzu-Shan');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Iran');
insert into cvterm (namespace,name)  values ('geodetic datum','International - ISTS_073_Astro_69');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Johnston_Island_61');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Kerguelen_Island');
insert into cvterm (namespace,name)  values ('geodetic datum','International - La_Reunion');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Marco_Astro');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Midway_Astro_61');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Naparima_BWI');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Observatorio_1966');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Pico_De_Las_Nieves');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Pitcairn_Astro_67');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Provisional_South_American_1956_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Provisional_South_Chilean_1963');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Qornoq');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Quatar_National');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Rome_1940');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Santa_Braz');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Santo_(DOS)');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Sapper_Hill_43');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Sicily');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Southeast_Base');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Southwest_Base');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Tananarive_Observatory_25');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Tristan_Astro_1968');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Yacare');
insert into cvterm (namespace,name)  values ('geodetic datum','International - Zanderij');
insert into cvterm (namespace,name)  values ('geodetic datum','Krassovsky - Afgooye');
insert into cvterm (namespace,name)  values ('geodetic datum','Krassovsky - Pulkovo_1942');
insert into cvterm (namespace,name)  values ('geodetic datum','Krassovsky - S_42');
insert into cvterm (namespace,name)  values ('geodetic datum','Modified_Airy - Ireland_1965');
insert into cvterm (namespace,name)  values ('geodetic datum','Modified_Everest - Kertau_48');
insert into cvterm (namespace,name)  values ('geodetic datum','Modified_Fischer_1960 - South_Asia');
insert into cvterm (namespace,name)  values ('geodetic datum','South_American_1969 - SAD-69/Brazil');
insert into cvterm (namespace,name)  values ('geodetic datum','South_American_1969 - South_American_1969_mean');
insert into cvterm (namespace,name)  values ('geodetic datum','WGS-72');
insert into cvterm (namespace,name)  values ('geodetic datum','WGS-84');
insert into cvterm (namespace,name)  values ('geodetic datum','WGS-84 - Ghana');
insert into cvterm (namespace,name)  values ('geodetic datum','WGS-84 - Gunung_Serindung_1962');
insert into cvterm (namespace,name)  values ('geodetic datum','WGS-84 - Montjong_Lowe');
insert into cvterm (namespace,name)  values ('geodetic datum','WGS-84 - Sierra_Leone_1960');
insert into cvterm (namespace,name)  values ('cvterm relationship','is_a');


--
-- insert cvterm relationships
--

insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(6,4,138);
insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(7,4,138);
insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(8,4,138);
insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(9,4,138);
insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(10,5,138);
insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(11,5,138);
insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(12,5,138); 
insert into cvterm_relationship (subject_oid,object_oid, predicate_oid) values(13,5,138);
