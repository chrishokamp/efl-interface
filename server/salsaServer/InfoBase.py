""" 
Information base
Every object has the following:
sentence, headWord, positionOfHead, sentenceID, headID, partsOfSpeech
"""

import re

class InfoBase:
	posHash = {'NN':'n', 'VB':'v', 'RB':'r', 'JJ':'a', 'CD':'n', 'IN':'n'} #chris#This only works when the words are correctly pos-tagged - i.e. if a sentence is automatically generated, and then pos-tagged by nltk, there will be an error if the word is tagged as anything other than one of these four POS options
#	29.10.12 -added hacks:
#	'CD': 'n' - to handle "information retrieval,and applied machine learning."
#	'IN': 'n' - to handle "properties on an HTML element and know" head: 'element'
	def __init__(self, text, count):
		text = re.sub(r'^\s+', '', text)
		self.positionOfHead = text[:text.index('<head>')].count(' ')
		self.head = text[text.index('<head>') + 6:text.index('</head>')]
		self.sentence = text.replace("<head>", "").replace("</head>", "")
		self.sentenceID = count
		self.inflections = {}
		self.headID = count
		self.synonyms = []
		self.headPos = ''
		self.partsOfSpeech = ()

	def display(self):
		print '\n-- -- --\n\n'
		print 'Sentence ID = %s\n' % self.sentenceID
		print 'Sentence = %s\n' % self.sentence
		print 'Part of speech tags = %s\n' % self.partsOfSpeech
		print 'Head word ID = %s\n' % self.headID
		print 'Head word = %s\n' % self.head
		print 'Position of head word = %s\n' % self.positionOfHead
		print 'Part of speech of head = %s\n' % self.headPos
		print 'Synonyms = %s\n' % self.synonyms
		print 'Inflections of the synonyms = %s\n' % self.inflections

	def posTag(self):
		# Use the off-the-shelf tagger that comes with NLTK - #*Chris - could this be a bottleneck in the process? - TODO: benchmark this portion of the code
		from nltk import pos_tag, word_tokenize
		# A list of tuples
		self.partsOfSpeech = pos_tag(word_tokenize(self.sentence))

	def lemmatize(self):
		# NLTK
		from nltk.stem.wordnet import WordNetLemmatizer
		L = WordNetLemmatizer()
		self.head = L.lemmatize(self.head, self.posHash[self.headPos])
