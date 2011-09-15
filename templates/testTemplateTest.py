import unittest2

import Cheetah.Template

class TemplateTest(unittest2.TestCase):
    """ Base class for test classes that test templating modules"""
    def verify(self, expected, template_input):
        """Check that the `template_input` string compiles to the `expected` string

        This routine ignores whitespace differences.
        """
        template = Cheetah.Template.Template(template_input)

        expected = "#extends ASSERT\n" + expected
        expected_template = Cheetah.Template.Template(expected)

        expected_no_ws = strip_to_lines(expected_template.writeBody())
        compiled_no_ws = strip_to_lines(template.writeBody())
        self.assertEquals(expected_no_ws, compiled_no_ws)

def strip_to_lines(input_string):
    """Returns the given string split into each line, with all
    whitespace removed"""
    stripped_input = strip_all_whitespace(input_string)
    input_lines = stripped_input.splitlines()
    return strip_whitespace_lines(input_lines)

def strip_all_whitespace(input_string):
    """Returns the given string with all whitespace and newlines
    characters removed from the left and right ends"""
    return input_string.strip(" \n\t")

def strip_whitespace_lines(input_lines):
    """Returns the given list of lines with leading/trailing
    whitespace removed and blank lines removed"""
    return [strip_all_whitespace(x) for x in input_lines if len(x) > 0]
