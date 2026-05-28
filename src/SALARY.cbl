      *================================================================*
      * PROGRAM:     SALARY                                           *
      * DESCRIPTION: FINAL SALARY CALCULATOR WITH BONUS              *
      * AUTHOR:      HERC01                                          *
      * PROJECT:     PROJECT 3 - ACELERA MAKER MONTREAL - WEEK 5     *
      * DATE:        2026-05-26                                       *
      *================================================================*
      * BONUS RULES:                                                  *
      *   UP TO 1 YEAR      =>  5%                                    *
      *   FROM 2 TO 5 YEARS => 10%                                    *
      *   ABOVE 5 YEARS     => 15%                                    *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SALARY.
       AUTHOR. HERC01.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *----------------------------------------------------------------*
      * INPUT VARIABLES                                                *
      *----------------------------------------------------------------*
           01 WS-NAME            PIC X(30) VALUE SPACES.
           01 WS-BASE-SALARY     PIC 9(7)V99 VALUE ZEROS.
           01 WS-YEARS           PIC 9(2)    VALUE ZEROS.
      *----------------------------------------------------------------*
      * CALCULATION VARIABLES                                          *
      *----------------------------------------------------------------*
           01 WS-BONUS           PIC 9(7)V99 VALUE ZEROS.
           01 WS-BONUS-PCT       PIC 9(3)V99 VALUE ZEROS.
           01 WS-FINAL-SALARY    PIC 9(7)V99 VALUE ZEROS.
      *----------------------------------------------------------------*
      * CONTROL VARIABLES                                              *
      *----------------------------------------------------------------*
           01 WS-MENU-OPT        PIC 9(1)    VALUE ZEROS.
      *
      *================================================================*
       PROCEDURE DIVISION.
      *================================================================*
       MAIN-PROCEDURE.
           PERFORM SHOW-MENU
           PERFORM UNTIL WS-MENU-OPT = 2
               EVALUATE WS-MENU-OPT
                   WHEN 1
                       PERFORM VALIDA-DADOS
                       PERFORM CALCULA-BONUS
                       PERFORM CALCULA-SALARY
                       PERFORM EXIBE-RESULT
                   WHEN OTHER
                       DISPLAY 'INVALID OPTION. TRY AGAIN.'
               END-EVALUATE
               PERFORM SHOW-MENU
           END-PERFORM
           DISPLAY '=========================='
           DISPLAY '   PROGRAM TERMINATED.    '
           DISPLAY '=========================='
           STOP RUN.
      *
      *----------------------------------------------------------------*
      * SHOW-MENU: DISPLAYS THE MAIN MENU                             *
      *----------------------------------------------------------------*
       SHOW-MENU.
           DISPLAY ' '
           DISPLAY '========================================='
           DISPLAY '     SALARY CALCULATOR - PROJETO 3      '
           DISPLAY '========================================='
           DISPLAY '  1 - CALCULATE SALARY'
           DISPLAY '  2 - EXIT'
           DISPLAY '========================================='
           DISPLAY 'CHOOSE AN OPTION: '
           ACCEPT WS-MENU-OPT.
      *
      *----------------------------------------------------------------*
      * VALIDA-DADOS: READS AND VALIDATES INPUT DATA                  *
      *----------------------------------------------------------------*
       VALIDA-DADOS.
           DISPLAY '-----------------------------------------'
           DISPLAY ' ENTER EMPLOYEE DATA'
           DISPLAY '-----------------------------------------'
           DISPLAY 'EMPLOYEE NAME: '
           ACCEPT WS-NAME
           DISPLAY 'BASE SALARY (EX: 3500.00): '
           ACCEPT WS-BASE-SALARY
           PERFORM UNTIL WS-BASE-SALARY > ZEROS
               DISPLAY 'ERROR: SALARY MUST BE GREATER THAN 0.'
               DISPLAY 'BASE SALARY: '
               ACCEPT WS-BASE-SALARY
           END-PERFORM
           DISPLAY 'YEARS IN COMPANY: '
           ACCEPT WS-YEARS.
      *
      *----------------------------------------------------------------*
      * CALCULA-BONUS: CALCULATES BONUS BASED ON YEARS                *
      *----------------------------------------------------------------*
       CALCULA-BONUS.
           EVALUATE TRUE
               WHEN WS-YEARS <= 1
                   MOVE 5.00  TO WS-BONUS-PCT
               WHEN WS-YEARS <= 5
                   MOVE 10.00 TO WS-BONUS-PCT
               WHEN OTHER
                   MOVE 15.00 TO WS-BONUS-PCT
           END-EVALUATE
           COMPUTE WS-BONUS =
               WS-BASE-SALARY * (WS-BONUS-PCT / 100).
      *
      *----------------------------------------------------------------*
      * CALCULA-SALARY: CALCULATES THE FINAL SALARY                   *
      *----------------------------------------------------------------*
       CALCULA-SALARY.
           COMPUTE WS-FINAL-SALARY =
               WS-BASE-SALARY + WS-BONUS.
      *
      *----------------------------------------------------------------*
      * EXIBE-RESULT: DISPLAYS THE CALCULATION RESULT                 *
      *----------------------------------------------------------------*
       EXIBE-RESULT.
           DISPLAY ' '
           DISPLAY '========================================='
           DISPLAY '            SALARY SUMMARY              '
           DISPLAY '========================================='
           DISPLAY 'EMPLOYEE    : ' WS-NAME
           DISPLAY 'BASE SALARY : ' WS-BASE-SALARY
           DISPLAY 'BONUS (%)   : ' WS-BONUS-PCT
           DISPLAY 'BONUS VALUE : ' WS-BONUS
           DISPLAY 'FINAL SALARY: ' WS-FINAL-SALARY
           DISPLAY '========================================='.
