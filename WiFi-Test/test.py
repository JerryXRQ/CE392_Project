import socket

def main():
    localIP = "127.0.0.1"

    localPort = 8080

    bufferSize = 1024

    msgFromServer = "Hello UDP Client"

    bytesToSend = str.encode(msgFromServer)

    # Create a datagram socket

    UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

# Bind to address and ip

    UDPServerSocket.bind(("", localPort))

    print("UDP server up and listening")

# Listen for incoming datagrams

    while (True):
        bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)

        message = bytesAddressPair[0]

        address = bytesAddressPair[1]

        clientMsg = "Message from Client:{}".format(message)
        clientIP = "Client IP Address:{}".format(address)

        print(clientMsg)
        print(clientIP)
        msg = message.decode('ascii')
        print("X_Coordinate: ",msg[:msg.find('\n')])
        msg = msg[msg.find('\n')+1:]
        print("Y_Coordinate: ", msg[:msg.find('\n')])
        msg = msg[msg.find('\n') + 1:]
        print("Width: ", msg[:msg.find('\n')])
        msg = int(msg[msg.find('\n') + 1:])&4095
        print("Height: ", msg)

    # Sending a reply to client

    UDPServerSocket.sendto(bytesToSend, address)

if __name__ == "__main__":
    main()