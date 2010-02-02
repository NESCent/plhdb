--
-- Script to change the birth date to use an observation type of 'date
-- of birth'
--

-- Change the type for all those birth observations that are not part
-- of a recording period.
UPDATE plhdb.observation SET
       type_oid = (
                SELECT cvterm_oid FROM plhdb.cvterm
                WHERE name = 'date of birth' AND namespace = 'event types')
WHERE type_oid = (
                SELECT cvterm_oid FROM plhdb.cvterm
                WHERE name = 'birth' AND namespace = 'event types') 
AND NOT EXISTS (
        SELECT 1 FROM plhdb.recordingperiod
        WHERE start_oid = observation.observation_oid
);

-- For those birth observations (with type 'birth') that are re-used
-- for recording periods (these must now be all the remaining ones),
-- create new ones using type 'date of birth'.
INSERT INTO plhdb.observation (time_of_observation, time_error, 
                               type_oid, individual_oid)
SELECT DISTINCT r.start_time, r.start_time_error, t.cvterm_oid, r.individual_oid
FROM plhdb.recordingperiods r, plhdb.cvterm t
WHERE r.start_event_type = 'birth'
AND   r.start_event_type_namespace = 'event types'
AND   r.period_type = 'total observation period'
AND   t.name = 'date of birth' AND t.namespace = 'event types'
AND NOT EXISTS (
         SELECT 1 
         FROM plhdb.observation o 
              JOIN plhdb.cvterm ot ON (o.type_oid = ot.cvterm_oid)
         WHERE o.individual_oid = r.individual_oid
         AND ot.name = 'birth' AND ot.namespace = 'event types'
         AND o.observation_oid != r.start_observation_oid
);

