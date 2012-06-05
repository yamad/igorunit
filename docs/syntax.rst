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

Writing the test body
---------------------

Test success/failure is determined by calling one or more assertion
functions that describe expectations for the code under test. A test
without any assertions succeeds by default. See the section
:ref:`assertions` for a complete list of all available assertions.

For example, this test ensures that the *strlen* function works as
documented::

  Function utest_strlenOnNullIsNaN()
      String str_foo
      EXPECT_EQ(NaN, strlen(str_foo))       // strlen should return NaN for a NULL string
  End

Tests are best kept small and focused on a single aspect of
functionality.

Test autodiscovery
------------------

Tests can be autodiscovered if your test function names start with
"utest\_" (short for *unit test*). If a function name does not start
with "utest\_", the function can still be included in test suites
manually.

Groups
------

You can also choose to organize tests into groups. To put a test into
a group, add a group name to the function name::

  Function utest_GROUP_NAME__TEST_NAME()
      // test body
  End

The group name is separated from the test name by a double underscore
"__". For example, the following snippet creates a group "Foo" and
puts the test "bar" into the "Foo" group::

  Function utest_Foo__bar()
     // test body
  End

If we then add the function::

   Function utest_Foo__baz()

group "Foo" will have two tests--"bar" and "baz".

Setup/Teardown
~~~~~~~~~~~~~~

You can define setup and teardown functions that run before and after
each test in a group.

To define a setup function, prefix the group name with "setup\_"::

  Function setup_<GROUP_NAME>()

To define a teardown function, prefix the group name with "teardown\_"::

  Function teardown_<GROUP_NAME>()

This feature is useful if you find that many tests have common code
before or after the actual test code. The setup and teardown functions
are run in the same data folder as the test function. In most cases,
common setup code will consist of variable and object
definitions. Because the data folder and its contents are deleted
after the test is completed anyway, a teardown function is not usually
necessary.
