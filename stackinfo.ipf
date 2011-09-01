#pragma rtGlobals=1

#ifndef STACKINFOUTILS_INCLUDE
#define STACKINFOUTILS_INCLUDE

#include "list"

Function/S Stack_getFull()
    String full_stack = GetRTStackInfo(3)
    List_pop(full_stack)
    return full_stack
End

Function Stack_getLength(full_stack)
    String full_stack
    return List_getLength(full_stack)
End

Function/S Stack_getStackRow(full_stack, row_idx)
    String full_stack
    Variable row_idx
    return List_getItemByIndex(full_stack, row_idx)
End

Function/S StackRow_getFunctionName(stack_row)
    String stack_row
    return StringFromList(0, stack_row, ",")
End

Function/S StackRow_getFileName(stack_row)
    String stack_row
    return StringFromList(1, stack_row, ",")
End

Function StackRow_getLineNumber(stack_row)
    String stack_row
    String line_number = StringFromList(2, stack_row, ",")
    return str2num(line_number)
End

#endif