/datum/firemode/energy/darkmatter
	name = "normal darkmatter"
	fire_delay = 4
	projectile_type = /obj/item/projectile/energy/darkmatter
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(8)

/datum/firemode/energy/darkmatter/stun
	projectile_type = /obj/item/projectile/beam/stun/darkmatter
	e_cost = SCALE_ENERGY_WEPAON_NORMAL(8)
	name = "stunning"

/datum/firemode/energy/darkmatter/beam
	projectile_type = /obj/item/projectile/beam/darkmatter
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(6)
	name = "focused beam"

/datum/firemode/energy/darkmatter/burst
	spread = 15
	burst = 8
	name = "burst barrage"
