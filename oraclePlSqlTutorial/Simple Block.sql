DECLARE
  L_MESSAGE VARCHAR2(100) := 'Hello World!';
BEGIN
  DBMS_OUTPUT.PUT_LINE(L_MESSAGE);
END;

/

DECLARE L_MESSAGE VARCHAR2(100) := 'Hello World!';
BEGIN
  DBMS_OUTPUT.PUT_LINE(L_MESSAGE);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
