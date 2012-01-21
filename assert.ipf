#pragma rtGlobals=1		// Use modern global access method.

#ifndef IGORUNIT_ASSERT
#define IGORUNIT_ASSERT

Constant ASSERTION_FAILURE = 1

Function ASSERT_TRUE(condition, [err_msg])
	Variable condition
	String err_msg
	
	if (ParamIsDefault(err_msg))
		err_msg = ""
	endif
End

End

Function/S EXPECTED_ERROR_MSG(expected, actual)
  String expected, actual
  String msg
  sprintf msg, "Expected <%s>, but was <%s>", expected, actual
  return msg
End

Constant TEST_SUCCESS = 1
Constant TEST_FAILURE = 2

Function EXPECT(condition, [fail_msg, test_type])
    Variable condition
    String fail_msg
    Variable test_type

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    if (ParamIsDefault(test_type))
        test_type = Assert_getTypeCode("EXPECT")
    endif

    Variable test_status

    STRUCT TestSuiteRunner tsr
    TSR_load(tsr, IgorUnit_getCurrentTSR())
    
    STRUCT UnitTest test
    String call_stack = IgorUnit_getCallingStack()
    String call_row = Stack_getLastRow(call_stack)
    String funcname = StackRow_getFunctionName(call_row)
    UnitTest_init(test, "", funcname, funcname)

    if (condition)
        TR_addSuccess(tsr.test_result, test, fail_msg)
        test_status = TEST_SUCCESS
    else
        TR_addFailure(tsr.test_result, test, fail_msg)
        test_status = TEST_FAILURE
    endif
    TSR_persist(tsr, IgorUnit_getCurrentTSR())
    return test_status
End

Function ASSERT(condition, [fail_msg])
    Variable condition
    String fail_msg

    if (ParamIsDefault(fail_msg))
        fail_msg = ""
    endif

    Variable test_status = EXPECT(condition, fail_msg=fail_msg)
    if (test_status == TEST_FAILURE)
        AbortOnValue 1, ASSERTION_FAILURE
    endif
End

Constant ASSERT_UNKNOWN = 0
Constant ASSERT_ASSERT = 1
Constant ASSERT_EXPECT = 2

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