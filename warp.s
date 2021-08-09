; warping background display
; (c) alan lowe, 1997

          OPT       pass
.return   EQUD      0
.stack    EQUD      stack%
.screen   EQUD      screen_base%
.sint     EQUD      sine_table%
.cost     EQUD      cosine_table%
.texture  EQUD      texture%
.num287   EQUD      287

.start    STR       r14,return
          LDR       r12,stack
          MOV       r0,#32
          MOV       r1,#0
          MOV       r2,#0
.loop     LDR       r11,screen
          CMP       r4,#1
          ;ADDEQ     r11,r11,#81920
          ADD       r9,r1,r1,LSL #2
          ADD       r9,r11,r9,LSL #6
          BL        getxandy
          STRB      r10,[r9,r0]
          ADD       r0,r0,#1
          LDR       r5,num287
          CMP       r0,r5
          BLT       loop
          MOV       r0,#32
          ADD       r1,r1,#1
          CMP       r1,#255
          BLT       loop
          ADD       r2,r2,#4
          MOV       r1,#0
          CMP       r2,#356
          BLE       loop
.finish   LDR       r15,return

; on entry r0=x , r1=y , r2=wobble factor
; on exit  r10=colour

.getxandy STMIA     r12!,{r14,r0-r9,r11}
          LDR       r11,sint
          ADD       r3,r0,r2
          MOV       r3,r3,LSL #2
          LDR       r4,[r11,r3]
          MUL       r3,r4,r1
          MOV       r3,r3,LSR #8
          ADD       r8,r3,r0  ;         r8=x coordinate
          LDR       r11,cost
          ADD       r3,r1,r2
          MOV       r3,r3,LSL #2
          LDR       r4,[r11,r3]
          MUL       r3,r4,r0
          MOV       r3,r3,LSR #8
          ADD       r9,r3,r1  ;         r9=y coordinate

          MOV       r0,#320
          MOV       r1,#0
          MOV       r2,#255

          MOV       r8,r8,LSR #1
          MOV       r9,r9,LSR #1

          LDR       r11,texture
          ADD       r11,r11,#56

          ADD       r7,r9,r9,LSL #2
          ADD       r7,r11,r7,LSL #6
          LDRB      r10,[r7,r8]

          LDMDB     r12!,{r0-r9,r11,PC}
