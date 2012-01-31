#pragma rtGlobals=1		// Use modern global access method.

// TestResult -- a component of IgorUnit
//   This data type collects the results of tests

#ifndef IGORUNIT_TESTRESULT
#define IGORUNIT_TESTRESULT

#include "waveutils"
#include "stackinfoutils"

#include "UnitTest"
#include "TestDefect"
#include "TestListener"
#include "TestListener_CommandLine"

Static Constant LISTENER_MAX_COUNT = 20

Structure TestResult
    Wave tests_run
    Wave assertions
    Wave/T string_store
    Variable test_run_count
    Variable failure_count
    Variable error_count
    Variable assertion_count
    Variable string_count
    Variable listener_count
    STRUCT TestListener test_listeners[LISTENER_MAX_COUNT]
EndStructure

Function TR_persist(tr, to_dfref)
    STRUCT TestResult &tr
    DFREF to_dfref

    if (!isDataFolderExists(to_dfref))
        NewDataFolder to_dfref
    endif

    Variable/G to_dfref:test_run_count = tr.test_run_count
    Variable/G to_dfref:failure_count = tr.failure_count
    Variable/G to_dfref:error_count = tr.error_count
    Variable/G to_dfref:assertion_count = tr.assertion_count
    Variable/G to_dfref:string_count = tr.string_count
    Variable/G to_dfref:listener_count = tr.listener_count

    Duplicate/O tr.tests_run, to_dfref:tests
    Duplicate/O tr.assertions, to_dfref:tr_assertions
    Duplicate/O/T tr.string_store, to_dfref:tr_string_store

    Variable i
    for (i=0; i<tr.listener_count; i+=1)
        String listen_name = "test_listener"+num2str(i)
        NewDataFolder/O to_dfref:$(listen_name)
        TL_persist(tr.test_listeners[i], to_dfref:$(listen_name))
    endfor
End

Function TR_load(tr, from_dfref)
    STRUCT TestResult &tr
    DFREF from_dfref

    NVAR test_run_count = from_dfref:test_run_count
    NVAR failure_count = from_dfref:failure_count
    NVAR error_count = from_dfref:error_count
    NVAR assertion_count = from_dfref:assertion_count
    NVAR string_count = from_dfref:string_count
    NVAR listener_count = from_dfref:listener_count

    Duplicate/O from_dfref:tests, tr.tests_run
    Duplicate/O from_dfref:tr_assertions, tr.assertions
    Duplicate/O/T from_dfref:tr_string_store, tr.string_store

    tr.test_run_count = test_run_count
    tr.failure_count = failure_count
    tr.error_count = error_count
    tr.assertion_count = assertion_count
    tr.string_count = string_count
    tr.listener_count = listener_count

    Variable i
    for (i=0; i<tr.listener_count; i+=1)
        String listen_name = "test_listener"+num2str(i)
        TL_load(tr.test_listeners[i], from_dfref:$(listen_name))
    endfor
End

Static Constant TESTWAVE_BLOCK_SIZE = 50
Static Constant ASSERTWAVE_BLOCK_SIZE = 100
Static Constant STRINGSTORE_BLOCK_SIZE = 300
Function TR_init(tr)
    STRUCT TestResult &tr

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
    tr.listener_count = 0

    STRUCT TestListener tl
    CLTL_init(tl)
    TR_registerListener(tr, tl)
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
    TR_notifyTestFailure(tr, test, duration, message)
    tr.failure_count += 1
End

Function TR_addTestError(tr, test, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable duration
    String message
    TR_addTestRun(tr, test, TEST_ERROR, duration, message)
//    TP_addError(tr.test_printer, test, message)
    tr.error_count += 1
End

Function TR_addTestSuccess(tr, test, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable duration
    String message
    TR_addTestRun(tr, test, TEST_SUCCESS, duration, message)
    TR_notifyTestSuccess(tr, test, duration, message)
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

    Assertion_setResult(assertion, result_code)
    Assertion_setTest(assertion, test)
    Variable i = tr.assertion_count

    tr.assertions[i][%test_idx] = UnitTest_getIndex(test)
    tr.assertions[i][%assert_type] = Assertion_getType(assertion)
    tr.assertions[i][%result_code] = result_code
    tr.assertions[i][%params_string_idx] = TR_storeString(tr, Assertion_getParams(assertion))
    tr.assertions[i][%stack_string_idx] = TR_storeString(tr, Assertion_getStack(assertion))
    tr.assertions[i][%msg_string_idx] = TR_storeString(tr, Assertion_getMessage(assertion))

    tr.assertion_count += 1
End

Function TR_addTestSuiteStart(tr, ts)
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    TR_notifyTestSuiteStart(tr, ts)
End

Function TR_addTestSuiteEnd(tr, ts)
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    TR_notifyTestSuiteEnd(tr, ts)
End

Function TR_notifyTestSuiteStart(tr, ts)
    STRUCT TestResult &tr
    STRUCT TestSuite &ts

    Variable i
    for (i=0; i<tr.listener_count; i+=1)
        TL_addTestSuiteStart(tr.test_listeners[i], tr, ts)
    endfor
End

Function TR_notifyTestSuiteEnd(tr, ts)
    STRUCT TestResult &tr
    STRUCT TestSuite &ts

    Variable i
    for (i=0; i<tr.listener_count; i+=1)
        TL_addTestSuiteEnd(tr.test_listeners[i], tr, ts)
    endfor
End

Function TR_notifyTestSuccess(tr, test, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable duration
    String message
    
    Variable i
    for (i=0; i<tr.listener_count; i+=1)
        TL_addTestSuccess(tr.test_listeners[i], tr, test)
    endfor
End

Function TR_notifyTestFailure(tr, test, duration, message)
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    Variable duration
    String message
    
    Variable i
    for (i=0; i<tr.listener_count; i+=1)
        TL_addTestFailure(tr.test_listeners[i], tr, test)
    endfor
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

Function TR_registerListener(tr, tl)
    STRUCT TestResult &tr
    STRUCT TestListener &tl

    if (tr.listener_count > LISTENER_MAX_COUNT)
        Abort "Too many registered listeners"
    endif

    tr.test_listeners[tr.listener_count] = tl
    tr.listener_count += 1
End

Function TR_getTestRunByIndex(tr, testrun_idx, output_defect)
    STRUCT TestResult &tr
    Variable testrun_idx
    STRUCT TestDefect &output_defect

    Variable test_idx = tr.tests_run[testrun_idx][%test_idx]
    Variable result_code = tr.tests_run[testrun_idx][%result_code]
    Variable duration = tr.tests_run[testrun_idx][%test_duration]
    String group_name = TR_getStoredString(tr, tr.tests_run[testrun_idx][%group_name_idx])
    String test_name = TR_getStoredString(tr, tr.tests_run[testrun_idx][%test_name_idx])
    String func_name = TR_getStoredString(tr, tr.tests_run[testrun_idx][%func_name_idx])
    String message = TR_getStoredString(tr, tr.tests_run[testrun_idx][%msg_idx])

    STRUCT UnitTest test
    UnitTest_init(test, group_name, test_name, func_name)
    UnitTest_setIndex(test, test_idx)
    TD_init(output_defect, test, duration, result_code, message)
    return 0
End

Function TR_getAssertByIndex(tr, assert_idx, output_assert)
    STRUCT TestResult &tr
    Variable assert_idx
    STRUCT Assertion &output_assert

    Variable test_idx = tr.assertions[assert_idx][%test_idx]
    Variable assert_type = tr.assertions[assert_idx][%assert_type]
    Variable result_code = tr.assertions[assert_idx][%result_code]
    String param_list = TR_getStoredString(tr, tr.assertions[assert_idx][%params_string_idx])
    String stack_info = TR_getStoredString(tr, tr.assertions[assert_idx][%stack_string_idx])
    String message = TR_getStoredString(tr, tr.assertions[assert_idx][%msg_string_idx])

    Assertion_set(output_assert, assert_type, param_list, stack_info, message)
    Assertion_setResult(output_assert, result_code)
    Assertion_setTestIndex(output_assert, test_idx)
    return 0
End

#endif