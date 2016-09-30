%	array

/*
	Rule: access
	Description:
		Access item from list by index, like an array.
	Input:
		[] (List): list to access from
		Index (Integer): location in list to acccess from
	Output:
		Element: the content at the specified location
*/
access([Head|List],Index,Element) :-
	Element = Head,
	Index is 0,!;
	access(Element,Index,List,0).

access(Element,Index,[Head|List],Current) :-
	Element = Head,
	Index is Current+1,!;
	access(Element,Index,List,Current+1).

/*
	Rule: addToList
	Description:
		Add an item to the front of a list
	Input:
		Element: Item to insert
		OldList (List): list to be added to
	Output:
		NewList (List): list with the new item
*/
addToList(Element,OldList,NewList) :-
	NewList = [Element|OldList].

/*
	Rule: inToList
	Description:
		Check if an item is in a list
	Input:
		Item: Item to check for
		[] (List): List to be checked
	Output:
		true/false: true if in liist, false otherwise
*/
inList(Item,[L|List]) :-
	Item = L;
	inList(Item,List).

implode([L|List],Separator,Result) :-
	implodeHelp(List,Separator,ResultList),
	concat(L,ResultList,Result).

implodeHelp([L|List],Separator,Result) :-
	implodeHelp(List,Separator,ResultList),
	concat(Separator,L,S),
	concat(S,ResultList,Result).
	
implodeHelp([],_,'').
