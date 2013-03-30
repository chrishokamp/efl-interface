#! /usr/bin/python
import socket
import sys

def startClient(info, data_to_transfer):
    server_address, port_number = info.split(':')
    client_socket = socket.socket()
    try:
        client_socket.connect((server_address, int(port_number)))
    except IOError:
        print 'Could not connect ...'
        sys.exit()

    print 'Connected to the server ...'
    #allDataF = open(file_to_transfer, 'rb')
    #allData = allDataF.read()
    #allDataF.close()
    
    # Make the request to transfer the data
    client_socket.sendall(data_to_transfer)

    print 'Closing connection ...'
    
    client_socket.close()

def error():
    print 'Usage: ./client.py server_address:port_number query_for_salsa...'
    print 'Exiting ... '
    sys.exit()

def main():
    if len(sys.argv) != 3:
        error()
    startClient(sys.argv[1], sys.argv[2])

if __name__ == '__main__':
    main()
