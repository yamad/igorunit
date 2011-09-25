#pragma rtGlobals=1		// Use modern global access method.

// UnitTest -- a component of IgorUnit
//   This data type represents a single unit test

#ifndef IGORUNIT_UNITTEST
#define IGORUNIT_UNITTEST

Structure UnitTest
    String groupname
    String testname
    String funcname
EndStructure

Function UnitTest_init(test, groupname, testname, funcname)
    STRUCT UnitTest &test
    String groupname, testname, funcname
    UnitTest_set(test, groupname, testname, funcname)
End

Function UnitTest_set(test, groupname, testname, funcname)
    STRUCT UnitTest &test
    String groupname, testname, funcname

    test.groupname = groupname
    test.testname = testname
    test.funcname = funcname
End

Function/S UnitTest_getTestname(test)
    STRUCT UnitTest &test
    return test.testname

End
Function/S UnitTest_getGroupname(test)
    STRUCT UnitTest &test
    return test.groupname
End

Function/S UnitTest_getFuncname(test)
    STRUCT UnitTest &test
    return test.funcname
End

#endif

