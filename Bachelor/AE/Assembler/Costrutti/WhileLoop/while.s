.data:
  x: .word 5

.text:
  .global main

main: LDR R1,#0
      LDR R2,=x
loop: CMP R1,R2
      BLE fine
      MOV R7,#4
      SVC 0
      SUB R2,R2,#1
      B loop
fine: MOV R7,#1
      SVC 0
