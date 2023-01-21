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
		if not CurrentRun.Hero.IsDead and TableLength(CurrentRun.Hero.LastStands) > 0 then
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

		local HelloVoiceLines = {
			{
				-- PlayOnceFromTableThisRun = true,
				RequiredFalseFlags = { "InFlashback" },
				PreLineWait = 1.0,
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
	
		local playedSomething = PlayVoiceLines(HelloVoiceLines, false)
		return true, KillHero( { }, { }, { } )
	end


	-- Hello World! Zagreus says hello!
	function pack.Actions.SayHello()
		local HelloVoiceLines = {
			{
				-- PlayOnceFromTableThisRun = true,
				RequiredFalseFlags = { "InFlashback" },
				PreLineWait = 1.0,
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
				{ Cue = "/VO/ZagreusHome_3098"}
							
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
			Icon = "ExtraLifeHeart",
			HealFraction = 0.5
		})
		UpdateLifePips()
		return true
	end

	-- Removes a Death Defiance (if any) 
	function pack.Actions.DDRemove()
		LostLastStandPresentation()
		RemoveLastStand()
		UpdateLifePips()
		return true
	end

	-- Flashbangs the player for 5 secionds
	function pack.Actions.Flashbang()
		-- FadeOut({Color = Color.White, Duration = 0})
		-- FadeIn({Duration = 5})
		FadeOut({Color = Color.White, Duration = 0})
		thread( pack.Actions.FlashbangFadeout )
		return true
	end
	  
	function pack.Actions.FlashbangFadeout()
		wait(2)
		FadeIn({Duration = 3})
	end

	function pack.Actions.WaveClearShout()
		FireWeaponFromUnit({ Weapon = "WaveClearSuper", Id = CurrentRun.Hero.ObjectId, DestinationId = CurrentRun.Hero.ObjectId,
			AutoEquip = true, ClearAllFireRequests = true })
		return true
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
	pack.Effects.ScreenNuke = cc.RigidEffect( cc.BindEffect( pack.Triggers.IfInCombat, pack.Actions.WaveClearShout))
end


-- put our effects into the centralised Effects table, under the "Hades.MyGoodShades" path
ModUtil.Path.Set( "MyGoodShades", ModUtil.Table.Copy( pack.Effects ), cc.Effects )

-- For testing purposes
-- ModUtil.Path.Wrap( "BeginOpeningCodex", 
-- 	function(baseFunc)		
-- 		if not CanOpenCodex() then
-- 			-- ModUtil.Hades.PrintStack("Testing") --..enemy.Name)
-- 			pack.Actions.Flashbang()
-- 		end
-- 		baseFunc()
-- 	end
-- )