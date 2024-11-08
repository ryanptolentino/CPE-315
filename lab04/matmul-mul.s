////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
// void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
//
//  NOTE: This version should use the MUL/MLA and ADD instructions
//
////////////////////////////////////////////////////////////////////////////////

	.arch armv8-a
	.global matmul
matmul:
    stp   x29, x30, [sp, -64]!
    mov x29, sp
    str x19, [sp, 16]
    str x20, [sp, 24]
    str x21, [sp, 32]
    str x22, [sp, 40]
    str x23, [sp, 48]
    str x24, [sp, 56]

    mov x19, x0 // x19 is the result Matrix C
    mov x20, x1 // x20 is the matrix A
    mov x21, x2 // x21 is the matrix B
    mov x22, x3 // x22 is hA
    mov x23, x4 // x23 is wA
    mov x24, x5 // x24 is wB

for1start:
    mov x9, 0 // initialize x9 as i = 0

for1:
    cmp x9, x22
    bge endfor1 

for2start:
    mov x10, 0 // initalize x10 as j = 0

for2:
    cmp x10, x24
    bge endfor2

    mov x11, 0 // initalize sum in x11 and set it to 0

for3start:
    mov x13, 0 // initalize x13 as k = 0

for3:
    cmp x13, x23
    bge endfor3

    mov x14, 4 // this is the size of the integers in an array

    mul x12, x9, x23 // i * wA = x12
    add x12, x12, x13 // x12 [i * wA + k] is the index of the thing we want to modify in A 
    mul x12, x12, x14 // x12 is now the offset for index in A
    add x12, x12, x20 // the space in memory of the index in A is x12

    ldr x12, [x12] // x12 = A[i * wA + k]

    // doing the same but for B
    mul x15, x13, x24 // k * wB = x15
    add x15, x15, x10
    mul x15, x15, x14 // offset
    add x15, x15, x21

    ldr x15, [x15] // x15 = B[k * wB + j]

    mul x12, x12, x15 // x12 = A[i * wA + k] * B[k * wB + j]
    
    add x11, x11, x12 // sum += A[i * wA + k] * B[k * wB + j]

    add x13, x13, 1 // k++
    bl for3

endfor3:

    mul x12, x9, x24 // x12 holds i * wB
    add x12, x12, x10 // i * wB + j this is the index that we want for C
    mul x12, x12, x14 // x12 holds the offset
    add x12, x12, x19 // space in memory we want to store to

    str x11, [x12] // C[i * wB + j] = sum

    add x10, x10, 1 // j++
    bl for2

endfor2:
    add x9, x9, 1 // i++
    bl for1

endfor1:
    ldr x19, [sp, 16]
    ldr x20, [sp, 24]
    ldr x21, [sp, 32]
    ldr x22, [sp, 40]
    ldr x23, [sp, 48]
    ldr x24, [sp, 56]
    ldp x29, x30, [sp], 64
    ret
