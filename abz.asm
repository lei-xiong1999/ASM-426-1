STACK SEGMENT STACK 'STACK'
      DW 100H DUP(?)
TOP LABEL WORD
STACK ENDS
DATA SEGMENT
        TITLE0 DB '17041126,XIONGLEI','$'
        TITLE1 DB 'GREATZ=','$'
        TITLE2 DB 'ZERO=','$'
        TITLE3 DB 'LITTLEZ=','$'  
BUFFER  DW -1,3,-5,7,-9,1,-9,9,-9,9,-5,-1,-2,-3,3,-4,-1,-9,-1,-1
GREATZ  DW ?                           
ZERO    DW ?
LITTLEZ DW ?
DATA ENDS
CODE SEGMENT
     ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK        
        
DISPMESSAGE MACRO MESSGE
    LEA DX,MESSGE
    MOV AH,09H
    INT 21H
ENDM     

DISPNUM MACRO  NUM    
    MOV AX,NUM   ;BUFFER -> AX
    CALL DISPLAY       
    DEC BX
    CMP BX,0  
    CALL DISPCR         
ENDM             

START:
    MOV AX,DATA
    MOV DS,AX
    MOV ES,AX
    MOV AX,STACK
    MOV SS,AX
    LEA SP,TOP
    XOR AX,AX
    MOV BL,10
    MOV GREATZ,AX   ;CLEAR G/Z/L
    MOV ZERO,AX
    MOV LITTLEZ,AX
    MOV CX,20       ;SET COUNT TO 20
    LEA SI,BUFFER                      

    MOV BX,20   ;COUNT=20
    LEA SI,BUFFER   ;SI->BUFFER
    PUSH BX ;KEEP BX = 20

    MOV DI,-2  
T1: 
    ADD DI,2   ;FLAG
    MOV AX,BUFFER[DI]   ;BUFFER -> AX
    CALL DISPLAY       
    DEC BX
    CMP BX,0
    JNE T1
    POP BX   
    CALL DISPCR

ST_COUNT:
    MOV AX,[SI]
    ADD SI,2
    AND AX,AX  
    JLE COUNT1
    INC GREATZ
    JMP COUNT3  
    
COUNT1:
    JL COUNT2
    INC ZERO
    JMP COUNT3 
    
COUNT2:
    INC LITTLEZ  
    
COUNT3:
    DEC CX
    JNZ ST_COUNT       
 
    DISPMESSAGE TITLE1
    DISPNUM GREATZ
    DISPMESSAGE TITLE2 
    DISPNUM ZERO             
    DISPMESSAGE TITLE3    
    DISPNUM LITTLEZ     
    CALL DISPCR
    CALL DISPCR
    CALL DISPCR       
    DISPMESSAGE TITLE0    
    POP BX

    MOV AH,4CH
    INT 21H     
       
DISPLAY PROC NEAR   ;DISPLAY PROGRAM
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    TEST AX,8000H
    JZ L6   ;IF +
    MOV BX,AX
    MOV DL,'-'
    MOV AH,2
    INT 21H
    MOV AX,BX
    NEG AX  ;IF -    
    
    L6: 
    MOV BX,10   ;GET EVERY BIT TO DISPLAY
    MOV CX,0  
    
    L1:
    XOR DX,DX
    DIV BX
    PUSH DX     ;PUSH INTO STACK TO SAVE DATA
    INC CX
    CMP AX,0
    JNE L1
    
    P1: 
    POP DX  ;OUTPUT THE DATA
    ADD DL,30H
    MOV AH,2H
    INT 21H
    LOOP P1
    
    MOV AH,2    ;OUTPUT ' '
    MOV DL,20H
    INT 21H
    
    POP DI
    POP DX
    POP CX
    POP BX
    RET
DISPLAY ENDP
    
DISPCR PROC NEAR    ;ENTER
    PUSH AX
    PUSH DX
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV AH,2
    MOV DL,0DH
    INT 21H
    POP DX
    POP AX
    RET
DISPCR ENDP
    
SHOW0 PROC NEAR ;0
    PUSH AX
    PUSH DX
    MOV AH,2
    MOV DL,30H
    INT 21H
    MOV AH,2
    MOV DL,20H
    INT 21H
    POP DX
    POP AX
    RET         
SHOW0 ENDP  

CODE    ENDS
        END START