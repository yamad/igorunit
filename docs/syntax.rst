Syntax
======

Defining a test
---------------

An IgorUnit test is an Igor function that returns nothing and has no
parameters::

  Function utest_<TEST_NAME>()
      // test body
  End

where <TEST_NAME> is an arbitrary string (following the rules for Igor
function names).

Test autodiscovery
------------------

Tests can be autodiscovered, if your test function names start with
"utest\_" (short for *unit test*). If a function name does not start
with "utest\_", the function can still be included in test suites
manually.


Writing the test body
---------------------

Test success/failure is determined by calling one or more assertion
functions that describe expectations for the code under test. A test
without any assertions succeeds by default.

For example, this test ensures that the *strlen* function works as
documented::

  Function test_strlenOnNullIsNaN()
      String str_foo
      EXPECT_EQ(NaN, strlen(str_foo))       // strlen should return NaN for a NULL string
  End

Tests are best kept small and focused on a single aspect of
functionality.
