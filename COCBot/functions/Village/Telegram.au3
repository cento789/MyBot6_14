; #FUNCTION# ====================================================================================================================
; Name ..........: Telegram
; Description ...: This function will report to your mobile phone your values and last attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: loll1 (2016-07)
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Array.au3>
#include <String.au3>

Func ansi2unicode($str)
	Local $keytxt = StringSplit($str,"\n",1)
	Local $aSRE = StringRegExp($keytxt[1], "\\u(....)", 3)
	For $i = 0 To UBound($aSRE) - 1
		$keytxt[1] = StringReplace($keytxt[1], "\u" & $aSRE[$i], BinaryToString("0x" & $aSRE[$i], 3))
	Next
	if $keytxt[0] > 1  Then
		$ansiStr = $keytxt[1] &"\n" & $keytxt[2]
	Else
		$ansiStr = $keytxt[1]
	EndIf
	Return $ansiStr
EndFunc

Func _RemoteControlTelegram()

	;Setlog("start processing telegram message.",$COLOR_GREEN) for debugging
	
	If $PushBulletEnabled2 = 0 Or $pRemote = 0 Then Return
	;add code for telegram
	if $PushBulletEnabled2 = 1 then
	;$access_token2 = $PushBulletToken2
	  $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	  $url= "https://api.telegram.org/bot"
	  $oHTTP.Open("Get", $url & $access_token2 & "/getupdates" , False)
	  $oHTTP.Send()
	  $Result = $oHTTP.ResponseText
	  Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
	  If $findstr2 = 1 Then
	   local $rmessage = _StringBetween($Result, 'text":"' ,'"}}' )           ;take message
	   local $uid = _StringBetween($Result, 'update_id":' ,'"message"' )             ;take update id
	   local $lastmessage = _Arraypop($rmessage)								 ;take last message
	   local $lastuid = _Arraypop($uid)
	   Local $uclm = ansi2unicode($lastmessage)
	   local $iuclm = StringUpper(StringStripWS($uclm, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message

	  if $first = 0 then
		  $first = 1
		  $lastremote = $lastuid
		  $oHTTP.Open("Get", $url & $access_token2 & "/getupdates?offset=" & $lastuid  , False)
	      $oHTTP.Send()
	   EndIf
	   if $lastremote <> $lastuid Then
      	 $lastremote = $lastuid
		 		 Switch $iuclm
					case "\/START"
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
		                $oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,48,"BOT is now starting telegram") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["' & GetTranslated(18,16,"Stop") & '\n\u23f9","' & GetTranslated(18,3,"Pause") & '\n\u23f8","' & GetTranslated(18,15,"Restart") & '\n\u21aa","' & GetTranslated(18,4,"Resume") & '\n\u25b6"],["' & GetTranslated(18,2,"Help") & '\n\u2753","' & GetTranslated(18,5,"Delete") & '\n\ud83d\udeae","' & GetTranslated(18,11,"Lastraid") & '\n\ud83d\udcd1","' & GetTranslated(18,13,"Stats") & '\n\ud83d\udcca"],["' & GetTranslated(18,14,"Screenshot") & '\n\ud83c\udfa6","' & GetTranslated(18,12,"Last raid txt") & '\n\ud83d\udcc4","' & GetTranslated(18,6,"Power") & '\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
					Case GetTranslated(18,2,"Help") & "\N\U2753"
						 Local $txtHelp =  GetTranslated(18,17,"You can remotely control your bot by selecting this key")
						$txtHelp &= "\n" & GetTranslated(18,18,"HELP - send this help message")
						$txtHelp &= "\n" & GetTranslated(18,19,"DELETE  - Use this if Remote dont respond to your request")
						$txtHelp &= "\n" & GetTranslated(18,20,"RESTART - restart the bot and bluestacks")
						$txtHelp &= "\n" & GetTranslated(18,21,"STOP - stop the bot")
						$txtHelp &= "\n" & GetTranslated(18,22,"PAUSE - pause the bot")
						$txtHelp &= "\n" & GetTranslated(18,23,"RESUME   - resume the bot")
						$txtHelp &= "\n" & GetTranslated(18,24,"STATS - send Village Statistics")
						;$txtHelp &= "\n" & "LOG - send the current log file of <Village Name>"
						$txtHelp &= "\n" & GetTranslated(18,25,"LASTRAID - send the last raid loot screenshot. you should check Take Loot snapshot in End Battle Tab ")
						$txtHelp &= "\n" & GetTranslated(18,26,"LASTRAIDTXT - send the last raid loot values")
						$txtHelp &= "\n" & GetTranslated(18,27,"SCREENSHOT - send a screenshot")
						$txtHelp &= "\n" & GetTranslated(18,28,"POWER - select powr option")
						$txtHelp &= "\n"
						$txtHelp &= "\n" & GetTranslated(18,101,"Send and recieve chats via Telegram. Use GETCHATS <interval|NOW|STOP> to get the latest clan chat as an image, and SENDCHAT <chat message> to send a chat to your clan")
						_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,29,"Request for Help") & "\n" & $txtHelp)
						SetLog("Telegram: Your request has been received from ' " & $iOrigPushBullet & ". Help has been sent", $COLOR_GREEN)
					Case GetTranslated(18,3,"Pause") & "\N\U23F8"
						If $TPaused = False And $Runstate = True Then
						 TogglePauseImpl("Push")
						Else
						 SetLog("Telegram: Your bot is currently paused, no action was taken", $COLOR_GREEN)
					 _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,30,"Request to Pause") & "\n" & GetTranslated(18,93,"Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslated(18,4,"Resume") & "\N\U25B6"
						If $TPaused = True And $Runstate = True Then
						 TogglePauseImpl("Push")
						Else
						 SetLog("Telegram: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
						 _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,31,"Request to Resume") & "\n" & GetTranslated(18,94,"Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslated(18,5,"Delete") & "\N\UD83D\UDEAE"
		                $oHTTP.Open("Get", $url & $access_token2 & "/getupdates?offset=" & $lastuid  , False)
	                    $oHTTP.Send()
					SetLog("Telegram: Your request has been received.", $COLOR_GREEN)
					;Case "LOG\N\UD83D\UDCD1"
						;SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Log is now sent", $COLOR_GREEN)
						;_PushFile2($sLogFName, "logs", "text/plain; charset=utf-8", $iOrigPushBullet & " | Current Log " & "\n")
						;_PushFile2($sLogFName, "logs", "application\/octet-stream", $iOrigPushBullet & " | Current Log " & "\n")
						;_PushFile2($sLogFName, "logs", "application/octet-stream", $iOrigPushBullet & " | Current Log " & "\n")
					Case GetTranslated(18,6,"Power") & "\N\Ud83D\UDDA5"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". POWER option now sent", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
		                $oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,49,"select POWER option") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,7,"Hibernate")&'\n\u26a0\ufe0f","'&GetTranslated(18,8,"Shut down")&'\n\u26a0\ufe0f","'&GetTranslated(18,9,"Standby")&'\n\u26a0\ufe0f"],["'&GetTranslated(18,10,"Cancel")&'"]],"one_time_keyboard": true,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
					Case GetTranslated(18,7,"Hibernate") & "\N\U26A0\UFE0F"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Hibernate PC", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,50,"PC got Hibernate") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
					Shutdown(64)
					Case GetTranslated(18,8,"Shut down") & "\N\U26A0\UFE0F"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Shut down PC", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,51,"PC got Shutdown") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
						Shutdown(5)
					Case GetTranslated(18,9,"Standby") & "\N\U26A0\UFE0F"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Standby PC", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,52,"PC got Standby") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
						Shutdown(32)
					Case GetTranslated(18,10,"Cancel")
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Cancel Power option", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,53,"canceled") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
					Case GetTranslated(18,11,"Lastraid") & "\N\UD83D\UDCD1"
						 If $LootFileName <> "" Then
						 _PushFileToTelegram($LootFileName, "Loots", "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(18,95,"Last Raid") & "\n" & $LootFileName)
						Else
						 _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,32,"There is no last raid screenshot."))
						EndIf
						SetLog("Telegram: Push Last Raid Snapshot...", $COLOR_GREEN)
					Case GetTranslated(18,12,"Last raid txt") & "\N\UD83D\UDCC4"
						SetLog("Telegram: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,33,"Last Raid txt") & "\n" & " \n[G]: " & _NumberFormat($iGoldLast) & " \n[E]: " & _NumberFormat($iElixirLast) & " \n[D]: " & _NumberFormat($iDarkLast) & " \n[T]: " & $iTrophyLast)
					Case GetTranslated(18,13,"Stats") & "\N\UD83D\UDCCA"
						SetLog("Telegram: Your request has been received. Statistics sent", $COLOR_GREEN)
						_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,34,"Stats Village Report") & "\n" & GetTranslated(18,35,"At Start") & "\n[G]: " & _NumberFormat($iGoldStart) & " [E]: " & _NumberFormat($iElixirStart) & " [D]: " & _NumberFormat($iDarkStart) & " [T]: " & $iTrophyStart & "\n\n" & GetTranslated(18,36,"Now (Current Resources)") & "\n[G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & " [T]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount & "\n \n[" & GetTranslated(18,37,"No. of Free Builders") &"]:"  & $iFreeBuilderCount & "\n [" & GetTranslated(18,38,"No. of Wall Up") & "]: G: " & $iNbrOfWallsUppedGold & "/ E: " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(18,39,"Attacked") & ": " & GUICtrlRead($lblresultvillagesattacked) & "\n" & GetTranslated(18,40,"Skipped") & ": " & $iSkippedVillageCount)
					Case GetTranslated(18,14,"Screenshot") & "\N\UD83C\UDFA6"
						SetLog("Telegram: ScreenShot request received", $COLOR_GREEN)
						$RequestScreenshot = 1
					Case GetTranslated(18,15,"Restart") & "\N\U21AA"
						SetLog("Telegram: Your request has been received. Bot and BS restarting...", $COLOR_GREEN)
						_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,41,"Request to Restart...") & "\n" & GetTranslated(18,42,"Your bot and BS are now restarting..."))
						SaveConfig()
						_Restart()
					Case GetTranslated(18,16,"Stop") & "\N\U23F9"
						SetLog("Telegram: Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $Runstate = True Then
						 _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,43,"Request to Stop...") & "\n" & GetTranslated(18,44,"BOT is now stopping..."))
						 btnStop()
						Else
						 _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,43,"Request to Stop...") & "\n" & GetTranslated(18,45,"Your bot is currently stopped, no action was taken"))
						EndIf
					Case Else ; Chat Bot
						$startCmd = StringLeft($iuclm, StringLen("SENDCHAT "))
						If $startCmd = "SENDCHAT " Then
							$chatMessage = StringRight($iuclm, StringLen($iuclm) - StringLen("SENDCHAT "))
							$chatMessage = StringLower($chatMessage)
							ChatbotPushbulletQueueChat($chatMessage)
							_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,97,"Chat queued, will send on next idle"))
						Else
							$startCmd = StringLeft($iuclm, StringLen("GETCHATS "))
							If $startCmd == "GETCHATS " Then
								$Interval = StringRight($iuclm, StringLen($iuclm) - StringLen("GETCHATS "))
								If $Interval = "STOP" Then
									ChatbotPushbulletStopChatRead()
									_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,98,"Stopping interval sending"))
								ElseIf $Interval = "NOW" Then
									ChatbotPushbulletQueueChatRead()
									_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,99,"Command queued, will send clan chat image on next idle"))
								Else
									ChatbotPushbulletIntervalChatRead(Number($Interval))
									_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,100,"Command queued, will send clan chat image on interval"))
								EndIf
							Else
								Local $lenstr = StringLen("Test ")
								Local $teststr = StringLeft($iuclm, $lenstr)
								If $teststr = ("Test ") Then
									SetLog("Telegram: received command syntax wrong, command ignored.", $COLOR_RED)
									_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,46,"Command not recognized") & "\n" & GetTranslated(18,47,"Please push BOT HELP to obtain a complete command list."))
								EndIf
							EndIf
						EndIf
		 EndSwitch

	   EndIf
      EndIf
   EndIf
EndFunc   ;==>_RemoteControl

Func _Telegram($pMessage = "")

	If ($PushBulletEnabled2 = 0 Or $PushBulletToken2 = "") Then Return
	if $PushBulletEnabled2 = 1 then 
	$access_token2 = $PushBulletToken2
		 $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		 $oHTTP.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates" , False)
		 $oHTTP.Send()
		 $Result = $oHTTP.ResponseText
  		 local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		 $chat_id2 = _Arraypop($chat_id)
		 $oHTTP.Open("Post", "https://api.telegram.org/bot" & $access_token2&"/sendmessage", False)
		 $oHTTP.SetRequestHeader("Content-Type", "application/json")
	     Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		 Local $Time = @HOUR & '.' & @MIN
		 local $pPush3 = '{"text":"' & $pmessage & '\n\n' & $Date & '__' & $Time & '", "chat_id":' & $chat_id2 & '}}'
		 $oHTTP.Send($pPush3)
	  EndIf
EndFunc   ;==>_PushBullet

Func _PushToPushTelegram($pMessage)
	If $PushBulletEnabled2 = 0 Or $PushBulletToken2 = "" Then Return
	if $PushBulletEnabled2 = 1 then
			$access_token2 = $PushBulletToken2
			$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$url= "https://api.telegram.org/bot"
			$oHTTP.Open("Post",  $url & $access_token2&"/sendmessage", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
			Local $Time = @HOUR & '.' & @MIN
			local $pPush3 = '{"text":"' & $pmessage & '\n\n' & $Date & '__' & $Time & '", "chat_id":' & $chat_id2 & '}}'
			$oHTTP.Send($pPush3)
	EndIf
EndFunc   ;==>_Push

Func Getchatid()
    If $PushBulletEnabled2 = 0 Or $PushBulletToken2= "" Then Return
		$access_token2 = $PushBulletToken2
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates" , False)
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText
		local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		$chat_id2 = _Arraypop($chat_id)
		$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		local $ppush3 = '{"text": "' & GetTranslated(18,48,"BOT is now starting telegram") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
		$oHTTP.Send($pPush3)
EndFunc   ;==>Getchatid

Func _PushFileToTelegram($File, $Folder, $FileType, $body)
	If $PushBulletEnabled2 = 0 Or $PushBulletToken2 ="" Then Return
	if $PushBulletEnabled2 = 1 then
	If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$access_token2 = $PushBulletToken2
			$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $chat_id2 &' " -F photo=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
		 Else
			SetLog("Telegram: Unable to send file " & $File, $COLOR_RED)
			_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(18,54,"Unable to Upload File") & "\n" & GetTranslated(18,55,"Occured an error type 2 uploading file to Telegram server..."))
		 EndIf
	 EndIf
EndFunc   ;==>_PushFile

Func PushMsgToTelegram($Message, $Source = "")
	if $PushBulletEnabled2 = 0 then return
	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If ($PushBulletEnabled2 = 1 And $pRemote = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,56, "Bot restarted"))
		Case "OutOfSync"
			If ($PushBulletEnabled2 = 1 And $pOOS = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,57, "Restarted after Out of Sync Error") & "\n" & GetTranslated(620,58, "Attacking now") & "...")
		Case "LastRaid"
			If ($PushBulletEnabled2 = 1 And $iAlertPBLastRaidTxt = 1) Then
				_PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,34,"Last Raid txt") & "\n" & " \n[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldLast) & " \n[" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirLast) & " \n[" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkLast) & " \n[" & GetTranslated(620,38, "T") & "]: " & $iTrophyLast)
				If _Sleep($iDelayPushMsg1) Then Return
				SetLog("Telegram: Last Raid Text has been sent!", $COLOR_GREEN)
			EndIf
			If ($PushBulletEnabled2 = 1 And $pLastRaidImg = 1) Then
				_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT - 45)
				;create a temporary file to send with telegram...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $ScreenshotLootInfo = 1 Then
					$AttackFile = $Date & "__" & $Time & " " & GetTranslated(620,35, "G") & $iGoldLast & " " & GetTranslated(620,36, "E") & $iElixirLast & " " & GetTranslated(620,37, "D") & $iDarkLast & " " & GetTranslated(620,38, "T") & $iTrophyLast & " " & GetTranslated(620,59, "S") & StringFormat("%3s", $SearchCount) & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				Else
					$AttackFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				EndIf
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
				_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $AttackFile)
				_GDIPlus_ImageDispose($hBitmap_Scaled)
				;push the file
				SetLog("Telegram: Last Raid screenshot has been sent!", $COLOR_GREEN)
				_PushFileToTelegram($AttackFile, GetTranslated(620,31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,32, "Last Raid") & "\n" & $AttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($dirLoots & $AttackFile)
				If Not ($iDelete) Then SetLog("Telegram: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
		Case "FoundWalls"
			If ($PushBulletEnabled2 = 1 And $pWallUpgrade = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,60, "Found Wall level") & " " & $icmbWalls + 4 & "\n" & " " & GetTranslated(620,61, "Wall segment has been located") & "...\n" & GetTranslated(620,62, "Upgrading") & "...")
		Case "SkypWalls"
			If ($PushBulletEnabled2 = 1 And $pWallUpgrade = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,63, "Cannot find Wall level") & $icmbWalls + 4 & "\n" & GetTranslated(620,64, "Skip upgrade") & "...")
		Case "AnotherDevice3600"
			If ($PushBulletEnabled2 = 1 And $pAnotherDevice = 1) Then _PushToPushTelegram($iOrigPushBullet & " | 1. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Floor($sTimeWakeUp / 60) / 60) & " " & GetTranslated(603,14, "Hours") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice60"
			If ($PushBulletEnabled2 = 1 And $pAnotherDevice = 1) Then _PushToPushTelegram($iOrigPushBullet & " | 2. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice"
			If ($PushBulletEnabled2 = 1 And $pAnotherDevice = 1) Then _PushToPushTelegram($iOrigPushBullet & " | 3. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "TakeBreak"
			If ($PushBulletEnabled2 = 1 And $pTakeAbreak = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,67, "Chief, we need some rest!") & "\n" & GetTranslated(620,68, "Village must take a break.."))
		;msg when MyBot closing
		Case "StopMyBot" 
			If ($PushBulletEnabled2 = 1 And $pStop = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,86, "BOT is now stopping"))
		Case "CocError"
			If ($PushBulletEnabled2 = 1 And $pOOS = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,69, "CoC Has Stopped Error") & ".....")
		Case "Pause"
			If ($PushBulletEnabled2 = 1 And $pRemote = 1) And $Source = "Push" Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,70, "Request to Pause") & "..." & "\n" & GetTranslated(620,71, "Your request has been received. Bot is now paused"))
		Case "Resume"
			If ($PushBulletEnabled2 = 1 And $pRemote = 1) And $Source = "Push" Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,72, "Request to Resume") & "..." & "\n" & GetTranslated(620,73, "Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If ($PushBulletEnabled2 = 1 And $pOOS = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,74, "Disconnected after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,75, "skip(s)") & "\n" & GetTranslated(620,76, "Cannot locate Next button, Restarting Bot") & "...")
		Case "MatchFound"
			If ($PushBulletEnabled2 = 1 And $pMatchFound = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & $sModeText[$iMatchMode] & " " & GetTranslated(620,89, "Match Found! after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,75, "skip(s)") & "\n" & "\n[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($searchGold) & "; \n[" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($searchElixir) & "; \n[" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($searchDark) & "; \n[" & GetTranslated(620,38, "T") & "]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If ($PushBulletEnabled2 = 1 And $pWallUpgrade = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,77, "Upgrade completed by using GOLD") & "\n" & GetTranslated(620,78, "Complete by using GOLD") & "...")
		Case "UpgradeWithElixir"
			If ($PushBulletEnabled2 = 1 And $pWallUpgrade = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,79, "Upgrade completed by using ELIXIR") & "\n" & GetTranslated(620,80, "Complete by using ELIXIR") & "...")
		Case "NoUpgradeWallButton"
			If ($PushBulletEnabled2 = 1 And $pWallUpgrade = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,81, "No Upgrade Gold Button") & "\n" & GetTranslated(620,81, "Cannot find gold upgrade button") & "...")
		Case "NoUpgradeElixirButton"
			If ($PushBulletEnabled2 = 1 And $pWallUpgrade = 1) Then _PushToPushTelegram($iOrigPushBullet & " | " & GetTranslated(620,82, "No Upgrade Elixir Button") & "\n" & GetTranslated(620,83, "Cannot find elixir upgrade button") & "...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT)
			$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirTemp & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			_PushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,84, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
			SetLog("Telegram: Screenshot sent!", $COLOR_GREEN)
			$RequestScreenshot = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("Pushbullet: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
		Case "DeleteAllPBMessages"
			_DeletePushOfPushBullet()
			SetLog("PushBullet: All messages deleted.", $COLOR_GREEN)
			$iDeleteAllPBPushesNow = False ; reset value
		Case "CampFull"
			If ($PushBulletEnabled2 = 1 And $ichkAlertPBCampFull = 1) Then
				If $ichkAlertPBCampFullTest = 0 Then
					_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,85, "Your Army Camps are now Full"))
					$ichkAlertPBCampFullTest = 1
				EndIf
			
			EndIf
	EndSwitch
EndFunc   ;==>PushMsgToPushBullet