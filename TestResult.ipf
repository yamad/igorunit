#pragma rtGlobals=1		// Use modern global access method.

// TestResult -- a component of IgorUnit
//   This data type collects the results of tests

#ifndef IGORUNIT_TESTRESULT
#define IGORUNIT_TESTRESULT

#include "waveutils"
#include "stackinfoutils"

#include "UnitTest"
#include "TestPrinter"
#include "TestDefect"

Structure TestResult
    Wave/T failures
    Wave/T errors
    Variable tests_run
    Variable failure_count
    Variable error_count
    STRUCT TestPrinter test_printer
EndStructure

Function TR_persist(tr, to_dfref)
    STRUCT TestResult &tr
    DFREF to_dfref

    Variable/G to_dfref:tests_run = tr.tests_run
    Variable/G to_dfref:failure_count = tr.failure_count
    Variable/G to_dfref:error_count = tr.error_count
    
    Duplicate/O/T tr.failures, to_dfref:failures
    Duplicate/O/T tr.errors, to_dfref:errors

    NewDataFolder/O to_dfref:test_printer
    TP_persist(tr.test_printer, to_dfref:test_printer)
End

Function TR_load(tr, from_dfref)
    STRUCT TestResult &tr
    DFREF from_dfref

    NVAR tests_run = from_dfref:tests_run
    NVAR failure_count = from_dfref:failure_count
    NVAR error_count = from_dfref:error_count

    Duplicate/O/T from_dfref:failures, tr.failures
    Duplicate/O/T from_dfref:errors, tr.errors

    tr.tests_run = tests_run
    tr.failure_count = failure_count
    tr.error_count = error_count
    TP_load(tr.test_printer, from_dfref:test_printer)
End

Static Constant FAILWAVE_BLOCK_SIZE = 10
Function TR_init(tr)
    STRUCT TestResult &tr

    STRUCT TestPrinter tp
    TP_init(tp)
    TR_setPrinter(tr, tp)

    // Waves hold information about each test that failed
    //   column 0 is the group name
    //   column 1 is the test name
    //   column 2 is the test function name
    //   column 3 is the error message
    //   column 4 is the stack information
    Make/FREE/T/N=(FAILWAVE_BLOCK_SIZE,5) tr.failures
    Make/FREE/T/N=(FAILWAVE_BLOCK_SIZE,5) tr.errors

    SetDimLabel 1, 0, group_name, tr.failures
    SetDimLabel 1, 1, test_name, tr.failures
    SetDimLabel 1, 2, func_name, tr.failures
    SetDimLabel 1, 3, message, tr.failures
    SetDimLabel 1, 4, stack_info, tr.failures

    SetDimLabel 1, 0, group_name, tr.errors
    SetDimLabel 1, 1, test_name, tr.errors
    SetDimLabel 1, 2, func_name, tr.errors
    SetDimLabel 1, 3, message, tr.errors
    SetDimLabel 1, 4, stack_info, tr.errors

    tr.tests_run = 0
    tr.failure_count = 0
    tr.error_count = 0
End

Function TR_setPrinter(tr, tp)
    STRUCT TestResult &tr
    STRUCT TestPrinter &tp
    tr.test_printer = tp
End

Function TR_getPrinter(tr, tp)
    STRUCT TestResult &tr
    STRUCT TestPrinter &tp
    tp = tr.test_printer
End

Function TR_getFailureCount(tr)
    STRUCT TestResult &tr
    return tr.failure_count
End

Function TR_getErrorCount(tr)
    STRUCT TestResult &tr
    return tr.error_count
End

Function TR_getTestRunCount(tr)
    STRUCT TestResult &tr
    return tr.tests_run
End

Function TR_getSuccessCount(tr)
    STRUCT TestResult &tr
    Variable total_tests = TR_getTestRunCount(tr)
    Variable total_failures = TR_getDefectCount(tr)
    return total_tests - total_failures
End

Function TR_getDefectCount(tr)
    STRUCT TestResult &tr
    return TR_getFailureCount(tr) + TR_getErrorCount(tr)
End

Function TR_addFailure(tr, test, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    String message
    TR_addFailed(tr.failures, tr.failure_count, test, message)
    TR_addRunTest(tr, test, message)
    TP_addFailure(tr.test_printer, test, message)
    tr.failure_count += 1
End

Function TR_addError(tr, test, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    String message
    TR_addFailed(tr.errors, tr.error_count, test, message)
    TR_addRunTest(tr, test, message)
    TP_addError(tr.test_printer, test, message)
    tr.error_count += 1
End

Function TR_addSuccess(tr, test, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    String message
    TR_addRunTest(tr, test, message)
    TP_addSuccess(tr.test_printer, test, message)
End

Function TR_addRunTest(tr, test, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    String message
    tr.tests_run += 1
End

Static Function TR_addFailed(fail_wave, fail_idx, test, message)
    Wave/T fail_wave
    Variable fail_idx
    STRUCT UnitTest &test
    String message

    if (fail_idx+1 > Wave_getRowCount(fail_wave))
        Wave_appendRows(fail_wave, FAILWAVE_BLOCK_SIZE)
    endif
    fail_wave[fail_idx][%group_name] = test.groupname
    fail_wave[fail_idx][%test_name] = test.testname
    fail_wave[fail_idx][%func_name] = test.funcname
    fail_wave[fail_idx][%message] = message
    fail_wave[fail_idx][%stack_info] = Stack_getPartialNegativeIndex(2)
End

Function TR_getFailureByIndex(tr, fail_idx, output_defect)
    STRUCT TestResult &tr
    Variable fail_idx
    STRUCT TestDefect &output_defect
    TR_getDefectByIndex(tr.failures, fail_idx, output_defect)
End

Function TR_getErrorByIndex(tr, fail_idx, output_defect)
    STRUCT TestResult &tr
    Variable fail_idx
    STRUCT TestDefect &output_defect
    TR_getDefectByIndex(tr.errors, fail_idx, output_defect)
End

Function TR_getDefectByIndex(fail_wave, fail_idx, output_defect)
    Wave/T fail_wave
    Variable fail_idx

    STRUCT TestDefect &output_defect

    String groupname = fail_wave[fail_idx][%group_name]
    String testname = fail_wave[fail_idx][%test_name]
    String funcname = fail_wave[fail_idx][%func_name]
    STRUCT UnitTest test
    UnitTest_init(test, groupname, testname, funcname)

    String message = fail_wave[fail_idx][%message]
    String stack_info = fail_wave[fail_idx][%stack_info]
    TD_init(output_defect, test, message, stack_info)
    return 0
End

#endif