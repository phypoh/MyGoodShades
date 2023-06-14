local cc, packs = CrowdControl, CrowdControl.Packs
local pack = ModUtil.Mod.Register( "MyGoodShades", packs.Hades, false )

pack.Effects = { }; pack.Actions = { }; pack.Triggers = { }
pack.Parametric = { Actions = { }, Triggers = { } }

ModUtil.Path.Wrap( "SetupMap", function(baseFunc)
	local package = "MyGoodShades"
	DebugPrint({Text = "Trying to load package "..package..".pkg"})
	LoadPackages({Name = package})
	return baseFunc()
end)

do
	-- =====================================================
	-- Triggers
	-- =====================================================
	function pack.Triggers.IfRunActive( id, action, ... )
		if not CurrentRun.Hero.IsDead then
			cc.InvokeEffect( id, action, ... )
			return true
		end
		return false
	end

	function pack.Triggers.IfInCombat( id, action, ... )
		if not CurrentRun.Hero.IsDead then
			local currentEncounter = CurrentRun.CurrentRoom.Encounter
			-- ModUtil.Hades.PrintStack(currentEncounter.InProgress) 
			-- ModUtil.Hades.PrintStack(currentEncounter.InProgress and currentEncounter.EncounterType ~= "NonCombat") 
			if currentEncounter.InProgress and currentEncounter.EncounterType ~= "NonCombat" then
				cc.InvokeEffect( id, action, ... )
				return true
			end
		end
		return false
	end

	function pack.Triggers.CheckLastStand( id, action, ... )
		if HasLastStand( CurrentRun.Hero ) then
			cc.InvokeEffect( id, action, ... )
			return true
		end
		return false
	end
		

	-- Experimental Triggers 
	-- function pack.Triggers.NextEncounter()
	-- 	-- TO FINISH
	-- 	return false
	-- end

	-- =====================================================
	-- Actions
	-- =====================================================

	-- Hope you enjoyed the show, my good Shade!
	function pack.Actions.KillHero( id )

		local DeadVoiceLines = {
			{
				-- PlayOnceFromTableThisRun = true,
				RequiredFalseFlags = { "InFlashback" },
				PreLineWait = 1.00,
				BreakIfPlayed = true,
				RandomRemaining = true,

				-- Hope you enjoyed the show, my good Shade!
				{ Cue = "/VO/ZagreusField_3345"},

				-- Someone's going to enjoy this.
				{ Cue = "/VO/ZagreusField_1036"},

				-- Someone'll like this
				{ Cue = "/VO/ZagreusField_1037"},
			},
		}
	
		local playedSomething = PlayVoiceLines(DeadVoiceLines, false)
		return true, KillHero( { }, { }, { } )
	end


	-- Hello World! Zagreus says hello!
	function pack.Actions.SayHello()
		local HelloVoiceLines = {
			{
				-- PlayOnceFromTableThisRun = true,
				RequiredFalseFlags = { "InFlashback" },
				PreLineWait = 0.5,
				BreakIfPlayed = true,
				RandomRemaining = true,
				-- SuccessiveChanceToPlay = 0.33,

				-- Greetings everyone! Just visiting...
				{ Cue = "/VO/ZagreusHome_2077"}, 

				-- Hello, I'll only be a moment!
				{ Cue = "/VO/ZagreusHome_2079"},

				-- Just thought I'd say hello!
				{ Cue = "/VO/ZagreusHome_2081"},

				-- That was for you, good Shade!
				{ Cue = "/VO/ZagreusField_3344"},

				-- Just me, pretend I'm not even here.
				{ Cue = "/VO/ZagreusHome_2083"},

				-- You shades hang in there
				{ Cue = "/VO/ZagreusHome_2888"}, 

				-- You shades doing alright? 
				{ Cue = "/VO/ZagreusHome_3076"}, 

				-- Seriously, you shades keep it up
				{ Cue = "/VO/ZagreusHome_3098"},

				-- Hello, supportive Shade!
				{ Cue = "/VO/ZagreusField_3027"},
							
			},
		}
		-- ModUtil.Hades.PrintStack("Hello World!")
		-- thread( PlayVoiceLines, HelloVoiceLines, false)
		local playedSomething = PlayVoiceLines(HelloVoiceLines, false)
		return playedSomething
	end

	-- Calling Aid. Add 50 to the call gauge
	function pack.Actions.BuildSuperMeter()
		if IsSuperValid() then 
			BuildSuperMeter(CurrentRun, CurrentRun.Hero.SuperMeterLimit)
			PlaySound({ Name = "/Leftovers/SFX/StaminaRefilled", Id = CurrentRun.Hero.ObjectId })
			return true
		end
		return false
	end	

	-- Adds a Death Defiance (increases maximum if any)
	function pack.Actions.DDAdd()
		local atMaxLastStands = CurrentRun.Hero.MaxLastStands == TableLength(CurrentRun.Hero.LastStands)
		AddLastStand({
			IncreaseMax = atMaxLastStands,
			Silent = true,
			WeaponName = 'LastStandMetaUpgradeShield',
			Icon = "DDCrowdControl",
			HealFraction = 0.5
		})
		UpdateLifePips()
		PlaySound({ Name = "/Leftovers/SFX/StaminaRefilled", Id = CurrentRun.Hero.ObjectId })
		thread(InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "DDGainedText", Duration = 1 })
		return true
	end

	-- Removes a Death Defiance (if any) 
	function pack.Actions.DDRemove()
		PlaySound({ Name = "/Leftovers/SFX/PlayerKilled", Id = CurrentRun.Hero.ObjectId })
		-- InCombatTextArgs({ TargetId = CurrentRun.Hero.ObjectId, Text = "DDLostText", Duration = 0.5 })
		thread(InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "DDLostText", Duration = 1 })
		thread(CheckLastStand, CurrentRun.Hero, CurrentRun.Hero)
		-- CheckLastStand( CurrentRun.Hero, CurrentRun.Hero )
		return true
	end

	-- Flashbangs the player for 5 secionds
	function pack.Actions.Flashbang()
		local SurprisedVoiceLines = {
			{
				-- PlayOnceFromTableThisRun = true,
				RequiredFalseFlags = { "InFlashback" },
				PreLineWait = 0.25,
				BreakIfPlayed = true,
				RandomRemaining = true,
				-- SuccessiveChanceToPlay = 0.33,

				-- Aahh!
				{ Cue = "/VO/ZagreusField_0068" },
				-- Wha--?
				{ Cue = "/VO/ZagreusField_0069" },
				-- Wha?!
				{ Cue = "/VO/ZagreusField_0070" },
				-- Aarrgh!
				{ Cue = "/VO/ZagreusField_0073" },
				-- Ah, damn it!
				{ Cue = "/VO/ZagreusField_0075" },
				-- Why, you...!
				{ Cue = "/VO/ZagreusField_0076" },
				-- Wha, how?
				{ Cue = "/VO/ZagreusField_0078" },
			},
		}

		PlaySound({ Name = "/SFX/Explosion1", Id = CurrentRun.Hero.ObjectId })
		-- PlayVoiceLines(SurprisedVoiceLines, false)
		thread( PlayVoiceLines, SurprisedVoiceLines, false)
		thread( FadeOut, {Color = Color.White, Duration = 0})
	
		thread( pack.Actions.FlashbangFadeout )
		return true
	end
	  
	function pack.Actions.FlashbangFadeout()
		wait(2)
		FadeIn({Duration = 3})
	end

	-- =====================================================
	-- Effects
	-- =====================================================
	pack.Effects.HelloWorld = pack.Actions.SayHello
	pack.Effects.KillHero = cc.BindEffect( packs.Hades.Base.Triggers.IfCanMove, pack.Actions.KillHero )
	pack.Effects.BuildSuperMeter = cc.RigidEffect( cc.BindEffect( pack.Triggers.IfInCombat, pack.Actions.BuildSuperMeter ) )
	pack.Effects.DDAdd = cc.RigidEffect( cc.BindEffect( pack.Triggers.IfRunActive, pack.Actions.DDAdd))
	pack.Effects.DDRemove = cc.RigidEffect( cc.BindEffect( pack.Triggers.CheckLastStand, pack.Actions.DDRemove))
	pack.Effects.Flashbang = cc.BindEffect( pack.Triggers.IfInCombat, pack.Actions.Flashbang)
end


-- put our effects into the centralised Effects table, under the "Hades.MyGoodShades" path
ModUtil.Path.Set( "MyGoodShades", ModUtil.Table.Copy( pack.Effects ), cc.Effects )

-- For testing purposes
-- ModUtil.Path.Wrap( "BeginOpeningCodex", 
-- 	function(baseFunc)		
-- 		-- if not CanOpenCodex() then
-- 		ModUtil.Hades.PrintStack("Testing") --..enemy.Name)
-- 		cc.NotifyCustomEffect(0, "resetPools", "Finished", 208)
-- 		-- end
-- 		baseFunc()
-- 	end
-- )
