TITLE Chaotic Temperature Statistics    (Proj5_landryza.asm)

; Author: Zachary Landry
; Last Modified: 05/19/25
; OSU email address: landryza@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5               Due Date: 05/25/25
; Description: Program generates random temperature readings for a number of days specified by a constant and
;				completes a number of readings each day specified by another constant.
;				These temperatures are within a range specified by max and min constants. Then the program
;				finds the highs and lows of each day, calculates the average high and low, and prints out
;				all of this information to the user.

INCLUDE Irvine32.inc

DAYS_MEASURED	=	14
TEMPS_PER_DAY	=	11
MIN_TEMP		=	20
MAX_TEMP		=	80

.data

intro1			BYTE		"Welcome to Chaotic Temperature Statistics, by Zach Landry",13,10,0
intro2			BYTE		"This program creates temperature readings, X per day for Y days, and then calculates the high and low for each day and the average high and low for all of the days. Then it prints all of these results with descriptive titles.",13,10,13,10,0
tempArray		DWORD		DAYS_MEASURED*TEMPS_PER_DAY DUP(?)
tempArrayLabel	BYTE		"The temperature readings are as follows (one row is one day): ",13,10,0
dailyHighsLabel	BYTE		"The highest temperature of each day was:",13,10,0
dailyLowsLabel	BYTE		"The lowest temperature of each day was:",13,10,0
dailyHighs		DWORD		DAYS_MEASURED DUP(?)
dailyLows		DWORD		DAYS_MEASURED DUP(?)
averageHigh		DWORD		?
averageLow		DWORD		?
avgHighLabel	BYTE		"The (truncated) average high temperature was: ",0
avgLowLabel		BYTE		"The (truncated) average low temperature was: ",0
outro1			BYTE		"Thanks for using Chaotic Temperature Statistics.",13,10,0
outro2			BYTE		"Goodbye!",13,10,0

.code
main PROC
	
	CALL	RANDOMIZE

	;Greet User
	PUSH	OFFSET intro1
	PUSH	OFFSET intro2
	CALL	printGreeting

	;Generate Temperatures
	PUSH	OFFSET	tempArray
	CALL	generateTemperatures

	;Find daily highs
	PUSH	OFFSET tempArray
	PUSH	OFFSET dailyHighs
	CALL	findDailyHighs

	;Find daily lows
	PUSH	OFFSET tempArray
	PUSH	OFFSET dailyLows
	CALL	findDailyLows

	;Calc average high and low temps
	PUSH	OFFSET dailyHighs
	PUSH	OFFSET dailyLows
	PUSH	OFFSET averageHigh
	PUSH	OFFSET averageLow
	CALL	calcAverageLowHighTemps

	;Displays the tempArray
	PUSH	OFFSET tempArrayLabel
	PUSH	OFFSET tempArray
	PUSH	DAYS_MEASURED
	PUSH	TEMPS_PER_DAY
	CALL	displayTempArray

	;Displays the dailyHighs
	PUSH	OFFSET dailyHighsLabel
	PUSH	OFFSET dailyHighs
	PUSH	1
	PUSH	DAYS_MEASURED
	CALL	displayTempArray

	;Displays the dailyLows
	PUSH	OFFSET dailyLowsLabel
	PUSH	OFFSET dailyLows
	PUSH	1
	PUSH	DAYS_MEASURED
	CALL	displayTempArray

	;Displays the average high
	PUSH	averageHigh
	PUSH	OFFSET	avgHighLabel
	CALL	displayTempwithString

	;Displays the average low
	PUSH	averageLow
	PUSH	OFFSET	avgLowLabel
	CALL	displayTempwithString

	;Farewell
	PUSH	OFFSET outro1
	PUSH	OFFSET outro2
	CALL	printGreeting


	Invoke ExitProcess,0	; exit to operating system
main ENDP

  ;--------------------------------------------------------------------------
  ; Name: printGreeting
  ;
  ; Procedure to introduce the program, prints two string arrays
  ;
  ; preconditions: [EBP+12] and [EBP+8] are strings
  ;
  ; postconditions: none
  ;
  ; receives: 2 strings, in first call: intro1 and intro2, in second call: outro1 and outro2
  ;
  ; returns: prints out 2 strings to the user
  ;--------------------------------------------------------------------------
printGreeting			PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX

	; [EBP+12] = intro 1
	; [EBP+8] = intro 2
	; [EBP+4] = return address
	; [EBP] = old ebp

	; Greet the user
	MOV		EDX, [EBP+12]
	CALL	WriteString			
	MOV		EDX, [EBP+8]
	CALL	WriteString			

	POP		EDX
	POP		EBP
	RET		8
printGreeting			ENDP

  ;--------------------------------------------------------------------------
  ; Name: generateTemperatures
  ;
  ; Procedure to generate random temperature readings
  ;
  ; preconditions: the array is length TEMPS_PER_DAY * DAYS_MEASURED
  ;
  ; postconditions: none
  ;
  ; receives: 
  ;		[ebp+8]		=	address of array
  ;		TEMPS_PER_DAY, DAYS_MEASURED, MAX_TEMP, and MIN_TEMP are constants
  ;
  ; returns: tempArray with random numbers filling the array
  ;--------------------------------------------------------------------------
generateTemperatures	PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDI
	PUSH	EBX
	PUSH	ECX
	PUSH	EAX
	; [EBP+8] = OFFSET tempArray
	; [EBP+4] = return address
	; [EBP] = old ebp

	MOV		EDI, [EBP+8]				
	MOV		EBX, DAYS_MEASURED			;Sets loop to go until all days have temperatures
	MOV		ECX, 1
_changeDays:
	;Outerloop to generate new temperatures for each day
	PUSH	EBX
	PUSH	ECX

	MOV		EBX, TEMPS_PER_DAY			;Sets loop to go until all temperatures have generated for one day
	MOV		ECX, 1
_genTemperature:
	;Innerloop to generate random number between min temp and max temp for each reading
	MOV		EAX, MAX_TEMP-MIN_TEMP+1	;Sets the range for the number
	CALL	RandomRange
	ADD		EAX, MIN_TEMP				;Takes temp from [0,Max temp-Min temp] to [min temp, max temp]
	MOV		[EDI], EAX
	ADD		EDI, 4

	; increment ecx, check if ecx <= ebx for temps in one day, if so loop again
	INC		ECX
	CMP		ECX, EBX
	JBE		_genTemperature

	; restore values before moving to outer loop
	POP		ECX
	POP		EBX

	; increment ecx, check if ecx <= ebx for days generated, if so loop again
	INC		ECX
	CMP		ECX, EBX
	JBE		_changeDays

	POP		EAX
	POP		ECX
	POP		EBX
	POP		EDI
	POP		EBP
	RET		4
generateTemperatures	ENDP

  ;--------------------------------------------------------------------------
  ; Name: findDailyHighs
  ;
  ; Procedure to find the daily highs
  ;
  ; preconditions: the array to be changed is length DAYS_MEASURED, the array to pull data from contains only positive values.
  ;
  ; postconditions: none
  ;
  ; receives: 
  ;		[ebp+12]	=	address of an array
  ;		[ebp+8]		=	address of an array
  ;		DAYS_MEASURED, TEMPS_PER_DAY are constants
  ;
  ; returns: dailyHighs filled with the highest temperature of each day
  ;--------------------------------------------------------------------------
findDailyHighs			PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ECX
	PUSH	EAX
	; PUSH	OFFSET tempArray
	; PUSH	OFFSET dailyHighs
	; [EBP+12] = tempArray
	; [EBP+8] = OFFSET dailyHighs
	; [EBP+4] = return address
	; [EBP] = old ebp

	;Initialize registers before entering the loop
	MOV		EDI, [EBP+8]				
	MOV		ESI, [EBP+12]				
	MOV		EBX, DAYS_MEASURED			
	MOV		ECX, 1
_changeDays:
	;Outerloop moves to the next day once all temps have been compared for one day
	PUSH	EBX
	PUSH	ECX

	MOV		EBX, TEMPS_PER_DAY			
	MOV		ECX, 1
	MOV		EAX, [ESI]
	MOV		[EDI], EAX					
_compareDailyTemps:
	;Innerloop compares each reading for one day to find the high
	MOV		EAX, [ESI]
	CMP		EAX, [EDI]
	JA		_updateDailyHigh
	JMP		_nextTempReading


_updateDailyHigh:
	MOV		[EDI], EAX					

_nextTempReading:
	; increment esi and ecx, check if ecx <= ebx for daily temps, if so loop again
	ADD		ESI, 4
	INC		ECX
	CMP		ECX, EBX
	JBE		_compareDailyTemps

	; restore values before moving to outer loop
	POP		ECX
	POP		EBX

	; increment dailyHigh to next day
	ADD		EDI, 4

	; increment ecx, check if ecx <= ebx for days, if so loop again
	INC		ECX
	CMP		ECX, EBX
	JBE		_changeDays

	POP		EAX
	POP		ECX
	POP		EBX
	POP		ESI
	POP		EDI
	POP		EBP
	RET		8
findDailyHighs			ENDP

  ;--------------------------------------------------------------------------
  ; Name: findDailyLows
  ;
  ; Procedure to find the daily lows
  ;
  ; preconditions: the array to be changed is length DAYS_MEASURED, the array to pull data from contains only positive values.
  ;
  ; postconditions: none
  ;
  ; receives: 
  ;		[ebp+12]	=	address of an array
  ;		[ebp+8]		=	address of an array
  ;		DAYS_MEASURED, TEMPS_PER_DAY are constants
  ;
  ; returns: dailyLows filled with the lowest temperature of each day
  ;--------------------------------------------------------------------------
findDailyLows			PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ECX
	PUSH	EAX
	; PUSH	tempArray
	; PUSH	OFFSET dailyLows
	; [EBP+12] = tempArray
	; [EBP+8] = OFFSET dailyLows
	; [EBP+4] = return address
	; [EBP] = old ebp

	MOV		EDI, [EBP+8]					
	MOV		ESI, [EBP+12]					
	MOV		EBX, DAYS_MEASURED				
	MOV		ECX, 1
_changeDays:
	;Outerloop moves to the next day once all temps have been compared for one day
	PUSH	EBX
	PUSH	ECX

	MOV		EBX, TEMPS_PER_DAY			
	MOV		ECX, 1
	MOV		EAX, [ESI]
	MOV		[EDI], EAX						;Initializes low to first temp of the day
_compareDailyTemps:
	;Innerloop compares each reading for one day to find the hig
	MOV		EAX, [ESI]
	CMP		EAX, [EDI]
	JB		_updateDailyLow
	JMP		_nextTempReading


_updateDailyLow:
	MOV		[EDI], EAX	

_nextTempReading:
	; increment esi and ecx, check if ecx <= ebx for daily temps, if so loop again
	ADD		ESI, 4
	INC		ECX
	CMP		ECX, EBX
	JBE		_compareDailyTemps

	; restore values before moving to outer loop
	POP		ECX
	POP		EBX

	; increment dailyLow to next day
	ADD		EDI, 4

	; increment ecx, check if ecx <= ebx for days, if so loop again
	INC		ECX
	CMP		ECX, EBX
	JBE		_changeDays

	POP		EAX
	POP		ECX
	POP		EBX
	POP		ESI
	POP		EDI
	POP		EBP
	RET		8
findDailyLows			ENDP


  ;--------------------------------------------------------------------------
  ; Name: calcAverageLowHighTemps
  ;
  ; Procedure to find the average of the dailyHighs and dailyLows
  ;
  ; preconditions: the values to be filled are the addresses of DWORDs, the arrays are DAYS_MEASURED long and contain only positive values
  ;
  ; postconditions: none
  ;
  ; receives: 
  ;		[EBP+20] = the address of an array
  ;		[EBP+16] = the address of an array
  ;		[EBP+12] = the address of a DWORD
  ;		[EBP+8] = the address of a DWORD
  ;		DAYS_MEASURED is a constant
  ;
  ; returns: averageHigh and averageLow with the truncated averages calculated
  ;--------------------------------------------------------------------------
calcAverageLowHighTemps	PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EBX
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI
	PUSH	EAX
	PUSH	EDX
	;PUSH	OFFSET dailyHighs
	;PUSH	OFFSET dailyLows
	;PUSH	OFFSET averageHigh
	;PUSH	OFFSET averageLow
	; [EBP+20] = OFFSET dailyHighs
	; [EBP+16] = OFFSET dailyLows
	; [EBP+12] = OFFSET averageHigh
	; [EBP+8] = OFFSET averageLow
	; [EBP+4] = return address
	; [EBP] = old ebp

	MOV		EBX, DAYS_MEASURED					;Sets to loop until each day's high has been added
	MOV		ECX, 1
	MOV		ESI, [EBP+20]						;Sets ESI to address of dailyHighs
	MOV		EDI, [EBP+12]						;Sets EDI to address of averageHigh
	MOV		EAX, 0								;Clears out the EAX before use
_calcAverageHigh:
	;loops to add all highs together
	ADD		EAX, [ESI]
	ADD		ESI, 4

	; increment ecx, check if ecx <= ebx for days, if so loop again
	INC		ECX
	CMP		ECX, EBX
	JBE		_calcAverageHigh

	; divide total of highs by number of days for average
	MOV		EDX, 0
	DIV		EBX
	MOV		[EDI], EAX							;Stores average in averageHigh

	MOV		EBX, DAYS_MEASURED					;Sets to loop until each day's low has been added
	MOV		ECX, 1
	MOV		ESI, [EBP+16]						;Sets ESI to address of dailyLows
	MOV		EDI, [EBP+8]						;Sets EDI to address of averageLow
	MOV		EAX, 0
_calcAverageLow:
	;loops to add all lows together
	ADD		EAX, [ESI]
	ADD		ESI, 4

	; increment ecx, check if ecx <= ebx for days, if so loop again
	INC		ECX
	CMP		ECX, EBX
	JBE		_calcAverageLow

	; divide total of highs by number of days for average
	MOV		EDX, 0
	DIV		EBX
	MOV		[EDI], EAX							;Stores average in averageLow
	
	POP		EDX
	POP		EAX
	POP		EDI
	POP		ESI
	POP		ECX
	POP		EBX
	POP		EBP
	RET		16
calcAverageLowHighTemps	ENDP

  ;--------------------------------------------------------------------------
  ; Namee: displayTempArray
  ;
  ; Procedure to display the temperature arrays created in the program
  ;
  ; preconditions: there are values specifying someColumns and someRows to be printed, 
  ;					the array contains only positive values, there is a string
  ;
  ; postconditions: none
  ;
  ; receives: someColumns, someRows, someArray, someTitle
  ;		[EBP+20]	= address of a string
  ;		[EBP+16]	= address of an array
  ;		[EBP+12]	= a value of rows to be printed
  ;		[EBP+8]		= a value of columns to be printed
  ;
  ; returns: prints out a string and an array to the user
  ;--------------------------------------------------------------------------
displayTempArray		PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	PUSH	ECX
	PUSH	EBX
	PUSH	EAX
	;PUSH	OFFSET tempArrayLabel
	;PUSH	OFFSET tempArray
	;PUSH	someRows
	;PUSH	someColumns
	; [EBP+20] = OFFSET tempArrayLabel
	; [EBP+16] = OFFSET tempArray
	; [EBP+12] = DAYS_MEASURED
	; [EBP+8] = TEMPS_PER_DAY
	; [EBP+4] = return address
	; [EBP] = old ebp

	MOV		EDX, [EBP+20]
	CALL	WriteString				

	MOV		ECX, 1
	MOV		EBX, [EBP+12]			
	MOV		EDI, [EBP+16]			
_changeRow:
	; Outerloop changes to the next row of values to print
	PUSH	ECX
	PUSH	EBX

	MOV		EBX, [EBP+8]			
	MOV		ECX, 1
_printRow:
	; Innerloop prints each value in the row
	MOV		EAX, [EDI]
	CALL	WriteDec				
	PUSH	EAX							;Preserves register so it's not impacted by writing a space
	MOV		AL, 32
	CALL	WriteChar			
	POP		EAX

	;increment EAX to next temp and increment ECX
	ADD		EDI, 4
	INC		ECX

	;check if ecx <= ebx, if so loop again
	CMP		ECX, EBX
	JBE		_printRow

	;restore values before moving to outer loop
	POP		EBX
	POP		ECX

	;move to next row
	CALL	CrLF

	;increment ECX, check if ecx <= ebx, if so loop again
	INC		ECX
	CMP		ECX, EBX
	JBE		_changeRow

	CALL	CrLf	

	POP		EAX
	POP		EBX
	POP		ECX
	POP		EDX
	POP		EBP
	RET		16
displayTempArray		ENDP


  ;--------------------------------------------------------------------------
  ; Name: displayTempwithString
  ;
  ; Procedure to display the average temperatures calculated by the program
  ;
  ; preconditions: there is a string, the value is positive
  ;
  ; postconditions: none
  ;
  ; receives: 
  ;		[EBP+12]	= value
  ;		[EBP+8]		= address of a string
  ;
  ; returns: prints out a string and a value to the user
  ;--------------------------------------------------------------------------
displayTempwithString	PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	PUSH	EAX
	PUSH	EBX
	; PUSH	averageHigh
	; PUSH	OFFSET	avgHighLabel
	; [EBP+12] = averageHigh
	; [EBP+8] = OFFSET	avgHighLabel
	; [EBP+4] = return address
	; [EBP] = old ebp

	; Print string and value
	MOV		EDX, [EBP+8]
	CALL	WriteString				
	MOV		EAX, [EBP+12]
	CALL	WriteDec					

	; Add space before next procedure call
	CALL	CrLf
	CALL	CrLf

	POP		EBX
	POP		EAX
	POP		EDX
	POP		EBP
	RET
displayTempwithString	ENDP

END main