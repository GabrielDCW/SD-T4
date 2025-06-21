if {[file isdirectory work]} {vdel -lib work -all}
vlib work
vmap work work
vlog fpu.sv
vlog tb_fpu.sv
vsim -voptargs=+acc tb_fpu
quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1
do wave.do
run -all
