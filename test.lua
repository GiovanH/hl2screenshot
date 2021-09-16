local player = Entity( 1 );

local positions = {}

-- local meshes = navmesh.GetAllNavAreas();
-- table navmesh.Find( Vector pos, number radius, number stepdown, number stepup )
local meshes = navmesh.Find(player:GetPos(), 500000, 120, 40);

if (#meshes == 0) then
	player:ConCommand("nav_generate")
end

-- navmesh.Find(Entity( 1 ):GetPos(), 2048, 2048, 2048)
for i, mesh in ipairs( meshes ) do
	table.insert(positions, mesh:GetCenter()) 
	-- for j, spot in ipairs( mesh:GetExposedSpots() ) do
		-- table.insert(positions, spot) 
	-- end 
	-- for j, spot in ipairs( mesh:GetHidingSpots() ) do
		-- table.insert(positions, spot) 
	-- end
end

print("Found positions " .. #meshes)


for i, v in ipairs( positions ) do
	-- player:ConCommand("drawcross " .. v:__tostring())
	-- if (i > 0) then break end
	-- local entity = ents.Create( "sent_ball" )
	-- if ( !IsValid( entity ) ) then return end 
	-- entity:SetPos( v )
	-- entity:SetBallSize(20)
	-- entity:Spawn()
end


local tr = {}

-- function screenshot()
	-- local HitDistance = 200
	-- local endpos = player:GetShootPos() + player:GetAimVector() * HitDistance
	-- print(player:GetShootPos(), endpos)
	-- player:ConCommand("drawline", player:GetShootPos(), endpos) 
	-- tr = util.TraceLine( {
		-- start = player:GetShootPos(),
		-- endpos = endpos
	-- } )
	-- PrintTable(tr)
	-- if (tr.Hit) then
		-- print(i, tr.Hit, "bad")
		-- player:EmitSound( Sound( "WeaponFrag.Throw" ) )
	-- else
		-- print(i, tr.Hit, "good")
		-- -- player:ConCommand("jpeg")
		-- player:EmitSound( Sound( "npc/turret_floor/click1.wav" ) )
	-- end

-- end

local shots = {}

for i, v in ipairs( positions ) do
	
	local HitDistance = 180
	local aim
	local endpos
	
	for rot = 0, 4 do
		aim = Angle(math.random(-20, 20), math.random(90*rot, 90*(rot+1)), 0)

		endpos = v + aim:Forward() * HitDistance
		tr = util.TraceLine( {
			start = v,
			endpos = endpos,
			filter = MASK_WATER || MASK_SOLID
		} )
		
		if (tr.Hit) then
			print("bad", v, v + aim:Forward() * HitDistance)
			--player:EmitSound( Sound( "WeaponFrag.Throw" ) )
		else
			local shot = {
				Aim = aim,
				Vec = v
			}
			table.insert(shots, shot) 
			-- player:ConCommand("drawline " .. v:__tostring() .. " " .. endpos:__tostring())
			-- player:EmitSound( Sound( "npc/turret_floor/click1.wav" ) )
		end
	end
end

local timefactor = 0.35

print("Found shots " .. #shots)
print("Est time in mins " .. #shots*timefactor/60)

for i, shot in ipairs( shots ) do
	-- if (i > 0) then break end
	timer.Simple( i * timefactor, function()
		--PrintTable(shot)
		print(i, #shots)
		player:SetPos(shot.Vec)
		player:SetEyeAngles(shot.Aim)
		-- player:EmitSound( Sound( "npc/turret_floor/click1.wav" ) )
		player:ConCommand("jpeg")
	end ); 
end