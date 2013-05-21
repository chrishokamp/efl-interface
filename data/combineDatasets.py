#!/usr/bin/python

import nltk, sys, getopt, json
from collections import defaultdict
#TODO:
#load Oxford json, Word Examples.json (from wordnet), and outsider_usages.json

#outsider = sys.argv[1]
outsiderUsages = open('outsider_usages.json', 'r').read()
exampleJson = open('wordExamples.json', 'r').read()
synJson = open('oxfordRogetUnion.json', 'r').read()
usages = json.loads(outsiderUsages) #get the feedback word from here, and look in oxford for synonyms and antonyms
examples = json.loads(exampleJson) 
synonyms = json.loads(synJson) 
def makehash():
    return defaultdict(makehash)

feedback = makehash() 
for usage in usages:
    print "KEY: %s" % usage
    print "FEEDBACK WORD: %s" % str(usages[usage]['feedbackWord'])
    word = usages[usage]['feedbackWord'].encode('ascii', 'ignore')
    pos = ''
    try:
        innerEx = examples[word]
        sens = []
        for u in innerEx:
            pos = u
            print "len of sens: %s" % str(len(innerEx[u].items()))
            sens = innerEx[u].items()
            sens.sort(key=lambda x: x[0].encode('ascii', 'ignore'))
            for sen in sens:
                print "\t\tSEN: %s" % str(sen)

            synList = []
            try:
                synList = synonyms[word][pos]
                for syn in synList:
                    print "\t\tSYNONYM: %s" % syn
            except KeyError:
                pass

            feedback[word]['pos'] = pos
            feedback[word]['word'] = word 
            feedback[word]['syns'] = synList
            feedback[word]['examples'] = [x[1] for i, x in enumerate(sens)]

    except KeyError:
        pass

j = json.dumps(feedback, sort_keys=True, indent=4, separators=(',',': '))
o = open('feedback.json', 'w')
o.write(j)
o.close()
    
