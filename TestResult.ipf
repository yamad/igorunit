#pragma rtGlobals=1		// Use modern global access method.

// TestResult -- a component of IgorUnit
//   This data type collects the results of tests

#ifndef IGORUNIT_TESTRESULT
#define IGORUNIT_TESTRESULT

#include "wave"
#include "stackinfo"

Structure TestResult
    Wave/T failures
    Wave/T errors
    Variable tests_run
EndStructure

Function TR_init(tr)
    STRUCT TestResult &tr

    // Waves hold information about each test that failed
    //   column 0 is the test name
    //   column 1 is the error message
    //   column 2 is the stack information
    Make/FREE/T/N=(0,3) tr.failures
    Make/FREE/T/N=(0,3) tr.errors

    SetDimLabel 1, 0, test_name, tr.failures
    SetDimLabel 1, 1, message, tr.failures
    SetDimLabel 1, 2, stack_info, tr.failures

    SetDimLabel 1, 0, test_name, tr.errors
    SetDimLabel 1, 1, message, tr.errors
    SetDimLabel 1, 2, stack_info, tr.errors
End

Function TR_getFailureCount(tr)
    STRUCT TestResult &tr
    return Wave_getRowCount(tr.failures)
End

Function TR_getErrorsCount(tr)
    STRUCT TestResult &tr
    return Wave_getRowCount(tr.errors)
End

Function TR_addFailure(tr, test_name, message)
    STRUCT TestResult &tr
    String test_name
    String message
    TR_addFailed(tr.failures, test_name, message)
End

Function TR_addError(tr, test_name, message)
    STRUCT TestResult &tr
    String test_name
    String message
    TR_addFailed(tr.errors, test_name, message)
End

Static Function TR_addFailed(fail_wave, test_name, message)
    Wave fail_wave
    Wave_appendRow(fail_wave)
    fail_wave[Inf][%test_name] = test_name
    fail_wave[Inf][%message] = message
    fail_wave[Inf][%stack_info] = Stack_getFull()
End

#endif
