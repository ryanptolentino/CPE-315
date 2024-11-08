    // Template main.s file for Lab 3
    // Jonathan Flores & Ryan Tolentino


.text

    .arch armv8-a



    

.global main

   /* Include a register usage plan in this comment before the function
    *   ** or ** give each register a meaningful alias using the syntax:
    * arg0 .req x0
    *
    * If you add additional functions remember to include register usage
    * plans for them as well.
    */



// Register aliases
input1 .req x20
input2 .req x21
operation .req w22
result .req x23
.equ SYS_READ, 0x00
main:
    // driver function main lives here, modify this for your other functions




    // You'll need to scan characters for the operation and to determine
    // if the program should repeat.
    // To scan a character, and compare it to another, do the following

    
    stp x29, x30, [sp, -16]!  // Stack frame 
    mov x29, sp

loop: 
    sub sp, sp, #16  // Allocate 16 bytes for input1 and input2

    // Enter num1 prompt and then storing in input1 
    ldr x0, =string1
    bl printf
    ldr x0, =scanint
    add x1, sp, #0   // address for input1
    bl scanf
   
    ldr input1, [sp] // load input1 from stack
    
   



    // Enter num2 prompt and then storing in input2 
    ldr x0, =string2
    bl printf
    ldr x0, =scanint
    add x1, sp, #8   // address for input2
    bl scanf

    
    ldr input2, [sp, #8] // load input2 from stack
    


    // Prompt for operation and then storing it
    ldr x0, =string3
    bl printf
    ldr x0, =scanchar
    mov x1, sp
    bl scanf
   
    ldrb operation, [sp]

    // Perform the operation
    cmp operation, '+'      //  if operation is addition
    beq add
    cmp operation, '-'      //  if operation is subtraction
    beq sub
    cmp operation, '*'      //  if operation is multiplication
    beq mult


    b invalid_operation      // else go to invalid_operation

//TEMP FUNCS JUST TO GET MAIN WORKING. 
// cheers my friend. Codington city? replace with actual funcs 

add:        
    mov x0, input1
    mov x1, input2
    bl intadd
    mov result, x0

    b print_result

sub:
    sub result, input1, input2
    b print_result

mult:
    mov x0, input1
    mov x1, input2
    bl intmul
    mov result, x0
    
    b print_result

invalid_operation:
  
    ldr x0, =string_invalid_op
    bl printf
    bl clear_buffer
    b repeat

  

invalid_response:
    
    ldr x0, =string_invalid_response
    bl printf 
    bl clear_buffer
    b repeat
    

print_result:

    //WHEN FUNCS ADDED CHANGE SO THAT IT MOVES THE RESULT FROM THE FUNC INTO THE CORRECT REGISTER FOR PRINT


    ldr x0, =string4    // Load address of format string
    mov x1, result      // Move result to x1
    bl printf           // Call printf
    b repeat

repeat:
   
    ldr x0, =string5 // prints out "Again?"" part 
    bl printf
    ldr x0, =scanchar

    add x1, sp, #16  // use separate space for response to avoid overwriting EDIET1

    mov x1, sp
    bl scanf
    ldrb w0, [sp] // checks for y
    cmp w0, 'y'
    beq loop_cleanup

    cmp w0, 'n'
    beq endloop

    b invalid_response

loop_cleanup:
    add sp, sp, #16  // Deallocate 32 bytes before looping
    b loop


endloop:

    // Exit loop 
    add sp, sp, #16  // Deallocate 16 bytes
    ldp x29, x30, [sp], 16
    ret



clear_buffer:
    mov x0, #0          
    mov x1, sp         
    mov x2, #1          // number of characters to read
read_char:
    mov x8, #SYS_READ  // 'SYS_READ' 
    svc 0              // system call
    cmp x0, #1         //  character was read
    bne exit_clear      // exit the clear_buffer function
    ldrb w1, [sp]      // load the read character into w1
    cmp w1, #10         //check if it's newline ('\n')
    bne read_char       // if it's not a newline, read the next character
exit_clear:
    ret                 // return from clear_buffer




yes:
    .byte   'y'

no:
    .byte   'n'

scanchar:
    .asciz  " %c"

scanint:
    .asciz " %ld"






.data
string1:
    .asciz "Enter Number 1: "

string2:
    .asciz "Enter Number 2: "

string3:
    .asciz "Enter Operation: "

string4:
    .asciz "Result is: %d\n"

string5:
    .asciz "Again? "

string_invalid_op:
    .asciz "Invalid Operation Entered."

string_invalid_response:
    .asciz "Invalid Response."


