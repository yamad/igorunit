## Test definition macros
<%!
   from templates import IgorUnitSuite
   suite = IgorUnitSuite.IgorTestSuite()
%>
<%def name="TEST(groupname, testname)">\
<%
   suite = self.attr.suite
   test = suite.add_test(groupname, testname)
   funcname = test.get_funcname()
%>\
Function ${funcname}(tr)
  STRUCT TestResult &tr
  String groupname = "${groupname}"
  String testname = "${testname}"
  String funcname = "${funcname}"
  String msg = ""

  STRUCT UnitTest test
  UnitTest_init(test, groupname, testname, funcname)
</%def>

<%def name="END_TEST()">\
  return 0
End
</%def>

<%def name="MAIN()">\
<% suite = self.attr.suite %>\
Function runAllTests()
  STRUCT TestSuite ts
  TS_init(ts)

  STRUCT UnitTest test
  % for group in suite.groups:
  TS_addGroup(ts, "${group.get_name()}")
  % for test in group.tests:
  TS_addTestByName(ts, "${group.get_name()}", "${test.get_name()}", "${test.get_funcname()}")
  % endfor
  % endfor

  STRUCT TestSuiteRunner tsr
  TSR_init(tsr, ts)

  TSR_runAllTests(tsr)
End
</%def>

<%def name="TEST_SETUP(groupname)">\
Function ${groupname}_setup()\
</%def>

<%def name="END_SETUP()">\
  return 0
End\
</%def>

<%def name="TEST_TEARDOWN(groupname)">\
Function ${groupname}_teardown()\
</%def>

<%def name="END_TEARDOWN()">\
  return 0
End\
</%def>
