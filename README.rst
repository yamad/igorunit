==========
 IgorUnit
==========

A unit test framework for `Igor Pro`_

General Design
==============

IgorUnit_ is an implementation of the xUnit_ test framework for the
`Igor Pro`_ data analysis language. Tests are defined directly in the
Igor language using a set of simple assertion functions to make
writing tests easy. The assertion function library is based on the
`googletest`_ framework.

`IgorUnit`_ can run tests in a variety of convenient ways. If named
appropriately, tests are autodiscovered. Alternatively, test suites
can be manually composed.

See the docs directory for usage information.

Install
=======

IgorUnit_ development is tracked in a git_ repository. It has a
dependency on the igorutils_ package, which must be on the Igor search
path for IgorUnit_ to work.

To install, download both the IgorUnit_ and igorutils_ packages and
place the folders in the User Procedures directory. See the "Shared
Procedure Files" and "Igor Pro User Files" help topics in the Igor
help system for more information on installing Igor packages.

Dependencies
------------

 * Git_ (for obtaining the code)
 * `Igor Pro 6.2 <http://www.wavemetrics.com>`_ or higher
 * igorutils_

.. _`Igor Pro`: http://www.wavemetrics.com
.. _`IgorUnit`: http://github.com/yamad/igorunit
.. _`igorutils`: http://github.com/yamad/igorutils
.. _git: http://git-scm.com
.. _xUnit: http://www.junit.org
.. _googletest: http://code.google.com/p/googletest
