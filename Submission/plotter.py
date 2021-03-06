import socket
import time
import matplotlib
import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d

mode = 0
#Mode 0 Plotting 3D Plot
#Mode 1 Plotting XY Plot
#Mode 2 Plotting XZ Plot

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

    x = []
    y = []
    z = []

    plt.ion()
    if mode == 0:
        figure = plt.figure(figsize=(9, 6))
        ax = plt.axes(projection='3d')
        ax.grid()
        pts = ax.scatter(x, y, z, color='red')

        ax.set_title("Tracker Results")
        ax.set_xlabel("X")
        ax.set_ylabel("Y")
        ax.set_zlabel("Z")

        ax.set_autoscaley_on(True)
        ax.set_xlim(0, 640)
        ax.set_ylim(0, 480)
        ax.set_zlim(0,500)
        plt.pause(0.1)

        while (True):
            bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)

            message = bytesAddressPair[0]

            address = bytesAddressPair[1]

            clientMsg = "Message from Client:{}".format(message)
            clientIP = "Client IP Address:{}".format(address)


            print(clientMsg)
            print(clientIP)

            msg = message.decode('ascii')
            x_current = int(msg[:msg.find('\n')])
            print("X_Coordinate: ",msg[:msg.find('\n')])
            msg = msg[msg.find('\n')+1:]
            y_current = int(msg[:msg.find('\n')])
            print("Y_Coordinate: ", msg[:msg.find('\n')])
            msg = msg[msg.find('\n') + 1:]
            width_current = int(msg[:msg.find('\n')])
            print("Width: ", msg[:msg.find('\n')])
            msg = int(msg[msg.find('\n') + 1:])
            height_current = int(msg)
            print("Height: ", msg)


            if height_current < 480 and width_current < 640 and width_current>0 and height_current>0:
                x.append(x_current)
                y.append(y_current)
                z.append(500 - 500 * 100/(width_current*height_current)**0.5)

                pts.remove()
                pts = ax.scatter(x, y, z, color='red')
                plt.draw()
                figure.canvas.flush_events()
    if mode == 1:
        plt.ion()
        figure, ax = plt.subplots(figsize=(8, 6))
        plt.title("Tracker Results")
        plt.xlabel("X")
        plt.ylabel("Y")
        line1, = ax.plot(x, y, 'o')
        ax.set_xlim(0, 640)
        ax.set_ylim(0, 480)
        plt.pause(0.1)


        while (True):
            bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)

            message = bytesAddressPair[0]

            address = bytesAddressPair[1]

            clientMsg = "Message from Client:{}".format(message)
            clientIP = "Client IP Address:{}".format(address)


            print(clientMsg)
            print(clientIP)

            msg = message.decode('ascii')
            x_current = int(msg[:msg.find('\n')])
            print("X_Coordinate: ",msg[:msg.find('\n')])
            msg = msg[msg.find('\n')+1:]
            y_current = int(msg[:msg.find('\n')])
            print("Y_Coordinate: ", msg[:msg.find('\n')])
            msg = msg[msg.find('\n') + 1:]
            width_current = int(msg[:msg.find('\n')])
            print("Width: ", msg[:msg.find('\n')])
            msg = int(msg[msg.find('\n') + 1:])
            height_current = int(msg)
            print("Height: ", msg)


            if height_current < 480 and width_current < 640 and width_current>0 and height_current>0:
                x.append(x_current)
                y.append(y_current)

                line1.set_xdata(x)
                line1.set_ydata(y)
                ax.relim()
                ax.autoscale_view()
                figure.canvas.draw()

                figure.canvas.flush_events()
    if mode == 2:
        plt.ion()
        figure, ax = plt.subplots(figsize=(8, 6))
        plt.title("Tracker Results")
        plt.xlabel("X")
        plt.ylabel("Z")
        line1, = ax.plot(x, z, 'o')
        ax.set_xlim(0, 640)
        ax.set_ylim(0, 480)
        plt.pause(0.1)


        while (True):
            bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)

            message = bytesAddressPair[0]

            address = bytesAddressPair[1]

            clientMsg = "Message from Client:{}".format(message)
            clientIP = "Client IP Address:{}".format(address)


            print(clientMsg)
            print(clientIP)

            msg = message.decode('ascii')
            x_current = int(msg[:msg.find('\n')])
            print("X_Coordinate: ",msg[:msg.find('\n')])
            msg = msg[msg.find('\n')+1:]
            y_current = int(msg[:msg.find('\n')])
            print("Y_Coordinate: ", msg[:msg.find('\n')])
            msg = msg[msg.find('\n') + 1:]
            width_current = int(msg[:msg.find('\n')])
            print("Width: ", msg[:msg.find('\n')])
            msg = int(msg[msg.find('\n') + 1:])
            height_current = int(msg)
            print("Height: ", msg)


            if height_current < 480 and width_current < 640 and width_current>0 and height_current>0:
                x.append(x_current)
                z.append(500 - 300 * 100/(width_current*height_current)**0.5)

                line1.set_xdata(x)
                line1.set_ydata(z)
                ax.relim()
                ax.autoscale_view()
                figure.canvas.draw()

                figure.canvas.flush_events()

if __name__ == "__main__":
    main()