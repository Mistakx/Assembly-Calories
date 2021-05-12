; Projecto 2 Arquitetura de Computadores - Balança com calculadora de Macros

; Endereçamento do Programa
; Pula para o bloco de instruções ->    0 ou 0x0000
; Periféricos                     ->   32 -  255 ou 0x0020 - 0x00FF
; Bloco de instruções             ->  256 - 1023 ou 0x0100 - 0x03FF
; Menus                           -> 2048 - 4095 ou 0x0800 - 0x0FFF
; Tabela de alimentos             -> 4096 - 8191 ou 0x1000 - 0x1FFF

; _____________________________________________________________________________________________________________

; Periféricos de Input
; É tomada a escolha que os periféricos são todos de palavra, por razões de "Future Proofing"                                                                                            

B_ON_OFF         EQU 0020H                ; Endereço botão on/off                                          
SEL_NR_MENU      EQU 0022H                ; Endereço botão para selecionar a opção nos menus
B_OK             EQU 0024H                ; Endereço botão validar escolha
B_CHANGE         EQU 0026H                ; Endereço botão change                                                               
PESO             EQU 0028H                ; Endereço do periférico peso


; _____________________________________________________________________________________________________________

; Display
; O display tem dimensões 7x16 (7 linhas de 16 bytes)
; 7x16 = 112         
; 112 = 0x70                                                                                    

DisplayBeginning EQU 0080H                ; Endereço onde começa o display
;DisplayEnd       EQU 009FH                ; Endereço onde acaba o display. 0x0080 + 0x006F = 0x00EF
DisplayEnd       EQU 00EFH                ; Endereço onde acaba o display. 0x0080 + 0x006F = 0x00EF

; _____________________________________________________________________________________________________________

; Stack Pointer

StackPointer     EQU 1FFEH                ; Endereço do Stack Pointer

; _____________________________________________________________________________________________________________

; Tabela de Alimentos

PLACE 1000H

TableAveia:
  STRING          "00- AVEIA       "
  STRING          "011  056  007  -"

TablePaoForma:
  STRING          "01- PAO DE FORMA"
  STRING          "009  042  003  -"

TableBatata:
  STRING          "02- BATATA      "
  STRING          "003  019  000  -"

TableArroz:
  STRING          "03- ARROZ       "
  STRING          "007  025  000  -"
  
TableFeijao:
  STRING          "04- FEIJAO      "
  STRING          "010  013  000  -"

TableLegumes:
  STRING          "05- LEGUMES     "
  STRING          "003  007  000  -"

TableTomate:
  STRING          "06- TOMATE      "
  STRING          "001  003  000  -"

TableBanana:
  STRING          "07- BANANA      "
  STRING          "001  023  000  -"

TableLaranja:
  STRING          "08- LARANJA     "
  STRING          "001  012  000  -"

TableMaca:
  STRING          "09- MACA        "
  STRING          "001  014  000  -"

TableKiwi:
  STRING          "10- KIWI        "
  STRING          "001  015  000  -"

TableBolachaChoc:
  STRING          "11- BOLACHA CHOC"
  STRING          "009  059  022  -"

TablePizza:
  STRING          "12- PIZZA       "
  STRING          "013  025  009  -"

TableAmendoas:
  STRING          "13- AMENDOAS    "
  STRING          "025  006  055  -"

TableLinhacas:
  STRING          "14- LINHACAS    "
  STRING          "018  034  036  -"

TableAzeite:
  STRING          "15- AZEITE      "
  STRING          "000  000  100  -"

TableLMagro:
  STRING          "16- LEITE MAGRO "
  STRING          "003  004  000  -"

TableWhey:
  STRING          "17- WHEY        "
  STRING          "080  008  004  -"

TableSalmao:
  STRING          "18- SALMAO      "
  STRING          "021  000  015  -"

TablePescada:
  STRING          "19- PESCADA     "
  STRING          "020  000  001  -"

TableAtum:
  STRING          "20- ATUM        "
  STRING          "025  000  002  -"

TablePorco:
  STRING          "21- PORCO       "
  STRING          "022  000  015  -"

TableFrango:
  STRING          "22- FRANGO      "
  STRING          "025  000  004  -"

TablePeru:
  STRING          "23- PERU        "
  STRING          "028  000  001  -"

TableOvo:
  STRING          "24- OVO         "
  STRING          "007  000  005  -"

TableQueijo:
  STRING          "25- QUEIJO      "
  STRING          "028  000  013  -"

; Menus

PLACE 0800H
MenuMain:
  STRING          "  MENU INICIAL  "
  STRING          "                "
  STRING          "1. BALANCA      "
  STRING          "2. TOTAL DIARIO "
  STRING          "3. RESET        "
  STRING          "                "
  STRING          "                "

;PLACE 0850H
MenuScale:
  STRING          "      PESO      "
  STRING          "                "
  STRING          "1. CHANGE       "
  STRING          "                "
  STRING          "                "
  STRING          "                "
  STRING          "                "

;PLACE 08D0H
MenuWeightOverflow:
  STRING          "      ERRO      "
  STRING          "                "
  STRING          "    OVERFLOW    "
  STRING          "   EXCESSO DE   "
  STRING          "      PESO      "
  STRING          "                "
  STRING          "                "

;PLACE 0950H
MenuError:
  STRING          "      ERRO      "
  STRING          "                "
  STRING          "     OPCAO      "
  STRING          "    INVALIDA    "
  STRING          "                "
  STRING          "                "
  STRING          "                "

;PLACE 09D0H
MenuDailyTotal:
  STRING          "  TOTAL DO DIA  "
  STRING          "P:  G           "
  STRING          "C:  G           "
  STRING          "F:  G           "
  STRING          "                "
  STRING          "1.META DIARIA   "
  STRING          "                "

; _____________________________________________________________________________________________________________

; Instruções


PLACE 0000H
JMP Startup


PLACE 0100H


DisplayResetCall: ; (Display Beginning, DisplayEnd + 1)
  
  CaraterVazio    EQU 0020H               ; Carater vazio usado para limpar o ecrã

  MOV             R3, CaraterVazio        ; Guardar em R3 o carater vazio
  MOV             [R0], R3                ; Guardar no display o valor escrito em R3
  ADD             R2, 2                   ; Pula para a próxima palavra do menu 
  ADD             R0, 2                   ; Pula para a próxima palavra do display

  ; Se ainda não chegou ao fim do display, começar a call de novo
  CMP             R0, R1
  JNE             DisplayResetCall

  ; Se chegou ao fim do display, retornar
  RET

PeriphericsResetCall:

  ; Guardar os dados dos registos já existentes na stack
  ; PUSH      R0
  ; PUSH      R1
  ; PUSH      R2
  ; PUSH      R3
  ; PUSH      R4

  ; Mover os endereços dos vários periféricos para os registos
  MOV             R0, B_ON_OFF            ; Guardar Endereço botão on/off                                                                     
  MOV             R1, SEL_NR_MENU         ; Guardar Endereço botão para selecionar a opção nos menus                                        
  MOV             R2, B_OK                ; Guardar Endereço botão validar escolha                                                           
  MOV             R3, B_CHANGE            ; Guardar Endereço botão change                                                                     
  MOV             R4, PESO                ; Guardar Endereço do periférico peso   
  MOV             R5, 0                   ; Guardar valor a usar nos vários resets dos periféricos

  ; Mover 0 para todos os periféricos, fazendo o seu reset
  MOVB            [R0], R5
  MOVB            [R1], R5
  MOVB            [R2], R5
  MOVB            [R3], R5
  MOVB            [R4], R5

  ; Reaver os dados dos registos que foram guardados na stack 
  ; POP       R0
  ; POP       R1
  ; POP       R2
  ; POP       R3
  ; POP       R4

  ; Returnar da sub-rotina
  RET

Startup:
  MOV             SP, StackPointer        ; Guardar o endereço do Stack Pointer no registo SP

  ; Preparar o display para ser limpo
  MOV             R0, DisplayBeginning    ; Guardar em R0 o endereço do inicio do display
  MOV             R1, DisplayEnd          ; Guardar em R1 o endereço do final do display
  ADD             R1, 1                   ; Adicionar 1 ao display end, quando o iterador do display chegar a este valor a rotina vai ser indicada a parar
  ;CALL            DisplayResetCall        ; Chamar a rotina que limpa o display

  ;CALL      PeriphericsResetCall    ; Chamar a rotina que limpa os periféricos
  CALL            MainCall                ; Chama a rotina principal do programa, que gere o estado da máquina

  MOV             R0, 2000H               ; Guarda o primeiro endereço fora da memória
  JMP             R0                      ; Salta para fora da memória, efetivamente acabando o programa
; TODO: Enable DisplayResetCall, PeriphericsResetCall

CheckTurnOnCall:

  MOV             R1, [R0]                ; Escrever o valor de B_ON_OFF em R1
  CMP             R1, 1                   ; Comparar se o B_ON_OFF está igual a 1 (ligado)
  JNE             CheckTurnOnCall         ; Se B_ON_OFF estiver desligado, volta a comparar até passar a ligado
  RET

MainCall:

  MOV             R0, B_ON_OFF            ; Guardar o endereço de B_ON_OFF em R0
  Call            CheckTurnOnCall         ; Verifica continuamente se o butão de ligar foi pressionado
  Call            MainMenuCall            ; Executa a call MainMenu após o butão de ligar ser pressionado
  RET

DisplayMenuCall: ; (Display Beginning, DisplayEnd + 1, MenuToDisplay)
  MOV             R3, [R2]                ; Guardar em R3 uma palavra do menu a imprimir no display
  MOV             [R0], R3                ; Guardar no display o valor escrito em R3
  ADD             R2, 2                   ; Pula para a próxima palavra do menu 
  ADD             R0, 2                   ; Pula para a próxima palavra do display

  ; Se ainda não chegou ao fim do display, começar a call de novo
  CMP             R0, R1
  JNE             DisplayMenuCall

  ; Se chegou ao fim do display, retornar
  RET
    
MainMenuCall:

  ; Preparar Display
  MOV             R0, DisplayBeginning    ; Guardar em R0 o endereço do inicio do display
  MOV             R1, DisplayEnd          ; Guardar em R1 o endereço do final do display
  ADD             R1, 1                   ; Adicionar 1 ao display end, quando o iterador do display chegar a este valor a rotina vai ser indicada a parar

  ; Mostrar Main Menu no Display
  MOV             R2, MenuMain            ; Guardar em R2 o endereço do menu principal
  CALL            DisplayMenuCall

  ; Verificar input do utilizador
  MOV             R0, SEL_NR_MENU
  MOV             R1, B_OK

  ; Verificar se o utilizador confirmou a sua escolha
  CMP B_OK, 1
  JNE MainMenuCall ; Se o utilizador não clicou confirmar a escolha ainda, voltar a verificar
  
  ; Se o utilizador confirmou a escolha

  CMP SEL_NR_MENU, 1
  JNE 2
  CALL ScaleMenu

  CMP SEL_NR_MENU, 2

  CMP SEL_NR_MENU, 3


