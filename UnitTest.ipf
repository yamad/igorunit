#pragma rtGlobals=1		// Use modern global access method.

// UnitTest -- a component of IgorUnit
//   This data type represents a single unit test

#ifndef IGORUNIT_UNITTEST
#define IGORUNIT_UNITTEST

Structure UnitTest
    String groupname
    String testname
    String funcname
    Variable index
EndStructure

Function UnitTest_persist(test, to_dfref)
    STRUCT UnitTest &test
    DFREF to_dfref

    Variable/G to_dfref:index = test.index
    String/G to_dfref:groupname = test.groupname
    String/G to_dfref:testname = test.testname
    String/G to_dfref:funcname = test.funcname
End

Function UnitTest_load(test, from_dfref)
    STRUCT UnitTest &test
    DFREF from_dfref

    SVAR groupname = from_dfref:groupname
    SVAR testname = from_dfref:testname
    SVAR funcname = from_dfref:funcname
    NVAR index = from_dfref:index

    UnitTest_set(test, groupname, testname, funcname)
    UnitTest_setIndex(test, index)
End

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

Function UnitTest_setIndex(test, index)
    STRUCT UnitTest &test
    Variable index
    test.index = index
End

Function UnitTest_getIndex(test)
    STRUCT UnitTest &test
    return test.index
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

Function/S UnitTest_getFilename(test)
    STRUCT UnitTest &test
    String funcinfo = FunctionInfo(UnitTest_getFuncname(test))
    return Dict_getItem(funcinfo, "PROCWIN")
End

Function UnitTest_getLineNumber(test)
    STRUCT UnitTest &test
    String funcinfo = FunctionInfo(UnitTest_getFuncname(test))
    return str2num(Dict_getItem(funcinfo, "PROCLINE"))
End

#endif

