%	scenario

:- [prisoners].

/*
	The number of years in prison for each combination of choices made by the 2 prisoners
	First in row or col: prisoner confesses 
	Second in row or col: prisoner abstains
*/
:- setYearsInPrison(
	[
		[5,0],
		[10,2]
	]
).

/*
	Arbitrary maximum for empathy/apathy values; higher number gives higher precision
*/
:- setPrecision(100).

/*
	Create some players and assign them some values
*/
:- setLikelihood('Tyler',[1,1]).

:- setEmpathy('Tyler',30).

:- setLikelihood('Ben',[1,2]).

:- setEmpathy('Ben',30).
