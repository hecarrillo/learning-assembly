segment .data 
cadImprimir  db   'Hello World in Windows Assembly!',0xA   ;Segundo argumento para la llamada al sistema _WriteConsoleA() 
cadImprimirLen  equ  ($ - cadImprimir)
segment .bss 
handleConsola   resd   1   ;Primer argumento para la llamada al sistema _WriteConsoleA() 
caractEscritos  resd   1   ;Cuarto argumento para la llamada al sistema _WriteConsoleA() 
ultimoArgumento  resd   1   ;Quinto argumento para la llamada al sistema _WriteConsoleA() 

segment .text 
global _main 
extern _GetStdHandle@4  ;Acceso externo a la llamada al sistema _GetStdHandle() 
extern _WriteConsoleA@20 ;Acceso externo a la llamada al sistema _WriteConsoleA() 
extern _ExitProcess@4 ;Acceso externo a la llamada al sistema _ExitProcess() 
   
_main: push dword -11  ;Argumento pasado por la pila y usado en _GetStdHandle() para la salida estándar 
call   _GetStdHandle@4   ;Invocacion de _GetStdHandle() 
mov  [handleConsola],eax  ;Devolucion del manejador de consola para escritura en el registro eax 

xor   eax,eax  ;Limpieza del registro eax (eax=0) 
xor eax,eax   ;Limpieza del registro eax (eax=0) 
mov  eax,0 ;eax=0 valor del ultimo argumento de _WriteConsoleA() 
mov  [ultimoArgumento],eax   ;Se guarda el valor del ultimo argumento en memoria 

push dword [ultimoArgumento]   ;Quinto argumento de _WriteConsoleA() pasado por la pila 
push dword caractEscritos   ;Cuarto argumento de _WriteConsoleA() pasado por la pila 
push dword cadImprimirLen  ;Tercer argumento de _WriteConsoleA() pasado por la pila 
push dword cadImprimir  ;Segundo argumento de _WriteConsoleA() pasado por la pila 
push dword [handleConsola]  ;Primer argumento de _WriteConsoleA() pasado por la pila 
call   _WriteConsoleA@20   ;Invocacion de _WriteConsoleA() 

xor   eax,eax   ;Limpieza del registro eax (eax=0) 
mov eax,0d   ;eax=0 valor del argumento de _ExitProcess() 
mov [ultimoArgumento],eax   ;Se guarda el valor del argumento en memoria 
push dword [ultimoArgumento]   ;Argumento de _ExitProcess() pasado por la pila 
call   _ExitProcess@4 ;Invocacion de _ ExitProcess() 

