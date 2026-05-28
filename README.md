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

![Demo do Menu](docs/demo-menu.gif)

> *Programa rodando no mainframe TK5 com interação via TSO*

---

## 📸 Screenshots

### 🛠️ JCL de Compilação

![JCL Compilação](docs/jcl-compilacao.png)

> *JCL usando procedimento **COBUCL** para compilar e linkeditar o programa SALARYPJ*

### ▶️ JCL de Execução

![JCL Execução](docs/jcl-execucao.png)

> *JCL que executa o programa SALARYPJ passando os dados via SYSIN*

### 📊 Resultado da Execução

![Resultado](docs/resultado-execucao.png)

> *Saída do programa exibindo o resumo do cálculo de salário com bônus aplicado*

---

## 🏗️ Arquitetura

```
cobol-salary-calculator/
├── docs/
│   ├── demo-menu.gif           # Demonstração em vídeo
│   ├── jcl-compilacao.png      # Screenshot do JCL de compilação
│   ├── jcl-execucao.png        # Screenshot do JCL de execução
│   └── resultado-execucao.png  # Screenshot do resultado
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

Execute via: `Macros → Run Macro → PutSalarypj.mac.txt`

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