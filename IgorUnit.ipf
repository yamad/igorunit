#pragma rtGlobals=1		// Use modern global access method.

// IgorUnit -- a unit testing framework for IgorPro based on xUnit

#include "utils"
#include "TestSuiteRunner"

Function test_assert()
End

Function runTests()
    String testfn_list
    testfn_list = discoverTests()

    Variable status = FALSE
    Variable successes = 0
    Variable failures = 0

    Variable test_no = ItemsInList(testfn_list)
    String curr_fn_name
    Variable i
    for (i=0; i < test_no; i+=1)
        curr_fn_name = StringFromList(i, testfn_list)
        FUNCREF prototest curr_fn = $curr_fn_name

        status = curr_fn()
        printTestResult(curr_fn_name, status)
        if (status == TRUE)
            successes += 1
        else
            failures += 1
        endif
    endfor

    printf "%d tests run: %d successes, %d failures", test_no, successes, failures
End

// Function runAutoTests()
//     String testfn_list = discoverTests()

//     STRUCT TestSuite ts
//     TS_init(ts)
//     TS_addTestList(ts, testfn_list)

//     STRUCT TestSuiteRunner tsr
//     TSR_init(tsr, ts)
//     TSR_runAllTests(tsr)
// End

Function attempt()
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

Function test1()
    print "In test 1..."
End