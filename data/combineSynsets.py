#!/usr/bin/python
from collections import defaultdict
import re
import json
import sets

#Combine the Oxford synonyms with the Roget and Wordnet synsets, removing antonyms
#For now, we are DISREGARDING Oxford sense groupings (is this wise?)
#   - hierarchical disambiguation would be a good idea in the long term

def makehash():
    return defaultdict(makehash)

def unique(a):
    return list(set(a))

def union(a, b):
    return list(set(a) | set(b))

def difference(a, b):
    return list(set(a).difference(set(b)))

#load Roget + wordnet
roget_string = open('jsonSynonyms.json', 'r').read()
roget = json.loads(roget_string)

#load Oxford
oxford_string = open('oxfordThesaurus.json', 'r').read()
oxford = json.loads(oxford_string)

combined = makehash()
#combine, don't duplicate
for word in oxford:
    for pos in oxford[word]:
        if word in roget and pos in roget[word]:
            #print "WORD: " + word + " POS: " + pos + " exists in both"
            #print " roget synset: " + roget[word][pos]
            rogetSyns = re.split(';', roget[word][pos])
            oxfordSyns = []
            oxfordAnts = []
            for sense in oxford[word][pos]:
                oxfordSyns += oxford[word][pos][sense]['syns']
                if 'ants' in oxford[word][pos][sense]:
                    oxfordAnts += oxford[word][pos][sense]['ants']
                
            allSyns = union(rogetSyns, oxfordSyns)
            noAnts = difference(allSyns, oxfordAnts)
            combined[word][pos] = noAnts
        else:
            oxfordSyns = []
            for sense in oxford[word][pos]:
                oxfordSyns += oxford[word][pos][sense]['syns']
            noDuplicates = unique(oxfordSyns)
            combined[word][pos] = noDuplicates

for word in roget:
    for pos in roget[word]:
        if word not in oxford or pos not in oxford[word]:
            #print "WORD: " + word + " POS: " + pos + " only exists in ROGET"
            rogetSyns = re.split(';', roget[word][pos])
            combined[word][pos] = rogetSyns

totalLen = len(combined)
print "NUM KEYS in COMBINED = " + str(totalLen)

out = open('oxfordRogetUnion.json', 'w')
out.write(json.dumps(combined, sort_keys=True, indent=2))
out.close()




