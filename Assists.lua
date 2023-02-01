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
		DusaAssist({Duration = 30})
		return true
	end

	function pack.Actions.SkellyAssist()
		SkellyAssist()
		return true
	end

	function pack.Actions.SisyphusAssist()
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

		local AssistVoiceLines = {
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

		DoAssistPresentation( assistData )

		PlaySound({ Name = "/SFX/WrathStart", Id = CurrentRun.Hero.ObjectId })
		FireWeaponFromUnit({ Weapon = "WaveClearSuper", Id = CurrentRun.Hero.ObjectId, DestinationId = CurrentRun.Hero.ObjectId,
			AutoEquip = true, ClearAllFireRequests = true })

		thread( DoAssistPresentationPostWeapon, assistData )
		thread( AssistCompletePresentation, assistData )
		thread( PlayVoiceLines, AssistVoiceLines, false)
		return true
	end

	-- =====================================================
	-- Effects
	-- =====================================================
	pack.Effects.DusaAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.DusaAssist))
	pack.Effects.SkellyAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.SkellyAssist))
	pack.Effects.SisyphusAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.SisyphusAssist))
	pack.Effects.AthenaAssist = pack.Actions.DeflectShout
	pack.Effects.ScreenNuke = cc.RigidEffect( cc.BindEffect( pack.Triggers.IfRunActive, pack.Actions.WaveClearShout))
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