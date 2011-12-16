#pragma rtGlobals=1		// Use modern global access method.

// TestSuiteRunner -- a component of IgorUnit
//   This data type is used to run the tests contained in a TestSuite

#ifndef IGORUNIT_TSR
#define IGORUNIT_TSR

#include "boolean"

#include "TestSuite"
#include "TestResult"
#include "TestPrinter"

Structure TestSuiteRunner
    Variable tests_run
    Variable curr_group_idx
    Variable curr_grouptest_idx
    Variable curr_test_idx
    STRUCT TestSuite test_suite
    STRUCT TestResult test_result
    STRUCT TestPrinter test_printer
EndStructure

Function TSR_init(tsr, ts)
    STRUCT TestSuiteRunner &tsr
    STRUCT TestSuite &ts

    tsr.tests_run = 0
    tsr.curr_group_idx = 0
    tsr.curr_grouptest_idx = 0
    tsr.curr_test_idx = 0
    tsr.test_suite = ts

    STRUCT TestResult tr
    TR_init(tr)
    tsr.test_result = tr

    STRUCT TestPrinter tp
    TP_init(tp)
    tsr.test_printer = tp
    TR_setPrinter(tr, tp)
End

Function/S TSR_runAllTests(tsr)
    STRUCT TestSuiteRunner &tsr
    do
        if (TSR_isDone(tsr))
            break
        endif
        TSR_runNextTest(tsr)
    while(1)
    return TSR_printReport(tsr)
End

Function TSR_runNextTest(tsr)
    STRUCT TestSuiteRunner &tsr

    String testname = TSR_getNextTest(tsr)
    String groupname = TSR_getCurrentGroup(tsr)
    STRUCT UnitTest test
    TS_getTest(tsr.test_suite, groupname, testname, test)
    TSR_runTest(tsr, test)
End

// Stub for function references
Function prototest(tr)
    STRUCT TestResult &tr
End

Function protofunc()
End

Function TSR_runTest(tsr, test)
    STRUCT TestSuiteRunner &tsr
    STRUCT UnitTest &test

    String setupname = getGroupSetupName(test.groupname)
    String teardownname = getGroupTeardownName(test.groupname)

    FUNCREF protofunc group_setup = $setupname
    FUNCREF protofunc group_teardown = $teardownname
    FUNCREF prototest curr_test = $test.funcname

    TSR_createTestDataFolder(tsr, test.funcname)
    try
        group_setup()
        curr_test(tsr.test_result)
        group_teardown()
    catch
        Variable err = GetRTError(1)
        String msg = GetErrMessage(err)
        TR_addError(tsr.test_result, test, msg)
    endtry
    TSR_deleteTestDataFolder(tsr, test.funcname)
End

Function/S getGroupSetupName(groupname)
    String groupname
    return groupname + "_setup"
End

Function/S getGroupTeardownName(groupname)
    String groupname
    return groupname + "_teardown"
End

Function TSR_createTestDataFolder(tsr, name)
    STRUCT TestSuiteRunner &tsr
    String name

    String foldername = "Test_" + name
    NewDataFolder/O/S root:$foldername
End

Function TSR_deleteTestDataFolder(tsr, name)
    STRUCT TestSuiteRunner &tsr
    String name

    String foldername = "Test_" + name
    KillDataFolder root:$foldername
End

Function/S TSR_printReport(tsr)
    STRUCT TestSuiteRunner &tsr

    STRUCT TestPrinter tp
    TR_getPrinter(tsr.test_result, tp)
    TP_generateReport(tp, tsr.test_result)
    return TP_getOutput(tp)
End

Function TSR_printReportToFile(tsr, fileref)
    STRUCT TestSuiteRunner &tsr
    Variable fileref

    STRUCT TestPrinter tp
    TR_getPrinter(tsr.test_result, tp)
    TP_generateReport(tp, tsr.test_result)
    fprintf fileref, "%s", TP_getOutput(tp)
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
    if (TS_getGroupTestCount(tsr.test_suite, groupname) == tsr.curr_grouptest_idx)
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
