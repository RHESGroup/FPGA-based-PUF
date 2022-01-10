     .globl   st_serial
     .p2align 2
     .type    st_serial,%function

st_serial:                     // Function "myadd" entry point.
     .fnstart
     BKPT   // Function arguments are in R0 and R1. Add together and put the result in R0.
     rev r0, r0
     bx       lr           // Return by branching to the address in the link register.
     .fnend
