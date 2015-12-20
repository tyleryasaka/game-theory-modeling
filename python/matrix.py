#	matrix

'''
	Class: player
	Description:
		representation of a player in a game
'''
class player:
	def __init__(self,Utility=None,Likelihood=None):
		self.Likelihood = Likelihood
		self.Utility = Utility
	def setUtility(self,Utility):
		self.Utility = Utility
	def getUtility(self):
		return self.Utility
	def setLikelihood(self,Likelihood):
		self.Likelihood = Likelihood	
	def getLikelihood(self):
		return self.Likelihood

'''
	Function: preferRational
	Description:
		determine the best course of action assuming pure rationality
	Input:
		Player (player): the player
	Output:
		return (Number): index of the chosen row of the matrix
'''
def preferRational(Player):
	WeightedUtility = evalRational(Player.getUtility(),Player.getLikelihood())
	return WeightedUtility.index(max(WeightedUtility))

'''
	Function: evalRational
	Description:
		evaluate the available options, assuming pure rationality
	Input:
		Utilities (List): the utility matrix
		Likelihood (List): list of weights representing how likely the player thinks each column of the matrix will occur
	Output:
		return (List): weighted utility matrix, taking into account both original utility values and likelihood
'''
def evalRational(Utilities,Likelihood):
	WeightedUtilities = []
	for Utility in Utilities:
		WeightedUtilities.append(weightedSum(Utility,Likelihood))
	return WeightedUtilities

'''
	Function: weightedSum
	Description:
		sum a list of integers, each integer multiplied by its corresponding value in a list of weights
	Input:
		Addends (List): list of integers
		Weights (List): list of weights
	Output:
		return (Number): the weighted sum
'''
def weightedSum(Addends,Weights):
	Sum = 0
	for A,Addend in enumerate(Addends):
		Sum += (Addend * Weights[A])
	return Sum
