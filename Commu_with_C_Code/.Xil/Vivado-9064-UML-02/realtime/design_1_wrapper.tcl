# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    set ::env(RT_TMP) "./.Xil/Vivado-9064-UML-02/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7z020clg400-1

    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog {
      c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/ipshared/xilinx.com/processing_system7_v5_5/da926f63/hdl/verilog/processing_system7_v5_5_aw_atc.v
      c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/ipshared/xilinx.com/processing_system7_v5_5/da926f63/hdl/verilog/processing_system7_v5_5_b_atc.v
      c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/ipshared/xilinx.com/processing_system7_v5_5/da926f63/hdl/verilog/processing_system7_v5_5_w_atc.v
      c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/ipshared/xilinx.com/processing_system7_v5_5/da926f63/hdl/verilog/processing_system7_v5_5_atc.v
      c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/ipshared/xilinx.com/processing_system7_v5_5/da926f63/hdl/verilog/processing_system7_v5_5_trace_buffer.v
      c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/ip/design_1_processing_system7_0_0/hdl/verilog/processing_system7_v5_5_processing_system7.v
      c:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/ip/design_1_processing_system7_0_0/synth/design_1_processing_system7_0_0.v
      C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/hdl/design_1.v
      C:/Users/Tim-UML/Documents/GitHub/MA_1/Commu_with_C_Code/Commu_with_C_Code.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top design_1_wrapper
    set rt::reportTiming false
    rt::set_parameter elaborateOnly true
    rt::set_parameter elaborateRtl true
    rt::set_parameter eliminateRedundantBitOperator false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter merge_flipflops true
    rt::set_parameter srlDepthThreshold 3
    rt::set_parameter rstSrlDepthThreshold 4
    rt::set_parameter webTalkPath {}
    rt::set_parameter enableSplitFlowPath "./.Xil/Vivado-9064-UML-02/"
    if {$rt::useElabCache == false} {
      rt::run_rtlelab -module $rt::top
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    if { $rt::flowresult == 1 } { return -code error }

    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
    }


    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}