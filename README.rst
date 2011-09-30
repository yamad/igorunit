==========
 IgorUnit
==========

A unit test framework for `Igor Pro`_

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

See the docs directory for usage information.

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
 * appscript_ (for Mac OS X)
 * pywin32_ (for Windows)

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
.. _appscript: http://appscript.sourceforge.net/py-appscript/index.html
.. _pywin32: http://sourceforge.net/projects/pywin32/
