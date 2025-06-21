# 💻 Trabalho 4 – FPU em HDL  

---

## 🎯 Objetivo  
Desenvolver uma Unidade de Ponto Flutuante (FPU) simplificada em HDL capaz de realizar operações de **soma e subtração** com números representados em ponto flutuante personalizado, baseado no padrão IEEE 754.

---

## 📌 Cálculo de X e Y  

- Fórmula:  
- X = 8 (+/-) (soma dos dígitos da matrícula mod 4)  
- Sinal + se dígito verificador for ímpar, - se for par

- Matrícula: **241076256**  
- Dígito verificador: **6 (par)** → sinal **negativo**  
- Soma dos dígitos: 2+4+1+0+7+6+2+5+6 = **33**  
- 33 mod 4 = 1  
- **X = 8 - 1 = 7**  
- **Y = 31 - X = 24**

---

## 2️⃣ Organização do Projeto
🧠 Módulo fpu.sv
Implementa uma unidade de ponto flutuante com suporte para soma e subtração de números codificados com sinal (1 bit), expoente (7 bits) e mantissa (24 bits).

### Entradas:
- op_a_in, op_b_in – Operandos (32 bits cada)
- op_sel – Seletor de operação (0 = soma, 1 = subtração)
- clk – Clock de 100 kHz
- rst – Reset assíncrono ativo em 0

### Saídas:
- data_out – Resultado da operação
- status_out – Vetor one-hot com flags:
  - [0] EXACT
  - [1] OVERFLOW
  - [2] UNDERFLOW
  - [3] INEXACT

### 🔄 Fluxo da operação:

- Extração dos campos (sinal, expoente, mantissa)
- Alinhamento dos expoentes
- Soma/Subtração da mantissa conforme sinais e operação
- Normalização do resultado
- Geração de flags de status
- Montagem do resultado final no formato de 32 bits

---
## 🧮 Formato de Representação

| Campo    | Bits         | Descrição                                |
|----------|--------------|--------------------------------------------|
| Sinal    | 1 bit        | Bit 31                                    |
| Expoente | 7 bits (X)   | Bits 30–24, com excesso-63                |
| Mantissa | 24 bits (Y)  | Bits 23–0, com bit implícito `1` na frente |

> Representação:  
> **valor = (-1)^sinal × (1.M) × 2^(expoente - 63)**

---

## 🧪 Casos de Teste (Testbench)

Total de **10 casos**, incluindo **corner-cases**:
1. Soma simples: 1.0 + 1.0  
2. Soma com zero  
3. Subtração de si mesmo  
4. Subtração com resultado negativo  
5. Overflow (expoente ≥ 127)  
6. Underflow (expoente = 0)  
7. Inexact (truncamento de bits)  
8. Soma de valores muito pequenos  
9. Cancelamento: +1.0 + (-1.0)  
10. Subtração com sinais opostos  

---

## 📥 Como Executar

1. Abra o projeto no Modelsim/Questa.
2. Execute o arquivo sim.do para rodar a simulação automaticamente.

---

## 🧾 Status Flags (`status_out`)

| Bit | Nome        | Descrição                                     |
|-----|-------------|-----------------------------------------------|
| 0   | EXACT       | Resultado exato, sem perda de precisão        |
| 1   | OVERFLOW    | Expoente final ≥ 127 (valor muito grande)     |
| 2   | UNDERFLOW   | Expoente final = 0 (valor muito pequeno)      |
| 3   | INEXACT     | Resultado com perda de precisão (truncamento) |

---

## 👤 Feito por: 
**Gabriel de Carvalho Woltmann**  


