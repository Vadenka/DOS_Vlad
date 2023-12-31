org 0x7C00

jmp start

msg db "Berlya Vladislav", 0
msg2 db "Denisovich NMT-313901", 0


;��������� �������� �����
start:
    cli                 ;���������� ����������
    mov ax, 0           ;������������� �������� �����
    mov ss, ax
    mov sp, 0xFFFF      ;��������� ��������� ����� �� ����
    sti                 ;�������� ����������

    mov ax, 0x13        ; ������������ � ����� 320x200 256-�����
    int 0x10
    mov ax, 0x0010      ; ��������� ������������ ������ ������
    int 0x10

    ;��������� ��������������� ������������
    mov cx, 100          ;� ���������� � ����� �������� ������
    mov dx, 150          ;Y
    mov bx, 130          ;������
    call draw_triangle


    ; ��������� ����� ����
    mov ah, 0x0B        ; ������� ��� ��������� ����� ����
    mov bl, 0x08
    int 0x10

    ;����� ������
    mov ah, 0x13        ; �������, ����������� ����� ������
    mov al, 0
    mov bh, 0
    mov bl, 14
    mov dl, 59          ;�������
    mov dh, 11          ;������
    push cs
    pop es
    mov bp, msg
    mov cx, 16          ;�����
    int 0x10

    mov ah, 0x13        ; �������, ����������� ����� ������
    mov al, 0
    mov bh, 0
    mov bl, 14
    mov dl, 59          ;�������
    mov dh, 12          ;������
    push cs
    pop es
    mov bp, msg2
    mov cx, 21           ;�����
    int 0x10

hang:
    jmp hang


 ;������� ��� ��������� ��������������� ������������
 ;cx - ��������� x ����������
 ;dx - ��������� y ����������
 ;bx - ������ ������������

draw_triangle:
    pusha
    mov bp, cx            ;bp �������� �������� x ���������� ��� ���������
 ;���� ��������� ������������
triangle_loop:
    push cx
    mov ax, bx            ;ax
    shr ax, 1
    sub cx, ax            ;���������
    add ax, bp            ;��������

;��������� �������������� �����
draw_line:
    cmp cx, ax            ;�������� ���� ��������� x (cx) ������ ��� �������� x (ax)
    jae line_done         ;���� ��������� ��� ������� �����, ����� ���������
    push ax
    push bx
    push dx

    mov ah, 0x0C          ;������� ��� ��������� �������
    mov al, 0x0F
    int 0x10              ;���������� BIOS

    pop dx
    pop bx
    pop ax
    inc cx                ;�������
    jmp draw_line         ;������

line_done:
    pop cx
    add dx, 1             ;������� �� ������ ����
    add cx, 1             ;�������� ���������� x �� ���� ������� ������
    dec bx                ;���������� ���������� ������
    jnz triangle_loop     ;���������,

    popa                  ;�������������� ���������
    ret

;���������� ���������� ����� ������������ ������� ������ � ��������� ������
times 510-($-$$) db 0
dw 0xAA55