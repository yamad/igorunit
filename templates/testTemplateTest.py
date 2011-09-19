import os

import unittest2

import Cheetah.Template

import mako.template
import mako.lookup

class TemplateTest(unittest2.TestCase):
    """ Base class for test classes that test templating modules"""
    def verify(self, expected_output, input):
        """Check that the `input` template string compiles to the
        `expected_output` string

        Both `input` and `expected_output` are passed through
        Cheetah. This greatly simplifies writing the `expected` string
        because any long-winded sections can be wrapped in template
        method calls. This reduces duplication and provides more
        focused testing of just the aspect of the template that is of
        interest.

        The comparison between lines ignores whitespace differences at
        the beginning/end of lines.
        """
        lookup = mako.lookup.TemplateLookup([os.getcwd()])

        template = mako.template.Template(input, lookup=lookup)
        compiled_no_ws = strip_to_lines(template.render())

        expected_template = mako.template.Template(expected_output, lookup=lookup)
        expected_no_ws = strip_to_lines(expected_template.render())
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
