#def TEST($groupname, $testname)
Function ${groupname}_${testname}(tr)
    STRUCT TestResult &tr
    String groupname = $groupname
    String testname = $testname
#end def

#def END_TEST
    return 0
End
#end def

#def TEST_SETUP($groupname)
Function ${groupname}_setup()
#end def

#def END_SETUP
    return 0
End
#end def

#def TEST_TEARDOWN($groupname)
Function ${groupname}_teardown()
#end def

#def END_TEARDOWN
    return 0
End
#end def

#def ASSERT($condition)
    String msg
    if ($condition)
        TR_addSuccess(tr, groupname, testname, msg)
    else
        sprintf msg, "%s is not true", "$condition"
        TR_addFailure(tr, groupname, testname, msg)
    endif
#end def

$TEST_SETUP("A")
$END_SETUP

$TEST_TEARDOWN("A")
$END_TEARDOWN

$TEST("A", "firsttest")
$ASSERT("1 == 2")
$END_TEST