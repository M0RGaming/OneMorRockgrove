local omr = OneMorRockgrove

function omr.settings.createSettings()
	local vars = omr.vars

	local panelName = "OneMorRockgroveSettingsPanel"
	local panelData = {
		type = "panel",
		name = "|cEFEBBEOne M0R Rockgrove Helper|r",
		author = "|c0DC1CF@M0R_Gaming|r",
		slashCommand = "/omr"
	}

	local bahseicorners = {
		"Banner",
		"Portal",
		"Boring Corner",
		"Entrance"
	}

	local optionsTable = {
		{
			type = "header",
			name = "|cFFD700Oaxiltso|r",
		},
		{
			type = "checkbox",
			name = "Enable Oax Safe Zone Indicator",
			tooltip = "If this is enabled, being outside of a safe zone for oax poisons will tint the edge of your screen red.",
			getFunc = function() return vars.enableRedIndicator end,
			setFunc = function(value) vars.enableRedIndicator = value end,
			width = "half",
		},
		{
			type = "checkbox",
			name = "Swap Oax Safe Zone Indicator",
			tooltip = "If this is enabled, being inside of a safe zone will turn your screen red instead of the other way around.",
			getFunc = function() return vars.reverseRed end,
			setFunc = function(value) vars.reverseRed = value end,
			width = "half",
		},
		{
			type = "checkbox",
			name = "Show Oax Safe Zone Borders",
			tooltip = "If this is enabled, the safe zone boundaries for oax will show up little markers on the ground",
			getFunc = function() return vars.showSafeBorders end,
			setFunc = function(value) vars.showSafeBorders = value end,
		},
		{
			type = "header",
			name = "|cFFD700Bahsei|r",
		},
		{
			type = "checkbox",
			name = "Enable Bahsei Good Cone Prediction",
			tooltip = "Plays a notification based on if bahsei's cone is probably a good cone or not.",
			getFunc = function() return vars.goodConePrediction end,
			setFunc = function(value) vars.goodConePrediction = value end,
		},
		{
			type = "checkbox",
			name = "Enable Bahsei Initial Cone Positioning",
			tooltip = "Plays a notification when the first cone goes out for bahsei indicating where to go.",
			getFunc = function() return vars.initialConeIndicator end,
			setFunc = function(value) vars.initialConeIndicator = value end,
		},
		{
			type = "dropdown",
			name = "Initial CW Position",
			tooltip = "Which corner should pop up if Bahsei does a clockwise cone to start.",
			choices = bahseicorners,
			getFunc = function() return vars.bahseiInitialCW end,
			setFunc = function(value) vars.bahseiInitialCW = value end,
			width = "half",
		},
		{
			type = "dropdown",
			name = "Initial CCW Position",
			tooltip = "Which corner should pop up if Bahsei does a counter-clockwise cone to start.",
			choices = bahseicorners,
			getFunc = function() return vars.bahseiInitialCCW end,
			setFunc = function(value) vars.bahseiInitialCCW = value end,
			width = "half",
		},
	}


	local panel = LibAddonMenu2:RegisterAddonPanel(panelName, panelData)
	LibAddonMenu2:RegisterOptionControls(panelName, optionsTable)

end