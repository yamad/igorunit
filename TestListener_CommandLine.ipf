#pragma rtGlobals=1		// Use modern global access method.

// Command Line TestListener -- a component of IgorUnit
//   This interface responds to TestResult events by emitting output
//   on the command line in real-time

#ifndef IGORUNIT_TL_COMMANDLINE
#define IGORUNIT_TL_COMMANDLINE

#include "TestListener"
#include "OutputFormat"
#include "OutputFormat_Basic"

Function CLTL_init(tl)
    STRUCT TestListener &tl
    TL_init(tl)

    FUNCREF TL_output tl.output_func = CLTL_output
    FUNCREF TL_addTestFailure tl.testfail_func = CLTL_addTestFailure
    FUNCREF TL_addTestSuccess tl.testsuccess_func = CLTL_addTestSuccess
    FUNCREF TL_addTestError tl.testerror_func = CLTL_addTestError
    FUNCREF TL_addTestSuiteEnd tl.ts_end_func = CLTL_addTestSuiteEnd
End

Function/S CLTL_output(tl, out_string)
    STRUCT TestListener &tl
    String out_string
    print out_string
End

Function CLTL_addTestFailure(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to

    String offunc_name = OutputFormat_getFuncName(tl.verbosity, "TestFailure")
    FUNCREF OFnull_TestOutcome offunc = $(offunc_name)
    String out_string = offunc(to)

    TL_output(tl, out_string)
End

Function CLTL_addTestSuccess(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to

    String offunc_name = OutputFormat_getFuncName(tl.verbosity, "TestSuccess")
    FUNCREF OFnull_TestOutcome offunc = $(offunc_name)
    String out_string = offunc(to)
    
    TL_output(tl, out_string)
End

Function CLTL_addTestError(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to

    String offunc_name = OutputFormat_getFuncName(tl.verbosity, "TestError")
    FUNCREF OFnull_TestOutcome offunc = $(offunc_name)
    String out_string = offunc(to)
    
    TL_output(tl, out_string)
End

Function CLTL_addTestStart(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
End

Function CLTL_addTestSuiteEnd(tl, tr, ts)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    TL_output(tl, OFBasic_TestSuiteSummary(tr, ts))
    TL_output(tl, "\r")
    CLTL_listFailures(tl, tr)
    TL_output(tl, "\r")
    CLTL_listErrors(tl, tr)
End

Function CLTL_listFailures(tl, tr)
    STRUCT TestListener &tl
    STRUCT TestResult &tr

    Variable fail_count = TR_getFailureCount(tr)
    if (fail_count == 0)
        return 0
    endif

    TL_output(tl, formatSectionHeader("Test Failures"))

    String fail_idxs = TR_getTestFailureIndices(tr)
    String of_tofunc_name = OutputFormat_getFuncName(tl.verbosity, "TestOutcomeSummary")
    FUNCREF OFnull_TestOutcome of_to_func = $(of_tofunc_name)

    String of_assertfunc_name = OutputFormat_getFuncName(tl.verbosity, "TestAssertSummary")
    FUNCREF OFBasic_TestAssertSummary of_assert_func = $(of_assertfunc_name)
    
    STRUCT TestOutcome to
    STRUCT Assertion assertion
    Variable i, to_idx
    for (i=0; i < fail_count; i+=1)
        to_idx = str2num(List_getItem(fail_idxs, i))
        TR_getTestOutcomeByIndex(tr, to_idx, to)
        TL_output(tl, of_to_func(to))

        String assert_idxs = TR_getAssertFailIndicesByTest(tr, to_idx)
        Variable assert_count = List_getLength(assert_idxs)
        if (assert_count > 0)
            Variable j, a_idx
            for (j=0; j < assert_count; j+=1)
                a_idx = str2num(List_getItem(assert_idxs, j))
                TR_getAssertByIndex(tr, a_idx, assertion)
                TL_output(tl, of_assert_func(to, assertion))
            endfor            
        endif        
        TL_output(tl, formatDefectFooter())
    endfor
End

Function CLTL_listErrors(tl, tr)
    STRUCT TestListener &tl
    STRUCT TestResult &tr

    Variable err_count = TR_getErrorCount(tr)
    if (err_count == 0)
        return 0
    endif

    TL_output(tl, formatSectionHeader("Test Errors"))

    String err_idxs = TR_getTestErrorIndices(tr)
    String offunc_name = OutputFormat_getFuncName(tl.verbosity, "TestOutcomeSummary")
    FUNCREF OFnull_TestOutcome offunc = $(offunc_name)
    
    STRUCT TestOutcome to
    Variable i, idx
    for (i=0; i < err_count; i+=1)
        idx = str2num(List_getItem(err_idxs, i))
        TR_getTestOutcomeByIndex(tr, idx, to)
        TL_output(tl, offunc(to))
        TL_output(tl, formatDefectFooter())
    endfor
End

Function CLTL_addAssertFailure(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
End

Function CLTL_addAssertSuccess(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
End

#endif