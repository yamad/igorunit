#pragma rtGlobals=1		// Use modern global access method.

// Assertion -- a component of IgorUnit
//   This data type represents a single assertion test

#ifndef IGORUNIT_ASSERTION
#define IGORUNIT_ASSERTION

#include "stackinfoutils"

Constant ASSERTION_UNKNOWN = 0
Constant ASSERTION_SUCCESS = 1
Constant ASSERTION_FAILURE = 2

Constant ASSERT_UNKNOWN = 0
Constant ASSERT_ASSERT = 1
Constant ASSERT_EXPECT = 2

Structure Assertion
    Variable assert_type
    Variable result_code
    String param_list
    String stack_info
    String message
    Variable test_idx
EndStructure

Function Assertion_init(a)
    STRUCT Assertion &a
    Assertion_set(a, ASSERT_UNKNOWN, "", "", "")
    a.result_code = ASSERTION_UNKNOWN
    a.test_idx = -1
End

Function Assertion_set(a, assert_type, param_list, stack_info, message)
    STRUCT Assertion &a
    Variable assert_type
    String param_list, stack_info, message

    a.assert_type = assert_type
    a.param_list = param_list
    a.stack_info = stack_info
    a.message = message
End

Function Assertion_initAuto(a, assert_name, param_list, message)
    STRUCT Assertion &a
    String assert_name, param_list, message
    Assertion_setTypeName(a, assert_name)
    Assertion_setStackInfo(a, Stack_getPartialNegativeIndex(2))
    Assertion_setParams(a, param_list)
    Assertion_setMessage(a, message)
End

Function Assertion_setResult(a, result_code)
    STRUCT Assertion &a
    Variable result_code
    a.result_code = result_code
End

Function Assertion_setTestIndex(a, test_idx)
    STRUCT Assertion &a
    Variable test_idx
    a.test_idx = test_idx
End

Function Assertion_setTest(a, test)
    STRUCT Assertion &a
    STRUCT UnitTest &test
    a.test_idx = UnitTest_getIndex(test)
End

Function Assertion_setType(a, assert_type)
    STRUCT Assertion &a
    Variable assert_type
    a.assert_type = assert_type
End

Function Assertion_setTypeName(a, assert_name)
    STRUCT Assertion &a
    String assert_name
    a.assert_type = Assert_getTypeCode(assert_name)
End

Function Assertion_setStackInfo(a, stack_info)
    STRUCT Assertion &a
    String stack_info
    a.stack_info = stack_info
End

Function Assertion_setMessage(a, message)
    STRUCT Assertion &a
    String message
    a.message = message
End

Function Assertion_autosetStackInfo(a)
    STRUCT Assertion &a
    Assertion_setStackInfo(a, Stack_getPartialNegativeIndex(1))
End

Function Assertion_setParams(a, param_list)
    STRUCT Assertion &a
    String param_list
    a.param_list = param_list
End

Function Assertion_getType(a)
    STRUCT Assertion &a
    return a.assert_type
End

Function/S Assertion_getParams(a)
    STRUCT Assertion &a
    return a.param_list
End

Function/S Assertion_getStack(a)
    STRUCT Assertion &a
    return a.stack_info
End

Function/S Assertion_getMessage(a)
    STRUCT Assertion &a
    return a.message
End

Function/S Assertion_getTypeName(a)
    STRUCT Assertion &a
    return Assert_getTypeName(Assertion_getType(a))
End

Function/S Assert_getTypeName(assert_type)
    Variable assert_type

    switch(assert_type)
        case ASSERT_ASSERT:
            return "ASSERT"
        case ASSERT_EXPECT:
            return "EXPECT"
        default:
            return "UNKNOWN ASSERT TYPE"
    endswitch
End

Function Assert_getTypeCode(assert_name)
    String assert_name

    strswitch(assert_name)
        case "ASSERT":
            return ASSERT_ASSERT
        case "EXPECT":
            return ASSERT_EXPECT
        default:
            return ASSERT_UNKNOWN
    endswitch
End

#endif

