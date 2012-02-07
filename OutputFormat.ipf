#ifndef IGORUNIT_OUTPUTFORMAT
#define IGORUNIT_OUTPUTFORMAT

// OutputFormat -- a component of IgorUnit
//    This data type handles formats for displaying test results

Structure OutputFormat
    String name
    FUNCREF OFnull_TestStart teststart_func
    FUNCREF OFnull_TestSuccess testsuccess_func
    FUNCREF OFnull_TestFailure testfail_func
    FUNCREF OFnull_TestError testerror_func
    FUNCREF OFnull_AssertSuccess assertsuccess_func
    FUNCREF OFnull_AssertFailure assertfail_func
    FUNCREF OFnull_TestSuiteSummary ts_summ_func
    FUNCREF OFnull_TestOutcomeSummary to_summ_func
    FUNCREF OFnull_AssertionSummary assert_summ_func
EndStructure

#include "OutputFormat_Basic"
#include "OutputFormat_Verbose"
Function OutputFormat_factory(verbosity, of_out)
    Variable verbosity
    STRUCT OutputFormat &of_out

    switch (verbosity)
        case VERBOSITY_HIGH:
            OFVerbose_init(of_out)
            break
        case VERBOSITY_LOW:
        default:
            OFBasic_init(of_out)
            break
    endswitch
    return 0
End

Function OF_init(of)
    STRUCT OutputFormat &of
    of.name = ""
    OF_setFuncPointers(of, "OFnull")
End

Function OF_setFuncPointers(of, prefix)
    STRUCT OutputFormat &of
    String prefix

    FUNCREF OFnull_TestStart of.teststart_func = $(prefix+"_TestStart")
    FUNCREF OFnull_TestSuccess of.testsuccess_func = $(prefix+"_TestSuccess")
    FUNCREF OFnull_TestFailure of.testfail_func = $(prefix+"_TestFailure")
    FUNCREF OFnull_TestError of.testerror_func = $(prefix+"_TestError")
    FUNCREF OFnull_AssertSuccess of.assertsuccess_func = $(prefix+"_AssertSuccess")
    FUNCREF OFnull_AssertFailure of.assertfail_func = $(prefix+"_AssertFailure")
    FUNCREF OFnull_TestSuiteSummary of.ts_summ_func = $(prefix+"_TestSuiteSummary")
    FUNCREF OFnull_TestOutcomeSummary of.to_summ_func = $(prefix+"_TestOutcomeSummary")
    FUNCREF OFnull_AssertionSummary of.assert_summ_func = $(prefix+"_AssertionSummary")
End

Function OF_persist(of, to_dfref)
    STRUCT OutputFormat &of
    DFREF to_dfref

    if (!isDataFolderExists(to_dfref))
        NewDataFolder to_dfref
    endif

    String/G to_dfref:name = of.name

    String funcinfo
    funcinfo = FuncRefInfo(of.teststart_func)
    String/G to_dfref:teststart_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.testsuccess_func)
    String/G to_dfref:testsuccess_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.testfail_func)
    String/G to_dfref:testfail_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.testerror_func)
    String/G to_dfref:testerror_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.assertsuccess_func)
    String/G to_dfref:assertsuccess_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.assertfail_func)
    String/G to_dfref:assertfail_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.ts_summ_func)
    String/G to_dfref:ts_summ_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.to_summ_func)
    String/G to_dfref:to_summ_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(of.assert_summ_func)
    String/G to_dfref:assert_summ_func = Dict_getItem(funcinfo, "NAME")
End

Function OF_load(of, from_dfref)
    STRUCT OutputFormat &of
    DFREF from_dfref

    SVAR name = from_dfref:name
    of.name = name

    SVAR teststart_func = from_dfref:teststart_func
    SVAR testsuccess_func = from_dfref:testsuccess_func
    SVAR testfail_func = from_dfref:testfail_func
    SVAR testerror_func = from_dfref:testerror_func
    SVAR assertsuccess_func = from_dfref:assertsuccess_func
    SVAR assertfail_func = from_dfref:assertfail_func
    SVAR ts_summ_func = from_dfref:ts_summ_func
    SVAR to_summ_func = from_dfref:to_summ_func
    SVAR assert_summ_func = from_dfref:assert_summ_func

    FUNCREF OFnull_TestStart of.teststart_func = $(teststart_func)
    FUNCREF OFnull_TestSuccess of.testsuccess_func = $(testsuccess_func)
    FUNCREF OFnull_TestFailure of.testfail_func = $(testfail_func)
    FUNCREF OFnull_TestError of.testerror_func = $(testerror_func)
    FUNCREF OFnull_AssertSuccess of.assertsuccess_func = $(assertsuccess_func)
    FUNCREF OFnull_AssertFailure of.assertfail_func = $(assertfail_func)
    FUNCREF OFnull_TestSuiteSummary of.ts_summ_func = $(ts_summ_func)
    FUNCREF OFnull_TestOutcomeSummary of.to_summ_func = $(to_summ_func)
    FUNCREF OFnull_AssertionSummary of.assert_summ_func = $(assert_summ_func)
End

Function/S OutputFormat_getPrefix(verbosity)
    Variable verbosity

    switch (verbosity)
        case VERBOSITY_LOW:
            return "OFBasic"
        default:
            return "OFVerbose"
    endswitch
End

Function/S OutputFormat_getFuncName(verbosity, func_suffix)
    Variable verbosity
    String func_suffix
    return OutputFormat_getPrefix(verbosity) +"_"+ func_suffix
End

Function/S OF_TestStart(of, test)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    return of.teststart_func(of, test)
End

Function/S OF_TestSuccess(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return of.testsuccess_func(of, to)
End

Function/S OF_TestFailure(of, to) 
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return of.testfail_func(of, to)
End

Function/S OF_TestError(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return of.testerror_func(of, to)
End

Function/S OF_AssertSuccess(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return of.assertsuccess_func(of, test, assertion)
End

Function/S OF_AssertFailure(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return of.assertfail_func(of, test, assertion)
End

Function/S OF_TestSuiteSummary(of, tr, ts)
    STRUCT OutputFormat &of
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    return of.ts_summ_func(of, tr, ts)
End

Function/S OF_TestOutcomeSummary(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return of.to_summ_func(of, to)
End

Function/S OF_AssertionSummary(of, to, assertion)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    STRUCT Assertion &assertion
    return of.assert_summ_func(of, to, assertion)
End

Function/S OFnull_TestStart(of, test)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    return ""
End

Function/S OFnull_TestOutcome(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return ""
End

Function/S OFnull_TestSuccess(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return ""
End

Function/S OFnull_TestFailure(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return ""
End

Function/S OFnull_TestError(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return ""
End

Function/S OFnull_AssertSuccess(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return ""
End

Function/S OFnull_AssertFailure(of, test, assertion)
    STRUCT OutputFormat &of
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return ""
End

Function/S OFnull_TestSuiteSummary(of, tr, ts)
    STRUCT OutputFormat &of
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    return ""
End

Function/S OFnull_TestOutcomeSummary(of, to)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    return ""
End

Function/S OFnull_AssertionSummary(of, to, assertion)
    STRUCT OutputFormat &of
    STRUCT TestOutcome &to
    STRUCT Assertion &assertion
    return ""
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