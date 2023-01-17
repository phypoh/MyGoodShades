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
		if CurrentRun.CurrentRoom.Name == "RoomOpening" then
			return false
		end

		for enemyid, enemy in pairs( ActiveEnemies ) do
			-- ModUtil.Hades.PrintStack("Enemy present: "..enemy.Name)
			if enemy.IsBoss then
				return false
			end
		end
		cc.InvokeEffect(id, action, ...)
		return true
	end
	-- =========================================
	-- Actions
	-- =====================================================

	function pack.Actions.SpawnEnemy(selection)
		return function (...)
			local enemyData = EnemyData[selection]
			local newEnemy = DeepCopyTable( enemyData )
			newEnemy.AIOptions = enemyData.AIOptions
			newEnemy.BlocksLootInteraction = false
			local invaderSpawnPoint = 40000
			newEnemy.ObjectId = SpawnUnit({
					Name = enemyData.Name,
					Group = "Standing",
					DestinationId = invaderSpawnPoint, 
					OffsetX = math.random(-500,500), 
					OffsetY = math.random(-500,500) })
			SetupEnemyObject( newEnemy, CurrentRun )
			return true
		end
	end

	function pack.Actions.SpawnEnemies(selection, count)
		return function (...)
			local enemyData = EnemyData[selection]
			for i=1, count do
				local newEnemy = DeepCopyTable( enemyData )
				newEnemy.AIOptions = enemyData.AIOptions
				newEnemy.BlocksLootInteraction = false
				local invaderSpawnPoint = 40000
				newEnemy.ObjectId = SpawnUnit({
						Name = enemyData.Name,
						Group = "Standing",
						DestinationId = invaderSpawnPoint, 
						OffsetX = math.random(-500,500), 
						OffsetY = math.random(-500,500) })
				SetupEnemyObject( newEnemy, CurrentRun )
				end
			return true
		end
	end


	function pack.Actions.SpawnBoss(bossName)
		return function (...)
			local enemyData = EnemyData[bossName]
			local newEnemy = DeepCopyTable( enemyData )
			newEnemy.AIOptions = enemyData.AIOptions
			newEnemy.BlocksLootInteraction = false
			local invaderSpawnPoint = 40000
			newEnemy.ObjectId = SpawnUnit({ Name = enemyData.Name, Group = "Standing", 
				DestinationId = CurrentRun.Hero.ObjectId, 
				OffsetX = math.random(-500,500), 
				OffsetY = math.random(-500,500) })
			SetupEnemyObject( newEnemy, CurrentRun, { SkipSpawnVoiceLines = true }  )
			UseableOff({ Id = newEnemy.ObjectId })
			return true
		end
	end

	-- =====================================================
	-- Effects
	-- =====================================================
	pack.Effects.SpawnButterflyBall = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Actions.SpawnEnemy("FlurrySpawner"))
	pack.Effects.SpawnFlameWheel = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Actions.SpawnEnemies("ChariotSuicide", 5))
	pack.Effects.SpawnNumbskull = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Actions.SpawnEnemies("SwarmerHelmeted", 5))
	pack.Effects.SpawnVoidstone = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Actions.SpawnEnemy("ShieldRanged"))
	pack.Effects.SpawnPest = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Actions.SpawnEnemies("ThiefMineLayer", 5))
	pack.Effects.SpawnSnakestone = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Actions.SpawnEnemy("HeavyRangedForked"))
	pack.Effects.SpawnSatyr = cc.BindEffect(pack.Triggers.IfNotFirstRoom, pack.Actions.SpawnEnemy("SatyrRanged"))
	pack.Effects.SpawnMeg = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Actions.SpawnBoss( "Harpy" )))
	pack.Effects.SpawnAlecto = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Actions.SpawnBoss( "Harpy2" )))
	pack.Effects.SpawnTis = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Actions.SpawnBoss( "Harpy3" )))
	pack.Effects.SpawnTheseus = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Actions.SpawnBoss( "Theseus" )))
	pack.Effects.SpawnAsterius = cc.RigidEffect(cc.BindEffect(pack.Triggers.BossCheck, pack.Actions.SpawnBoss( "Minotaur" )))

end

-- put our effects into the centralised Effects table, under the "Hades.Cornucopia" path
ModUtil.Path.Set( "Legion", ModUtil.Table.Copy( pack.Effects ), cc.Effects )


-- For testing purposes
-- ModUtil.Path.Wrap( "BeginOpeningCodex", 
-- 	function(baseFunc)		
-- 		if not CanOpenCodex() then
-- 
-- 		end
-- 		baseFunc()
-- 	end
-- )
