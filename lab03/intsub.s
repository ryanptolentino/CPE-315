    // intsub function in this file

    .arch armv8-a
    .global intsub

   /* Include a register usage plan in this comment before the function
    *   ** or ** give each register a meaningful alias using the syntax:
    * arg0 .req x0
    */

intsub:
    stp x29, x30, [sp, -48]!
    str x19, [sp, 16]
    str x20, [sp, 24]
    str x21, [sp, 32]

    mov x19, x0 // x19 = a
    mov x20, x1 // x20 = b

while:
    cmp x20, 0
    beq endwhile // while b != 0
    mvn x9, x19 // x9 holds the inverted bits of a 
    and x10, x9, x20 // x10 is borrow (borrow = (~a) & b)

    orr x19, x19, x20 // a or with b

    lsl x20, x10, 1 // b = borrow << 1
    
    bl while

endwhile:
    mov x0, x19

    ldr x19, [sp, 16]
    ldr x20, [sp, 24]
    ldr x21, [sp, 32]
    ldp x29, x30, [sp], 48
    ret

