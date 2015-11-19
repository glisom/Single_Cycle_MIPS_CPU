@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xsim mips_single_cycle_tb_behav -key {Behavioral:sim_1:Functional:mips_single_cycle_tb} -tclbatch mips_single_cycle_tb.tcl -view H:/EECS_645/HW09_source_files/07_MIPS_Single_Cycle/mips_single_cycle_proj/mips_single_cycle_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
