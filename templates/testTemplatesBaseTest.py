import unittest2

from testTemplateTest import TemplateTest

class testTemplateBaseTest(TemplateTest):
    def setup(self):
        pass

    def testSucceedMacro(self):
        template_string = """
        #extends ASSERT
        $SUCCEED()
        """
        expected = u"""
        TR_addSuccess(tr, groupname, testname, "")
        """
        self.verify(expected, template_string)

    def testFailMacro(self):
        template_string = """
        #extends ASSERT
        $FAIL("Test message")
        """
        expected = u"""
        TR_addFailure(tr, groupname, testname, "Test message")
        """
        self.verify(expected, template_string)

    def testAssertBaseMacro(self):
        template_string = """
        #extends ASSERT
        $ASSERT_BASE("condition == other", "Failed!")
        """
        expected = u"""
        if (condition == other)
            TR_addSuccess(tr, groupname, testname, "")
        else
            TR_addFailure(tr, groupname, testname, "Failed!")
        endif
        """
        self.verify(expected, template_string)

    def testAssertMacro(self):
        template_string = """
        #extends ASSERT
        $ASSERT("condition == other")
        """
        expected = u"""
        if (condition == other)
          TR_addSuccess(tr, groupname, testname, "")
        else
          TR_addFailure(tr, groupname, testname, "condition == other is not true")
        endif
        """
        self.verify(expected, template_string)

    def testStringsEqualMacro(self):
        template_string = """
        #extends ASSERT
        $STRINGS_EQUAL("strings", "different")
        """
        expected = u"""
        if (cmpstr("strings", "different") == 0)
        TR_addSuccess(tr, groupname, testname, "")
        else
        TR_addFailure(tr, groupname, testname, "Expected <'strings'>, but was <'different'>")
        endif
        """
        self.verify(expected, template_string)

    def testVariablesEqualMacro(self):
        template_string = """
        #extends ASSERT
        $VARS_EQUAL(1, 2)
        """
        expected = u"""
        if (1 == 2)
        $SUCCEED()
        else
        TR_addFailure(tr, groupname, testname, "Expected <1>, but was <2>")
        endif
        """
        self.verify(expected, template_string)

if __name__ == '__main__':
    unittest2.main()
