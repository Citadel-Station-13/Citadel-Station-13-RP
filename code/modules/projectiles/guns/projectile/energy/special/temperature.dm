/datum/firemode/energy/temperature
	abstract_type = /datum/firemode/energy/temperature
	charge_cost = 240

/datum/firemode/energy/temperature/cold
	name = "endothermic"
	projectile_type = /obj/projectile/temp

/datum/firemode/energy/temperature/hot
	name = "exothermic"
	projectile_type = /obj/projectile/temp/hot

/obj/item/gun/projectile/energy/temperature
	name = "temperature gun"
	icon = 'icons/modules/projectiles/guns/energy/temperature.dmi'
	icon_state = "temp"
	render_ammo_system = GUN_RENDERING_OVERLAYS
	render_ammo_count = 4
	render_ammo_empty = TRUE
	render_ammo_inhand = TRUE
	desc = "A gun that can add or remove heat from entities it hits.  In other words, it can fire 'cold', and 'hot' beams."
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	slot_flags = SLOT_BELT|SLOT_BACK
	no_pin_required = TRUE
	projectile_type = /obj/projectile/temp
	regex_this_firemodes = list(
		/datum/firemode/energy/temperature/cold,
		/datum/firemode/energy/temperature/hot,
	)
	one_handed_penalty = 15

