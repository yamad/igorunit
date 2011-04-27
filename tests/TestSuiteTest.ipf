#pragma rtGlobals=1		// Use modern global access method.

// TestSuite Tests -- tests from the TestSuite data type

#include "TestSuite"

// Structure variables are initialized to 0 by default
Function test_StructVarsAre0()
    STRUCT TestSuite ts

    if (ts.test_no == 0)
        print 1
    endif

    ts.test_no += 1

    if (ts.test_no == 1)
        print 1
    endif
End

// Structure strings are not initialized by default
Function test_StructStrings()
    STRUCT TestSuite ts

    assert(strlen(ts.tests))

    String add_str = "Concatenate This"
    Variable added_len = strlen(add_str)

    ts.tests += add_str

    if (strlen(ts.tests) == added_len)
        print 1
    endif
End

Function TestSuiteTest_runTests()
    test_StructVarsAre0()
    test_StructStringsAreEmpty()
End
