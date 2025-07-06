/datum/role/ghostrole/sdf
	name = "System defense Force Soldier"
	assigned_role = "SDF Soldier"
	desc = "You are a Soldier of the haddi's folley SDF."
	spawntext = "You are a soldier tasked to protect haddi's folley sector, posted on the Outpost 12, with the SDF corvette 'Interrupted-The-Speech'. Hunt Pirates, kill xenos, protect the sector. Make sure to read your SOP !"

	important_info = "Read, the SOP ! You are not antags and you have no authority on NT stations."

	instantiator = /datum/ghostrole_instantiator/human/player_static/sdf

/datum/role/ghostrole/sdf/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/role/ghostrole/sdf/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> ATTENTION : STANDING ORDERS SOLDIER ! MAKE SURE THE SECTOR IS SAFE ! YOU MAY USE THE INTERRUPTED-THE-SPEECH TO PATROL THE SECTOR ! MAKE SURE YOU RESPECT THE SOP ! AND FOR GOD SAKE, DONT MESS WITH CORPORATIONS AFFAIRS !</i>")

/datum/ghostrole_instantiator/human/player_static/sdf
	equip_loadout = TRUE

/datum/ghostrole_instantiator/human/player_static/sdf/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/sdf

/obj/structure/ghost_role_spawner/sdf
	name = "SDF Long-range Teleporter"
	desc = "A teleporter made to link the ship with Miaphus."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad_active"
	anchored = TRUE
	role_type = /datum/role/ghostrole/sdf
	role_spawns = 4

