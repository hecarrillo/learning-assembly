# learning-assembly

Learning assembly in Windows and Linux. Using nasm for 32 bits

## To compile/run on Windows

1. Install nasm
2. Set as env variable in PATH
3. Compile the desired file as: `nasm -f win32 <desired_file>.asm`
4. Link the .obj file to an .exe with: `ld<desired_file>.obj -m i386pe -l kernel32`
5. Execute as: `./a.exe`
