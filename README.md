# Практическая работа №1
## Берля Владислав Денисович, НМТ-313901
``` assembly language
org 0x7C00

jmp start

msg db "Berlya Vladislav", 0
msg2 db "Denisovich NMT-313901", 0


;Настройка сегмента стека
start:
    cli                 ;Отключение прерывания
    mov ax, 0           ;Инициализация сегмента стека
    mov ss, ax
    mov sp, 0xFFFF      ;Установка указателя стека на верх
    sti                 ;Включить прерывания

    mov ax, 0x13        ; Переключение в режим 320x200 256-цвета
    int 0x10
    mov ax, 0x0010      ; Установка графического режима текста
    int 0x10

    ;Рисование равностороннего треугольника
    mov cx, 100          ;Х координата в левой половине экрана
    mov dx, 150          ;Y
    mov bx, 130          ;Высота
    call draw_triangle


    ; Установка цвета фона
    mov ah, 0x0B        ;Функция для установки цвета фона
    mov bl, 0x08
    int 0x10

    ;Вывод текста
    mov ah, 0x13        ;Функция, реализующая вывод текста
    mov al, 0
    mov bh, 0
    mov bl, 14
    mov dl, 59          ;Колонка
    mov dh, 11          ;Строка
    push cs
    pop es
    mov bp, msg
    mov cx, 16          ;Длина
    int 0x10

    mov ah, 0x13        ;Функция, реализующая вывод текста
    mov al, 0
    mov bh, 0
    mov bl, 14
    mov dl, 59          ;Колонка
    mov dh, 12          ;Строка
    push cs
    pop es
    mov bp, msg2
    mov cx, 21          ;Длина
    int 0x10

hang:
    jmp hang


 ;Функция для рисования равностороннего треугольника
 ;cx - начальная x координата
 ;dx - начальная y координата
 ;bx - высота треугольника

draw_triangle:
    pusha
    mov bp, cx            ;bp сохраним оригинал x координаты для сравнения
 ;Цикл отрисовки треугольника
triangle_loop:
    push cx
    mov ax, bx            ;ax
    shr ax, 1
    sub cx, ax            ;Вычитание
    add ax, bp            ;Сложение

;Рисование горизонтальной линии
draw_line:
    cmp cx, ax            ;Проверка если начальный x (cx) меньше чем конечный x (ax)
    jae line_done         ;Если достигнут или пройден конец, линия закончена
    push ax
    push bx
    push dx

    mov ah, 0x0C          ;Функция для отрисовки пикселя
    mov al, 0x0F
    int 0x10              ;Прерывание BIOS

    pop dx
    pop bx
    pop ax
    inc cx                ;Переход
    jmp draw_line         ;Повтор

line_done:
    pop cx
    add dx, 1             ;Переход на строку выше
    add cx, 1             ;Смещение начального x на один пиксель вправо
    dec bx                ;Уменьшение оставшейся высоты
    jnz triangle_loop     ;Континуум,

    popa                  ;Восстановление регистров
    ret

;Заполнение оставшейся части загрузочного сектора нулями и волшебным числом
times 510-($-$$) db 0
dw 0xAA55
```
