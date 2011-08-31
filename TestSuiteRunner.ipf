#pragma rtGlobals=1		// Use modern global access method.

// TestSuiteRunner -- a component of IgorUnit
//   This data type is used to run the tests contained in a TestSuite

#ifndef IGORUNIT_TSR
#define IGORUNIT_TSR

#include "boolean"
#include "utils"
#include "TestSuite"

Structure TestSuiteRunner
    Variable successes
    Variable failures
    Variable curr_group_idx
    Variable curr_test_idx
    STRUCT TestSuite test_suite
EndStructure

Function TSR_init(tsr, ts)
    STRUCT TestSuiteRunner &tsr
    STRUCT TestSuite &ts

    tsr.successes = 0
    tsr.failures = 0
    tsr.curr_group_idx = 0
    tsr.curr_test_idx = 0
    tsr.test_suite = ts
End

Function TSR_runAllTests(tsr)
    STRUCT TestSuiteRunner &tsr

    do
        if (!TSR_isDone(tsr))
            break
        endif

        TSR_runNextTest(tsr)
    while(1)

    TSR_printReport(tsr)
End

Function TSR_runNextTest(tsr)
    STRUCT TestSuiteRunner &tsr

    String testname = TSR_getNextTest(tsr)
    TSR_runTest(tsr, testname)
End

Function TSR_runTest(tsr, testname)
    STRUCT TestSuiteRunner &tsr
    String testname

    FUNCREF prototest curr_test = $testname

    print testname
    Variable status = curr_test()
    printTestResult(testname, status)
    TSR_saveTestResult(tsr, status)
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

    Variable test_no = TSR_getTestCount(tsr)
    printf "%d tests run: %d successes, %d failures\r", test_no, tsr.successes, tsr.failures
End

Function TSR_getTestCount(tsr)
    STRUCT TestSuiteRunner &tsr
    return TS_getTestCount(tsr.test_suite)
End

Function/S TSR_getNextTest(tsr)
    STRUCT TestSuiteRunner &tsr
    
    String testname = TS_getTestByIndex(tsr.test_suite, tsr.curr_group_idx, tsr.curr_test_idx)
    tsr.curr_test_idx += 1

    return testname
End

Function TSR_isDone(tsr)
    STRUCT TestSuiteRunner &tsr

    if (tsr.curr_test_idx >= TSR_getTestCount(tsr))
        return TRUE
    endif
    return FALSE
End

#endif