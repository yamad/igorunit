#pragma rtGlobals=1		// Use modern global access method.

// TestSuiteRunner -- a component of IgorUnit
//   This data type is used to run the tests contained in a TestSuite

#ifndef IGORUNIT_TSR
#define IGORUNIT_TSR

#include "booleanutils"
#include "datafolderutils"

#include "TestSuite"
#include "TestResult"
#include "TestPrinter"

Structure TestSuiteRunner
    Variable test_run_count
    Variable curr_group_idx
    Variable curr_grouptest_idx
    Variable curr_test_idx
    Variable curr_test_status
    STRUCT TestSuite test_suite
    STRUCT TestResult test_result
EndStructure

Function TSR_persist(tsr, to_dfref)
    STRUCT TestSuiteRunner &tsr
    DFREF to_dfref

    Variable/G to_dfref:test_run_count = tsr.test_run_count
    Variable/G to_dfref:curr_group_idx = tsr.curr_group_idx
    Variable/G to_dfref:curr_grouptest_idx = tsr.curr_grouptest_idx
    Variable/G to_dfref:curr_test_idx = tsr.curr_test_idx
    Variable/G to_dfref:curr_test_status = tsr.curr_test_status

    NewDataFolder/O to_dfref:test_suite
    NewDataFolder/O to_dfref:test_result
    TS_persist(tsr.test_suite, to_dfref:test_suite)
    TR_persist(tsr.test_result, to_dfref:test_result)
End

Function TSR_load(tsr, from_dfref)
    STRUCT TestSuiteRunner &tsr
    DFREF from_dfref

    NVAR test_run_count = from_dfref:test_run_count
    NVAR curr_group_idx = from_dfref:curr_group_idx
    NVAR curr_grouptest_idx = from_dfref:curr_grouptest_idx
    NVAR curr_test_idx = from_dfref:curr_test_idx
    NVAR curr_test_status = from_dfref:curr_test_status

    tsr.test_run_count = test_run_count
    tsr.curr_group_idx = curr_group_idx
    tsr.curr_grouptest_idx = curr_grouptest_idx
    tsr.curr_test_idx = curr_test_idx
    tsr.curr_test_status = curr_test_status
    TS_load(tsr.test_suite, from_dfref:test_suite)
    TR_load(tsr.test_result, from_dfref:test_result)
End

Function TSR_init(tsr, ts)
    STRUCT TestSuiteRunner &tsr
    STRUCT TestSuite &ts

    tsr.test_run_count = 0
    tsr.curr_group_idx = 0
    tsr.curr_grouptest_idx = 0
    tsr.curr_test_idx = 0
    tsr.curr_test_status = TEST_UNKNOWN
    tsr.test_suite = ts

    STRUCT TestResult tr
    TR_init(tr)
    tsr.test_result = tr

    STRUCT TestPrinter tp
    TP_init(tp)
    TR_setPrinter(tr, tp)
End

Function/S TSR_runAllTests(tsr)
    STRUCT TestSuiteRunner &tsr
    TSR_persist(tsr, IgorUnit_getCurrentTSR())
    do
        TSR_load(tsr, IgorUnit_getCurrentTSR())
        if (TSR_isDone(tsr))
            break
        endif
        TSR_runNextTest(tsr)
    while(1)
    String report = TSR_printReport(tsr)
    IgorUnit_clearCurrentTSR()
    return report
End

Function TSR_runNextTest(tsr)
    STRUCT TestSuiteRunner &tsr

    STRUCT UnitTest test
    String testname = TSR_getNextTest(tsr, test)
    TSR_runTest(tsr, test)
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
    FUNCREF protofunc curr_test = $test.funcname

    tsr.curr_test_status = TEST_SUCCESS
    Variable start_time, end_time
    String msg = ""
    TSR_createTestDataFolder(tsr, test.funcname)
    TSR_persist(tsr, IgorUnit_getCurrentTSR())
    UnitTest_persist(test, IgorUnit_getCurrentUnitTest())
    start_time = stopMSTimer(-2)
    try
        group_setup()
        curr_test()
        group_teardown()
        end_time = stopMSTimer(-2)
        TSR_load(tsr, IgorUnit_getCurrentTSR())
    catch
        end_time = stopMSTimer(-2)
        TSR_load(tsr, IgorUnit_getCurrentTSR())
        if (V_AbortCode == ASSERTION_FAILURE)
            // do not run other tests if assertion fails
            // assertion results have already been recorded
            tsr.curr_test_status = TEST_FAILURE
        else
            // handle all other aborts as test errors
            tsr.curr_test_status = TEST_ERROR
            Variable err = GetRTError(1)
            msg = GetErrMessage(err)
        endif
    endtry

    Variable duration = end_time - start_time
    switch(tsr.curr_test_status)
        case TEST_SUCCESS:
            TR_addTestSuccess(tsr.test_result, test, duration, msg)
            break
        case TEST_FAILURE:
            TR_addTestFailure(tsr.test_result, test, duration, msg)
            break
        case TEST_ERROR:
            TR_addTestError(tsr.test_result, test, duration, msg)
            break
        default:
            break
    endswitch

    tsr.test_run_count += 1
    TSR_deleteTestDataFolder(tsr, test.funcname)
    IgorUnit_clearCurrentUnitTest()
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
    return tsr.test_run_count
End

Function TSR_getTestCount(tsr)
    STRUCT TestSuiteRunner &tsr
    return TS_getTestCount(tsr.test_suite)
End

Function/S TSR_getNextTest(tsr, test)
    STRUCT TestSuiteRunner &tsr
    STRUCT UnitTest &test

    if (TSR_isCurrentGroupDone(tsr))
        TSR_getNextGroup(tsr)
    endif

    TS_getGroupTestByIndex(tsr.test_suite, tsr.curr_group_idx, tsr.curr_grouptest_idx, test)
    tsr.curr_grouptest_idx += 1
    tsr.curr_test_idx += 1

    return test.testname
End

Function TSR_getCurrentGroup(tsr)
    STRUCT TestSuiteRunner &tsr
    return tsr.curr_group_idx
End

Function TSR_getNextGroup(tsr)
    STRUCT TestSuiteRunner &tsr
    tsr.curr_group_idx += 1
    tsr.curr_grouptest_idx = 0
    return TSR_getCurrentGroup(tsr)
End

Function TSR_isCurrentGroupDone(tsr)
    STRUCT TestSuiteRunner &tsr

    if (TS_getGroupTestCount(tsr.test_suite, tsr.curr_group_idx) == tsr.curr_grouptest_idx)
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
