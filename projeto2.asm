; Projecto 2 Arquitetura de Computadores - Balança com calculadora de Macros
; Note - It's not peripherics, it's peripherals.
; Note - Instrução 192 parece que nao executa.

; Endereçamento do Programa
; Pula para o bloco de instruções ->    0 ou 0x0000
; Periféricos                     ->   32 -  255 ou 0x0020 - 0x00FF
; Bloco de instruções             ->  256 - 1023 ou 0x0100 - 0x03FF
; Menus                           -> 2048 - 4095 ou 0x0800 - 0x0FFF
; Tabela de alimentos             -> 4096 - 8191 ou 0x1000 - 0x1FFF

; _____________________________________________________________________________________________________________

; Periféricos de Input
; É tomada a escolha que os periféricos são todos de palavra, por razões de "Future Proofing"                                                                                            

B_ON_OFF         EQU 0020H                                            ; Endereço botão on/off                                          
SEL_NR_MENU      EQU 0022H                                            ; Endereço botão para selecionar a opção nos menus
B_OK             EQU 0024H                                            ; Endereço botão validar escolha
B_CHANGE         EQU 0026H                                            ; Endereço botão change                                                               
PESO             EQU 0028H                                            ; Endereço do periférico peso

; _____________________________________________________________________________________________________________

; Display
; O display tem dimensões 7x16 (7 linhas de 16 bytes)
; 7x16 = 112         
; 112 = 0x70                                                                                    

DisplayBeginning EQU 0080H                                            ; Endereço onde começa o display
DisplayEnd       EQU 00EFH                                            ; Endereço onde acaba o display. 0x0080 + 0x006F = 0x00EF

; _____________________________________________________________________________________________________________

; Stack Pointer

StackPointer     EQU 1FFEH                                            ; Endereço do Stack Pointer

; _____________________________________________________________________________________________________________

; Tabela de Alimentos

PLACE 1000H

  TableAveia                        :
  STRING                            "00- AVEIA       "
  STRING                            "011  056  007  -"

  TablePaoForma                     :
  STRING                            "01- PAO DE FORMA"
  STRING                            "009  042  003  -"

  TableBatata                       :
  STRING                            "02- BATATA      "
  STRING                            "003  019  000  -"

  TableArroz                        :
  STRING                            "03- ARROZ       "
  STRING                            "007  025  000  -"
    
  TableFeijao                       :
  STRING                            "04- FEIJAO      "
  STRING                            "010  013  000  -"

  TableLegumes                      :
  STRING                            "05- LEGUMES     "
  STRING                            "003  007  000  -"

  TableTomate                       :
  STRING                            "06- TOMATE      "
  STRING                            "001  003  000  -"

  TableBanana                       :
  STRING                            "07- BANANA      "
  STRING                            "001  023  000  -"

  TableLaranja                      :
  STRING                            "08- LARANJA     "
  STRING                            "001  012  000  -"

  TableMaca                         :
  STRING                            "09- MACA        "
  STRING                            "001  014  000  -"

  TableKiwi                         :
  STRING                            "10- KIWI        "
  STRING                            "001  015  000  -"

  TableBolachaChoc                  :
  STRING                            "11- BOLACHA CHOC"
  STRING                            "009  059  022  -"

  TablePizza                        :
  STRING                            "12- PIZZA       "
  STRING                            "013  025  009  -"

  TableAmendoas                     :
  STRING                            "13- AMENDOAS    "
  STRING                            "025  006  055  -"

  TableLinhacas                     :
  STRING                            "14- LINHACAS    "
  STRING                            "018  034  036  -"

  TableAzeite                       :
  STRING                            "15- AZEITE      "
  STRING                            "000  000  100  -"

  TableLMagro                       :
  STRING                            "16- LEITE MAGRO "
  STRING                            "003  004  000  -"

  TableWhey                         :
  STRING                            "17- WHEY        "
  STRING                            "080  008  004  -"

  TableSalmao                       :
  STRING                            "18- SALMAO      "
  STRING                            "021  000  015  -"

  TablePescada                      :
  STRING                            "19- PESCADA     "
  STRING                            "020  000  001  -"

  TableAtum                         :
  STRING                            "20- ATUM        "
  STRING                            "025  000  002  -"

  TablePorco                        :
  STRING                            "21- PORCO       "
  STRING                            "022  000  015  -"

  TableFrango                       :
  STRING                            "22- FRANGO      "
  STRING                            "025  000  004  -"

  TablePeru                         :
  STRING                            "23- PERU        "
  STRING                            "028  000  001  -"

  TableOvo                          :
  STRING                            "24- OVO         "
  STRING                            "007  000  005  -"

  TableQueijo                       :
  STRING                            "25- QUEIJO      "
  STRING                            "028  000  013  -"

; _____________________________________________________________________________________________________________

; Menus

PLACE 0800H

  GUIMenuMain                       :
  STRING                            "  MENU INICIAL  "
  STRING                            "                "
  STRING                            "1. BALANCA      "
  STRING                            "2. TOTAL DIARIO "
  STRING                            "3. RESET        "
  STRING                            "                "
  STRING                            "                "

  GUIMenuScale                      :
  STRING                            "      PESO      "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "

  GUIMenuWeightOverflow             :
  STRING                            "      ERRO      "
  STRING                            "                "
  STRING                            "    OVERFLOW    "
  STRING                            "   EXCESSO DE   "
  STRING                            "      PESO      "
  STRING                            "                "
  STRING                            "                "

  GUIMenuError                      :
  STRING                            "      ERRO      "
  STRING                            "                "
  STRING                            "     OPCAO      "
  STRING                            "    INVALIDA    "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "

  GUIMenuDailyTotal                 :
  STRING                            "  TOTAL DO DIA  "
  STRING                            "P:  G           "
  STRING                            "C:  G           "
  STRING                            "F:  G           "
  STRING                            "                "
  STRING                            "1.META DIARIA   "
  STRING                            "                "

  GUIMenuReset                      :
  STRING                            "  MENU RESET    "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "
  STRING                            "                "

; _____________________________________________________________________________________________________________

; Instruções

PLACE 0000H
  JMP                               Startup


PLACE 0100H

DisplayResetCall: ; (Display Beginning, DisplayEnd + 1)
  
  CaraterVazio                      EQU 2020H                         ; Carater vazio usado para limpar o ecrã
  MOV                               R3, CaraterVazio                  ; Guardar em R3 o carater vazio
  MOV                               [R0], R3                          ; Guardar no display o carater vazio
  ADD                               R2, 2                             ; Pula para a próxima palavra do menu 
  ADD                               R0, 2                             ; Pula para a próxima palavra do display

  ; Se ainda não chegou ao fim do display, começar a call de novo
  CMP                               R0, R1
  JNE                               DisplayResetCall

  ; Se chegou ao fim do display, retornar
  RET

PeriphericsResetCall:

  ; Mover os endereços dos vários periféricos para os registos
  MOV                               R0, B_ON_OFF                      ; Guardar Endereço botão on/off                                                                     
  MOV                               R1, SEL_NR_MENU                   ; Guardar Endereço botão para selecionar a opção nos menus                                        
  MOV                               R2, B_OK                          ; Guardar Endereço botão validar escolha                                                           
  MOV                               R3, B_CHANGE                      ; Guardar Endereço botão change                                                                     
  MOV                               R4, PESO                          ; Guardar Endereço do periférico peso   
  MOV                               R5, 0                             ; Guardar valor a usar nos vários resets dos periféricos
  MOV                               R6, 2020H                         ; Guardar valor a usar no reset do peso


  ; Mover 0 para todos os periféricos, e 0 ASCII para o peso, fazendo o seu reset
  MOVB                              [R0], R5
  MOVB                              [R1], R5
  MOVB                              [R2], R5
  MOVB                              [R3], R5
  MOV                               [R4], R6

  ; Returnar da sub-rotina
  RET


PrepareDisplayCall: ; (No Input) (DisplayBeginning, DisplayEnd + 1)
  MOV                               R0, DisplayBeginning              ; Guardar em R0 o endereço do inicio do display
  MOV                               R1, DisplayEnd                    ; Guardar em R1 o endereço do final do display
  ADD                               R1, 1                             ; Adicionar 1 ao display end, quando o iterador do display chegar a este valor a rotina vai ser indicada a parar
  RET

OverwriteDisplayCall: ; ([DisplayBeginning], LineToBeOverwritten, [ContentToOverwrite], BytesAlreadyOverwritten)


  MOV                               R4, 16                            ; Número de bytes que uma linha do display tem                  
  MUL                               R1, R4                            ; Transforma a LineToBeOverwritten no padding que será necessário dar ao [DisplayBeginning]
  ADD                               R0, R1                            ; Muda o [DisplayBeginning] para o ínicio da linha do display onde se quer dar overwrite
  
  OverwriteDisplayPrepared          :
  
  CMP                               R3, R4                            ; Verifica se já foram dados overwrite a 16 bytes, ou seja, à linha inteira
  JNE                               BytesNotAllOverwritten
  
  ; Se já foi dado overwrite a todos os bytes da linha
  RET

  ; Se ainda não foi dado overwrite a todos os bytes da linha
  BytesNotAllOverwritten            :
  MOV R5, [R2] ; Mover valor ContentToOverwrite para R5
  MOV                               [R0], R5                          ; Mover ContentToOverwrite que se quer dar overwrite para o display
  ADD                               R0, 2
  ADD                               R2, 2
  ADD                               R3, 2
  JMP                               OverwriteDisplayPrepared


Startup:
  MOV                               SP, StackPointer                  ; Guardar o endereço do Stack Pointer no registo SP

  CALL                              PrepareDisplayCall                ; Preparar o display para ser limpo
  CALL                              DisplayResetCall                  ; Chamar a rotina que limpa o display
  CALL                              PeriphericsResetCall              ; Chamar a rotina que limpa os periféricos
  CALL                              MainCall                          ; Chama a rotina principal do programa, que gere o estado da máquina

  MOV                               R0, 2000H                         ; Guarda o primeiro endereço fora da memória
  JMP                               R0                                ; Salta para fora da memória, efetivamente acabando o programa

CheckTurnOnCall: 
  MOV                               R0, B_ON_OFF                      ; Guardar o endereço de B_ON_OFF em R0
  MOV                               R1, [R0]                          ; Escrever o valor de B_ON_OFF em R1
  CMP                               R1, 1                             ; Comparar se o B_ON_OFF está igual a 1 (ligado)
  JNE                               CheckTurnOnCall                   ; Se B_ON_OFF estiver desligado, volta a comparar até passar a ligado
  RET

MainCall:

  ; B_ON_OFF
  CALL                              CheckTurnOnCall                   ; Verifica continuamente se o butão de ligar foi pressionado

  ; Display
  CALL                              PrepareDisplayCall                ; Após o butão de ligar ser precionado, preparar display para mostrar o menu principal
  MOV                               R2, GUIMenuMain                   ; Guardar em R2 o endereço do menu principal
  CALL                              DisplayMenuCall

  ; Menu Input
  CALL                              MenuMainCall                      ; Executa a call MainMenu após o butão de ligar ser pressionado

  RET


DisplayMenuCall: ; (Display Beginning, DisplayEnd + 1, MenuToDisplay)
  MOV                               R3, [R2]                          ; Guardar em R3 uma palavra do menu a imprimir no display
  MOV                               [R0], R3                          ; Guardar no display o valor escrito em R3
  ADD                               R2, 2                             ; Pula para a próxima palavra do menu 
  ADD                               R0, 2                             ; Pula para a próxima palavra do display

  ; Se ainda não chegou ao fim do display, começar a call de novo
  CMP                               R0, R1
  JNE                               DisplayMenuCall

  ; Se chegou ao fim do display, retornar
  RET

MenuChangeFoodCall: ; ((), (), (), (), PesoAnterior, AlimentoAtual, TableNumber)
; TODO: After cycling trough all foods, reset back to the first

  ; Display
  CALL                              PrepareDisplayCall                ; Preparar ecrã para mostrar o menu balança
  MOV                               R7, 32                            ; Guarda em R7 o número de carateres da tabela de cada alimento, para ser usado como padding
  MOV                               R8, R4                            ; Guarda cópia do TableNumber em R8
  MUL                               R8, R7                            ; Constrói o padding que será usado para aceder ao endereço correto (Cópia TableNumber * Nº Carateres Alimento)
  NOP                                                                 ; Instrução 192 simplesmente é pulada no simulador
  NOP                                                                 ; Instrução 192 simplesmente é pulada no simulador
  NOP                                                                 ; Instrução 192 simplesmente é pulada no simulador

  
  MOV                               R2, TableAveia                    ; Guarda em R2 o endereço da primeira tabela
  ADD                               R2, R8                            ; Adiciona o padding ao endereço da primeira tabela, obtendo a tabela que se quer aceder
  CALL                              DisplayMenuCall                   ; Mostrar Menu balança no Display

  MenuChangeFoodDisplayReady        :

  ; Verifica se B_CHANGE for pressionado
  MOV                               R0, B_CHANGE
  MOV                               R1, [R0]                          ; Move o valor do B_CHANGE para R1
  CMP                               R1, 1
  JNE                               MenuChangeFoodChangeNotPressed
  
  ; Se o butão B_CHANGE for pressionado

  MOV                               R0, B_CHANGE
  MOV                               R1, 0
  MOV                               [R0], R1                          ; Reset do valor do B_CHANGE
  ADD                               R6, 1                             ; Passa como parâmetro o nº da tabela do alimento seguinte
  JMP                               MenuChangeFoodCall
 


  ; Se o butão B_CHANGE não for pressionado
  MenuChangeFoodChangeNotPressed    :

  MOV                               R2, SEL_NR_MENU
  MOV                               R0, [R2]                          ; Move valor SEL_NR_MENU para R0
  MOV                               R2, B_OK
  MOV                               R1, [R2]                          ; Move valor B_OK para R1
  CMP                               R1, 1
  JNE                               MenuChangeFoodOkNotPressed

  ; Se o butão B_OK foi pressionado

  ChoiceAveia                       :
  CMP                               R0, 0
  JNE                               ChoicePaoForma

  ChoicePaoForma                    :
  CMP                               R0, 1
  JNE                               ChoiceBatata

  ChoiceBatata                      :
  CMP                               R0, 2
  JNE                               ChoiceArroz

  ChoiceArroz                       :
  CMP                               R0, 3
  JNE                               ChoiceFeijao

  ChoiceFeijao                      :
  CMP                               R0, 4
  JNE                               ChoiceLegumes

  ChoiceLegumes                     :
  CMP                               R0, 5
  JNE                               ChoiceTomate

  ChoiceTomate                      :
  CMP                               R0, 6
  JNE                               ChoiceBanana

  ChoiceBanana                      :
  CMP                               R0, 7
  JNE                               ChoiceLaranja

  ChoiceLaranja                     :
  CMP                               R0, 0
  JNE                               ChoiceMaca

  ChoiceMaca                        :
  CMP                               R0, 0
  JNE                               ChoiceKiwi

  ChoiceKiwi                        :
  CMP                               R0, 0
  JNE                               ChoiceBolachaChoc

  ChoiceBolachaChoc                 :
  CMP                               R0, 0
  JNE                               ChoicePizza

  ChoicePizza                       :
  CMP                               R0, 0
  JNE                               ChoiceAmendoas

  ChoiceAmendoas                    :
  CMP                               R0, 0
  JNE                               ChoiceLinhacas

  ChoiceLinhacas                    :
  CMP                               R0, 0
  JNE                               ChoiceAzeite

  ChoiceAzeite                      :
  CMP                               R0, 0
  JNE                               ChoiceLMagro

  ChoiceLMagro                      :
  CMP                               R0, 0
  JNE                               ChoiceWhey

  ChoiceWhey                        :
  CMP                               R0, 0
  JNE                               ChoiceSalmao

  ChoiceSalmao                      :
  CMP                               R0, 0
  JNE                               ChoicePescada

  ChoicePescada                     :
  CMP                               R0, 0
  JNE                               ChoiceAtum

  ChoiceAtum                        :
  CMP                               R0, 0
  JNE                               ChoicePorco

  ChoicePorco                       :
  CMP                               R0, 0
  JNE                               ChoiceFrango

  ChoiceFrango                      :
  CMP                               R0, 0
  JNE                               ChoicePeru

  ChoicePeru                        :
  CMP                               R0, 0
  JNE                               ChoiceOvo

  ChoiceOvo                         :
  CMP                               R0, 0
  JNE                               ChoiceQueijo

  ChoiceQueijo                      :
  CMP                               R0, 0
  JNE                               MenuChangeFoodChoiceError

  MenuChangeFoodChoiceError         : 
  CMP                               R0, 0
  JNE                               ChoicePaoForma

  ; Se o butão B_OK não foi pressionado
  MenuChangeFoodOkNotPressed        :
  JMP                               MenuChangeFoodDisplayReady        ; Se o butão change não foi clicado, e não foi selecionado nenhum alimento, 
  ;                                                            não há necessidade de voltar a dar refresh no ecrã, sendo só necessário verificar os inputs.
  RET

MenuScaleCall: ; ((), (), (), (), (), (), PesoAnterior, AlimentoAtual)

  ; Display Scale Menu
  DisplayScaleMenu                  : 
  CALL                              PrepareDisplayCall                ; Preparar ecrã para mostrar o menu balança
  MOV                               R2, GUIMenuScale                  ; Guardar em R2 o endereço do menu balança
  CALL                              DisplayMenuCall                   ; Mostrar Menu balança no Display
  ; Display Overwrite Peso 
  MOV                               R0, DisplayBeginning
  MOV                               R1, 1                             ; Linha a dar overwrite, sendo a primeira a linha 0
  MOV                               R2, PESO                          ; Endereço com o conteúdo que irá substituir a linha
  MOV                               R3, 0                             ; Numero de bytes que já levaram overwrite
  CALL                              OverwriteDisplayCall
  ; Display Overwrite Alimento
  MOV                               R0, DisplayBeginning
  MOV                               R1, 2                             ; Linha a dar overwrite, sendo a primeira a linha 0
  MOV                               R2, TableAveia                    ; Endereço com o conteúdo que irá substituir a linha
  MOV                               R3, 0                             ; Numero de bytes que já levaram overwrite

  MOV                               R4, 32                            ; Guarda em R4 o número de carateres da tabela de cada alimento, para ser usado como padding
  MOV                               R5, R7                            ; Guarda cópia do AlimentoAtual em R5
  MUL                               R5, R4                            ; Constrói o padding que será usado para aceder ao endereço correto (Cópia AlimentoAtual * Nº Carateres Alimento)
  ADD                               R2, R5                            ; Adiciona o padding ao endereço da primeira tabela, obtendo a tabela que se quer aceder
  CALL                              OverwriteDisplayCall

  MenuScaleDisplayReady             :

  MOV                               R0, B_CHANGE
  MOV                               R1, [R0]                          ; Guardar valor B_CHANGE no R1
  CMP                               R1, 1                             ; Verificar se B_CHANGE foi pressionado
  JNE                               MenuScaleChangeNotPressed         

  ; Se o butão change foi pressionado
  DisplayChangeFoodMenu             :
  MOV                               R6, 0                             ; Passa 0 como parâmetro para mostrar o primeiro menu da tabela
  MOV                               R0, B_CHANGE                              
  MOV                               [R0], R6                          ; Reset do periférico [B_CHANGE] antes de entrar no próximo menu                                   
  Call                              MenuChangeFoodCall
  JMP                               MenuScaleCall 

  ; Se o butão change não foi pressionado
  MenuScaleChangeNotPressed         :
  
  MOV                               R0, PESO
  MOV                               R1, [R0]                          ; Guardar valor atual do PESO no R1
  CMP                               R1, R6                            ; Comparar valor atual do peso, com o valor guardado anteriormente
  MOV                               R6, R1                            ; Criar cópia do valor atual do peso, na próxima iteração será comparada com o novo valor do peso nessa iteração 

  ; Se o peso mudou comparado com a iteração anterior
  JNE                               DisplayScaleMenu

  ; Se o peso não mudou comparado com a iteração anterior
  JMP                               MenuScaleDisplayReady

  RET

MenuDailyTotalCall:
  MOV                               R8, 4
  RET

MenuResetCall:
  MOV                               R9, 4
  RET

MenuErrorCall:
  MOV                               R10, 4
  RET
  
MenuMainCall:

  MOV                               R0, B_OK
  MOV                               R1, [R0]                          ; Escrever o valor de B_OK em R1

  ; Verificar se o utilizador confirmou a sua escolha
  CMP                               R1, 1                             ; Verificar se o utilizador primiu o butão de confirmar a escolha
  JNE                               MenuMainCall                      ; Se o utilizador não clicou confirmar a escolha ainda, voltar a verificar

  ; Se o utilizador confirmou a escolha
  MOV                               R0, SEL_NR_MENU
  MOV                               R1, [R0]                          ; Escrever o valor de SEL_NR_MENU em R1

  ; Escolha 1 - Menu Balança
  CMP                               R1, 1          
  JNE                               ChoiceDailyTotal                  ; Se não foi esta a escolha do utilizador, verifica a próxima
  
  ; Input
  MOV                               R1, 0
  MOV                               R0, SEL_NR_MENU
  MOV                               [R0], R1                          ; Reset do periférico [SEL_NR_MENU] antes de entrar no próximo menu
  MOV                               R0, B_OK
  MOV                               [R0], R1                          ; Reset do periférico [B_OK] antes de entrar no próximo menu

  MOV                               R0, PESO
  MOV                               R6, [R0]                          ; Passar como parâmetro valor do peso atual
  MOV                               R7, 0                             ; Passar como parâmetro o alimento 0
  CALL                              MenuScaleCall
  JMP                               MenuMainCall

  ; Escolha 2 - Total diário
  ChoiceDailyTotal                  :
  CMP                               R1, 2          
  JNE                               ChoiceResetInput                  ; Se não foi esta a escolha do utilizador, verifica a próxima

  ; Display
  CALL                              PrepareDisplayCall                ; Preparar Display para mostrar o total diário
  MOV                               R2, GUIMenuDailyTotal             ; Guardar em R2 o endereço do menu total diário
  CALL                              DisplayMenuCall                   ; Mostrar Menu total diário no Display

  ; Input
  MOV                               R1, 0
  MOV                               R0, SEL_NR_MENU
  MOV                               R1, B_OK
  MOV                               [R0], R3                          ; Reset do periférico [SEL_NR_MENU] antes de entrar no próximo menu
  MOV                               [R1], R3                          ; Reset do periférico [B_OK] antes de entrar no próximo menu
  MOV                               R2, 0                             ; Reset do valor do butão SEL_NR_MENU antes de entrar no próximo menu
  MOV                               R3, 0                             ; Reset do valor do butão B_OK antes de entrar no próximo menu
  CALL                              MenuDailyTotalCall
  JMP                               MenuMainCall

  ; Escolha 3 - Reset
  ChoiceResetInput                  :
  CMP                               R1, 3         
  JNE                               MenuMainChoiceError               ; Se não foi esta a escolha do utilizador, não existe próxima, logo mostra um erro

  ; Display
  CALL                              PrepareDisplayCall                ; Preparar Display para mostrar o menu de reset
  MOV                               R2, GUIMenuReset                  ; Guardar em R2 o endereço do menu de reset
  CALL                              DisplayMenuCall                   ; Mostrar menu de reset no Display

  ; Input
  MOV                               R3, 0
  MOV                               R0, SEL_NR_MENU
  MOV                               R1, B_OK
  MOV                               [R0], R3                          ; Reset do periférico [SEL_NR_MENU] antes de entrar no próximo menu
  MOV                               [R1], R3                          ; Reset do periférico [B_OK] antes de entrar no próximo menu
  MOV                               R2, 0                             ; Reset do valor do butão SEL_NR_MENU antes de entrar no próximo menu
  MOV                               R3, 0                             ; Reset do valor do butão B_OK antes de entrar no próximo menu
  CALL                              MenuResetCall
  JMP                               MenuMainCall

  ; Erro
  MenuMainChoiceError               :

  ; Display
  CALL                              PrepareDisplayCall                ; Preparar Display para mostrar o menu erro
  MOV                               R2, GUIMenuError                  ; Guardar em R2 o endereço do menu principal
  CALL                              DisplayMenuCall

  ; Input
  MOV                               R3, 0
  MOV                               R0, SEL_NR_MENU
  MOV                               R1, B_OK
  MOV                               [R0], R3                          ; Reset do periférico [SEL_NR_MENU] antes de entrar no próximo menu
  MOV                               [R1], R3                          ; Reset do periférico [B_OK] antes de entrar no próximo menu
  MOV                               R2, 0                             ; Reset do valor do butão SEL_NR_MENU antes de entrar no próximo menu
  MOV                               R3, 0                             ; Reset do valor do butão B_OK antes de entrar no próximo menu
  CALL                              MenuErrorCall
  JMP                               MenuMainCall

  RET





;MAGIC FORMULA
;((7 * 16) + E) * 16 + 2
;https://www.tutorialspoint.com/8085-code-to-convert-binary-number-to-ascii-code