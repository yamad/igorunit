Assertions
==========

The following assertions are available. The naming and structure of
assertions are based on the `googletest`_ framework.

Each type of assertion has two variants--a fatal (ASSERT_*) and a
non-fatal (EXPECT_*) variant. Both variants will cause the containing
test to fail, but exit from the containing test differently. ASSERT_*
assertions abort from the containing function, stopping function
execution immediately. EXPECT_* assertions, when they fail, do not
abort the current function and thus allow the rest of the function to
run.

The EXPECT_* variant is usually *preferred*. However, the ASSERT_*
variant should be used when it doesn't make sense to continue the
function if the assertion fails (e.g. if the variable is NULL,
subsequent tests will inevitably fail).

A custom failure message can be provided to any assertion by passing
the optional parameter *fail_msg*::

    ASSERT(1 == 2, fail_msg="One definitely does not equal two")

Note that *fail_msg* can be added to any assertion. For clarity, in
the tables below, *fail_msg* is not included in the assertion
signatures even though it is available. Thus, for example,
*ASSERT(condition)* actually has the signature *ASSERT(condition,
[fail_msg])*.

.. _googletest: http://code.google.com/p/googletest

Basic assertions
----------------

These assertions provide basic true/false condition testing. 

Also, unconditional success (SUCCEED) and failure (FAIL) assertions
are available. These are useful when control flow is needed to
determine whether a test is successful or not.

.. #+ORGTBL: SEND basic_assert orgtbl-to-rst
.. | Fatal assertion         | Non-fatal assertion     | Verifies              |
.. |-------------------------+-------------------------+-----------------------|
.. |                         | SUCCEED()[1]_           | unconditional success |
.. | FAIL()                  | EXPECT_FAIL()[2]_       | unconditional failure |
.. | ASSERT(condition)       | EXPECT(condition)       | *condition* is true   |
.. | ASSERT_TRUE(condition)  | EXPECT_TRUE(condition)  | same as above         |
.. | ASSERT_FALSE(condition) | EXPECT_FALSE(condition) | *condition* is false  |
.. BEGIN RECEIVE ORGTBL basic_assert
+-------------------------+-------------------------+-----------------------+
| Fatal assertion         | Non-fatal assertion     | Verifies              |
+=========================+=========================+=======================+
|                         | SUCCEED()[1]_           | unconditional success |
+-------------------------+-------------------------+-----------------------+
| FAIL()                  | EXPECT_FAIL()[2]_       | unconditional failure |
+-------------------------+-------------------------+-----------------------+
| ASSERT(condition)       | EXPECT(condition)       | *condition* is true   |
+-------------------------+-------------------------+-----------------------+
| ASSERT_TRUE(condition)  | EXPECT_TRUE(condition)  | same as above         |
+-------------------------+-------------------------+-----------------------+
| ASSERT_FALSE(condition) | EXPECT_FALSE(condition) | *condition* is false  |
+-------------------------+-------------------------+-----------------------+
.. END RECEIVE ORGTBL basic_assert

.. [1] All functions have an optional *fail_msg* parameter that is not listed. 
   Therefore, for instance, the real signature for SUCCEED() is SUCCEED([fail_msg]).

.. [2] This is a departure from the `googletest`_ name, which is ADD_FAILURE(). 
   I believe that EXPECT_FAIL() is more consistent with the other non-fatal assertions.


Variable comparison
-------------------

The following assertions compare two numerical values. 

.. #+ORGTBL: SEND var_assert orgtbl-to-rst
.. | Fatal assertion                          | Non-fatal assertion                      | Verifies           |
.. |------------------------------------------+------------------------------------------+--------------------|
.. | ASSERT_EQ(expected, actual, [tolerance]) | EXPECT_EQ(expected, actual, [tolerance]) | expected == actual |
.. | ASSERT_NE(expected, actual, [tolerance]) | EXPECT_NE(expected, actual, [tolerance]) | expected != actual |
.. | ASSERT_LT(val1, val2)                    | EXPECT_LT(val1, val2)                    | val1 < val2        |
.. | ASSERT_LE(val1, val2)                    | EXPECT_LE(val1, val2)                    | val1 <= val2       |
.. | ASSERT_GT(val1, val2)                    | EXPECT_GT(val1, val2)                    | val1 > val2        |
.. | ASSERT_GE(val1, val2)                    | EXPECT_GE(val1, val2)                    | val1 >= val2       |
.. BEGIN RECEIVE ORGTBL var_assert
+------------------------------------------+------------------------------------------+--------------------+
| Fatal assertion                          | Non-fatal assertion                      | Verifies           |
+==========================================+==========================================+====================+
| ASSERT_EQ(expected, actual, [tolerance]) | EXPECT_EQ(expected, actual, [tolerance]) | expected == actual |
+------------------------------------------+------------------------------------------+--------------------+
| ASSERT_NE(expected, actual, [tolerance]) | EXPECT_NE(expected, actual, [tolerance]) | expected != actual |
+------------------------------------------+------------------------------------------+--------------------+
| ASSERT_LT(val1, val2)                    | EXPECT_LT(val1, val2)                    | val1 < val2        |
+------------------------------------------+------------------------------------------+--------------------+
| ASSERT_LE(val1, val2)                    | EXPECT_LE(val1, val2)                    | val1 <= val2       |
+------------------------------------------+------------------------------------------+--------------------+
| ASSERT_GT(val1, val2)                    | EXPECT_GT(val1, val2)                    | val1 > val2        |
+------------------------------------------+------------------------------------------+--------------------+
| ASSERT_GE(val1, val2)                    | EXPECT_GE(val1, val2)                    | val1 >= val2       |
+------------------------------------------+------------------------------------------+--------------------+
.. END RECEIVE ORGTBL var_assert

For assertions that include the *tolerance* parameter, if a tolerance
is specified the values are equal if the difference between the
expected and actual values is less than or equal to the tolerance.

Two NaNs are considered equal, as are two +Infs or two
-Infs. Obviously, +Inf and -Inf are not equal.

A similar set of assertions to the above can be used to compare
complex numbers (*_*_C). Both real and imaginary parts must be equal
for an equality test to succeed.

.. #+ORGTBL: SEND complex_assert orgtbl-to-rst
.. | Fatal assertion                            | Non-fatal assertion                        | Verifies           |
.. |--------------------------------------------+--------------------------------------------+--------------------|
.. | ASSERT_EQ_C(expected, actual, [tolerance]) | EXPECT_EQ_C(expected, actual, [tolerance]) | expected == actual |
.. | ASSERT_NE_C(expected, actual, [tolerance]) | EXPECT_NE_C(expected, actual, [tolerance]) | expected != actual |
.. BEGIN RECEIVE ORGTBL complex_assert
+--------------------------------------------+--------------------------------------------+--------------------+
| Fatal assertion                            | Non-fatal assertion                        | Verifies           |
+============================================+============================================+====================+
| ASSERT_EQ_C(expected, actual, [tolerance]) | EXPECT_EQ_C(expected, actual, [tolerance]) | expected == actual |
+--------------------------------------------+--------------------------------------------+--------------------+
| ASSERT_NE_C(expected, actual, [tolerance]) | EXPECT_NE_C(expected, actual, [tolerance]) | expected != actual |
+--------------------------------------------+--------------------------------------------+--------------------+
.. END RECEIVE ORGTBL complex_assert


String comparison
-----------------

The following assertions compare two string values.

.. #+ORGTBL: SEND string_assert orgtbl-to-rst
.. | Fatal assertion                    | Non-fatal assertion                | Verifies                                         |
.. |------------------------------------+------------------------------------+--------------------------------------------------|
.. | ASSERT_STREQ(expected, actual)     | EXPECT_STREQ(expected, actual)     | strings have the same content                    |
.. | ASSERT_STRNE(expected, actual)     | EXPECT_STRNE(expected, actual)     | strings have different content                   |
.. | ASSERT_STRCASEEQ(expected, actual) | EXPECT_STRCASEEQ(expected, actual) | strings have the same content, case insensitive  |
.. | ASSERT_STRCASENE(expected, actual) | EXPECT_STRCASENE(expected, actual) | strings have different content, case insensitive |
.. BEGIN RECEIVE ORGTBL string_assert
+------------------------------------+------------------------------------+--------------------------------------------------+
| Fatal assertion                    | Non-fatal assertion                | Verifies                                         |
+====================================+====================================+==================================================+
| ASSERT_STREQ(expected, actual)     | EXPECT_STREQ(expected, actual)     | strings have the same content                    |
+------------------------------------+------------------------------------+--------------------------------------------------+
| ASSERT_STRNE(expected, actual)     | EXPECT_STRNE(expected, actual)     | strings have different content                   |
+------------------------------------+------------------------------------+--------------------------------------------------+
| ASSERT_STRCASEEQ(expected, actual) | EXPECT_STRCASEEQ(expected, actual) | strings have the same content, case insensitive  |
+------------------------------------+------------------------------------+--------------------------------------------------+
| ASSERT_STRCASENE(expected, actual) | EXPECT_STRCASENE(expected, actual) | strings have different content, case insensitive |
+------------------------------------+------------------------------------+--------------------------------------------------+
.. END RECEIVE ORGTBL string_assert

A NULL string and an empty string are considered different. Two NULL
strings are equal.

Note that *CASE* indicates that the assertion is **not** case
sensitive.
