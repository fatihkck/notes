

CREATE OR REPLACE PROCEDURE PROCESS_EMPLOYEE(P_EMPLOYEE_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE) IS
  V_EMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
  V_LAST_NAME   EMPLOYEES.LAST_NAME%TYPE;
  V_SALARY      EMPLOYEES.SALARY%TYPE;
BEGIN
  SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.SALARY
    INTO V_EMPLOYEE_ID, V_LAST_NAME, V_SALARY
    FROM EMPLOYEES E
   WHERE EMPLOYEE_ID = P_EMPLOYEE_ID;
  DBMS_OUTPUT.PUT_LINE(V_EMPLOYEE_ID);
END PROCESS_EMPLOYEE;

/

BEGIN
PROCESS_EMPLOYEE(100);
END;

/

CREATE OR REPLACE PROCEDURE PROCESS_EMPLOYEE_V1(P_EMPLOYEE_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE) IS
V_EMPLOYEE EMPLOYEES%ROWTYPE;
BEGIN
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.SALARY INTO V_EMPLOYEE.EMPLOYEE_ID, V_EMPLOYEE.LAST_NAME, V_EMPLOYEE.SALARY FROM EMPLOYEES E WHERE EMPLOYEE_ID = P_EMPLOYEE_ID; DBMS_OUTPUT.PUT_LINE(V_EMPLOYEE.EMPLOYEE_ID);
END PROCESS_EMPLOYEE_V1;

/

BEGIN
PROCESS_EMPLOYEE_V1(100);
END;

/
CREATE OR REPLACE PROCEDURE PROCESS_EMPLOYEE_V2(P_EMPLOYEE_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE) IS
V_EMPLOYEE EMPLOYEES%ROWTYPE;
BEGIN
SELECT E.* INTO V_EMPLOYEE FROM EMPLOYEES E WHERE EMPLOYEE_ID = P_EMPLOYEE_ID; DBMS_OUTPUT.PUT_LINE(V_EMPLOYEE.LAST_NAME);
END PROCESS_EMPLOYEE_V2;

/

BEGIN
PROCESS_EMPLOYEE_V2(101);
END;

/

DECLARE CURSOR NO_IDS_CUR IS
SELECT LAST_NAME, SALARY FROM EMPLOYEES;

V_EMPLOYEE NO_IDS_CUR%ROWTYPE;
BEGIN
OPEN NO_IDS_CUR; FETCH NO_IDS_CUR INTO V_EMPLOYEE; CLOSE NO_IDS_CUR;
END;

/

DECLARE V_EMPLOYEE EMPLOYEES%ROWTYPE;
BEGIN
EXECUTE IMMEDIATE 'SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID=100' INTO V_EMPLOYEE;
END;

/
BEGIN
FOR EMPLOYEE_REC IN (SELECT LAST_NAME, SALARY FROM EMPLOYEES) LOOP DBMS_OUTPUT.PUT_LINE(EMPLOYEE_REC.LAST_NAME || ' ' || EMPLOYEE_REC.SALARY);
END LOOP;
END;

/

  /*DECLARE
     V_employee_id   EMPLOYEES.employee_id%TYPE
        := 500;
     V_last_name     EMPLOYEES.last_name%TYPE
        := 'Mondrian';
     V_salary        EMPLOYEES.salary%TYPE
        := 2000;
  BEGIN
     INSERT
       INTO EMPLOYEES (employee_id,
                            last_name,
                            salary)
     VALUES (
               V_employee_id,
               V_last_name,
               V_salary);
  END; */

/

  /*DECLARE
    V_employee  EMPLOYEES%ROWTYPE;
  BEGIN
  
    V_employee.employee_id := 500;
     V_employee.last_name := ‘Mondrian’;
     V_employee.salary := 2000;  
  
  
     INSERT
       INTO EMPLOYEES (employee_id,
                            last_name,
                            salary)
     VALUES (
               V_employee.employee_id,
               V_employee.last_name,
               V_employee.salary);
  END; */


/

/*DECLARE
   l_name1           VARCHAR2 (100);
   l_total_sales1    NUMBER;
   l_deliver_pref1   VARCHAR2 (10);
   --
   l_name2           VARCHAR2 (100);
   l_total_sales2    NUMBER;
   l_deliver_pref2   VARCHAR2 (10);
   
   -- INSTED 
   -- create your own record type and then declare two records
   
   TYPE customer_info_rt IS RECORD
   (
      name           VARCHAR2 (100),
      total_sales    NUMBER,
      deliver_pref   VARCHAR2 (10)
   );

   l_customer1   customer_info_rt;
   l_customer2   customer_info_rt;*/
   
   
   /
