#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.0 MHz" [get_ports FPGA_CLK1_50]
create_clock -period "50.0 MHz" [get_ports FPGA_CLK2_50]
create_clock -period "50.0 MHz" [get_ports FPGA_CLK3_50]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty

create_clock -period "25.0 MHz"  -name MIPI_PIXEL_CLK [get_ports MIPI_PIXEL_CLK]
create_clock -period "25.0 MHz"  -name HDMI_TX_CLK [get_ports HDMI_TX_CLK]

create_clock -period "15 KHz"  -name HDMI_TX_HS [get_ports HDMI_TX_HS]
create_clock -period "60 Hz"  -name HDMI_TX_VS [get_ports HDMI_TX_VS]

#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay 2.0 -clock "MIPI_PIXEL_CLK" [get_ports {MIPI_PIXEL_D[*]}]
set_input_delay 2.0 -clock "MIPI_PIXEL_CLK" [get_ports MIPI_PIXEL_VS]
set_input_delay 2.0 -clock "MIPI_PIXEL_CLK" [get_ports MIPI_PIXEL_HS]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay 2.0 -clock "HDMI_TX_CLK" [get_ports {HDMI_TX_D[*]}]
set_output_delay 2.0 -clock "HDMI_TX_CLK" [get_ports HDMI_TX_DE]
set_output_delay 2.0 -clock "HDMI_TX_CLK" [get_ports HDMI_TX_VS]
set_output_delay 2.0 -clock "HDMI_TX_CLK" [get_ports HDMI_TX_HS]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



