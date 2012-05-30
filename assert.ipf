#pragma rtGlobals=1		// Use modern global access method.

#ifndef IGORUNIT_ASSERT
#define IGORUNIT_ASSERT

#include "stringutils"
#include "numutils"

#include "Assertion"

Constant TEST_UNKNOWN = 0
Constant TEST_SUCCESS = 1
Constant TEST_FAILURE = 2
Constant TEST_ERROR = 3

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
        // signal success if test has not failed in a previous assert
        if (tsr.curr_test_status != TEST_FAILURE && tsr.curr_test_status != TEST_ERROR)
            tsr.curr_test_status = TEST_SUCCESS
        endif
    else
        assertion.message = fail_msg
        TR_addAssertFailure(tsr.test_result, test, assertion)
        tsr.curr_test_status = TEST_FAILURE
    endif
    TSR_persist(tsr, IgorUnit_getCurrentTSR())
    return tsr.curr_test_status
End

Function TEST_TRUE(condition, assertion)
    Variable condition
    STRUCT Assertion &assertion

    String params
	sprintf params, "%.16g", condition
    Assertion_setParams(assertion, params)

	return (condition)
End

Function EXPECT_TRUE(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_TRUE(condition, a)    
    ASSERT_BASE(passed, fail_msg, a)    
End

Function ASSERT_TRUE(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_TRUE(condition, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Alias for EXPECT_TRUE
Function EXPECT(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif
    EXPECT_TRUE(condition, fail_msg=fail_msg)
End

// Alias for ASSERT_TRUE
Function ASSERT(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif
    ASSERT_TRUE(condition, fail_msg=fail_msg)
End

// False truth test (*_FALSE)
Function EXPECT_FALSE(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_TRUE(!(condition), a)    
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_FALSE(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_TRUE(!(condition), a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Equal (EQ)
Function TEST_EQ(expected, actual, tolerance, assertion)
	Variable expected
	Variable actual
	Variable tolerance
    STRUCT Assertion &assertion
	
	String params
	sprintf params, "%.16g, %.16g, %.16g", expected, actual, tolerance
    Assertion_setParams(assertion, params)

    String err_msg = EXPECTED_ERROR_MSG(num2str(expected), num2str(actual))
    Assertion_setMessage(assertion, err_msg)
	
	Variable ntExpected = numtype(expected)
	Variable ntActual = numtype(actual)
	if (ntExpected != ntActual) // values have different types
		return FALSE
	else
		if (ntExpected == 1)    // both values are either +/-Inf
			return (expected == actual)
		elseif (ntExpected == 2) // both values are NaN
			return TRUE
		else                    // compare values, within tolerance
			return (abs(expected - actual) <= tolerance)
		endif
	endif
End

Function EXPECT_EQ(expected, actual, [tolerance, fail_msg])
	Variable expected
	Variable actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_EQ(expected, actual, tolerance, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_EQ(expected, actual, [tolerance, fail_msg])
	Variable expected
	Variable actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_EQ(expected, actual, tolerance, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Not Equal (NE)
Function EXPECT_NE(expected, actual, [tolerance, fail_msg])
	Variable expected
	Variable actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        String msg_format = "Expected <%s> should not equal actual <%s>"
        sprintf fail_msg, msg_format, num2str(expected), num2str(actual)
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_EQ(expected, actual, tolerance, a)
    Assertion_setMessage(a, fail_msg)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_NE(expected, actual, [tolerance, fail_msg])
	Variable expected
	Variable actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        String msg_format = "Expected <%s> should not equal actual <%s>"
        sprintf fail_msg, msg_format, num2str(expected), num2str(actual)
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_EQ(expected, actual, tolerance, a)
    Assertion_setMessage(a, fail_msg)

    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Less than (LT)
Function TEST_LT(val1, val2, assertion)
	Variable val1
	Variable val2
    STRUCT Assertion &assertion

	String params
	sprintf params, "%.16g, %.16g", val1, val2
    Assertion_setParams(assertion, params)
	
	return (val1 < val2)
End

Function EXPECT_LT(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_LT(val1, val2, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_LT(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_LT(val1, val2, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Less than or equal to (LE)
Function TEST_LE(val1, val2, assertion)
	Variable val1
	Variable val2
    STRUCT Assertion &assertion

	String params
	sprintf params, "%.16g, %.16g", val1, val2
    Assertion_setParams(assertion, params)

    if (isNaN(val1) && isNaN(val2))
        return TRUE
    endif
	return (val1 <= val2)
End

Function EXPECT_LE(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_LE(val1, val2, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_LE(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_LE(val1, val2, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Greater than (GT)
Function TEST_GT(val1, val2, assertion)
	Variable val1
	Variable val2
    STRUCT Assertion &assertion

	String params
	sprintf params, "%.16g, %.16g", val1, val2
    Assertion_setParams(assertion, params)
	
	return (val1 > val2)
End

Function EXPECT_GT(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_GT(val1, val2, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_GT(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_GT(val1, val2, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Greater than or equal to (GE)
Function TEST_GE(val1, val2, assertion)
	Variable val1
	Variable val2
    STRUCT Assertion &assertion

	String params
	sprintf params, "%.16g, %.16g", val1, val2
    Assertion_setParams(assertion, params)

    if (isNaN(val1) && isNaN(val2))
        return TRUE
    endif
    return (val1 >= val2)
End

Function EXPECT_GE(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_GE(val1, val2, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_GE(val1, val2, [fail_msg])
	Variable val1, val2
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_GE(val1, val2, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Complex numbers tests
Function TEST_EQ_C(expected, actual, tol, assertion)
	Variable/C expected
	Variable/C actual
	Variable tol
    STRUCT Assertion &assertion
	
	Variable realsEqual = FALSE
    Variable imagsEqual = FALSE
    Variable numsEqual = FALSE
    
    realsEqual = TEST_EQ(real(expected), real(actual), tol, assertion)
    if (realsEqual)
        imagsEqual = TEST_EQ(imag(expected), imag(actual), tol, assertion)
        if (imagsEqual)
            numsEqual = TRUE
        endif	
    endif

	String params
    String params_format = "(%.16g, %.16g), (%.16g, %.16g), %.16g"
	sprintf params, params_format, real(expected), imag(expected), real(actual), imag(actual), tol
    Assertion_setParams(assertion, params)

	return numsEqual
End

Function EXPECT_EQ_C(expected, actual, [tolerance, fail_msg])
	Variable/C expected
	Variable/C actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_EQ_C(expected, actual, tolerance, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_EQ_C(expected, actual, [tolerance, fail_msg])
	Variable/C expected
	Variable/C actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_EQ_C(expected, actual, tolerance, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// Complex Not Equal (NE_C)
Function EXPECT_NE_C(expected, actual, [tolerance, fail_msg])
	Variable/C expected
	Variable/C actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        String msg_format = "Expected <%s> should not equal actual <%s>"
        sprintf fail_msg, msg_format, num2str(expected), num2str(actual)
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_EQ_C(expected, actual, tolerance, a)
    Assertion_setMessage(a, fail_msg)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_NE_C(expected, actual, [tolerance, fail_msg])
	Variable/C expected
	Variable/C actual
	Variable tolerance
    String fail_msg

    if (ParamIsDefault(tolerance))
        tolerance = 0
    endif
    if (ParamIsDefault(fail_msg))
        String msg_format = "Expected <%s> should not equal actual <%s>"
        sprintf fail_msg, msg_format, num2str(expected), num2str(actual)
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_EQ_C(expected, actual, tolerance, a)
    Assertion_setMessage(a, fail_msg)

    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// String Equality (STREQ)
Function TEST_STREQ(expected, actual, case_sensitive, assertion)
	String expected
	String actual
	Variable case_sensitive
    STRUCT Assertion &assertion

    // check for null strings before 
    Variable isExpectedNull = isStringNull(expected)
    Variable isActualNull = isStringNull(actual)
    if (isExpectedNull && isActualNull)
        return TRUE             // both are null, so are equal
    elseif (isExpectedNull || isActualNull)
        return FALSE            // one is null, so not equal
    endif
	
    if (case_sensitive)
        return isStringsEqual(expected, actual)
    else
        return isStringsEqual_NoCase(expected, actual)
    endif
End


// String equality, case sensitive (*_STREQ)
Function EXPECT_STREQ(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_STREQ(expected, actual, TRUE, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_STREQ(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_STREQ(expected, actual, TRUE, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// String inequality, case sensitive (*_STRNE)
Function EXPECT_STRNE(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_STREQ(expected, actual, TRUE, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_STRNE(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_STREQ(expected, actual, TRUE, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// String equality, case insensitive (*_STRCASEEQ)
Function EXPECT_STRCASEEQ(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_STREQ(expected, actual, FALSE, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_STRCASEEQ(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = TEST_STREQ(expected, actual, FALSE, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

// String inequality, case insensitive (*_STRCASENE)
Function EXPECT_STRCASENE(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_STREQ(expected, actual, FALSE, a)
    ASSERT_BASE(passed, fail_msg, a)
End

Function ASSERT_STRCASENE(expected, actual, [fail_msg])
	String expected
	String actual
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable passed = !TEST_STREQ(expected, actual, FALSE, a)
    Variable test_status = ASSERT_BASE(passed, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

Function SUCCEED([fail_msg])
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)
    ASSERT_BASE(TRUE, fail_msg, a)
End

Function EXPECT_FAIL([fail_msg])
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)
    ASSERT_BASE(FALSE, fail_msg, a)
End

Function FAIL([fail_msg])
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    STRUCT Assertion a
    Assertion_initAuto(a)

    Variable test_status = ASSERT_BASE(FALSE, fail_msg, a)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End


Function/S EXPECTED_ERROR_MSG(expected, actual)
  String expected, actual
  String msg
  sprintf msg, "Expected <%s>, but was <%s>", expected, actual
  return msg
End

#endif