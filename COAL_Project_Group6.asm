.model small
.stack 100h

.data

;========MAIN MENU STRINGS========
main1 db 13,10,"========== MAIN MENU ==========",13,10,"$"
main2 db "1) Caesar Cipher",13,10,"$"
main3 db "2) ROT13 Hybrid Cipher",13,10,"$"
main4 db "3) Exit",13,10,"$"
main5 db "Enter choice: $"
;========CAESAR MENU STRINGS========
c1 db 13,10,"------ CAESAR MENU ------",13,10,"$"
c2 db "1) Encrypt",13,10,"$"
c3 db "2) Decrypt",13,10,"$"
c5 db "3) Back to Main Menu",13,10,"$"
c6 db "Enter option: $"
;========ROT MENU STRINGS========
r1 db 13,10,"------ ROT13 HYBRID MENU ------",13,10,"$"
r2 db "1) Encrypt",13,10,"$"
r3 db "2) Decrypt",13,10,"$"
r5 db "3) Back to Main Menu",13,10,"$"
r6 db "Enter option: $"
;========ORIGINAL CIPHER STRINGS========
msg_caesar_in   db 13,10, "Enter text for Caesar Cipher: $"
msg_caesar_key  db 13,10, "Enter Caesar key (1-25): $"
msg_caesar_key2 db 13,10, "Enter key to decrypt: $"
msg_caesar_enc  db 13,10, "Encrypted (Caesar): $"
msg_caesar_dec  db 13,10, "Decrypted (Caesar): $"
msg_wrong_key   db 13,10, "Incorrect key! Cannot decrypt.$"
msg_rot_in      db 13,10, "Enter text for ROT13 Hybrid (ROL+XOR): $"
msg_rot_enc     db 13,10, "Encrypted (ROT13 Hybrid): $"
msg_rot_dec     db 13,10, "Decrypted (ROT13 Hybrid): $"
msg_invalid db 13,10,"Invalid choice! Try again.$"
;========BUFFERS========
buffer   db 100, ?, 100 dup('$')
caesar_e db 101 dup('$')
caesar_d db 101 dup('$')
rot_buf  db 100, ?, 100 dup('$')
rot_e    db 101 dup('$')
rot_d    db 101 dup('$')
key1 db 0
key_buf db 3, ?, 3 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax
;========MAIN MENU LOOP========
main_menu:

    mov dx, offset main1
    mov ah, 09h
    int 21h

    mov dx, offset main2
    mov ah, 09h
    int 21h

    mov dx, offset main3
    mov ah, 09h
    int 21h

    mov dx, offset main4
    mov ah, 09h
    int 21h

    mov dx, offset main5
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'

    cmp al, 1
    je caesar_menu

    cmp al, 2
    je rot_menu_start

    cmp al, 3
    je exit_program

    mov dx, offset msg_invalid
    mov ah, 09h
    int 21h
    jmp main_menu

;========CAESAR MENU========
caesar_menu:
    mov dx, offset c1
    mov ah, 09h
    int 21h

    mov dx, offset c2
    mov ah, 09h
    int 21h

    mov dx, offset c3
    mov ah, 09h
    int 21h

    mov dx, offset c5
    mov ah, 09h
    int 21h

    mov dx, offset c6
    mov ah, 09h
    int 21h

    mov ah,1
    int 21h
    sub al,'0'

    cmp al,1
    je caesar_encrypt_only

    cmp al,2
    je caesar_decrypt_only

    cmp al,3
    je main_menu

    mov dx, offset msg_invalid
    mov ah, 09h
    int 21h
    jmp caesar_menu

;========CAESAR ENCRYPT========
caesar_encrypt_only:

    mov dx, offset msg_caesar_in
    mov ah, 09h
    int 21h

    mov dx, offset buffer
    mov ah,0Ah
    int 21h

;========Read key========

    mov dx, offset msg_caesar_key
    mov ah, 09h
    int 21h

    mov dx, offset key_buf
    mov ah, 0Ah
    int 21h

    lea si, key_buf+2
    mov al,[si]
    sub al,'0'
    mov bl,al

    mov al,[si+1]
    cmp al,13
    je one_digit_k1

    sub al,'0'
    mov bh,al
    mov al,bl
    mov cl,10
    mul cl
    add al,bh
    jmp key_done_k1

one_digit_k1:
    mov al,bl

key_done_k1:
    mov key1, al
;========CAESAR ENCRYPTION LOOP========
    lea si, buffer+2
    lea di, caesar_e
    mov cl, buffer+1

ca_enc_loop:
    cmp cl, 0
    je show_ca_enc

    mov al,[si]

    cmp al,'A'
    jb ca_store_e
    cmp al,'Z'
    jbe enc_upper

    cmp al,'a'
    jb ca_store_e
    cmp al,'z'
    jbe enc_lower

    jmp ca_store_e

enc_upper:
    sub al,'A'
    add al,key1
    mov bl,26
    mov ah,0
    div bl
    mov al,ah
    add al,'A'
    jmp ca_store_e

enc_lower:
    sub al,'a'
    add al,key1
    mov bl,26
    mov ah,0
    div bl
    mov al,ah
    add al,'a'

ca_store_e:
    mov [di],al
    inc si
    inc di
    dec cl
    jmp ca_enc_loop

show_ca_enc:
    mov byte ptr [di], '$'

    mov dx, offset msg_caesar_enc
    mov ah, 09h
    int 21h

    mov dx, offset caesar_e
    mov ah, 09h
    int 21h

    jmp caesar_menu

;========CAESAR DECRYPT========
caesar_decrypt_only:

    mov dx, offset msg_caesar_key2
    mov ah, 09h
    int 21h

    mov dx, offset key_buf
    mov ah,0Ah
    int 21h

    lea si, key_buf+2
    mov al,[si]
    sub al,'0'
    mov bl,al

    mov al,[si+1]
    cmp al,13
    je one_digit_k2

    sub al,'0'
    mov bh,al
    mov al,bl
    mov cl,10
    mul cl
    add al,bh
    jmp key_done_k2

one_digit_k2:
    mov al,bl

key_done_k2:
    mov bh, al

    cmp bh,key1
    jne wrong_key_show

;========decrypt========

    lea si, caesar_e
    lea di, caesar_d
    mov cl, buffer+1

ca_dec_loop:
    cmp cl,0
    je show_ca_dec

    mov al,[si]

    cmp al,'A'
    jb ca_store_d
    cmp al,'Z'
    jbe dec_upper

    cmp al,'a'
    jb ca_store_d
    cmp al,'z'
    jbe dec_lower

    jmp ca_store_d

dec_upper:
    sub al,'A'
    sub al,key1
    add al,26
    mov bl,26
    mov ah,0
    div bl
    mov al,ah
    add al,'A'
    jmp ca_store_d

dec_lower:
    sub al,'a'
    sub al,key1
    add al,26
    mov bl,26
    mov ah,0
    div bl
    mov al,ah
    add al,'a'

ca_store_d:
    mov [di],al
    inc si
    inc di
    dec cl
    jmp ca_dec_loop

show_ca_dec:
    mov byte ptr [di],'$'

    mov dx, offset msg_caesar_dec
    mov ah, 09h
    int 21h

    mov dx, offset caesar_d
    mov ah, 09h
    int 21h

    jmp caesar_menu


;========ROT13 MENU========

rot_menu_start:

    mov dx, offset r1
    mov ah, 09h
    int 21h

    mov dx, offset r2
    mov ah, 09h
    int 21h

    mov dx, offset r3
    mov ah, 09h
    int 21h

    mov dx, offset r5
    mov ah, 09h
    int 21h

    mov dx, offset r6
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al,'0'

    cmp al,1
    je rot_encrypt_only

    cmp al,2
    je rot_decrypt_only

    cmp al,3
    je main_menu

    mov dx, offset msg_invalid
    mov ah, 09h
    int 21h
    jmp rot_menu_start
;========ROT ENCRYPT ========
rot_encrypt_only:

    mov dx, offset msg_rot_in
    mov ah, 09h
    int 21h

    mov dx, offset rot_buf
    mov ah, 0Ah
    int 21h

    lea si, rot_buf+2
    lea di, rot_e
    mov cl, rot_buf+1

rot_enc_loop:
    cmp cl,0
    je show_rot_enc

    mov al,[si]
    rol al,3
    xor al,13h
    mov [di],al

    inc si
    inc di
    dec cl
    jmp rot_enc_loop

show_rot_enc:
    mov byte ptr [di],'$'

    mov dx, offset msg_rot_enc
    mov ah, 09h
    int 21h

    mov dx, offset rot_e
    mov ah, 09h
    int 21h

    jmp rot_menu_start

;========ROT DECRYPT ========

rot_decrypt_only:

    lea si, rot_e
    lea di, rot_d
    mov cl, rot_buf+1

rot_dec_loop:
    cmp cl,0
    je show_rot_dec

    mov al,[si]
    xor al,13h
    ror al,3
    mov [di],al

    inc si
    inc di
    dec cl
    jmp rot_dec_loop

show_rot_dec:
    mov byte ptr [di],'$'

    mov dx, offset msg_rot_dec
    mov ah, 09h
    int 21h

    mov dx, offset rot_d
    mov ah, 09h
    int 21h

    jmp rot_menu_start


;========WRONG KEY HANDLER========

wrong_key_show:
    mov dx, offset msg_wrong_key
    mov ah, 09h
    int 21h
    jmp caesar_menu

;========EXIT PROGRAM========

exit_program:
    mov ah,4Ch
    int 21h

main endp
end main
