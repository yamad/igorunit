#pragma rtGlobals=1		// Use modern global access method.

// Assertion -- a component of IgorUnit
//   This data type represents a single assertion test

#ifndef IGORUNIT_ASSERTION
#define IGORUNIT_ASSERTION

#include "stackinfoutils"

Constant ASSERTION_UNKNOWN = 0
Constant ASSERTION_SUCCESS = 1
Constant ASSERTION_FAILURE = 2

// Assertion Type Codes (at_*)
Constant at_ASSERT_UNKNOWN = 0
Constant at_ASSERT = 1
Constant at_EXPECT = 2
Constant at_ASSERT_STREQ = 3
Constant at_EXPECT_STREQ = 4

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
    Assertion_set(a, at_ASSERT_UNKNOWN, "", "", "")
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

Function Assertion_initAuto(a)
    STRUCT Assertion &a

    String stack_info = Stack_getPartialNegativeIndex(1)
    String assert_name = StackRow_getFunctionName(Stack_getLastRow(stack_info))

    Assertion_init(a)
    Assertion_setTypeName(a, assert_name)
    Assertion_setStackInfo(a, stack_info)
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

Function Assertion_autosetType(a)
    STRUCT Assertion &a
    String stack_info = Stack_getPartialNegativeIndex(1)
    String stack_row = Stack_getLastRow(stack_info)
    Assertion_setTypeName(a, StackRow_getFunctionName(stack_row))
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

Function Assertion_getResult(a)
    STRUCT Assertion &a
    return a.result_code
End

Function/S Assertion_getParams(a)
    STRUCT Assertion &a
    return a.param_list
End

Function/S Assertion_getStack(a)
    STRUCT Assertion &a
    return a.stack_info
End

Function Assertion_getLineNumber(a)
    STRUCT Assertion &a
    String stack_info = Assertion_getStack(a)
    Variable stack_len = Stack_getLength(stack_info)
    String stack_row = Stack_getRow(stack_info, stack_len - 2)
    return StackRow_getLineNumber(stack_row)
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
        case at_ASSERT:
            return "ASSERT"
        case at_EXPECT:
            return "EXPECT"
        case at_ASSERT_STREQ:
            return "ASSERT_STREQ"
        case at_EXPECT_STREQ:
            return "EXPECT_STREQ"
        default:
            return "UNKNOWN ASSERT TYPE"
    endswitch
End

Function Assert_getTypeCode(assert_name)
    String assert_name

    strswitch(assert_name)
        case "ASSERT":
            return at_ASSERT
        case "EXPECT":
            return at_EXPECT
        case "ASSERT_STREQ":
            return at_ASSERT_STREQ
        case "EXPECT_STREQ":
            return at_EXPECT_STREQ
        default:
            return at_ASSERT_UNKNOWN
    endswitch
End

#endif

