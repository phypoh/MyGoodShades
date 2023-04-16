local cc, packs = CrowdControl, CrowdControl.Packs
local pack = ModUtil.Mod.Register( "Legion", packs.Hades, false )

pack.Effects = { }; pack.Actions = { }; pack.Triggers = { }
pack.Parametric = { Actions = { }, Triggers = { } }

do
	-- =====================================================
	-- Triggers
	-- =====================================================

	function pack.Triggers.IfNotFirstRoom(id, action, ...)
		if CurrentRun.CurrentRoom.Name ~= "RoomOpening" then
				cc.InvokeEffect( id, action, ... )	
				return true
		end
		return false
	end

	function pack.Parametric.Triggers.DuplicateCheck( enemyName )
		return function(...)
			if CurrentRun.CurrentRoom.Name == "RoomOpening" then
				return false
			end

			for enemyid, enemy in pairs( ActiveEnemies ) do
				-- ModUtil.Hades.PrintStack("Enemy present: "..enemy.Name)
				if enemy.Name == enemyName then
					return false
				end
			end
			cc.InvokeEffect(...)
			return true
		end
	end

	function pack.Triggers.BossCheck(id, action, ... )
		local currentEncounter = CurrentRun.CurrentRoom.Encounter
		local numBoss = 0
		if CurrentRun.CurrentRoom.Name == "RoomOpening" or not ( currentEncounter.InProgress and currentEncounter.EncounterType ~= "NonCombat" ) then
			return false
		end

		for enemyid, enemy in pairs( ActiveEnemies ) do
			-- ModUtil.Hades.PrintStack("Enemy present: "..enemy.Name)
			if enemy.IsBoss then
				numBoss = numBoss + 1
			end
		end

		if numBoss >= 2 then
			return false
		end

		cc.InvokeEffect(id, action, ...)
		return true
	end

	function pack.Parametric.Triggers.DoubleBossCheck( bossName )
		return function( ... )
			local currentEncounter = CurrentRun.CurrentRoom.Encounter
			local numBoss = 0
			if CurrentRun.CurrentRoom.Name == "RoomOpening" or not ( currentEncounter.InProgress and currentEncounter.EncounterType ~= "NonCombat" ) then
				return false
			end

			for enemyid, enemy in pairs( ActiveEnemies ) do
				-- ModUtil.Hades.PrintStack("Enemy present: "..enemy.Name)
				if enemy.IsBoss then
					numBoss = numBoss + 1
				end
				if enemy.Name == bossName then
					-- ModUtil.Hades.PrintStack("Same boss")
					return false
				end
			end

			if numBoss >= 2 then
				-- ModUtil.Hades.PrintStack("Too many")
				return false
			end

			cc.InvokeEffect( ... )
			return true
		end
	end
	-- =====================================================
	-- Actions
	-- =====================================================
	

	local function getHealthScalingForBiome()
		local biomeNumber = GetBiomeDepth(CurrentRun)
		-- biomeNumber ==
		--   Tartarus -> 1 
		--   Asphodel -> 2
		--   Elysium -> 3
		--   Styx/Surface -> 4
		
		-- scaledHealthMultiplier == 
		-- 	Tartarus -> 1 
		
		-- 	Asphodel -> 1.5
		-- 	Elysium -> 2
		-- 	Styx/Surface -> 2.5
		-- if biomeNumber == nil then
		-- 	return 1
		-- end

		return 0.5 * (biomeNumber + 1)
	end


	function SpawnEnemy(enemyData, scaledHealth)
		local currentEncounter = CurrentRun.CurrentRoom.Encounter
		local newEnemy = DeepCopyTable( enemyData )
		if scaledHealth then
			local newHealth = scaledHealth * getHealthScalingForBiome() 
			newEnemy.MaxHealth = newHealth
		end
		newEnemy.AIOptions = enemyData.AIOptions
		-- newEnemy.BlocksLootInteraction = false
		local invaderSpawnPoint = SelectSpawnPoint(CurrentRun.CurrentRoom, newEnemy, currentEncounter)
		newEnemy.ObjectId = SpawnUnit({
				Name = enemyData.Name,
				Group = "Standing",
				DestinationId = invaderSpawnPoint, 
				OffsetX = math.random(-200,200), 
				OffsetY = math.random(-200,200) 
			})
		SetupEnemyObject( newEnemy, CurrentRun )
		return true
	end

	function pack.Parametric.Actions.SpawnEnemies(selection, count, scaledHealth)
		return function (...)
			PlaySound({ Name = "/SFX/FightGong" })
			local enemyData = EnemyData[selection]
			for i=1, count do
				SpawnEnemy(enemyData, scaledHealth)
			end
		return true
		end
	end

	function RefreshBossHealthUI()
		for enemyid, enemy in pairs( ActiveEnemies ) do
			-- ModUtil.Hades.PrintStack("Enemy present: "..enemy.Name)
			if enemy.IsBoss then
				RemoveEnemyUI( enemy )
				-- enemy.HasHealthBar = false
				CreateBossHealthBar( enemy )
			end
		end
		-- for enemyid, enemy in pairs( ActiveEnemies ) do
		-- 	-- ModUtil.Hades.PrintStack("Enemy present: "..enemy.Name)
		-- 	if enemy.IsBoss then
		-- 		enemy.HasHealthBar = false
		-- 		CreateBossHealthBar( enemy )
		-- 		-- CreateCCBossHealthBar( enemy )
		-- 	end
		-- end
	end

	function pack.Parametric.Actions.SpawnBoss(bossName, scaledHealth)
		return function (...)
			PlaySound({ Name = "/SFX/FightGong" })
			thread(InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "BossSpawnText", Duration = 1 })
			local currentEncounter = CurrentRun.CurrentRoom.Encounter
			local enemyData = EnemyData[bossName]
			local newEnemy = DeepCopyTable( enemyData )
			if scaledHealth then
				local newHealth = scaledHealth * getHealthScalingForBiome() 
				newEnemy.MaxHealth = newHealth
			end
			newEnemy.AIOptions = enemyData.AIOptions
			newEnemy.BlocksLootInteraction = false
			local invaderSpawnPoint = SelectSpawnPoint(CurrentRun.CurrentRoom, newEnemy, currentEncounter)
			newEnemy.ObjectId = SpawnUnit({ Name = enemyData.Name, Group = "Standing", 
				DestinationId = invaderSpawnPoint, 
				OffsetX = math.random(-5,5), 
				OffsetY = math.random(-5,5) 
			})
			SetupEnemyObject( newEnemy, CurrentRun, { SkipSpawnVoiceLines = true }  )
			UseableOff({ Id = newEnemy.ObjectId })
			
			-- wait(0.5)

			-- thread( CreateBossHealthBar, newEnemy )
			RefreshBossHealthUI()
			return true
		end
	end

	-- =====================================================
	-- Effects
	-- =====================================================

	pack.Effects.SpawnNumbskull = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Parametric.Actions.SpawnEnemies("SwarmerHelmeted", 5, 30))
	pack.Effects.SpawnPest = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Parametric.Actions.SpawnEnemies("ThiefMineLayer", 5, 40))
	pack.Effects.SpawnVoidstone = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Parametric.Actions.SpawnEnemies("ShieldRanged", 1, 175))
	pack.Effects.SpawnButterflyBall = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Parametric.Actions.SpawnEnemies("FlurrySpawner", 1, 275))
	pack.Effects.SpawnFlameWheel = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Parametric.Actions.SpawnEnemies("ChariotSuicide", 5))
	pack.Effects.SpawnSnakestone = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Parametric.Actions.SpawnEnemies("HeavyRangedForked", 1, 215))
	pack.Effects.SpawnSatyr = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Parametric.Actions.SpawnEnemies("SatyrRanged", 1, 375))

	-- pack.Effects.SpawnMeg = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Parametric.Actions.SpawnBoss( "Harpy", 4400 )))
	-- pack.Effects.SpawnAlecto = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Parametric.Actions.SpawnBoss( "Harpy2", 4600 )))
	-- pack.Effects.SpawnTis = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Parametric.Actions.SpawnBoss( "Harpy3", 5200 )))
	-- pack.Effects.SpawnTheseus = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Parametric.Actions.SpawnBoss( "Theseus", 4500 )))
	-- pack.Effects.SpawnAsterius = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Parametric.Actions.SpawnBoss( "Minotaur", 7000 )))

	pack.Effects.SpawnMeg = cc.RigidEffect(cc.BindEffect(pack.Parametric.Triggers.DoubleBossCheck("Harpy"), pack.Parametric.Actions.SpawnBoss( "Harpy", 4400 )))
	pack.Effects.SpawnAlecto = cc.RigidEffect(cc.BindEffect(pack.Parametric.Triggers.DoubleBossCheck("Harpy2"), pack.Parametric.Actions.SpawnBoss( "Harpy2", 4600 )))
	pack.Effects.SpawnTis = cc.RigidEffect(cc.BindEffect(pack.Parametric.Triggers.DoubleBossCheck("Harpy3"), pack.Parametric.Actions.SpawnBoss( "Harpy3", 5200 )))
	pack.Effects.SpawnTheseus = cc.RigidEffect(cc.BindEffect(pack.Parametric.Triggers.DoubleBossCheck("Theseus"), pack.Parametric.Actions.SpawnBoss( "Theseus", 4500 )))
	pack.Effects.SpawnAsterius = cc.RigidEffect(cc.BindEffect(pack.Parametric.Triggers.DoubleBossCheck("Minotaur"), pack.Parametric.Actions.SpawnBoss( "Minotaur", 7000 )))

end

-- put our effects into the centralised Effects table, under the "Hades.Legion" path
ModUtil.Path.Set( "Legion", ModUtil.Table.Copy( pack.Effects ), cc.Effects )


-- For testing purposes
-- ModUtil.Path.Wrap( "BeginOpeningCodex", 
-- 	function(baseFunc)		
-- 		if not CanOpenCodex() then
-- 			local myfunc = pack.Parametric.Actions.SpawnBoss( "Harpy", 4400 )
-- 			myfunc()
-- 			-- local myfunc2 = pack.Parametric.Actions.SpawnBoss( "Harpy2", 4400 )
-- 			-- myfunc2()
-- 		end
-- 		baseFunc()
-- 	end
-- )
