#pragma rtGlobals=1		// Use modern global access method.

// Assertion -- a component of IgorUnit
//   This data type represents a single assertion test

#ifndef IGORUNIT_ASSERTION
#define IGORUNIT_ASSERTION

// Assertion Status/Result Codes
Constant ASSERTION_UNKNOWN = 1
Constant ASSERTION_FAILURE = 2
Constant ASSERTION_SUCCESS = 3
Constant ASSERTION_IGNORETEST = 4

// Assertion Type Codes (ATC_*)
Constant ATC_ASSERT_UNKNOWN = 0
Constant ATC_ASSERT = 1
Constant ATC_EXPECT = 2
Constant ATC_ASSERT_TRUE = 3
Constant ATC_EXPECT_TRUE = 4
Constant ATC_ASSERT_FALSE = 5
Constant ATC_EXPECT_FALSE = 6
Constant ATC_ASSERT_EQ = 7
Constant ATC_EXPECT_EQ = 8
Constant ATC_ASSERT_NE = 9
Constant ATC_EXPECT_NE = 10
Constant ATC_ASSERT_LT = 11
Constant ATC_EXPECT_LT = 12
Constant ATC_ASSERT_LE = 13
Constant ATC_EXPECT_LE = 14
Constant ATC_ASSERT_GT = 15
Constant ATC_EXPECT_GT = 16
Constant ATC_ASSERT_GE = 17
Constant ATC_EXPECT_GE = 18
Constant ATC_ASSERT_EQ_C = 19
Constant ATC_EXPECT_EQ_C = 20
Constant ATC_ASSERT_NE_C = 21
Constant ATC_EXPECT_NE_C = 22
Constant ATC_ASSERT_STREQ = 23
Constant ATC_EXPECT_STREQ = 24
Constant ATC_ASSERT_STRNE = 25
Constant ATC_EXPECT_STRNE = 26
Constant ATC_ASSERT_STRCASEEQ = 27
Constant ATC_EXPECT_STRCASEEQ = 28
Constant ATC_ASSERT_STRCASENE = 29
Constant ATC_EXPECT_STRCASENE = 30
Constant ATC_SUCCEED = 31
Constant ATC_EXPECT_SUCCEED = 32
Constant ATC_FAIL = 33
Constant ATC_EXPECT_FAIL = 34
Constant ATC_IGNORE_TEST = 35

Structure Assertion
    Variable assert_type
    Variable result_code
    String param_list
    String stack_info
    String message
    String std_message
    Variable test_idx
EndStructure

Function Assertion_init(a)
    STRUCT Assertion &a
    Assertion_set(a, ATC_ASSERT_UNKNOWN, "", "", "")
    a.std_message = ""
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

Function Assertion_setStdMessage(a, message)
    STRUCT Assertion &a
    String message
    a.std_message = message
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

Function/S Assertion_getStdMessage(a)
    STRUCT Assertion &a
    return a.std_message
End

Function/S Assertion_getFullMessage(a)
    STRUCT Assertion &a

    String msg = Assertion_getMessage(a)
    String std_msg = Assertion_getStdMessage(a)

    String msg_out = msg
    if (isStringExists(std_msg))
        if (isStringExists(msg_out))
            sprintf msg_out, "%s : %s", std_msg, msg_out
        else
            msg_out = std_msg
        endif
    endif
    return msg_out
End

Function/S Assertion_getTypeName(a)
    STRUCT Assertion &a
    return Assert_getTypeName(Assertion_getType(a))
End

Function/S Assert_getTypeName(assert_type)
    Variable assert_type

    switch(assert_type)
        case ATC_ASSERT:
            return "ASSERT"
        case ATC_EXPECT:
            return "EXPECT"
        case ATC_ASSERT_TRUE:
            return "ASSERT_TRUE"
        case ATC_EXPECT_TRUE:
            return "EXPECT_TRUE"
        case ATC_ASSERT_FALSE:
            return "ASSERT_FALSE"
        case ATC_EXPECT_FALSE:
            return "EXPECT_FALSE"
        case ATC_ASSERT_EQ:
            return "ASSERT_EQ"
        case ATC_EXPECT_EQ:
            return "EXPECT_EQ"
        case ATC_ASSERT_NE:
            return "ASSERT_NE"
        case ATC_EXPECT_NE:
            return "EXPECT_NE"
        case ATC_ASSERT_LT:
            return "ASSERT_LT"
        case ATC_EXPECT_LT:
            return "EXPECT_LT"
        case ATC_ASSERT_LE:
            return "ASSERT_LE"
        case ATC_EXPECT_LE:
            return "EXPECT_LE"
        case ATC_ASSERT_GT:
            return "ASSERT_GT"
        case ATC_EXPECT_GT:
            return "EXPECT_GT"
        case ATC_ASSERT_GE:
            return "ASSERT_GE"
        case ATC_EXPECT_GE:
            return "EXPECT_GE"
        case ATC_ASSERT_EQ_C:
            return "ASSERT_EQ_C"
        case ATC_EXPECT_EQ_C:
            return "EXPECT_EQ_C"
        case ATC_ASSERT_NE_C:
            return "ASSERT_NE_C"
        case ATC_EXPECT_NE_C:
            return "EXPECT_NE_C"
        case ATC_ASSERT_STREQ:
            return "ASSERT_STREQ"
        case ATC_EXPECT_STREQ:
            return "EXPECT_STREQ"
        case ATC_ASSERT_STRNE:
            return "ASSERT_STRNE"
        case ATC_EXPECT_STRNE:
            return "EXPECT_STRNE"
        case ATC_ASSERT_STRCASEEQ:
            return "ASSERT_STRCASEEQ"
        case ATC_EXPECT_STRCASEEQ:
            return "EXPECT_STRCASEEQ"
        case ATC_ASSERT_STRCASENE:
            return "ASSERT_STRCASENE"
        case ATC_EXPECT_STRCASENE:
            return "EXPECT_STRCASENE"
        case ATC_SUCCEED:
            return "SUCCEED"
        case ATC_EXPECT_SUCCEED:
            return "EXPECT_SUCCEED"
        case ATC_FAIL:
            return "FAIL"
        case ATC_EXPECT_FAIL:
            return "EXPECT_FAIL"
        case ATC_IGNORE_TEST:
            return "IGNORE_TEST"
        case ATC_ASSERT_UNKNOWN:
        default:
            return "UNKNOWN_ASSERT"
    endswitch
End

Function Assert_getTypeCode(assert_name)
    String assert_name

    strswitch(assert_name)
        case "ASSERT":
            return ATC_ASSERT
        case "EXPECT":
            return ATC_EXPECT
        case "ASSERT_TRUE":
            return ATC_ASSERT_TRUE
        case "EXPECT_TRUE":
            return ATC_EXPECT_TRUE
        case "ASSERT_FALSE":
            return ATC_ASSERT_FALSE
        case "EXPECT_FALSE":
            return ATC_EXPECT_FALSE
        case "ASSERT_EQ":
            return ATC_ASSERT_EQ
        case "EXPECT_EQ":
            return ATC_EXPECT_EQ
        case "ASSERT_NE":
            return ATC_ASSERT_NE
        case "EXPECT_NE":
            return ATC_EXPECT_NE
        case "ASSERT_LT":
            return ATC_ASSERT_LT
        case "EXPECT_LT":
            return ATC_EXPECT_LT
        case "ASSERT_LE":
            return ATC_ASSERT_LE
        case "EXPECT_LE":
            return ATC_EXPECT_LE
        case "ASSERT_GT":
            return ATC_ASSERT_GT
        case "EXPECT_GT":
            return ATC_EXPECT_GT
        case "ASSERT_GE":
            return ATC_ASSERT_GE
        case "EXPECT_GE":
            return ATC_EXPECT_GE
        case "ASSERT_EQ_C":
            return ATC_ASSERT_EQ_C
        case "EXPECT_EQ_C":
            return ATC_EXPECT_EQ_C
        case "ASSERT_NE_C":
            return ATC_ASSERT_NE_C
        case "EXPECT_NE_C":
            return ATC_EXPECT_NE_C
        case "ASSERT_STREQ":
            return ATC_ASSERT_STREQ
        case "EXPECT_STREQ":
            return ATC_EXPECT_STREQ
        case "ASSERT_STRNE":
            return ATC_ASSERT_STRNE
        case "EXPECT_STRNE":
            return ATC_EXPECT_STRNE
        case "ASSERT_STRCASEEQ":
            return ATC_ASSERT_STRCASEEQ
        case "EXPECT_STRCASEEQ":
            return ATC_EXPECT_STRCASEEQ
        case "ASSERT_STRCASENE":
            return ATC_ASSERT_STRCASENE
        case "EXPECT_STRCASENE":
            return ATC_EXPECT_STRCASENE
        case "SUCCEED":
            return ATC_SUCCEED
        case "EXPECT_SUCCEED":
            return ATC_EXPECT_SUCCEED
        case "FAIL":
            return ATC_FAIL
        case "EXPECT_FAIL":
            return ATC_EXPECT_FAIL
        case "IGNORE_TEST":
            return ATC_IGNORE_TEST
        case "ASSERT_UNKNOWN":
        default:
            return ATC_ASSERT_UNKNOWN
    endswitch
End

#endif

