--Change schema name in input from public
SELECT 
          CASE 
                    WHEN Row_number() over () = 1 THEN '\set ON_ERROR_ROLLBACK off'  || e'\n'
                                        || '\set ON_ERROR_STOP off' || e'\n'
                                        || 'BEGIN; ' || e'\n'
                    ELSE 'BEGIN; '  || e'\n'
          END 
                    || 'DO $$ BEGIN RAISE NOTICE ' 
                    || '''' 
                    || 'CALLING ' 
                    || routines.routine_type 
                    || ' :: ' 
                    || routines.specific_schema 
                    || '.' 
                    || routines.routine_name 
                    || '''' 
                    || '; END$$ ;' || e'\n'
                    || 
          CASE 
                    WHEN routines.routine_type = 'PROCEDURE' THEN  e'\n' || 'CALL ' 
                    WHEN routines.routine_type = 'FUNCTION' THEN  e'\n' ||  'SELECT ' 
          END 
                    || routines.specific_schema 
                    || '.' 
                    || routines.routine_name 
                    || '(' 
                    || string_agg( 
          CASE 
                    WHEN parameters.data_type IN ('smallint' , 
                                                  'integer' , 
                                                  'bigint' , 
                                                  'decimal' , 
                                                  'numeric' , 
                                                  'real' , 
                                                  'double precision' , 
                                                  'smallserial' , 
                                                  'serial' , 
                                                  'bigserial') THEN '1' 
                                        || '::' 
                                        || parameters.data_type 
                    WHEN parameters.data_type IN ( 'decimal' , 
                                                  'numeric' , 
                                                  'real' , 
                                                  'double precision' 
                                                  ) THEN '99.99' 
                                        || '::' 
                                        || parameters.data_type 
                    WHEN parameters.data_type IN ('money') THEN '99.07' 
                                        || '::' 
                                        || parameters.data_type 
                    WHEN parameters.data_type IN ('character' , 
                                                  'character varying' , 
                                                  'varchar' , 
                                                  'char' , 
                                                  'text') THEN '''' 
                                        || 1 
                                        || '''' 
                                        || '::' 
                                        || parameters.data_type 
                    WHEN parameters.data_type IN ('bytea') THEN 'E' 
                                        || '''' 
                                        || '\\000' 
                                        || '''' 
                                        || '::bytea' 
                    WHEN parameters.data_type IN ('date' , 
                                                  'time with time zone' , 
                                                  'time without time zone' , 
                                                  'timestamp with time zone', 
                                                  'timestamp without time zone') THEN '''' 
                                        || 'now' 
                                        || '''' 
                                        || '::' 
                                        || parameters.data_type 
                    WHEN parameters.data_type IN ('boolean') THEN 'true::boolean' 
                    WHEN parameters.data_type IN ('UUID') THEN 'uuid_generate_v4()' 
                    ELSE ' ' 
          END , ',' ORDER BY parameters.ordinal_position) 
                    || ');' || e'\n'
                    || 'ROLLBACK;' || e'\n'
                    || 'DO $$ BEGIN RAISE NOTICE ' 
                    || '''' 
                    || 'Code Sanity Completed -  ' 
                    || routines.routine_type 
                    || ' :: ' 
                    || routines.specific_schema 
                    || '.' 
                    || routines.routine_name 
                    || '''' 
                    || '; END$$ ;' || e'\n'
                     AS "sql_command" 
FROM      information_schema.routines 
left join information_schema.parameters 
ON        routines.specific_name=parameters.specific_name 
AND       parameters.parameter_mode NOT IN ('OUT') 
WHERE     routines.specific_schema='public'
AND       routines.routine_type IN ('PROCEDURE' , 
                                    'FUNCTION') 
AND       ( 
                    routines.data_type NOT IN ('trigger' , 
                                               'event_trigger') 
          OR        routines.data_type IS NULL) 
GROUP BY  routines.routine_name , 
          routines.routine_type , 
          routines.specific_schema 
ORDER BY  routines.routine_name;
