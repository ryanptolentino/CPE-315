/*
 * This file contains a stub implementation of the intadd function that uses
 *  the add instruction.  Use this to test your matrix multiplication code.
 *  Once your matrix code works replace this with your intadd from lab3.
 *  If your intadd is not working you can use the intadd implementation provided
 *  by the instructor.  If you profile / submit using this stub version
 *  of intadd you will get a 0 for the corresponding portion of lab4.
 */

    .arch armv8-a
    .global intadd

   /* Include a register usage plan in this comment before the function
    *   ** or ** give each register a meaningful alias using the syntax:
    * arg0 .req x0
    */

intadd:

    stp   x29, x30, [sp, -64]!
    mov x29, sp
    str x19, [sp, 16]
    str x20, [sp, 24]
    str x21, [sp, 32]
    str x22, [sp, 40]
    str x23, [sp, 48]

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    
    eor x21, x21, x21    // carry num

loop:
    
    eor x22, x19, x20    // x3 = x0 + x1
    
    
    and x21, x19, x20    // gets carry
    lsl x21, x21, #1    // left shift 

    //sets up next loop, else if carry goes to 0 it just returns the value in the end
    mov x19, x22        
    mov x20, x21        

   
    cbnz x21, loop // compares carry num to zero, if its anything more than 0 it will loop again
    //x0 already has res so dont need to move it in the end

    mov x0, x19

    ldr x19, [sp, 16]
    ldr x20, [sp, 24]
    ldr x21, [sp, 32]
    ldr x22, [sp, 40]
    ldr x23, [sp, 48]
    ldp x29, x30, [sp], 64
    ret
