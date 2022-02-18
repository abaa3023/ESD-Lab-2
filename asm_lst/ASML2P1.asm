  ORG 0000h				Start at location 0
  LJMP BEGIN			Begin from BEGIN
  ORG 000bh				Set up ISR address
  LJMP ISR_BEGIN		Jump to IRQ Handler
BEGIN:
  MOV R0,#6				Counter is set as 6
  MOV TMOD,#01H			Setting bits to start timer
  MOV IE,#82H			Interrupt enable for timer
  MOV TH0,#15H			Setting higher byte as 15H
  MOV TL0,#9FH			Setting lower byte as 9FH -> 159FH = 5535 -> 65535 - 5535 = 60000
  MOV TCON,#10H			Timer control register
  SJMP ENDLOOP			Go to infinite loop
ENDLOOP:
  SJMP ENDLOOP			Infinite loop
ISR_BEGIN:				
  MOV A,R0				Copy R0 value to A		
  SUBB A,#1H			Subtract 1 every time loop runs
  MOV R0,A				Copy back to R0
  JZ TOGGLE				Toggle if R0 is 0
  JNZ RESET				else Reset the timer
TOGGLE:	
  CPL P1.4				Toggle the pin
  MOV TH0,#15H			reset is for reset
  MOV TL0,#9FH
  MOV TCON,#10H
  MOV R0,#6
  RETI
RESET:
  MOV TH0,#15H			Reset functionality
  MOV TL0,#9FH
  MOV TCON,#10H
  RETI
