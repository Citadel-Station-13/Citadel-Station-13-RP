/datum/role/ghostrole/scavenger
	name = "FTU Guardian Salvage Company Worker"
	assigned_role = "Scavenger"
	desc = "You are a worker of the Guardian Salvage Company, a subsidiary of the FTU."
	spawntext = "You are a worker of the Guardian Salvage Company, a subsidiary of the FTU.  \
	You work on the FTV Adala, a Mega Tug designed to carry wrecks to be repaired."
	important_info = "You are not an Antagonist, and been granted a vessel and a small shuttle. \
	The goal of your job scavenge wrecks; and repair ships, that you can later sell or use for yourself. \
	Your company have been granted legal rights by the Hadii's Folly governement to scavenge in the system."

	instantiator = /datum/ghostrole_instantiator/human/player_static/scavenger

/datum/role/ghostrole/scavenger/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/role/ghostrole/scavenger/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> The small Guardian Salvage Company was just bought by the FTU after a previous job left the company bankrupt. \
	Even if you are one of the old guard, here from the start in 2656, or a new fellow recruited recently, this new deal is, even if the FTU can be weird and shady at times, \
	seen with hope. You have received legal right to salvage in Hadii's Folly space. Its dangerous, but its honnest work. </i>")

/datum/ghostrole_instantiator/human/player_static/scavenger
	equip_loadout = TRUE //Hey, its a job.

/datum/ghostrole_instantiator/human/player_static/scavenger/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/scavenger

/obj/structure/ghost_role_spawner/scavenger
	name = "Worker's Sleeper"
	desc = "Wake the fuck up scavenger, you have a welder to burn."
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "sleeper"
	anchored = TRUE
	role_type = /datum/role/ghostrole/scavenger
	role_spawns = 1
