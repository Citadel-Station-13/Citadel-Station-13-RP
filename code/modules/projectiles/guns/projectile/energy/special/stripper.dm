/datum/firemode/energy/stripper
	name = "strip"
	projectile_type = /obj/projectile/beam/stripper
	charge_cost = 240

/obj/item/gun/projectile/energy/stripper//Because it can be fun
	name = "stripper gun"
	desc = "A gun designed to remove unnessary layers from people. For external use only!"
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "sizegun-shrink100" // Someone can probably do better. -Ace
	item_state = null	//so the human update icon uses the icon_state instead
	fire_sound = 'sound/weapons/wave.ogg'
	regex_this_firemodes = list(/datum/firemode/energy/stripper)
	origin_tech = list(TECH_BLUESPACE = 4)
	modifystate = "sizegun-shrink"
	no_pin_required = 1
	battery_lock = 1
