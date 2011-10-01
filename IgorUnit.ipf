#pragma rtGlobals=1		// Use modern global access method.

// IgorUnit -- a unit testing framework for IgorPro based on xUnit

#include "assert"
#include "UnitTest"
#include "TestSuiteRunner"
#include "TestSuite"
#include "TestResult"

// Test files are Igor notebooks that start with the string *test*
Function/S TestFiles_getAll()
    // Returns a list of all Notebooks (WIN:16) starting with the
    // string *test*
    return WinList("test*", ";", "WIN:16")
End