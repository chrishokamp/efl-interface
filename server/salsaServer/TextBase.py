# Standalone LexSub
# Ravi S Sinha
# University of North Texas
# Summer 2011

# Class definition
import re

#Chris: this module was written to handle files. Single-line queries need not use this code
class TextBase:
	def __init__(self, rawText):
		#Chris: commented to allow passing in memory
		#tempFH = open(rawTextFile, "r")
		print 'TextBase: %s' % rawText
		#tempStr = ""
		#for line in rawText:
		#	tempStr += line.strip() + " "
		self.raw = rawText.strip()
		print 'self.raw: %s' % self.raw
		self.text = [self.raw]

	def preprocess(self):
		flag = True

		#Chris: TODO - this is a temporary hack! 
		#TEST
		#self.text[2] = self.raw
		#self.text = self.raw.split('.')
		#self.text.pop() # Get rid of the last element which is empty by default
		for line in self.text:
			print 'Line is: %s' %line # Tested
			if "<head>" not in line or "</head>" not in line:
				flag = False
			# print flag # Tested
			# Enforcing no spaces between <head>, word and </head>
			if re.search(r'<head>\s+', line) or re.search(r'\s+</head>', line):
				flag = False	

		if not flag:
			print "Error: you did not specify <head> and </head> tags or there are extra spaces in the lines . . ."
			import sys
			sys.exit()

	def displayText(self):
		for line in self.text:
			print line



