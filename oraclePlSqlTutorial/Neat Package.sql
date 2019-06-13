/*CREATE OR REPLACE PROCEDURE process_employee (
   employee_id_in IN employees.employee_id%TYPE)
IS
   l_fullname VARCHAR2(100);
BEGIN
   SELECT last_name || ',' || first_name
     INTO l_fullname
     FROM employees
    WHERE employee_id = employee_id_in;
    
END;

-- Insted of procedure


 CREATE OR REPLACE PACKAGE employee_pkg
   AS
       SUBTYPE fullname_t IS VARCHAR2 (100);
   
       FUNCTION fullname (
          last_in  employees.last_name%TYPE,
          first_in  employees.first_name%TYPE)
          RETURN fullname_t;
   
        FUNCTION fullname (
           employee_id_in IN employees.employee_id%TYPE)
           RETURN fullname_t;
    END employee_pkg;


CREATE OR REPLACE PROCEDURE process_employee (
   employee_id_in IN employees.employee_id%TYPE)
IS
   l_name employee_pkg.fullname_t;
   employee_id_in   employees.employee_id%TYPE := 1;
BEGIN
   l_name := employee_pkg.fullname (employee_id_in);
   ...
END;*/

/


  CREATE OR REPLACE PACKAGE BODY employee_pkg
  AS
     FUNCTION fullname (
        last_in employees.last_name%TYPE,
        first_in employees.first_name%TYPE
     )
        RETURN fullname_t
     IS
     BEGIN
        RETURN last_in || ', ' || first_in;
     END;
   
     FUNCTION fullname (employee_id_in IN employee.employee_id%TYPE)
        RETURN fullname_t
     IS
        l_fullname fullname_t;
     BEGIN
        SELECT fullname (last_name, first_name) INTO l_fullname
          FROM employees
         WHERE employee_id = employee_id_in;
   
        RETURN l_fullname;
      END;
   END employee_pkg;
   
   
/

--Package-level data consists of variables and constants that are defined at the package level—that is, not within a particular function or procedure in the package. The following package specification, for example, declares one variable and one constant at the package leve
CREATE OR REPLACE PACKAGE plsql_limits
IS
   c_varchar2_length CONSTANT 
      PLS_INTEGER := 32767;
   g_start_time PLS_INTEGER;
END;   




DECLARE
   l_start   PLS_INTEGER;
BEGIN
   /* Get and save the starting time. */
   l_start := DBMS_UTILITY.get_cpu_time;

   /* Run your code. */
   FOR indx IN 1 .. 10000
   LOOP
      NULL;
   END LOOP;

   /* Subtract starting time from current time. */
   DBMS_OUTPUT.put_line (
      DBMS_UTILITY.get_cpu_time - l_start);
END;
/


CREATE OR REPLACE PACKAGE timer_pkg
IS
   PROCEDURE start_timer;

   PROCEDURE show_elapsed (message_in IN VARCHAR2 := NULL);
END timer_pkg;
/

CREATE OR REPLACE PACKAGE BODY timer_pkg
IS
   g_start_time   NUMBER := NULL;

   PROCEDURE start_timer
   IS
   BEGIN
      g_start_time := DBMS_UTILITY.get_cpu_time;
   END;
   
   
   PROCEDURE show_elapsed (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            message_in
         || ': '
         || TO_CHAR (DBMS_UTILITY.get_cpu_time - g_start_time));

      start_timer;
   END;
END timer_pkg;
/

BEGIN
   timer_pkg.start_timer;
   FOR indx IN 1 .. 10000
   LOOP
      NULL;
   END LOOP;
   timer_pkg.show_elapsed ('10000 Nothings');
END;

--Subprogram Overloading
CREATE OR REPLACE PACKAGE my_output
IS
   PROCEDURE put_line (value_in IN VARCHAR2);

   PROCEDURE put_line (value_in IN BOOLEAN);

   PROCEDURE put_line (
      value_in   IN DATE,
      mask_in    IN VARCHAR2 DEFAULT 'YYYY-MM-DD HH24:MI:SS');
END my_output;
