#	prisoners

from matrix import *

#Declare global variables
precision = None
yearsInPrison = None

'''
	Function: setPrecision
	Description:
		set the precision value for the game
	Input:
		Precision (Number): new value
'''
def setPrecision(Precision):
	global precision
	precision = Precision
	
'''
	Function: getPrecision
	Description:
		get the precision value for the game
	Output:
		return (Number): current value
'''
def getPrecision(Precision):
	global precision
	return precision

'''
	Function: setYearsInPrison
	Description:
		set the yearsInPrison value for the game
	Input:
		YearsInPrison (List): new matrix
'''
def setYearsInPrison(YearsInPrison):
	global yearsInPrison
	yearsInPrison = YearsInPrison

'''
	Function: getYearsInPrison
	Description:
		get the yearsInPrison value for the game
	Output:
		return (List): current matrix
'''
def getYearsInPrison(YearsInPrison):
	global yearsInPrison
	return yearsInPrison

'''
	Class: prisoner
	Description:
		representation of a player in a game; inherits from player
'''
class prisoner(player):
	def setEmpathy(self,Empathy):
		global precision
		self.Empathy = Empathy
		self.Apathy = precision - Empathy
	def getEmpathy(self):
		return self.Empathy
	def setApathy(self,Apathy):
		global precision
		self.Apathy = Apathy
		self.Empathy = precision - Apathy
	def getApathy(self):
		return self.Apathy

'''
	Function: preferRationalPD
	Description:
		Maps referRational result 0 to 'confess', and result 1 to 'refuse'
	Input:
		Player (prisoner): the player
	Output:
		return (String): 'confess' or 'refuse'
'''
def preferRationalPD(Player):
	deriveUtility(Player)
	if preferRational(Player):
		Action = 'refuse'
	else:
		Action = 'confess'
	return Action

'''
	Function: deriveUtility
	Description:
		Sets a utility matrix based on empathy, apathy, and yearsInPrison matrix
	Input:
		Player (prisoner): the player
'''
def deriveUtility(Player):
	global yearsInPrison
	Apathy = Player.getApathy()
	Empathy = Player.getEmpathy()
	Years = yearsInPrison
	Utility = []
	Utility.append([])
	Utility.append([])
	Utility[0].append(Years[0][0] * -1 * Apathy	+	Years[0][0] * -1 * Empathy)
	Utility[0].append(Years[0][1] * -1 * Apathy	+	Years[1][0] * -1 * Empathy)
	Utility[1].append(Years[1][0] * -1 * Apathy	+	Years[0][1] * -1 * Empathy)
	Utility[1].append(Years[1][1] * -1 * Apathy	+	Years[1][1] * -1 * Empathy)
	Player.setUtility(Utility)

'''
	Function: getResults
	Description:
		Get the result of a prisoner's dilemma between 2 players
	Input:
		Player1 (prisoner): player 1
		Player2 (prisoner): player 2
	Output:
		return (Dictionary): prison sentences for player 1 and player 2
'''
def getResults(Player1,Player2):
	results = {}
	deriveUtility(Player1)
	deriveUtility(Player2)
	Choice1 = preferRational(Player1)
	Choice2 = preferRational(Player2)
	global yearsInPrison
	results['Player1'] = yearsInPrison[Choice1][Choice2]
	results['Player2'] = yearsInPrison[Choice2][Choice1]
	return results

'''
	Function: getApathyForAction
	Description:
		find all valid apathy values that would cause the specified action
	Input:
		Player (prisoner): the player
		Action (String): the action that would result
	Output:
		return (Number): a valid apathy value
'''
def getApathyForAction(Player,Action):
	global precision
	results = []
	initialApathy = Player.getApathy()
	for i in range(0,precision+1):
		Player.setApathy(i)
		deriveUtility(Player)
		if preferRationalPD(Player) == Action:
			results.append(i)
	Player.setApathy(initialApathy)
	return results

'''
	Function: getEmpathyForAction
	Description:
		find all valid empathy values that would cause the specified action
	Input:
		Player (prisoner): the player
		Action (String): the action that would result
	Output:
		return (Number): a valid empathy value
'''
def getEmpathyForAction(Player,Action):
	global precision
	results = []
	initialEmpathy = Player.getEmpathy()
	for i in range(0,precision+1):
		Player.setEmpathy(i)
		deriveUtility(Player)
		if preferRationalPD(Player) == Action:
			results.append(i)
	Player.setEmpathy(initialEmpathy)
	return results

'''
	Function: maxApathy
	Description:
		select the maximum apathy value for a given action
	Input:
		Player (prisoner): the player
		Action (String): the action that would result
	Output:
		return (Integer): the maximum apathy value
'''
def maxApathy(Player,Action):
	return max(getApathyForAction(Player,Action))
	
'''
	Function: minApathy
	Description:
		select the minimum apathy value for a given action
	Input:
		Player (prisoner): the player
		Action (String): the action that would result
	Output:
		return (Integer): the minimum apathy value
'''
def minApathy(Player,Action):
	return min(getApathyForAction(Player,Action))
	
'''
	Function: maxEmpathy
	Description:
		select the maximum empathy value for a given action
	Input:
		Player (prisoner): identifier for the player
		Action (String): the action that would result
	Output:
		return (Integer): the maximum empathy value
'''
def maxEmpathy(Player,Action):
	return max(getEmpathyForAction(Player,Action))
	
'''
	Function: minEmpathy
	Description:
		select the minimum empathy value for a given action
	Input:
		Player (prisoner): identifier for the player
		Action (String): the action that would result
	Output:
		return (Integer): the minimum empathy value
'''
def minEmpathy(Player,Action):
	return min(getEmpathyForAction(Player,Action))
