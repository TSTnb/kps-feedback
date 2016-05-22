#CommentFlag @
#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#singleinstance force

rollingMSLength = 500
@This is the window of time, in ms, that the KPS is "remembered" for.
@For example,  if 502 ms have passed, then we're looking at keys pressed between ms 2 and ms 502.

kPSThreshold = 7
@The KPS we need to be higher than (over the past 500 ms) in order for the screen to be black.

@ idleThreshold = 1
@ Experimental feature not used

timeStamps := Object()
@ An array that will hold the "time stamp" (the number of ticks from the last time the comptuer was booted)


rollingKPS := 0
nowTime := 0
frequency := 0
@ Initialize some variables

DllCall("QueryPerformanceFrequency", "Int64*", Frequency)
@ I forgot what this does exactly. It's a more accurate version of AHK's ticks


Gui, -Caption @ +Resize
Gui, Show, x10 y0 w1900 h1060, KPS Feedback
@ Start the gui window


Loop{
	gosub refresh
	sleep, 1
}

@ Every 1 ms, run the "refresh" routine

return

GuiClose:
ExitApp

@ Set your keys below. Every time you press the key, it logs the timestamp and stores it in the array.

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
	@ Set variable nowTime to the current time and put it into the array.
	DllCall("QueryPerformanceCounter", "Int64*", nowTime)
	timeStamps.Push(nowTime)
	return

refresh:

	Find out the time right now.
	DllCall("QueryPerformanceCounter", "Int64*", nowTime)
	
	
	@Iterate through the array.  Compare the timestamps of the button presses with the current time. If it's longer than the rollingMSLength window of time, exclude it from the array.
	
	for index, stamp in timeStamps {
		elapsedTime := (nowTime- stamp)*1000/frequency
		if (elapsedTime > rollingMSLength) {
			timeStamps.RemoveAt(index)
		}
	}
	
	@ Calculate the KPS by dividing the number of keypresses still stored in the array by the length of the window of time we're storing them for.
	rollingKPS := timeStamps.MaxIndex() / (rollingMSLength / 1000)
	
	
	@ Some debugging stuff
	@ FileAppend, %rollingKPS%, C:\Users\user\Documents\test.txt
	@ FileAppend, `n, C:\Users\user\Documents\test.txt
	
	
	
	if(rollingKPS < kPSThreshold) { @ (rollingKPS < kPSThreshold and rollingKPS > idleThreshold) {
		@ If the KPS is lower than what we want, turn red, otherwise turn red. The commented out stuff is for an experimental feature that's not used.
		Gui, Color, Red
	} else {
		@ if (rollingKPS >idleThreshold){
		Gui, Color, Black
		@} else {
		@ Gui, Color, 000033
		@ }
	}
	return