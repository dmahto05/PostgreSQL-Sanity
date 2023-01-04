One of the key difference, we need to consider while migrating Oracle to PostgreSQL is compilation of Procedural code.
Its behavior with regards to Exceptions during compile time varies between both the databases.

PostgreSQL has its own behavior while creating Function or Procedures and tends to don't give most of semantics exceptions unlike Oracle during code compilation or creations as all code is wrapped within as String.

Whenever we are migrating code as part of Procedural logic, we need to check Function sanity with a Run. Only Conversion is half way done, actual definition of done is running the code and perform functional checks. 

Though we might not have functional test cases as part of conversion, we can still perform high level sanity by mocking procedural code calls.
To ease Creation of Function Call, had developed below SQL to output PROCEDURE or FUNCTION calls.

Check out Blog for more details
https://databaserookies.wordpress.com/2019/10/03/1265/
