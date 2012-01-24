#pragma rtGlobals=1		// Use modern global access method.

#ifndef IGORUNIT_ASSERT
#define IGORUNIT_ASSERT

#include "stringutils"

#include "Assertion"

Constant ASSERTION_SUCCESS = 1
Constant ASSERTION_FAILURE = 2

Constant TEST_UNKNOWN = 0
Constant TEST_SUCCESS = 1
Constant TEST_FAILURE = 2
Constant TEST_ERROR = 3

Function ASSERT_TRUE(condition, [err_msg])
	Variable condition
	String err_msg
	
	if (ParamIsDefault(err_msg))
		err_msg = ""
	endif
End

Function/S EXPECTED_ERROR_MSG(expected, actual)
  String expected, actual
  String msg
  sprintf msg, "Expected <%s>, but was <%s>", expected, actual
  return msg
End

Function EXPECT(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    String params
	sprintf params, "%.16g", condition

    STRUCT Assertion a
    Assertion_init(a)
    Assertion_setTypeName(a, "EXPECT")
    Assertion_setParams(a, params)
    Assertion_autosetStackInfo(a)

    ASSERT_BASE(condition, fail_msg, a)
End

Function ASSERT_BASE(condition, fail_msg, assertion)
    Variable condition
    String fail_msg
    STRUCT Assertion &assertion

    STRUCT TestSuiteRunner tsr
    TSR_load(tsr, IgorUnit_getCurrentTSR())

    STRUCT UnitTest test
    UnitTest_load(test, IgorUnit_getCurrentUnitTest())

    if (condition)
        TR_addAssertSuccess(tsr.test_result, test, assertion)
        tsr.curr_test_status = TEST_SUCCESS
    else
        TR_addAssertFailure(tsr.test_result, test, assertion)
        tsr.curr_test_status = TEST_FAILURE
    endif
    TSR_persist(tsr, IgorUnit_getCurrentTSR())
    return tsr.curr_test_status
End

Function ASSERT(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    String params
	sprintf params, "%.16g", condition

    STRUCT Assertion a
    Assertion_initAuto(a, "ASSERT", params, fail_msg)

    Variable test_status = ASSERT_BASE(condition, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End


#endif