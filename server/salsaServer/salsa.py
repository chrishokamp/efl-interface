"""
 Standalone LexSub Analyzer (SaLSA)
 Ravi S Sinha
 University of North Texas
 Summer 2011
 
 Modified to function as an interface module for a Server by Chris Hokamp  
 Fall 2012

"""

# Imports
import sys
import shelve
from TextBase import *
from InfoBase import InfoBase
from NGrams import NGrams

#Step 4: Get the synonyms from WordNet and Encarta as well as
#         the inflections from AGID
# Collected previously for RTLS and AGID, saved as persistent objects
# synonyms['word']['pos'] = string of synonyms (;)
# Union of WordNet and Encarta for each head word
synonyms = shelve.open('synonyms.db')['1'] 
inflections = shelve.open('inflections.db')['1']

def querySalsa(info):
# Step 1: get text from text file, and split with '.'
# Enforce head words tags
# Enforce no spacing between <head>, </head> and the head word

#Chris: TODO - add def prepQuery to TextBase to handle single-line queries, or in-memory queries

	try:
		textBase = TextBase(info)
		textBase.preprocess()
	# textBase.displayText() # Tested
	except IndexError:
		print "Error: no input file found . . ."
		sys.exit()

# Step 2: format the data into a nice structure
	count = 0
	infos = []
	for line in textBase.text:
		infos.append(InfoBase(line, count))
		count += 1

# Step 3: PoS tag the information and store the information
#
	for infoElem in infos:
		infoElem.posTag()
		infoElem.headPos = infoElem.partsOfSpeech[infoElem.positionOfHead][1][:2]
		infoElem.lemmatize()
		if InfoBase.posHash.has_key(infoElem.headPos):
			temp = InfoBase.posHash[infoElem.headPos]
			if synonyms[infoElem.head].has_key(temp):
				infoElem.synonyms = list(set(synonyms[infoElem.head][temp].split(';'))) #*Chris: if the word has no synonyms, nothing will be added

	
	for infoElem in infos:
		#Chris: TODO: temporary test hack (comment out this block to test)
		#infoElem.inflections[s] = inflections[s][pos]

		pos = InfoBase.posHash[infoElem.headPos]
		for s in infoElem.synonyms:
			if inflections[s].has_key(pos):
				if infoElem.inflections.has_key(s):
					infoElem.inflections[s] += inflections[s][pos]
				else:
					infoElem.inflections[s] = inflections[s][pos]



#for info in infos:
#	info.display() # Tested

# Step 5: Generate all n-grams for all synonyms and their inflections
	for infoElem in infos:
		# Represents all n-grams for this sentence ID
		ngramsCollection = NGrams(infoElem)
		ngramsCollection.constructNGrams()
		ngramsCollection.sanitizeGrammar()
		infoElem.display()
		print 'All n-grams = %s\n' % ngramsCollection.ngrams[infoElem.sentenceID]
		#for logging
		totalNgrams = 0
		for ngramList in ngramsCollection.ngrams[infoElem.sentenceID]:
			totalNgrams += len(ngramList) 	
			
# Step 6: Get counts, sum the counts, and sort/ reverse-sort them and display
		ngramsCollection.getCounts()
		scores = ngramsCollection.scores[infoElem.sentenceID]
		scores = sorted([(value, key) for (key, value) in scores.items()], reverse = True)
		print 'All synonyms scores = %s\n' % scores
		#TEST
		scores.append(totalNgrams)
		return scores 
