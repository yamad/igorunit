#pragma rtGlobals=1		// Use modern global access method.

// TestSuite -- a component of IgorUnit
//   This data type can be used to organize tests into sets/suites

#ifndef IGORUNIT_TS
#define IGORUNIT_TS

#include "utils"

Structure TestSuite
    String tests
    Variable test_no
EndStructure

Function TS_init(ts)
    STRUCT TestSuite &ts
    ts.test_no = 0
End

Function TS_addTestList(ts, test_list)
    STRUCT TestSuite &ts
    String test_list

    Variable test_no = ItemsInList(test_list)
    Variable i
    for (i=0; i < test_no; i+=1)
        String testname = StringFromList(i, test_list)
        TS_addTest(ts, testname)
    endfor
End

Function TS_addTest(ts, testname)
    STRUCT TestSuite &ts
    String testname

    if (!TS_hasTest(ts, testname))
        ts.tests = AddListItem(testname, ts.tests, ";", Inf)
        ts.test_no += 1
    endif
End

Function TS_removeTest(ts, testname)
    STRUCT TestSuite &ts
    String testname

    if (TS_hasTest(ts, testname))
        Variable test_idx = WhichListItem(testname, ts.tests, ";")
        ts.tests = RemoveListItem(test_idx, ts.tests, ";")
        ts.test_no -= 1
    endif
End

Function/S TS_getTestByIndex(ts, test_idx)
    STRUCT TestSuite &ts
    Variable test_idx

    String testname = StringFromList(test_idx, ts.tests)
    if (strlen(testname) == 0)
        String err_msg
        sprintf err_msg, "No test found at index %d", test_idx
        Abort err_msg
    endif
    return testname
End

Function TS_hasTest(ts, testname)
    STRUCT TestSuite &ts
    String testname

    if (FindListItem(testname, ts.tests, ";") > 0)
        return TRUE
    endif
    return FALSE
End

Function TS_getNumberOfTests(ts)
    STRUCT TestSuite &ts
    return ts.test_no
End

#endif