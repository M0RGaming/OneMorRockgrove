local omr = OneMorRockgrove
omr.guide = {}

function omr.guide.createWriteup()

	local panelName = "OneMorRockgroveMechanicsGuide"
	local panelData = {
		type = "panel",
		name = "|cEFEBBEOne M0R Rockgrove Helper - Mech Guide|r",
		author = "|c0DC1CF@M0R_Gaming|r",
		slashCommand = "/omrguide"
	}

	local optionsTable = {
		{
			type = "submenu",
			name = "Trash Enemies",
			tooltip = "All the different types of trash enemies in the trial",
			controls = {
				{
					type = "description",
					title = "Reaver",
					text = "The Reaver is a big guy with a large stick who goes around smacking people. The Reaver's light attacks also hurt "..
						"harder than most of the other trash enemies so tanks should pay attention to it. The main mechanic that the Reaver will "..
						"do is spawning a large persistant circle. Anyone standing in this circle will take alot of damage, and so the tank should "..
						"pull the Reaver out of the circle and towards the group. As the reaver contains no cleave it is fully safe to hold in group "..
						"after its circle goes out. Some groups will move the Reaver towards the exit and the dps will roll dodge towards it, but this is "..
						"highly dependant on what your raid lead says."
				},
				{
					type = "description",
					title = "Bloodseeker",
					text = "Bloodseekers are archers that start spawning at the 1.2 trash pack. These archers need to be outranged to move them as they "..
						"will not move towards the person with taunt and cannot be chained. These enemies are relatively easy to deal with, but they will "..
						"do a mechanic where they start channeling a taking aim at multiple people. This taking aim can either be bashed or roll dodged, "..
						"but if the tanks are prepulling trash packs then there can be an edge case scenario where DPS don't revieve a dodge timer from "..
						"Codes if they run into the pull after the archers start channeling. The only other mechanic that the archers do is they will "..
						"teleport away after every few seconds and will need to be range pulled into stack again."
				},
				{
					type = "description",
					title = "Soulweavers",
					text = "The Soulweaver is an enemy with a staff that can do alot of damage if the group is not paying attention. When the Soulweavers "..
						"cast their shield ability, a shield will be placed on the enemies around the Soulweaver. This shield's health can be seen on the "..
						"target unit frame, and when a shield's health reaches 0 it will shoot out a projectile at everyone. Generally for high damage "..
						"groups, this shield will explode the instant it spawns, and thus high damage groups should roll dodge when they see the "..
						"shields spawn. If using Rockgrove Helper from Qcell, the queue to dodge is when the shield notification pops up with a number "..
						"next to it. This number is the amount of shields that went out."
				},
				{
					type = "description",
					title = "Haj Mota",
					text = "The Haj Mota doesnt really do anything too scary, except for it charges in the direction it is looking every so often. "..
						"When it charges, it should be either roll dodged or blocked, and it should be relatively easy to kill. There is only one Haj "..
						"Mota in the entire trial, and it spawns right after trash 1.1. There is also an achievement to keep the Haj Mota alive until "..
						"the last trash pack before Oax, and then sacrifice it to a geyser."
				},
			},
		},
		{
			type = "header",
			name = "|cFFD700Oaxiltso|r",
		},
		{
			type = "divider",
		}
	}


	local panel = LibAddonMenu2:RegisterAddonPanel(panelName, panelData)
	LibAddonMenu2:RegisterOptionControls(panelName, optionsTable)

end


--[[


				{
					type = "description",
					title = "",
					text = ""..
						""..
						""..
						""..
						""..
						""
				},

]]