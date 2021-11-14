# Temperature Sensor
set_property PACKAGE_PIN F16 [get_ports SCL]
set_property IOSTANDARD LVCMOS33 [get_ports SCL]

set_property PACKAGE_PIN G16 [get_ports SDA]
set_property IOSTANDARD LVCMOS33 [get_ports SDA]

set_property PACKAGE_PIN D14 [get_ports TMP_INT]
set_property IOSTANDARD LVCMOS33 [get_ports TMP_INT]

set_property PACKAGE_PIN C14 [get_ports TMP_CT]
set_property IOSTANDARD LVCMOS33 [get_ports TMP_CT]


# LED
set_property PACKAGE_PIN T5 [get_ports Tcritical]
set_property IOSTANDARD LVCMOS33 [get_ports Tcritical]

set_property PACKAGE_PIN T6 [get_ports Thigh]
set_property IOSTANDARD LVCMOS33 [get_ports Thigh]

set_property PACKAGE_PIN R8 [get_ports Tlow]
set_property IOSTANDARD LVCMOS33 [get_ports Tlow]

set_property PACKAGE_PIN V9 [get_ports TMP_CT_out] 
set_property IOSTANDARD LVCMOS33 [get_ports TMP_CT_out] 

set_property PACKAGE_PIN T8 [get_ports TMP_INT_out] 
set_property IOSTANDARD LVCMOS33 [get_ports TMP_INT_out] 

 
# Crystala Oscillator
set_property PACKAGE_PIN E3 [get_ports Clock_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports Clock_100MHz]


# Slide switch
set_property PACKAGE_PIN U9 [get_ports Clear_n]
set_property IOSTANDARD LVCMOS33 [get_ports Clear_n]

set_property PACKAGE_PIN U8 [get_ports Register_select[0]]
set_property IOSTANDARD LVCMOS33 [get_ports Register_select[0]]

set_property PACKAGE_PIN R7 [get_ports Register_select[1]]
set_property IOSTANDARD LVCMOS33 [get_ports Register_select[1]]

set_property PACKAGE_PIN R6 [get_ports Register_select[2]]
set_property IOSTANDARD LVCMOS33 [get_ports Register_select[2]]

set_property PACKAGE_PIN R5 [get_ports Register_select[3]]
set_property IOSTANDARD LVCMOS33 [get_ports Register_select[3]]


# 7-Segment LED
set_property PACKAGE_PIN N6 [get_ports AN0]
set_property IOSTANDARD LVCMOS33 [get_ports AN0]

set_property PACKAGE_PIN M6 [get_ports AN1]
set_property IOSTANDARD LVCMOS33 [get_ports AN1]

set_property PACKAGE_PIN M3 [get_ports AN2]
set_property IOSTANDARD LVCMOS33 [get_ports AN2]

set_property PACKAGE_PIN N5 [get_ports AN3]
set_property IOSTANDARD LVCMOS33 [get_ports AN3]

set_property PACKAGE_PIN N2 [get_ports AN4]
set_property IOSTANDARD LVCMOS33 [get_ports AN4]

set_property PACKAGE_PIN N4 [get_ports AN5]
set_property IOSTANDARD LVCMOS33 [get_ports AN5]

set_property PACKAGE_PIN L1 [get_ports AN6]
set_property IOSTANDARD LVCMOS33 [get_ports AN6]

set_property PACKAGE_PIN M1 [get_ports AN7]
set_property IOSTANDARD LVCMOS33 [get_ports AN7]

set_property PACKAGE_PIN L3 [get_ports CA]
set_property IOSTANDARD LVCMOS33 [get_ports CA]

set_property PACKAGE_PIN N1 [get_ports CB]
set_property IOSTANDARD LVCMOS33 [get_ports CB]

set_property PACKAGE_PIN L5 [get_ports CC]
set_property IOSTANDARD LVCMOS33 [get_ports CC]

set_property PACKAGE_PIN L4 [get_ports CD]
set_property IOSTANDARD LVCMOS33 [get_ports CD]

set_property PACKAGE_PIN K3 [get_ports CE]
set_property IOSTANDARD LVCMOS33 [get_ports CE]

set_property PACKAGE_PIN M2 [get_ports CF]
set_property IOSTANDARD LVCMOS33 [get_ports CF]

set_property PACKAGE_PIN L6 [get_ports CG]
set_property IOSTANDARD LVCMOS33 [get_ports CG]

set_property PACKAGE_PIN M4 [get_ports DP]
set_property IOSTANDARD LVCMOS33 [get_ports DP]