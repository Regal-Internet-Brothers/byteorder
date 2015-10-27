Strict

Public

' Imports:

'Import regal.sizeof
Import regal.byteorder

' Functions:
Function Main:Int()
	' Local variable(s):
	Local F:Float = 10.0
	Local BEF:Int = HToNF(F)
	
	Print("F: " + F)
	Print("BEF: " + BEF)
	Print("NToHF(BEF): " + NToHF(BEF))
	
	Print("-----")
	
	Local I:Int = 507689
	Local BEI:Int = HToNI(I)
	
	Print("I: " + I)
	Print("BEI: " + BEI)
	Print("NToHI(BEI): " + NToHI(BEI))
	
	Print("-----")
	
	Local S:Int = 627
	Local BES:Int = HToNS(S)
	
	Print("S: " + S)
	Print("BES: " + BES)
	Print("NToHS(BES): " + NToHS(BES))
	
	' Return the default response.
	Return 0
End