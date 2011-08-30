#pragma rtGlobals=1		// Use modern global access method.

// TestSuite -- a component of IgorUnit
//   This data type can be used to organize tests into sets/suites

#ifndef IGORUNIT_TS
#define IGORUNIT_TS

#include "utils"

Structure TestSuite
    Wave tests
    Variable test_no
EndStructure

Function TS_init(ts)
    STRUCT TestSuite &ts
    ts.test_no = 0
    TS_initTestWave(ts)
End

Function TS_initTestWave(ts)
    STRUCT TestSuite &ts

    Make/N=(0,2) ts.tests
    SetDimLabel 0,-1, test_groups, ts.tests
    SetDimLabel 1, 0, group, ts.tests
    SetDimLabel 1, 1, tests, ts.tests
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

Function TS_addTest(ts, groupname, testname)
    STRUCT TestSuite &ts
    String groupname, testname

    Variable row_idx
    if (!TS_hasGroup(ts, groupname))
        row_idx = Wave_appendRow(ts.tests)
        ts.tests[row_idx][%group] = groupname

    if (!TS_hasTest(ts, groupname, testname))
        ts.tests = AddListItem(testname, ts.tests, ";", Inf)
        ts.test_no += 1
    endif
End

Function Wave_appendRow(wave_in)
    // Add a new row to a wave and return the index of the new row
    Wave wave_in
    Variable rowCount = Wave_getRowCount(wave_in)
    InsertPoints/M=0 rowCount, 1, wave_in
    return Wave_getRowCount(wave_in)
End

Function Wave_getRowCount(wave_in)
    Wave wave_in
    return DimSize(wave_in, 0)
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

Function/S TS_getGroupByIndex(ts, group_idx)
    STRUCT TestSuite &ts
    Variable group_idx

    String groupname = ts.tests[group_idx][%group]
    return groupname
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

Function/S TS_getGroupTests(ts, groupname)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    String groupname
End

Function TS_hasGroup(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    FindValue/TEXT=(groupname)/TXOP=2 ts.tests
End

Function TS_hasTest(ts, groupname, testname)
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

Function Wave2D_getColumnIndex(orig_index, row_count)
    // Return the column index in a 2D wave when given a 1D index
    return floor(orig_index / row_count)
End

Function Wave2D_getRowIndex(orig_index, row_count, col_index)
    // Return the row index in a 2D wave when given a 1D index
    return (orig_index - (col_index * row_count))
#endif