onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -divider Inputs
add wave -hex tb_fpu/clk
add wave -hex tb_fpu/rst
add wave -bin tb_fpu/op_a_in
add wave -bin tb_fpu/op_b_in
add wave -dec tb_fpu/op_sel
add wave -divider Outputs
add wave -bin tb_fpu/data_out
add wave -bin tb_fpu/status_out

update
