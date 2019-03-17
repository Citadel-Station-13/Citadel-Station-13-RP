/datum/firemode/energy/stun/taser
	name = "stun"
	projectile_type = /obj/item/projectile/beam/stun
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(15)
	mode_icon_state = "stun"

/datum/firemode/energy/stun/stunrevolver
	name = "stun"
	projectile_type = /obj/item/projectile/energy/electrode/stun
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(6)

/datum/firemode/energy/disable
	name = "disable"
	projectile_type = /obj/item/projectile/beam/disable
	mode_icon_state = "disable"
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(24)
