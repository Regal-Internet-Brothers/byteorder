Strict

Public

' Preprocessor related:
#BYTEORDER_FLOATING_POINT = True

' Imports:
#If BYTEORDER_FLOATING_POINT
	Import brl.databuffer
#End

' Global variable(s):
Global System_BigEndian:BoolObject = Null

' Functions:

'#If LANG = "java"
'Function NToHL:Int(I:Int)="java.lang.Integer.reverse" ' Or reverseBytes, not sure which would do the job.
'#Else

' These endian-related commands are mainly for internal use / last resort measures:
Function BigEndian:Bool()
	If (System_BigEndian = Null) Then
		Local I:Int = 1
		
		I = I Shr 31
		
		If (I > 0) Then
			System_BigEndian = True
		Else
			System_BigEndian = False
		Endif
	Endif
	
	Return System_BigEndian
End

' This command takes a 32-bit big-endian integer, checks if the system is big-endian,
' and if it isn't, it'll convert the integer to little-endian:
Function NToHL:Int(I:Int) ' 32-bit
	' Swap the bytes around.
	If (Not BigEndian()) Then
		I = (((I Shr 24) & $000000FF) | ((I Shr 8) & $0000FF00) | ((I Shl 8) & $00FF0000) | ((I Shl 24) & $FF000000))
	Endif
	
	Return I
End

Function HToNL:Int(I:Int)
	Return NToHL(I)
End

'#End

' This command takes a 16-bit big-endian integer, checks if the system is big-endian,
' and if it isn't, it'll convert the integer to little-endian:
Function NToHS:Int(I:Int) ' 16-bit
	If (Not BigEndian()) Then
		I = ((((I & $000000FF) Shl 8) | ((I & $0000FF00) Shr 8)))
	Endif
	
	Return I
End

Function HToNS:Int(I:Int)
	Return NToHS(I)
End

#If BYTEORDER_FLOATING_POINT
	' This command takes a 32-bit floating-point value, and contains it within a big-endian integer:
	Function HToNF:Int(F:Float)
		' Local variable(s):
		Local Value:Int = 0
		Local Buffer:DataBuffer = Null
		
		#Rem
		#If CPP_DOUBLE_PRECISION_FLOATS
			Buffer = New DataBuffer(8)
		#Else
			' INSERT BUFFER HERE.
		#End
		#End
		
		Buffer = New DataBuffer(4)
		
		Buffer.PokeFloat(0, F)
		Value = HToNL(Buffer.PeekInt(0))
		
		Buffer.Discard(); Buffer = Null
		
		' Return the calculated integer.
		Return Value
	End
	
	' This command takes a 32-bit big-endian integer and converts it into a system native float:
	Function NToHF:Float(Data:Int)
		' Local variable(s):
		Local Value:Float = 0.0
		Local Buffer:DataBuffer = Null
		
		#Rem
		#If CPP_DOUBLE_PRECISION_FLOATS
			Buffer = New DataBuffer(8)
		#Else
			' INSERT BUFFER HERE.
		#End
		#End
		
		Buffer = New DataBuffer(4)
		
		Buffer.PokeInt(0, NToHL(Data))
		Value = Buffer.PeekFloat(0)
		
		Buffer.Discard(); Buffer = Null
		
		' Return the calculated floating-point value.
		Return Value
	End
#End