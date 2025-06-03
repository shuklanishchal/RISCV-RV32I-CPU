.extern main
.text
.globl start

start:
    addi sp, sp, -16  # Allocate space on the stack
    sw ra, 12(sp)     # Save return address
    call main
    # Return preparation
    lw ra, 12(sp)     # Restore return address
    addi sp, sp, 16   # Deallocate stack space
    ebreak