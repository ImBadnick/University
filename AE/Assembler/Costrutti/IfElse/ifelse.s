.text:
  .global main

main: LDR R1,#0
      CMP R1,#0
      BNE else
then: ADD R1,R1,#1
      B continue
else: ADD R1,R1,#5
cont: MOV R7,#4
      SVC 0
      MOV R7,#1
      SVC 0
