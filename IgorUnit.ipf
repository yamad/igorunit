#pragma rtGlobals=1		// Use modern global access method.

// IgorUnit -- a unit testing framework for IgorPro based on xUnit

#ifndef IGORUNIT_INCLUDE
#define IGORUNIT_INCLUDE

#include "stackinfoutils"

#include "assert"
#include "UnitTest"
#include "TestSuiteRunner"
#include "TestSuite"
#include "TestResult"

Strconstant IGORUNIT_DF = "root:Packages:IgorUnit" // Path to package data folder

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

Function/S runAllTests_getResults()
  STRUCT TestSuite ts
  TS_init(ts)


  // Add Tests
  // STRUCT UnitTest test
  // % for group in suite.groups:
  // TS_addGroup(ts, "${group.get_name()}")
  // % for test in group.tests:
  // TS_addTestByName(ts, "${group.get_name()}", "${test.get_name()}", "${test.get_funcname()}")
  // % endfor
  // % endfor

  TS_addTestByName(ts, "t", "test_TestTest", "test_TestTest")
  return TS_runSuite(ts)
End

Function/S TS_runSuite(ts)
    STRUCT TestSuite &ts
    
    STRUCT TestSuiteRunner tsr
    TSR_init(tsr, ts)
  
    String results = TSR_runAllTests(tsr)
    return results
End

Function runAllTests()
  print runAllTests_getResults()
End

Function test_TestTest()
//    ASSERT(1 == 2)
    EXPECT_FALSE(1 == 2)
    EXPECT_TRUE(1 == 1)
    EXPECT_TRUE(2 != 1)
    EXPECT_EQ(1, 1, tolerance=0)
//    ASSERT(1 == 2)
End

#endif