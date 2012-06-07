#include "IgorUnit"

Function utest_TS__diffgroups()
    // Tests with the same name from different groups are considered different
    STRUCT UnitTest testA
    STRUCT UnitTest testB
    STRUCT TestSuite ts

    TS_init(ts)
    UnitTest_init(testA, "GroupA", "same_test_name", "dummy_func")
    UnitTest_init(testB, "GroupB", "other_test_name", "dummy_func2")

    TS_addTest(ts, testA)
    TS_addTest(ts, testB)
    ASSERT_FALSE(TS_hasTest(ts, "GroupB", "same_test_name"), fail_msg="tests considered the same!")
End