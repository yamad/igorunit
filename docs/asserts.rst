.. _assertions:

Assertions
==========

The following assertions are available. The naming and structure of
assertions are based on the `googletest`_ framework.

Each type of assertion has two variants--a fatal (``ASSERT_*``) and
a non-fatal (``EXPECT_*``) variant. Both variants signal test
failure if the assertion fails. However, a failed ASSERT_* assertion
aborts execution of the containing test immediately. By contrast, a
failed EXPECT_* assertion allows the containing test to continue
executing.

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
``ASSERT(condition)`` actually has the signature ``ASSERT(condition,
[fail_msg])``.


.. _googletest: http://code.google.com/p/googletest

Basic assertions
----------------

These assertions provide basic true/false condition testing.

Also, unconditional success (SUCCEED) and failure (FAIL) assertions
are available. These are useful when control flow is needed to
determine whether a test is successful or not.

.. #+ORGTBL: SEND basic_assert orgtbl-to-rst :no-escape t
.. | Fatal assertion         | Non-fatal assertion     | Verifies              |
.. |-------------------------+-------------------------+-----------------------|
.. | SUCCEED() [1]_ [2]_     | EXPECT_SUCCEED()        | unconditional success |
.. | FAIL()                  | EXPECT_FAIL() [3]_      | unconditional failure |
.. | ASSERT(condition)       | EXPECT(condition)       | *condition* is true   |
.. | ASSERT_TRUE(condition)  | EXPECT_TRUE(condition)  | same as above         |
.. | ASSERT_FALSE(condition) | EXPECT_FALSE(condition) | *condition* is false  |
.. BEGIN RECEIVE ORGTBL basic_assert
+-------------------------+-------------------------+-----------------------+
| Fatal assertion         | Non-fatal assertion     | Verifies              |
+=========================+=========================+=======================+
| SUCCEED() [1]_ [2]_     | EXPECT_SUCCEED()        | unconditional success |
+-------------------------+-------------------------+-----------------------+
| FAIL()                  | EXPECT_FAIL() [3]_      | unconditional failure |
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

.. [2] SUCCEED is a special case. It is the only assertion that
   signals success and then immediately stops test execution. It is listed
   under "fatal assertions" because the test is stopped once it is called.
   All other fatal assertions stop execution only if the assertion fails.

.. [3] This is a departure from the `googletest`_ name, which is ADD_FAILURE().
   I believe that EXPECT_FAIL() is more consistent with the other non-fatal assertions.


Variable comparison
-------------------

The following assertions compare two numerical values.

.. #+ORGTBL: SEND var_assert orgtbl-to-rst :no-escape t
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

For assertions that include the *tolerance* optional parameter, the
values are equal if the difference between the expected and actual
values is less than or equal to the tolerance.

Two ``NaN`` values are considered equal, as are two ``+Inf`` values or
two ``-Inf`` values. Obviously, ``+Inf`` and ``-Inf`` are not equal.

A similar set of assertions to the above can be used to compare
complex numbers (``*_*_C``). Both real and imaginary parts must be
equal for an equality test to succeed.

.. #+ORGTBL: SEND complex_assert orgtbl-to-rst :no-escape t
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

.. #+ORGTBL: SEND string_assert orgtbl-to-rst :no-escape t
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

A ``NULL`` string and an empty string are considered different. Two
``NULL`` strings are equal.

Note that ``CASE`` indicates that the assertion is *case-insensitive*.


Wave comparison
---------------

The following assertions compare two waves

.. #+ORGTBL: SEND wave_assert orgtbl-to-rst :no-escape t
.. | Fatal assertion                  | Non-fatal assertion              | Verifies                            |
.. |----------------------------------+----------------------------------+-------------------------------------|
.. | ASSERT_WAVEEQ(expected, actual)  | EXPECT_WAVEEQ(expected, actual)  | numerical waves have the same data  |
.. | ASSERT_WAVENEQ(expected, actual) | EXPECT_WAVENEQ(expected, actual) | numerical waves have different data |
.. BEGIN RECEIVE ORGTBL wave_assert
+----------------------------------+----------------------------------+-------------------------------------+
| Fatal assertion                  | Non-fatal assertion              | Verifies                            |
+==================================+==================================+=====================================+
| ASSERT_WAVEEQ(expected, actual)  | EXPECT_WAVEEQ(expected, actual)  | numerical waves have the same data  |
+----------------------------------+----------------------------------+-------------------------------------+
| ASSERT_WAVENEQ(expected, actual) | EXPECT_WAVENEQ(expected, actual) | numerical waves have different data |
+----------------------------------+----------------------------------+-------------------------------------+
.. END RECEIVE ORGTBL wave_assert



Ignoring tests
--------------

A test can be ignored by adding the ``IGNORE_TEST`` assertion::

  IGNORE_TEST()

This assertion signals the current test to stop and the test is
flagged as ignored. Ignored tests do not count towards test failure or
error counts. This can be useful to temporarily "comment out" a
troublesome test.

Note that ``IGNORE_TEST`` must be called before any fatal
assertions. It is best to make ``IGNORE_TEST`` the first line of a
test.

Returning from an assertion
---------------------------

.. note:: This section is useful mostly to IgorUnit developers. In
   general, IgorUnit client code will not be interested in assertion
   return codes.

All assertions return an assertion result code, which is a Variable
with one of the following values:

  * ``ASSERTION_UNKNOWN``
  * ``ASSERTION_SUCCESS``
  * ``ASSERTION_FAILURE``
  * ``ASSERTION_IGNORETEST``

Of course, because fatal assertions abort when they fail, only
non-fatal assertions can return ``ASSERTION_FAILURE``.

The results of assertions are automatically saved by IgorUnit, so in
the vast majority of cases, you don't need or want to inspect the
assertion result at all. A bare assertion is the common case, and
usually what you want::

  EXPECT_EQ(1, 2)               // common case, don't capture returned value

However, assertion results may be useful in some rare cases with
complicated control flow. For instance, to test whether ``EXPECT_EQ``
is working correctly, one might write the following test::

  // EXPECT_EQ fails when values are not equal
  Function utest_EXPECT_EQ_fails_neq()
      Variable assert_status
      String msg = "EXPECT_EQ thinks 1 and 2 are equal!"
      assert_status = EXPECT_EQ(1, 2)
      if (assert_status == ASSERTION_FAILURE)
          SUCCEED(fail_msg=msg)
      else
          FAIL(fail_msg=msg)
      endif
  End

Here, the test should succeed when ``EXPECT_EQ`` signals a
failure. This is the opposite of normal behavior, so we have to handle
the result of the assertion ourselves. ``SUCCEED`` does exactly what
we want and signals test success even if there are other failing
assertions in the test.

Note that this techinque is really only useful for testing the
assertions themselves. It is not a general way to test for the
opposite of an assertion. For instance, we could (stupidly) mimic the
test in ``EXPECT_NEQ`` (values are not equal) using assertion result
codes. This test succeeds if 1 and 2 are different::

  // worst version. DON'T DO THIS!
  Variable rc = EXPECT_EQ(1, 2)
  if (rc == ASSERTION_FAILURE)     // 1 and 2 are not equal
      SUCCEED()
  endif

This is, however, the worst way to write this test. In general, if you
find yourself using assertion results, you are probably doing
something wrong. An improved version (but not the best) would be to
forget about assertion result codes and test for ``1 == 2``
directly. Any of the following will work::

  // better versions
  if (1 == 2)
      FAIL()
  endif

  if (1 != 2)
      SUCCEED()
  endif

  ASSERT_TRUE(1 != 2)
  ASSERT_FALSE(1 == 2)

The best solution, of course, is to just use ``EXPECT_NEQ``
directly. This is concise, clear, and comes with more useful
diagnostic messages when things go wrong::

  // best version
  EXPECT_NEQ(1, 2)
