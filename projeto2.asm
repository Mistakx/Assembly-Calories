; Projecto 2 Arquitetura de Computadores - Balança com calculadora de Macros
; Endereçamento -> 0 - 8191 corresponde à memória 
; Instruções -> 0 a 1599 e 4000 a 4999
;   Dados-> 2000 a 3999 e 6000 a 7399
;Endereçamento -> 32768 - 32967 corresponde a periféricos. O resto é espaço livre 
;_________________________________________________________________________________________________________________________________________________
;               INPUTS                                                                                                 
SEL_NR_MENU     EQU 8001H;  Endereço botão para selecionar a opção nos menus                                        
B_ON_OFF        EQU 8002H;  Endereço botão on/off                                                                     
B_OK            EQU 8003H;  Endereço botão validar escolha                                                           
B_CHANGE        EQU 8004H;  Endereço botão change                                                                     
PESO            EQU 8005H;  Endereço do periférico peso                                                               
;                                                                                                                     
; Endereçamento byte a byte pois K é no máximo 1byte nos primeiros 4 casos. No que se trata do peso este não é representável em 1 byte (1-2500)g                                                                                                                    
;_________________________________________________________________________________________________________________________________________________
;               DISPLAY                                                                                               

DisplayInicio   EQU 0090H;  Endereço onde começa o display 
DisplayFim      EQU 00FFH;  Endereço onde acaba o display

;_________________________________________________________________________________________________________________________________________________
;               CONSTANTES
CaraterVazio    EQU 20H;    Endereço do carater vazio usado para limpar o ecrã


;_________________________________________________________________________________________________________________________________________________
;               STACKPOINTER

StackPointer    EQU 6000H;  Endereço relativo ao stackpointer(pilha)

;_________________________________________________________________________________________________________________________________________________
;               MENUS

PLACE 07D0H
Menu_Principal:             ; Display Main menu
STRING "  MENU INICIAL  "
STRING "                "   ; 0.ON/OFF maybe idk.. 
STRING "1. BALANÇA      "
STRING "2. TOTAL DIARIO "
STRING "3. RESET        "
STRING "                "
STRING "                "

PLACE 0850H
Menu_Balança:               ; Display Menu balança
STRING "  BALANÇA       "
STRING "                "
STRING "PESO            "
STRING "1. CHANGE       "
STRING "                "
STRING "                "
STRING "                "

PLACE 08D0H
Menu_Overflow:              ; Display caso o peso ultrapasse 2500g
STRING "     ERRO       "
STRING "    OVERFLOW    "
STRING "  O VALOR NAO   "
STRING "    GUARDADO    "
STRING "                "
STRING "                "
STRING "                "

PLACE 0950H                 ; Display rotina ERRO
Menu_ERRO:
STRING "      ERRO      "
STRING "                "
STRING "      OPÇÃO     "
STRING "    INVALIDA    "
STRING "                "
STRING "                "
STRING "                "

PLACE 09D0H
Total_Dia:                  ; Display Total dia
STRING "  TOTAL DO DIA  "
STRING "P:  G           "
STRING "C:  G           "
STRING "F:  G           "
STRING "                "
STRING "1.META DIÁRIA   "
STRING "                "

;_________________________________________________________________________________________________________________________________________________
;               Instruções
;R2 será usado de modo a ir buscar os endereços dos displays
;R0 os periféricos

PLACE 0000H 
Inicio: 
    MOV R0,Começar          ; Guarda em R0 o endereço para começar parao menu principal
    JMP R0                  ; Salta para R0, ou seja para a etiqueta Começar

PLACE 0050H
Começar:
    MOV SP,StackPointer     ; Guarda o endereço da stack em SP
    CALL LimparDisplay      ; Chama a rotina que limpa o display
    CALL LimparPerifericos  ; Chama a rotina que limpa os periféricos
    MOV R0, B_ON_OFF        ; Guardar o endereço de B_ON_OFF em R0
LIGAR:
    MOVB R1, [R0]           ; Escrita de do valor apontado por R0 em R1
    CMP R1, 1               ; Comparar se o valor do registo R1 está igual a 1
    JNE Começar             ; Caso não seja igual a 1 salta para Começar
Ligado:
    MOV R2, Menu_Principal  ; Guardar em R2 o endereço do menu Principal
    CALL MostraDisplay      ; Chamada da rotina MostraDisplay
    CALL LimparPerifericos
;_________________________________________________________________________________________________________________________________________________
;  
             ROTINAS
MostraDisplay:
    MOV R0, DisplayInicio   ; Guardar em R0 o endereço do inicio do display
    MOV R1, DisplayFim      ; Guardar em R1 o endereço do final do display 
CicloDisplay:
    MOV R3, [R2]            ; Guardar em R3 o valor da string em R2
    MOV [R0], R3            ; Escrever em R0 o valor escrito em R3
    ADD R2,2                ;
    ADD R0,2                ;   
;Implementar a rotina ERRO!
