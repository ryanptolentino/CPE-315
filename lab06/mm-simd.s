////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A
//! @param wB         width of matrix B
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[j * wB + k];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////

/*
 * Assumptions needed to make for this program to work:
 *    1. Matrix M is in row major order
 *    2. Matrix N is in column major order
 *    3. Both M and N have equal heights and widths i.e. Square Matrix
 *    4. Both M and N have a total size that is divisible by 4
 *
 * Argument Registers:
 * x0: Return matrix address
 * x1: Matrix A address
 * x2: Matrix B address
 * x3: hA
 * x4: wA
 * x5: wB
 */

.arch armv8-a
.global matmul

matmul:
    stp   x29, x30, [sp, -16]!  // frame pointer and return address.
    mov   x29, sp               // frame pointer.

    mov   x9, 0                 
loop_i:
    cmp   x9, x3                //  i and hA comparison
    bge   endloop_i             // exit loop 

    mov   x10, 0                // column index for matrix B (and C).
loop_j:
    cmp   x10, x5               // j with wB.
    bge   endloop_j             
    dup    v0.4S, wzr           // zro out for dot product.

    // base address for the row of A and column of B for current iteration.
    mul    x6, x9, x4           
    lsl    x6, x6, #2            
    add    x11, x1, x6           

    mul    x7, x10, x4           // column offset for B 
    lsl    x7, x7, #2            // byte offset.
    add    x12, x2, x7           // address for the column of B.

    mov    x13, 0              
loop_k:
    cmp    x13, x4              // check end of row/column.
    bge    endloop_k            // end loop

    // load 4 nums from row of A and  column of B.
    ld1    {v1.4S}, [x11], #16 
    ld1    {v2.4S}, [x12], #16  

    mla    v0.4S, v1.4S, v2.4S  // multiply and add

    add    x13, x13, 4         // next 4 nums.
    b      loop_k

endloop_k:
    // address to store the result in C.
    mul    x6, x9, x5           // offset in C.
    add    x6, x6, x10          // column offset in C.
    lsl    x6, x6, #2           // byte offset.
    add    x6, x0, x6           

    addv   s0, v0.4S            // add nums in v0.
    str    s0, [x6]             // store the sum in C.

    add    x10, x10, 1         // add 
    b      loop_j

endloop_j:
    add    x9, x9, 1           // add 
    b      loop_i

endloop_i:
    ldp    x29, x30, [sp], 16  // Restore frame pointer and return address.
    ret
