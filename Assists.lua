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

	function pack.Actions.StartAthenaShout()
		AthenaShout()
		return true
	end

	function pack.Actions.FinishAthenaShout()
		EndAthenaShout()
		return true
	end


	-- =====================================================
	-- Effects
	-- =====================================================
	pack.Effects.DusaAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.DusaAssist))
	pack.Effects.SkellyAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.SkellyAssist))
	pack.Effects.SisyphusAssist = cc.RigidEffect(cc.BindEffect(pack.Triggers.IfInCombat, pack.Actions.SisyphusAssist))
	-- pack.Effects.AthenaAssist = cc.RigidEffect( cc.BindEffect( pack.Triggers.IfInCombat,
	-- 	 cc.TimedEffect( pack.Actions.StartAthenaShout, pack.Actions.FinishAthenaShout ) ) )
	pack.Effects.AthenaAssist = cc.TimedEffect( pack.Actions.StartAthenaShout, pack.Actions.FinishAthenaShout )
end

-- put our effects into the centralised Effects table, under the "Hades.Cornucopia" path
ModUtil.Path.Set( "Assists", ModUtil.Table.Copy( pack.Effects ), cc.Effects )

-- For testing purposes
-- ModUtil.Path.Wrap( "BeginOpeningCodex", 
-- 	function(baseFunc)		
-- 		if not CanOpenCodex() then
-- 			ModUtil.Hades.PrintStack("Testing Codex function")
-- 			pack.Effects.AthenaAssist()
-- 		end
-- 		baseFunc()
-- 	end
-- )