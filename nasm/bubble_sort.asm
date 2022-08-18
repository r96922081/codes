%include "util.asm"

section .data
 input: times 10 dd 0
 input_count dd 5
 temp: times 10 dd 0  

section .text
 global _start:


exchange_if_addr1_greater_than_addr2:
  pop dword [temp]
  pop dword [temp + 4]
  pop dword [temp + 8]

  push dword [temp]
  push eax
  push ebx
  push ecx
  push edx

  mov eax, dword [temp+8]
  mov ebx, dword [temp+4]
  mov ecx, [eax]
  mov edx, [ebx]

  cmp ecx, edx
  jl end

  mov eax, dword [temp+4]
  mov [eax], ecx

  mov eax, dword [temp+8]
  mov [eax], edx

  end:
    pop edx
    pop ecx
    pop ebx
    pop eax  

  ret

_start:
  mov dword [input], 3
  mov dword [input+4], 1
  mov dword [input+8], 2
  mov dword [input+12], 5
  mov dword [input+16], 4
  
  mov ecx, [input_count]
  push ecx

  sort:    
    mov eax, [input_count]
    sub eax, ecx ; eax is now offset by 1

    mov ecx, eax
    mov eax, 4
    mul ecx
    mov ecx, eax ; ecx is now offset by 4

    mov eax, input
    add eax, ecx
    mov ebx, eax
    add ebx, 4

    push eax
    push ebx
    call exchange_if_addr1_greater_than_addr2

    pop ecx
    dec ecx
    push ecx
    cmp ecx, 1
  jne sort

  pop ecx


  mov dword [temp], 'bubb'
  push temp
  push 4
  call print_string


  mov dword [temp], 'le o'
  push temp
  push 4
  call print_string


  mov dword [temp], 'utpu'
  push temp
  push 4
  call print_string

  mov dword [temp], `t:\n`
  push temp
  push 3
  call print_string


  push dword input
  push 5
  call print_addr_count

  mov eax, 1
  int 0x80   ; call kernel
