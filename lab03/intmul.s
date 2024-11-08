    // intmul function in this file

    .arch armv8-a
    .global intmul

   /* Include a register usage plan in this comment before the function
    *   ** or ** give each register a meaningful alias using the syntax:
    * arg0 .req x0
    */

intmul:
    stp x29, x30, [sp, -48]!
    str x19, [sp, 16]
    str x20, [sp, 24]
    str x21, [sp, 32]

    mov x19, x0 // x19 is a
    mov x20, x1 // x20 is b
    mov x21, 0 // x21 is result (result = 0)

while:
    cmp x20, 0
    beq endwhile

if:
    and x9, x20, 1 // b & 1
    cmp x9, 1 // if b & 1 = true 
    bne endif
    mov x0, x21 // for the intadd func result = a (parameter)
    mov x1, x19 // for the intadd func a = b (parameter)
    bl intadd

    mov x21, x0 // move the result of result + a to result register

endif:

    lsl x19, x19, 1 // a = a << 1
    lsr x20, x20, 1 // b = b >> 1
    bl while

endwhile:
    mov x0, x21 // move result into return register

    ldr x19, [sp, 16]
    ldr x20, [sp, 24]
    ldr x21, [sp, 32]
    ldp x29, x30, [sp], 48
    ret


