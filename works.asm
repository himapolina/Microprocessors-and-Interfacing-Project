;given right ascension of sun = 10hrs 41min 16s and declination = + 8 deg 18min 17sec
;H = LST - RA
#start= stepper_motor.exe# 


    
    ;given right ascension of sun = 10hrs 41min 16s and declination = + 8 deg 18min 17sec
    ;H = LST - RA
    jmp top
    TOP:
        mov ah, 02ch        ;int 21h service to get system time
        int 21h             ;stores ch=hour, cl=min, dh=second
    
    cmp dh, 16
    ja sub1
    add dh, 60
    sub dh, 16              ;dh stores seconds part of H
    dec cl
    
    next1:
        cmp cl, 41          ;comparing 41 with current minutes
        ja sub2
        add cl, 60
        sub cl, 41          ;cl stores minutes part of H
        dec ch              
    
    next2:
        cmp ch, 10
        ja sub3
        add ch, 24
        sub ch, 10          ;ch stores hours part of H
       
    
    
    sub1:
        sub dh, 16       
        jmp next1
    
    
    sub2:
        sub cl, 41
        jmp next2
    
    sub3:
        sub ch, 10
    next3:
        mov al, ch
        mov bl, 4           ;to convert hours to radians: hours*15*0.2618 = hours*4
        mul bl              ;al=al*bl  al=H in radians
;--------------------------------------------------hour angle calc---------------------------------------------------;


    ;cos(declination) = 0.989
    ;observer's coordinates (somewhere near vellore) latitude = 79, sin(79) = 0.981
        
    ;formula for altitude, a:
    ;sin(a) = sin(declination)*sin(observer's latitude) + cos(declination)*cos(obs lat.)*cos(H)
    ;sin(a) = (13 + 19*cos(H))/100
    
    ;sin(a) = (1 + 2*cos(H) )/10   
    
    ;formula for azimuth A:
    ;sin(A) = -sin(H) * cos(declination)/ cos(a)  = -sin(H) *0.989/cos(a) = -sin(H)/cos(a) approx.
    
    ;cos(H), ch=H    multiplying values with 10
    ;cos(H) = 1 - H^2/2! +....
    
    mov cl, al
    mov ch, 00       ;cx=H
    mov ax, cx       ;ax=H
    mul ax           ;ax=H^2
    mov bx, 2
    
    div bx           ;al=al/2
    mov ah, 00
    mov dx, 10
    mul dx
    mov dx, 10       ;ax=10*H^2/2
    sub dx, ax       ;dx=10 - 10*H^2/2 = 10*cos(H)
    
    mov ax, dx
    mov dx, 00       ;clear dx to avoid error
   
    cmp ax, 10
    jbe next
    mov bx, 0ffffh   ;taking 2's complement to convert negative to positive
    xor ax, bx       
    add ax, 1        ;ax has value of 10*cos(H)
;--------------------------------------------------taylor series----------------------------------------------------;

    ;10*sin(a) = 1 + 2*cos(H)
    next:
        mov bx, 10
        div bx
        mov ah, 00
        mov dx, ax 
        mov bx, 2
        mov ax, dx
        mul bx
        add ax, 1
        ;ax has 10*sin(a)
   
;--------------------------------------------finding 10*sin(a)------------------------------------------------------;
   
                      ;10*sin(a) value in al
    mov ah, 02ch      ;int 21h service to get system time to check if it's morning or afternoon
    int 21h
 
    cmp ch, 15
    jb timeofday
    cmp ch, 18
    jae check1
    mov cl, 6
    jmp rotateStepper
    
    check1:
        mov cl, 8
        jmp rotateStepper
    
    timeofday:                                                                                     
        cmp ch, 12
        jb morning
        jae afternoon
    
    
    
    mov ch, 00
    
 
    
    morning:                           ;refer to table
        cmp al, 3
        jbe case1
        cmp al, 8
        jbe case2
        cmp al, 10
        jbe case3

    case1:
        mov cl, 0
        jmp rotateStepper
    case2:
        mov cl, 1
        jmp rotateStepper
    case3:
        mov cl, 2
        jmp rotateStepper

    
    afternoon:
        cmp al, 3
        jbe case6
        cmp al, 8
        jbe case7
        cmp al, 10
        jbe case8
        jmp case9

    
    case6:
        mov cl, 4
        jmp rotateStepper
    case7:
        mov cl, 3
        jmp rotateStepper
    case8:
        mov cl, 2
        jmp rotateStepper
    case9:
        mov cl, 4
        jmp rotateStepper

;------------------------------steps calculated stored in cl-----------------------------------------------;
    
    rotateStepper:    
   
    mov dh,00h
    jmp start
   
    datcw_fs1 db 0000_0011b
              db 0000_0110b    
              db 0000_0100b
              db 0000_0001b
             
    datcw_fs2 db 0000_0011b
              db 0000_0010b   
              db 0000_0100b
              db 0000_0001b
    
    datcw_fs3 db 0000_0011b
              db 0000_0110b    
              db 0000_0100b
              db 0000_0001b
    
    datcw_fs4 db 0000_0011b
              db 0000_0010b    
             

    ;stepper motor    
    start:
    mov al,00
    mov ah,00
             
    mov al, cl 
    ;steps=dl
    mov dl,al
    mov dh,00h
    mov cx, 0
    
    jmp start1
    
    start1:
    mov bx, offset datcw_fs1        ;start from clock-wise full-step.
    mov si, 0  
    
    next_step:
                                    ;motor sets top bit when it's ready to accept new command
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
    jb  start2
    jmp end
    
    start2:
    mov bx, offset datcw_fs2        ;start from clock-wise full-step.
    mov si, 0 
    
    next_step1:
                                    ;motor sets top bit when it's ready to accept new command
    wait1:   in al, 7     
            test al, 10000000b
            jz wait1
    
    mov al, [bx][si]
    out 7, al
    
    inc si
    
    cmp si, 4
    jb next_step1
    mov si, 0
    
    inc cx
    cmp cx, dx
    jb  start3
    jmp end
    
    start3:
    mov bx, offset datcw_fs3        ;start from clock-wise full-step.
    mov si, 0 
    
    next_step2:
                                    ;motor sets top bit when it's ready to accept new command
    wait2:  in al, 7     
            test al, 10000000b
            jz wait2
    
    mov al, [bx][si]
    out 7, al
    
    inc si
    
    cmp si, 4
    jb next_step2
    mov si, 0
    
    inc cx
    cmp cx, dx
    jb  start4
    jmp end
    
    start4:
    mov bx, offset datcw_fs4        ;start from clock-wise full-step.
    mov si, 0 
    
    next_step3:
                                    ;motor sets top bit when it's ready to accept new command
    wait3:   in al, 7     
            test al, 10000000b
            jz wait3
    
    mov al, [bx][si]
    out 7, al
    
    inc si
    
    cmp si, 2
    jb next_step3
    mov si, 0
    
    inc cx
    cmp cx, dx
    jb  start1
    jmp end
    
    end:
    hlt