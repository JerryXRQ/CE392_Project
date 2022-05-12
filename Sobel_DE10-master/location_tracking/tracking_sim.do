setenv LMC_TIMEUNIT -9
vlib work
vmap work work
vlog -work work "./fifo.sv"
vlog -work work "./tracking.sv"
vlog -work work "./tracking_tb.sv"
vsim -classdebug -voptargs=+acc +notimingchecks -L work work.tracking_tb -wlf tracking_tb.wlf
add wave -noupdate -group tracking_tb
add wave -noupdate -group tracking_tb -radix hexadecimal /tracking_tb/*
add wave -noupdate -group tracking_tb/tracking_dut
add wave -noupdate -group tracking_tb/tracking_dut -radix hexadecimal /tracking_tb/tracking_dut/*
add wave -noupdate -group tracking_tb/tracking_dut/fifo_in_inst
add wave -noupdate -group tracking_tb/tracking_dut/fifo_in_inst -radix hexadecimal /tracking_tb/tracking_dut/fifo_in_inst/*
run -all