# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/MIET/APS_labs/lab1/lab1.cache/wt [current_project]
set_property parent.project_path D:/MIET/APS_labs/lab1/lab1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/MIET/APS_labs/lab1/lab1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem {
  D:/MIET/APS_labs/lab1/instruction.txt
  D:/MIET/APS_labs/lab1/mem.txt
}
read_verilog -library xil_defaultlib -sv {
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/operation_define.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/adder_for_pc.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/alu_riscv.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/data_memory.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/decoder_riscv.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/instruction_memory.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/mp2_1.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/mp3_1.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/mp4_1.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/prorgram_counter.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/register_file.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/se.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/sign_extand20.sv
  D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/tract.sv
}
set_property is_global_include true [get_files D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/operation_define.sv]
read_verilog -library xil_defaultlib D:/MIET/APS_labs/lab1/lab1.srcs/sources_1/new/defines_riscv.v
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/MIET/Nexys-A7-100T-Master.xdc
set_property used_in_implementation false [get_files D:/MIET/Nexys-A7-100T-Master.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top tract -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef tract.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file tract_utilization_synth.rpt -pb tract_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
