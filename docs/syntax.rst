Syntax
======

Defining a test
---------------

An IgorUnit test has a name and must belong to a group. To define a
test, use the TEST macro::

  ${TEST("<GROUP_NAME>", "<TEST_NAME>")}
  // test body
  ${END_TEST()}

where <GROUP_NAME> and <TEST_NAME> are both strings. Each test is
uniquely defined by its group and name. That is, no two tests should
have the same group as well as the same name. If this occurs, only one
of the tests will be run.


Defining a test group
---------------------

Test groups allow the sharing of setup/teardown methods across several
unit tests. They can also be used for simple semantic organization of
tests. For example, it may often make sense to organize all tests
dealing with one module or idea into a single test group.

To define a setup and teardown routine for a group, use the TEST_SETUP
and TEST_TEARDOWN macros::

  ${TEST_SETUP("<GROUP_NAME>")}
  // setup body
  ${END_SETUP()}

  ${TEST_TEARDOWN("<GROUP_NAME>")}
  // teardown body
  ${END_TEARDOWN()}

Writing the test body
---------------------

The TEST macro makes several variables available within the test body:

 - `tr` -- reference to a TestResult instance
 - `groupname` -- the name of the test group
 - `testname` -- the name of the test
 - `funcname` -- the name of the test function
 - `msg` -- string variable for holding an error message
 - `test` -- a UnitTest structure holding information about the test

To test a condition in a unit test, the test must call one of a set of
assertion macros. Any number of assertion macros can be defined in a
test, but at least one is required for the test to be
meaningful. Using the assertion macros within the TEST environment
allows IgorUnit to automatically keep track of useful information
about the results of each test.


List of assertion macros
------------------------

The following assertion macros are available:

+-------------------------------+------------------------------------------+
|Macro                          |Description                               |
+===============================+==========================================+
|SUCCEED()                      |Unconditional test success                |
+-------------------------------+------------------------------------------+
|FAIL(message)                  |Unconditional test failure, stored with   |
|                               |`message`                                 |
+-------------------------------+------------------------------------------+
|ASSERT(condition)              |Checks that the `condition` is true       |
+-------------------------------+------------------------------------------+
|VARS_EQUAL(expected, actual)   |Checks that two numbers (variables) are   |
|                               |equal                                     |
+-------------------------------+------------------------------------------+
|STRINGS_EQUAL(expected, actual)|Checks that two strings are equal         |
+-------------------------------+------------------------------------------+
