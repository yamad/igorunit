==========
 IgorUnit
==========

A unit test framework for `Igor Pro`_

.. contents::

General Design
==============

IgorUnit_ is an implementation of the xUnit_ test framework for the
`Igor Pro`_ data analysis language. IgorUnit_ generates valid Igor
code using a Python_\ -based toolkit. Tests are defined using a set of
simple macros to make writing tests easy. The templating engine Mako_
is used as a preprocessor to expand the macros.

This general design is similar to unit test libraries built for the C
language, such as Unity_ and Check_, which use preprocessor macros to
do the heavy lifting. Unity_ also provides Ruby-based automatic test
suite generation. Similarly, `IgorUnit`_ automatically generates test
suites and provides convenience functions to make those suites easy to
run.

Install
=======

IgorUnit_ development is tracked in a git_ repository. It has a
dependency on the igorutils_ package, which is included as a `git
submodule`_. To get a fully functional IgorUnit distribution::

 git clone git://github.com/yamad/igorunit.git
 git submodule init
 git submodule update

You will also need to ensure that a Python_ interpreter is available
and that the python package Mako_ is installed.

Dependencies
------------

 * Git_ (for obtaining the code)
 * `Igor Pro 6.2 <http://www.wavemetrics.com>`_ or higher
 * `Python 2.7 <http://www.python.org>`_ (Python 3 support is forthcoming)
 * Mako_ templating engine

Usage
=====

The `make_tests.py` script transforms `IgorUnit`_ test files into
valid Igor code. The resulting code can be included and run like any
Igor procedure file (\*.ipf). The rest of this section describes the
appropriate syntax for test files. To generate a valid test suite from
a test file, issue the following command from the command line::

 python make_tests.py <path/to/test_file>

or, more simply::

 ./make_tests.py {path/to/test_file}

The output from the `make_tests` script can be piped to a file::

 ./make_tests.py {path/to/test_file} > {path/to/output_file.ipf}

Note that `make_tests` can accept more than one test file. The tests
from all the files will be collected and included in the script
output::

 ./make_tests.py {test_file_1} {test_file_2} > {output_file.ipf}

I recommend saving `make_tests` output to an \*.ipf file in a directory
on the Igor search path. This way, the resulting procedure file can be
easily included into Igor code. To run the tests, include the
procedure file into your Igor experiment procedure window::

 #include "output_file"

Then, from the Igor command window, call the `runAllTests` function::

 runAllTests()


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
|                               |                                          |
+-------------------------------+------------------------------------------+


.. _Mako: http://www.makotemplates.org
.. _Unity: http://throwtheswitch.org/white-papers/unity-intro.html
.. _Check: http://check.sourceforge.net
.. _`Igor Pro`: http://www.wavemetrics.com
.. _`IgorUnit`: http://github.com/yamad/igorunit
.. _`igorutils`: http://github.com/yamad/igorutils
.. _git: http://git-scm.com
.. _`git submodule`: http://schacon.github.com/git/git-submodule.html
.. _xUnit: http://www.junit.org
.. _Python: http://www.python.org
