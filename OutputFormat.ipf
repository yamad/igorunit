#ifndef IGORUNIT_OUTPUTFORMAT
#define IGORUNIT_OUTPUTFORMAT

Function/S OutputFormat_getPrefix(verbosity)
    Variable verbosity

    switch (verbosity)
        case VERBOSITY_LOW:
            return "OFBasic"
        default:
            return "OFVerbose"
    endswitch
End

Function/S OutputFormat_getFuncName(verbosity, func_suffix)
    Variable verbosity
    String func_suffix
    return OutputFormat_getPrefix(verbosity) +"_"+ func_suffix
End

#endif