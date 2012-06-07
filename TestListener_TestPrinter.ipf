#pragma rtGlobals=1		// Use modern global access method.

// TestPrinter TestListener -- a component of IgorUnit
//   This interface responds to TestResult events by emitting output (printing!)

#ifndef IGORUNIT_TL_TESTPRINTER
#define IGORUNIT_TL_TESTPRINTER

#include "TestListener"
#include "OutputFormat"

Function TLTP_init(tl)
    STRUCT TestListener &tl
    TL_init(tl)
    TL_setFuncPointers(tl, "TLTP")
End

Function/S TLTP_output(tl, out_string)
    STRUCT TestListener &tl
    String out_string
    printf, "%s", out_string
End

Function/S TLTP_outputToString(tl, out_string)
    STRUCT TestListener &tl
    String out_string
    tl.output += out_string
End

Function TLTP_addTestFailure(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_TestFailure(of, to))
End

Function TLTP_addTestSuccess(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_TestSuccess(of, to))
End

Function TLTP_addTestError(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_TestError(of, to))
End

Function TLTP_addTestIgnore(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_TestIgnore(of, to))
End

Function TLTP_addGroupStart(tl, tr, groupname)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    String groupname

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_GroupStart(of, groupname))
End

Function TLTP_addTestStart(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_TestStart(of, test))
End

Function TLTP_addTestEnd(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
End

Function TLTP_addAssertFailure(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_AssertFailure(of, test, assertion))
End

Function TLTP_addAssertSuccess(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, OF_AssertSuccess(of, test, assertion))
End

Function TLTP_addTestSuiteStart(tl, tr, ts)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
End

Function TLTP_addTestSuiteEnd(tl, tr, ts)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestSuite &ts

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, "\r")
    TL_output(tl, OF_TestSuiteSummary(of, tr, ts))
    TL_output(tl, "\r")
    TLTP_listFailures(tl, tr)
    TL_output(tl, "\r")
    TLTP_listErrors(tl, tr)
End

Function TLTP_listFailures(tl, tr)
    STRUCT TestListener &tl
    STRUCT TestResult &tr

    Variable fail_count = TR_getFailureCount(tr)
    if (fail_count == 0)
        return 0
    endif

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, formatSectionHeader("Test Failures"))

    String fail_idxs = TR_getTestFailureIndices(tr)

    STRUCT TestOutcome to
    STRUCT Assertion assertion
    Variable i, to_idx
    for (i=0; i < fail_count; i+=1)
        to_idx = str2num(List_getItem(fail_idxs, i))
        TR_getTestOutcomeByIndex(tr, to_idx, to)
        TL_output(tl, OF_TestOutcomeSummary(of, to))

        String assert_idxs = TR_getAssertFailIndicesByTest(tr, to_idx)
        Variable assert_count = List_getLength(assert_idxs)
        if (assert_count > 0)
            Variable j, a_idx
            for (j=0; j < assert_count; j+=1)
                a_idx = str2num(List_getItem(assert_idxs, j))
                TR_getAssertByIndex(tr, a_idx, assertion)
                TL_output(tl, OF_AssertionSummary(of, to, assertion))
            endfor
        endif
        TL_output(tl, formatDefectFooter())
    endfor
End

Function TLTP_listErrors(tl, tr)
    STRUCT TestListener &tl
    STRUCT TestResult &tr

    Variable err_count = TR_getErrorCount(tr)
    if (err_count == 0)
        return 0
    endif

    STRUCT OutputFormat of
    OutputFormat_factory(tl.verbosity, of)

    TL_output(tl, formatSectionHeader("Test Errors"))

    String err_idxs = TR_getTestErrorIndices(tr)
    STRUCT TestOutcome to
    Variable i, idx
    for (i=0; i < err_count; i+=1)
        idx = str2num(List_getItem(err_idxs, i))
        TR_getTestOutcomeByIndex(tr, idx, to)
        TL_output(tl, OF_TestOutcomeSummary(of, to))
        TL_output(tl, formatDefectFooter())
    endfor
End

#endif