.model small
.stack 100
.data
    ; 09: tab   13, 10: endline    '$': endstring
    ENDLINE          db 13, 10, '$'
    ENDLINE_x2       db 13, 10, 13, 10, '$'
    MSG_INPUT        db 13, 10, "Please input a number to factorization:", 13, 10, "n = ", '$'
    MSG_OUTPUT       db " = ", '$'
    MSG_NOT_A_NUMBER db 13, 10, "Please input valid number 0-9...", 13, 10, '$'
    MSG_SPACING      db " * ", '$'
    n                dw 0
    n_half           dw 0
.code
main proc
                             mov  ax, @data
                             mov  ds, ax
    ; Input into n
                             call inputDec
    ; Print all prime factors of n
                             call printPrimeFactors
main endp

    ; Print prime factors of n
printPrimeFactors proc
    ; Push all registers
                             push ax
                             push bx
                             push cx
                             push dx
    ; Start finding prime factors
                             lea  dx, ENDLINE_x2
                             mov  ah, 9
                             int  21h

                             mov  ax, n                       ; AX = n, to be devived by 2
                             call outputDec
                             push ax
                             push dx
                             lea  dx, MSG_OUTPUT
                             mov  ah, 9
                             int  21h
                             pop  dx
                             pop  ax
                             mov  cx, n                       ; Holder of n before n/2
                             xor  dx, dx                      ; Remainder = 0
                             mov  bx, 2                       ; Devider = 2
    ; AX = n. We start looping AX/2 untill remainder != 0, so now AX is an odd number
    
    ; Begin div 2
    div_by2:                 
                             mov  cx, ax                      ; Temp holder of n before AX/2
                             div  bx                          ; AX = AX/2; DX = AX%2
    ; check end condition
                             cmp  dx, 0
                             jne  done_div_by2
    ; print bx
                             push ax
                             push dx

                             mov  ax, bx
                             call outputDec

                             lea  dx, MSG_SPACING
                             mov  ah, 9
                             int  21h

                             pop  dx
                             pop  ax
    ; loop back
                             jmp  div_by2
    done_div_by2:            
                             mov  ax, cx                      ; AX%2 != 0 => get back the holder value into AX
    ; End div 2

    ; init variables
                             mov  bx, 1                       ; Devider = 1
    loopFindPrimeFactors:    
    ; inc BX by 2 and begin new loop
                             add  bx, 2                       ; Devider += 2
    ; check loop end condition: BX > n/2
                             cmp  bx, n_half
                             jg   END_loopFindPrimeFactors
    ; Begin loop body
                             xor  dx, dx                      ; Remainder = 0
    ; Begin div BX
    div_byBX:                
                             mov  cx, ax                      ; Temp holder of AX before AX/BX
                             div  bx                          ; AX = AX/BX; DX = AX%BX
    ; check condition
                             cmp  dx, 0
                             jne  not_div_byBX                ; if AX%BX != 0
    ; else
    ; print bx
                             push ax
                             push dx

                             mov  ax, bx
                             call outputDec

                             lea  dx, MSG_SPACING
                             mov  ah, 9
                             int  21h

                             pop  dx
                             pop  ax
    ; loop back
                             jmp  div_byBX
    not_div_byBX:            
                             mov  ax, cx
                             jmp  loopFindPrimeFactors        ; Loop back
    ; End div BX
    
    ; End loop body
    END_loopFindPrimeFactors:
    ; Delele last Spacing
                             mov  ax, 3
                             call delete
    ; Pop all registers
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
    ; Terminate program
                             mov  ah, 4ch
                             int  21h
printPrimeFactors endp

    ; Store input value from keyboard into willdrawn_amount
inputDec proc
    ; Push all registers
                             push ax
                             push bx
                             push cx
                             push dx
         
    beginInput:              
    ; mov  ah, 2
                             lea  dx, MSG_INPUT               ; Show input msg
                             mov  ah, 9
                             int  21h

                             xor  bx, bx                      ; Temp SUM
                             xor  cx, cx
                             mov  ah, 1
                             int  21h
    continueInput:           
    ; Begin Condition for a number: '0' <= input char value (al) <= '9'
                             cmp  al, '0'
                             jnge notANumber
                             cmp  al, '9'
                             jnle notANumber
    ; End Condition for a number: '0' <= input char value (al) <= '9'

    ; Begin Converting input char value into Dec value
                             and  ax, 000fh                   ; Store char value in AX instead of AL
                             push ax                          ; Push char value
                             mov  ax, 10                      ; AX = 10 (For decimal conversion)
                 
                             mul  bx                          ; AX = AX * BX = 10 * SUM
                             mov  bx, ax                      ; BX = AX
                             pop  ax                          ; Pop char value
                             add  bx, ax                      ; BX = 10 * BX + AX
    ; Begin Check End Input condition (Enter)
                             mov  ah, 1
                             int  21h
                             cmp  al, 13                      ; if(input != ENTER)
                             jne  continueInput               ;    continueInput
    ; End Check End Input condition (Enter)
    ; End Converting input char value into Dec value
    ; Store coverted value into willdrawn_amount
                             mov  n, bx
                             mov  ax, n
                             mov  bx, 2
                             div  bx
                             mov  n_half, ax
    ; Pop all registers
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
    ; return proc
                             ret
                 
    notANumber:              
                             lea  dx, MSG_NOT_A_NUMBER        ; Not a number error message
                             mov  ah, 9
                             int  21h
                             jmp  beginInput                  ; Input again
inputDec endp

    ; Print ax to screen
outputDec proc
    ; Push all registers
                             push ax
                             push bx
                             push cx
                             push dx

                             xor  cx, cx                      ; cx = 0 (digit index)
                             mov  bx, 10                      ; bx = 10 (divisor factor)
    divide:                  
                             xor  dx, dx                      ; dx = 0
                             div  bx                          ; quotient ax = ax / bx; remainder dx = ax % bx
                             push dx
                             inc  cx
                             cmp  ax, 0                       ; if(remainder != 0)
                             jne  divide                      ;    divide
                             mov  ah, 2
    show:                    
                             pop  dx
                             or   dl, 30h
                             int  21h
                             loop show
    ; Pop all registers
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
    ; return proc
                             ret
         
outputDec endp

    ; Delete back AX char
delete proc
    ; Push all registers
                             push ax
                             push bx
                             push cx
                             push dx

    ; init variables
                             mov  bx, ax
                             mov  cx, bx
    back:                    
    ; Move cursor back one position
                             mov  dl, 8
                             mov  ah, 2
                             int  21h

    ; Loop back
                             loop back
    ; init variables
                             mov  cx, bx
    fill:                    
    ; Fill space char
                             mov  dl, ' '
                             mov  ah, 2
                             int  21h

    ; Loop back
                             loop fill
    ; Pop all registers
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
    ; return proc
                             ret
delete endp
end main