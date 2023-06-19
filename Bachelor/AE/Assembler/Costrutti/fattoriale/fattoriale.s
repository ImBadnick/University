.data:
    x: .word 5

.text:
    .global main


main: MOV R0,#0
      LDR R1,=x
      LDR R1,[R1]
      BL fatt

fatt: CMP R1,#0
      BNE loop
      MOV R1,#1
      MOV PC,LR
      

loop: PUSH{LR}
      SUB R1,R1,#1
      BL fatt
      POP{LR}
      MUL R0,R0,R1
      mov PC,LR

