%	math

:- [array].

/*
	Rule: restrict
	Description:
		Restrict a variable to a certain range of consecutive integers
	Input:
		Min (Integer): beginning of range (inclusive)
		Max (Integer): end of range (inclusive)
	Output:
		Integer: restricted variable
*/
restrict(Min,Max,Integer) :-
	enumeratedList(Min,Max,List),
	inList(Integer,List).

/*
	Rule: enumeratedList
	Description:
		create a list of consecutive integers
	Input:
		Start (Integer): beginning of range (inclusive)
		Stop (Integer): end of range (inclusive)
	Output:
		List (List): the resulting list
*/
enumeratedList(Start,Stop,List) :-
	enumeratedList(Start,Start,Stop,List).
	
enumeratedList(Index,Start,Stop,[H|List]) :-
	Index =< Stop,
	H is Index,
	enumeratedList(Index+1,Start,Stop,List),!.
	
enumeratedList(Index,_,Stop,[]) :-
	Stop is Index -1,!.

/*
	Rule: max
	Description:
		finds the maximum value of a list of integers
	Input:
		[] (List): list to search
	Output:
		Max (Integer): the largest value in the list
*/
max([Max],Max).

max([Data|List],Max) :-
	max(List,MaxList),
	(Data >= MaxList -> Max is Data,!; Max is MaxList,!).

/*
	Rule: indexMax
	Description:
		finds the index of the maximum value of a list of integers
	Input:
		List (List): list to search
	Output:
		Max (Integer): the index of the largest value in the list
*/
indexMax(List,Max) :-
	indexMax(List,0,_,Max).
	
indexMax([MaxData],MaxIndex,MaxData,MaxIndex).

indexMax([Data|List],Index,MaxData,MaxIndex) :-
	NextIndex is Index + 1,
	indexMax(List,NextIndex,ListMaxData,ListMaxIndex),
	(
		Data >= ListMaxData -> MaxIndex is Index,MaxData is Data,!;
		MaxIndex is ListMaxIndex, MaxData is ListMaxData,!
	).
