# 
# Synthesis run script generated by Vivado
# 

set_param gui.test TreeTableDev
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

create_project -in_memory -part xc7z020clg400-1
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.cache/wt [current_project]
set_property parent.project_path C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:microzed_7020:part0:1.0 [current_project]
add_files C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/design_1.bd
set_property used_in_implementation false [get_files -all c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/ip/design_1_processing_system7_0_0/design_1_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/design_1_ooc.xdc]
set_property is_locked true [get_files C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/design_1.bd]

read_verilog -library xil_defaultlib C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
catch { write_hwdef -file design_1_wrapper.hwdef }
synth_design -top design_1_wrapper -part xc7z020clg400-1
write_checkpoint -noxdef design_1_wrapper.dcp
catch { report_utilization -file design_1_wrapper_utilization_synth.rpt -pb design_1_wrapper_utilization_synth.pb }