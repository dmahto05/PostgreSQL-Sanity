SELECT 'BEGIN; ' || CASE WHEN routines.routine_type = 'PROCEDURE' 
             THEN 'CALL ' 
			 WHEN routines.routine_type = 'FUNCTION' 
			 THEN 'SELECT ' END || routines.specific_schema || '.' ||
           routines.routine_name || '(' || STRING_AGG(CASE 
        WHEN parameters.data_type  IN ('smallint' , 'integer' , 'bigint' , 'decimal' , 'numeric' , 'real' , 'double precision' , 'smallserial' , 'serial' , 'bigserial') 
		               THEN '1' || '::' || parameters.data_type 
		WHEN parameters.data_type  IN ('money') 
		               THEN '99.07' || '::' || parameters.data_type 
		WHEN parameters.data_type  IN ('character' , 'character varying' , 'varchar' , 'char' , 'text')
		               THEN  '''' || 1 || '''' || '::' || parameters.data_type   
		WHEN parameters.data_type  IN ('bytea')
					   THEN 'E' || ''''||  '\\000' || '''' || '::bytea'
        WHEN parameters.data_type  IN ('date' , 'time with time zone' , 'time without time zone' , 'timestamp with time zone','timestamp without time zone') 
		   			   THEN '''' || 'now' || '''' || '::' || parameters.data_type 
		WHEN parameters.data_type  in ('boolean') 
					   THEN 'true::boolean'
		WHEN parameters.data_type in ('UUID')
		               THEN 'uuid_generate_v4 ()'
		ELSE ' '
		END , ',' ORDER BY parameters.ordinal_position)  || ');' || 'ROLLBACK;'as "sql_command"
FROM information_schema.routines
    LEFT JOIN information_schema.parameters ON routines.specific_name=parameters.specific_name
WHERE routines.specific_schema=<<SCHEMA_NAME>>
AND routines.routine_type IN ('PROCEDURE' , 'FUNCTION') 
AND (routines.data_type NOT IN ('trigger') OR routines.data_type IS NULL)
GROUP BY routines.routine_name , routines.routine_type , routines.specific_schema
ORDER BY routines.routine_name;
