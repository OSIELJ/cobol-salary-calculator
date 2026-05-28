# 💰 COBOL Salary Calculator

> **Projeto 3 - Acelera Maker Montreal**
> Calculadora de Salário Final em COBOL, compilada e executada em mainframe IBM com sistema operacional MVS 3.8j (TK5).

---

## 📋 Sobre o Projeto

Sistema interativo de cálculo de salário desenvolvido em **COBOL ANS 1974**, com menu navegável que permite ao usuário informar o nome do funcionário, salário base e tempo de empresa para calcular automaticamente o salário final com bônus por tempo de serviço.

O programa foi **compilado e testado em mainframe real** (emulado via Hercules + TK5), demonstrando o ciclo completo de desenvolvimento mainframe: edição, transferência, compilação JCL, link-edit e execução interativa via TSO.

---

## 🎯 Funcionalidades

- ✅ **Menu interativo** com navegação por opções
- ✅ **Entrada de dados** do funcionário (nome, salário, tempo de empresa)
- ✅ **Cálculo automático de bônus** baseado em tempo de empresa:
  - Até 1 ano → **5%** de bônus
  - De 2 a 5 anos → **10%** de bônus
  - Mais de 5 anos → **15%** de bônus
- ✅ **Conversão de entrada flexível** (digite valores sem zeros à esquerda)
- ✅ **Formatação monetária brasileira** (R$ 2.500,00)
- ✅ **Loop contínuo** até o usuário escolher sair

---

## 🎥 Demonstração

### Execução Interativa pelo Menu

<img width="722" height="372" alt="1_ TK5 - TN3270 Plus 2026-05-28 20-07-17" src="https://github.com/user-attachments/assets/65f569b6-2c68-42c7-87e3-b003ffdd8bd9" />

> *Programa rodando no mainframe TK5 com interação via TSO*
> 

---

## 📸 Screenshots

### 🛠️ JCL de Compilação

<img width="1919" height="1030" alt="Captura de tela 2026-05-28 200958" src="https://github.com/user-attachments/assets/394af82a-077b-4574-aa82-7a294e5c2730" />

> *JCL usando procedimento **COBUCL** para compilar e linkeditar o programa SALARYPJ*
> 

### ▶️ JCL de Execução

<img width="1918" height="1031" alt="Captura de tela 2026-05-28 201126" src="https://github.com/user-attachments/assets/41397fa5-dd4b-4918-ba38-1da391aa756f" />

> *JCL que executa o programa SALARYPJ passando os dados via SYSIN*

### 📊 Resultado da Execução

<img width="1919" height="1033" alt="Captura de tela 2026-05-28 201230" src="https://github.com/user-attachments/assets/5415ecbf-6cf3-42cd-a130-20e7806c8fe9" />

> *Saída do programa exibindo o resumo do cálculo de salário com bônus aplicado*
> 

---

## 🏗️ Arquitetura

```
cobol-salary-calculator/
├── src/
│   └── SALARYPJ.cbl            # Código-fonte COBOL principal
├── .gitignore
└── README.md
```

---

## 💻 Tecnologias Utilizadas

| Tecnologia | Descrição |
|-----------|-----------|
| **COBOL ANS 1974** | Linguagem de programação |
| **MVS 3.8j (TK5)** | Sistema operacional mainframe |
| **Hercules Emulator** | Emulador de hardware IBM System/370 |
| **TN3270 Plus** | Cliente terminal 3270 |
| **JCL** | Job Control Language para compilação |
| **TSO/RFE** | Time Sharing Option / Editor RFE |
| **IND$FILE** | Transferência de arquivos PC ↔ Mainframe |

---

## 🔧 Estrutura do Código

### Divisões COBOL

```cobol
IDENTIFICATION DIVISION    → Identificação do programa
ENVIRONMENT DIVISION       → Configuração do ambiente (SPECIAL-NAMES)
DATA DIVISION              → Definição de variáveis (WORKING-STORAGE)
PROCEDURE DIVISION         → Lógica do programa
```

### Principais Parágrafos

| Parágrafo | Função |
|-----------|--------|
| `MAIN-PROCEDURE` | Ponto de entrada do programa |
| `MOSTRA-MENU` | Exibe menu principal |
| `PROCESSA-OPCAO` | Trata a opção escolhida |
| `ENTRADA-DADOS` | Coleta dados do funcionário |
| `CONVERTE-SALARIO` | Converte string em número |
| `CONVERTE-TEMPO` | Converte string em número |
| `CALCULA-BONUS` | Calcula percentual de bônus |
| `CALCULA-SALARIO` | Soma salário base + bônus |
| `EXIBE-RESULTADO` | Mostra resumo final |

---

## 🚀 Como Executar no Mainframe TK5

### 1️⃣ Pré-requisitos

- TK5 (MVS 3.8j) rodando no Hercules
- TN3270 Plus conectado ao mainframe
- Usuário TSO `HERC01`

### 2️⃣ Transferir o arquivo para o mainframe

Host -> File Transfer...

ou

Crie um script `PutSalarypj.mac.txt`:

```
FileTransfer    operation=send,
                pcfile=C:\MAIN\SALARYPJ.cbl,
                hostfile='HERC01.COBOL(SALARYPJ)',
                opsys=mvs/tso,
                lrecl=80,
                recfm=fixed,
                options="ascii crlf"
exit
```

Execute via: `Host → Run Script... → PutSalarypj.mac.txt`

### 3️⃣ JCL de Compilação

```jcl
//HERC01XX JOB (COBOL),
//             '',
//             CLASS=C,
//             MSGCLASS=X,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1),NOTIFY=HERC01
//SALARYPJ EXEC COBUCL,
//             PARM.COB='FLAGW,LOAD,SUPMAP,SIZE=2048K,BUF=1024K'
//COB.SYSPUNCH DD DUMMY
//COB.SYSIN    DD DSNAME=HERC01.COBOL(SALARYPJ),DISP=SHR
//COB.SYSLIB   DD DSNAME=HERC01.LOAD,DISP=SHR
//LKED.SYSLMOD DD DSNAME=HERC01.LOAD(SALARYPJ),DISP=SHR
//LKED.SYSIN   DD DUMMY
```

Compile com:
```
SUB
```

### 4️⃣ Executar o programa (modo interativo)

No TSO Command Processor:

```
ALLOC F(SYSPRINT) DA(*)
ALLOC F(SYSIN) DA(*)
ALLOC F(SYSOUT) DA(*)
CALL 'HERC01.LOAD(SALARYPJ)'
```

### 5️⃣ Executar via JCL (modo batch)

```jcl
//HERC01XX JOB (COBOL),'EXEC SALARYPJ',CLASS=A,
//             MSGCLASS=H,MSGLEVEL=(1,1),NOTIFY=HERC01
//*
//* EXECUTA PROGRAMA COBOL SALARYPJ
//*
//STEP01   EXEC PGM=SALARYPJ
//STEPLIB  DD DSN=HERC01.LOAD,
//            DISP=SHR
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
1
MARIA SOUZA
2500
4
2
/*
```
Compile com:
```
SUB
```
---

## 📊 Tabela de Cálculo

Com salário base de **R$ 2.500,00**:

| Tempo de Empresa | Bônus % | Valor do Bônus | Salário Final |
|:---:|:---:|:---:|:---:|
| Até 1 ano | 5% | R$ 125,00 | **R$ 2.625,00** |
| 2 a 5 anos | 10% | R$ 250,00 | **R$ 2.750,00** |
| Mais de 5 anos | 15% | R$ 375,00 | **R$ 2.875,00** |

---

## 🎓 Aprendizados

Durante o desenvolvimento deste projeto, foram aplicados conceitos de:

- 📌 Edição de arquivos no editor **RFE** do mainframe
- 📌 Transferência de arquivos PC ↔ Mainframe usando **IND$FILE**
- 📌 Criação de scripts `.mac` para automatizar transferências
- 📌 Compilação de programas COBOL usando **JCL** com procedimento `COBUCL`
- 📌 Alocação dinâmica de DDs (`SYSIN/SYSOUT/SYSPRINT`) no TSO
- 📌 Uso de `ACCEPT/DISPLAY` para criar menus interativos
- 📌 Conversão de strings para números usando `REDEFINES` e `OCCURS`
- 📌 Formatação de valores monetários com `PIC` editado e `SPECIAL-NAMES`
- 📌 Diagnóstico e correção de erros de sintaxe COBOL ANS 1974

---

## 🛠️ Desafios Superados

- ✔️ Conflito de operadores `>=` e `<=` não suportados em COBOL 1974
- ✔️ Sintaxe `EVALUATE` substituída por `IF` aninhados
- ✔️ Configuração correta de SYSIN/SYSOUT para programas interativos
- ✔️ Conversão de valores com `DECIMAL-POINT IS COMMA` para padrão brasileiro
- ✔️ Tratamento de entrada flexível com `REDEFINES` e validação caractere-a-caractere

---

## 👤 Autor

**Osiel Junior**
🚀 Acelera Maker Montreal

---

## 📝 Licença

Este projeto foi desenvolvido para fins educacionais como parte do programa **Acelera Maker Montreal**.

---

⭐ Se este projeto te ajudou, deixe uma estrela!
