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
    Wave tests_run
    Wave assertions
    Wave/T string_store
    Variable test_run_count
    Variable failure_count
    Variable error_count
    Variable assertion_count
    Variable string_count
    STRUCT TestPrinter test_printer
EndStructure

Function TR_persist(tr, to_dfref)
    STRUCT TestResult &tr
    DFREF to_dfref

    Variable/G to_dfref:test_run_count = tr.test_run_count
    Variable/G to_dfref:failure_count = tr.failure_count
    Variable/G to_dfref:error_count = tr.error_count
    Variable/G to_dfref:assertion_count = tr.assertion_count
    Variable/G to_dfref:string_count = tr.string_count

    Duplicate/O tr.tests_run, to_dfref:tr_tests
    Duplicate/O tr.assertions, to_dfref:tr_assertions
    Duplicate/O/T tr.string_store, to_dfref:tr_string_store

    NewDataFolder/O to_dfref:test_printer
    TP_persist(tr.test_printer, to_dfref:test_printer)
End

Function TR_load(tr, from_dfref)
    STRUCT TestResult &tr
    DFREF from_dfref

    NVAR test_run_count = from_dfref:test_run_count
    NVAR failure_count = from_dfref:failure_count
    NVAR error_count = from_dfref:error_count
    NVAR assertion_count = from_dfref:assertion_count
    NVAR string_count = from_dfref:string_count

    Duplicate/O from_dfref:tr_tests, tr.tests_run
    Duplicate/O from_dfref:tr_assertions, tr.assertions
    Duplicate/O/T from_dfref:tr_string_store, tr.string_store

    tr.test_run_count = test_run_count
    tr.failure_count = failure_count
    tr.error_count = error_count
    tr.assertion_count = assertion_count
    tr.string_count = string_count

    TP_load(tr.test_printer, from_dfref:test_printer)
End


Static Constant TESTWAVE_BLOCK_SIZE = 50
Static Constant ASSERTWAVE_BLOCK_SIZE = 100
Static Constant STRINGSTORE_BLOCK_SIZE = 300
Function TR_init(tr)
    STRUCT TestResult &tr

    STRUCT TestPrinter tp
    TP_init(tp)
    TR_setPrinter(tr, tp)

    Make/FREE/N=(TESTWAVE_BLOCK_SIZE,7) tr.tests_run
    SetDimLabel 1, 0, test_idx, tr.tests_run
    SetDimLabel 1, 1, result_code, tr.tests_run
    SetDimLabel 1, 2, test_duration, tr.tests_run    
    SetDimLabel 1, 3, group_name_idx, tr.tests_run    
    SetDimLabel 1, 4, test_name_idx, tr.tests_run    
    SetDimLabel 1, 5, func_name_idx, tr.tests_run
    SetDimLabel 1, 6, msg_idx, tr.tests_run

    Make/FREE/N=(ASSERTWAVE_BLOCK_SIZE,6) tr.assertions
    SetDimLabel 1, 0, test_idx, tr.assertions
    SetDimLabel 1, 1, assert_type, tr.assertions
    SetDimLabel 1, 2, result_code, tr.assertions
    SetDimLabel 1, 3, params_string_idx, tr.assertions
    SetDimLabel 1, 4, msg_string_idx, tr.assertions
    SetDimLabel 1, 5, stack_string_idx, tr.assertions

    Make/FREE/T/N=(STRINGSTORE_BLOCK_SIZE) tr.string_store
    tr.string_store[0] = ""
    tr.string_count = 1

    tr.test_run_count = 0
    tr.failure_count = 0
    tr.error_count = 0
    tr.assertion_count = 0
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
    return tr.test_run_count
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

Function TR_addTestRun(tr, test, result_code, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable result_code
    Variable duration
    String message

    if (tr.test_run_count+1 > Wave_getRowCount(tr.tests_run))
        Wave_appendRows(tr.tests_run, TESTWAVE_BLOCK_SIZE)
    endif

    Variable i = tr.test_run_count
    tr.tests_run[i][%test_idx] = UnitTest_getIndex(test)
    tr.tests_run[i][%result_code] = result_code
    tr.tests_run[i][%test_duration] = duration
    tr.tests_run[i][%group_name_idx] = TR_storeString(tr, UnitTest_getGroupname(test))
    tr.tests_run[i][%test_name_idx] = TR_storeString(tr, UnitTest_getTestname(test))
    tr.tests_run[i][%func_name_idx] = TR_storeString(tr, UnitTest_getFuncname(test))
    tr.tests_run[i][%msg_idx] = TR_storeString(tr, message)
    tr.test_run_count += 1
End

Function TR_addTestFailure(tr, test, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable duration
    String message
    TR_addTestRun(tr, test, TEST_FAILURE, duration, message)
    TP_addFailure(tr.test_printer, test, message)
    tr.failure_count += 1
End

Function TR_addTestError(tr, test, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable duration
    String message
    TR_addTestRun(tr, test, TEST_ERROR, duration, message)
    TP_addError(tr.test_printer, test, message)
    tr.error_count += 1
End

Function TR_addTestSuccess(tr, test, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable duration
    String message
    TR_addTestRun(tr, test, TEST_SUCCESS, duration, message)
    TP_addSuccess(tr.test_printer, test, message)
End

Function TR_addAssertSuccess(tr, test, assertion)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    TR_addAssertionRun(tr, test, assertion, ASSERTION_SUCCESS)
End

Function TR_addAssertFailure(tr, test, assertion)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    TR_addAssertionRun(tr, test, assertion, ASSERTION_FAILURE)
End

Function TR_addAssertionRun(tr, test, assertion, result_code)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    Variable result_code

    if (tr.assertion_count+1 > Wave_getRowCount(tr.assertions))
        Wave_appendRows(tr.assertions, ASSERTWAVE_BLOCK_SIZE)
    endif

    Variable i = tr.assertion_count

    tr.assertions[i][%test_idx] = UnitTest_getIndex(test)
    tr.assertions[i][%assert_type] = Assertion_getType(assertion)
    tr.assertions[i][%result_code] = result_code
    tr.assertions[i][%params_string_idx] = TR_storeString(tr, Assertion_getParams(assertion))
    tr.assertions[i][%stack_string_idx] = TR_storeString(tr, Assertion_getStack(assertion))
    tr.assertions[i][%msg_string_idx] = TR_storeString(tr, Assertion_getMessage(assertion))

    tr.assertion_count += 1
End

Static Function TR_storeString(tr, string_to_save)
    STRUCT TestResult &tr
    String string_to_save

    Variable idx = tr.string_count
    if (idx+1 > Wave_getRowCount(tr.string_store))
        Wave_appendRows(tr.string_store, STRINGSTORE_BLOCK_SIZE)
    endif

    if (strlen(string_to_save) > 0)
        tr.string_store[idx] = string_to_save
        tr.string_count += 1
    else
        return 0
    endif
    return idx
End

Static Function/S TR_getStoredString(tr, string_idx)
    STRUCT TestResult &tr
    Variable string_idx
    return tr.string_store[string_idx]
End

// Function TR_getFailureByIndex(tr, fail_idx, output_defect)
//     STRUCT TestResult &tr
//     Variable fail_idx
//     STRUCT TestDefect &output_defect
//     TR_getDefectByIndex(tr.failures, fail_idx, output_defect)
// End

// Function TR_getErrorByIndex(tr, fail_idx, output_defect)
//     STRUCT TestResult &tr
//     Variable fail_idx
//     STRUCT TestDefect &output_defect
//     TR_getDefectByIndex(tr.errors, fail_idx, output_defect)
// End

// Function TR_getDefectByIndex(fail_wave, fail_idx, output_defect)
//     Wave/T fail_wave
//     Variable fail_idx

//     STRUCT TestDefect &output_defect

//     String groupname = fail_wave[fail_idx][%group_name]
//     String testname = fail_wave[fail_idx][%test_name]
//     String funcname = fail_wave[fail_idx][%func_name]
//     STRUCT UnitTest test
//     UnitTest_init(test, groupname, testname, funcname)

//     String message = fail_wave[fail_idx][%message]
//     String stack_info = fail_wave[fail_idx][%stack_info]
//     TD_init(output_defect, test, message, stack_info)
//     return 0
// End

#endif