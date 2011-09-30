===========================
 Using IgorUnit on Windows
===========================

To work around limitations in the Igor Pro environment, IgorUnit
depends on the Python_ programming language.

IgorUnit test files are written outside of Igor in any text
editor. The tests are then compiled into Igor code and run using
Python_ scripts that communicate with Igor.

This guide explains recommendations and installation steps for using
IgorUnit on the Microsoft Windows operating system.

Installing Python on Windows
============================

IgorUnit must have a Python_ 2 interpreter (as of this writing, the
most current Python 2 version is Python 2.7.2) present to run its
python scripts. There are several distributions of Python for Windows
that will work just fine.

I suggest the `Enthought Python Distribution`__ (EPD_), which is
purpose-built for scientists. It is free for academic use and installs
most of the useful packages for scientific use of Python by
default. The installers for the academic versions of EPD_ can be found
at `this link <http://www.enthought.com/repo/.hidden_epd_installers>`.

Other python distributions for Windows include:

 * The official `Python.org Python <http://www.python.org/getit>`_
 * `ActiveState ActivePython <http://www.activestate.com/activepython>`_
 
.. note:: Because IgorUnit communicates with Igor through the
   operating system, an OS-native python distribution must be
   used. This means that Cygwin_ python will not work.

__ EPD_

Some useful tips for Python on Windows
--------------------------------------

pip
~~~

A useful tool for working with Python is the package installer
pip_. If your python distribution did not come with pip_ already (EPD
7.1 does not), it can be installed from the Windows command prompt
("$" indicates the command prompt) ::

 $ easy_install pip

If the command prompt complains that it cannot find `easy_install`,
you need to install distribute_ first. To install distribute_,
download `distribute_setup.py
<http://python-distribute.org/distribute_setup.py>`_ and run it.

Windows Python from inside Cygwin_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Although you cannot use Cygwin python for all of IgorUnit's features,
you might still want to use the Cygwin_ shell. To use the Windows
Python installation from inside of Cygwin_, you can create a symbolic
link from the python executable to somewhere on your PATH.

I have done the following (from the Cygwin_ shell)::

 $ mkdir ~/bin
 $ ln -s /cygdrive/c/Python27/python.exe ~/bin/winpython
 $ export PATH=~/bin:$PATH

Now, calling Windows Python is easy::

 $ winpython --version

You may also want to permanently add `~/bin` to your PATH::
 
 $ echo "export PATH=~/bin:$PATH" >> ~/.bash_profile

.. _Python: http://www.python.org
.. _Cygwin: http://www.cygwin.com
.. _EPD: http://www.enthought.com/products/epd.php
.. _pip: http://pypi.python.org/pypi/pip
.. _distribute: http://pypi.python.org/pypi/distribute
