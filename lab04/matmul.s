.arch armv8-a
.global matmul
.extern intadd
.extern intmul

matmul:
    // Save the frame pointer and return address, then allocate space on the stack for local variables
    stp   x29, x30, [sp, -96]!
    mov   x29, sp
    // Store callee-saved registers that will be used in the function
    str   x19, [sp, 16]
    str   x20, [sp, 24]
    str   x21, [sp, 32]
    str   x22, [sp, 40]
    str   x23, [sp, 48]
    str   x24, [sp, 56]


    mov   x19, x0 // Result matrix C
    mov   x20, x1 // Matrix A
    mov   x21, x2 // Matrix B
    mov   x22, x3 // Height of matrix A (hA)
    mov   x23, x4 // Width of matrix A (also height of B, wA/hB)
    mov   x24, x5 // Width of matrix B (wB)

    // Initialize loop counter for the outer loop
    mov   x25, 0
for1:
    // Outer loop: iterate over rows of A
    cmp   x25, x22 // Compare current row index with height of A
    bge   endfor1 // Break loop if all rows processed

    // Initialize loop counter for the middle loop j
    mov   x26, 0
for2:
    // Middle loop: iterate over columns of B
    cmp   x26, x24 // Compare current column index with width of B
    bge   endfor2 // Break loop if all columns processed
    eor   x28, x28, x28 // Reset sum for the dot product calculation

    // Initialize loop counter for the inner loop
    mov   x27, 0
for3:
    // Inner loop: perform dot product of row of A and column of B
    cmp   x27, x23 // Compare current index with width of A
    bge   endfor3 // Break loop if end of row/column reached

    // Calculate address of the current element of A
    mov   x0, x25
    mov   x1, x23
    bl    intmul // Multiply row index by width of A
    mov   x2, x0
    mov   x0, x2
    mov   x1, x27
    bl    intadd // Correct: use x27 instead of x13
    lsl   x0, x0, #2 // Left shift to get byte offset

    add   x0, x20, x0 // Correct: Directly add base address of A and offset

    ldr   x2, [x0] // Load the element from A

    // Calculate address of the current element of B
    mov   x0, x27
    mov   x1, x24
    bl    intmul // Multiply row index (in B) by width of B
    mov   x3, x0
    mov   x0, x3
    mov   x1, x26
    bl    intadd // Correct: use x26 instead of x10

    lsl   x0, x0, #2 // Correct: Use left shift instead of 'mul' for byte offset

    add   x0, x21, x0 // Correct: Directly add base address of B and offset

    ldr   x3, [x0] // Load the element from B

    // Multiply elements of A and B, then add to the sum
    mov   x0, x2
    mov   x1, x3
    bl    intmul
    mov   x2, x0
    mov   x0, x28
    mov   x1, x2
    bl    intadd
    mov   x28, x0 // Update sum

    // Increment k
    mov   x0, x27
    mov   x1, 1
    bl    intadd
    mov   x27, x0
    b     for3
endfor3:
    
    // Store the computed sum in the result matrix C
    mov   x0, x25
    mov   x1, x24
    bl    intmul
    mov   x2, x0
    mov   x0, x2
    mov   x1, x26
    bl    intadd

    lsl   x0, x0, #2 // Correct: Use left shift instead of 'mul' for byte offset

    add   x0, x19, x0 // Correct: Directly add base address of C and offset
    
    str   x28, [x0] // Correct: Store x28 (sum) in C, not x11

    // Increment j
    mov   x0, x26
    mov   x1, 1
    bl    intadd
    mov   x26, x0
    b     for2
endfor2:
   
    // Increment i
    mov   x0, x25
    mov   x1, 1
    bl    intadd
    mov   x25, x0
    b     for1
endfor1:
    // Restore saved registers and deallocate stack space
    ldr   x19, [sp, 16]
    ldr   x20, [sp, 24]
    ldr   x21, [sp, 32]
    ldr   x22, [sp, 40]
    ldr   x23, [sp, 48]
    ldr   x24, [sp, 56]
    ldp   x29, x30, [sp], 96 // Correct: Deallocation size should match allocation size
    ret
