/datum/role/ghostrole/occulum
	name = "Occulum operator"
	assigned_role = "Occulum operator"
	desc = "You are a employee of the Occulum News Network."
	spawntext = "You are a employee of the Occulum News Network. You can work as a radio host, a normal reporter, a sponsor, a technician, a spy, a journalist... You have been trusted and authorised to start what ever project you like !"

	important_info = "This is not an antag role though minor acts of mischief such as petty theft, and corporate spying are allowed."

	instantiator = /datum/ghostrole_instantiator/human/player_static/occulum

/datum/role/ghostrole/occulum/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/role/ghostrole/occulum/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> Welcome on the Skyplanet, Lythios 43a. Occulum always had a small presence here. Now that the blockade is lifted, personal can now be send in this small safehouse. You have a ship available, the ORS (Occulum Radio Shuttle) Crescend, if your coworkers didn't move it. (If they did, feel free to take a voidline racing shuttle). </i>")

/datum/ghostrole_instantiator/human/player_static/occulum
	equip_loadout = TRUE

/datum/ghostrole_instantiator/human/player_static/occulum/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/occulum

/obj/structure/ghost_role_spawner/occulum
	name = "Operator's teleporter"
	desc = "Arrived from here."
	role_type = /datum/role/ghostrole/occulum
	role_spawns = 2
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad_idle"

//occulum CRYO
/obj/machinery/cryopod/robot/door/travel/occulum
	name = "Occulum Teleporter"
	desc = "A teleporter towards the nearest HQ."
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

/obj/machinery/computer/cryopod/travel/occulum
	name = "docking oversight console"
	desc = "An interface between workers and the docking oversight systems tasked with keeping track of all operators who enter or exit from the docks."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "Oculum Travel Oversight"
	allow_items = TRUE

/obj/machinery/telecomms/allinone/occulum
	name = "Oculum Radio Servers"
	freq_listening = list(FREQ_COMMON, FREQ_ENTERTAINMENT)
