#start=stepper_motor.exe#



mov ah, 02ch               ;int 21h service to get system time
int 21h                    ;stores ch=hour, cl=min, dh=second

cmp ch, 7
jbe case1
cmp ch, 10
jbe case2
cmp ch, 13
jbe case3
cmp ch, 16
jbe case4
jmp case5

case1:
    mov dx, 0
    jmp start
case2:
    mov dx, 1
    jmp start
case3:
    mov dx, 2
    jmp start
case4:
    mov dx, 3
    jmp start
case5:
    mov dx, 4
    jmp start               ;dx has number of steps i.e. angle
    
datcw    db 0000_0110b      ;6
         db 0000_0100b      ;4
         db 0000_0011b      ;3
         db 0000_0010b      ;2   
         
         
         
start:
mov bx, offset datcw        ; start from clock-wise half-step.
mov si, 0
mov cx, 1                   ; step counter
cmp cx, dx
ja stop


next_step:
                            ; motor sets top bit when it's ready to accept new command
wait:   in al, 7     
        test al, 10000000b
        jz wait

mov al, [bx][si]
out 7, al

inc si

cmp si, 4
jb next_step
mov si, 0

inc cx
cmp cx, dx
jbe  next_step
hlt

stop:
    hlt
 