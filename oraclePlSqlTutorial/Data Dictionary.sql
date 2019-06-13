SELECT * FROM USER_ARGUMENTS;

SELECT * FROM USER_DEPENDENCIES;

SELECT * FROM USER_ERRORS;

SELECT * FROM USER_IDENTIFIERS;

SELECT * FROM USER_OBJECT_SIZE;

SELECT * FROM USER_OBJECTS;

SELECT * FROM USER_PLSQL_OBJECT_SETTINGS;

SELECT * FROM USER_PROCEDURES;

SELECT * FROM USER_SOURCE;

SELECT * FROM USER_STORED_SETTINGS;

SELECT * FROM USER_TRIGGERS;

SELECT * FROM USER_TRIGGER_COLS;


--The following query returns all the objects defined in my schema:

SELECT * FROM user_objects;
SELECT * FROM all_objects;

--Show the names of all tables in my schema
SELECT object_name,UO.*
  FROM user_objects UO
 WHERE UO.object_type = 'TABLE'
 ORDER BY UO.object_name;
 
 
---Show the names of all objects whose status is invalid:

SELECT object_type, object_name
  FROM user_objects
 WHERE status = 'INVALID'
 ORDER BY object_type, object_name;
 
 
--Show all objects that have been changed today:

SELECT object_type, object_name, 
       last_ddl_time
  FROM user_objects
 WHERE last_ddl_time >= TRUNC (SYSDATE)
 ORDER BY object_type, object_name;
 
 --where this procedure is called
 SELECT name, line, text
  FROM user_source
 WHERE UPPER (text) 
  LIKE '%SALES_MGR.CALC_TOTALS%'
 ORDER BY name, line;
 
 --Find all the program units that are not taking sufficient advantage of compile time optimization in Oracle Database
 --An optimization level of 0 means no optimization at all. An optimization level of 1 means a minimal amount of optimization. Neither of these levels should be seen in a production environment.
 SELECT *
  FROM user_plsql_object_settings
 WHERE plsql_optimize_level < 2;
 
 --Identify all programs for which compile time warnings (which provide feedback on the quality of your code) are disabled
 SELECT name, plsql_warnings
  FROM user_plsql_object_settings
 WHERE plsql_warnings LIKE '%DISABLE%';
 
 
 ---Find all the procedures and functions that will run under invoker rights (the privileges of the invoker of the program are used at runtime to resolve references to database objects such as tables):
 SELECT   object_name
       , procedure_name 
    FROM user_procedures
   WHERE authid = 'CURRENT_USER'
ORDER BY object_name, procedure_name;

--Show all the functions declared to be deterministic:
SELECT   object_name
       , procedure_name 
    FROM user_procedures
   WHERE deterministic = 'YES'
ORDER BY object_name, procedure_name;

--Find all disabled triggers

SELECT *
  FROM user_triggers 
 WHERE status = 'DISABLED';
 
-- Find all row-level triggers defined on the EMPLOYEES table:

SELECT *
  FROM user_triggers 
 WHERE table_name = 'EMPLOYEES'
   AND trigger_type LIKE '%EACH ROW';
   
--Find all triggers that fire when an UPDATE operation is performed:

SELECT *
  FROM user_triggers 
 WHERE triggering_event LIKE '%UPDATE%';
 
 SET SERVEROUTPUT ON;
 --The following query, unfortunately, fails and produces an ORA-00932 error
BEGIN
  FOR rec IN (SELECT * 
              FROM user_triggers)
  LOOP
    IF rec.trigger_body LIKE '%emp%'
    THEN
      DBMS_OUTPUT.put_line (
        'Found in ' || rec.trigger_name);
    END IF;
  END LOOP;
END;

/

--Find all the objects that depend on (reference) the EMPLOYEES table:

SELECT type, name 
   FROM user_dependencies
  WHERE  referenced_name = 'EMPLOYEES'
ORDER BY type, name;

--Find all the objects in the current schema on which the ORDER_MGR package depends:

SELECT referenced_type
     , referenced_name 
    FROM user_dependencies
   WHERE name = 'ORDER_MGR'
     AND referenced_owner = USER
ORDER BY referenced_type, 
         referenced_name;
         

SELECT name,
       TYPE,
       referenced_owner,
       referenced_name
  FROM user_dependencies
 WHERE     TYPE IN
              ('PACKAGE',
               'PACKAGE BODY',
               'PROCEDURE',
               'FUNCTION',
               'TRIGGER',
               'TYPE')
   AND referenced_type = 'TABLE'
   AND name NOT LIKE '%\_API' ESCAPE '\'
ORDER BY name
       , referenced_owner
       , referenced_name;
       
--Find all programs that have an argument of type LONG. This is the datatype that was used to store large strings (more than 4,000 characters) in past versions of Oracle Database. Now the database uses large object types such as character large object (CLOB). Oracle recommends that any usages of LONG be converted to CLOB. USER_ARGUMENTS makes it easy to find all such usages in parameter lists:

SELECT object_name
     , package_name
     , argument_name,data_type
  FROM user_arguments
 WHERE data_type = 'LONG';
 
 --Find all functions that have an OUT or an IN OUT argument. A recommendation you will hear from many programming experts is that functions should contain only IN arguments. A function with an OUT or an IN OUT argument cannot be called inside a SQL statement, and it cannot be used in a function-based index. If you need to return multiple pieces of information, use a procedure or return a record. Listing 1 demonstrates a query that will identify all functions defined in packages that violate this best practice.
 
  SELECT ua.object_name,
        ua.package_name,
        ua.argument_name,
        ua.in_out
   FROM (SELECT *
           FROM user_arguments
          WHERE position = 0) funcs,
        user_arguments ua
  WHERE     ua.in_out IN ('OUT', 'IN OUT')
        AND ua.position > 0
        AND ua.data_level = 0
        AND funcs.object_name = ua.object_name
        AND funcs.package_name = ua.package_name
        AND (   funcs.overload = ua.overload
             OR (funcs.overload IS NULL
                  AND ua.overload IS NULL));
                  
                  
WITH subprograms_with_exception
        AS (SELECT DISTINCT owner
                          , object_name
                          , object_type
                          , name
              FROM all_identifiers has_exc
             WHERE     has_exc.owner = USER
                   AND has_exc.usage = 'DECLARATION'
                   AND has_exc.TYPE = 'EXCEPTION'),
     subprograms_with_raise_handle
        AS (SELECT DISTINCT owner
                          , object_name
                          , object_type
                          , name
              FROM all_identifiers with_rh
             WHERE     with_rh.owner = USER
                   AND with_rh.usage = 'REFERENCE'
                   AND with_rh.TYPE = 'EXCEPTION')
SELECT *
  FROM subprograms_with_exception
MINUS
SELECT *
  FROM subprograms_with_raise_handle;                  