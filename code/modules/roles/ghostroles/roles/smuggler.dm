/datum/prototype/role/ghostrole/smuggler
	name = "Smuggler"
	assigned_role = "smuggler"
	desc = "You are a Vacuum Crucis Expanse smuggler."
	spawntext = "In deep space, goods are valuable. Especially illgal goods. Weapons, drugs, contraband... Your goal is too transport those goods and make money out of it. Evade NT security, pirates, and become rich."

	important_info = "Read, the SOP ! You are not antags, and can't attack NT station. However, you can defend yourself."

	instantiator = /datum/ghostrole_instantiator/human/player_static/smuggler

/datum/prototype/role/ghostrole/smuggler/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/prototype/role/ghostrole/smuggler/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> Time to Smuggle goods ! Gear, up, get in a ship, and go ahead. Carerfull, NT exploration and security has been recruited by fleet-sec to counter smuggling !</i>")

/datum/ghostrole_instantiator/human/player_static/smuggler
	equip_loadout = TRUE

/datum/ghostrole_instantiator/human/player_static/smuggler/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/smuggler

/obj/structure/ghost_role_spawner/smuggler
	name = "smuggler Long-range Teleporter"
	desc = "A teleporter made to link with the fleet."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad_active"
	anchored = TRUE
	role_type = /datum/prototype/role/ghostrole/smuggler
	role_spawns = 4

//smuggler CRYO
/obj/machinery/cryopod/robot/door/travel/smuggler
	name = "smuggler cryo"
	desc = "A teleporter towards outpost 01."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	announce_channel = "Trade"
	on_store_message = "went into cryosleep."
	on_store_name = "Smuggler cryo storage"

/obj/machinery/computer/cryopod/travel/smuggler
	name = "docking oversight console"
	desc = "An interface between soldiers and the docking oversight systems tasked with keeping track of all smugglers who enter or exit cryo."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "smuggler Travel Oversight"
	allow_items = TRUE

/obj/machinery/telecomms/allinone/smuggler
	freq_listening = list(FREQ_COMMON)
