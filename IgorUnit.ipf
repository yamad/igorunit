#pragma rtGlobals=1		// Use modern global access method.

// IgorUnit -- a unit testing framework for IgorPro based on xUnit

#ifndef IGORUNIT_INCLUDE
#define IGORUNIT_INCLUDE

#include "booleanutils"
#include "numutils"
#include "waveutils"
#include "listutils"
#include "funcutils"
#include "stringutils"
#include "datafolderutils"
#include "stackinfoutils"

#include "assert"
#include "TestSuiteRunner"

Strconstant IGORUNIT_DF = "root:Packages:IgorUnit" // Path to package data folder

Static Strconstant AUTODISCOVER_PREFIX = "utest_"
Static Strconstant GROUP_SEP = "__"

// -- Automatically run initialization when compiled --
Menu "Macros", dynamic
    IgorUnit_init()
End

Function/S IgorUnit_init()
	String pkgroot_df = "root:Packages"
	if (!DataFolderExists(pkgroot_df))
		NewDataFolder $pkgroot_df
	endif
	if (!DataFolderExists(IGORUNIT_DF))
		NewDataFolder $IGORUNIT_DF
	endif
	DFREF savedDFR = GetDataFolderDFR()
	SetDataFolder $IGORUNIT_DF
	Variable/G IgorUnit_INCLUDE = 1

	SetDataFolder savedDFR
End

Function/DF IgorUnit_getCurrentTSR()
    String TSR_REFWAVE_PATH = IGORUNIT_DF+":CURR_TSR"
    return DataFolder_createOrGet(TSR_REFWAVE_PATH)
End

Function IgorUnit_clearCurrentTSR()
    String TSR_REFWAVE_PATH = IGORUNIT_DF+":CURR_TSR"
    KillDataFolder $(TSR_REFWAVE_PATH)
End

Function/DF IgorUnit_getCurrentUnitTest()
    String TEST_REFWAVE_PATH = IGORUNIT_DF+":CURR_TEST"
    return DataFolder_createOrGet(TEST_REFWAVE_PATH)
End

Function IgorUnit_clearCurrentUnitTest()
    String TEST_REFWAVE_PATH = IGORUNIT_DF+":CURR_TEST"
    KillDataFolder $(TEST_REFWAVE_PATH)
End

Function/S IgorUnit_getCallingStack()
    return Stack_getPartialNegativeIndex(2)
End

Function/S IgorUnit_autoDiscoverTests()
    return FunctionList(AUTODISCOVER_PREFIX+"*", ";", "KIND:2")
End

Function IgorUnit_addAutoDiscoverList(ts, func_list)
    STRUCT TestSuite &ts
    String func_list

    Variable list_len = List_getLength(func_list)
    Variable i
    for (i=0; i<list_len; i+=1)
        String curr_func = List_getItem(func_list, i)
        IgorUnit_addAutoDiscoverTest(ts, curr_func)
    endfor
End

Function IgorUnit_addAutoDiscoverTest(ts, func_name)
    STRUCT TestSuite &ts
    String func_name

    String group_name = ""
    String test_name = ""
    IgorUnit_splitFuncName(func_name, group_name, test_name)
    TS_addTestByName(ts, group_name, test_name, func_name)
End

Function IgorUnit_splitFuncName(func_name, group_name, test_name)
    String func_name
    String &group_name, &test_name

    String func_re = "(?:"+AUTODISCOVER_PREFIX+")?(?:([\\w\\d_]+)"+GROUP_SEP+")?([\\w\\d_]+)"
    SplitString/E=func_re func_name, group_name, test_name
End

Function IgorUnit_runAllTests()
    STRUCT TestSuite ts
    TS_init(ts)

    String test_list = IgorUnit_autoDiscoverTests()
    IgorUnit_addAutoDiscoverList(ts, test_list)
    return TS_runSuite(ts)
End

Function TS_runSuite(ts)
    STRUCT TestSuite &ts

    STRUCT TestSuiteRunner tsr
    TSR_init(tsr, ts)
    return TSR_runAllTests(tsr)
End

Function utest_TestTest()
//    ASSERT(1 == 2)
    IGNORE_TEST()
    EXPECT_FALSE(1 == 2)
    EXPECT_TRUE(1 == -1)
    EXPECT_TRUE(2 != 1)
    EXPECT_EQ(1, 1, tol=0)
//    ASSERT(1 == 2)
End

#endif