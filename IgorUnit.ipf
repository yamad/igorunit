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
	// Determine if  exists.  If it does, then that
	// wave contains one point which stores the DFREF where the global
	// frameworks are located.  If this wave does not exist then initialize it.
    String curr_tsr_refname = IGORUNIT_DF+":CURR_TSR_REF"
    Wave/DF/Z TSR_PTRS = $(curr_tsr_refname)
	if (!WaveExists(TSR_PTRS) || (DataFolderRefStatus(TSR_PTRS[0]) == 0))
		Make/O/N=1/DF $(curr_tsr_refname)
        Wave/DF TSR_PTRS = $(curr_tsr_refname)
		TSR_PTRS[0] = NewFreeDataFolder()
//		SetWaveLock 1, TSR_PTRS
	endif
	return TSR_PTRS[0]
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
  
    DFREF curr_tsr_ref = IgorUnit_getCurrentTSR()
    TSR_persist(tsr, curr_tsr_ref)

    String results = TSR_runAllTests(tsr)
    KillDataFolder curr_tsr_ref
    return results
End

Function runAllTests()
  print runAllTests_getResults()
End

Function test_TestTest()
    ASSERT(1 == 2)
    EXPECT(1 == 2)
    ASSERT(1 == 2)
End

#endif