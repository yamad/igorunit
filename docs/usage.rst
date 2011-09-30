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
easily included into Igor code.

Running tests within Igor
-------------------------

To run the tests, include the procedure file into your Igor experiment
procedure window (make sure the file is a folder on your Igor path)::

 #include "output_file"

Then, from the Igor command window, call the `runAllTests` function::

 runAllTests()

For capturing the test output (instead of spitting it out on the Igor
command line), use::

 runAllTests_getResults()

