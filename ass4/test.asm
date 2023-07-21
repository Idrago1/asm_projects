;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Ivan Nguyen
; Email: inguy038@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 23
; TA: Menthi Wu
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R4
;=================================================================================


.ORIG x3000			
;-------------
;Instructions
;-------------


BACK_AT_ONE 		


LD R5,ZERO		    ;Set these valuse to zero to restart them 
LD R4,ZERO			
LD R3,ZERO			
LD R6,COUNTER       ;set counter


;INTRO MESSAGE
LD R0, introPromptPtr
PUTS


WHILE_LOOP
    GETC		;input char to R0, send it to output_char
    ADD R1,R0,#0
    LD R7,NEGNEWLINE
    ADD R1,R1,R7
    BRnp OUTPUT

OUTPUT		;echo char in R0
    OUT		
    BR INPUT_CHAR	;send to input_char

INPUT_CHAR		;sends inputted number to r5

    ADD R2,R0,#0	
    LD R7,zero		
    ADD R2,R2,R7	
    BRz END_OF_THE_WORLD	; if it is a enter 
    LD R2,zero
    
    ADD R1,R0,#0	
    LD R7,OPP_ZERO	
    ADD R1,R1,R7	
    BRn OTHER_CHAR	;if it is less than 0

    ADD R1,R0,#0	
    LD R7,OPP_NINE		
    ADD R1,R1,R7	
    BRp INVALID_CHAR	;it is greater then 9 


    ADD R1,R6,#0	;copy counter to r1
    ADD R1,R1,#-6	;subtracr 6 from counter. if zero, then only 1 char been input so far
    BRz FIRST_CHAR

    ADD R5,R5,R5	;to multiply r5 by 10. r5 = 2x
    ADD R2,R5,R5	
    ADD R2,R2,R2	
    ADD R5,R5,R2	


    LD R7,OPP_ZERO		;load -48 to convert to decimal
    ADD R0,R0,R7	
    ADD R5,R5,R0
    
    ADD R6,R6,#-1	;decrement counter
    BRp WHILE_LOOP		;if not zero, go back for more inputs
    BRz CHECK_NEG	;if zero, then we have max inputs and go to check if we need to


FIRST_CHAR
    LD R7,OPP_ZERO
    ADD R0,R0,R7	    ;convert to dec
    ADD R5,R0,R5	    
    ADD R6,R6,#-2	    ;minus by 1, and then another because of lack of sign bit
    BR WHILE_LOOP		;get next input


OTHER_CHAR
			            ;check if positive symbol
    LD R7,PLUS		    ;load (reverse) plus ascii to check
    ADD R1,R0,#0	    
    ADD R1,R1,R7	    
    BRz PLUS_CHAR	    ;if zero, then it is a plus symbol

			            ;check if minus symbol
    LD R7,MINUS		    ;load (reverse) minus ascii to check
    ADD R1,R0,#0	    
    ADD R1,R1,R7    	
    BRz MINUS_CHAR	    ;if zero, then it is a minus symbol
    
			            ;check if newline symbol
    LD R7,NEGNEWLINE	;load (reverse) newline ascii to check 
    ADD R1,R0,#0	
    ADD R1,R1,R7	    ;add to see if same
    BRz NEWLINE_INPUT	;if zero, then it is a newline. send to NEWLINE_INPUT


INVALID_CHAR
	;this is an error becuase it should never be greater than 57
    ADD R1,R0,#0
    ADD R1,R1,#-10
    BRnp ERROR_MESSAGE


ERROR_MESSAGE
    LD R0,NEWLINE
    OUT
    LD R0,errorMessagePtr	;print error message 
    PUTS
    BR BACK_AT_ONE 	;start over

PLUS_CHAR
			            ;check if first char
    ADD R1,R6,#0	    ;copy counter to r1
    ADD R1,R1,#-6	    ;subtract 6 from counter
    BRnp INVALID_CHAR	;if not zero, then it's not the first char. send to error
    
		        	;if zero, then continue: this is the first char
    ADD R4,R4,#0	
    ADD R3,R3,#1	;flag for sign bit = 1
    ADD R6,R6,#-1	;decrement counter
    BR WHILE_LOOP		;send to get next input

MINUS_CHAR 
    ADD R1,R6,#0	
    ADD R1,R1,#-6	
    BRnp INVALID_CHAR	;if not zero, then it's not the first char. send to error
	
    ADD R4,R4,#1	
    ADD R3,R3,#1	
    ADD R6,R6,#-1	
    BR WHILE_LOOP		;send to get next input

NEWLINE_INPUT

    ADD R1,R6,#0	
    ADD R1,R1,#-6	;subtract 6 from counter
    BRz INVALID_CHAR
    

    ADD R1,R6,#0	
    ADD R1,R1,#-5	;subtract 5 from counter
    BRnp CHECK_NEG	;if not zero check if its negitive 

    ;check symbol
    ADD R1,R3,#0
    ADD R1,R1,#-1
    BRz INVALID_CHAR	;if value is 0, symbol was 1 and 1st char is a sign followed by newline
    BRnp CHECK_NEG	;if symbol bit is 0 then continue

MAKE_NEG
    NOT R5,R5
    ADD R5,R5,#1
    ld r4 , ZERO
    ld r7 , ZERO
    add r7 , r7,r5
    add r4 , r4, r5
    BR END_OF_THE_WORLD

CHECK_NEG
    ADD R1,R4,#0	;copy sign bit to r1
    ADD R1,R1,#-1	
    BRz MAKE_NEG	;if zero its negitive if not move on 
    
    

END_OF_THE_WORLD
    ld r4 , ZERO
    ld r7 , ZERO
    add r7 , r7,r5
    add r4 , r4, r5
    LD R0,NEWLINE 
    OUT


HALT
;---------------	
;Program Data
;---------------

DEC_0 .FILL #0
DEC_10 .FILL #9
COUNTER .FILL #6

OPP_ZERO .FILL #-48    ;negitive ascii valuse for 0
OPP_NINE .FILL #-57    ;negitive ascii valuse for 9

PLUS .FILL #-43     ;negitive ascii valuse for +
MINUS .FILL #-45    ;negitive ascii valuse for -

NEWLINE .FILL #10           ;ascii valuse for newline
NEGNEWLINE .FILL #-10       ;negitive ascii valuse for newline

ZERO .fill #0

introPromptPtr .FILL xB000
errorMessagePtr .FILL xB200
.END
;------------
;Remote data
;------------
.ORIG xB000

 .STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
.END


.ORIG xB200	
 .STRINGZ	"ERROR: invalid input\n"

;---------------
;END of PROGRAM
;---------------
.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
