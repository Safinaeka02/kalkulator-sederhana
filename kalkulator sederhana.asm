org 100h            ; Mulai program di alamat 100h

; Data
menu db 'Kalkulator Sederhana', 0Dh, 0Ah
     db '1. Penjumlahan', 0Dh, 0Ah
     db '2. Pengurangan', 0Dh, 0Ah
     db 'Pilih operasi (1-2): $'

input_msg db 0Dh, 0Ah, 'Masukkan bilangan pertama: $'
input_msg2 db 0Dh, 0Ah, 'Masukkan bilangan kedua: $'
result_msg db 0Dh, 0Ah, 'Hasil: $'
buffer db 6 dup('$')  ; Buffer untuk angka yang akan ditampilkan

.code
start:
    ; Menampilkan menu
    mov ah, 09h
    lea dx, menu
    int 21h

    ; Meminta pengguna memilih operasi
    mov ah, 01h
    int 21h         ; Membaca karakter pilihan
    sub al, '0'     ; Mengonversi karakter ke angka
    mov bl, al      ; Menyimpan pilihan operasi di BL

    ; Meminta input angka pertama
    lea dx, input_msg
    mov ah, 09h
    int 21h         ; Menampilkan prompt untuk angka pertama
    call input_number
    mov cx, ax      ; Menyimpan bilangan pertama di CX

    ; Meminta input angka kedua
    lea dx, input_msg2
    mov ah, 09h
    int 21h         ; Menampilkan prompt untuk angka kedua
    call input_number
    mov dx, ax      ; Menyimpan bilangan kedua di DX

    ; Menangani operasi berdasarkan pilihan
    cmp bl, 1       ; Cek apakah pilihan 1 (Penjumlahan)
    je addition
    cmp bl, 2       ; Cek apakah pilihan 2 (Pengurangan)
    je subtraction
    jmp exit

addition:
    add cx, dx      ; CX = CX + DX (Penjumlahan)
    mov ax, cx      ; Menyimpan hasil penjumlahan ke AX
    call display_result
    jmp start       ; Kembali ke menu utama

subtraction:
    sub cx, dx      ; CX = CX - DX (Pengurangan)
    mov ax, cx      ; Menyimpan hasil pengurangan ke AX
    call display_result
    jmp start       ; Kembali ke menu utama

; Fungsi untuk input bilangan
input_number:
    xor ax, ax      ; Bersihkan AX
    mov cx, 0       ; Menyimpan hasil input
    mov bl, 10      ; Basis 10 untuk konversi
input_loop:
    mov ah, 01h     ; Membaca karakter
    int 21h
    sub al, '0'     ; Mengonversi karakter ke angka
    cmp al, 0       ; Cek apakah angka valid
    jl done_input
    mul bl          ; AX = AX * 10
    add ax, cx      ; Menambahkan angka ke hasil konversi
    mov cx, ax      ; Simpan hasil konversi
    jmp input_loop
done_input:
    ret

; Fungsi untuk menampilkan hasil
display_result:
    mov ah, 09h
    lea dx, result_msg
    int 21h
    mov ax, cx
    call print_number
    ret

; Fungsi untuk mencetak angka
print_number:
    xor bx, bx      ; Bersihkan BX
    mov cx, 10      ; Basis 10
    mov si, 0       ; Indeks buffer
convert_loop:
    xor dx, dx
    div cx          ; Membagi AX dengan 10
    add dl, '0'     ; Konversi ke karakter ASCII
    push dx         ; Simpan digit ke stack
    inc si          ; Increment indeks
    test ax, ax     ; Cek apakah sudah habis
    jnz convert_loop
output_loop:
    pop dx          ; Ambil digit dari stack
    mov buffer[si-1], dl
    dec si
    loop output_loop
    mov buffer[si], '$'
    lea dx, buffer
    mov ah, 09h
    int 21h
    ret

exit:
    mov ah, 4Ch
    int 21h
end start
