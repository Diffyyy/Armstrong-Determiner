%include "io.inc"
section .data
INPUT dq 0
COUNT dd 0
COUNTER dd 0
COUNTDEC dd 0
SUM dd 0
INPUTDEC dd 0

INDEX dd 0
TEMPI dd 0
GARBAGE dd 0
ANS dd 0
section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
GET_INPUT:
    mov dword[SUM], 0
    mov dword[INPUTDEC], 0
    
    
    PRINT_STRING "Enter a positive number: "
    GET_STRING [INPUT], 9
    lea esi, [INPUT]
    
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    jmp LOOP_CHECK
    

ERROR: 
    PRINT_STRING "Error: Input. Please enter a number again: "
    NEWLINE
    jmp GET_INPUT
    

LOOP_CHECK: 
    mov bl, [esi + eax * 1]
    
    cmp bl, 0
    je CLEAR
    cmp bl, 10
    je CLEAR
    cmp bl, 13
    je CLEAR
    
    ;bl < 0x30 (zero) -> jump to error
    cmp bl, 0x30
    jl ERROR
    ;bl > 0x39 (nine) -> jump to error
    cmp bl, 0x39
    jg ERROR
    
    ;to convert current char to dec
    sub bl, '0'
    inc eax
    inc ecx
    
    jmp LOOP_CHECK
    
CLEAR: 
    mov [COUNT], ecx
    dec ecx
    mov [COUNTDEC], ecx
    xor eax, eax
    xor ecx, ecx
    mov [COUNTER], ecx
    
    ;eax = 
    ;ebx = curr num
    ;ecx = index
    ;edx = temporary product
    PRINT_STRING "Sequence: "
   
    mov ecx, [COUNT]
    
LOOP_CALCULATE:
    cmp ecx, 0
    je PRINT_SUM

    
    xor ebx, ebx
    mov bl, [esi + eax * 1]
    sub bl, '0'
    mov [COUNTER], ecx
    
    xor ecx, ecx
    xor edx, edx
    mov edx, 1
    ;Exponent
    
EXPONENT: 
    cmp ecx, [COUNT]
    je LOOP_CONT
    imul edx, ebx
    
    inc ecx
    jmp EXPONENT
    
LOOP_CONT: 
    add [SUM], edx
    mov ecx, [COUNTER]
    dec ecx
    inc eax
    
    PRINT_DEC 4, edx
    cmp ecx, 0
    jne PRINT_COMMA
    
    jmp LOOP_CALCULATE
   
PRINT_COMMA:
    PRINT_STRING ", "
    jmp LOOP_CALCULATE
    
    
PRINT_SUM: 
    NEWLINE
    PRINT_STRING "Sum of the m-th power digits: "
    PRINT_DEC 4, SUM
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    

CONVERT_TO_DEC:
    cmp ecx, [COUNT]
    je IS_ARMSTRONG
    
    movzx eax, byte[INPUT + ecx]
    sub eax, '0'
    imul edx, 10
    add edx, eax
    inc ecx
    jmp CONVERT_TO_DEC

IS_ARMSTRONG:
    mov [INPUTDEC], edx
    NEWLINE
    PRINT_STRING "Armstrong Number: "
    xor eax, eax
    xor ebx, ebx
    mov eax, [SUM]
    mov ebx, [INPUTDEC]
    
    
    cmp eax, ebx
    jne NOT_ARMSTRONG
    PRINT_STRING "Yes"
    jmp INPUT_AGAIN

NOT_ARMSTRONG:
    PRINT_STRING "No"

INPUT_AGAIN: 
    NEWLINE
    PRINT_STRING "Do you want to continue? (Y/N) "
    GET_CHAR ANS
    GET_CHAR GARBAGE
    cmp word [ANS], 0x59
    je GET_INPUT
    cmp word [ANS], 0x79
    je GET_INPUT
    cmp word [ANS], 0x4E
    je EXIT
    cmp word [ANS], 0x6E
    je EXIT
    
    jmp INPUT_AGAIN

      
EXIT:
    xor eax, eax
    ret