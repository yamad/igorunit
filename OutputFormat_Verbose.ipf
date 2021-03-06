#ifndef IGORUNIT_OUTPUTFORMAT_VERBOSE
#define IGORUNIT_OUTPUTFORMAT_VERBOSE

Function OFVerbose_init(of)
    STRUCT OutputFormat &of
    of.name = "Verbose"
    OF_setFuncPointers(of, "OFVerbose")
End

Function/S OFVerbose_GroupStart(of, groupname)
    STRUCT OutputFormat &of
    String groupname

    return groupname + "\r"
End

Function/S OFVerbose_TestStart(of, test)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test

    String result_line
    String test_id = ""
    String docstring = UnitTest_getDocString(test)
    if (isStringExists(docstring))
        test_id = docstring
    else
        test_id = UnitTest_getFuncname(test)
    endif
    sprintf result_line, "  %s %s ", test_id, formatVerboseDashes(test_id)
    return result_line
End

Function/S OFVerbose_TestSuccess(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "OK\r"
End

Function/S OFVerbose_TestFailure(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "FAIL\r"
End

Function/S OFVerbose_TestError(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "ERROR\r"
End

Function/S OFVerbose_TestIgnore(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return "IGNORE\r"
End

Function/S OFVerbose_AssertSuccess(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return ""
End

Function/S OFVerbose_AssertFailure(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return ""
End

Function/S OFVerbose_TestSuiteSummary(of, tr, ts)
    STRUCT OutputFormat &of
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    return OFBasic_TestSuiteSummary(of, tr, ts)
End

Function/S OFVerbose_TestOutcomeSummary(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to

    String groupname = TO_getGroupname(to)
    String testname = TO_getTestname(to)
    String funcname = TO_getFuncname(to)
    String filename = TO_getFilename(to)
    String docstring = TO_getDocString(to)
    Variable linenum = TO_getLineNumber(to)
    String message = TO_getMessage(to)

    String defect_summary
    sprintf defect_summary, "%s (%s) in %s at line %d\r", testname, funcname, filename, linenum

    if (isStringExists(groupname))
        sprintf defect_summary, "%s, %s", groupname, defect_summary
    endif

    if (isStringExists(docstring))
        sprintf defect_summary, "%s  %s\r", defect_summary, docstring
    endif

    if (isStringExists(message))
        String msg_line
        sprintf msg_line, "\t%s\r", message
        defect_summary += msg_line
    endif
    return defect_summary
End

Function/S OFVerbose_AssertionSummary(of, to, assertion)
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
    sprintf summary, "\t%s(%s), %s at line %d\r", type, param_list, message, linenum
    return summary
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