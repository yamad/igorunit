#pragma rtGlobals=1		// Use modern global access method.

// TestSuite -- a component of IgorUnit
//   This data type can be used to organize tests into sets/suites

#ifndef IGORUNIT_TS
#define IGORUNIT_TS

#include "booleanutils"
#include "stringutils"
#include "listutils"
#include "waveutils"
#include "datafolderutils"

#include "UnitTest"

Structure TestSuite
    String groups
    Wave/T tests
    Wave/T testfuncs
    Variable test_count
    Variable group_count
EndStructure

Function TS_persist(ts, to_dfref)
    STRUCT TestSuite &ts
    DFREF to_dfref

    if (!isDataFolderExists(to_dfref))
        NewDataFolder to_dfref
    endif

    String/G to_dfref:groups = ts.groups

    Duplicate/O/T ts.tests, to_dfref:tests
    Duplicate/O/T ts.testfuncs, to_dfref:testfuncs

    Variable/G to_dfref:test_count = ts.test_count
    Variable/G to_dfref:group_count = ts.group_count
End

Function TS_load(ts, from_dfref)
    STRUCT TestSuite &ts
    DFREF from_dfref

    SVAR groups = from_dfref:groups
    NVAR test_count = from_dfref:test_count
    NVAR group_count = from_dfref:group_count

    Duplicate/O/T from_dfref:tests, ts.tests
    Duplicate/O/T from_dfref:testfuncs, ts.testfuncs

    ts.groups = groups
    ts.test_count = test_count
    ts.group_count = group_count
End

Static Constant GROUP_BLOCK_SIZE=10
Function TS_init(ts)
    STRUCT TestSuite &ts
    ts.test_count = 0
    ts.group_count = 0
    ts.groups = ""
    Make/FREE/T/N=(GROUP_BLOCK_SIZE, 3) ts.tests
    SetDimLabel 1, 0, test_name, ts.tests
    SetDimLabel 1, 1, func_name, ts.tests
    SetDimLabel 1, 2, group_idx, ts.tests

    Make/FREE/T/N=(GROUP_BLOCK_SIZE) ts.testfuncs
End

Function TS_getTestCount(ts)
    STRUCT TestSuite &ts
    return ts.test_count
End

Function TS_getGroupCount(ts)
    STRUCT TestSuite &ts
    return ts.group_count
End

Function TS_addGroup(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    if (!TS_hasGroup(ts, groupname))
        ts.groups = List_addItem(ts.groups, groupname)
    endif
    ts.group_count += 1
    return TS_getGroupIndex(ts, groupname)
End

Function TS_addTest(ts, test)
    STRUCT TestSuite &ts
    STRUCT UnitTest &test

    Variable group_idx = TS_addGroup(ts, test.groupname)
    if (!TS_hasTest(ts, test.groupname, test.testname))
        ts.tests[ts.test_count][%test_name] = test.testname
        ts.tests[ts.test_count][%func_name] = test.funcname
        ts.tests[ts.test_count][%group_idx] = num2str(group_idx)
        ts.test_count += 1
    endif
    return ts.test_count
End

Function TS_addTestByName(ts, groupname, testname, funcname)
    STRUCT TestSuite &ts
    String groupname, testname, funcname

    STRUCT UnitTest test
    UnitTest_init(test, groupname, testname, funcname)
    return TS_addTest(ts, test)
End

// Load UnitTest into output_test
Function TS_getTest(ts, test_idx, output_test)
    STRUCT TestSuite &ts
    Variable test_idx
    STRUCT UnitTest &output_test

    String groupname = TS_getTestGroupNameByIndex(ts, test_idx)
    String testname = TS_getTestNameByIndex(ts, test_idx)
    String funcname = TS_getTestFuncNameByIndex(ts, test_idx)
    UnitTest_set(output_test, groupname, testname, funcname)
    UnitTest_setIndex(output_test, test_idx)
End

Function TS_getTestByName(ts, groupname, testname, output_test)
    STRUCT TestSuite &ts
    String groupname, testname
    STRUCT UnitTest &output_test

    Variable group_idx = TS_getGroupIndex(ts, groupname)
    Variable dimtest_idx = FindDimLabel(ts.tests, 1, "test_name")
    String group_test_idxs = Wave_NumsToList(TS_getGroupTestIndices(ts, group_idx))
    Extract/O/FREE/INDX ts.tests, idxs, (q == dimtest_idx && List_hasItem(group_test_idxs, ts.tests[p][%group_idx]) && isStringsEqual(ts.tests[p][%test_name], testname))
    Wave results = Wave_convert2DToRowIndices(idxs, ts.tests)
    if (Wave_getRowCount(results) == 0)
        return -1
    endif
    Variable test_idx = results[0]
    TS_getTest(ts, test_idx, output_test)
    return test_idx
End

Function TS_getGroupTestByIndex(ts, group_idx, grouptest_idx, output_test)
    STRUCT TestSuite &ts
    Variable group_idx, grouptest_idx
    STRUCT UnitTest &output_test

    Variable full_idx = TS_getIndexFromGroupIndex(ts, group_idx, grouptest_idx)
    TS_getTest(ts, full_idx, output_test)
End

Function TS_getIndexFromGroupIndex(ts, group_idx, grouptest_idx)
    STRUCT TestSuite &ts
    Variable group_idx, grouptest_idx

    Wave group_test_idxs = TS_getGroupTestIndices(ts, group_idx)
    return group_test_idxs[grouptest_idx]
End

Function/S TS_getGroupNameByIndex(ts, group_idx)
    STRUCT TestSuite &ts
    Variable group_idx

    String groupname = List_getItem(ts.groups, group_idx)
    return groupname
End

Function/WAVE TS_getGroupTests(ts, groupname)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    String groupname

    Variable group_idx = TS_getGroupIndex(ts, groupname)
    return TS_getGroupTestsByIndex(ts, group_idx)
End

Function/WAVE TS_getGroupTestsByIndex(ts, group_idx)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    Variable group_idx

    Variable dim_idx = FindDimLabel(ts.tests, 1, "group_idx")
    Extract/O/FREE ts.tests, result, (q == dim_idx && isStringsEqual(ts.tests[p][%group_idx], num2str(group_idx)))
    return result
End

Function/WAVE TS_getGroupTestIndices(ts, group_idx)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    Variable group_idx

    Variable dim_idx = FindDimLabel(ts.tests, 1, "group_idx")
    Extract/O/FREE/INDX ts.tests, result, (q == dim_idx && isStringsEqual(ts.tests[p][%group_idx], num2str(group_idx)))
    return Wave_convert2DToRowIndices(result, ts.tests)
End

Function TS_getGroupTestCount(ts, group_idx)
    STRUCT TestSuite &ts
    Variable group_idx
    Wave group_tests = TS_getGroupTestIndices(ts, group_idx)
    return Wave_getRowCount(group_tests)
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

    STRUCT UnitTest test
    if (TS_getTestByName(ts, groupname, testname, test) > -1)
        return TRUE
    endif
    return FALSE
End

Function TS_getGroupIndex(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    return WhichListItem(groupname, ts.groups, ";")
End

Function/S TS_getTestNameByIndex(ts, test_idx)
    STRUCT TestSuite &ts
    Variable test_idx
    return ts.tests[test_idx][%test_name]
End

Function/S TS_getTestFuncNameByIndex(ts, test_idx)
    STRUCT TestSuite &ts
    Variable test_idx
    return ts.tests[test_idx][%func_name]
End

Function/S TS_getTestGroupNameByIndex(ts, test_idx)
    STRUCT TestSuite &ts
    Variable test_idx
    return TS_getGroupNameByIndex(ts, str2num(ts.tests[test_idx][%group_idx]))
End
    
#endif
