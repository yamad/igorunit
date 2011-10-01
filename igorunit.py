#!/usr/bin/env python

import os, sys

import make_tests

def communicator_factory():
    if sys.platform == 'darwin':        # Mac OS X
        return MacIgorCommunicator()
    elif sys.platform == 'win32':       # Windows
        return WinIgorCommunicator()
    else:                               # for now, return do-nothing dummy
        IgorCommunicator()

class IgorCommunicator(object):
    def __init__(self):
        self.igorapp = None

    def execute(self, cmd):
        pass

class MacIgorCommunicator(IgorCommunicator):
    def __init__(self):
        import appscript
        self.igorapp = appscript.app("Igor Pro")

    def execute(self, cmd):
        return self.igorapp.Do_Script(cmd)

    def is_op_queue_empty(self):
        # As far as I can tell, Igor does not provide a way to
        # determine the status of the operation queue on Mac. For now,
        # the op queue appears to block operations until it is done,
        # so things work. But we are basically crossing our fingers
        # that the procedure compilation completes before we ask for a
        # test run.
        return True

class WinIgorCommunicator(IgorCommunicator):
    def __init__(self):
        import win32com.client
        # using gencache.EnsureDispatch instead of Dispatch to load
        # enumerations
        self.igorapp = win32com.client.gencache.EnsureDispatch("IgorPro.Application")
        self.constants = win32com.client.constants

    def execute(self, cmd):
        """ Executes the given Igor command `cmd` and returns the
        result, if any.

        For Windows, this command wraps the Execute2 Igor automation
        function
        """
        flag_nolog = 0                  # do not log in Igor history area
        code_page = 0                   # use system default code page

        # Igor requires the following dummy output variables to be passed
        err_code = 0
        err_msg = ""
        history = ""
        results = ""

        # TODO: deal intelligently with errors passed back from Igor
        result_tuple = self.igorapp.Execute2(flag_nolog, code_page, cmd,
                                             err_code, err_msg, history, results)
        err_code, err_msg, history, results = result_tuple
        return results

    def is_op_queue_empty(self):
        return self.igorapp.Status1(
            self.constants.ipStatusOperationQueueIsEmpty)

class IgorCommandGenerator(object):
    def insert_include(self, include_name):
        """
        >>> gen = IgorCommandGenerator()
        >>> gen.include("TEST")
        'Execute/P/Q "INSERTINCLUDE \\"TEST\\""'
        """
        inc_cmd = 'INSERTINCLUDE \\"{0}\\"'.format(include_name)
        return self.add_to_op_queue(inc_cmd)

    def delete_include(self, include_name):
        del_cmd = 'DELETEINCLUDE \\"{0}\\"'.format(include_name)
        return self.add_to_op_queue(del_cmd)

    def compile_procedures(self):
        # Igor requires the trailing space. Don't ask me!
        return self.add_to_op_queue('COMPILEPROCEDURES ')

    def add_to_op_queue(self, cmd):
        """ Post a command to the operation queue"""
        return 'Execute/P/Q "{0}"'.format(cmd)

    def capture_result(self, cmd):
        """
        >>> gen = IgorCommandGenerator()
        >>> gen.capture_result("print 1")
        'fprintf 0, "%s", print 1'
        """
        return 'fprintf 0, "%s", {0}'.format(cmd)

class IgorCommand(object):
    def __init__(self, communicator, command_generator):
        self.comm = communicator
        self.gen = command_generator

    def insert_include(self, include_name):
        cmd = self.gen.insert_include(include_name)
        return self.comm.execute(cmd)

    def delete_include(self, include_name):
        cmd = self.gen.delete_include(include_name)
        return self.comm.execute(cmd)

    def compile_procedures(self):
        cmd = self.gen.compile_procedures()
        return self.comm.execute(cmd)

    def return_result(self, cmd):
        cmd = self.gen.capture_result(cmd)
        res = self.comm.execute(cmd)
        res = convert_to_python_newlines(res)
        return res

    def include_and_compile(self, include_name):
        self.insert_include(include_name)
        self.compile_procedures()

    def uninclude_and_compile(self, include_name):
        self.delete_include(include_name)
        self.compile_procedures()

    def is_compiled(self):
        # The more direct test for procedure compile status does not
        # seem to work, so use proxy check that all operations in the
        # op queue have completed.
        return bool(self.comm.is_op_queue_empty())

def convert_to_python_newlines(igor_result):
    return igor_result.replace("\r", "\n")

def write_tests_to_file(filepath, test_files):
    rendered_file = make_tests.generate_igor_from_files(test_files)
    proc_file = open(filepath, "w")
    proc_file.write(rendered_file)
    proc_file.close()
    return filepath

import time
def main(argv):
    test_files = argv
    filepath = os.path.join(os.getcwd(), "testfile.ipf")
    fpath = write_tests_to_file(filepath, test_files)

    comm = communicator_factory()
    gen = IgorCommandGenerator()
    command = IgorCommand(comm, gen)

    command.include_and_compile("testfile")
    compile_time = 0
    while command.is_compiled() is not True:
        time.sleep(0.5)
        compile_time += 0.5
    print "Time to compile: {0}sec".format(compile_time)
    res = command.return_result("runAllTests_getResults()")
    command.uninclude_and_compile("testfile")
    return res

if __name__ == '__main__':
    import sys
    print main(sys.argv[1:])
