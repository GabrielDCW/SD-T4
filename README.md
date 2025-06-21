# 💻 Trabalho 4 – FPU em HDL  
**Gabriel de Carvalho Woltman**

---

## 🎯 Objetivo
Desenvolver uma Unidade de Ponto Flutuante (FPU) simplificada em HDL capaz de realizar operações de **soma e subtração** com números representados em ponto flutuante personalizado, baseado no padrão IEEE 754.

---

## 📌 Cálculo de X e Y

> Fórmula:  
> X = 8 (+/-) (soma dos dígitos da matrícula mod 4)  
> Sinal + se dígito verificador for ímpar, - se for par

- Matrícula: **241076256**  
- Dígito verificador: **6 (par)** → sinal **negativo**  
- Soma dos dígitos: 2+4+1+0+7+6+2+5+6 = **33**  
- 33 mod 4 = 1 →  
  **X = 8 - 1 = 7**,  
  **Y = 31 - X = 24**

---

## 🧪 Casos de Teste (Testbench)
Total de 10 casos, incluindo corner-cases:
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

## 🧾 Status Flags (status_out)
Bit 	Nome	      Descrição
0	    EXACT	      Resultado exato, sem perda de precisão
1	    OVERFLOW	  Expoente final ≥ 127 (valor muito grande)
2	    UNDERFLOW  	Expoente final = 0 (valor muito pequeno)
3	    INEXACT	    Resultado com perda de precisão (truncamento)
