#pragma rtGlobals=1		// Use modern global access method.

// TestDefect -- a component of IgorUnit
//   This data type represents information about a failed test

#ifndef IGORUNIT_TESTDEFECT
#define IGORUNIT_TESTDEFECT

#include "UnitTest"

Structure TestDefect
    STRUCT UnitTest test
    String message
    String stack_info
EndStructure

Function TD_init(td, test, message, stack_info)
    STRUCT TestDefect &td
    STRUCT UnitTest &test
    String message, stack_info

    TD_set(td, test, message, stack_info)
End

Function TD_set(td, test, message, stack_info)
    STRUCT TestDefect &td
    STRUCT UnitTest &test
    String message, stack_info

    td.test = test
    td.message = message
    td.stack_info = stack_info
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

Function/S TD_getStackInfo(td)
    STRUCT TestDefect &td
    return td.stack_info
End

Function/S TD_getFilename(td)
    STRUCT TestDefect &td
    String stack_row = Stack_getLastRow(td.stack_info)
    return StackRow_getFileName(stack_row)
End

Function TD_getLineNumber(td)
    STRUCT TestDefect &td
    String stack_row = Stack_getLastRow(td.stack_info)
    return StackRow_getLineNumber(stack_row)
End

#endif