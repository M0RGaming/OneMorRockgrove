local omr = OneMorRockgrove


function omr.activateBahsei()
	-- bahsei good or bad cone
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT, omr.onBahseiCone)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 153517)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT, omr.onBahseiCone)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 153518)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)

	-- The rest is for bahsei cones so just exit if not enabled.
	if not omr.vars.goodConePrediction then return end

	-- correlate userIds to unitTags
	EVENT_MANAGER:RegisterForEvent("OMR ID Identification", EVENT_EFFECT_CHANGED, omr.idIdentification)
	EVENT_MANAGER:AddFilterForEvent("OMR ID Identification", EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, 'group')

	-- bahsei light attack (for identifying who is (probably) tank)
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei LA Carve", EVENT_COMBAT_EVENT, omr.onBahseiLightAttack)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei LA Carve", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 150047)
	EVENT_MANAGER:RegisterForEvent("OMR Bahsei LA Slice", EVENT_COMBAT_EVENT, omr.onBahseiLightAttack)
	EVENT_MANAGER:AddFilterForEvent("OMR Bahsei LA Slice", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 150048)

	-- make the assumption that the tank with the lowest health is bahsei tank before getting concrete evidence from who gets attacked
	local lowestHealth = 1000000
	for i=1,12 do
		local unitTag = "group"..i
		if (GetGroupMemberSelectedRole(unitTag) == LFG_ROLE_TANK) then
			local _, max = GetUnitPower(unitTag, COMBAT_MECHANIC_FLAGS_HEALTH)
			if max < lowestHealth then
				omr.probTankUnitTag = unitTag
			end
		end
	end

end

function omr.deactivateBahsei()
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei Cone CW", EVENT_COMBAT_EVENT)
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei Cone CCW", EVENT_COMBAT_EVENT)
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei LA Carve", EVENT_COMBAT_EVENT)
	EVENT_MANAGER:UnregisterForEvent("OMR Bahsei LA Slice", EVENT_COMBAT_EVENT)
	EVENT_MANAGER:UnregisterForEvent("OMR ID Identification", EVENT_EFFECT_CHANGED)
	omr.oldConeId = nil
	omr.probTankUnitTag = ""
	omr.idLookup = {}
end

omr.bossRegistry[2] = omr.activateBahsei





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

omr.idLookup = {}




function omr.onBahseiLightAttack(_, result, _, abilityName, _, _, sourceName, _, targetName, _, hitValue, _, _, _, sourceUnitId, targetUnitId, abilityId, _)
	-- abilityId = light attack (carve or slice) 150047 and 150048
	local unitTag = omr.idLookup[targetUnitId]
	if not unitTag then return end
	omr.probTankUnitTag = unitTag
	--d("Light attack: "..GetUnitDisplayName(unitTag).." was hit by "..tostring(sourceName).."'s "..tostring(abilityName).." (which is a light attack prob)")
end


function omr.idIdentification(_, _, _, effectName, unitTag, _, _, _, _, _, _, _, _, unitName, unitId, abilityId, _)
	omr.idLookup[unitId] = unitTag
	--d("ID Identification: "..unitTag.." has a id of "..unitId.." since they had "..effectName.." ("..abilityId..") on them")
end





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
		if omr.vars.initialConeIndicator then
			if abilityId == 153517 then
				omr.sendCSA("|c00FF00"..omr.vars.bahseiInitialCW.."|r", "|cB0B0B0(probably)|r", SOUNDS.BATTLEGROUND_NEARING_VICTORY)
			else
				omr.sendCSA("|cFF0000"..omr.vars.bahseiInitialCCW.."|r", "|cB0B0B0(probably)|r", SOUNDS.TELVAR_MULTIPLIERMAX)
			end
		end
		return
	end

	if not omr.vars.goodConePrediction then return end

	-- get group position and normalize with origin at center of bahsei's arena
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

	local avgx, avgz = omr.distanceWeightedMean(groupPositions) -- calc xbar and zbar with dwm on dps locations. DWM should take care of outliers
	local groupTheta = math.atan2(avgz,avgx)
	--d("Group Theta = ".. groupTheta)
	-- Calc Group and Tank theta in respect to the center of bahsei's arena. 
	local world, tx, ty, tz = GetUnitRawWorldPosition(omr.probTankUnitTag)
	local tankTheta = math.atan2((tz-bz),(tx-bx))
	--d("Tank Theta = ".. tankTheta)


	-- based on the rotation which the tank is oriented relative to the group, identify which direction would be a good cone
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













-- TELVAR_MULTIPLIERMAX on bad
-- BATTLEGROUND_NEARING_VICTORY on good

function omr.goodCone()
	omr.sendCSA("|c00FF00GOOD CONE|r", "|cB0B0B0(probably)|r", SOUNDS.BATTLEGROUND_NEARING_VICTORY)
	omr.border("OMR Bahsei Good Cone", 1000, 0x00FF001A, true)
end

function omr.badCone()
	omr.sendCSA("|cFF0000BAD CONE|r", "|cB0B0B0(probably)|r", SOUNDS.TELVAR_MULTIPLIERMAX)
	omr.border("OMR Bahsei Bad Cone", 1000, 0xFF00001A, true)
end











-- the following isnt being used yet, it will eventually place markers around the arena and rotate based on how cone is rotating




-- {marker, offset}
omr.markers = {}
omr.markerStartingPosition = {0,0}
omr.markerXScaling = 1
omr.markerYScaling = 1


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
end

--SLASH_COMMANDS['/setup'] = omr.createBahseiPins
--SLASH_COMMANDS['/move'] = omr.rotateMarkers