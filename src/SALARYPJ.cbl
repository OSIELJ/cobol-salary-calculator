      *----------------------------------------------------------------*
      * PROJETO 3:   SALARIO FINAL - ACELERA MAKER                     *
      * DESCRICAO:   CALCULA SALARIO COM BONUS E MENU INTERATIVO       *
      *----------------------------------------------------------------*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SALARYPJ.
       AUTHOR. HERC01.
      *
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *-- VARIAVEIS DE ENTRADA
           01 WS-NOME            PIC X(30)   VALUE SPACES.
           01 WS-SALARIO-BASE    PIC 9(7)V99 VALUE ZEROS.
           01 WS-TEMPO-EMP       PIC 9(2)    VALUE ZEROS.
      *-- VARIAVEIS DE CALCULO E CONTROLE
           01 WS-BONUS-VALOR     PIC 9(7)V99 VALUE ZEROS.
           01 WS-BONUS-PCT       PIC 9(3)V99 VALUE ZEROS.
           01 WS-SALARIO-FINAL   PIC 9(7)V99 VALUE ZEROS.
           01 WS-OPCAO           PIC 9(1)    VALUE ZEROS.
      *-- VARIAVEIS AUXILIARES DE CONVERSAO
           01 WS-IN-SALARIO      PIC X(10)   VALUE SPACES.
           01 WS-SAL-TAB REDEFINES WS-IN-SALARIO.
               05 WS-SAL-DIG     PIC X OCCURS 10 TIMES.
           01 WS-IN-TEMPO        PIC X(2)    VALUE SPACES.
           01 WS-TEM-TAB REDEFINES WS-IN-TEMPO.
               05 WS-TEM-DIG     PIC X OCCURS 2 TIMES.
           01 WS-IDX             PIC 9(2)    VALUE ZEROS.
           01 WS-DIGITO          PIC 9       VALUE ZEROS.
           01 WS-NUM-TEMP        PIC 9(9)    VALUE ZEROS.
           01 WS-CHAR            PIC X       VALUE SPACES.
      *-- VARIAVEIS DE EXIBICAO
           01 WS-DISP-SAL-BASE   PIC ZZZ.ZZZ.ZZ9,99.
           01 WS-DISP-BONUS      PIC ZZZ.ZZZ.ZZ9,99.
           01 WS-DISP-SAL-FINAL  PIC ZZZ.ZZZ.ZZ9,99.
           01 WS-DISP-PCT        PIC ZZ9,99.
      *
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM MOSTRA-MENU.
           PERFORM PROCESSA-OPCAO UNTIL WS-OPCAO = 2.
           DISPLAY ' '.
           DISPLAY '========================================='.
           DISPLAY '   PROGRAMA ENCERRADO. ATE LOGO!         '.
           DISPLAY '========================================='.
           STOP RUN.
      *
       MOSTRA-MENU.
           DISPLAY ' '.
           DISPLAY '========================================='.
           DISPLAY '    CALCULADORA DE SALARIO - PROJETO 3   '.
           DISPLAY '========================================='.
           DISPLAY '  1 - CALCULAR'.
           DISPLAY '  2 - SAIR'.
           DISPLAY '========================================='.
           DISPLAY 'ESCOLHA UMA OPCAO: '.
           ACCEPT WS-OPCAO.
      *
       PROCESSA-OPCAO.
           IF WS-OPCAO = 1
               PERFORM ENTRADA-DADOS
               PERFORM CALCULA-BONUS
               PERFORM CALCULA-SALARIO
               PERFORM EXIBE-RESULTADO.
           IF WS-OPCAO NOT = 1 AND WS-OPCAO NOT = 2
               DISPLAY '*** OPCAO INVALIDA. TENTE NOVAMENTE. ***'.
           IF WS-OPCAO NOT = 2
               PERFORM MOSTRA-MENU.
      *
       ENTRADA-DADOS.
           MOVE SPACES TO WS-NOME.
           MOVE ZEROS  TO WS-SALARIO-BASE.
           MOVE ZEROS  TO WS-TEMPO-EMP.
           MOVE SPACES TO WS-IN-SALARIO.
           MOVE SPACES TO WS-IN-TEMPO.
           DISPLAY '-----------------------------------------'.
           DISPLAY ' NOME DO FUNCIONARIO: '.
           ACCEPT WS-NOME.
           DISPLAY ' SALARIO BASE (EX: 2500): '.
           ACCEPT WS-IN-SALARIO.
           PERFORM CONVERTE-SALARIO.
           DISPLAY ' TEMPO DE EMPRESA (ANOS): '.
           ACCEPT WS-IN-TEMPO.
           PERFORM CONVERTE-TEMPO.
      *
       CONVERTE-SALARIO.
           MOVE ZEROS TO WS-NUM-TEMP.
           PERFORM LE-DIGITO-SAL VARYING WS-IDX FROM 1 BY 1
                                 UNTIL WS-IDX > 10.
           COMPUTE WS-SALARIO-BASE = WS-NUM-TEMP.
      *
       LE-DIGITO-SAL.
           MOVE WS-SAL-DIG(WS-IDX) TO WS-CHAR.
           IF WS-CHAR NOT < '0' AND WS-CHAR NOT > '9'
               MOVE WS-CHAR TO WS-DIGITO
               COMPUTE WS-NUM-TEMP = (WS-NUM-TEMP * 10) + WS-DIGITO.
      *
       CONVERTE-TEMPO.
           MOVE ZEROS TO WS-NUM-TEMP.
           PERFORM LE-DIGITO-TEMPO VARYING WS-IDX FROM 1 BY 1
                                   UNTIL WS-IDX > 2.
           MOVE WS-NUM-TEMP TO WS-TEMPO-EMP.
      *
       LE-DIGITO-TEMPO.
           MOVE WS-TEM-DIG(WS-IDX) TO WS-CHAR.
           IF WS-CHAR NOT < '0' AND WS-CHAR NOT > '9'
               MOVE WS-CHAR TO WS-DIGITO
               COMPUTE WS-NUM-TEMP = (WS-NUM-TEMP * 10) + WS-DIGITO.
      *
       CALCULA-BONUS.
           IF WS-TEMPO-EMP NOT > 1
               MOVE 5,00 TO WS-BONUS-PCT.
           IF WS-TEMPO-EMP > 1 AND WS-TEMPO-EMP NOT > 5
               MOVE 10,00 TO WS-BONUS-PCT.
           IF WS-TEMPO-EMP > 5
               MOVE 15,00 TO WS-BONUS-PCT.
           COMPUTE WS-BONUS-VALOR ROUNDED =
               WS-SALARIO-BASE * (WS-BONUS-PCT / 100).
      *
       CALCULA-SALARIO.
           COMPUTE WS-SALARIO-FINAL =
               WS-SALARIO-BASE + WS-BONUS-VALOR.
      *
       EXIBE-RESULTADO.
           MOVE WS-SALARIO-BASE  TO WS-DISP-SAL-BASE.
           MOVE WS-BONUS-VALOR   TO WS-DISP-BONUS.
           MOVE WS-SALARIO-FINAL TO WS-DISP-SAL-FINAL.
           MOVE WS-BONUS-PCT     TO WS-DISP-PCT.
           DISPLAY ' '.
           DISPLAY '========================================='.
           DISPLAY '           RESUMO DO SALARIO             '.
           DISPLAY '========================================='.
           DISPLAY ' NOME         : ' WS-NOME.
           DISPLAY ' SALARIO BASE : ' WS-DISP-SAL-BASE.
           DISPLAY ' BONUS APLIC. : ' WS-DISP-PCT '%'.
           DISPLAY ' VALOR BONUS  : ' WS-DISP-BONUS.
           DISPLAY ' SALARIO FINAL: ' WS-DISP-SAL-FINAL.
           DISPLAY '========================================='.
