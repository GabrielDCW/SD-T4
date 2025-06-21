`timescale 1ns/1ps

module tb_fpu();

  logic clk = 0, rst = 1;
  logic [31:0] op_a_in, op_b_in;
  logic op_sel;
  logic [31:0] data_out;
  logic [3:0] status_out;

  fpu dut (
    .clk(clk),
    .rst(rst),
    .op_a_in(op_a_in),
    .op_b_in(op_b_in),
    .op_sel(op_sel),
    .data_out(data_out),
    .status_out(status_out)
  );

  // Clock de 100 kHz
  always #5000 clk = ~clk;

  task apply_inputs(input [31:0] a, input [31:0] b, input logic sel);
    begin
      op_a_in = a;
      op_b_in = b;
      op_sel  = sel;
      #10000;
    end
  endtask

  initial begin
    #10000 rst = 0; // libera reset após 1 ciclo

    // Teste 1: Soma de dois positivos simples
    apply_inputs(32'b0_0111111_000000000000000000000000, 
                 32'b0_0111111_000000000000000000000000, 
                 0);

    // Teste 2: Soma com zero
    apply_inputs(32'b0_0111111_000000000000000000000000,
                 32'b0_0000000_000000000000000000000000, 
                 0);

    // Teste 3: Subtração de um número por ele mesmo
    apply_inputs(32'b0_0111111_100000000000000000000000, 
                 32'b0_0111111_100000000000000000000000, 
                 1);

    // Teste 4: Subtração que dá negativo
    apply_inputs(32'b0_0111111_000000000000000000000000, 
                 32'b0_1000000_000000000000000000000000, 
                 1);

    // Teste 5: Overflow
    apply_inputs(32'b0_1111110_111111111111111111111111, 
                 32'b0_1111110_111111111111111111111111, 
                 0);

    // Teste 6: Underflow
    apply_inputs(32'b0_0000001_000000000000000000000000, 
                 32'b0_0000001_000000000000000000000000, 
                 1);

    // Teste 7: Inexact
    apply_inputs(32'b0_0111111_000000000000000000000001,
                 32'b0_0111111_000000000000000000000001,
                 0);

    // Teste 8: Soma de números pequenos
    apply_inputs(32'b0_0010000_000000000000000000000000, 
                 32'b0_0010000_000000000000000000000000,
                 0);

    // Teste 9: Soma com sinais opostos (cancelamento)
    apply_inputs(32'b0_0111111_000000000000000000000000, 
                 32'b1_0111111_000000000000000000000000,
                 0);

    // Teste 10: Subtração com sinais opostos
    apply_inputs(32'b1_0111111_000000000000000000000000,
                 32'b0_0111111_000000000000000000000000,
                 1);

    #100000; // Espera extra
    $finish;
  end
endmodule
