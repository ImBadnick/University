.data:
  x: .word 3

.text:
  .global main

main: LDR R1,=x
      CMP R1,#0
      BNE case1
      LDR R1,#0
      B fine

case1: CMP R1,#1
       BNE case2
       LDR R1,#10
       B fine

case2: CMP R1,#2
       BNE case3
       LDR R1,#20
       B fine

case3: CMP R1,#3
       BNE default
       LDR R1,#30
       B fine

deflt: LDR R1,#40

fine:  MOV R7,#4
       SVC 0
       MOV R7,#1
       SVC 0
