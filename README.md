# PostgreSQL-Sanity
PostgreSQL Sanity Script 

One of the key difference, we need to consider while migrating Oracle to PostgreSQL is compilation of Procedural code.
Its behaviour with regards to Exceptions during compile time and execution time varies between both the databases.

PostgreSQL has its own behaviour while creating Function or Procedures and tends to don't give most of semantics exceptions unlike Oracle during code compilation or creations.

Lets Understand with Examples,

CREATE OR REPLACE FUNCTION TEST_FUNC
RETURN INT
AS
INPUTVAR INT;
BEGIN
SELECT COL1 INTO INPUTVAR FROM DUAL;

RETURN INPUTVAR;
END;

When we try to create above function in Oracle, it is bound to give exceptions.

Errors: FUNCTION TEST_FUNC
Line/Col: 6/1 PL/SQL: SQL Statement ignored
Line/Col: 6/8 PL/SQL: ORA-00904: "COL1": invalid identifier

