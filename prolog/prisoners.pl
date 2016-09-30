%	prisoners

:- [matrix].

/*
	Rule: setPrecision
	Description:
		set the precision value for the game
	Input:
		Precision (Integer): new value
*/
setPrecision(Precision) :-
	nb_setval(precision,Precision).

/*
	Rule: getPrecision
	Description:
		get the precision value for the game
	Output:
		Precision (Integer): current value
*/
getPrecision(Precision) :-
	nb_getval(precision,Precision).

/*
	Rule: setYearsInPrison
	Description:
		set the yearsInPrison value for the game
	Input:
		YearsInPrison (List): new matrix
*/
setYearsInPrison(YearsInPrison) :-
	nb_setval(yearsInPrison,YearsInPrison).

/*
	Rule: getYearsInPrison
	Description:
		get the yearsInPrison value for the game
	Output:
		YearsInPrison (List): current matrix
*/
getYearsInPrison(YearsInPrison) :-
	nb_getval(yearsInPrison,YearsInPrison).
	
/*
	Rule: setEmpathy
	Description:
		set the empathy value for a player; also implicitly sets the apathy value to its inverse
	Input:
		Player (String): identifier for the player
		Empathy: new value
*/
setEmpathy(Player,Empathy) :-
	getPrecision(Precision),
	setProp(Player,'empathy',Empathy),
	Apathy is Precision - Empathy,
	setProp(Player,'apathy',Apathy).
	
/*
	Rule: getEmpathy
	Description:
		get the empathy value for a player
	Input:
		Player (String): identifier for the player
	Output:
		Empathy: current value
*/
getEmpathy(Player,Empathy) :-
	getProp(Player,'empathy',Empathy).
	
/*
	Rule: setApathy
	Description:
		set the apathy value for a player; also implicitly sets the empathy value to its inverse
	Input:
		Player (String): identifier for the player
		Apathy: new value
*/
setApathy(Player,Apathy) :-
	getPrecision(Precision),
	setProp(Player,'apathy',Apathy),
	Empathy is Precision - Apathy,
	setProp(Player,'empathy',Empathy).
	
/*
	Rule: getApathy
	Description:
		get the apathy value for a player
	Input:
		Player (String): identifier for the player
	Output:
		Apathy: current value
*/
getApathy(Player,Apathy) :-
	getProp(Player,'apathy',Apathy).

/*
	Rule: preferRationalPD
	Description:
		Maps referRational result 0 to 'confess', and result 1 to 'refuse'
	Input:
		Player (String): identifier for the player
	Output:
		Action (String): 'confess' or 'refuse'
*/
preferRationalPD(Player,Action) :-
	deriveUtility(Player),
	preferRational(Player,0),
	Action = 'confess',!;
	preferRational(Player,1),
	Action = 'refuse',!.

/*
	Rule: deriveUtility
	Description:
		Sets a utility matrix based on empathy, apathy, and yearsInPrison matrix
	Input:
		Player (String): identifier for the player
*/
deriveUtility(Player) :-
	getEmpathy(Player,Empathy),
	getApathy(Player,Apathy),
	getYearsInPrison(Years),
	access(Years,0,A),
	access(A,0,A1),
	access(A,1,A2),
	access(Years,1,B),
	access(B,0,B1),
	access(B,1,B2),
	W is A1 * -1 * Apathy + A1 * -1 * Empathy,
	X is A2 * -1 * Apathy + B1 * -1 * Empathy,
	Y is B1 * -1 * Apathy + A2 * -1 * Empathy,
	Z is B2 * -1 * Apathy + B2 * -1 * Empathy,
	Utility = 
	[
		[W,X],
		[Y,Z]
	],
	setUtility(Player,Utility).

/*
	Rule: getResults
	Description:
		Get the result of a prisoner's dilemma between 2 players
	Input:
		Player1 (String): identifier for player 1
		Player2 (String): identifier for player 2
	Output:
		Player1Sentence (Integer): prison sentence for player 1
		Player2Sentence (Integer): prison sentence for player 2
*/
getResults(Player1,Player2,Player1Sentence,Player2Sentence) :-
	deriveUtility(Player1),
	deriveUtility(Player2),
	preferRational(Player1,Choice1),
	preferRational(Player2,Choice2),
	getYearsInPrison(YearsInPrison),
	access(YearsInPrison,Choice1,Player1Row),
	access(Player1Row,Choice2,Player1Sentence),
	access(YearsInPrison,Choice2,Player2Row),
	access(Player2Row,Choice1,Player2Sentence).
	
/*
	Rule: getApathyForAction
	Description:
		find all valid apathy values that would cause the specified action
	Input:
		Player (String): identifier for the player
		Action (String): the action that would result
	Output:
		Apathy (Integer): a valid apathy value
*/
getApathyForAction(Player,Action,Apathy) :-
	getApathy(Player,InitialApathy),
	findall(A,getApathyForActionHelp(Player,Action,A),Results),
	inList(Apathy,Results),
	setApathy(Player,InitialApathy).
	
getApathyForActionHelp(Player,Action,Apathy) :-
	getPrecision(Precision),
	restrict(0,Precision,Apathy),
	setApathy(Player,Apathy),
	deriveUtility(Player),
	preferRationalPD(Player,Action).

/*
	Rule: getEmpathyForAction
	Description:
		find all valid empathy values that would cause the specified action
	Input:
		Player (String): identifier for the player
		Action (String): the action that would result
	Output:
		Empathy (Integer): a valid empathy value
*/
getEmpathyForAction(Player,Action,Empathy) :-
	getEmpathy(Player,InitialEmpathy),
	findall(E,getEmpathyForActionHelp(Player,Action,E),Results),
	inList(Empathy,Results),
	setEmpathy(Player,InitialEmpathy).

getEmpathyForActionHelp(Player,Action,Empathy) :-
	getPrecision(Precision),
	restrict(0,Precision,Empathy),
	setEmpathy(Player,Empathy),
	deriveUtility(Player),
	preferRationalPD(Player,Action).

/*
	Rule: maxApathy
	Description:
		select the maximum apathy value for a given action
	Input:
		Player (String): identifier for the player
		Action (String): the action that would result
	Output:
		Apathy (Integer): the maximum apathy value
*/
maxApathy(Player,Action,Apathy) :-
	findall(Apathy,getApathyForAction(Player,Action,Apathy),Results), %clarify
	max(Results,Apathy).

/*
	Rule: minApathy
	Description:
		select the minimum apathy value for a given action
	Input:
		Player (String): identifier for the player
		Action (String): the action that would result
	Output:
		Apathy (Integer): the minimum apathy value
*/
minApathy(Player,Action,Apathy) :-
	nb_getval(precision,Precision),
	maxEmpathy(Player,Action,Empathy),
	Apathy is Precision - Empathy.

/*
	Rule: maxEmpathy
	Description:
		select the maximum empathy value for a given action
	Input:
		Player (String): identifier for the player
		Action (String): the action that would result
	Output:
		Empathy (Integer): the maximum empathy value
*/
maxEmpathy(Player,Action,Empathy) :-
	findall(Empathy,getEmpathyForAction(Player,Action,Empathy),Results),
	max(Results,Empathy).

/*
	Rule: minEmpathy
	Description:
		select the minimum empathy value for a given action
	Input:
		Player (String): identifier for the player
		Action (String): the action that would result
	Output:
		Empathy (Integer): the minimum empathy value
*/
minEmpathy(Player,Action,Empathy) :-
	nb_getval(precision,Precision),
	maxApathy(Player,Action,Apathy),
	Empathy is Precision - Apathy.
