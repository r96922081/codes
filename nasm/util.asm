section .data
  print_a_char_proc_temp:  times 4 dd 10
  print_string_proc_temp:  times 4 dd 10
  print_regiter_proc_temp dd 0
  print_value_proc_buf dd 0
  print_value_proc_temp: times 4 dd 0
  print_value_new_line_proc_buf dd 0
  print_value_new_line_proc_temp: times 4 dd 0
  print_addr_proc_temp: times 4 dd 0
  print_addr_count_proc_temp: times 4 dd 0
  temp_string dd ' '
  temp_buf : times 2 dd 0

print_string:
  ; [string, len, ret]

  pop dword [print_string_proc_temp] ;ret
  pop dword [print_string_proc_temp + 4] ; len
  pop dword [print_string_proc_temp + 8] ; string

  push dword [print_string_proc_temp]
  push eax
  push ebx
  push ecx
  push edx

  mov eax, 4
  mov ebx, 1
  mov ecx, [print_string_proc_temp + 8]
  mov edx, [print_string_proc_temp + 4]
  int 0x80

  pop edx
  pop ecx
  pop ebx
  pop eax

  ret

print_addr_count:
  ; [addr, count, ret]
  mov [print_addr_count_proc_temp], eax
  mov [print_addr_count_proc_temp + 4], ebx
  mov [print_addr_count_proc_temp + 8], ecx
  mov [print_addr_count_proc_temp + 12], edx

  pop ebx; ret
  pop ecx; count
  pop eax; addr
  push ebx

  print_addr_count_loop:
    push eax
    call print_addr
    add eax, 4
    dec ecx
    cmp ecx, 0    
    jne print_addr_count_loop

  mov eax, [print_addr_count_proc_temp]
  mov ebx, [print_addr_count_proc_temp + 4]
  mov ecx, [print_addr_count_proc_temp + 8]
  mov edx, [print_addr_count_proc_temp + 12]

  ret


print_addr:
  ; [addr, ret]
  mov [print_value_proc_temp], eax
  mov [print_value_proc_temp + 4], ebx
  mov [print_value_proc_temp + 8], ecx
  mov [print_value_proc_temp + 12], edx

  pop ebx ; ret
  pop eax ; addr
  push ebx
  push dword [print_value_proc_temp]
  push dword [print_value_proc_temp + 4]
  push dword [print_value_proc_temp + 8]
  push dword [print_value_proc_temp + 12]

  push eax
  call print_value 

  push ' '
  call  print_a_char 

  push '='
  call  print_a_char 

  push ' '
  call  print_a_char 

  push dword [eax] 
  call print_value
  
  push 10
  call print_a_char

  pop edx
  pop ecx
  pop ebx
  pop eax

  ret

print_value_new_line:
  mov [print_value_new_line_proc_temp], eax
  mov [print_value_new_line_proc_temp + 4], ebx
  mov [print_value_new_line_proc_temp + 8], ecx
  mov [print_value_new_line_proc_temp + 12], edx

  pop ebx ; ret
  pop eax ; value
  push ebx
  push dword [print_value_new_line_proc_temp]
  push dword [print_value_new_line_proc_temp + 4]
  push dword [print_value_new_line_proc_temp + 8]
  push dword [print_value_new_line_proc_temp + 12]

  push eax
  call print_value

  mov eax, 4
  mov ebx, 1
  mov byte [print_value_new_line_proc_buf], 10 ; new line
  mov ecx, print_value_new_line_proc_buf
  mov edx, 1
  int 0x80

  pop edx
  pop ecx
  pop ebx
  pop eax

  ret

print_value:
  ; [value, ret]

  mov [print_value_proc_temp], eax
  mov [print_value_proc_temp + 4], ebx
  mov [print_value_proc_temp + 8], ecx
  mov [print_value_proc_temp + 12], edx

  pop ebx ; ret
  pop eax ; value
  push ebx
  push dword [print_value_proc_temp]
  push dword [print_value_proc_temp + 4]
  push dword [print_value_proc_temp + 8]
  push dword [print_value_proc_temp + 12]
  push 8; 
  push eax ; [ret, eax, ebx, ecx, edx, loop, data]

  mov eax, 4
  mov ebx, 1
  mov byte [print_value_proc_buf], '0'
  mov ecx, print_value_proc_buf
  mov edx, 1
  int 0x80

  mov eax, 4
  mov ebx, 1
  mov byte [print_value_proc_buf], 'x'
  mov ecx, print_value_proc_buf
  mov edx, 1
  int 0x80

  loop:
    pop eax
    ror eax, 28
    push eax
    
    mov edx, 0
    mov ebx, 16
    div ebx
    
    mov eax, 10
    cmp dx, ax ; if dx < ax, then zf = 0. cf = 1, if dx = ax, then zf = 1, cf = 0.  if dx > ax, then zf = 0, cf = 0
    jc less_than_10
    
    mov al, 'A'
    sub edx, 10
    jmp end_condition
    
    less_than_10:
    mov al, '0' 
    
    end_condition:
    
    add al,dl
    mov byte [print_value_proc_buf], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, print_value_proc_buf
    mov edx, 1
    int 0x80
    
    pop eax; data
    pop ecx; loop
    dec ecx
    cmp ecx, 0
    push ecx 
    push eax
    ; [ret, eax, ebx, ecx, edx, loop, data]  
  jne loop

  pop eax
  pop ebx   
  ; [ret, eax, ebx, ecx, edx]


  pop edx
  pop ecx
  pop ebx
  pop eax

  ret

print_a_char:
  ; [char, ret]


  pop dword [print_a_char_proc_temp] ;ret
  pop dword [print_a_char_proc_temp + 4] ; char
  mov dword [print_a_char_proc_temp + 8], eax
  mov dword [print_a_char_proc_temp + 12], ebx
  mov dword [print_a_char_proc_temp + 16], ecx
  mov dword [print_a_char_proc_temp + 20], edx


  mov eax, 4
  mov ebx, 1
  mov ecx, print_a_char_proc_temp + 4
  mov edx, 1
  int 0x80

  mov edx, [print_a_char_proc_temp + 20]
  mov ecx, [print_a_char_proc_temp + 16]
  mov ebx, [print_a_char_proc_temp + 12]
  mov eax, [print_a_char_proc_temp + 8]

  push dword [print_a_char_proc_temp] 

  ret


print_registers:
  mov dword [temp_string], 'eax:'
  push temp_string
  push 4
  call print_string

  mov dword [temp_string], ' '
  push temp_string
  push 1
  call print_string

  push eax
  call  print_value_new_line

  mov dword [temp_string], 'ebx:'
  push temp_string
  push 4
  call print_string

  mov dword [temp_string], ' '
  push temp_string
  push 1
  call print_string

  push ebx
  call  print_value_new_line

  mov dword [temp_string], 'ecx:'
  push temp_string
  push 4
  call print_string

  mov dword [temp_string], ' '
  push temp_string
  push 1
  call print_string

  push ecx
  call  print_value_new_line

  mov dword [temp_string], 'edx:'
  push temp_string
  push 4
  call print_string

  mov dword [temp_string], ' '
  push temp_string
  push 1
  call print_string

  push edx
  call print_value_new_line
  
  ret


_demo:
  mov eax, 1
  mov ebx, 2
  mov ecx, 3
  mov edx, 4

  call  print_registers

  mov dword [temp_string], 'ABC'
  push temp_string
  push 3
  call print_string

  mov dword [temp_string], 10 
  push temp_string
  push 1
  call print_string

  mov dword [temp_buf], 0x12345678
  push temp_buf
  call print_addr
 
  mov dword [temp_buf + 4], 0x11112222
  push temp_buf
  push 2
  call print_addr_count
 
  mov eax, 1
  int 0x80   ; call kernel
