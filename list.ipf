#pragma rtGlobals=1		// Use modern global access method.

#ifndef LISTUTILS_INCLUDE
#define LISTUTILS_INCLUDE

Static Strconstant LISTSEP = ";"

Function List_getLength(list_in)
    String list_in
    return ItemsInList(list_in, LISTSEP)
End

Function/S List_getItemByIndex(list_in, get_idx)
    String list_in
    Variable get_idx
    return StringFromList(get_idx, list_in)
End

Function/S List_removeItemByIndex(list_in, remove_idx)
    String list_in
    Variable remove_idx
    return RemoveListItem(remove_idx, list_in, LISTSEP)
End

Function/S List_pop(list_in)
    String &list_in

    Variable last_idx = List_getLength(list_in) - 1
    String popped = List_getItemByIndex(list_in, last_idx)
    list_in = List_removeItemByIndex(list_in, last_idx)
    return popped
End

#endif