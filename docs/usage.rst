Usage
=====

To use `IgorUnit`, install the IgorUnit distribution into your Igor
path and include the main IgorUnit procedure file ::

    #include "IgorUnit"

Then, write test functions. Function names starting with "utest_" are autodiscovered.

To run tests, from the Igor command window, call the `runAllTests` function::

 IgorUnit_runAllTests()

To run a single test, call the `runSingleTest` function::

 IgorUnit_runSingleTest(<function_name>)
