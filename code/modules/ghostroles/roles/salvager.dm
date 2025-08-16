/datum/role/ghostrole/salvager
	name = "Guardian Company Salvager"
	assigned_role = "Guardian Company Salvager"
	desc = "You are a worker of the Guardian Company. You find ships, repair them, then sell them. You can also try and collect good to then sell them, or transport them between A and B. A bit less known, but you secretly smuggle contraband."
	spawntext = "You are a worker of the Guardian Company. You find ships, repair them, then sell them. You can also try and collect good to then sell them, or transport them between A and B. A bit less known, but you secretly smuggle contraband."

	important_info = "The Guardian Company Salvager is a small company. It is a small fleet of 4 shuttles deployed arround a small mothership. Created in 2558 Once part of the FTU, it broke off from the union after a loss of profit during the mid 2560's. Struggling to survive, the company somewhat managed to stay on float. They fix ship, collect the most precious ellements, then sell them. While this is their main objectif, the truth is that they often smuggle legal and illegal goods. After the Osiris Debris field was opened; your shuttle, the GCSS Vevalia, was deployed in the system."

	instantiator = /datum/ghostrole_instantiator/human/player_static/salvager

/datum/role/ghostrole/salvager/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/role/ghostrole/salvager/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> Welcome on the Skyplanet, Lythios 43a. Occulum always had a small presence here. Now that the blockade is lifted, personal can now be send in this small safehouse. You have a ship available, the ORS (Occulum Radio Shuttle) Silaes, if your coworkers didn't move it. (If they did, feel free to take a voidline racing shuttle). </i>")

/datum/ghostrole_instantiator/human/player_static/salvager
	equip_loadout = TRUE

/datum/ghostrole_instantiator/human/player_static/salvager/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/salvager

/obj/structure/ghost_role_spawner/salvager
	name = "Salvager's bed"
	desc = "You woke up here."
	role_type = /datum/role/ghostrole/salvager
	role_spawns = 1
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	pressure_resistance = 15
	surgery_odds = 70 // better than nothing
	anchored = TRUE
	buckle_allowed = TRUE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW
	buckle_dir = SOUTH
	buckle_lying = 90

//salvager CRYO
/obj/machinery/cryopod/robot/door/travel/salvager
	name = "Teleporter to mothership GCV Regalia"
	desc = "A teleporter towards the mothership."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad_idle"
	announce_channel = "Trade"
	base_icon_state = "pad"
	occupied_icon_state = "pad_active"
	on_store_message = "has departed and his heading back to the nearest Occulum HQ."
	on_store_name = "Oculum Travel Oversight"
	on_enter_occupant_message = "The gateway activates, and you step into the swirling portal."
	on_store_visible_message_1 = "'s portal disappears just after"
	on_store_visible_message_2 = "finishes walking across it."

/obj/machinery/computer/cryopod/travel/salvager
	name = "docking oversight console"
	desc = "An interface between worker and the docking oversight systems tasked with keeping track of all operators who enter or exit from the docks."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "GCV Regalia Travel Oversight"
	allow_items = TRUE
