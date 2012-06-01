#ifndef IGORUNIT_OUTPUTFORMAT_BASIC
#define IGORUNIT_OUTPUTFORMAT_BASIC

Function OFBasic_init(of)
    STRUCT OutputFormat &of
    of.name = "Basic"
    OF_setFuncPointers(of, "OFBasic")
End

Function/S OFBasic_TestStart(of, test)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    return ""
End

Function/S OFBasic_TestSuccess(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "."
End

Function/S OFBasic_TestFailure(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "F"
End

Function/S OFBasic_TestError(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "E"
End

Function/S OFBasic_TestIgnore(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "I"
End

Function/S OFBasic_AssertSuccess(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return ""
End

Function/S OFBasic_AssertFailure(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return ""
End

Function/S OFBasic_TestSuiteSummary(of, tr, ts)
    STRUCT OutputFormat &of
    STRUCT TestResult &tr
    STRUCT TestSuite &ts

    Variable test_count = TR_getTestRunCount(tr)
    Variable success_count = TR_getSuccessCount(tr)
    Variable failure_count = TR_getFailureCount(tr)
    Variable error_count = TR_getErrorCount(tr)
    Variable ignore_count = TR_getIgnoreCount(tr)

    String summary_msg
    sprintf summary_msg, "%d tests run: %d successes, %d failures, %d errors, %d ignored \r", test_count, success_count, failure_count, error_count, ignore_count
    return summary_msg
End

Function/S OFBasic_TestOutcomeSummary(of, to)
    STRUCT OutputFormat &of
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

Function/S OFBasic_AssertionSummary(of, to, assertion)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    STRUCT Assertion &assertion

    Variable result_code = Assertion_getResult(assertion)
    String type = Assertion_getTypeName(assertion)
    String param_list = Assertion_getParams(assertion)
    String message = Assertion_getFullMessage(assertion)
    String stack_info = Assertion_getStack(assertion)
    Variable linenum = Assertion_getLineNumber(assertion)

    if (isStringExists(message))
        message = message + ", "
    endif

    String summary
    sprintf summary, "\t%s(%s), %sat line %d\r", type, param_list, message, linenum
    return summary
End

#endif