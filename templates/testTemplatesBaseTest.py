import unittest2

from testTemplateTest import TemplateTest

class testTemplateAssert(TemplateTest):
    def setUp(self):
        self.inherit = "<%inherit file='ASSERT.mako'/>\n"

    def testSucceedMacro(self):
        template_string = self.inherit + """
        ${SUCCEED()}
        """
        expected = self.inherit + u"""
        TR_addSuccess(tr, groupname, testname, "")
        """
        self.verify(expected, template_string)

    def testFailMacro(self):
        template_string = self.inherit + """
        <%inherit file="ASSERT.mako" />
        ${FAIL("Test message")}
        """
        expected = self.inherit + u"""
        TR_addFailure(tr, groupname, testname, "Test message")
        """
        self.verify(expected, template_string)

    def testAssertBaseMacro(self):
        template_string = self.inherit + """
        <%inherit file="ASSERT.mako" />
        ${ASSERT_BASE("condition == other", "Failed!")}
        """
        expected = self.inherit + u"""
        if (condition == other)
            ${SUCCEED()}
        else
            ${FAIL("Failed!")}
        endif
        """
        self.verify(expected, template_string)

    def testAssertMacro(self):
        template_string = self.inherit + """
        <%inherit file="ASSERT.mako" />
        ${ASSERT("condition == other")}
        """
        expected = self.inherit + u"""
        if (condition == other)
          ${SUCCEED()}
        else
          ${FAIL("<condition == other> is not true")}
        endif
        """
        self.verify(expected, template_string)

    def testStringsEqualMacro(self):
        template_string = self.inherit + """
        ${STRINGS_EQUAL("strings", "different")}
        """
        expected = self.inherit + u"""
        if (cmpstr("strings", "different") == 0)
          ${SUCCEED()}
        else
          ${FAIL("Expected <'strings'>, but was <'different'>")}
        endif
        """
        self.verify(expected, template_string)

    def testVariablesEqualMacro(self):
        template_string = self.inherit + """
        ${VARS_EQUAL(1, 2)}
        """
        expected = self.inherit + u"""
        if (1 == 2)
          ${SUCCEED()}
        else
          ${FAIL("Expected <1>, but was <2>")}
        endif
        """
        self.verify(expected, template_string)

class testTemplateTEST(TemplateTest):
    def setUp(self):
        self.inherit = "<%inherit file='TEST.mako'/>\n"

    def testEndTest(self):
        template_string = self.inherit + """
        ${END_TEST}
        """
        expected = self.inherit + """
          return 0
        End
        """
        self.verify(expected, template_string)

if __name__ == '__main__':
    unittest2.main()
