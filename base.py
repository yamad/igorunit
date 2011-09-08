test_template = """
Function {groupname}_{testname}(tr)
    STRUCT TestResult &tr
    String groupname = {groupname}
    String testname = {testname}
"""

import Cheetah.Template

TEST_TEMPLATE_FILE = "TEST_ipf.tmpl"

class Base(Cheetah.Template.Template):
    def __init__(self):
        self.tests = []
        super(Cheetah.Template.Template, self).__init__()

    def TEST(self, groupname, testname):
        template_string = open(TEST_TEMPLATE_FILE, "r").
        namespace = {"groupname":groupname, "testname":testname}
        filled_template = Cheetah.Template.Template(template_string, namespace)

        self.tests.append(IgorTest(groupname, testname))
        return filled_template

    def ALL_TESTS(self):
        res = []
        for test in self.tests:
            res.append("%s, %s" % (test['groupname'], test['testname']))
        return "\n".join(res)

class IgorTest(object):
    def __init__(self, groupname, testname):
        self.groupname = groupname
        self.testname = testname
