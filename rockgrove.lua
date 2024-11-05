OneMorRockgrove = {}
omr = OneMorRockgrove -- local var for easy access
omr.name = "OneMorRockgrove"
omr.vars = {}


-- Points obtained from the elms markers created by zbzszzzt123
local safePoly = {
	{93481,80597}, {93320,80506}, {93058,80375},
	{92807,80290}, {92525,80080}, {92063,80107},
	{91857,80115}, {91622,80264}, {91190,80491},
	{90868,80797}, {90586,81282}, {90448,81795},
	{90379,82321}, {90439,82758}, {90654,83091},
	{90880,83294}, {93481,83294}
}

-- Points recorded via a testing run with me, @Chrissy-T, @jowoll, @Jess182, @PyroFD3S
-- a few points need a bit of refining, will do in a later run
local safeEntranceLeftPoly = {
	{90081,76844}, {90027,77513}, {90146,77961},
	{90250,78353}, {90316,78674}, {90378,78945},
	{90647,79089}, {90729,79381}, {91101,79579},
	{91425,79726}, {91828,79626}, {92224,79852},
	{92647,79746}, {93094,79689}, {93287,79379},
	{93481,79206}, {93481,76844}
}

omr.safeZones = {}
omr.safeZones.entranceLeft = safeEntranceLeftPoly
omr.safeZones.exitLeft = safePoly


-- obtained from https://stackoverflow.com/a/39996227
local function insidePolygon(polygon, point)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i][2] < point[2] and polygon[j][2] >= point[2] or polygon[j][2] < point[2] and polygon[i][2] >= point[2]) then
            if (polygon[i][1] + ( point[2] - polygon[i][2] ) / (polygon[j][2] - polygon[i][2]) * (polygon[j][1] - polygon[i][1]) < point[1]) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes 
end


function omr.isUnitInSafeZone(unitTag) 
	local world, px, py, pz = GetUnitWorldPosition(unitTag)
	return insidePolygon(safePoly,{px,pz}) or insidePolygon(safeEntranceLeftPoly,{px,pz})
end


--[[
	
	
	   ____
	  6MMMMb
	 8P    Y8
	6M      Mb    ___    ____   ___
	MM      MM  6MMMMb   `MM(   )P'
	MM      MM 8M'  `Mb   `MM` ,P
	MM      MM     ,oMM    `MM,P
	MM      MM ,6MM9'MM     `MM.
	YM      M9 MM'   MM     d`MM.
	 8b    d8  MM.  ,MM    d' `MM.
	  YMMMM9   `YMMM9'Yb._d_  _)MM_
	
	
	
]]


--omr.reverseRed = false
local red = omr.vars.reverseRed -- originally false, but made to be reverse red since behaviour is reversed
-- OAX POISON SAFE ZONE
function omr.EnableSafeIndicator()
	EVENT_MANAGER:RegisterForUpdate("OMR Safe Zone", 50, function()
		if not omr.isUnitInSafeZone('player') then
			if not red then
				omr.border("OMR Safe Zone", nil, 0xFF00001A, not omr.vars.reverseRed)
				red = true
			end
		else
			if red then
				omr.border("OMR Safe Zone", nil, 0xFF00001A, omr.vars.reverseRed)
				red = false
			end
		end
	end)
end


function omr.border(id, duration, colour, enable)
	if enable then
		CombatAlerts.ScreenBorderEnable(colour, duration, id)
	else
		CombatAlerts.ScreenBorderDisable(id)
	end
end


function omr.DisableSafeIndicator()
	EVENT_MANAGER:UnregisterForUpdate("OMR Safe Zone")
	omr.border("OMR Safe Zone", nil, 0xFF00001A, false)
	red = omr.vars.reverseRed
end





--omr.showSafeBorders = false
omr.markersEntranceLeft = {}
omr.markersExitLeft = {}

function omr.createSafeBorders()
	local y = 35727
	for i,v in pairs(omr.safeZones.entranceLeft) do
		omr.markersEntranceLeft[#omr.markersEntranceLeft+1] = OSI.CreatePositionIcon(v[1], y, v[2], "OdySupportIcons/icons/squares/marker_lightblue.dds", 50, {0,0.7,1})
	end
	for i,v in pairs(omr.safeZones.exitLeft) do
		omr.markersExitLeft[#omr.markersExitLeft+1] = OSI.CreatePositionIcon(v[1], y, v[2], "OdySupportIcons/icons/squares/marker_lightblue.dds", 50, {0,1,0})
	end
end

function omr.destroySafeBorders()
	for i,v in pairs(omr.markersEntranceLeft) do
		OSI.DiscardPositionIcon(v)
	end
	for i,v in pairs(omr.markersExitLeft) do
		OSI.DiscardPositionIcon(v)
	end
	omr.markersEntranceLeft = {}
	omr.markersExitLeft = {}
end




SLASH_COMMANDS['/enableoaxred'] = omr.EnableSafeIndicator
SLASH_COMMANDS['/disableoaxred'] = omr.DisableSafeIndicator

SLASH_COMMANDS['/swapoaxred'] = function()
	omr.vars.reverseRed = not omr.vars.reverseRed
	d("One Mor Rockgrove: Reverse Red is now: "..tostring(omr.vars.reverseRed))
end
SLASH_COMMANDS['/swapoaxborders'] = function()
	omr.vars.showSafeBorders = not omr.vars.showSafeBorders
	d("One Mor Rockgrove: Show Safe Borders is now: "..tostring(omr.vars.showSafeBorders))
end




--[[
	
	
	________             ___
	`MMMMMMMb.           `MM                         68b
	 MM    `Mb            MM                         Y89
	 MM     MM    ___     MM  __     ____     ____   ___
	 MM    .M9  6MMMMb    MM 6MMb   6MMMMb\  6MMMMb  `MM
	 MMMMMMM(  8M'  `Mb   MMM9 `Mb MM'    ` 6M'  `Mb  MM
	 MM    `Mb     ,oMM   MM'   MM YM.      MM    MM  MM
	 MM     MM ,6MM9'MM   MM    MM  YMMMMb  MMMMMMMM  MM
	 MM     MM MM'   MM   MM    MM      `Mb MM        MM
	 MM    .M9 MM.  ,MM   MM    MM L    ,MM YM    d9  MM
	_MMMMMMM9' `YMMM9'Yb._MM_  _MM_MYMMMM9   YMMMM9  _MM_
	
	
	
]]


-- {marker, offset}
omr.markers = {}
omr.markerStartingPosition = {0,0}
omr.markerXScaling = 1
omr.markerYScaling = 1


-- cant procede with this until i reach bahsei
-- maybe make this also go below your feet?
function omr.createBahseiPins()

	local _, x, y, z = GetUnitRawWorldPosition( "player" )

	local positions = {
		{x-100,y,z-100},
		{x,y,z-100},
		{x+100,y,z-100},
		{x+100,y,z},
		{x+100,y,z+100},
		{x,y,z+100},
		{x-100,y,z+100},
		{x-100,y,z},
	}

	for i,v in pairs(positions) do
		omr.markers[#omr.markers+1] = {OSI.CreatePositionIcon(v[1], v[2], v[3], "OdySupportIcons/icons/squares/marker_lightblue.dds", 50),(i-1)*100}
	end

	omr.markerStartingPosition = {x-100, z-100}

end


function omr.rotateMarkers(distance)

	for i,v in pairs(omr.markers) do
		v[2] = v[2] + distance

		if v[2] >= 800 then v[2] = v[2] - 800 end

		local currentSide = zo_floor(v[2]/200)
		local currentOffset = v[2]%200


		if currentSide == 0 then
			v[1].x = omr.markerStartingPosition[1] + currentOffset
			v[1].z = omr.markerStartingPosition[2]
		elseif currentSide == 1 then
			v[1].x = omr.markerStartingPosition[1] + 200
			v[1].z = omr.markerStartingPosition[2] + currentOffset
		elseif currentSide == 2 then
			v[1].x = (omr.markerStartingPosition[1] + 200) - currentOffset
			v[1].z = omr.markerStartingPosition[2] + 200
		elseif currentSide == 3 then
			v[1].z = (omr.markerStartingPosition[2] + 200) - currentOffset
			v[1].x = omr.markerStartingPosition[1]
		end

	end

--[[
	for i,v in pairs(omr.markers) do
		v.x = v.x+50
	end
	--]]
end

--SLASH_COMMANDS['/setup'] = omr.createBahseiPins
--SLASH_COMMANDS['/move'] = omr.rotateMarkers



-- bahsei room corners
-- 103118, 42650, 96430
-- 96677, 42650, 102867


omr.bahseiCorners = {
	{103118, 42650, 96430},
	{103118, 42650, 102867},
	{96677, 42650, 102867},
	{96677, 42650, 96430}
}

omr.bahseiCenter = {
	(omr.bahseiCorners[1][1]+omr.bahseiCorners[3][1])/2,
	(omr.bahseiCorners[1][3]+omr.bahseiCorners[3][3])/2
}


-- tanks position will always be ahead of a portion of the group's position (hopefully), so identify if tank is clockwise or counterclockwise
-- from group. Then using that, assume that cone is spawning ahead of group and if its going in the same direction as tank then its good cone,
-- opposite is bad cone


-- ids from qcells
-- cw = 153517
-- ccw = 153518
omr.oldConeId = nil

function omr.onBahseiCone(_, result, _, abilityName, _, _, sourceName, _, targetName, _, hitValue, _, _, _, sourceUnitId, targetUnitId, abilityId)
	if omr.oldConeId == nil then
		omr.oldConeId = abilityId

		if abilityId == 153517 then
			--omr.sendCSA("|c00FF00BANNER|r", "|cB0B0B0(probably)|r", SOUNDS.BATTLEGROUND_NEARING_VICTORY)
			omr.sendCSA("|c00FF00BORING CORNER|r", "|cB0B0B0(probably)|r", SOUNDS.BATTLEGROUND_NEARING_VICTORY)
		else
			--omr.sendCSA("|cFF0000BORING CORNER|r", "|cB0B0B0(probably)|r", SOUNDS.TELVAR_MULTIPLIERMAX)
			omr.sendCSA("|cFF0000PORTAL|r", "|cB0B0B0(probably)|r", SOUNDS.TELVAR_MULTIPLIERMAX)
		end

		return
	end

	-- Old logic, had issues
	--[[

	if omr.oldConeId == abilityId then
		omr.goodCone()
	else
		omr.badCone()
	end
	omr.oldConeId = abilityId
	--]]

	local groupPositions = {}
	local bx = omr.bahseiCenter[1]
	local bz = omr.bahseiCenter[2]
	for i=1, 12 do
		local unitTag = "group"..i
		if (GetGroupMemberSelectedRole(unitTag) == LFG_ROLE_DPS) then
			local world, x, y, z = GetUnitRawWorldPosition(unitTag)
			if world == 1263 then
				groupPositions[#groupPositions+1] = {x-bx,z-bz}
			end
		end
	end

	local avgx, avgz = omr.distanceWeightedMean(groupPositions)
	local groupTheta = math.atan(avgz/avgx)
	d("Group Theta = ".. groupTheta)

	local world, tx, ty, tz = GetUnitRawWorldPosition(omr.probTankUnitTag)
	local tankTheta = math.atan(tz-bz/tx-bx)
	d("Tank Theta = ".. tankTheta)


	local goodCone = 0
	if tankTheta < groupTheta then
		goodCone = 153517 -- good cone is cw
	else
		goodCone = 153518 -- good cone is ccw
	end


	if goodCone == abilityId then
		omr.goodCone()
	else
		omr.badCone()
	end
	omr.oldConeId = abilityId

end




-- distance weighted mean, xbar = Σ_i(w_i * x_i)/Σ_i(w_i), where w_i = n/Σ_j(|x_i-x_j|), and n = int (usually number of points)
function omr.distanceWeightedMean(positions)
	local avgx = 0
	local avgy = 0
	local weightings = 0
	local n = #positions

	-- do 1 weighting for radius, use to eval both x and y avg
	for i,v in pairs(positions) do
		local ri = math.sqrt(v[1]^2 + v[2]^2) -- radius of point i
		local w = 0
		for j,k in pairs(positions) do
			local rj = math.sqrt(k[1]^2 + k[2]^2) -- radius of point j
			w = w + math.abs(ri-rj)
		end
		w = n/w
		weightings = weightings + w

		avgx = avgx+w*v[1]
		avgy = avgy+w*v[2]
	end

	avgx = avgx/weightings
	avgy = avgy/weightings
	return avgx,avgy
end



function omr.onBahseiLightAttack(_, result, _, abilityName, _, _, sourceName, _, targetName, _, hitValue, _, _, _, sourceUnitId, targetUnitId, abilityId, _)
	-- filter for:
	-- source unit id = boss1
	-- abilityId = light attack (carve or slice) 150047 and 150048
	omr.probTankUnitTag = targetUnitId
	--d("Light attack: "..targetName.." was hit by "..sourceName.."'s "..abilityName.." (which is a light attack prob)")
end




-- TELVAR_MULTIPLIERMAX on bad
-- BATTLEGROUND_NEARING_VICTORY on good

function omr.goodCone()
	omr.sendCSA("|c00FF00GOOD CONE|r", "|cB0B0B0(probably)|r", SOUNDS.BATTLEGROUND_NEARING_VICTORY)
end

function omr.badCone()
	omr.sendCSA("|cFF0000BAD CONE|r", "|cB0B0B0(probably)|r", SOUNDS.TELVAR_MULTIPLIERMAX)
end


function omr.sendCSA(message, secondMessage, sound)
	local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT, sound)
    messageParams:SetText(message,secondMessage)
    messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_BATTLEGROUND_NEARING_VICTORY)
    messageParams:MarkShowImmediately()
    messageParams:MarkQueueImmediately()
    messageParams:SetLifespanMS(5500)
    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end















omr.zonedIn = false
function omr.playerActivated()
	local zone, _, _, _ = GetUnitRawWorldPosition("player")
	if zone == 1263 and (not omr.zonedIn) then
		omr.activateRG()
		omr.zonedIn = true
	elseif (not zone == 1263) and omr.zonedIn then
		omr.deactivateRG()
		omr.zonedIn = false
	end
end



function omr.activateRG()
	--d("Activated")
	--EVENT_MANAGER:RegisterForEvent(omr.name, EVENT_BOSSES_CHANGED, omr.combatStateCheck)
	EVENT_MANAGER:RegisterForEvent(omr.name, EVENT_PLAYER_COMBAT_STATE, omr.combatStateCheck)
	EVENT_MANAGER:RegisterForEvent(omr.name, EVENT_UNIT_DEATH_STATE_CHANGED, omr.combatStateCheck)
	EVENT_MANAGER:RegisterForEvent(omr.name, EVENT_PLAYER_ACTIVATED, omr.combatStateCheck)
	omr.combatStateCheck(1)
end

function omr.deactivateRG()
	--d("Deactivated")
	omr.activeBoss = nil
	omr.deactivateOax()
	omr.deactivateBahsei()
	--EVENT_MANAGER:UnregisterForEvent(omr.name, EVENT_BOSSES_CHANGED)
	EVENT_MANAGER:UnregisterForEvent(omr.name, EVENT_PLAYER_COMBAT_STATE)
	EVENT_MANAGER:UnregisterForEvent(omr.name, EVENT_UNIT_DEATH_STATE_CHANGED)
	EVENT_MANAGER:UnregisterForEvent(omr.name, EVENT_PLAYER_ACTIVATED)
end



omr.activeBoss = ""
omr.combatState = false
function omr.combatStateCheck(state)
	--d("Activated "..state)
	if IsUnitDead('player') then return end
	if IsUnitInCombat('player') then
		if omr.combatState then return end -- might work to stop edge case scenarios (bahsei portals) where the boss unloads
		omr.combatState = true

		local currentBoss = string.lower(GetUnitName("boss1"))
		--d(currentBoss..' '..omr.activeBoss)
		if not (omr.activeBoss == currentBoss) then
			omr.activeBoss = currentBoss
			local id = omr.bossLookup[currentBoss]
			if id == nil then return end
			omr.bossRegistry[id]()
		end
	else
		omr.activeBoss = ""
		omr.deactivateOax()
		omr.deactivateBahsei()
		omr.combatState = false
	end
end



function omr.activateOax()
	if omr.vars.enableRedIndicator then
		omr.EnableSafeIndicator()
	end
	if omr.vars.showSafeBorders then
		omr.createSafeBorders()
	end
end

function omr.deactivateOax()
	omr.DisableSafeIndicator()
	omr.destroySafeBorders()
end



function omr.activateBahsei()
	-- bahsei good or bad cone
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT, omr.onBahseiCone)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 153517)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT, omr.onBahseiCone)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 153518)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)

	-- bahsei light attack (for identifying who is (probably) tank)
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei LA Carve", EVENT_COMBAT_EVENT, omr.onBahseiLightAttack)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei LA Carve", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 150047)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei LA Carve", EVENT_COMBAT_EVENT, REGISTER_FILTER_UNIT_TAG_PREFIX, "boss")
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei LA Slice", EVENT_COMBAT_EVENT, omr.onBahseiLightAttack)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei LA Slice", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 150048)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei LA Slice", EVENT_COMBAT_EVENT, REGISTER_FILTER_UNIT_TAG_PREFIX, "boss")
end

function omr.deactivateBahsei()
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT)
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT)
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei LA Carve", EVENT_COMBAT_EVENT)
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei LA Slice", EVENT_COMBAT_EVENT)
	omr.oldConeId = nil
	omr.probTankUnitTag = ""
end



omr.bossRegistry = {
	[1] = omr.activateOax,
	[2] = omr.activateBahsei
}

-- /script CHAT_SYSTEM:StartTextEntry(string.lower(GetUnitName("boss1")))
omr.bossLookup = { -- for other languages
	["oaxiltso"] = 1,
	["оазилцо"] = 1,
	["奥西索"] = 1,
	["bahsei"] = 2,
	["flame-herald bahsei"] = 2
}








omr.varversion = 1

omr.settings = {}
omr.settings.DefaultSettings = {
	reverseRed = false,
	showSafeBorders = false,
	enableRedIndicator = true,
}





-------------------------------------------------------------------------------------------------
--  OnAddOnLoaded  --
-------------------------------------------------------------------------------------------------
function omr.OnAddOnLoaded(event, addonName) -- Runs for all addons which load, so make sure that init is only called for this addon
	if addonName ~= omr.name then return end
	omr:Initialize()
	
end

-------------------------------------------------------------------------------------------------
--  Register Events --
-------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(omr.name, EVENT_ADD_ON_LOADED, omr.OnAddOnLoaded)

-------------------------------------------------------------------------------------------------
--  Initialize Function --
-------------------------------------------------------------------------------------------------
function omr:Initialize()
	EVENT_MANAGER:UnregisterForEvent(omr.name, EVENT_ADD_ON_LOADED)
	EVENT_MANAGER:RegisterForEvent(omr.name .. "AlwaysActive", EVENT_PLAYER_ACTIVATED, omr.playerActivated)

	omr.vars = ZO_SavedVars:NewAccountWide("OMRSettings", omr.varversion, nil, omr.settings.DefaultSettings)
	omr.settings.createSettings()
end
