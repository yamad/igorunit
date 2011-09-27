#pragma rtGlobals=1		// Use modern global access method.

#ifndef IGORUNIT_ASSERT
#define IGORUNIT_ASSERT

Function/S EXPECTED_ERROR_MSG(expected, actual)
  String expected, actual
  String msg
  sprintf msg, "Expected <%s>, but was <%s>", expected, actual
  return msg
End

#endif
