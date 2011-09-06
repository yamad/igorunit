#pragma rtGlobals=1		// Use modern global access method.

// IgorUnit -- a unit testing framework for IgorPro based on xUnit

#include "utils"
#include "TestSuiteRunner"
#include "TestSuite"
#include "TestResult"

Function test_All()
    STRUCT TestSuite ts
    TS_init(ts)
    TS_addGroup(ts, "default")
    TS_addTest(ts, "default", "test1")
    
    STRUCT TestSuiteRunner tsr
    TSR_init(tsr, ts)
    TSR_runAllTests(tsr)
End

Function default_setup()
    print "In setup"
End

Function default_teardown()
    print "In teardown"
End

Function test1(tr)
    STRUCT TestResult &tr
    TR_addFailure(tr, "default", "test1", "This is a fake test failure")
End