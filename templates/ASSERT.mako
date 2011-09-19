## Basic assert structure, tests the condition and issues a test
## failure if it is false. This macro is the basis for most other test
## macros, which call ASSERT_BASE to implement the basic IgorUnit
## assertion structure.
<%def name="ASSERT_BASE(condition, fail_msg)">\
  if (${condition})
  ${SUCCEED()}
  else
  ${FAIL(fail_msg)}
  endif\
</%def>

## Tests whether the condition is true
<%def name="ASSERT(condition)">\
<% msg = "<{0}> is not true".format(condition) %>\
${ASSERT_BASE(condition, msg)}\
</%def>

## Test that two variables (numbers) are equal
<%def name="VARS_EQUAL(expected, actual)">\
<%
  msg = EXPECTED_ERROR_MSG(expected, actual)
  condition = "{0} == {1}".format(expected, actual)
%>\
${ASSERT_BASE(condition, msg)}\
</%def>

## Test that two strings are equal
<%def name="STRINGS_EQUAL(expected, actual)">\
<%
  msg = "{0}".format(EXPECTED_ERROR_MSG(expected, actual))
  condition = 'cmpstr("{0}", "{1}") == 0'.format(expected, actual)
%>\
${ASSERT_BASE(condition, msg)}\
</%def>

## Signal a test success
<%def name="SUCCEED()">\
    TR_addSuccess(tr, groupname, testname, "")\
</%def>

## Signal a test failure, with a provided failure message (given as a string)
<%def name="FAIL(msg)">\
    TR_addFailure(tr, groupname, testname, "${msg}")\
</%def>

## Signal a test failure, with a failure message (given as a string *variable*)
<%def name="FAIL_MSGVAR(msg_var)">\
    TR_addFailure(tr, groupname, testname, ${msg_var})\
</%def>

## Returns a string indicating that a test variable (actual) did not
## evaluate to the expected result
<%def name="EXPECTED_ERROR_MSG(expected, actual)" buffered="True">\
Expected <${expected.__repr__()}>, but was <${actual.__repr__()}>\
</%def>
