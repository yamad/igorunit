#pragma rtGlobals=1		// Use modern global access method.

// TestSuiteRunner -- a component of IgorUnit
//   This data type is used to run the tests contained in a TestSuite

#ifndef IGORUNIT_TSR
#define IGORUNIT_TSR

#include "boolean"
#include "utils"

#include "TestSuite"
#include "TestResult"

Structure TestSuiteRunner
    Variable successes
    Variable failures
    Variable errors
    Variable tests_run
    Variable curr_group_idx
    Variable curr_grouptest_idx
    Variable curr_test_idx
    STRUCT TestSuite test_suite
    STRUCT TestResult test_result
EndStructure

Function TSR_init(tsr, ts)
    STRUCT TestSuiteRunner &tsr
    STRUCT TestSuite &ts

    STRUCT TestResult tr
    TR_init(tr)

    tsr.successes = 0
    tsr.failures = 0
    tsr.errors = 0
    tsr.tests_run = 0
    tsr.curr_group_idx = 0
    tsr.curr_grouptest_idx = 0
    tsr.curr_test_idx = 0
    tsr.test_suite = ts
    tsr.test_result = tr
End

Function TSR_runAllTests(tsr)
    STRUCT TestSuiteRunner &tsr

    do
        if (TSR_isDone(tsr))
            break
        endif
        TSR_runNextTest(tsr)
    while(1)

    TSR_printReport(tsr)
End

Function TSR_runNextTest(tsr)
    STRUCT TestSuiteRunner &tsr

    String testname = TSR_getNextTest(tsr)
    String groupname = TSR_getCurrentGroup(tsr)
    TSR_runTest(tsr, groupname, testname)
End

Function TSR_runTest(tsr, groupname, testname)
    STRUCT TestSuiteRunner &tsr
    String groupname, testname

    String setupname = groupname + "_setup"
    String teardownname = groupname + "_teardown"

    FUNCREF prototest group_setup = $setupname
    FUNCREF prototest curr_test = $testname
    FUNCREF prototest group_teardown = $teardownname

    tsr.tests_run += 1
    TSR_createTestDataFolder(tsr, testname)
    try
        group_setup()
        curr_test()
        group_teardown()
    catch
        print 0
    endtry

    // wrapup test
    TSR_deleteTestDataFolder(tsr, testname)
    Variable status = 1
    printTestResult(testname, status)
    TSR_saveTestResult(tsr, status)
End

Function TSR_createTestDataFolder(tsr, testname)
    STRUCT TestSuiteRunner &tsr
    String testname

    String foldername = "Test_" + testname
    NewDataFolder/O/S root:$foldername
End

Function TSR_deleteTestDataFolder(tsr, testname)
    STRUCT TestSuiteRunner &tsr
    String testname

    String foldername = "Test_" + testname
    KillDataFolder root:$foldername
End

Static Function TSR_saveTestResult(tsr, status)
    STRUCT TestSuiteRunner &tsr
    Variable status

    if (status == TRUE)
        tsr.successes += 1
    else
        tsr.failures += 1
    endif
End

Function TSR_printReport(tsr)
    STRUCT TestSuiteRunner &tsr

    Variable test_no = TSR_getRunTestCount(tsr)
    printf "%d tests run: %d successes, %d failures\r", test_no, tsr.successes, tsr.failures
End

Function TSR_getRunTestCount(tsr)
    STRUCT TestSuiteRunner &tsr
    return tsr.tests_run
End

Function TSR_getTestCount(tsr)
    STRUCT TestSuiteRunner &tsr
    return TS_getTestCount(tsr.test_suite)
End

Function/S TSR_getNextTest(tsr)
    STRUCT TestSuiteRunner &tsr

    if (TSR_isCurrentGroupDone(tsr))
        TSR_getNextGroup(tsr)
    endif

    String testname = TS_getTestByIndex(tsr.test_suite, tsr.curr_group_idx, tsr.curr_grouptest_idx)
    tsr.curr_grouptest_idx += 1
    tsr.curr_test_idx += 1

    return testname
End

Function/S TSR_getCurrentGroup(tsr)
    STRUCT TestSuiteRunner &tsr
    return TS_getGroupByIndex(tsr.test_suite, tsr.curr_group_idx)
End

Function/S TSR_getNextGroup(tsr)
    STRUCT TestSuiteRunner &tsr

    String groupname = TSR_getCurrentGroup(tsr)
    tsr.curr_group_idx += 1
    tsr.curr_grouptest_idx = 0
    return groupname
End

Function TSR_isCurrentGroupDone(tsr)
    STRUCT TestSuiteRunner &tsr

    String groupname = TSR_getCurrentGroup(tsr)
    if (TS_getGroupTestCount(tsr.test_suite, groupname) == tsr.curr_test_idx)
        return TRUE
    endif
    return FALSE
End

Function TSR_isDone(tsr)
    STRUCT TestSuiteRunner &tsr

    if (tsr.curr_test_idx >= TSR_getTestCount(tsr))
        return TRUE
    endif
    return FALSE
End

#endif