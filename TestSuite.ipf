#pragma rtGlobals=1		// Use modern global access method.

// TestSuite -- a component of IgorUnit
//   This data type can be used to organize tests into sets/suites

#ifndef IGORUNIT_TS
#define IGORUNIT_TS

#include "boolean"
#include "utils"
#include "list"
#include "wave"

Constant TESTSUITE_GROUP_MAX = 400

Structure TestSuite
    String groups
    String tests[TESTSUITE_GROUP_MAX]
    Variable test_no
EndStructure

Function TS_init(ts)
    STRUCT TestSuite &ts
    ts.test_no = 0
    ts.groups = ""

    // Variable i
    // for (i=0; i < TESTSUITE_GROUP_MAX; i+=1)
    //     ts.tests[i] = ""
    // endfor
End

Function TS_addGroup(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    if (!TS_hasGroup(ts, groupname))
        ts.groups = AddListItem(groupname, ts.groups, ";", Inf)
        TS_initNewGroupTestList(ts)
    endif
    return TS_getGroupIndex(ts, groupname)
End

Static Function TS_initNewGroupTestList(ts)
    STRUCT TestSuite &ts
    Variable group_count = TS_getGroupCount(ts)
    ts.tests[group_count-1] = ""
End

Function TS_addTest(ts, groupname, testname)
    STRUCT TestSuite &ts
    String groupname, testname

    Variable group_idx = TS_addGroup(ts, groupname)
    if (!TS_hasTest(ts, groupname, testname))
        ts.tests[group_idx] = AddListItem(testname, ts.tests[group_idx], ";", Inf)
        ts.test_no += 1
    endif
    return TS_getTestIndex(ts, groupname, testname)
End

Function TS_removeTest(ts, groupname, testname)
    STRUCT TestSuite &ts
    String groupname, testname

    Variable group_idx = TS_getGroupIndex(ts, groupname)
    if (TS_hasTest(ts, groupname, testname))
        Variable test_idx = TS_getTestIndex(ts, groupname, testname)
        ts.tests[group_idx] = RemoveListItem(test_idx, ts.tests[group_idx], ";")
        ts.test_no -= 1
    endif
End

Function/S TS_getGroupByIndex(ts, group_idx)
    STRUCT TestSuite &ts
    Variable group_idx

    String groupname = StringFromList(group_idx, ts.groups)
    return groupname
End

Function/S TS_getTestByIndex(ts, group_idx, test_idx)
    STRUCT TestSuite &ts
    Variable group_idx, test_idx

    String test_list = TS_getGroupTestsByIndex(ts, group_idx)
    String testname = StringFromList(test_idx, test_list)
    return testname
End

Function/S TS_getGroupTests(ts, groupname)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    String groupname

    Variable group_idx = TS_getGroupIndex(ts, groupname)
    return TS_getGroupTestsByIndex(ts, group_idx)
End

Function/S TS_getGroupTestsByIndex(ts, group_idx)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    Variable group_idx

    return ts.tests[group_idx]
End

Function TS_getGroupTestCount(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    String test_list = TS_getGroupTests(ts, groupname)
    return List_getLength(test_list)
End

Function TS_hasGroup(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    if (TS_getGroupIndex(ts, groupname) > -1)
        return TRUE
    endif
    return FALSE
End

Function TS_hasTest(ts, groupname, testname)
    STRUCT TestSuite &ts
    String groupname, testname

    if (TS_getTestIndex(ts, groupname, testname) > -1)
        return TRUE
    endif
    return FALSE
End

Function TS_getGroupIndex(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    return WhichListItem(groupname, ts.groups, ";")
End

Function TS_getTestIndex(ts, groupname, testname)
    STRUCT TestSuite &ts
    String groupname, testname

    String test_list = TS_getGroupTests(ts, groupname)
    return WhichListItem(testname, test_list, ";")
End

Function TS_getTestCount(ts)
    STRUCT TestSuite &ts
    return ts.test_no
End

Function TS_getGroupCount(ts)
    STRUCT TestSuite &ts
    return List_getLength(ts.groups)
End

#endif