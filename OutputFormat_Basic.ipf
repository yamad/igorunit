#ifndef IGORUNIT_OUTPUTFORMAT_BASIC
#define IGORUNIT_OUTPUTFORMAT_BASIC

#include "stringutils"

Function/S OFnull_TestOutcome(to)
    STRUCT TestOutcome &to
End 

Function/S OFBasic_TestSuccess(to)
    STRUCT TestOutcome &to
    return "."
End

Function/S OFBasic_TestFailure(to)
    STRUCT TestOutcome &to
    return "F"
End

Function/S OFBasic_TestError(to)
    STRUCT TestOutcome &to
    return "E"
End

Function/S OFBasic_TestSuiteSummary(tr, ts)
    STRUCT TestResult &tr
    STRUCT TestSuite &ts

    Variable test_count = TR_getTestRunCount(tr)
    Variable success_count = TR_getSuccessCount(tr)
    Variable failure_count = TR_getFailureCount(tr)
    Variable error_count = TR_getErrorCount(tr)

    String summary_msg
    sprintf summary_msg, "%d tests run: %d successes, %d failures, %d errors\r", test_count, success_count, failure_count, error_count
    return summary_msg
End

Function/S OFBasic_TestOutcomeSummary(to)
    STRUCT TestOutcome &to

    String groupname = TO_getGroupname(to)
    String testname = TO_getTestname(to)
    String funcname = TO_getFuncname(to)
    String filename = TO_getFilename(to)
    Variable linenum = TO_getLineNumber(to)
    String message = TO_getMessage(to)

    String defect_summary
    sprintf defect_summary, "%s in %s at line %d\r", funcname, filename, linenum

    if (isStringExists(message))
        String msg_line
        sprintf msg_line, "\t%s\r", message
        defect_summary += msg_line
    endif
    return defect_summary
End

Function/S OFBasic_TestAssertSummary(to, assertion)
    STRUCT TestOutcome &to
    STRUCT Assertion &assertion

    Variable result_code = Assertion_getResult(assertion)
    String type = Assertion_getTypeName(assertion)
    String param_list = Assertion_getParams(assertion)
    String message = Assertion_getMessage(assertion)
    String stack_info = Assertion_getStack(assertion)
    Variable linenum = Assertion_getLineNumber(assertion)

    String summary
    sprintf summary, "\t%s(%s), %s, at line %d\r", type, param_list, message, linenum
    return summary
End

Function/S OFVerbose_TestFailure(to)
    STRUCT TestOutcome &to
    return formatRunVerbose(to, "FAIL")
End

Function/S OFVerbose_TestError(to)
    STRUCT TestOutcome &to
    return formatRunVerbose(to, "ERROR")
End

Function/S OFVerbose_TestSuccess(to)
    STRUCT TestOutcome &to
    return formatRunVerbose(to, "OK")
End

Function/S formatRunVerbose(to, result_string)
    STRUCT TestOutcome &to
    String result_string

    String result_line
    String test_desc

    String groupname = TO_getGroupname(to)
    String testname = TO_getTestname(to)
    sprintf test_desc, "%s, %s", groupname, testname

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

#endif