CREATE GLOBAL TEMPORARY TABLE my_temp_table2 (
  id           NUMBER,
  description  VARCHAR2(20)
)
ON COMMIT DELETE ROWS;

-- Insert, but don't commit, then check contents of GTT.
INSERT INTO my_temp_table2 VALUES (1, 'ONE');
commit;
SELECT COUNT(*) FROM my_temp_table2;


/

cREATE GLOBAL TEMPORARY TABLE my_temp_table3 (
  id           NUMBER,
  description  VARCHAR2(20)
)
ON COMMIT PRESERVE ROWS;

-- Insert and commit, then check contents of GTT.
INSERT INTO my_temp_table3 VALUES (1, 'ONE');
COMMIT;

--Reconnect and check contents
SELECT COUNT(*) FROM my_temp_table3;



/DROP TABLE my_temp_table PURGE;

-- Create conventional table.
CREATE TABLE my_temp_table (
  id           NUMBER,
  description  VARCHAR2(20)
);

-- Populate table.
INSERT INTO my_temp_table
WITH data_table AS (
  SELECT 1 AS id
  FROM   dual
  CONNECT BY level < 10000
)
SELECT rownum, TO_CHAR(rownum)
FROM   data_table a, data_table b
WHERE  rownum <= 100;

-- Check undo used by transaction.
SELECT t.used_ublk,
       t.used_urec
FROM   v$transaction t,
       v$session s
WHERE  s.saddr = t.ses_addr
AND    s.audsid = SYS_CONTEXT('USERENV', 'SESSIONID');


