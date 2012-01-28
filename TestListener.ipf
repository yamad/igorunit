#pragma rtGlobals=1		// Use modern global access method.

// TestListener -- a component of IgorUnit
//   This interface can listen to events emitted by TestResult

#ifndef IGORUNIT_TESTLISTENER
#define IGORUNIT_TESTLISTENER

Constant LISTENERTYPE_DEFAULT = 0
Constant LISTENERTYPE_COMMANDLINE = 1

Constant VERBOSITY_LOW = 1

Structure TestListener
    Variable listener_type
    Variable verbosity
    String output
    FUNCREF TL_output output_func
    FUNCREF TL_addTestFailure testfail_func
    FUNCREF TL_addTestSuccess testsuccess_func
    FUNCREF TL_addTestError testerror_func
    FUNCREF TL_addTestStart teststart_func
    FUNCREF TL_addTestEnded testend_func
    FUNCREF TL_addAssertSuccess assertsuccess_func
    FUNCREF TL_addAssertFailure assertfail_func
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

    funcinfo = FuncRefInfo(tl.teststart_func)
    String/G to_dfref:teststart_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.testend_func)
    String/G to_dfref:testend_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.assertsuccess_func)
    String/G to_dfref:assertsuccess_func = Dict_getItem(funcinfo, "NAME")

    funcinfo = FuncRefInfo(tl.assertfail_func)
    String/G to_dfref:assertfail_func = Dict_getItem(funcinfo, "NAME")
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
    SVAR teststart_func = from_dfref:teststart_func
    SVAR testend_func = from_dfref:testend_func
    SVAR assertsuccess_func = from_dfref:assertsuccess_func
    SVAR assertfail_func = from_dfref:assertfail_func

    FUNCREF TL_output tl.output_func = $(output_func)
    FUNCREF TL_addTestFailure tl.testfail_func = $(testfail_func)
    FUNCREF TL_addTestSuccess tl.testsuccess_func = $(testsuccess_func)
    FUNCREF TL_addTestError tl.testerror_func = $(testerror_func)
    FUNCREF TL_addTestStart tl.teststart_func = $(teststart_func)
    FUNCREF TL_addTestEnded tl.testend_func = $(testend_func)
    FUNCREF TL_addAssertSuccess tl.assertsuccess_func = $(assertsuccess_func)
    FUNCREF TL_addAssertFailure tl.assertfail_func = $(assertfail_func)
End

Function TL_init(tl)
    STRUCT TestListener &tl

    tl.listener_type = LISTENERTYPE_COMMANDLINE
    tl.verbosity = VERBOSITY_LOW
    tl.output = ""
    TL_setFuncPointers(tl, "TL")
End

Function TL_setFuncPointers(tl, prefix)
    STRUCT TestListener &tl
    String prefix

    FUNCREF TL_output tl.output_func = $(prefix+"_output")
    FUNCREF TL_addTestFailure tl.testfail_func = $(prefix+"_addTestFailure")
    FUNCREF TL_addTestSuccess tl.testsuccess_func = $(prefix+"_addTestSuccess")
    FUNCREF TL_addTestError tl.testerror_func = $(prefix+"_addTestError")
    FUNCREF TL_addTestStart tl.teststart_func = $(prefix+"_addTestStart")
    FUNCREF TL_addTestEnded tl.testend_func = $(prefix+"_addTestEnded")
    FUNCREF TL_addAssertSuccess tl.assertsuccess_func = $(prefix+"_addAssertSuccess")
    FUNCREF TL_addAssertFailure tl.assertfail_func = $(prefix+"_addAssertFailure")
End

Function/S TL_output(tl, out_string)
    STRUCT TestListener &tl
    String out_string
    return tl.output_func(tl, out_string)
End

Function TL_addTestFailure(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    return tl.testfail_func(tl, tr, test)
End

Function TL_addTestSuccess(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    return tl.testsuccess_func(tl, tr, test)
End

Function TL_addTestError(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
End

Function TL_addTestStart(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
End

Function TL_addTestEnded(tl, tr, test)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
End

Function TL_addAssertFailure(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
End

Function TL_addAssertSuccess(tl, tr, test, assertion)
    STRUCT TestListener &tl
    STRUCT TestResult &tr
    STRUCT UnitTest &test
    STRUCT Assertion &assertion
End

#endif