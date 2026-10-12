/datum/prototype/role/ghostrole/maquis
	name = "Dryas maquisard"
	assigned_role = "Dryas maquisard"
	desc = "You are a maquisard in the Dryas maquis."
	spawntext = "You are a maquisard in the Dryas maquis, a splinter group of the Roselin colony fleet that wish for the instauration of a true democratie alligned with Oricon, proper planetary colonisation, and the loss of power of the militia and council of captains. By all means necesary, even piracy."

	important_info = "You are a semi-Antagonist. Smuggle, do piracy, attack militia controled area... But avoid direct confrontation with NT, they can sell us gear for our cause."

	instantiator = /datum/ghostrole_instantiator/human/player_static/maquis

/datum/prototype/role/ghostrole/maquis/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/prototype/role/ghostrole/maquis/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> ATTENTION : The admiral orders simple, we are to focus on fleet defense, hunt pirates, protect colonist and travelers... Altho, we do not have the Adamant, unless there is a issue, we still have the Albatross !</i>")

/datum/ghostrole_instantiator/human/player_static/maquis
	equip_loadout = TRUE

/datum/ghostrole_instantiator/human/player_static/maquis/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/maquisard

/obj/structure/ghost_role_spawner/maquis
	name = "Regular guy bed"
	desc = "Here sleeps the grunts."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = TRUE
	role_type = /datum/prototype/role/ghostrole/maquis
	role_spawns = 1
	density = 0

//maquis CRYO
/obj/machinery/cryopod/robot/door/travel/maquis
	name = "Maquis Teleporter"
	desc = "A teleporter towards a maquis safehouse."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad_idle"
	announce_channel = "Trade"
	base_icon_state = "pad"
	occupied_icon_state = "pad_active"
	on_store_message = "has departed from the ship."
	on_store_name = "Maquis Travel Oversight"
	on_enter_occupant_message = "The gateway activates, and you step into the swirling portal."
	on_store_visible_message_1 = "'s portal disappears just after"
	on_store_visible_message_2 = "finishes walking across it."

/obj/machinery/computer/cryopod/travel/maquis
	name = "docking oversight console"
	desc = "An interface between soldiers and the docking oversight systems tasked with keeping track of all soldiers who enter or exit from the docks."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "Militia Travel Oversight"
	allow_items = TRUE

/obj/machinery/telecomms/allinone/maquis
	freq_listening = list(FREQ_COMMON, FREQ_MAQUIS)

