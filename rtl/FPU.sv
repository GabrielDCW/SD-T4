// fpu.sv
module fpu (
    input  logic        clk,
    input  logic        rst, // reset assíncrono ativo em 0
    input  logic [31:0] op_a_in,
    input  logic [31:0] op_b_in,
    input  logic        op_sel, // 0 = soma, 1 = subtração
    output logic [31:0] data_out,
    output logic [3:0]  status_out // EXACT, OVERFLOW, UNDERFLOW, INEXACT
);

  logic sign_a, sign_b;
  logic [6:0] exp_a, exp_b; // 7 bits de expoente
  logic [24:0] mant_a, mant_b; // 24 bits + bit implícito

  // Registradores
  logic [28:0] mant_res; // 24 + margem para operações
  logic [7:0] exp_res;   // 7 bits + margem
  logic sign_res;

  // Flags internas
  logic exact_flag, overflow_flag, underflow_flag, inexact_flag;

  always_comb begin
    // Extrai os campos dos operandos
    sign_a = op_a_in[31];
    exp_a  = op_a_in[30:24];
    mant_a = {1'b1, op_a_in[23:0]};

    sign_b = op_b_in[31];
    exp_b  = op_b_in[30:24];
    mant_b = {1'b1, op_b_in[23:0]};

    // Alinha os expoentes
    if (exp_a > exp_b) begin
      mant_b = mant_b >> (exp_a - exp_b);
      exp_res = exp_a;
    end else begin
      mant_a = mant_a >> (exp_b - exp_a);
      exp_res = exp_b;
    end

    // Operação
    if (op_sel == 1) begin
      if (sign_a == sign_b)
        mant_res = mant_a - mant_b;
      else
        mant_res = mant_a + mant_b;
    end else begin
      if (sign_a == sign_b)
        mant_res = mant_a + mant_b;
      else
        mant_res = (mant_a > mant_b) ? mant_a - mant_b : mant_b - mant_a;
    end

    sign_res = sign_a; // simplificado

    // Normalização
    while (mant_res[24] != 1 && exp_res > 0) begin
      mant_res = mant_res << 1;
      exp_res--;
    end

    // Flags
    exact_flag     = (mant_res[0 +: 24] == 0);
    inexact_flag   = !exact_flag;
    overflow_flag  = (exp_res >= 127);
    underflow_flag = (exp_res == 0);

    // Atualiza status
    status_out = 4'b0000;
    status_out[0] = exact_flag;
    status_out[1] = overflow_flag;
    status_out[2] = underflow_flag;
    status_out[3] = inexact_flag;

    // Gera saída final
    data_out = {sign_res, exp_res[6:0], mant_res[23:0]};
  end
endmodule

