--
-- Script to fix the wrong species assignment for studyID 2
--

-- create the new taxon
INSERT INTO plhdb.taxon (scientific_name, common_name)
VALUES ('Propithecus edwardsi', 'Milne-Edwards'' Sifaka');

-- change the taxon of the study to this one
UPDATE plhdb.study SET
       taxon_oid = (
                 SELECT taxon_oid FROM plhdb.taxon 
                 WHERE scientific_name = 'Propithecus edwardsi')
WHERE id = '2';