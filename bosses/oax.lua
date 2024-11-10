local omr = OneMorRockgrove




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



omr.bossRegistry[1] = omr.activateOax







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





function omr.isUnitInSafeZone(unitTag) 
	local world, px, py, pz = GetUnitWorldPosition(unitTag)
	return omr.insidePolygon(safePoly,{px,pz}) or omr.insidePolygon(safeEntranceLeftPoly,{px,pz})
end











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
SLASH_COMMANDS['/showoaxborders'] = omr.createSafeBorders
SLASH_COMMANDS['/disableoaxred'] = omr.DisableSafeIndicator
SLASH_COMMANDS['/hideoaxborders'] = omr.destroySafeBorders

SLASH_COMMANDS['/swapoaxred'] = function()
	omr.vars.reverseRed = not omr.vars.reverseRed
	d("One Mor Rockgrove: Reverse Red is now: "..tostring(omr.vars.reverseRed))
end
SLASH_COMMANDS['/swapoaxborders'] = function()
	omr.vars.showSafeBorders = not omr.vars.showSafeBorders
	d("One Mor Rockgrove: Show Safe Borders is now: "..tostring(omr.vars.showSafeBorders))
end
