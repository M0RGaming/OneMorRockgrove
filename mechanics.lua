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
						"next to it. This number is the amount of shields that went out. The soul weaver also does a mechanic where 3 people get circles "..
						"below their feet. These circles will one shot someone if they are overlapped, but can also be roll dodged by everyone in it."
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
			type = "submenu",
			name = "|cFFD700Oaxiltso|r",
			tooltip = "Mechanics for Oaxiltso",
			controls = {
				{
					type = "description",
					title = "Slam",
					text = "Oax will occasionally do a mechanic where he slams his hands into the ground and spawn a circle of fire. This circle will "..
						"one shot any dds in it who do not roll dodge, and deal a large amount of damage to the tank as well. The circle is placed at the "..
						"feet of the tank who has agro on the boss and the circle will disappear before he creates a new one."
				},
				{
					type = "description",
					title = "Havocrel Annihilator",
					text = "At 90%, 75%, 50%, and 25%, oax will spawn a Havocrel Annihilator who does a few mechanics that need to be worried about. "..
						"After a couple of seconds of spawning, the miniboss will create a circle around it. If this circle touches either Oax or another "..
						"mini, then the enemy it touches will enrage and do a ton of damage. The minis will also create metors on the ground when they "..
						"cast their heavy attack. When this happens dps will need to block the metors or else they will be stunned and tank a bunch of "..
						"damage. Finally, the minis will randomly chain people in and put a cone on someone. This cone will track the person with it "..
						"and follow them around so it should not be swung. If the cone is not roll dodged before it goes off, everyone who got hit will "..
						"gain a massive dot on them."
				},
				{
					type = "description",
					title = "Poisons",
					text = "At various points throughout the fight, Oax will spit poison at 2 random people outside of the safe zones around each pool. "..
						"If there are not 2 people outside of the safe zone when Oax spits his poisons, then someone inside the pool will randomly get "..
						"the poison. When someone has this poison effect on them, they will be dropping AOE puddles on the ground below their feet "..
						"which will do a ton of damage to anyone staying within them. To cleanse these poison effects, the people with the poison will "..
						"need to walk into one of the four pools around the room. However, after cleansing in a pool, frogs will start spawning from "..
						"the pool that was used, and so a pool close to group should be used to cleanse to ensure frogs dont build up."
				},
				{
					type = "description",
					title = "Charges",
					text = "At various points throughout the fight, Oax will turn to look at the furthest person away (within a maximum distance) and "..
						"after a few seconds charge at them. Anyone in the path of this charge will take alot of damage and usually die. To mitigate "..
						"this, usually one healer is intentionally standing the furthest away when the charges are about to happen. After Oax chooses "..
						"someone to charge at, he is locked into charging at them, so the person being targetted can run towards and roll dodge through "..
						"him. This will cause the charge to end earlier as he has to move less distance, and is great to ensure that Oax stays in dots."
				},
				{
					type = "description",
					title = "Hardmode Mechanics",
					text = "In hardmode, Oax has more health and does more damage, but there are also 2 more mechanics that need to be worried about. "..
						"At various points throughout the fight Oax will turn one of the pools around the arena into lava, causing it to no longer "..
						"be able to cleanse people. This will usually prioritize the pools that the group have not been using, but at around 25% there "..
						"will only be 1 pool left remaining so healers with poison will need to alternate who clenases. In addition to the poison pools "..
						"disappearing, Oax will also charge twice in a row below 50% health. Because of this, cancelling charges becomes more important "..
						"as it will ensure that the correct people get charges, and not someone standing with the mini."
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