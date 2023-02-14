local cc, packs = CrowdControl, CrowdControl.Packs
local pack = ModUtil.Mod.Register( "Assists", packs.Hades, false )

pack.Effects = { }; pack.Actions = { }; pack.Triggers = { }
pack.Parametric = { Actions = { }, Triggers = { } }

do
	-- =====================================================
	-- Triggers
	-- =====================================================
	function pack.Triggers.IfInCombat( id, action, ... )
		if not CurrentRun.Hero.IsDead then
			local currentEncounter = CurrentRun.CurrentRoom.Encounter
			if currentEncounter.InProgress and currentEncounter.EncounterType ~= "NonCombat" then
				cc.InvokeEffect( id, action, ... )
			end
		end
		return false
	end

	-- =====================================================
	-- Actions
	-- =====================================================

	-- Summon Dusa for 30 seconds (Companion Fidi)
	function pack.Actions.DusaAssist()
		thread(InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "AssistText", Duration = 1 })
		DusaAssist({Duration = 30})
		return true
	end

	function pack.Actions.SkellyAssist()
		thread(InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "AssistText", Duration = 1 })
		SkellyAssist()
		return true
	end

	function pack.Actions.SisyphusAssist()
		thread(InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "AssistText", Duration = 1 })
		SisyphusLootSprinkle( {
			FunctionName = "SisyphusLootSprinkle",
			SisyphusWeapon = "NPC_Sisyphus_01_Assist",
			LootOptions =
			{
				{
					Name = "MinorMoneyDrop",
					MinAmount = 1,
					MaxAmount = 1,
				},
				{
					Name = "HealDropMinor",
					MinAmount = 4,
					MaxAmount = 4,
				},
				{
					Name = "RoomRewardMetaPointDrop",
					MinAmount = 1,
					MaxAmount = 1,
				},
			},
			Range = 80,
			MinForce = 200,
			MaxForce = 350,
			GameStateRequirements = {},
			AssistPresentationPortrait = "Portrait_Sisyphus_Default_01",
			AssistPresentationColor = { 110, 255, 0, 255 },
			AssistPresentationPortraitOffsetY = 35,
		} )
		return true
	end

	function pack.Actions.DeflectShout()
		AthenaShout()
		wait(5)
		EndAthenaShout()
		return true
	end

	function pack.Actions.WaveClearShout()
		assistData = 	
		{
			WeaponName = "WaveClearSuper",
			GameStateRequirements = {},
			AssistPresentationPortrait = "Portrait_Shades_Default_01",
			-- AssistPresentationPortrait = "Portrait_Thanatos_Default_01",
			AssistPresentationPortraitOffsetY = 45,
			AssistPresentationColor = { 0, 255, 0, 255 },
		}	

		local ShadeAssistVoiceLines = {
			{
				-- PlayOnceFromTableThisRun = true,
				RequiredFalseFlags = { "InFlashback" },
				PreLineWait = 0.5,
				BreakIfPlayed = true,
				RandomRemaining = true,
				-- SuccessiveChanceToPlay = 0.33,

				-- "We got them, my good Shade!
				{ Cue = "/VO/ZagreusField_3347"}, 

				-- Thank you for your support, my Shade!
				{ Cue = "/VO/ZagreusField_3346"},
				
				-- Showed them who's boss, didn't we, Shade?
				{ Cue = "/VO/ZagreusField_3348"},
			},
		}

		-- DoAssistPresentation( assistData )
		local currentRun = CurrentRun
		SetPlayerInvulnerable( "Super" )
		AddInputBlock({ Name = "AssistPreSummon" })

		PlaySound({ Name = assistData.ProcSound or "/Leftovers/SFX/AuraThrowLarge" })
		PlaySound({ Name = "/SFX/Menu Sounds/PortraitEmoteSparklySFX" })

		
		thread( DoRumble, { { LeftTriggerStart = 2, LeftTriggerStrengthFraction = 0.4, LeftTriggerFrequencyFraction = 0.15, LeftTriggerTimeout = 0.3, }, } )

		thread( PlayVoiceLines, ShadeAssistVoiceLines, false ) -- NOTE TO PHY THAT WE CHANGED THIS ONE
		AdjustFullscreenBloom({ Name = "LastKillBloom", Duration = 0 })

		--local assistDimmer = CreateScreenComponent({ Name = "rectangle01", X = ScreenCenterX, Y = ScreenCenterY, Group = "Combat_Menu" })
		local assistDimmer = SpawnObstacle({ Name = "rectangle01", DestinationId = currentRun.Hero.ObjectId, Group = "Combat_UI" })
		Teleport({ Id = assistDimmer, OffsetX = ScreenCenterX, OffsetY = ScreenCenterY })
		DrawScreenRelative({ Ids = { assistDimmer } })
		SetScale({ Id = assistDimmer, Fraction = 10 })
		SetColor({ Id = assistDimmer, Color = {20, 20, 20, 255} })
		--SetAlpha({ Id = assistDimmer, Fraction = 0.0, Duration = 0 })
		SetAlpha({ Id = assistDimmer, Fraction = 0.8, Duration = 0 })

		wait( 0.06 )
		ExpireProjectiles({ ExcludeNames = WeaponSets.ExpireProjectileExcludeProjectileNames })
		AddSimSpeedChange( "Assist", { Fraction = 0.005, LerpTime = 0 } )
		SetAnimation({ Name = "ZagreusSummon", DestinationId = CurrentRun.Hero.ObjectId })
		CreateAnimation({ Name = "SuperStartFlare", DestinationId = CurrentRun.Hero.ObjectId, Color = assistData.AssistPresentationColor or Color.Red })

		waitScreenTime(  0.32 )

		local currentRun = CurrentRun
		HideCombatUI("AssistPresentationPortrait")

		ApplyEffectFromWeapon({ Id = currentRun.Hero.ObjectId, DestinationId = currentRun.Hero.ObjectId, WeaponName = "ShoutSelfSlow", EffectName = "ShoutSelfSlow", AutoEquip = true })
		Rumble({ Fraction = 0.7, Duration = 0.3 })
		AdjustFullscreenBloom({ Name = "LightningStrike", Duration = 0 })
		AdjustFullscreenBloom({ Name = "WrathPhase2", Duration = 0.1, Delay = 0 })
		AdjustRadialBlurStrength({ Fraction = 1.5, Duration = 0 })
		AdjustRadialBlurDistance({ Fraction = 0.125, Duration = 0 })
		AdjustRadialBlurStrength({ Fraction = 0, Duration = 0.03, Delay=0 })
		AdjustRadialBlurDistance({ Fraction = 0, Duration = 0.03, Delay=0 })

		local wrathPresentationOffsetY = 100
		local wrathStreak = SpawnObstacle({ Name = "BlankObstacle", DestinationId = currentRun.Hero.ObjectId, Group = "Combat_UI" })
		Teleport({ Id = wrathStreak, OffsetX = (1920/2), OffsetY = 800 + wrathPresentationOffsetY })
		DrawScreenRelative({ Ids = { wrathStreak } })
		CreateAnimation({ Name = "WrathPresentationStreak", DestinationId = wrathStreak, Color = assistData.AssistPresentationColor or Color.Red })

		local portraitOffsetXBuffer = assistData.AssistPresentationPortraitOffsetX or 0
		local portraitOffsetYBuffer = assistData.AssistPresentationPortraitOffsetY or 0

		local godImage = SpawnObstacle({ Name = "BlankObstacle", DestinationId = currentRun.Hero.ObjectId, Group = "Combat_Menu" })
		Teleport({ Id = godImage, OffsetX = -300 + portraitOffsetXBuffer, OffsetY = (1080/2) + 80 + wrathPresentationOffsetY + portraitOffsetYBuffer })
		DrawScreenRelative({ Ids = { godImage } })
		CreateAnimation({ Name = assistData.AssistPresentationPortrait, DestinationId = godImage, Scale = "1.0" })

		local godImage2 = SpawnObstacle({ Name = "BlankObstacle", DestinationId = currentRun.Hero.ObjectId, Group = "Combat_UI" })
		Teleport({ Id = godImage2, OffsetX = 60, OffsetY = (1080/2) + 90 + wrathPresentationOffsetY })
		DrawScreenRelative({ Ids = { godImage2 } })
		if assistData.AssistPresentationPortrait2 then
			CreateAnimation({ Name = assistData.AssistPresentationPortrait2, DestinationId = godImage2, Scale = "1.0" })
		end

		local wrathStreakFront = SpawnObstacle({ Name = "BlankObstacle", DestinationId = currentRun.Hero.ObjectId, Group = "Combat_Menu_Overlay" })
		Teleport({ Id = wrathStreakFront, OffsetX = 900, OffsetY = 1150 + wrathPresentationOffsetY })
		DrawScreenRelative({ Ids = { wrathStreakFront } })
		CreateAnimation({ Name = "WrathPresentationBottomDivider", DestinationId = wrathStreakFront, Scale = "1.25", Color = assistData.AssistPresentationColor or Color.Red })

		local wrathVignette = SpawnObstacle({ Name = "BlankObstacle", DestinationId = currentRun.Hero.ObjectId, Group = "FX_Standing_Top" })
		Teleport({ Id = wrathVignette, OffsetX = ScreenCenterX, OffsetY = ScreenCenterY })
		DrawScreenRelative({ Ids = { wrathVignette } })
		CreateAnimation({ Name = "WrathVignette", DestinationId = wrathVignette, Color = Color.Red })

		-- audio
		local dummyGodSource = {}

		AddSimSpeedChange( "Assist", { Fraction = 0.1, LerpTime = 0.06 } )
		SetThingProperty({ Property = "ElapsedTimeMultiplier", Value = 3, ValueChangeType = "Multiply", DataValue = false, DestinationNames = { "HeroTeam" } })

		ScreenAnchors.FullscreenAlertFxAnchor = CreateScreenObstacle({ Name = "BlankObstacle", Group = "Scripting", X = ScreenCenterX, Y = ScreenCenterY })

		local fullscreenAlertDisplacementFx = SpawnObstacle({ Name = "FullscreenAlertDisplace", Group = "FX_Displacement", DestinationId = ScreenAnchors.FullscreenAlertFxAnchor})
		DrawScreenRelative({ Id = fullscreenAlertDisplacementFx })

		Move({ Id = godImage, Angle = 8, Distance = 800, Duration = 0.2, EaseIn = 0.2, EaseOut = 1, TimeModifierFraction = 0 })

			Move({ Id = godImage2, Angle = 8, Distance = 800, Duration = 0.2, EaseIn = 0.2, EaseOut = 1, TimeModifierFraction = 0 })

		Move({ Id = wrathStreakFront, Angle = 8, Distance = 200, Duration = 0.5, EaseIn = 0.9, EaseOut = 1, TimeModifierFraction = 0 })
		Move({ Id = playerImage, Angle = 170, Speed = 50, TimeModifierFraction = 0 })

		SetColor({ Id = wrathVignette, Color = {0, 0, 0, 0.4}, Duration = 0.05, TimeModifierFraction = 0 })

		waitScreenTime(  0.25 )
		PlaySound({ Name = "/SFX/Menu Sounds/PortraitEmoteSurpriseSFX" })

		AdjustFullscreenBloom({ Name = "Off", Duration = 0.1, Delay = 0 })
		Move({ Id = godImage, Angle = 8, Distance = 100, Duration = 1, EaseIn = 0.5, EaseOut = 0.5, TimeModifierFraction = 0 })

			Move({ Id = godImage2, Angle = 8, Distance = 100, Duration = 1, EaseIn = 0.5, EaseOut = 0.5, TimeModifierFraction = 0 })

		Move({ Id = wrathStreakFront, Angle = 8, Distance = 25, Duration = 1, EaseIn = 0.5, EaseOut = 1, TimeModifierFraction = 0 })

		waitScreenTime(  0.55 )
		AdjustZoom({Fraction = currentRun.CurrentRoom.ZoomFraction or 0.9, LerpTime = 0.25})

		PlaySound({ Name = "/Leftovers/Menu Sounds/TextReveal3" })

		RemoveInputBlock({ Name = "AssistPreSummon" })
		for k, enemy in pairs( ActiveEnemies ) do
			if enemy.AssistReactionVoiceLines ~= nil then
				thread( PlayVoiceLines, enemy.AssistReactionVoiceLines, nil, enemy )
			end
		end

		thread( CrowdReactionPresentation, { AnimationNames = { "StatusIconSmile", "StatusIconOhBoy", "StatusIconEmbarrassed" }, Sound = "/SFX/TheseusCrowdCheer", ReactionChance = 0.05, Requirements = { RequiredRoom = "C_Boss01" }, Delay = 1, Shake = true, RadialBlur = true } )

		SetAlpha({ Id = godImage, Fraction = 0, Duration = 0.12, TimeModifierFraction = 0 })

			SetAlpha({ Id = godImage2, Fraction = 0, Duration = 0.12, TimeModifierFraction = 0 })

		SetAlpha({ Id = wrathVignette, Fraction = 0, Duration = 0.06 })
		SetColor({ Id = assistDimmer, Color = {0.0, 0, 0, 0}, Duration = 0.06 })
		SetAlpha({ Id = fullscreenAlertDisplacementFx, Fraction = 0, Duration = 0.06 })
		--ModifyTextBox({ Id = defianceText, FadeTarget = 0.0, FadeDuration = 0.3, ColorTarget = {1, 0, 0, 1}, ColorDuration = 0.3 })

		waitScreenTime(  0.06 )

		PlaySound({ Name = "/SFX/WrathStart", Id = CurrentRun.Hero.ObjectId })
		FireWeaponFromUnit({ Weapon = "WaveClearSuper", Id = CurrentRun.Hero.ObjectId, DestinationId = CurrentRun.Hero.ObjectId,
			AutoEquip = true, ClearAllFireRequests = true })

		thread( DoAssistPresentationPostWeapon, assistData )
		-- thread( AssistCompletePresentation, assistData )
		-- thread( PlayVoiceLines, ShadeAssistVoiceLines, false)
		return true
	end

	-- =====================================================
	-- Effects
	-- =====================================================
	pack.Effects.DusaAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.DusaAssist))
	pack.Effects.SkellyAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.SkellyAssist))
	pack.Effects.SisyphusAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.SisyphusAssist))
	pack.Effects.AthenaAssist = pack.Actions.DeflectShout
	pack.Effects.ScreenNuke = cc.RigidEffect( cc.BindEffect( packs.Hades.MyGoodShades.Triggers.IfRunActive, pack.Actions.WaveClearShout))
end

-- put our effects into the centralised Effects table, under the "Hades.Cornucopia" path
ModUtil.Path.Set( "Assists", ModUtil.Table.Copy( pack.Effects ), cc.Effects )

-- -- For testing purposes
-- ModUtil.Path.Wrap( "BeginOpeningCodex", 
-- 	function(baseFunc)		
-- 		if not CanOpenCodex() then
-- 			-- ModUtil.Hades.PrintStack("Testing") --..enemy.Name)
-- 			pack.Actions.WaveClearShout()
-- 		end
-- 		baseFunc()
-- 	end
-- )