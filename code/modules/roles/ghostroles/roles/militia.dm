/datum/prototype/role/ghostrole/militia
	name = "Roselin Fleet Militian"
	assigned_role = "Roselin Fleet Militian"
	desc = "You are a militian of the Roselin Fleet."
	spawntext = "You are a soldier tasked to protect the fleet. Hunt Pirates, fine smugglers, protect the sector. Make sure to read your SOP !"

	important_info = "Read, the SOP ! You are not antags and you have no authority on NT ships."

	instantiator = /datum/ghostrole_instantiator/human/player_static/militia

/datum/prototype/role/ghostrole/militia/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/prototype/role/ghostrole/militia/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> ATTENTION : The admiral orders simple, we are to focus on fleet defense, hunt pirates, protect colonist and travelers.</i>")

/datum/ghostrole_instantiator/human/player_static/militia
	equip_loadout = TRUE

/datum/ghostrole_instantiator/human/player_static/militia/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/militia


/obj/structure/ghost_role_spawner/militia
	name = "Regular guy bed"
	desc = "Here sleeps the grunts."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = TRUE
	role_type = /datum/prototype/role/ghostrole/militia
	role_spawns = 1
	density = 0

//militia CRYO
/obj/machinery/cryopod/robot/door/travel/militia
	name = "Militia Teleporter"
	desc = "A teleporter towards outpost 01."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad_idle"
	announce_channel = "Trade"
	base_icon_state = "pad"
	occupied_icon_state = "pad_active"
	on_store_message = "has departed from the ship."
	on_store_name = "SDF Travel Oversight"
	on_enter_occupant_message = "The gateway activates, and you step into the swirling portal."
	on_store_visible_message_1 = "'s portal disappears just after"
	on_store_visible_message_2 = "finishes walking across it."

/obj/machinery/computer/cryopod/travel/militia
	name = "docking oversight console"
	desc = "An interface between soldiers and the docking oversight systems tasked with keeping track of all soldiers who enter or exit from the docks."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "Militia Travel Oversight"
	allow_items = TRUE

/obj/machinery/telecomms/allinone/militia
	freq_listening = list(FREQ_COMMON, FREQ_MILITIA)
