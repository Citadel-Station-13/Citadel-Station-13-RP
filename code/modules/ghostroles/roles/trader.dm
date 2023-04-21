/datum/role/ghostrole/trader
	name = "Trader"
	assigned_role = "Trader"
	desc = "You are a merchant, eager to sell your wares and acquire monetary compensation."
	spawntext = "On the Frontier there are many avenues by which one can make their fortune. Traders usually sign up with the ITV, or any number of chain corporations like Nebula Gas. Often at risk of piracy, Traders are usually savvy behind a register or a shuttle console."
	important_info = "As an employee of Nebula Gas, you honor your Manager and Intergalactic Law. You have the right to refuse service, and price objects according to your discretion. Nebula Gas maintains neutral relations with NanoTrasen, but it is a good idea to avoid engaging in open hostility with the Corporation. If you find yourself in a dispute with NanoTrasen employees, do your best not to initiate hostilities, but do not simply capitulate to their demands."
	instantiator = /datum/ghostrole_instantiator/human/player_static/trader

/datum/role/ghostrole/trader/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/flavour_text = "<i>The hissing of the cryopod rouses you from your sleep. A cheerful jingle helps to draw you to wakefulness as heated \
	air rushes into the cabin. Dim lighting activates around the room to protect your eyes from overexposure. It's time for your shift on board \
	this Nebula Gas trade outpost. How you spend your waking hours is entirely up to you - just remember that your baseline paycheck only covers \
	necessities and baseline amenities. If you want to get your cut of the daily profits, you need to secure some sales.</i>"
	to_chat(created, flavour_text)

/datum/ghostrole_instantiator/human/player_static/trader
	equip_loadout = TRUE
	equip_traits = TRUE

/datum/ghostrole_instantiator/human/player_static/trader/GetOutfit(client/C, mob/M, list/params)
	M.faction = "trader"
	//var/datum/outfit/outfit = ..()
	return /datum/outfit/trader

/obj/structure/ghost_role_spawner/trader
	name = "merchant cryopod"
	desc = "A luxury sleeper designed to put its occupant into a deep, restful sleep. It can only be opened from the inside, or by automated systems."
	icon = 'icons/obj/medical/cryogenic2.dmi'
	icon_state = "sleeper_0"
	anchored = TRUE
	density = TRUE
	role_type = /datum/role/ghostrole/trader
	role_spawns = 1
