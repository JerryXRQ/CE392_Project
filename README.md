# CE392_Project

Our goal in this project is to build a 3D tracking system that only uses a camera as the source of information. By tracking the location of a green marker and performing some geometric derivations, we should be able to obtain the x, y, and z coordinates of a stylus. Compared to existing implementations on VR devices, this approach greatly reduces the cost and complexity of the system. We will evaluate the performance of this design and make improvements to it.

The FPGA device we have chosen is the DE-10 Nano board. It has an ARM processor for running Linux, two GPIO ports for connecting the camera and RFS Wi-Fi module, and a NIOS II processor used for controlling the Wi-Fi module and interfacing different components. It provides great flexibility and processing power for our project. The camera we have chosen is the D8M-GPIO camera from Terasic. It produces 640*480 images at 60 frames per second. The Wi-Fi module we use is the RFS board from Terasic.  

The FPGA portion of the project resembles the Sobel unit we designed before. Reading the pixel stream from the camera, our location detection module will locate the green pixels and find the center of the green box. Based on the size of the green box with respect to a reference value, we can derive the z-coordinate of the pen.

We run C code on the NIOS II processor on the DE-10 board. The processor interfaces with the onboard FPGA, on top of which we build our streaming architecture to get the coordinates. The processor then controls the RFS module, which has a built-in Wi-Fi unit, to send out the results via UDP packets. The data packets are then captured by a Python program running the drawing code.
