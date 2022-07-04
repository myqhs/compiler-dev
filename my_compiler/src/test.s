          .text                         
          .globl main                   
          .align 2                      
          .data                         
          .global x                     
          .size x, 4                    
x:                                      
          .word 10000000                
          .data                         
          .global BB                    
          .size BB, 16                  
BB:                                     
          .zero 16                      
          .data                         
          .global a                     
          .size a, 4                    
a:                                      
          .zero 4                       

          .text                         
_f:                                     # function entry
          sw    ra, -4(sp)              
          sw    fp, -8(sp)              
          mv    fp, sp                  
          addi  sp, sp, -8              
__LL0:                                  
                                  #      T0 = LOAD_SYMBOL a
          la    t0, a                   
                                  #      T1 = LOAD T0, 0
          lw    t1, 0(t0)               
                                  #      T2 <- 1
          li    t2, 1                   
                                  #      T3 <- (T1 + T2)
          add   s1, t1, t2              
                                  #      T4 = LOAD_SYMBOL a
          la    s2, a                   
                                  #      STORE T3 -> T4, 0
          sw    s1, 0(s2)               
                                  #      T5 = LOAD_SYMBOL a
          la    s3, a                   
                                  #      T6 = LOAD T5, 0
          lw    s4, 0(s3)               
          mv    a0, s4                  
          mv    sp, fp                  
          lw    ra, -4(fp)              
          lw    fp, -8(fp)              
          ret                           

          .text                         
_g:                                     # function entry
          sw    ra, -4(sp)              
          sw    fp, -8(sp)              
          mv    fp, sp                  
          addi  sp, sp, -8              
__LL1:                                  
          lw    t0, 8(fp)               # load T10 from (fp+8) into t0
          mv    a0, t0                  
          mv    sp, fp                  
          lw    ra, -4(fp)              
          lw    fp, -8(fp)              
          ret                           

          .text                         
main:                                   # function entry
          sw    ra, -4(sp)              
          sw    fp, -8(sp)              
          mv    fp, sp                  
          addi  sp, sp, -12             
__LL2:                                  
                                  #      T13 = ALLOC 16
                                  #      T14 <- 1
          li    t0, 1                   
                                  #      T15 <- 1
          li    t1, 1                   
                                  #      T16 <- 2
          li    t2, 2                   
                                  #      T17 <- (T14 * T16)
          mul   s1, t0, t2              
                                  #      T18 <- (T17 + T15)
          add   s2, s1, t1              
                                  #      T19 <- 4
          li    s3, 4                   
                                  #      T20 <- (T18 * T19)
          mul   s4, s2, s3              
                                  #      T21 <- 0
          li    s5, 0                   
                                  #      T22 = LOAD_SYMBOL BB
          la    s6, BB                  
                                  #      T23 <- (T22 + T20)
          add   s7, s6, s4              
                                  #      STORE T21 -> T23, 0
          sw    s5, 0(s7)               
                                  #      T24 = CALL _f
          mv    s8, zero                # initialize T34 with 0
          sw    s8, -4(sp)              
          mv    s9, zero                # initialize T31 with 0
          sw    s9, -8(sp)              
          mv    s10, zero               # initialize T28 with 0
          sw    s10, -12(sp)            
          mv    s11, zero               # initialize T27 with 0
          sw    s11, -16(sp)            
          mv    t3, zero                # initialize T26 with 0
          sw    t3, -20(sp)             
          mv    t4, zero                # initialize T25 with 0
          sw    t4, -24(sp)             
          mv    t5, zero                # initialize T24 with 0
          sw    t5, -28(sp)             
          addi  sp, sp, -28             
          call  _f                      
          addi  sp, sp, 28              
          lw    s8, -4(sp)              
          lw    s9, -8(sp)              
          lw    s10, -12(sp)            
          lw    s11, -16(sp)            
          lw    t3, -20(sp)             
          lw    t4, -24(sp)             
          lw    t5, -28(sp)             
          mv    t5, a0                  
                                  #      T25 = CALL _f
          sw    s8, -4(sp)              
          sw    s9, -8(sp)              
          sw    s10, -12(sp)            
          sw    s11, -16(sp)            
          sw    t3, -20(sp)             
          sw    t4, -24(sp)             
          sw    t5, -28(sp)             
          addi  sp, sp, -28             
          call  _f                      
          addi  sp, sp, 28              
          lw    s8, -4(sp)              
          lw    s9, -8(sp)              
          lw    s10, -12(sp)            
          lw    s11, -16(sp)            
          lw    t3, -20(sp)             
          lw    t4, -24(sp)             
          lw    t5, -28(sp)             
          mv    t4, a0                  
                                  #      T26 = CALL _f
          sw    s8, -4(sp)              
          sw    s9, -8(sp)              
          sw    s10, -12(sp)            
          sw    s11, -16(sp)            
          sw    t3, -20(sp)             
          sw    t4, -24(sp)             
          sw    t5, -28(sp)             
          addi  sp, sp, -28             
          call  _f                      
          addi  sp, sp, 28              
          lw    s8, -4(sp)              
          lw    s9, -8(sp)              
          lw    s10, -12(sp)            
          lw    s11, -16(sp)            
          lw    t3, -20(sp)             
          lw    t4, -24(sp)             
          lw    t5, -28(sp)             
          mv    t3, a0                  
                                  #      PARAM T24
                                  #      PARAM T25
                                  #      PARAM T26
                                  #      T27 = CALL _g
          sw    s8, -4(sp)              
          sw    s9, -8(sp)              
          sw    s10, -12(sp)            
          sw    s11, -16(sp)            
          addi  sp, sp, -16             
          addi  sp, sp, -12             
          sw    t3, 8(sp)               
          sw    t4, 4(sp)               
          sw    t5, 0(sp)               
          call  _g                      
          addi  sp, sp, 28              
          lw    s8, -4(sp)              
          lw    s9, -8(sp)              
          lw    s10, -12(sp)            
          lw    s11, -16(sp)            
          mv    s11, a0                 
                                  #      T12 <- T27
          mv    t6, s11                 
                                  #      T28 = CALL _f
          sw    s8, -4(sp)              
          sw    s9, -8(sp)              
          sw    s10, -12(sp)            
          sw    t6, -16(sp)             
          addi  sp, sp, -16             
          call  _f                      
          addi  sp, sp, 16              
          lw    s8, -4(sp)              
          lw    s9, -8(sp)              
          lw    s10, -12(sp)            
          lw    t6, -16(sp)             
          mv    s10, a0                 
                                  #      T29 <- 0
          li    t0, 0                   
                                  #      T30 <- (T28 == T29)
          sub   t1, s10, t0             
          seqz  t1, t1                  
                                  #      T31 = CALL _f
          sw    s8, -4(sp)              
          sw    s9, -8(sp)              
          sw    t1, -12(sp)             
          sw    t6, -16(sp)             
          addi  sp, sp, -16             
          call  _f                      
          addi  sp, sp, 16              
          lw    s8, -4(sp)              
          lw    s9, -8(sp)              
          lw    t1, -12(sp)             
          lw    t6, -16(sp)             
          mv    s9, a0                  
                                  #      T32 <- 1
          li    t0, 1                   
                                  #      T33 <- (T31 == T32)
          sub   t2, s9, t0              
          seqz  t2, t2                  
                                  #      T34 = CALL _f
          sw    s8, -4(sp)              
          sw    t2, -8(sp)              
          sw    t1, -12(sp)             
          sw    t6, -16(sp)             
          addi  sp, sp, -16             
          call  _f                      
          addi  sp, sp, 16              
          lw    s8, -4(sp)              
          lw    t2, -8(sp)              
          lw    t1, -12(sp)             
          lw    t6, -16(sp)             
          mv    s8, a0                  
                                  #      T35 <- 2
          li    t0, 2                   
                                  #      T36 <- (T34 == T35)
          sub   s1, s8, t0              
          seqz  s1, s1                  
                                  #      T37 <- (T33 && T36)
          snez  t0, t2
          sub   t0, zero, t0
          and   t0, t0,s1
          snez  t0, t0
                                  #      T38 <- (T30 || T37)
          or    t2, t1,t0
          snez  t2, t2
                                  # (save modified registers before control flow changes)
          sw    t6, -12(fp)             # spill T12 from t6 to (fp-12)
          beqz  t2, __LL4               
          j     __LL3                   
__LL3:                                  
          lw    t0, -12(fp)             # load T12 from (fp-12) into t0
          mv    a0, t0                  
          mv    sp, fp                  
          lw    ra, -4(fp)              
          lw    fp, -8(fp)              
          ret                           
__LL4:                                  
                                  #      T39 = LOAD_SYMBOL a
          la    t0, a                   
                                  #      T40 = LOAD T39, 0
          lw    t1, 0(t0)               
          mv    a0, t1                  
          mv    sp, fp                  
          lw    ra, -4(fp)              
          lw    fp, -8(fp)              
          ret                           
