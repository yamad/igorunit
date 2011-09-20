#!/usr/bin/env python

import os

import mako.template
import mako.lookup

def file_getdir(filepath):
    return os.path.dirname(os.path.abspath(filepath))

template_dir = os.path.join(file_getdir(__file__), "templates")
HEADER_FILE = os.path.join(template_dir, "BaseHeader.mako")

def read_file(filepath):
    """ Return file contents as a string"""
    return open(filepath, "r").read()

def collect_sources(test_files):
    """ Return the concatenated contents of all files in the list
    `test_files"""
    file_contents = [read_file(f) for f in test_files]
    return '\n'.join(file_contents)

def prepend_test_header(test_source):
    header_source = read_file(HEADER_FILE)
    return '\n'.join([header_source, test_source])

def make_template_source(test_files):
    test_source = collect_sources(test_files)
    return prepend_test_header(test_source)

lookup_dirs = [template_dir, os.getcwd()]
def generate_igor_from_files(test_files):
    a_lookup = mako.lookup.TemplateLookup(
        directories=lookup_dirs,
        input_encoding='utf-8', output_encoding='utf-8',
        )
    template_source = make_template_source(test_files)
    template = mako.template.Template(template_source, lookup=a_lookup)
    return template.render()

def main(argv):
    test_files = argv
    rendered_file = generate_igor_from_files(test_files)
    print rendered_file

if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
