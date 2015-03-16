Strict

Public

' Preprocessor related:
'#BYTEORDER_COMPATIBILITY = True
#BYTEORDER_FLOATING_POINT = True
#BYTEORDER_CACHE = True

' Imports:
#If BYTEORDER_FLOATING_POINT
	Import brl.databuffer
#End

Import sizeof

' Constant variable(s) (Public):
' Nothing so far.

' Constant variable(s) (Private):
Private

#If BYTEORDER_FLOATING_POINT And Not SIZEOF_IMPLEMENTED
	' Modifying 'SizeOf_FloatingPoint' should not be done, as it may be backed by a constant:
	#If LANG = "cpp" And CPP_DOUBLE_PRECISION_FLOATS And TARGET <> "win8" And Target <> "winrt"
		Const SizeOf_FloatingPoint:Int = 8
	#Else
		Const SizeOf_FloatingPoint:Int = 4
	#End
#End

Public

' Global variable(s) (Public):
#If BYTEORDER_COMPATIBILITY
	Global System_BigEndian:Bool = False
#End

' Global variable(s) (Private):
Private

' Cache:
#If BYTEORDER_FLOATING_POINT
	#If BYTEORDER_CACHE
		Global FloatBuffer:DataBuffer = New DataBuffer(SizeOf_FloatingPoint)
	#End
#End

Public

' Functions:

'#If LANG = "java"
'Function NToHL:Int(I:Int)="java.lang.Integer.reverse" ' Or reverseBytes, not sure which would do the job.
'#Else

' These endian-related commands are mainly for internal use / last resort measures:
Function BigEndian:Bool()
	Local I:Int = 1
	
	I = I Shr 31

	If (I > 0) Then
		#If BYTEORDER_COMPATIBILITY
			System_BigEndian = True
		#End
		
		Return True
	Endif
	
	#If BYTEORDER_COMPATIBILITY
		System_BigEndian = False
	#End
	
	' Return the default response.
	Return False
End

Function LittleEndian:Bool()
	Return Not BigEndian()
End

' This command takes a 32-bit integer, checks if the system is big-endian,
' and if it isn't, it'll convert the integer to the opposite endian-format:
Function NToHL:Int(I:Int) ' 32-bit
	' Swap the bytes around.
	If (Not BigEndian()) Then
		Return (((I Shr 24) & $000000FF) | ((I Shr 8) & $0000FF00) | ((I Shl 8) & $00FF0000) | ((I Shl 24) & $FF000000))
	Endif
	
	Return I
End

Function HToNL:Int(I:Int)
	Return NToHL(I)
End

' For the sake of future-proofing, it is recommended that you use
' these two commands, instead of 'HToNL' and 'NToHL' directly:
Function HToNI:Int(I:Int)
	Return HToNL(I)
End

Function NToHI:Int(I:Int)
	Return NToHL(I)
End

'#End

' This command takes a 16-bit integer, checks if the system is big-endian,
' and if it isn't, it'll convert the integer to the opposite-endian:
Function NToHS:Int(S:Int) ' 16-bit
	If (Not BigEndian()) Then
		Return ((((S & $000000FF) Shl 8) | ((S & $0000FF00) Shr 8)))
	Endif
	
	Return S
End

Function HToNS:Int(S:Int)
	Return NToHS(S)
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
		
		#If BYTEORDER_CACHE
			Buffer = FloatBuffer
		#Else
			Buffer = New DataBuffer(SizeOf_FloatingPoint)
		#End
		
		' This is may change in the future:
		Buffer.PokeFloat(0, F)
		Value = HToNL(Buffer.PeekInt(0))
		
		#If Not BYTEORDER_CACHE
			Buffer.Discard(); Buffer = Null
		#End
		
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
		
		#If BYTEORDER_CACHE
			Buffer = FloatBuffer
		#Else
			Buffer = New DataBuffer(4)
		#End
		
		' This may change in the future:
		Buffer.PokeInt(0, NToHL(Data))
		Value = Buffer.PeekFloat(0)
		
		#If Not BYTEORDER_CACHE
			Buffer.Discard(); Buffer = Null
		#End
		
		' Return the calculated floating-point value.
		Return Value
	End
#End