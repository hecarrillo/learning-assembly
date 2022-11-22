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
 handleConsola resd 10 
 longitudCadenaDefault resd 10  
 longitudCadenaFinal resd 10
 charToPrint  resd 10 
 placeholder  resd 10 
 remainder resd 10
 quotient  resd 10 
 string  resb 30  
 ultimoArgumento resd 10  
 
segment .text 
        global _main 
        extern _GetStdHandle@4   
        extern _WriteConsoleA@20   
        extern _ReadConsoleA@20    
        extern _ExitProcess@4   
   
_main: 
        call printInitialPrompt
        call readLine
        call printStringLengthPrompt
        ; save the string length in edi (as a function parameter to printNumber)
        mov edi, [longitudCadenaFinal]
        call printNumber
exit:
        push 0;
        call _ExitProcess@4 

printInitialPrompt:
        ; obtain the handle to the console
        push dword -11
        xor eax, eax
        call _GetStdHandle@4
        mov [handleConsola], eax

        xor eax, eax
        mov eax, 0
        mov [ultimoArgumento], eax

        ; print the initial prompt
        push dword [ultimoArgumento]
        push dword placeholder
        push dword initialPromptLength
        push dword initialPrompt
        push dword [handleConsola]
        call _WriteConsoleA@20
        ret

printStringLengthPrompt:
        push dword -11
        xor eax, eax
        call _GetStdHandle@4
        mov [handleConsola], eax

        xor eax, eax
        mov eax, 0
        mov [ultimoArgumento], eax

        push dword [ultimoArgumento]
        push dword placeholder
        push dword stringLengthPromptLength
        push dword stringLengthPrompt
        push dword [handleConsola]
        call _WriteConsoleA@20
        ret

readLine:
        push dword -10d ;Argumento pasado por la pila y usado en _GetStdHandle() para la entrada estandar 
        call _GetStdHandle@4 ;Invocacion de _GetStdHandle() 
        mov [handleConsola],eax ;Devolucion del manejador de consola para lectura en el registro eax 

        xor eax,eax  ;Limpieza del registro eax (eax=0) 
        mov eax,100d  ;numero maximo de chars a leer
        mov [longitudCadenaDefault],eax ;Se guarda la longitud en memoria 
        xor eax,eax  ;Limpieza del registro eax (eax=0) 
        mov eax,0d  ;eax=0 valor del ultimo argumento de _ReadConsoleA() 
        mov [ultimoArgumento],eax ;Se guarda el valor del ultimo argumento en memoria 

        push dword [ultimoArgumento] 
        push dword longitudCadenaFinal 
        push dword [longitudCadenaDefault]
        push dword string
        push dword [handleConsola] 
        call _ReadConsoleA@20 

        xor eax, eax
        mov eax, [longitudCadenaFinal]
        sub eax, 2
        mov [longitudCadenaFinal], eax

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
        push dword-11
        xor eax,eax; 
        call _GetStdHandle@4;
        mov [handleConsola],eax;

        xor eax,eax  ;Limpieza del registro eax (eax=0) 
        mov eax,0d  ;eax=0 valor del ultimo argumento de _ReadConsoleA() 
        mov [ultimoArgumento],eax ;Se guarda el valor del ultimo argumento en memoria 

        push dword [ultimoArgumento] ;lpReserved Reserved; must be NULL.
        push dword placeholder ;lpNumberOfCharsWritten [out, optional] A pointer to a variable that receives the number of characters actually written.
        push dword 1  ;nNumberOfCharsToWrite [in]The number of characters to be written. 
        push dword charToPrint ;lpBuffer [in] A pointer to a buffer that contains characters to be written to the console screen buffer.
        push dword [handleConsola] ;hConsoleOutput [in] A handle to the console screen buffer
        call _WriteConsoleA@20 ;Invocacion de _WriteConsoleA() 
        ret
 