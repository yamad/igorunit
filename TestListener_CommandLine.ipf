#pragma rtGlobals=1		// Use modern global access method.

// Command Line TestListener -- a component of IgorUnit
//   This interface responds to TestResult events by emitting output
//   on the command line in real-time

#ifndef IGORUNIT_TL_COMMANDLINE
#define IGORUNIT_TL_COMMANDLINE

#include "TestListener"

Function CLTL_init(tl)
    STRUCT TestListener &tl
    TL_init(tl)

    FUNCREF TL_output tl.output_func = CLTL_output
    FUNCREF TL_addTestFailure tl.testfail_func = CLTL_addTestFailure
    FUNCREF TL_addTestSuccess tl.testsuccess_func = CLTL_addTestSuccess
    FUNCREF TL_addTestError tl.testerror_func = CLTL_addTestError
End

Function/S CLTL_output(tl, out_string)
    STRUCT TestListener &tl
    String out_string
    print out_string
End

Function CLTL_addTestFailure(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test

    String out_string
    if (tl.verbosity != VERBOSITY_LOW)
        out_string = formatRunVerboseFailure(test)
        TL_output(tl, out_string)
    else
        out_string = formatRunBasicFailure(test)
        TL_output(tl, out_string)
    endif
End

Function CLTL_addTestSuccess(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test

    String out_string
    if (tl.verbosity != VERBOSITY_LOW)
        out_string = formatRunVerboseSuccess(test)
        TL_output(tl, out_string)
    else
        out_string = formatRunBasicSuccess(test)
        TL_output(tl, out_string)
    endif
End

Function CLTL_addTestError(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test

    String out_string
    if (tl.verbosity > VERBOSITY_LOW)
        out_string = formatRunVerboseError(test)
        TL_output(tl, out_string)
    else
        out_string = formatRunBasicError(test)
        TL_output(tl, out_string)
    endif
End

Function CLTL_addTestStart(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
End

Function CLTL_addTestEnded(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
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

Function/S formatRunBasicFailure(test)
    STRUCT UnitTest &test
    return "F"
End

Function/S formatRunVerboseFailure(test)
    STRUCT UnitTest &test
    return formatRunVerbose(test, "FAIL")
End

Function/S formatRunBasicError(test)
    STRUCT UnitTest &test
    return "E"
End

Function/S formatRunVerboseError(test)
    STRUCT UnitTest &test
    return formatRunVerbose(test, "ERROR")
End

Function/S formatRunBasicSuccess(test)
    STRUCT UnitTest &test
    return "."
End

Function/S formatRunVerboseSuccess(test)
    STRUCT UnitTest &test
    return formatRunVerbose(test, "OK")
End

Function/S formatRunVerbose(test, result_string)
    STRUCT UnitTest &test
    String result_string
    String result_line

    String test_desc
    sprintf test_desc, "%s, %s", test.groupname, test.testname

    String dashes = formatVerboseDashes(test_desc)
    sprintf result_line, "%s %s %s\r", test_desc, dashes, result_string
    return result_line
End

Constant DASH_COLUMN = 50
Function/S formatVerboseDashes(test_description)
    String test_description

    String res_dashes = ""
    Variable dash_length = DASH_COLUMN - strlen(test_description)
    Variable i
    for (i=0; i< dash_length; i+=1)
        res_dashes += "."
    endfor
    return res_dashes
End

#endif