create_clock -name clk_100MHz -period 10.0 -waveform {0.0 5.0} [get_ports Clock_100MHz]

create_generated_clock -name gen_clk_400KHz -source [get_ports Clock_100MHz] -edges [list 1 261 521]  \
     [get_pins temp_sensor_DUT/clock_400KHz_reg/Q] 

create_generated_clock -name gen_clk_8KHz -source [get_ports Clock_100MHz] -edges [list 1 12501 25001]  \
     [get_pins bcd_to_7_seg_LED_DUT/clock_8KHz_reg/Q] 


set_clock_groups -name async_clks_100MHz_8KHz -asynchronous -group [get_clocks clk_100MHz] -group [get_clocks gen_clk_8KHz]

set_clock_groups -name async_clks_100MHz_400KHz -asynchronous -group [get_clocks clk_100MHz] -group [get_clocks gen_clk_400KHz] 

set_clock_groups -name async_clks_400KHz_8KHz -asynchronous -group [get_clocks gen_clk_400KHz] -group [get_clocks gen_clk_8KHz] 

set_false_path -from [get_ports Clear_n]


set_input_delay -clock [get_clocks gen_clk_8KHz] 1.0 [get_ports {Register_select[3] Register_select[2] Register_select[1] Register_select[0] SDA Clear_n}]

set_output_delay -clock [get_clocks gen_clk_8KHz] 1.0 [get_ports {AN7 AN6 AN5 AN4 AN3 AN2 AN1 AN0 CA CB CC CD CE CF CG DP SCL SDA Tcritical Thigh Tlow}]