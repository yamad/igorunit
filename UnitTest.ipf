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
    String docstring
EndStructure

Function UnitTest_persist(test, to_dfref)
    STRUCT UnitTest &test
    DFREF to_dfref

    Variable/G to_dfref:index = test.index
    String/G to_dfref:groupname = test.groupname
    String/G to_dfref:testname = test.testname
    String/G to_dfref:funcname = test.funcname
    String/G to_dfref:docstring = test.docstring
End

Function UnitTest_load(test, from_dfref)
    STRUCT UnitTest &test
    DFREF from_dfref

    SVAR groupname = from_dfref:groupname
    SVAR testname = from_dfref:testname
    SVAR funcname = from_dfref:funcname
    NVAR index = from_dfref:index
    SVAR docstring = from_dfref:docstring

    UnitTest_set(test, groupname, testname, funcname)
    UnitTest_setIndex(test, index)
    UnitTest_setDocString(test, docstring)
End

Function UnitTest_init(test, groupname, testname, funcname)
    STRUCT UnitTest &test
    String groupname, testname, funcname
    UnitTest_set(test, groupname, testname, funcname)
    test.docstring = ""
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

Function UnitTest_setDocString(test, doc_str)
    STRUCT UnitTest &test
    String doc_str
    test.docstring = doc_str
End

Function UnitTest_autosetDocString(test)
    STRUCT UnitTest &test
    String first_re = "^\\s*//[\\t ]*([^\\r]*)\\r?"
    String doc_str = Func_getPostDocString(test.funcname)
    test.docstring = String_getRegexMatch(doc_str, first_re)
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

Function/S UnitTest_getDocString(test)
    STRUCT UnitTest &test
    return test.docstring
End

Function/S UnitTest_getFilename(test)
    STRUCT UnitTest &test
    return Func_getFilename(test.funcname)
End

Function UnitTest_getLineNumber(test)
    STRUCT UnitTest &test
    return Func_getLineNumber(test.funcname)
End


#endif

