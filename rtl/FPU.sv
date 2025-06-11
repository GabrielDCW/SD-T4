module FPU (
  input clock100Khz 
  input reset
  input op_A_in [7:0]
  input op_B_in [22:0]
  output data_out 
  output status_out
);
