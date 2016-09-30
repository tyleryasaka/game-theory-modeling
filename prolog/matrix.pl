%	matrix

:- [math].

/*
	Rule: setLikelihood
	Description:
		set the likelihood value for a player
	Input:
		Player (String): identifier for the player
		Likelihood (List): new value
*/
setLikelihood(Player,Likelihood) :-
	setProp(Player,'likelihood',Likelihood).

/*
	Rule: getLikelihood
	Description:
		get the likelihood value for a player
	Input:
		Player (String): identifier for the player
	Output:
		Likelihood (List): current value
*/
getLikelihood(Player,Likelihood) :-
	getProp(Player,'likelihood',Likelihood).

/*
	Rule: setUtility
	Description:
		set the utility value for a player
	Input:
		Player (String): identifier for the player
		Utility (List): new value
*/
setUtility(Player,Utility) :-
	setProp(Player,'utility',Utility).

/*
	Rule: getUtility
	Description:
		get the utility value for a player
	Input:
		Player (String): identifier for the player
	Output:
		Utility (List): current value
*/
getUtility(Player,Utility) :-
	getProp(Player,'utility',Utility).

/*
	Rule: setProp
	Description:
		helper for setting a property for a player
	Input:
		Player (String): identifier for the player
		Property (String): identifier for the property
		Value: new value
*/
setProp(Player,Property,Value) :-
	implode([Player,Property],'.',Name),
	nb_setval(Name,Value).

/*
	Rule: getProp
	Description:
		helper for getting a property for a player
	Input:
		Player (String): identifier for the player
		Property (String): identifier for the property
	Output:
		Value: current value
*/
getProp(Player,Property,Value) :-
	implode([Player,Property],'.',Name),
	nb_getval(Name,Value).

/*
	Rule: preferRational
	Description:
		determine the best course of action assuming pure rationality
	Input:
		Player (String): identifier for the player
	Output:
		Choice (Integer): index of the chosen row of the matrix
*/
preferRational(Player,Choice) :-
	getLikelihood(Player,Likelihood),
	getUtility(Player,Utility),
	evalRational(Utility,Likelihood,WeightedUtility),
	indexMax(WeightedUtility,Choice).

/*
	Rule: evalRational
	Description:
		evaluate the available options, assuming pure rationality
	Input:
		[] (List): the utility matrix
		Likelihood (List): list of weights representing how likely the player thinks each column of the matrix will occur
	Output:
		[] (List): weighted utility matrix, taking into account both original utility values and likelihood
*/
evalRational([U|Utility],Likelihood,[WU|WeightedUtility]) :-
	evalRational(Utility,Likelihood,WeightedUtility),
	weightedSum(U,Likelihood,Sum),
	WU is Sum.
	
evalRational([],_,[]).

/*
	Rule: weightedSum
	Description:
		sum a list of integers, each integer multiplied by its corresponding value in a list of weights
	Input:
		[] (List): list of integers
		[] (List): list of weights
	Output:
		Sum (Integer): the weighted sum
*/
weightedSum([A|Addends],[W|Weights],Sum) :-
	weightedSum(Addends,Weights,SumBelow),
	Sum is A * W + SumBelow.

weightedSum([],[],0).
