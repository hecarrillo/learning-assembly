segment .data
; string that says: "Insert a string and press enter"
initialPrompt db "Inserte una cadena:", 10
; obtain the length of the initialPrompt string
initialPromptLength equ ($ - initialPrompt)
; string that says: "String length: "
stringLengthPrompt db "Longitud de la cadena: ", 10
; obtain the length of the stringLengthPrompt string
stringLengthPromptLength equ ($ - stringLengthPrompt)

segment .bss   
 longitudCadenaFinal resd 10
 charToPrint  resd 10 
 string  resb 50  
 
segment .text 
        global _start   
   
_start: 
        call printInitialPrompt
        call readLine
        call printStringLengthPrompt
        xor ecx, ecx
        mov ecx, [string]
        call strlen
        ; save the string length in edi (as a function parameter to printNumber)
        mov edi, [longitudCadenaFinal]
        call printNumber
exit:
        mov eax, 1
        int 0x80

printInitialPrompt:   
        mov edx, initialPromptLength
        mov ecx, initialPrompt
        mov ebx, 1
        mov eax, 4
        int 0x80     
        ret

printStringLengthPrompt:
        mov edx, stringLengthPromptLength
        mov ecx, stringLengthPrompt
        mov ebx, 1
        mov eax, 4
        int 0x80
        ret

readLine:
        mov edx, 50
        mov ecx, string
        mov ebx, 0
        mov eax, 3
        int 0x80
        ret

strlen:
  xor   eax, eax

_strlen_next:
    
    cmp   ecx, byte 0  ; null byte yet?
    jz    _strlen_null   ; yes, get out

    inc   eax            ; char is ok, count it
    inc   ecx            ; move to next char
    jmp   _strlen_next   ; process again

_strlen_null:

  mov   [longitudCadenaFinal], eax  
  ret  

printNumber:
        cmp edi, 10
        jge recurse
        ; if the current number less than 10, we have reached the end of recursion and we print the number
        mov [charToPrint], edi
        call parseIntToChar
        call print
        ret

recurse:
        xor eax, eax
        xor ecx, ecx
        mov eax, edi
        mov edx, 0
        mov ecx, 10
        div ecx; eax/ecx
        push edx; push the remainder into the stack
        mov edi, eax
        call printNumber
        pop edx
        mov [charToPrint], edx
        call parseIntToChar
        call print
        ret

parseIntToChar:
        xor eax, eax
        mov eax, [charToPrint] 
        add eax, 48 ; Convert the number into a char adding '0' (first char in ascii)
        mov [charToPrint], eax
        ret

print:
        mov edx, 1
        mov ecx, charToPrint
        mov ebx, 1
        mov eax, 4
        int 0x80
        ret
 