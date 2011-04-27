#pragma rtGlobals=1		// Use modern global access method.

// Assert function tests 
//   Use print statements to run these tests to keep things basic. Don't
//   use the assert statements themselves, because that is what we are
//   testing.
//
//   TRUE = 1, FALSE = 0. These are defined as constants elsewhere, so
//   reduce dependencies and name collisions, just use plain old 0 and
//   1 in this file.

#include "assert"

Function test_assert_integer_equals()
    try
        assert(5 == 5)
        return 1
    catch
        return 0
    endtry
End

Function test_assert_integer_notequals()
    try
        assert(5 == 4)
        return 0
    catch
        return 1
    endtry
End

Function test_assert_floats_equals()
    try
        assert(1.0 == 1.0)
        return 1
    catch
        return 0
    endtry
End

Function test_assert_floats_notequals()
    try
        assert(1.0 == 1.1)
        return 0
    catch
        return 1
    endtry
End

Function test_fail()
    if (!fail())
        return 1
    endif
    return 0
End

Function test_assertTrue()
    if (assertTrue(1))
        return 1
    endif
    return 0
End

Function test_assertFalse()
    if (assertFalse(0))
        return 1
    endif
    return 0
End

Function test_isPosInf()
    if (isInf(Inf))
        return 1
    endif
    return 0
End

Function test_isNegInf()
    if (isInf(-Inf))
        return 1
    endif
    return 0
End

Function test_isInfNotNumber()
    if (!isInf(2))
        return 1
    endif
    return 0
End

Function test_isNaN()
    if (isNaN(NaN))
        return 1
    endif
    return 0
End

Function test_isNaNNotNumber()
    if (!isNaN(2))
        return 1
    endif
    return 0
End

Function assertTest_runTests()
    print test_assert_integer_equals()
    print test_assert_integer_notequals()
    print test_assert_floats_equals()
    print test_assert_floats_notequals()
    print test_isPosInf()
    print test_isNegInf()
    print test_isInfNotNumber()
    print test_isNaN()
    print test_isNaNNotNumber()
End