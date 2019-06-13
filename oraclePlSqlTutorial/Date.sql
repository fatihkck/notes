DECLARE
  L_TODAY_DATE      DATE := SYSDATE;
  L_TODAY_TIMESTAMP TIMESTAMP := SYSTIMESTAMP;
  L_TODAY_TIMETZONE TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  L_INTERVAL1       INTERVAL YEAR(4) TO MONTH := '2011-11';
  L_INTERVAL2       INTERVAL DAY(2) TO SECOND := '15 00:30:44';
BEGIN
  NULL;
END;

/

BEGIN
  DBMS_OUTPUT.put_line (SYSDATE);
  DBMS_OUTPUT.put_line (SYSTIMESTAMP);
  DBMS_OUTPUT.put_line (SYSDATE - SYSTIMESTAMP);
END;

/
--Converting dates to strings and strings to dates
BEGIN
   DBMS_OUTPUT.put_line (
     TO_CHAR (SYSDATE));
   DBMS_OUTPUT.put_line (
     TO_CHAR (SYSTIMESTAMP));
END;

/
BEGIN
   DBMS_OUTPUT.put_line (
TO_CHAR (SYSDATE, 
'Day, DDth Month YYYY'));
END;
/
BEGIN
  DBMS_OUTPUT.put_line (
    TO_CHAR (SYSDATE, 
'Day, DDth Month YYYY', 
'NLS_DATE_LANGUAGE=Spanish'));
END;
/
BEGIN
  DBMS_OUTPUT.put_line (
     TO_CHAR (SYSDATE, 
'FMDay, DDth Month YYYY'));
END;
/
BEGIN
  DBMS_OUTPUT.put_line (
    TO_CHAR (SYSDATE, 
'YYYY-MM-DD HH24:MI:SS'));
END;

/

SELECT EXTRACT (YEAR FROM SYSDATE) FROM DUAL;
SELECT EXTRACT (DAY FROM SYSDATE) FROM DUAL;
SELECT EXTRACT (MONTH FROM SYSDATE) FROM DUAL;

/

DECLARE
  l_date   DATE;
BEGIN
  l_date := TO_DATE ('12-JAN-2011');
  DBMS_OUTPUT.put_line(l_date);
  l_date := TO_DATE ('January 12 2011', 
'Month DD YYYY');
DBMS_OUTPUT.put_line(l_date);
END	;

/

DECLARE
  l_date   DATE;
BEGIN
  
--Set l_date to today’s date, but with the time set to 00:00:00:
 l_date := TRUNC (SYSDATE);
 DBMS_OUTPUT.put_line(l_date);
 
  --Get the first day of the month for the specified date:
 l_date := TRUNC (SYSDATE, 'MM');
 DBMS_OUTPUT.put_line(l_date);
 
 --Get the first day of the quarter for the specified date
 l_date := TRUNC (SYSDATE, 'Q');
 DBMS_OUTPUT.put_line(l_date);
 
 --Get the first day of the year for the specified date:
 l_date := TRUNC (SYSDATE, 'Y');
 DBMS_OUTPUT.put_line(l_date);
 
-- Set a local variable to tomorrow’s date:
 l_date := SYSDATE + 1;
  DBMS_OUTPUT.put_line(l_date);
-- Move back one hour:
l_date := SYSDATE - 1/24;
 DBMS_OUTPUT.put_line(l_date);
--Move ahead 10 seconds:
l_date := SYSDATE + 10 / (60 * 60 * 24);
 DBMS_OUTPUT.put_line(l_date);
END	;


/
DECLARE
   l_date1   DATE := SYSDATE;
   l_date2   DATE := SYSDATE + 10;
BEGIN
   DBMS_OUTPUT.put_line (
      l_date2 - l_date1);
   DBMS_OUTPUT.put_line (
      l_date1 - l_date2);
END;

/

/*
ADD_MONTHS—adds the specified number of months to or subtracts it from a date (or a time stamp)

NEXT_DAY—returns the date of the first weekday named in the call to the function

LAST_DAY—returns the date of the last day of the month of the specified date
*/

DECLARE
   l_date   DATE;

BEGIN
  
l_date := ADD_MONTHS (SYSDATE, 1);
   DBMS_OUTPUT.put_line (
      l_date);
l_date := ADD_MONTHS (SYSDATE, -3);

   DBMS_OUTPUT.put_line (
      l_date);
      
      
   DBMS_OUTPUT.put_line (
      ADD_MONTHS (TO_DATE ('31-jan-2011', 'DD-MON-YYYY'), 1));
   DBMS_OUTPUT.put_line (
      ADD_MONTHS (TO_DATE ('27-feb-2011', 'DD-MON-YYYY'), -1));
   DBMS_OUTPUT.put_line (
      ADD_MONTHS (TO_DATE ('28-feb-2011', 'DD-MON-YYYY'), -1));
      
   l_date := NEXT_DAY (SYSDATE, 'SAT');
	-- or
	 l_date := NEXT_DAY (SYSDATE, 'SATURDAY');
  
   DBMS_OUTPUT.put_line (
      l_date);
END;
