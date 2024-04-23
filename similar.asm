; Two arrays are called similar if one can be obtained from another by swapping at most one pair of elements in one of the arrays.
; Given two arrays a and b, check whether they are similar. Example: - For a = [1, 2, 3] and b = [1, 2, 3] the output should be areSimilar(a, b) = true.
; The arrays are equal, no need to swap any elements. For a = [1, 2, 3] and b = [2, 1, 3] the output should be areSimilar(a, b) = true.
; We can obtain b from a by swapping 2 and 1 in b. - For a = [1, 2, 2] and b = [2, 1, 1] the output should be areSimilar(a, b) = false.
; Any swap of any two elements either in a or in b won't make a and b equal.

.model small
.stack 100
.data
    ENDLINE            db  13, 10, '$'
    ; Msg
    MSG_NOT_SIMILAR    db  "NOT SIMILAR", 13, 10, '$'
    MSG_IS_SIMILAR     db  "IS SIMILAR", 13, 10, '$'
    ; Arrays
    NUMBER_OF_ELEMENTS equ 5                             ; number of elements in arrays
    array_a            db  9, 7, 2, 4, 5                 ; array of 1 byte elements
    array_b            db  3, 9, 2, 4, 5                 ; array of 1 byte elements

    ; Variables
    mismatch_count     db  0                             ; Count the number of mismaches
    mismatch_a_1       db  0                             ; First mismatch value of array_a
    mismatch_a_2       db  0                             ; Second mismatch value of array_a
    mismatch_b_1       db  0                             ; First mismatch value of array_b
    mismatch_b_2       db  0                             ; Second mismatch value of array_b

.code
main proc
                     mov  ax, @data
                     mov  ds, ax
    ; Main body
                     mov  si, 0                       ; reset index of array to 0
                     xor  ax, ax                      ; clear ax for storing temp value of array_a element
                     xor  bx, bx                      ; clear bx for storing temp value of array_b element

                     mov  cx, NUMBER_OF_ELEMENTS      ; for (si = 0; si < NUMBER_OF_ELEMENTS; si ++)
    check_loop:      
                     mov  al, byte ptr array_a[si]    ; al = array_a[si]. Store to al the value of array_a element at the current si index
                     mov  bl, byte ptr array_b[si]    ; bl = array_b[si]. Store to bl the value of array_b element at the current si index
                     cmp  al, bl
                     jne  not_equal                   ; if al != bl => mismatch detected, jump to not_equal to process

    continue:        
                     inc  si                          ; si ++ to begin next loop with the next index si of arrays
                     loop check_loop                  ; next loop
    ; Done check loop, check if similar or not
                     jmp  check_similar

    not_equal:       
    ; if array_a[si] != array_b[si]
                     inc  mismatch_count              ; Mismatch detected, increase mismatch_count

                     cmp  mismatch_count, 1
                     je   mismatch_count_1            ; First mismatch, store values

                     cmp  mismatch_count, 2
                     je   mismatch_count_2            ; Second mismatch, store values

                     jg   not_similar                 ; More than 2 mismatch => more than 1 swap => not similar

    mismatch_count_1:
                     mov  mismatch_a_1, al
                     mov  mismatch_b_1, bl
                     jmp  continue


    mismatch_count_2:
                     mov  mismatch_a_2, al
                     mov  mismatch_b_2, bl
                     jmp  continue

    check_similar:   
    ; Check if there are mismatch, compare value after swap is equal or not. If there are no mismatch, the list is similar.
                     cmp  mismatch_count, 0
                     je   is_similar                  ; if mismatch_count == 0, there are no mismatch => similar
                     cmp  mismatch_count, 2
                     jne  not_similar                 ; if mismatch_count != 2, mismatch can't be swap => not similar
    ; else Begin check similarity
    ; ..., mismatch_a_1,...,mismatch_a_2,...
    ; ..., mismatch_b_1,...,mismatch_b_2,...
                     mov  dl, mismatch_a_1
                     cmp  dl, mismatch_b_2
                     jne  not_similar

                     mov  dl, mismatch_a_2
                     cmp  dl, mismatch_b_1
                     jne  not_similar
                     jmp  is_similar
                  

    not_similar:     
                     lea  dx, MSG_NOT_SIMILAR
                     mov  ah, 9
                     int  21h
                     jmp  finish

    is_similar:      
                     lea  dx, MSG_IS_SIMILAR
                     mov  ah, 9
                     int  21h
    ;           jmp  finish

    finish:          
    ; end Main body

    ; Terminate program
                     mov  ah, 4ch
                     int  21h
main endp

end main