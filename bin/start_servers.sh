#!/bin/bash
#+------------------------------------------------------------------------+
#| Start the word server for HoundDog                                     |
#| @author Chris Hokamp                                                   |
#+------------------------------------------------------------------------+

# $1 location of server
# $2 location of wordlist
# $3 port number

usage ()
{
    echo "start_servers.sh"
    echo "usage: ./start_servers.sh <Server Location> <Wordlist>"
    echo "start the HoundDog word server"
}

#echo "num arguments: " 
#echo $#

if [ $# != 2 ]
then
    usage
    exit
fi

#start the server
perl $1 $2 $3 

echo "Startup finished"

