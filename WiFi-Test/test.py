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
        msg = str(message)
        print("X_Coordinate: %d",message[:msg.find('\n')])
        msg = msg[msg.find('\n')+1:]
        print("Y_Coordinate: %d", message[:msg.find('\n')])
        msg = msg[msg.find('\n') + 1:]
        print("Width: %d", message[:msg.find('\n')])
        msg = msg[msg.find('\n') + 1:]
        print("Height: %d", message)

    # Sending a reply to client

    UDPServerSocket.sendto(bytesToSend, address)

if __name__ == "__main__":
    main()