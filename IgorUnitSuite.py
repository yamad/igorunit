import Cheetah.Template

from BaseTest import BaseTest

TEST_TEMPLATE_FILE = "TEST_ipf.frag"

class IgorUnitSuite(BaseTest):
    def __init__(self):
        self.suite = IgorTestSuite()
        super(BaseTest, self).__init__()

    def TEST(self, groupname, testname):
        """ Macro to begin a unit test definition

        Used to define all unit tests. The test group name and test
        name must be a unique combination. The following variables are
        available in each test definition environment:

         - `tr` -- a reference to a TestResult instance
         - `groupname` -- the name of the test group
         - `testname` -- the name of the test itself
        """
        template_string = self.getFileContents(TEST_TEMPLATE_FILE)
        namespace = {"groupname":groupname, "testname":testname}
        filled_template = Cheetah.Template.Template(template_string, namespace)

        self.add_test(groupname, testname)
        return filled_template

    def add_test(self, groupname, testname):
        self.suite.add_test(groupname, testname)

class IgorTestSuite(object):
    def __init__(self):
        self.groups = []

    def add_group(self, groupname):
        if not self.has_group(groupname):
            group = self.make_group(groupname)
            self.groups.append(group)
        return self.get_group(groupname)

    def has_group(self, groupname):
        probe_group = self.make_group(groupname)
        if probe_group in self.groups:
            return True
        return False

    def get_group(self, groupname):
        if not self.has_group(groupname):
            return None

        match_idxs = [i for i,x in enumerate(self.groups) \
                      if x.get_name() == groupname]
        first_match_group = self.groups[match_idxs[0]]
        return first_match_group

    def get_groups(self):
        return self.groups

    def make_group(self, groupname):
        return IgorTestGroup(groupname)

    def add_test(self, groupname, testname):
        group = self.get_group(groupname)
        if group is None:
            group = self.add_group(groupname)
        group.add_test(testname)

class IgorTestGroup(object):
    def __init__(self, groupname):
        self.name = groupname
        self.tests = []

    def add_test(self, testname):
        if not self.has_test(testname):
            test = self.make_test(testname)
            self.tests.append(test)
        return self.get_test(testname)

    def has_test(self, testname):
        probe_test = self.make_test(testname)
        if probe_test in self.tests:
            return True
        return False

    def get_test(self, testname):
        if not self.has_test(testname):
            return None

        match_idxs = [i for i,x in enumerate(self.tests) \
                      if x.get_name() == testname]
        first_match_test = self.tests[match_idxs[0]]
        return first_match_test

    def make_test(self, testname):
        return IgorTest(self.name, testname)

    def __eq__(self, other):
        if not isinstance(other, IgorTestGroup):
            raise NotImplementedError
        return self.name == other.name

    def get_name(self):
        return self.name

    def get_setupname(self):
        return "{name}_setup".format(name=self.name)

    def get_teardownname(self):
        return "{name}_teardown".format(name=self.name)

    def get_tests(self):
        return self.tests

class IgorTest(object):
    def __init__(self, groupname, testname):
        self.groupname = groupname
        self.name = testname

    def get_name(self):
        return self.name

    def get_groupname(self):
        return self.groupname

    def get_fullname(self):
        return "{groupname}_{testname}".format(groupname=self.groupname,
                                               testname=self.name)

    def __eq__(self, other):
        if not isinstance(other, IgorTest):
            raise NotImplementedError

        if self.groupname == other.groupname:
            return self.name == other.name
        return False

import unittest
class TestIgorTest(unittest.TestCase):
    def testsEqual(self):
        testA = IgorTest("default", "test1")
        testB = IgorTest("default", "test1")
        self.assertEquals(testA, testB)

    def testsNamesSameGroupsDiff(self):
        testA = IgorTest("default", "test1")
        testB = IgorTest("non-default", "test1")
        self.assertNotEquals(testA, testB)

    def testsNamesDiffGroupsSame(self):
        testA = IgorTest("default", "test")
        testB = IgorTest("default", "diff_test")
        self.assertNotEquals(testA, testB)

    def testsDoNotCompareToNonTests(self):
        class NotATest(object):
            def __init__(self, groupname, testname):
                self.groupname = groupname
                self.name = testname

        testA = IgorTest("default", "test")
        non_test = NotATest("default", "test")
        self.assertRaises(NotImplementedError,
                          lambda: testA == non_test)

    def test_findIn(self):
        test_list = [IgorTest("A", "b"), IgorTest("C", "d")]
        if IgorTest("A", "b") not in test_list:
            self.fail()
