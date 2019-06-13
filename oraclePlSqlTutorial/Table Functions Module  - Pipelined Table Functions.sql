/*
  HOW TO USE PIPELINED TABLE FUNCTION : 
  ADD PIPELINED KEYWORD TO HEADER
  USE PIPE ROW STATEMENT INSTEAD OF POPULATING LOCAL COLLECTION
  RETURN NOTHING BUT CONTROL TO THE CALLING QUERY
  REDUCE PGA MEMORY CONSUMPTION, IMPROVE PERFORMANCE.
*/

DROP TYPE ticker_ot FORCE;
DROP TYPE tickers_nt FORCE;
DROP TYPE stock_ot FORCE;
DROP TYPE stocks_nt FORCE;
DROP TABLE stocks;
DROP TABLE tickers;

CREATE TABLE stocks
(
   ticker        VARCHAR2 (20),
   trade_date    DATE,
   open_price    NUMBER,
   close_price   NUMBER
)
/

/* Load up 10000 rows - when running in your own database, you might want to
   use a higher volume of data here, to see a more dramatic difference in the
   elapsed time and memory utilization 
*/

INSERT INTO stocks
       SELECT 'STK' || LEVEL,
              SYSDATE,
              LEVEL,
              LEVEL + 15
         FROM DUAL
   CONNECT BY LEVEL <= 10000
/   

CREATE TABLE tickers
(
   ticker      VARCHAR2 (20),
   pricedate   DATE,
   pricetype   VARCHAR2 (1),
   price       NUMBER
)
/

CREATE TYPE ticker_ot AS OBJECT
(
   ticker VARCHAR2 (20),
   pricedate DATE,
   pricetype VARCHAR2 (1),
   price NUMBER
);
/

CREATE TYPE tickers_nt AS TABLE OF ticker_ot;
/

CREATE OR REPLACE PACKAGE stock_mgr
   AUTHID DEFINER
IS
   TYPE stocks_rc IS REF CURSOR RETURN stocks%ROWTYPE;
END stock_mgr;
/

CREATE OR REPLACE FUNCTION doubled_nopl (rows_in stock_mgr.stocks_rc)
   RETURN tickers_nt
   AUTHID DEFINER
IS
   TYPE stocks_aat IS TABLE OF stocks%ROWTYPE INDEX BY PLS_INTEGER;
   l_stocks    stocks_aat;

   l_doubled   tickers_nt := tickers_nt ();
BEGIN
   LOOP
      FETCH rows_in BULK COLLECT INTO l_stocks LIMIT 100;
      EXIT WHEN l_stocks.COUNT = 0;

      FOR l_row IN 1 .. l_stocks.COUNT
      LOOP
         l_doubled.EXTEND;
         l_doubled (l_doubled.LAST) :=
            ticker_ot (l_stocks (l_row).ticker,
                       l_stocks (l_row).trade_date,
                       'O',
                       l_stocks (l_row).open_price);

         l_doubled.EXTEND;
         l_doubled (l_doubled.LAST) :=
            ticker_ot (l_stocks (l_row).ticker,
                       l_stocks (l_row).trade_date,
                       'C',
                       l_stocks (l_row).close_price);
      END LOOP;
   END LOOP;

   RETURN l_doubled;
END;
/

CREATE OR REPLACE FUNCTION doubled_pl (rows_in stock_mgr.stocks_rc)
   RETURN tickers_nt
   PIPELINED
   AUTHID DEFINER
IS
   TYPE stocks_aat IS TABLE OF stocks%ROWTYPE INDEX BY PLS_INTEGER;
   l_stocks   stocks_aat;
BEGIN
   LOOP
      FETCH rows_in BULK COLLECT INTO l_stocks LIMIT 100;
      EXIT WHEN l_stocks.COUNT = 0;

      FOR l_row IN 1 .. l_stocks.COUNT
      LOOP
         PIPE ROW (ticker_ot (l_stocks (l_row).ticker,
                              l_stocks (l_row).trade_date,
                              'O',
                              l_stocks (l_row).open_price));

         PIPE ROW (ticker_ot (l_stocks (l_row).ticker,
                              l_stocks (l_row).trade_date,
                              'C',
                              l_stocks (l_row).close_price));
      END LOOP;
   END LOOP;

   RETURN;
END;


/

SELECT COUNT(*) FROM tickers
/

INSERT INTO tickers
   SELECT * 
     FROM TABLE (doubled_pl (CURSOR (SELECT * FROM stocks)))
/

SELECT * FROM tickers
 WHERE ROWNUM < 20
/

CREATE OR REPLACE PACKAGE utils
IS
   PROCEDURE initialize (context_in IN VARCHAR2);

   PROCEDURE show_results (message_in IN VARCHAR2 := NULL);
END;
/

CREATE OR REPLACE PACKAGE BODY utils
IS
   last_timing   INTEGER := NULL;
   last_pga   INTEGER := NULL;

   FUNCTION pga_consumed
      RETURN NUMBER
   AS
      l_pga   NUMBER;
   BEGIN
      SELECT st.VALUE
        INTO l_pga
        FROM v$mystat st, v$statname sn
       WHERE st.statistic# = sn.statistic# AND sn.name = 'session pga memory';

      RETURN l_pga;
   END;

   PROCEDURE initialize (context_in IN VARCHAR2)
   IS
   BEGIN
      DELETE FROM tickers;
      COMMIT;
      DBMS_OUTPUT.put_line (context_in);
      last_timing := DBMS_UTILITY.get_time;
      last_pga := pga_consumed;
   END;

   PROCEDURE show_results (message_in IN VARCHAR2 := NULL)
   IS
      l_count   INTEGER;
   BEGIN
      SELECT COUNT (*) INTO l_count FROM tickers;

      DBMS_OUTPUT.put_line ('Ticker row count: ' || l_count);

      DBMS_OUTPUT.put_line (
         '"' || message_in || '" completed in: ' || 
         TO_CHAR (DBMS_UTILITY.get_time - last_timing)||' centisecs; pga at: '||
         TO_CHAR (pga_consumed() - last_pga) || ' bytes');
   END;
END;
/
BEGIN
   utils.initialize ('Pipelined');

   INSERT INTO tickers
      SELECT *
        FROM TABLE (doubled_pl (CURSOR (SELECT * FROM stocks)))
       WHERE ROWNUM < 10;

   utils.show_results ('First 9 rows');

   utils.initialize ('Not Pipelined');

   INSERT INTO tickers
      SELECT *
        FROM TABLE (doubled_nopl (CURSOR (SELECT * FROM stocks)))
       WHERE ROWNUM < 10;

   utils.show_results ('First 9 rows');
END;
/


CREATE OR REPLACE TYPE strings_t IS TABLE OF VARCHAR2 (100);
/

CREATE OR REPLACE FUNCTION strings
   RETURN strings_t
   PIPELINED
   AUTHID DEFINER
IS
BEGIN
   PIPE ROW (1);
   PIPE ROW (2);
   RETURN;
END;
/

SELECT COLUMN_VALUE my_string
  FROM TABLE (strings ())
 WHERE ROWNUM < 2
/
Now I add an OTHERS exception handler and nothing else.


CREATE OR REPLACE FUNCTION strings
   RETURN strings_t
   PIPELINED
   AUTHID DEFINER
IS
BEGIN
   PIPE ROW (1);
   PIPE ROW (2);
   RETURN;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Error: ' || SQLERRM);
      RAISE;
END;
/

SELECT COLUMN_VALUE my_string
  FROM TABLE (strings ())
 WHERE ROWNUM < 2
/

BEGIN
   DBMS_OUTPUT.put_line ('Flush output cache!');
END;
/


REATE OR REPLACE FUNCTION strings
   RETURN strings_t
   PIPELINED
   AUTHID DEFINER
IS
BEGIN
   PIPE ROW (1);
   PIPE ROW (2);
   RETURN;
EXCEPTION
   WHEN no_data_needed
   THEN
      RAISE;
   WHEN OTHERS
   THEN
      /* Clean up code here! */
      RAISE;
END;
/

SELECT COLUMN_VALUE my_string
  FROM TABLE (strings ())
 WHERE ROWNUM < 2
/