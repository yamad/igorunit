## Starting fragment of a unittest
##   called with TEST(groupname, testname)
Function ${groupname}_${testname}(tr)
    STRUCT TestResult &tr
    String groupname = ${groupname}
    String testname = ${testname}