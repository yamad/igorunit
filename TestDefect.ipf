#pragma rtGlobals=1		// Use modern global access method.

// TestDefect -- a component of IgorUnit
//   This data type represents information about a failed test

#ifndef IGORUNIT_TESTDEFECT
#define IGORUNIT_TESTDEFECT

#include "UnitTest"

Structure TestDefect
    STRUCT UnitTest test
    Variable duration
    Variable result_code
    String message
EndStructure

Function TD_init(td, test, duration, result_code, message)
    STRUCT TestDefect &td
    STRUCT UnitTest &test
    Variable duration
    Variable result_code
    String message

    TD_set(td, test, duration, result_code, message)
End

Function TD_set(td, test, duration, result_code, message)
    STRUCT TestDefect &td
    STRUCT UnitTest &test
    Variable duration
    Variable result_code
    String message

    td.test = test
    td.duration = duration
    td.result_code = result_code
    td.message = message
End

Function/S TD_getGroupname(td)
    STRUCT TestDefect &td
    return UnitTest_getGroupname(td.test)
End

Function/S TD_getTestname(td)
    STRUCT TestDefect &td
    return UnitTest_getTestname(td.test)
End

Function/S TD_getFuncname(td)
    STRUCT TestDefect &td
    return UnitTest_getFuncname(td.test)
End

Function/S TD_getMessage(td)
    STRUCT TestDefect &td
    return td.message
End

Function TD_getResult(td)
    STRUCT TestDefect &td
    return td.result_code
End

Function TD_getDuration(td)
    STRUCT TestDefect &td
    return td.duration
End

Function/S TD_getFilename(td)
    STRUCT TestDefect &td
    return UnitTest_getFilename(td.test)
End

Function TD_getLineNumber(td)
    STRUCT TestDefect &td
    return UnitTest_getLineNumber(td.test)
End

#endif