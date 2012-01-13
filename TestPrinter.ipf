#pragma rtGlobals=1             // Use modern global access method.

// TestPrinter -- a component of IgorUnit
//   This interface is responsible for printing the results of a test run

#ifndef IGORUNIT_TESTPRINTER
#define IGORUNIT_TESTPRINTER

#include "booleanutils"

#include "UnitTest"

Structure TestPrinter
    String output
    Variable is_verbose
EndStructure

Function TP_persist(tp, to_dfpath)
    STRUCT TestPrinter &tp
    String to_dfpath
    DFREF to_dfref = DataFolder_create(to_dfpath)
    String/G to_dfref:output = tp.output
    Variable/G to_dfref:is_verbose = tp.is_verbose
End

Function TP_load(tp, from_dfpath)
    STRUCT TestPrinter &tp
    String from_dfpath
    DFREF from_dfref = DataFolder_getDFRfromPath(from_dfpath)

    SVAR output = from_dfref:output
    NVAR is_verbose = from_dfref:is_verbose

    tp.output = output
    tp.is_verbose = is_verbose

    KillDataFolder from_dfref
End

Function TP_init(tp)
    STRUCT TestPrinter &tp 
    tp.output = ""
    tp.is_verbose = FALSE
End

Function TP_setVerbose(tp, is_verbose)
    STRUCT TestPrinter &tp
    Variable is_verbose
    tp.is_verbose = is_verbose
End

Function TP_addFailure(tp, test, message)
    STRUCT TestPrinter &tp
    STRUCT UnitTest &test
    String message

    if (tp.is_verbose == TRUE)
        tp.output += formatRunVerboseFailure(test)
    else
        tp.output += formatRunBasicFailure(test)
    endif
End

Function TP_addError(tp, test, message)
    STRUCT TestPrinter &tp
    STRUCT UnitTest &test
    String message

    if (tp.is_verbose == TRUE)
        tp.output += formatRunVerboseError(test)
    else
        tp.output += formatRunBasicError(test)
    endif
End

Function TP_addSuccess(tp, test, message)
    STRUCT TestPrinter &tp
    STRUCT UnitTest &test
    String message

    if (tp.is_verbose == TRUE)
        tp.output += formatRunVerboseSuccess(test)
    else
        tp.output += formatRunBasicSuccess(test)
    endif
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

Function TP_generateReport(tp, tr)
    STRUCT TestPrinter &tp
    STRUCT TestResult &tr

    if (tp.is_verbose == TRUE)
        tp.output += formatSectionFooter()
    else
        tp.output += "\r"
    endif
    tp.output += formatSummary(tr)
    if (TR_getDefectCount(tr) > 0)
        tp.output += "\r"
        tp.output += formatAllErrors(tr)
        tp.output += formatAllFailures(tr)
    else
        tp.output += "OK!\r"
    endif
End

Function/S TP_getOutput(tp)
    STRUCT TestPrinter &tp
    return tp.output
End

Function TP_clearOutput(tp)
    STRUCT TestPrinter &tp
    tp.output = ""
End

Function/S formatSummary(test_result)
    STRUCT TestResult &test_result

    Variable test_count = TR_getTestRunCount(test_result)
    Variable success_count = TR_getSuccessCount(test_result)
    Variable failure_count = TR_getFailureCount(test_result)
    Variable error_count = TR_getErrorCount(test_result)

    String summary_msg
    sprintf summary_msg, "%d tests run: %d successes, %d failures, %d errors\r", test_count, success_count, failure_count, error_count
    return summary_msg
End

Function/S formatSectionHeader(header_text)
    String header_text
    String section_header = ""
    section_header += header_text + "\r"
    section_header += "======================================\r"
    return section_header
End

Function/S formatSectionFooter()
    String section_footer = ""
    section_footer += "--------------------------------------\r"
    return section_footer
End

Function/S formatDefectFooter()
    String defect_footer = ""
    defect_footer += "--------------------------------------\r"
    return defect_footer
End

Function/S formatDefect(td)
    STRUCT TestDefect &td

    String groupname = TD_getGroupname(td)
    String testname = TD_getTestname(td)
    String filename = TD_getFilename(td)
    Variable linenum = TD_getLineNumber(td)
    String message = TD_getMessage(td)

    String defect_summary
    sprintf defect_summary, "%s, %s in %s at line %d\r", groupname, testname, filename, linenum

    String msg_line
    sprintf msg_line, "\t%s\r", message
    defect_summary += msg_line
    return defect_summary
End

Function/S formatAllErrors(tr)
    STRUCT TestResult &tr
    Variable error_count = TR_getErrorCount(tr)
    if (error_count == 0)
        return ""
    endif

    String error_section = ""
    error_section += formatSectionHeader("Test Errors")

    Variable i
    STRUCT TestDefect td
    for (i=0; i < error_count; i+=1)
        TR_getErrorByIndex(tr, i, td)
        error_section += formatDefect(td)
        error_section += formatDefectFooter()
    endfor
    return error_section
End

Function/S formatAllFailures(tr)
    STRUCT TestResult &tr
    Variable fail_count = TR_getFailureCount(tr)
    if (fail_count == 0)
        return ""
    endif

    String fail_section = ""
    fail_section += formatSectionHeader("Test Failures")

    Variable i
    STRUCT TestDefect td
    for (i=0; i < fail_count; i+=1)
        TR_getFailureByIndex(tr, i, td)
        fail_section += formatDefect(td)
        fail_section += formatDefectFooter()
    endfor
    return fail_section
End

#endif