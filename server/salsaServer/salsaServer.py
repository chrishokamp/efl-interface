#! /usr/bin/python
from multiprocessing import Process
import socket
import sys
import os
import salsa

BUFLEN = 256

# handle every client in a separate subprocess
# to facilitate multiple clients simultaneously
def handleClientRequest(info, sock_obj, data_root_directory):
        print 'Accepted connection from client: '
        print '%s, port: %s' % (info[0], info[1])
        print '\n'
        data = ''
#        while(True):
        tempData = sock_obj.recv(BUFLEN)
            #if not tempData:
             #   break
        data += tempData

	print 'The data sent to the server was: %s' % data
        #now send the data to salsa and get the results back
	result = salsa.querySalsa(data) #should this be salsa.querySalsa(data)?
	print 'result is: %s' % result
	#the total number of queries is the last item in list
	totalNgrams = result.pop()
	#23.10.12 - trying to fix the AJAX error - Update: tested
	#TEST
	#result = [(56193, 'Page'), (35272, 'sheet'), (6171, 'side')]
	output = "Total Ngrams in query: " + str(totalNgrams)
	noSyn = 0
        for syn in result:
		 #if the score is not 0
		score = syn[0] 
		if (score > 0):
		 	output += '|' + syn[1]
			noSyn += 1
	if (noSyn > 0):
		sock_obj.sendall(output+"\n")
	else:
		empty = 'No synonyms were found...'
		sock_obj.sendall(empty+"\n")
	
        print 'The result from salsa was: %s' % output 	
	#Update: can't send a list - needs to be a single string (currently | delimited)
       	sock_obj.sendall(output+"\n")
	print 'Closing Connection'
        sock_obj.close()

        #fDirName = data_root_directory + '/' + str(info[0]) + '_' + str(info[1]) + '/'
        #os.mkdir(fDirName)
        #os.chdir(fDirName)
        #f = open('data.txt', 'wb')
        #f.write(data)
        #f.close()

        #os.chdir('..')
        #print 'Data transferred to %s' % fDirName

def startServer(port_number, data_root_directory):
    server_sock = socket.socket()
    server_sock.bind(('127.0.0.1', int(port_number)))
    server_sock.listen(0)
    while(True):
        # Accept a connection
        sock_obj, info = server_sock.accept()
        # Create a subprocess to deal with the client
        process = Process(target = handleClientRequest, args=(info, sock_obj, data_root_directory))
        process.start()
        process.join()

def error():
    print 'Usage: ./server.py port_number data_root_directory'
    print 'Exiting ... '
    sys.exit()

def main():
    if len(sys.argv) != 3:
        error()
    startServer(sys.argv[1], sys.argv[2])

if __name__ == '__main__':
    main()
