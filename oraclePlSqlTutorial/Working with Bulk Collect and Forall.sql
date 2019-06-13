/*Context Switches and Performance
Almost every program PL/SQL developers write includes both PL/SQL and SQL statements. PL/SQL statements are run by the PL/SQL statement executor; SQL statements are run by the SQL statement executor. When the PL/SQL runtime engine encounters a SQL statement, it stops and passes the SQL statement over to the SQL engine. The SQL engine executes the SQL statement and returns information back to the PL/SQL engine (see Figure 1). This transfer of control is called a context switch, and each one of these switches incurs overhead that slows down the overall performance of your programs.*/



CREATE OR REPLACE PROCEDURE INCREASE_SALARY
(
  DEPARTMENT_ID_IN IN EMPLOYEES.DEPARTMENT_ID%TYPE,
  INCREASE_PCT_IN  IN NUMBER
) IS
BEGIN
  FOR EMPLOYEE_REC IN (SELECT EMPLOYEE_ID
                         FROM EMPLOYEES
                        WHERE DEPARTMENT_ID =
                              INCREASE_SALARY.DEPARTMENT_ID_IN)
  LOOP
    UPDATE EMPLOYEES EMP
       SET EMP.SALARY = EMP.SALARY +
                        EMP.SALARY * INCREASE_SALARY.INCREASE_PCT_IN
     WHERE EMP.EMPLOYEE_ID = EMPLOYEE_REC.EMPLOYEE_ID;
  END LOOP;
END INCREASE_SALARY;

/

CREATE OR REPLACE PROCEDURE TEST_PROC IS
TYPE TOBJECTTABLE IS
TABLE OF ALL_OBJECTS%ROWTYPE; OBJECTTABLE$ TOBJECTTABLE;

BEGIN
SELECT * BULK COLLECT INTO OBJECTTABLE$ FROM ALL_OBJECTS;

  --FORALL X IN OBJECTTABLE$.FIRST .. OBJECTTABLE$.LAST
  --INSERT INTO T1 VALUES OBJECTTABLE$ (X);

END TEST_PROC;

/
