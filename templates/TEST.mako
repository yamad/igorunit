## Test definition macros
<%!
   from templates import IgorUnitSuite
   suite = IgorUnitSuite.IgorTestSuite()
%>
<%def name="TEST(groupname, testname)">\
Function ${groupname}_${testname}(tr)
  STRUCT TestResult &tr
  String groupname = "${groupname}"
  String testname = "${testname}"
  String msg = ""\
  <%
    suite = self.attr.suite
    suite.add_test(groupname, testname)
  %>
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

  STRUCT TestSuiteRunner tsr
  TSR_init(tsr, ts)

  % for group in suite.groups:
  TS_addGroup(ts, "${group.get_name()}")
  % for test in group.tests:
  TS_addTest(ts, "${group.get_name()}", "${test.get_name()}")
  % endfor
  % endfor
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
