#pragma rtGlobals=1		// Use modern global access method.

// TestListener -- a component of IgorUnit
//   This interface can listen to events emitted by TestResult

#ifndef IGORUNIT_TESTLISTENER
#define IGORUNIT_TESTLISTENER

#include "funcutils"

Constant LISTENERTYPE_DEFAULT = 0
Constant LISTENERTYPE_PRINTER = 1

Constant VERBOSITY_LOW = 1
Constant VERBOSITY_HIGH = 2

Static Strconstant TL_DEFAULT_PREFIX = "TLnull"

Structure TestListener
    Variable listener_type
    Variable verbosity
    String output
    FUNCREF TLnull_output output_func
    FUNCREF TLnull_addTestFailure testfail_func
    FUNCREF TLnull_addTestSuccess testsuccess_func
    FUNCREF TLnull_addTestError testerror_func
    FUNCREF TLnull_addTestIgnore testignore_func
    FUNCREF TLnull_addTestStart teststart_func
    FUNCREF TLnull_addTestEnd testend_func
    FUNCREF TLnull_addAssertSuccess assertsuccess_func
    FUNCREF TLnull_addAssertFailure assertfail_func
    FUNCREF TLnull_addTestSuiteStart ts_start_func
    FUNCREF TLnull_addTestSuiteEnd ts_end_func
EndStructure

Function TL_persist(tl, to_dfref)
    STRUCT TestListener &tl
    DFREF to_dfref

    if (!isDataFolderExists(to_dfref))
        NewDataFolder to_dfref
    endif

    Variable/G to_dfref:listener_type = tl.listener_type
    Variable/G to_dfref:verbosity = tl.verbosity
    String/G to_dfref:output = tl.output

    String funcinfo
    funcinfo = FuncRefInfo(tl.output_func)
    String/G to_dfref:output_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.testfail_func)
    String/G to_dfref:testfail_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.testsuccess_func)
    String/G to_dfref:testsuccess_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.testerror_func)
    String/G to_dfref:testerror_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.testignore_func)
    String/G to_dfref:testignore_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.teststart_func)
    String/G to_dfref:teststart_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.testend_func)
    String/G to_dfref:testend_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.assertsuccess_func)
    String/G to_dfref:assertsuccess_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.assertfail_func)
    String/G to_dfref:assertfail_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.ts_start_func)
    String/G to_dfref:ts_start_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.ts_end_func)
    String/G to_dfref:ts_end_func = Dict_getItem(funcinfo, "NAME")
End

Function TL_load(tl, from_dfref)
    STRUCT TestListener &tl
    DFREF from_dfref

    NVAR listener_type = from_dfref:listener_type
    NVAR verbosity = from_dfref:verbosity
    SVAR output = from_dfref:output

    tl.listener_type = listener_type
    tl.verbosity = verbosity
    tl.output = output

    SVAR output_func = from_dfref:output_func
    SVAR testfail_func = from_dfref:testfail_func
    SVAR testsuccess_func = from_dfref:testsuccess_func
    SVAR testerror_func = from_dfref:testerror_func
    SVAR testignore_func = from_dfref:testignore_func
    SVAR teststart_func = from_dfref:teststart_func
    SVAR testend_func = from_dfref:testend_func
    SVAR assertsuccess_func = from_dfref:assertsuccess_func
    SVAR assertfail_func = from_dfref:assertfail_func
    SVAR ts_start_func = from_dfref:ts_start_func
    SVAR ts_end_func = from_dfref:ts_end_func

    FUNCREF TLnull_output tl.output_func = $(output_func)
    FUNCREF TLnull_addTestFailure tl.testfail_func = $(testfail_func)
    FUNCREF TLnull_addTestSuccess tl.testsuccess_func = $(testsuccess_func)
    FUNCREF TLnull_addTestError tl.testerror_func = $(testerror_func)
    FUNCREF TLnull_addTestIgnore tl.testignore_func = $(testignore_func)
    FUNCREF TLnull_addTestStart tl.teststart_func = $(teststart_func)
    FUNCREF TLnull_addTestEnd tl.testend_func = $(testend_func)
    FUNCREF TLnull_addAssertSuccess tl.assertsuccess_func = $(assertsuccess_func)
    FUNCREF TLnull_addAssertFailure tl.assertfail_func = $(assertfail_func)
    FUNCREF TLnull_addTestSuiteStart tl.ts_start_func = $(ts_start_func)
    FUNCREF TLnull_addTestSuiteEnd tl.ts_end_func = $(ts_end_func)
End

Function TL_init(tl)
    STRUCT TestListener &tl

    tl.listener_type = LISTENERTYPE_DEFAULT
    tl.verbosity = VERBOSITY_LOW
    tl.output = ""
    TL_setFuncPointers(tl, TL_DEFAULT_PREFIX)
End

Function TL_setFuncPointers(tl, prefix)
    STRUCT TestListener &tl
    String prefix

    String funcname

    funcname = prefix+"_output"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_output tl.output_func = $(funcname)
    endif
    funcname = prefix+"_addTestFailure"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestFailure tl.testfail_func = $(funcname)
    endif
    funcname = prefix+"_addTestSuccess"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestSuccess tl.testsuccess_func = $(funcname)
    endif
    funcname = prefix+"_addTestError"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestError tl.testerror_func = $(funcname)
    endif
    funcname = prefix+"_addTestIgnore"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestIgnore tl.testignore_func = $(funcname)
    endif
    funcname = prefix+"_addTestStart"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestStart tl.teststart_func = $(funcname)
    endif
    funcname = prefix+"_addTestEnd"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestEnd tl.testend_func = $(funcname)
    endif
    funcname = prefix+"_addAssertSuccess"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addAssertSuccess tl.assertsuccess_func = $(funcname)
    endif
    funcname = prefix+"_addAssertFailure"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addAssertFailure tl.assertfail_func = $(funcname)
    endif
    funcname = prefix+"_addTestSuiteStart"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestSuiteStart tl.ts_start_func = $(funcname)
    endif
    funcname = prefix+"_addTestSuiteEnd"
    if (isFunctionExists(funcname))
        FUNCREF TLnull_addTestSuiteEnd tl.ts_end_func = $(funcname)
    endif
End

Function TL_setVerbosity(tl, verbosity)
    STRUCT TestListener &tl

    Variable verbosity
    tl.verbosity = verbosity
End

Function/S TL_output(tl, out_string)
    STRUCT TestListener &tl
    String out_string
    return tl.output_func(tl, out_string)
End

Function TL_addTestSuiteStart(tl, tr, ts)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    return tl.ts_start_func(tl, tr, ts)
End

Function TL_addTestSuiteEnd(tl, tr, ts)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
    return tl.ts_end_func(tl, tr, ts)
End

Function TL_addTestFailure(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
    return tl.testfail_func(tl, tr, to)
End

Function TL_addTestSuccess(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
    return tl.testsuccess_func(tl, tr, to)
End

Function TL_addTestError(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
    return tl.testerror_func(tl, tr, to)
End

Function TL_addTestIgnore(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
    return tl.testignore_func(tl, tr, to)
End

Function TL_addTestStart(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    return tl.teststart_func(tl, tr, test)
End

Function TL_addTestEnd(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
    return tl.testend_func(tl, tr, to)
End

Function TL_addAssertFailure(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return tl.assertfail_func(tl, tr, test, assertion)
End

Function TL_addAssertSuccess(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
    return tl.assertsuccess_func(tl, tr, test, assertion)
End

Function/S TLnull_output(tl, out_string)
    STRUCT TestListener &tl
    String out_string
End

Function TLnull_addTestSuiteStart(tl, tr, ts)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
End

Function TLnull_addTestSuiteEnd(tl, tr, ts)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestSuite &ts
End

Function TLnull_addTestFailure(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
End

Function TLnull_addTestSuccess(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
End

Function TLnull_addTestError(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
End

Function TLnull_addTestIgnore(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
End

Function TLnull_addTestStart(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
End

Function TLnull_addTestEnd(tl, tr, to)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT TestOutcome &to
End

Function TLnull_addAssertFailure(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
End

Function TLnull_addAssertSuccess(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
End

#endif