; Attack Variables, constants and enums - Added by LunaEclipse
;
; Troop types - Added CC Spell as a type, so clan castle spell can be reported.
Global Enum  $eCCSpell = $eHaSpell + 1

; Type of Spell in the CC, this will be the second entry for the spell on the bar
Global $CCSpellType

; Set the constants for the center of the screen when attacking
Global Const $centerX = 430
Global Const $centerY = 335

; Attack settings
Global Enum $eOneSide, $eTwoSides, $eThreeSides, $eAllSides, $eSmartSave, $eMultiFinger
Global Enum $eCustomDeploy = $eAllSides + 1, $eMilking

; Deployment Array Constants
Global Const $DEPLOY_COLUMNS = 5
Global Const $DEPLOY_MAX_WAVES = 24
Global Const $DEPLOY_NUMBER_CONTROLS = 3

; Custom Deployment Variables, Constants and Enums
Global $deployValues[$DEPLOY_MAX_WAVES][2]

Global Const $COLUMN_SEPERATOR = ","
Global Const $ROW_SEPERATOR = "|"
Global Const $DEPLOY_TYPE_HEADER = "Type"
Global Const $DEPLOY_POSITION_HEADER = "Position"

Global Const $eDeployWait = $eHaSpell + 1
Global Const $eDeployUnused = $eHaSpell + 2
Global Const $DEPLOY_WAIT_STRING = "<Delay>"
Global Const $DEPLOY_EMPTY_STRING = "<Unused>"

; Custom Deployment UI Settings
Global $valueTownHall = 5
Global $valueDEStorage = 10
Global $valueGoldStorage = 3
Global $valueElixirStorage = 3
Global $valueGoldMine = 1
Global $valueElixirCollector = 1
Global $valueDEDrill = 2

; Custom Deployment Control Arrays
Global $ctrlDeploy[$DEPLOY_MAX_WAVES][$DEPLOY_NUMBER_CONTROLS]
Global $ctrlDeployHeadings[3][$DEPLOY_NUMBER_CONTROLS] ; 3 - Specifies the number of columns of wave information

; Minimum Troops per position for Custom Deployment with a number of positions set
Global $maxSaveTroopsPerCollector = [3, 5, 1, 5, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $minTroopsPerPosition = [1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1]

; Default Deployment for Save Troops for Collectors
Global Const $DEFAULT_SAVE_TROOPS_DEPLOY[6][5] = [[$eGiant, 0, 1, 1, 0], _
												  [$eBarb, 0, 1, 1, 0], _
												  [$eArch, 0, 1, 1, 0], _
												  [$eWiza, 0, 1, 1, 0], _
												  [$eMini, 0, 1, 1, 0], _
												  [$eGobl, 0, 1, 1, 0]]

; Default Deployment for Original Attacks
Global Const $DEFAULT_ORIGINAL_DEPLOY[13][$DEPLOY_COLUMNS] = [[$eGiant, 0, 1, 1, 2], _
															  [$eBarb, 0, 1, 2, 0], _
															  [$eWall, 0, 1, 1, 2], _
															  [$eArch, 0, 1, 2, 0], _
															  [$eBarb, 0, 2, 2, 0], _
															  [$eGobl, 0, 1, 2, 0], _
															  ["CC", 1, 1, 1, 1], _
															  [$eHogs, 0, 1, 1, 1], _
															  [$eWiza, 0, 1, 1, 0], _
															  [$eMini, 0, 1, 1, 0], _
															  [$eArch, 0, 2, 2, 0], _
															  [$eGobl, 0, 2, 2, 0], _
															  ["HEROES", 1, 2, 1, 1]]

; Default Deployment for Four Finger Array
Global Const $DEFAULT_FOUR_FINGER_DEPLOY[16][$DEPLOY_COLUMNS] = [[$eGiant,  0, 1, 1, 2], _
																 [$eBarb,   0, 1, 1, 0], _
																 [$eWall,   0, 1, 1, 2], _
																 [$eArch,   0, 1, 1, 0], _
																 [$eGobl,   0, 1, 2, 0], _
																 ["CC",     1, 1, 1, 1], _
																 [$eHeal,   1, 1, 1, 1], _
																 [$eHogs,   0, 1, 1, 1], _
																 [$eWiza,   0, 1, 1, 0], _
																 [$eMini,   0, 1, 1, 0], _
																 [$eGobl,   0, 2, 2, 0], _
																 [$eWitc,   0, 1, 1, 0], _
																 [$eValk,   0, 1, 1, 0], _
																 [$eDrag,   0, 1, 1, 0], _
																 [$ePekk,   0, 1, 1, 0], _
																 ["HEROES", 1, 2, 1, 1]]

; Default Deployment for Custom Deployment
Global Const $DEFAULT_CUSTOM_DEPLOY[$DEPLOY_MAX_WAVES][$DEPLOY_COLUMNS] = [[$eESpell, 0, 1, 1, 80], _
																		   [$eGiant, 0, 1, 2, 0], _
																		   [$eArch, 0, 1, 3, 0], _
																		   [$eBarb, 0, 1, 2, 0], _
																		   [$eHogs, 0, 1, 1, 2], _
																		   [$eCastle, 1, 1, 1, 0], _
																		   [$eWall, 0, 1, 4, 1], _
																		   [$eRSpell, 0, 1, 1, 35], _
																		   [$eArch, 0, 2, 3, 0], _
																		   [$eWall, 0, 2, 4, 1], _
																		   [$eKing, 1, 1, 1, 0], _
																		   [$eWall, 0, 3, 4, 1], _
																		   [$eArch, 0, 3, 3, 1], _
																		   [$eWall, 0, 4, 4, 0], _
																		   [$eGiant, 0, 2, 2, 0], _
																		   [$eHSpell, 0, 1, 1, 70], _
																		   [$eBarb, 0, 2, 2, 1], _
																		   [$eWiza, 0, 1, 1, 0], _
																		   [$eMini, 0, 1, 1, 0], _
																		   [$eGobl, 0, 1, 1, 0], _
																		   [$eQueen, 1, 1, 1, 0], _
																		   [$eWarden, 1, 1, 1, 0], _
																		   [$eDeployUnused, 0, 0, 0, 0], _
																		   [$eDeployUnused, 0, 0, 0, 0]]

; Multi Finger Attack Style Setting
Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $iMultiFingerStyle[3] = [0, 0, 0]

; Save Troops Variables and Constants
Global $useFFBarchST = 1
Global $percentCollectors = 80
Global $redlineDistance = 50
Global $usingMultiFinger = False

; SmartZap GUI variables - Added by LunaEclipse
Global $ichkSmartZap = 1
Global $ichkSmartZapDB = 1
Global $ichkSmartZapSaveHeroes = 1
Global $itxtMinDE = 300

; SmartZap stats - Added by LunaEclipse
Global $smartZapGain = 0
Global $numLSpellsUsed = 0

; SmartZap Array to hold Total Amount of DE available from Drill at each level (1-6) - Added by LunaEclipse
Global Const $drillLevelHold[6] = [	120, _
												225, _
												405, _
												630, _
												960, _
												1350]

; SmartZap Array to hold Amount of DE available to steal from Drills at each level (1-6) - Added by LunaEclipse
Global Const $drillLevelSteal[6] = [59, _
                                    102, _
												172, _
												251, _
												343, _
												479]
