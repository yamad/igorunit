// Tests for assertion functions.
//    tests are adapted from Adam Light's "Autotest" framework
#include "IgorUnit"

Function utest_TRUE()
	// Assertions that should pass.
	EXPECT_TRUE(1)
	EXPECT_TRUE(inf)
	EXPECT_TRUE(-inf)
	EXPECT_TRUE(1e-235)
	EXPECT_TRUE(1e235)
	EXPECT_TRUE(-1)
	ASSERT_TRUE(1)
	ASSERT_TRUE(inf)
	ASSERT_TRUE(-inf)
	ASSERT_TRUE(1e-235)
	ASSERT_TRUE(1e235)
	ASSERT_TRUE(-1)
End

Function utest_TRUE_failures()
	EXPECT_TRUE(0, fail_msg="Should fail")
	ASSERT_TRUE(0, fail_msg="Should fail (fatally)")
	EXPECT_TRUE(0, fail_msg="***Should not be executed at all in the first place***")
End

// ASSERT_EQ should fatally abort on failure
Function utest_Assert__ASSERT_EQ_aborts()
    try
        ASSERT_EQ(1, 2)
    catch
        if (V_AbortCode == ASSERTION_FAILURE)
            SUCCEED()
        endif
    endtry
End

// Test EXPECT_FALSE and ASSERT_FALSE
Function utest_FALSE()
	// Assertions that should fail.
	EXPECT_FALSE(1, fail_msg="Should fail")
    EXPECT_FALSE(NaN, fail_msg="Should fail")
	EXPECT_FALSE(inf, fail_msg="Should fail")
	EXPECT_FALSE(-inf, fail_msg="Should fail")
	EXPECT_FALSE(1e-235, fail_msg="Should fail")
	EXPECT_FALSE(1e235, fail_msg="Should fail")
	EXPECT_FALSE(-1, fail_msg="Should fail")
	EXPECT_FALSE(-1, fail_msg="Should fail")
	EXPECT_FALSE(0, fail_msg="Should pass")
	ASSERT_FALSE(0, fail_msg="Should pass")
	ASSERT_FALSE(1, fail_msg="Should fail (fatally)")
	EXPECT_FALSE(1, fail_msg="***Should not be executed at all in the first place***")
End

Constant kTOLs = 1e-6           // single precision tolerance
Constant kTOLd = 1e-13          // double precision tolerance
// Test EXPECT_EQ and ASSERT_EQ
Function utest_EQ()
	// Assertions that should pass.
	EXPECT_EQ(-inf, -inf, tol=kTOLd, fail_msg="Should pass")
	EXPECT_EQ(inf, inf, tol=kTOLd, fail_msg="Should pass")
	EXPECT_EQ(NaN, NaN, tol=kTOLd, fail_msg="Should pass")
	EXPECT_EQ(NaN, -NaN, tol=kTOLd, fail_msg="Should pass")	// Signed bit of NaN should be ignored
	EXPECT_EQ(-1, -1, tol=kTOLd, fail_msg="Should pass")
	EXPECT_EQ(1, 1, tol=kTOLd, fail_msg="Should pass")
	EXPECT_EQ(0, 0, tol=kTOLd, fail_msg="Should pass")
	EXPECT_EQ(1, 1, fail_msg="Should pass")
	EXPECT_EQ(inf * 0, NaN, fail_msg="Should pass")
	EXPECT_EQ(0, 0, fail_msg="Should pass")
	EXPECT_EQ(sqrt(-1), NaN, fail_msg="Should pass")
	EXPECT_EQ(kTOLd * 0.999, 0, tol=kTOLd, fail_msg="Should pass")	// due to tolerance
	EXPECT_EQ(1234567890e256, 1234567890e256, tol=kTOLd, fail_msg="Should pass")

	ASSERT_EQ(-inf, -inf, tol=kTOLd, fail_msg="Should pass")
	ASSERT_EQ(inf, inf, tol=kTOLd, fail_msg="Should pass")
	ASSERT_EQ(NaN, NaN, tol=kTOLd, fail_msg="Should pass")
	ASSERT_EQ(NaN, -NaN, tol=kTOLd, fail_msg="Should pass")	// Signed bit of NaN should be ignored
	ASSERT_EQ(-1, -1, tol=kTOLd, fail_msg="Should pass")
	ASSERT_EQ(1, 1, tol=kTOLd, fail_msg="Should pass")
	ASSERT_EQ(0, 0, tol=kTOLd, fail_msg="Should pass")
	ASSERT_EQ(kTOLd * 0.999, 0, tol=kTOLd, fail_msg="Should pass")	// due to tolerance
	ASSERT_EQ(1234567890e256, 1234567890e256, tol=kTOLd, fail_msg="Should pass")
	ASSERT_EQ(1000.43 - 1000.0, .43, tol=kTOLd, fail_msg="Should pass")	// due to tolerance
End

Function utest_EQ_failures()
    // Assertions that should fail
	EXPECT_EQ(kTOLd * 0.999, 0, tol=kTOLd/2, fail_msg="Should fail")
	EXPECT_EQ(-kTOLd * 0.999, 0, tol=kTOLd/2, fail_msg="Should fail")
	EXPECT_EQ(inf, nan, tol=kTOLd, fail_msg="Should fail")
	EXPECT_EQ(-inf, nan, tol=kTOLd, fail_msg="Should fail")
	EXPECT_EQ(nan, inf, tol=kTOLd, fail_msg="Should fail")
	EXPECT_EQ(1, 2, tol=kTOLd, fail_msg="Should fail")
	EXPECT_EQ(kTOLd * 0.999, 0, fail_msg="Should fail")	// due to 0 tolerance
	EXPECT_EQ(1000.43 - 1000.0, .43, fail_msg="Should fail due to floating point rounding error")	// due to 0 tolerance


	// Fatal tests
	ASSERT_EQ(0, 0, fail_msg="Should pass")
	ASSERT_EQ(kTOLd * 0.999, 0, tol=kTOLd, fail_msg="Should pass")	// due to tolerance

	ASSERT_EQ(kTOLd * 0.999, 0, fail_msg="Should fail (fatally)")	// due to 0 tolerance
	ASSERT_EQ(kTOLd * 0.999, 0, fail_msg="***Should not be executed at all in the first place***")	// due to 0 tolerance
End

// Test EXPECT_NE and ASSERT_NE
Function utest_NE()
	// Assertions that should pass
	EXPECT_NE(kTOLd * 0.999, 0/2, fail_msg="Should pass")
	EXPECT_NE(-kTOLd * 0.999, 0/2, fail_msg="Should pass")
	EXPECT_NE(inf, nan, fail_msg="Should pass")
	EXPECT_NE(-inf, nan, fail_msg="Should pass")
	EXPECT_NE(nan, inf, fail_msg="Should pass")
	EXPECT_NE(1, 2, fail_msg="Should pass")
	EXPECT_NE(kTOLd * 0.999, 0, fail_msg="Should pass")
	EXPECT_NE(1000.43 - 1000.0, .43, fail_msg="Should pass due to floating point rounding error")

	// Assertions that should pass
	ASSERT_NE(kTOLd * 0.999, 0/2, fail_msg="Should pass")
	ASSERT_NE(-kTOLd * 0.999, 0/2, fail_msg="Should pass")
	ASSERT_NE(inf, nan, fail_msg="Should pass")
	ASSERT_NE(-inf, nan, fail_msg="Should pass")
	ASSERT_NE(nan, inf, fail_msg="Should pass")
	ASSERT_NE(1, 2, fail_msg="Should pass")
	ASSERT_NE(kTOLd * 0.999, 0, fail_msg="Should pass")
	ASSERT_NE(1000.43 - 1000.0, .43, fail_msg="Should pass")

	// Assertions that should fail.
	EXPECT_NE(-inf, -inf, fail_msg="Should fail")
	EXPECT_NE(inf, inf, fail_msg="Should fail")
	EXPECT_NE(NaN, NaN, fail_msg="Should fail")
	EXPECT_NE(NaN, -NaN, fail_msg="Should fail")	// Signed bit of NaN should be ignored
	EXPECT_NE(-1, -1, fail_msg="Should fail")
	EXPECT_NE(1, 1, fail_msg="Should fail")
	EXPECT_NE(0, 0, fail_msg="Should fail")
	EXPECT_NE(1, 1, fail_msg="Should fail")
	EXPECT_NE(0, 0, fail_msg="Should fail")
	EXPECT_NE(kTOLd * 0.999, kTOLd * 0.999, fail_msg="Should fail")
	EXPECT_NE(1234567890e256, 1234567890e256, fail_msg="Should fail")

	// Fatal tests
	ASSERT_NE(kTOLd * 0.999, kTOLd * 0.999, fail_msg="Should fail (fatally)")
	ASSERT_NE(kTOLd * 0.999, kTOLd * 0.999, fail_msg="***Should not be executed at all in the first place***")
End

// Test EXPECT_LT and ASSERT_LT
Function utest_LT()
	String message

	// Assertions that should pass
	message = "Should pass"
	EXPECT_LT(0, 0.999, fail_msg=message)
	EXPECT_LT(-1, 0, fail_msg=message)
	EXPECT_LT(1, 2, fail_msg=message)
	EXPECT_LT(-kTOLd * 0.999, 0, fail_msg=message)
	EXPECT_LT(-inf, inf, fail_msg=message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_LT(0, 0.999, fail_msg=message)
	ASSERT_LT(-1, 0, fail_msg=message)
	ASSERT_LT(1, 2, fail_msg=message)
	ASSERT_LT(-kTOLd * 0.999, 0, fail_msg=message)
	ASSERT_LT(-inf, inf, fail_msg=message)

	// Assertions that should fail.
	message = "Should fail"
	EXPECT_LT(inf, nan, fail_msg= message)
	EXPECT_LT(-inf, nan, fail_msg=message)
	EXPECT_LT(nan, inf, fail_msg=message)
	EXPECT_LT(-inf, -inf, fail_msg= message)
	EXPECT_LT(inf, inf, fail_msg= message)
	EXPECT_LT(NaN, NaN, fail_msg= message)
	EXPECT_LT(NaN, -NaN, fail_msg= message)	// Signed bit of NaN should be ignored
	EXPECT_LT(100, 0, fail_msg= message)
	EXPECT_LT(100, -100, fail_msg= message)
	EXPECT_LT(0, -100, fail_msg= message)
	EXPECT_LT(-1, -1, fail_msg= message)
	EXPECT_LT(1, 1, fail_msg= message)
	EXPECT_LT(0, 0, fail_msg= message)

	// Fatal tests
	ASSERT_LT(kTOLd * 0.999, kTOLd * 0.999, fail_msg="Should fail (fatally)")
	ASSERT_LT(kTOLd * 0.999, kTOLd * 0.999, fail_msg="***Should not be executed at all in the first place***")
End

// Test EXPECT_GT and ASSERT_GT
Function utest_GT()
	String message

	// Assertions that should pass
	message = "Should pass"
	EXPECT_GT(inf, -inf, fail_msg= message)
	EXPECT_GT(1, -1, fail_msg= message)
	EXPECT_GT(-1, -100, fail_msg= message)
	EXPECT_GT(0.1, 0, fail_msg= message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_GT(inf, -inf, fail_msg= message)
	ASSERT_GT(1, -1, fail_msg= message)
	ASSERT_GT(-1, -100, fail_msg= message)
	ASSERT_GT(0.1, 0, fail_msg= message)

	// Assertions that should fail.
	message = "Should fail"
	EXPECT_GT(inf, nan, fail_msg= message)
	EXPECT_GT(-inf, nan, fail_msg=message)
	EXPECT_GT(nan, inf, fail_msg=message)
	EXPECT_GT(-inf, -inf, fail_msg= message)
	EXPECT_GT(inf, inf, fail_msg= message)
	EXPECT_GT(NaN, NaN, fail_msg= message)
	EXPECT_GT(NaN, -NaN, fail_msg= message)	// Signed bit of NaN should be ignored
	EXPECT_GT(0, 0.999, fail_msg=message)
	EXPECT_GT(-1, 0, fail_msg=message)
	EXPECT_GT(1, 2, fail_msg=message)
	EXPECT_GT(-kTOLd * 0.999, 0, fail_msg=message)
	EXPECT_GT(-inf, inf, fail_msg=message)
	EXPECT_GT(0, 0, fail_msg=message)

	// Fatal tests
	ASSERT_GT(0, 0, fail_msg="Should fail (fatally)")
	ASSERT_GT(0, 0, fail_msg="***Should not be executed at all in the first place***")
End

// Test EXPECT_LE and ASSERT_LE
Function utest_LE()
	String message

	// Assertions that should pass
	message = "Should pass"
	EXPECT_LE(0, 0.999, fail_msg=message)
	EXPECT_LE(-1, 0, fail_msg=message)
	EXPECT_LE(1, 2, fail_msg=message)
	EXPECT_LE(1, 1, fail_msg=message)
	EXPECT_LE(NaN, NaN, fail_msg=message)
	EXPECT_LE(inf, inf, fail_msg=message)
	EXPECT_LE(-kTOLd * 0.999, 0, fail_msg=message)
	EXPECT_LE(-inf, inf, fail_msg=message)
	EXPECT_LE(0, 0, fail_msg= message)
	EXPECT_LE(NaN, -NaN, fail_msg= message)	// Signed bit of NaN should be ignored
	EXPECT_LE(1, 1, fail_msg= message)
	EXPECT_LE(-inf, -inf, fail_msg= message)
	EXPECT_LE(inf, inf, fail_msg= message)
	EXPECT_LE(-1, -1, fail_msg= message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_LE(0, 0.999, fail_msg=message)
	ASSERT_LE(-1, 0, fail_msg=message)
	ASSERT_LE(1, 2, fail_msg=message)
	ASSERT_LE(-kTOLd * 0.999, 0, fail_msg=message)
	ASSERT_LE(-inf, inf, fail_msg=message)

	// Assertions that should fail.
	message = "Should fail"
	EXPECT_LE(inf, nan, fail_msg= message)
	EXPECT_LE(-inf, nan, fail_msg=message)
	EXPECT_LE(nan, inf, fail_msg=message)
	EXPECT_LE(100, 0, fail_msg= message)
	EXPECT_LE(100, -100, fail_msg= message)
	EXPECT_LE(0, -100, fail_msg= message)

	// Fatal tests
	ASSERT_LE(1, 0, fail_msg="Should fail (fatally)")
	ASSERT_LE(1, 0, fail_msg="***Should not be executed at all in the first place***")
End

// Test EXPECT_GE and ASSERT_GE
Function utest_GE()
	String message

	// Assertions that should pass
	message = "Should pass"
	EXPECT_GE(inf, -inf, fail_msg= message)
	EXPECT_GE(1, -1, fail_msg= message)
	EXPECT_GE(-1, -100, fail_msg= message)
	EXPECT_GE(0.1, 0, fail_msg= message)
	EXPECT_GE(NaN, -NaN, fail_msg= message)	// Signed bit of NaN should be ignored
	EXPECT_GE(NaN, NaN, fail_msg= message)
	EXPECT_GE(0, 0, fail_msg=message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_GE(inf, -inf, fail_msg= message)
	ASSERT_GE(1, -1, fail_msg= message)
	ASSERT_GE(-1, -100, fail_msg= message)
	ASSERT_GE(0.1, 0, fail_msg= message)
	ASSERT_GE(NaN, -NaN, fail_msg= message)	// Signed bit of NaN should be ignored
	ASSERT_GE(NaN, NaN, fail_msg= message)
	ASSERT_GE(0, 0, fail_msg=message)


	// Assertions that should fail.
	message = "Should fail"
	EXPECT_GE(inf, nan, fail_msg= message)
	EXPECT_GE(-inf, nan, fail_msg=message)
	EXPECT_GE(nan, inf, fail_msg=message)
	EXPECT_GE(-inf, -inf, fail_msg= message)
	EXPECT_GE(inf, inf, fail_msg= message)
	EXPECT_GE(NaN, NaN, fail_msg= message)
	EXPECT_GE(NaN, -NaN, fail_msg= message)	// Signed bit of NaN should be ignored
	EXPECT_GE(0, 0.999, fail_msg=message)
	EXPECT_GE(-1, 0, fail_msg=message)
	EXPECT_GE(1, 2, fail_msg=message)
	EXPECT_GE(-kTOLd * 0.999, 0, fail_msg=message)
	EXPECT_GE(-inf, inf, fail_msg=message)


	// Fatal tests
	ASSERT_GE(0, 1, fail_msg="Should fail (fatally)")
	ASSERT_GE(0, 1, fail_msg="***Should not be executed at all in the first place***")
End


// Test EXPECT_EQ_C and ASSERT_EQ_C
Function utest_EQ_C()
	// Assertions that should pass.
	EXPECT_EQ_C(cmplx(NaN, NaN), cmplx(NaN, NaN))
	EXPECT_EQ_C(cmplx(NaN, -NaN), cmplx(-NaN, NaN))
	EXPECT_EQ_C(cmplx(inf, NaN), cmplx(inf, NaN))
	EXPECT_EQ_C(cmplx(-inf, 0), cmplx(-inf, 0))
	EXPECT_EQ_C(cmplx(inf, inf), cmplx(inf, inf))
	EXPECT_EQ_C(cmplx(0, 1), cmplx(0, 1), tol=kTOLd)
	EXPECT_EQ_C(cmplx(5, -1), cmplx(5, -1), tol=kTOLd)
	EXPECT_EQ_C(cmplx(-5, 1/3), cmplx(-5, 1/3), tol=kTOLd)
	EXPECT_EQ_C(cmplx(1000.43 - 1000.0, 0), cmplx(.43, 0), tol=kTOLd)
	EXPECT_EQ_C(cmplx(0, 1000.43 - 1000.0), cmplx(0, .43), tol=kTOLd)
	EXPECT_EQ_C(cmplx(5, 0), cmplx(4, 0), tol=2)		// NOTE:  Large tolerance here.

	ASSERT_EQ_C(cmplx(NaN, NaN), cmplx(NaN, NaN))
	ASSERT_EQ_C(cmplx(NaN, -NaN), cmplx(-NaN, NaN))
	ASSERT_EQ_C(cmplx(inf, NaN), cmplx(inf, NaN))
	ASSERT_EQ_C(cmplx(-inf, 0), cmplx(-inf, 0))
	ASSERT_EQ_C(cmplx(inf, inf), cmplx(inf, inf))
	ASSERT_EQ_C(cmplx(0, 1), cmplx(0, 1), tol=kTOLd)
	ASSERT_EQ_C(cmplx(5, -1), cmplx(5, -1), tol=kTOLd)
	ASSERT_EQ_C(cmplx(-5, 1/3), cmplx(-5, 1/3), tol=kTOLd)
	ASSERT_EQ_C(cmplx(1000.43 - 1000.0, 0), cmplx(.43, 0), tol=kTOLd)
	ASSERT_EQ_C(cmplx(0, 1000.43 - 1000.0), cmplx(0, .43), tol=kTOLd)
	ASSERT_EQ_C(cmplx(5, 0), cmplx(4, 0), tol=2)		// NOTE:  Large tolerance here.

    // Assertions that should fail
    String msg = "Should fail"
	EXPECT_EQ_C(cmplx(inf, inf), cmplx(-inf, inf), fail_msg=msg)
	EXPECT_EQ_C(cmplx(inf, -inf), cmplx(-inf, -inf), fail_msg=msg)
	EXPECT_EQ_C(cmplx(-inf, -inf), cmplx(inf, inf), fail_msg=msg)
	EXPECT_EQ_C(cmplx(NaN, NaN), cmplx(NaN, -inf), fail_msg=msg)
	EXPECT_EQ_C(cmplx(NaN, inf), cmplx(inf, inf), fail_msg=msg)
	EXPECT_EQ_C(cmplx(0, inf), cmplx(inf, inf), fail_msg=msg)
	EXPECT_EQ_C(cmplx(1000.43 - 1000.0, 0), cmplx(.43, 0), fail_msg=msg)
	EXPECT_EQ_C(cmplx(0, 1000.43 - 1000.0), cmplx(0, .43), fail_msg=msg)
	EXPECT_EQ_C(cmplx(5, 0), cmplx(4, 0), tol=kTOLs, fail_msg=msg)
	ASSERT_EQ_C(cmplx(5, 0), cmplx(4, 0), tol=kTOLs, fail_msg="Should fail (fatally).")
	EXPECT_EQ_C(cmplx(5, 0), cmplx(4, 0), tol=kTOLs, fail_msg="***Should not be executed at all in the first place***")
End

// Test EXPECT_NE_C and ASSERT_NE_C
Function utest_NE_C()
	// Assertions that should pass.
	EXPECT_NE_C(cmplx(inf, inf), cmplx(-inf, inf))
	EXPECT_NE_C(cmplx(inf, -inf), cmplx(-inf, -inf))
	EXPECT_NE_C(cmplx(-inf, -inf), cmplx(inf, inf))
	EXPECT_NE_C(cmplx(NaN, NaN), cmplx(NaN, -inf))
	EXPECT_NE_C(cmplx(NaN, inf), cmplx(inf, inf))
	EXPECT_NE_C(cmplx(0, inf), cmplx(inf, inf))
	EXPECT_NE_C(cmplx(1000.43 - 1000.0, 0), cmplx(.43, 0))
	EXPECT_NE_C(cmplx(0, 1000.43 - 1000.0), cmplx(0, .43))
	EXPECT_NE_C(cmplx(5, 0), cmplx(4, 0))
	EXPECT_NE_C(cmplx(1000.43 - 1000.0, 0), cmplx(.43, 0))
	EXPECT_NE_C(cmplx(0, 1000.43 - 1000.0), cmplx(0, .43))
	EXPECT_NE_C(cmplx(5, 0), cmplx(4, 0))

	ASSERT_NE_C(cmplx(inf, inf), cmplx(-inf, inf))
	ASSERT_NE_C(cmplx(inf, -inf), cmplx(-inf, -inf))
	ASSERT_NE_C(cmplx(-inf, -inf), cmplx(inf, inf))
	ASSERT_NE_C(cmplx(NaN, NaN), cmplx(NaN, -inf))
	ASSERT_NE_C(cmplx(NaN, inf), cmplx(inf, inf))
	ASSERT_NE_C(cmplx(0, inf), cmplx(inf, inf))
	ASSERT_NE_C(cmplx(1000.43 - 1000.0, 0), cmplx(.43, 0))
	ASSERT_NE_C(cmplx(0, 1000.43 - 1000.0), cmplx(0, .43))
	ASSERT_NE_C(cmplx(5, 0), cmplx(4, 0))
	ASSERT_NE_C(cmplx(1000.43 - 1000.0, 0), cmplx(.43, 0))
	ASSERT_NE_C(cmplx(0, 1000.43 - 1000.0), cmplx(0, .43))
	ASSERT_NE_C(cmplx(5, 0), cmplx(4, 0))


    // Assertions that should fail
    String msg = "Should fail"
	EXPECT_NE_C(cmplx(NaN, -NaN), cmplx(-NaN, NaN), fail_msg=msg)			// Sign should be ignored on NaN
	EXPECT_NE_C(cmplx(inf, NaN), cmplx(inf, NaN), fail_msg=msg)
	EXPECT_NE_C(cmplx(-inf, 0), cmplx(-inf, 0), fail_msg=msg)
	EXPECT_NE_C(cmplx(inf, inf), cmplx(inf, inf), fail_msg=msg)
	EXPECT_NE_C(cmplx(0, 1), cmplx(0, 1), fail_msg=msg)
	EXPECT_NE_C(cmplx(5, -1), cmplx(5, -1), fail_msg=msg)
	EXPECT_NE_C(cmplx(-5, 1/3), cmplx(-5, 1/3), fail_msg=msg)

	ASSERT_NE_C(cmplx(-5, 1/3), cmplx(-5, 1/3), fail_msg="Should fail (fatally).")
	ASSERT_NE_C(cmplx(-5, 1/3), cmplx(-5, 1/3), fail_msg="***Should not be executed at all in the first place***")
End

Function utest_STREQ()
	String message

	SVAR/Z nullSVAR1
	SVAR/Z nullSVAR2

	// Assertions that should pass
	message = "Should pass"
	EXPECT_STREQ("a", "a", fail_msg= message)
	EXPECT_STREQ("", "", fail_msg= message)
//	EXPECT_STREQ(nullSVAR1, nullSVAR2, fail_msg= message)
	EXPECT_STREQ("A", "A", fail_msg= message)
	EXPECT_STREQ("AbCdEfG", "AbCdEfG", fail_msg= message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_STREQ("a", "a", fail_msg= message)
//	ASSERT_STREQ(nullSVAR1, nullSVAR2, fail_msg= message)
	ASSERT_STREQ("", "", fail_msg= message)
	ASSERT_STREQ("A", "A", fail_msg= message)
	ASSERT_STREQ("AbCdEfG", "AbCdEfG", fail_msg= message)

	// Assertions that should fail
	message = "Should fail"
	EXPECT_STREQ("a", "b", fail_msg= message)
	EXPECT_STREQ("a", "A", fail_msg= message)
	EXPECT_STREQ("A", "a", fail_msg= message)
//	EXPECT_STREQ(nullSVAR1, "", fail_msg= message)
//	EXPECT_STREQ(nullSVAR1, "abcd", fail_msg= message)
	EXPECT_STREQ("AbCdEfG", "bCdE", fail_msg= message)

	ASSERT_STREQ("AbCdEfG", "bCdE", fail_msg= message + "(fatally)")
	EXPECT_STREQ("AbCdEfG", "bCdE", fail_msg= "***Should not be executed at all in the first place***")
End

Function utest_STRNE()
	String message

	SVAR/Z nullSVAR1
	SVAR/Z nullSVAR2

	// Assertions that should pass
	message = "Should pass"
	EXPECT_STRNE("a", "b", fail_msg= message)
	EXPECT_STRNE("a", "A", fail_msg= message)
	EXPECT_STRNE("A", "a", fail_msg= message)
//	EXPECT_STRNE(nullSVAR1, "", fail_msg= message)
//	EXPECT_STRNE(nullSVAR1, "abcd", fail_msg= message)
	EXPECT_STRNE("AbCdEfG", "bCdE", fail_msg= message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_STRNE("a", "b", fail_msg= message)
	ASSERT_STRNE("a", "A", fail_msg= message)
	ASSERT_STRNE("A", "a", fail_msg= message)
//	ASSERT_STRNE(nullSVAR1, "", fail_msg= message)
//	ASSERT_STRNE(nullSVAR1, "abcd", fail_msg= message)
	ASSERT_STRNE("AbCdEfG", "bCdE", fail_msg= message)

	// Assertions that should fail
	message = "Should fail"
	EXPECT_STRNE("a", "a", fail_msg= message)
	EXPECT_STRNE("", "", fail_msg= message)
//	EXPECT_STRNE(nullSVAR1, nullSVAR2, fail_msg= message)
	EXPECT_STRNE("A", "A", fail_msg= message)
	EXPECT_STRNE("AbCdEfG", "AbCdEfG", fail_msg= message)


	ASSERT_STRNE("a", "a", fail_msg= message + "(fatally)")
	EXPECT_STRNE("a", "a", fail_msg= "***Should not be executed at all in the first place***")
End

Function utest_WAVEEQ()
    Make/N=10 wv1
    Make/N=10 wv2
    Make/T wv3
    Make/T wv4

    wv1 = 0
    wv2 = 0
    EXPECT_WAVEEQ(wv1, wv2)

    wv1 = 0
    wv2 = 1

    wv3 = "true"
    wv4 = "true"
    EXPECT_WAVEEQ(wv3, wv4)
End

static Function test_STRCASEIEQ()
	String message

	SVAR/Z nullSVAR1
	SVAR/Z nullSVAR2

	// Assertions that should pass
	message = "Should pass"
	EXPECT_STRCASEEQ("a", "a", fail_msg= message)
	EXPECT_STRCASEEQ("", "", fail_msg= message)
	EXPECT_STRCASEEQ("A", "A", fail_msg= message)
//	EXPECT_STRCASEEQ(nullSVAR1, nullSVAR2, fail_msg= message)
	EXPECT_STRCASEEQ("AbCdEfG", "AbCdEfG", fail_msg= message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_STRCASEEQ("a", "a", fail_msg= message)
	ASSERT_STRCASEEQ("", "", fail_msg= message)
	ASSERT_STRCASEEQ("A", "A", fail_msg= message)
//	ASSERT_STRCASEEQ(nullSVAR1, nullSVAR2, fail_msg= message)
	ASSERT_STRCASEEQ("AbCdEfG", "AbCdEfG", fail_msg= message)

	// Assertions that should fail
	message = "Should fail"
	EXPECT_STRCASEEQ("a", "b", fail_msg= message)
	EXPECT_STRCASEEQ("a", "A", fail_msg= message)
	EXPECT_STRCASEEQ("A", "a", fail_msg= message)
	EXPECT_STRCASEEQ("AbCdEfG", "bCdE", fail_msg= message)
//	EXPECT_STRCASEEQ(nullSVAR1, "", fail_msg= message)
//	EXPECT_STRCASEEQ(nullSVAR1, "abcd", fail_msg= message)
	ASSERT_STRCASEEQ("AbCdEfG", "bCdE", fail_msg= message + "(fatally)")
	EXPECT_STRCASEEQ("AbCdEfG", "bCdE", fail_msg= "***Should not be executed at all in the first place***")
End

static Function test_STRCASENE()
	String message

	SVAR/Z nullSVAR1
	SVAR/Z nullSVAR2

	// Assertions that should pass
	message = "Should pass"
	EXPECT_STRCASENE("a", "b", fail_msg= message)
	EXPECT_STRCASENE("AbCdEfG", "bCdE", fail_msg= message)
//	EXPECT_STRCASENE(nullSVAR1, "", fail_msg= message)
//	EXPECT_STRCASENE(nullSVAR1, "abcd", fail_msg= message)

	// Assertions that should pass
	message = "Should pass"
	ASSERT_STRCASENE("a", "b", fail_msg= message)
	ASSERT_STRCASENE("AbCdEfG", "bCdE", fail_msg= message)
//	ASSERT_STRCASENE(nullSVAR1, "", fail_msg= message)
//	ASSERT_STRCASENE(nullSVAR1, "abcd", fail_msg= message)

	// Assertions that should fail
	message = "Should fail"
	EXPECT_STRCASENE("a", "A", fail_msg= message)
	EXPECT_STRCASENE("A", "a", fail_msg= message)
	EXPECT_STRCASENE("a", "a", fail_msg= message)
	EXPECT_STRCASENE("", "", fail_msg= message)
	EXPECT_STRCASENE("A", "A", fail_msg= message)
//	EXPECT_STRCASENE(nullSVAR1, nullSVAR2, fail_msg= message)
	EXPECT_STRCASENE("AbCdEfG", "AbCdEfG", fail_msg= message)

	ASSERT_STRCASENE("a", "a", fail_msg= message + "(fatally)")
	EXPECT_STRCASENE("a", "a", fail_msg= "***Should not be executed at all in the first place***")
End

Function test_Explicits()
	SUCCEED(fail_msg="This should pass.")
	EXPECT_FAIL(fail_msg="This direct assertion should fail.")
	FAIL(fail_msg="This direct assertion should fail (fatally).")
	EXPECT_FAIL(fail_msg="***Should not be executed at all in the first place***")
End