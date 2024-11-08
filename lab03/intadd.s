.arch armv8-a
.global intadd

intadd:
    
    eor x2, x2, x2    // carry num

loop:
    
    eor x3, x0, x1    // x3 = x0 + x1
    
    
    and x2, x0, x1    // gets carry
    lsl x2, x2, #1    // left shift 

    //sets up next loop, else if carry goes to 0 it just returns the value in the end
    mov x0, x3        
    mov x1, x2        

   
    cbnz x2, loop // compares carry num to zero, if its anything more than 0 it will loop again
    //x0 already has res so dont need to move it in the end
    ret 
