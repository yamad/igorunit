#pragma rtGlobals=1		// Use modern global access method.

#ifndef LISTUTILS_INCLUDE
#define LISTUTILS_INCLUDE

Static Strconstant LISTSEP = ";"

Function List_getLength(list_in)
    String list_in
    return ItemsInList(list_in, LISTSEP)
End

#endif