#CommentFlag @
#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#singleinstance force

rollingMSLength = 500

kPSThreshold = 7
idleThreshold = 1
timeStamps := Object()
rollingKPS := 0
nowTime := 0
frequency := 0
DllCall("QueryPerformanceFrequency", "Int64*", Frequency)

@ setTimer, refresh, 1

Gui, -Caption @ +Resize
@ Gui, Add, Text, vVarText w50
Gui, Show, x10 y0 w1900 h1060, KPS Feedback

Loop{
	gosub refresh
	sleep, 1
}

return

GuiClose:
ExitApp

~j::
	KeyWait, j
	gosub, timeStamper
	return

~k::                                                                                                                                                                                                                                                                                                                                                                                                                                         
	KeyWait, k
	gosub, timeStamper
	return
	
~;::                                                                                                                                                                                                                                                                                                                                                                                                                                         
	KeyWait, ;
	gosub, timeStamper
	return
	
~n::                                                                                                                                                                                                                                                                                                                                                                                                                                         
	KeyWait, n
	gosub, timeStamper
	return
	
~i::                                                                                                                                                                                                                                                                                                                                                                                                                                         
	KeyWait, i
	gosub, timeStamper
	return
	
~a::                                                                                                                                                                                                                                                                                                                                                                                                                                         
	KeyWait, a
	gosub, timeStamper
	return
	
~d::                                                                                                                                                                                                                                                                                                                                                                                                                                         
	KeyWait, d
	gosub, timeStamper
	return
	
~f::                                                                                                                                                                                                                                                                                                                                                                                                                                         
	KeyWait, f
	gosub, timeStamper
	return
	
timeStamper:
	DllCall("QueryPerformanceCounter", "Int64*", nowTime)
	timeStamps.Push(nowTime)
	return

refresh:
	DllCall("QueryPerformanceCounter", "Int64*", nowTime)

	for index, stamp in timeStamps {
		elapsedTime := (nowTime- stamp)*1000/frequency
		if (elapsedTime > rollingMSLength) {
			timeStamps.RemoveAt(index)
		}
	}
	rollingKPS := timeStamps.MaxIndex() / (rollingMSLength / 1000)
	 
	@ FileAppend, %rollingKPS%, C:\Users\user\Documents\test.txt
	@ FileAppend, `n, C:\Users\user\Documents\test.txt
	
	if(rollingKPS < kPSThreshold) { @ (rollingKPS < kPSThreshold and rollingKPS > idleThreshold) {
		Gui, Color, Red
	} else {
		@ if (rollingKPS >idleThreshold){
		Gui, Color, Black
		@} else {
		@ Gui, Color, 000033
		@ }
	}
	return