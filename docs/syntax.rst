Syntax
======

Defining a test
---------------

An IgorUnit test is an Igor function that returns nothing and has no
parameters::

  Function test_<TEST_NAME>()
      // test body
  End

where <TEST_NAME> is an arbitrary string (following the rules for Igor
function names).

If you want your tests to be autodiscovered, your test function names
must start with "test_". If a function name does not start with
"test_", the function can still be included in test suites manually.

Writing the test body
---------------------

Test success/failure is determined by calling one or more assertion
functions that describe expectations for the code under test. A test
without any assertions succeeds by default.

This example test ensures that the *strlen* function works as documented::

  Function test_strlenOnNullIsNaN()
      String str_foo
      EXPECT_EQ(NaN, strlen(str_foo))       // strlen should return NaN for a NULL string
  End

Tests are best kept small and focused on a single aspect of functionality.
