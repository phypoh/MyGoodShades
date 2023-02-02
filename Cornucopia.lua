local cc, packs = CrowdControl, CrowdControl.Packs
local pack = ModUtil.Mod.Register( "Cornucopia", packs.Hades, false )

pack.Effects = { }; pack.Actions = { }; pack.Triggers = { }
pack.Parametric = { Actions = { }, Triggers = { } }

do
	MGSConsumableData = ModUtil.Entangled.ModData(ConsumableData)
	MGSConsumableData.StoreRewardRandomStack.UseText = "PomShardUseText"
	-- =====================================================
	-- Triggers
	-- =====================================================

	function pack.Triggers.IfOutOfCombat( id, action, ... )
		if not CurrentRun.Hero.IsDead then
			local currentEncounter = CurrentRun.CurrentRoom.Encounter
			if not currentEncounter.InProgress or currentEncounter.EncounterType == "NonCombat" then
				cc.InvokeEffect( id, action, ... )
				return true
			end
		end
		return false
	end

	-- =====================================================
	-- Actions
	-- =====================================================

	-- Spawn some moolah
	function pack.Actions.SpawnMoney()
		local dropItemName = "MinorMoneyDrop"
		GiveRandomConsumables({
			Delay = 0.5,
			NotRequiredPickup = true,
			LootOptions =
			{
				{
					Name = dropItemName,
					Chance = 1,
				}
			}
		})
		return true
	end

	-- Spawns a small heal drop (heals for 10)
	function pack.Actions.SpawnHealDrop()
		DropHealth( "HealDropMinor", CurrentRun.Hero.ObjectId )
		return true
	end

	-- Gift some nectar
	function pack.Actions.SpawnNectar()
		local dropItemName = "GiftDrop"
		GiveRandomConsumables({
			Delay = 0.5,
			NotRequiredPickup = true,
			LootOptions =
			{
				{
					Name = dropItemName,
					Chance = 1,
				}
			}
		})
		return true
	end

	function pack.Actions.SpawnPomShard()
		local dropItemName = "StoreRewardRandomStack"
		GiveRandomConsumables({
			Delay = 0.5,
			NotRequiredPickup = true,
			LootOptions =
			{
				{
					Name = dropItemName,
					Chance = 1,
				}
			}
		})
		return true
	end

	-- Cures Poison
	-- Note for developer: code adapted from PoisonCureFountainStyx in ObstacleData.lua and UseStyxFountain in Interactables.lua
	function pack.Actions.PoisonCure()
		if not HasEffect({ Id = CurrentRun.Hero.ObjectId, EffectName = "StyxPoison" }) then 
			return false
		end

		local CuredVoiceLines =
		{
			Cooldowns =
			{
				{ Name = "ZagreusAnyQuipSpeech" },
				{ Name = "ZagCuredPoisonSpeech", Time = 15 }
			},
			{
				BreakIfPlayed = true,
				RandomRemaining = true,
				PreLineWait = 0.45,
				-- RequiredHasEffect = "StyxPoison",
				SuccessiveChanceToPlay = 0.5,

				-- Whew.
				{ Cue = "/VO/ZagreusField_2131", },
				-- Better.
				{ Cue = "/VO/ZagreusField_2132", },
				-- There.
				{ Cue = "/VO/ZagreusField_2133", },
				-- Cured.
				{ Cue = "/VO/ZagreusField_2134", },
				-- Good.
				{ Cue = "/VO/ZagreusField_2135", },
				-- OK.
				{ Cue = "/VO/ZagreusField_2136", },
				-- Mmm.
				{ Cue = "/VO/ZagreusField_2137", },
				-- Clean.
				{ Cue = "/VO/ZagreusField_2138", },
			},
		}

		ClearEffect({ Id = CurrentRun.Hero.ObjectId, Name = "StyxPoison" })
		BlockEffect({ Id = CurrentRun.Hero.ObjectId, Name = "StyxPoison", Duration = 0.75 })
		thread(InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "CuredText", Duration = 0.75 })
		thread( PlayVoiceLines, CuredVoiceLines, false )
		return true
	end 


	function pack.Actions.DropBoon()
		local LootNames = OrderedKeysToList( LootData )
		local output = {}
		for i, lootName in pairs( LootNames ) do
			local lootData = LootData[lootName]
			if lootData.GodLoot and IsGameStateEligible( CurrentRun, lootData ) then
				table.insert(output, lootName)
			end
		end

		local LootGod = GetRandomValue(output)
		
		-- ModUtil.Hades.PrintStack(LootGod) 
		if LootGod == nil then
			CreateLoot({ Name = "HermesUpgrade", OffsetX = 100, SpawnPoint = CurrentRun.Hero.ObjectId })
		else
			CreateLoot({ Name = LootGod, OffsetX = 100, SpawnPoint = CurrentRun.Hero.ObjectId })
		end
		return true
	end


	-- =====================================================
	-- Effects
	-- =====================================================
	pack.Effects.DropHeal = pack.Actions.SpawnHealDrop
	pack.Effects.DropMoney = cc.RigidEffect( cc.BindEffect( packs.Hades.MyGoodShades.Triggers.IfRunActive, pack.Actions.SpawnMoney ))
	pack.Effects.DropNectar = pack.Actions.SpawnNectar
	pack.Effects.DropPomShard = cc.RigidEffect( cc.BindEffect( packs.Hades.MyGoodShades.Triggers.IfRunActive, pack.Actions.SpawnPomShard ))
	pack.Effects.PoisonCure = cc.RigidEffect( pack.Actions.PoisonCure )
	pack.Effects.DropBoon =  cc.BindEffect( pack.Triggers.IfOutOfCombat, pack.Actions.DropBoon )
end

-- put our effects into the centralised Effects table, under the "Hades.Cornucopia" path
ModUtil.Path.Set( "Cornucopia", ModUtil.Table.Copy( pack.Effects ), cc.Effects )

-- For testing purposes
-- ModUtil.Path.Wrap( "BeginOpeningCodex", 
-- 	function(baseFunc)		
-- 		if not CanOpenCodex() then
-- 			pack.Actions.DropBoon()
-- 		end
-- 		baseFunc()
-- 	end
-- )