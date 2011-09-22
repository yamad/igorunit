#pragma rtGlobals=1		// Use modern global access method.

#ifndef IGORUNIT_ASSERT
#define IGORUNIT_ASSERT

#include "utils"

Function assert(condition)
	Variable condition
	if (condition)
		return TRUE
	endif
	Abort "Assertion failed"
End

// Return false if the condition is false, but do not abort
Function soft_assert(condition)
	Variable condition
	if (condition)
		return TRUE
	endif
	return FALSE
End

Function fail()
	return FALSE
End

Function assertTrue(condition)
	Variable condition
	assert(condition)
End

Function assertFalse(condition)
	Variable condition
	return !assert(condition)
End

Function isInf(number)
    Variable number
    return soft_assert(numtype(number) == 1)
End

Function assertIsInf(number)
    Variable number
    assert(isInf(number))
End

Function isNaN(number)
    Variable number
    return soft_assert(numtype(number) == 2)
End

Function assertIsNaN(number)
    Variable number
    assert(isNaN(number))
End

Function/S EXPECTED_ERROR_MSG(expected, actual)
  String expected, actual
  sprintf msg, "Expected <%s>, but was <%s>", expected, actual
  return msg
End

#endif