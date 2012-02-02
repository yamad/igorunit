#pragma rtGlobals=1		// Use modern global access method.

// TestOutcome -- a component of IgorUnit
//   This data type represents information about the outcome/result of a run test

#ifndef IGORUNIT_TESTOUTCOME
#define IGORUNIT_TESTOUTCOME

#include "UnitTest"

Structure TestOutcome
    STRUCT UnitTest test
    Variable duration
    Variable result_code
    String message
EndStructure

Function TO_init(to, test, duration, result_code, message)
    STRUCT TestOutcome &to
    STRUCT UnitTest &test
    Variable duration
    Variable result_code
    String message

    TO_set(to, test, duration, result_code, message)
End

Function TO_set(to, test, duration, result_code, message)
    STRUCT TestOutcome &to
    STRUCT UnitTest &test
    Variable duration
    Variable result_code
    String message

    to.test = test
    to.duration = duration
    to.result_code = result_code
    to.message = message
End

Function/S TO_getGroupname(to)
    STRUCT TestOutcome &to
    return UnitTest_getGroupname(to.test)
End

Function/S TO_getTestname(to)
    STRUCT TestOutcome &to
    return UnitTest_getTestname(to.test)
End

Function/S TO_getFuncname(to)
    STRUCT TestOutcome &to
    return UnitTest_getFuncname(to.test)
End

Function TO_getIndex(to)
    STRUCT TestOutcome &to
    return UnitTest_getIndex(to.test)
End

Function/S TO_getMessage(to)
    STRUCT TestOutcome &to
    return to.message
End

Function TO_getResult(to)
    STRUCT TestOutcome &to
    return to.result_code
End

Function TO_getDuration(to)
    STRUCT TestOutcome &to
    return to.duration
End

Function/S TO_getFilename(to)
    STRUCT TestOutcome &to
    return UnitTest_getFilename(to.test)
End

Function TO_getLineNumber(to)
    STRUCT TestOutcome &to
    return UnitTest_getLineNumber(to.test)
End

#endif