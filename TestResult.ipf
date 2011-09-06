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
    //   column 0 is the group name
    //   column 1 is the test name
    //   column 2 is the error message
    //   column 3 is the stack information
    Make/FREE/T/N=(0,4) tr.failures
    Make/FREE/T/N=(0,4) tr.errors

    SetDimLabel 1, 0, group_name, tr.failures
    SetDimLabel 1, 1, test_name, tr.failures
    SetDimLabel 1, 2, message, tr.failures
    SetDimLabel 1, 3, stack_info, tr.failures

    SetDimLabel 1, 0, group_name, tr.errors
    SetDimLabel 1, 1, test_name, tr.errors
    SetDimLabel 1, 2, message, tr.errors
    SetDimLabel 1, 3, stack_info, tr.errors
End

Function TR_getFailureCount(tr)
    STRUCT TestResult &tr
    return Wave_getRowCount(tr.failures)
End

Function TR_getErrorCount(tr)
    STRUCT TestResult &tr
    return Wave_getRowCount(tr.errors)
End

Function TR_getTestRunCount(tr)
    STRUCT TestResult &tr
    return tr.tests_run
End

Function TR_getSuccessCount(tr)
    STRUCT TestResult &tr
    Variable total_tests = TR_getTestRunCount(tr)
    Variable total_failures = TR_getFailureCount(tr) + TR_getErrorCount(tr)
    return total_tests - total_failures
End

Function TR_addFailure(tr, group_name, test_name, message)
    STRUCT TestResult &tr
    String group_name, test_name, message
    TR_addFailed(tr.failures, group_name, test_name, message)
    TR_addRunTest(tr, group_name, test_name, message)
    printf "F"
End

Function TR_addError(tr, group_name, test_name, message)
    STRUCT TestResult &tr
    String group_name, test_name, message
    TR_addFailed(tr.errors, group_name, test_name, message)
    TR_addRunTest(tr, group_name, test_name, message)
    printf "E"
End

Function TR_addSuccess(tr, group_name, test_name, message)
    STRUCT TestResult &tr
    String group_name, test_name, message
    TR_addRunTest(tr, group_name, test_name, message)
    printf "."
End

Function TR_addRunTest(tr, group_name, test_name, message)
    STRUCT TestResult &tr
    String group_name, test_name, message
    tr.tests_run += 1
End

Static Function TR_addFailed(fail_wave, group_name, test_name, message)
    Wave/T fail_wave
    String group_name, test_name, message

    Wave_appendRow(fail_wave)
    fail_wave[Inf][%group_name] = group_name
    fail_wave[Inf][%test_name] = test_name
    fail_wave[Inf][%message] = message
    fail_wave[Inf][%stack_info] = Stack_getPartialNegativeIndex(2)
End

Function/S TR_printAllFailures(tr)
    STRUCT TestResult &tr

    Variable failure_count = TR_getFailureCount(tr)
    if (failure_count == 0)
        return ""
    endif

    printf "Test Failures\r"
    printf "======================================\r"
    Variable i
    for (i=0; i < failure_count; i+=1)
        TR_printFailureByIndex(tr.failures, i)
        printf "--------------------------------------\r"
    endfor
End

Function/S TR_printAllErrors(tr)
    STRUCT TestResult &tr

    Variable error_count = TR_getErrorCount(tr)
    if (error_count == 0)
        return ""
    endif

    printf "Test Errors\r"
    printf "======================================\r"
    Variable i
    for (i=0; i < error_count; i+=1)
        TR_printFailureByIndex(tr.errors, i)
        printf "--------------------------------------\r"
    endfor
End

Function/S TR_printFailureByIndex(fail_wave, fail_idx)
    Wave/T fail_wave
    Variable fail_idx

    String groupname = fail_wave[fail_idx][%group_name]
    String testname = fail_wave[fail_idx][%test_name]
    String message = fail_wave[fail_idx][%message]
    String stack_info = fail_wave[fail_idx][%stack_info]

    String stack_row = Stack_getRow(stack_info, Stack_getLength(stack_info) - 1)

    printf "%s, %s in %s at line %d\r", groupname, testname, StackRow_getFileName(stack_row), StackRow_getLineNumber(stack_row)
    printf "\t%s\r", message
End

#endif