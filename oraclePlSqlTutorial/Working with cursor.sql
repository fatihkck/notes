
--SELECT-INTO offers the fastest and simplest way to fetch a single row from a SELECT statement
--If the SELECT statement identifies more than one row to be fetched, Oracle Database will raise the TOO_MANY_ROWS exception.
-- If the statement doesn’t identify any rows to be fetched, Oracle Database will raise the NO_DATA_FOUND exception

--ORA-00947: not enough values  The INTO list contains fewer variables than the SELECT list.
--ORA-00913: too many values	The INTO list contains more variables than the SELECT list.
--ORA-06502: PL/SQL: numeric or value error	The number of variables in the INTO and SELECT lists matches, but the datatypes do not match and Oracle Database was unable to convert implicitly from one type to the other.


-- A SELECT-INTO is also referred to as an implicit query, because Oracle Database implicitly opens a cursor for the SELECT statement, fetches the row, and then closes the cursor when it finishes doing that (or when an exception is raised).

SELECT select_list INTO variable_list FROM remainder_of_query;
/
DECLARE
  l_last_name  employees.last_name%TYPE;
BEGIN
  SELECT last_name
    INTO l_last_name
    FROM employees
   WHERE employee_id = 138;
  DBMS_OUTPUT.put_line (
     l_last_name);
END;

/
--Fetch an entire row from the employees table for a specific employee ID:

DECLARE
   l_employee   employees%ROWTYPE;
BEGIN
   SELECT *
     INTO l_employee
     FROM employees
    WHERE employee_id = 138;
   DBMS_OUTPUT.put_line (
      l_employee.last_name);
END;

/
--Fetch columns from different tables:

DECLARE
  l_last_name         
     employees.last_name%TYPE;
  l_department_name   
     departments.department_name%TYPE;
BEGIN
  SELECT last_name, department_name
    INTO l_last_name, l_department_name
    FROM employees e, departments d
   WHERE e.department_id=d.department_id
         AND e.employee_id=138;
  DBMS_OUTPUT.put_line (
     l_last_name || 
     ' in ' || 
     l_department_name);
END;

/

-- If the query does not identify any rows, Oracle Database will not raise NO_DATA_FOUND. Instead, the cursor_name%NOTFOUND attribute will return TRUE.
-- Your query can return more than one row, and Oracle Database will not raise TOO_MANY_ROWS.
-- When you declare a cursor in a package (that is, not inside a subprogram of the package) and the cursor is opened, it will stay open until you explicitly close it or your session is terminated.
 DECLARE
     l_total       INTEGER := 10000;

     CURSOR employee_id_cur
     IS
          SELECT employee_id
            FROM plch_employees
        ORDER BY salary ASC;

     l_employee_id   employee_id_cur%ROWTYPE;
  BEGIN
     OPEN employee_id_cur;

     LOOP
        FETCH employee_id_cur INTO l_employee_id;
        EXIT WHEN employee_id_cur%NOTFOUND;

        assign_bonus (l_employee_id, l_total);
        EXIT WHEN l_total <= 0;
     END LOOP;

     CLOSE employees_cur;
  END;


/

BEGIN
   FOR employee_rec IN (
        SELECT *
          FROM employees
         WHERE department_id = 10)
   LOOP
      DBMS_OUTPUT.put_line (
         employee_rec.last_name);
   END LOOP;
END;
/
--You can also use a cursor FOR loop with an explicitly declared cursor
DECLARE
   CURSOR employees_in_10_cur
   IS
      SELECT *
        FROM employees
       WHERE department_id = 10;
BEGIN
   FOR employee_rec 
   IN employees_in_10_cur
   LOOP
      DBMS_OUTPUT.put_line (
         employee_rec.last_name);
   END LOOP;
END;


--Dynamic Queries with EXECUTE IMMEDIATE

CREATE OR REPLACE FUNCTION 
single_number_value (
   table_in    IN VARCHAR2,
   column_in   IN VARCHAR2,
   where_in    IN VARCHAR2)
   RETURN NUMBER
IS
   l_return   NUMBER;
BEGIN
   EXECUTE IMMEDIATE
         'SELECT '
      || column_in
      || ' FROM '
      || table_in
      || ' WHERE '
      || where_in
      INTO l_return;
   RETURN l_return;
END;

/

BEGIN
   DBMS_OUTPUT.put_line (
      single_number_value (
                'employees',
                'salary',
                'employee_id=138'));
END;

