/datum/prototype/role/ghostrole/sdf
	name = "System defense Force Soldier"
	assigned_role = "SDF Soldier"
	desc = "You are a Soldier of the haddi's folley SDF."
	spawntext = "You are a soldier tasked to protect haddi's folley sector, posted on the Outpost 12, with the SDF corvette 'Interrupted-The-Speech'. Hunt Pirates, kill xenos, protect the sector. Make sure to read your SOP !"

	important_info = "Read, the SOP ! You are not antags and you have no authority on NT stations."

	instantiator = /datum/ghostrole_instantiator/human/player_static/sdf

/datum/prototype/role/ghostrole/sdf/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/prototype/role/ghostrole/sdf/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
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
	role_type = /datum/prototype/role/ghostrole/sdf
	role_spawns = 3

//SDF CRYO
/obj/machinery/cryopod/robot/door/travel/sdf
	name = "SDF Teleporter"
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

/obj/machinery/computer/cryopod/travel/sdf
	name = "docking oversight console"
	desc = "An interface between soldiers and the docking oversight systems tasked with keeping track of all soldiers who enter or exit from the docks."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "SDF Travel Oversight"
	allow_items = TRUE

/obj/machinery/telecomms/allinone/sdf
	freq_listening = list(FREQ_COMMON, FREQ_SDF)
